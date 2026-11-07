# Azure setup: handoff and plan for Sat Nov 7

Written Fri Nov 6, 2026, late evening, by Marco with Claude Code. No keys, tokens or connection strings are in this file. Where a secret is needed, the placeholder is `$AOAI_KEY` etc.

## Rules that still apply
- **Spending limit: $500** for the team subscription (told to us by the organizers). Stay on the cheapest tiers; see "Cost guard".
- Ask before every `az ... create`, delete, role assignment or install. One command at a time. On an error: show the exact command and error, propose one fix, no blind retries.
- Never print or write a key. Read it into a shell variable from `az` and use it in the same command.
- Work only on the branch `marco_testing`. No commits to `main`. Commit only when Marco says so; push only to `origin/marco_testing`, then open a PR for Kent. Before each work block: `git fetch origin`, then `git merge --ff-only origin/main`.
- AI use for Friday is logged in `Finalists/AI_USAGE_LOG.md`; add a row for each new block of work.

## State at end of Friday
Signed in as `gullotto@AD.UNC.EDU` (CLI 2.92.0, installed with Homebrew; `containerapp` extension installed, preview). Default subscription: `unc-sdis-solveathon-team15`.

| What | Name | State |
|---|---|---|
| Region | East US (`eastus`) | chosen; both models available there as Standard SKU (`gpt-4o-mini` 2024-07-18, `text-embedding-3-small` v1) |
| Resource group | `rg-primary-unc-sdis-solveathon-team15` | existed already; we reuse it |
| Resource providers | App, OperationalInsights, ContainerRegistry, CognitiveServices, Storage | registered Friday |
| Storage account | `ffmdatateam15` (StorageV2, LRS, no public blob access, TLS 1.2) | created |
| Blob container | `ffm-data` (created with `--auth-mode login`) | created |
| Log Analytics workspace | `ffm-logs` | created |
| Container Registry | `ffmacrteam15` (Basic) | created |
| Container Apps environment | `ffm-env` | created |
| Hello app | `Finalists/app/app.R`, `Finalists/app/Dockerfile` (`rocker/shiny:4.4.2`, port 3838, `MODE` env var, `MODE=job` is a stub that exits 0) | written, **not built, not committed** |
| Azure OpenAI resource | `ffm-aoai-team15` | **not created** (Marco had not answered; no Azure OpenAI exists in the subscription) |
| Container App | `ffm-app` | **not created** |
| Budget alerts ($250, $400) | | **not created**; Claude offered, Marco did not answer |

Nothing has been tested yet. No URL exists yet.

## Plan for Saturday (in order)

### 0. Start of session (5 min)
1. `git fetch origin`; confirm branch is `marco_testing`; `git merge --ff-only origin/main`.
2. `az account show` (expect `unc-sdis-solveathon-team15`). If the token expired, Marco runs `az login` and approves Duo himself.
3. Read `planning/07_discovery_findings.md` and the latest `handoff.md` for anything Kent decided overnight (which agency, R versus Python, whether Azure OpenAI is ours). If Kent chose Python or Streamlit, stop and redo step 5 with that stack.

### 1. Decide first (ask Kent or a mentor, 9:00 check-in)
- Is Azure OpenAI ours to create, or do the organizers provide an endpoint? (Starter Kit says skip its Step 3 if provided.)
- Does R Shiny on Container Apps hold, or do we switch to Python?
These two answers decide steps 2 and 5. Do not guess.

### 2. Azure OpenAI (ask before creating)
- Check the `Microsoft.CognitiveServices` provider is `Registered`.
- Create `ffm-aoai-team15` (kind `OpenAI`, SKU `S0`, East US), then two deployments: `text-embedding-3-small` and `gpt-4o-mini`, Standard SKU, **small capacity** (for example 10 to 30 on the chat model) to cap cost.
- If creation is refused (quota, policy, access needing approval): record the exact error in this file, tell Kent, and fall back to keyword/TF-IDF scoring as the Starter Kit allows. Do not spend time fighting it.
- Check Azure's data-handling documentation before anyone claims "prompts are not used for training". Mark it [uncertain] until read.

### 3. Test the two calls (no key in output)
- Read endpoint and key into shell variables from `az cognitiveservices account ...`; run one embedding call and one chat call with `curl`; print only the HTTP status and token counts.
- Done when both return 200.

### 4. Build the image in the cloud
- `az acr build -r ffmacrteam15 -t ffm-app:v1 ./app` (no local Docker needed).
- If the build is slow or fails, record the exact error and tell Kent at once; this is the signal that R on Container Apps may be a problem.

### 5. Deploy the Container App
- Create `ffm-app` in `ffm-env`: external ingress, target port 3838, env var `MODE=app`, **min replicas 0 or 1 and max 1**, smallest CPU/memory (0.5 vCPU, 1 Gi). Pull from the registry using a managed identity or `--registry-identity`, not an admin password in a file.
- `curl -I https://<fqdn>` returns 200 and the page shows "MODE = app". Test once on the phone hotspot too (the demo must work on venue Wi-Fi and a hotspot).
- Note: a scale-to-zero app has a cold start of some seconds. Before the demo, set min replicas to 1 or warm it up.

### 6. Storage access for the app (only if time)
- Give the app a managed identity with `Storage Blob Data Contributor` on `ffmdatateam15` (role assignment: ask first). Agree the blob layout with Everett and Kent: `profiles/{agency}.json`, `raw/{yyyy-mm-dd}/grants.json`, `opportunities/latest.json`, `scored/{agency}/latest.json`, `decisions/{agency}.json`, `eval/labels.json`, `runs/{timestamp}.json`.

### 7. Cost guard
- Ask Marco about budget alerts at $250 and $400 (Cost Management budget). If his account cannot create one, note it here and check Cost analysis by hand at lunch and at 6:00 pm.
- Keep LLM calls to the top N results only (Starter Kit pitfall: calling the LLM for every item).
- Biggest runaway risks: a loop calling the model, an app with min replicas above 1, a large Log Analytics ingestion. Before leaving for the night, check cost and scale.

### 8. Close out
- Write the results into this file: the real URL, region, resource names, exact `az` commands (secrets as `$AOAI_KEY`), test results, failures and fixes.
- Add new rows to `AI_USAGE_LOG.md` (Friday's row exists): Claude Code (Sonnet 5.5) used for Azure CLI setup and file writing; human checks: Marco signed in and approved each create, read the resource list in the portal.
- Optionally update the Azure row in `handoff.md` (ask Kent first; it is his file).
- Post to the team: public URL, region, resource names, anything that failed. Commit on `marco_testing` only when Marco says so, then PR for Kent.

## Things I could not verify
- The `$500` limit comes from Marco's report; the cost figures in chat (ACR Basic about $5/month, scale-to-zero free when idle) are estimates, not read from Azure pricing.
- Whether Marco's account can create budgets and role assignments.
- Whether the `rocker/shiny:4.4.2` tag builds cleanly in ACR (not yet tried).
- Plan years, text extractability and which agency we serve are open on the data side; they do not block Azure.

## Rollback if anything goes wrong
Delete only resources we created (all names above, in `rg-primary-unc-sdis-solveathon-team15`). Do not delete the resource group, `rg-networking`, `NetworkWatcherRG` or `rg-serviceHealthAlert`. Ask Marco before each delete.
