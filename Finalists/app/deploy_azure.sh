#!/bin/sh
# deploy_azure.sh: the exact Azure steps to ship the full tool, written so a human can read and run them.
# DRY RUN BY DEFAULT: it prints each command and runs nothing against Azure. To run for real, a person sets
# DEPLOY=yes and answers each prompt. Nobody has run this file yet (written Sat Nov 7 by Kent's Claude).
#
#   sh app/deploy_azure.sh                  # prints the plan only
#   DEPLOY=yes sh app/deploy_azure.sh       # asks before every step
#
# Names come from src/docs/azure_setup.md (all exist already). No key, SAS or token is written here:
# BLOB_WRITE_SAS, if used, is read from the caller's environment and passed straight to az.
# Run from the Finalists/ folder. Needs: az login (Duo), the containerapp extension.
set -eu

RG=rg-primary-unc-sdis-solveathon-team15
ACR=ffmacrteam15
ENVNAME=ffm-env
APP=ffm-app
JOB=ffm-daily-refresh
STORAGE=ffmdatateam15
CONTAINER=ffm-data
TAG="${TAG:-v3}"
IMAGE="$ACR.azurecr.io/ffm-app:$TAG"
CRON="${JOB_CRON:-0 11 * * *}"   # 11:00 UTC daily (6:00 am Eastern in winter); change if the team wants another time

run() {
  # run <description> <command...>: print, and only with DEPLOY=yes ask and execute.
  desc="$1"; shift
  echo
  echo "== $desc"
  echo "   $*"
  if [ "${DEPLOY:-no}" != "yes" ]; then echo "   (dry run: not executed)"; return 0; fi
  printf "   Run this step? [y/N] "
  read -r ans
  [ "$ans" = "y" ] || { echo "   skipped"; return 0; }
  "$@"
}

[ -f src/tool/matchmaker.html ] || { echo "Run from the Finalists/ folder."; exit 1; }

# Local only, safe: copies the tool page and data into app/ and checks no key value is present.
run "1. Stage app assets and secret check (local)" sh app/stage_proof_assets.sh

run "2. Validate payload.json before shipping (local)" \
  python3 -c "import json,sys;p=json.load(open('data/processed/payload.json'));assert p['agencies'] and p['rows'] and p.get('goals');print('payload ok',len(p['rows']),'rows')"

run "3. Build the image in the registry (about 1.5 minutes, about \$0.02)" \
  az acr build -r "$ACR" -t "ffm-app:$TAG" ./app --no-logs

run "4. Upload payload.json to Blob (login auth, key never printed)" \
  az storage blob upload --account-name "$STORAGE" --container-name "$CONTAINER" --name payload.json \
    --file data/processed/payload.json --auth-mode login --overwrite

run "5. Point the Container App at the new image (min replicas stay as they are)" \
  az containerapp update -n "$APP" -g "$RG" --image "$IMAGE"

# The daily job. JOB_DRY_RUN=1 means it checks and stamps but writes nothing until a write SAS or the Contributor role exists.
run "6. Create the daily refresh job (dry-run mode on; cron $CRON)" \
  az containerapp job create -n "$JOB" -g "$RG" --environment "$ENVNAME" \
    --trigger-type Schedule --cron-expression "$CRON" --replica-timeout 900 --replica-retry-limit 0 \
    --image "$IMAGE" --cpu 0.5 --memory 1.0Gi \
    --registry-server "$ACR.azurecr.io" --registry-identity system \
    --env-vars MODE=job JOB_DRY_RUN=1

run "7. Trigger the job once by hand, then read its log (to show the refresh works)" \
  az containerapp job start -n "$JOB" -g "$RG"

cat <<'EOF'

After a real run, by hand:
- Open the app URL and check the agency picker, the tiles and the match board on a phone.
- Switch the job to real writes only after a write SAS exists: set JOB_DRY_RUN=0 and BLOB_WRITE_SAS as a job secret.
- Min replicas: 1 before the talk (about $1.30 per day), back to 0 after. Stop and tell Kent at $50 added.
- Record spend and any failure in src/docs/azure_setup.md.
EOF
