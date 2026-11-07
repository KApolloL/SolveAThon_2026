#!/bin/sh
# MODE=job: daily refresh (job.R checks, stamps and ships payload.json; dry run unless JOB_DRY_RUN=0).
# Otherwise: serve the Shiny app directly (no shiny-server), so env vars reach R.
if [ "${MODE:-app}" = "job" ]; then
  cd /srv/app
  exec Rscript job.R
fi
cd /srv/app
exec R -q -e 'shiny::runApp("/srv/app", host = "0.0.0.0", port = 3838)'
