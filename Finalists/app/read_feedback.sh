#!/bin/sh
# read_feedback.sh: print feedback sent from the tool's "Give feedback" form (team only: needs az login to the team subscription).
# Recent lines come from the live container log; older ones from the Log Analytics workspace the app logs to.
#   sh app/read_feedback.sh            # last ~500 log lines of the running app
#   sh app/read_feedback.sh history    # everything in Log Analytics for the past 30 days
set -eu
RG=rg-primary-unc-sdis-solveathon-team15; APP=ffm-app; WS=32fe4ead-138c-41fe-b1e7-9559d53b1de1
if [ "${1:-}" = "history" ]; then
  az monitor log-analytics query -w "$WS" --analytics-query "ContainerAppConsoleLogs_CL | where TimeGenerated > ago(30d) | where Log_s has 'FEEDBACK ' | project TimeGenerated, Log_s | order by TimeGenerated desc" -o table
else
  az containerapp logs show -n "$APP" -g "$RG" --type console --tail 500 2>/dev/null | grep 'FEEDBACK ' || echo "No feedback in the recent log. Try: sh app/read_feedback.sh history"
fi
