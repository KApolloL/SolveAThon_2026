# 10_run_ranking.R: items + criteria -> filter, score, rank, explain.
# Writes data/processed/ranking.csv and payload.json (the tool's data) and
# outs/top_results.csv / .xlsx. Everything that decides a result is in the criteria table.
# Run: Rscript R/10_run_ranking.R

here::i_am("src/R/10_run_ranking.R")
source(here::here("src", "R", "00_config.R"))
source(here::here("src", "R", "helpers_io.R"))
source(here::here("src", "R", "score.R"))
suppressPackageStartupMessages({ library(readr); library(jsonlite) })

items <- read_any(ITEMS_FILE)
cr <- read_csv(CRITERIA_FILE, show_col_types = FALSE, col_types = cols(.default = col_character()))
cr$weight <- if ("weight" %in% names(cr)) suppressWarnings(as.numeric(cr$weight)) else NA_real_

rk <- rank_items(items, cr, REF_DATE, ID_COL, NAME_COL, top_n = Inf)
message(nrow(items), " items; ", nrow(rk$dropped), " dropped by filters; ", nrow(rk$ranked), " ranked")

dir.create(DIR_PROCESSED, showWarnings = FALSE, recursive = TRUE)
dir.create(DIR_OUTS, showWarnings = FALSE, recursive = TRUE)
write_csv(rk$ranked, RANKING_CSV)

payload <- build_payload(items, cr, rk, ID_COL, NAME_COL, SHOW_FIELDS)
write_json(payload, PAYLOAD_JSON, auto_unbox = TRUE, null = "null", na = "null", digits = NA)

top <- head(rk$ranked[, c("rank", "id", "name", "total", "why")], TOP_N)
extra <- items[, SHOW_FIELDS]
extra$id <- as.character(items[[ID_COL]])
top <- dplyr::left_join(top, extra, by = "id")
write_csv(top, file.path(DIR_OUTS, "top_results.csv"))
openxlsx::write.xlsx(top, file.path(DIR_OUTS, "top_results.xlsx"))
message("Wrote ranking.csv, payload.json, top_results.csv/.xlsx")
