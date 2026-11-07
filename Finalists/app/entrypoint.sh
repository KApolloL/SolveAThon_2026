#!/bin/sh
# MODE=job: stub for the daily refresh (prints one line, exits 0).
# Otherwise: serve the Shiny app directly (no shiny-server), so env vars reach R.
if [ "${MODE:-app}" = "job" ]; then
  echo "MODE=job: refresh stub ran at $(date -u '+%Y-%m-%d %H:%M:%S') UTC"
  exit 0
fi
cd /srv/app
exec R -q -e 'shiny::runApp("/srv/app", host = "0.0.0.0", port = 3838)'
