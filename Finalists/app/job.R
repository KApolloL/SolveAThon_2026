# job.R: MODE=job. Daily refresh step: take a scored payload.json, check its shape against
# saturday/03_contract.md, stamp "data as of", and upload it to Blob. No model calls here.
# The scoring itself is Kent's pipeline (src/R/10_run_ranking.R); this wrapper only runs it
# if it is in the image (PIPELINE_SCRIPT) and ships the result.
#
# Settings (env vars; TODO move to 00_config.R, listed in Marco's handoff):
#   JOB_DRY_RUN=1     check and stamp only; write nothing to Blob (default 1 until write access exists)
#   PAYLOAD_IN        path of the payload to ship          (default data/processed/payload.json)
#   PIPELINE_SCRIPT   optional Rscript to run first        (default none)
#   BLOB_WRITE_SAS    write SAS for the one blob; else managed identity (needs Storage Blob Data Contributor)
suppressPackageStartupMessages(library(jsonlite))

env <- function(k, d = "") { v <- Sys.getenv(k, ""); if (nzchar(v)) v else d }
dry <- env("JOB_DRY_RUN", "1") != "0"
inp <- env("PAYLOAD_IN", "data/processed/payload.json")
blob <- "https://ffmdatateam15.blob.core.windows.net/ffm-data/payload.json"
now <- format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
msg <- function(...) cat(format(Sys.time(), "%H:%M:%S"), "job:", ..., "\n")

ps <- env("PIPELINE_SCRIPT")
if (nzchar(ps)) {
  msg("running", ps)
  st <- system2("Rscript", ps)
  if (st != 0) { msg("pipeline failed, status", st, "; leaving the Blob file as it is"); quit(status = 1) }
}

if (!file.exists(inp)) { msg("no payload at", inp, "; nothing to ship"); quit(status = 1) }
p <- fromJSON(inp, simplifyVector = FALSE)

# Shape check from the contract. A bad file must never replace a good one in Blob.
need_top <- c("data_as_of", "window_days", "agencies", "rows")
need_row <- c("agency_id", "opp_id", "title", "status", "days_left", "rank", "in_top10",
              "eligibility", "url")
problems <- character()
miss <- setdiff(need_top, names(p)); if (length(miss)) problems <- c(problems, paste("missing top-level:", paste(miss, collapse = ", ")))
if (!length(p$agencies)) problems <- c(problems, "no agencies")
if (length(p$rows)) {
  bad <- Filter(function(r) length(setdiff(need_row, names(r))) > 0, p$rows)
  if (length(bad)) problems <- c(problems, paste(length(bad), "rows miss required keys"))
  ids <- vapply(p$agencies, function(a) a$agency_id, "")
  stray <- Filter(function(r) !(r$agency_id %in% ids), p$rows)
  if (length(stray)) problems <- c(problems, paste(length(stray), "rows have an unknown agency_id"))
  okst <- vapply(p$rows, function(r) r$status %in% c("posted", "forecasted", "notice"), TRUE)
  if (!all(okst)) problems <- c(problems, "a row has an unknown status")
} else problems <- c(problems, "no rows")
if (length(problems)) { msg("payload rejected:", paste(problems, collapse = "; ")); quit(status = 1) }

# Stamp. Never claim a pipeline ran when it did not: keep the file's own stamp too.
p$shipped_at <- now
if (is.null(p$pipeline_as_of)) p$pipeline_as_of <- p$data_as_of
out <- tempfile(fileext = ".json")
write_json(p, out, auto_unbox = TRUE, null = "null", na = "null", pretty = FALSE)
msg("payload ok:", length(p$agencies), "agencies,", length(p$rows), "rows, shipped_at", now)

if (dry) { msg("JOB_DRY_RUN is on: nothing written to Blob"); quit(status = 0) }

sas <- env("BLOB_WRITE_SAS")
hdr <- c("-H", shQuote("x-ms-blob-type: BlockBlob"), "-H", shQuote("Content-Type: application/json"),
         "-H", shQuote("x-ms-version: 2021-08-06"))
if (nzchar(sas)) {
  target <- paste0(blob, "?", sub("^\\?", "", sas))
} else {
  ep <- env("IDENTITY_ENDPOINT"); stopifnot(nzchar(ep))
  tk <- paste(system2("curl", c("-s", "-H", shQuote(paste0("X-IDENTITY-HEADER: ", env("IDENTITY_HEADER"))),
              shQuote(paste0(ep, "?api-version=2019-08-01&resource=https://storage.azure.com/"))), stdout = TRUE), collapse = "")
  tok <- sub('.*"access_token":"([^"]+)".*', "\\1", tk)
  hdr <- c(hdr, "-H", shQuote(paste0("Authorization: Bearer ", tok)))
  target <- blob
}
code <- system2("curl", c("-s", "-o", "/dev/null", "-w", "%{http_code}", "-X", "PUT", hdr,
                "--data-binary", shQuote(paste0("@", out)), shQuote(target)), stdout = TRUE)
msg("upload HTTP status", code)
quit(status = if (identical(code, "201")) 0 else 1)
