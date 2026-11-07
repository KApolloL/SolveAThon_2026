# 10_run_ranking.R: open opportunities x active agencies -> filter, score, rank, explain,
# one ranking per agency. Writes data/processed/items.csv (one row per agency x opportunity),
# ranking.csv (ranked rows, per-agency ranks) and outs/top_results.csv (top N per agency).
# 11_build_payload.R turns these into payload.json; 12_backtest.R ranks closed items.
# Run: Rscript R/10_run_ranking.R

here::i_am("src/R/10_run_ranking.R")
source(here::here("src", "R", "00_config.R"))
source(here::here("src", "R", "helpers_io.R"))
source(here::here("src", "R", "helpers_rank.R"))
source(here::here("src", "R", "score.R"))

stop_if_toy(CRITERIA_FILE)
cr <- read_criteria()
inp <- load_rank_inputs()
opps <- inp$opps[inp$opps$status %in% OPEN_STATUSES, ]

items <- build_items(opps, inp$ag, inp$plans)
dir.create(DIR_PROCESSED, showWarnings = FALSE, recursive = TRUE)
write_csv(items, file.path(DIR_PROCESSED, "items.csv"), na = "")

# An opportunity is compared with others for the same agency only.
rk <- rank_by_agency(items, cr)
message(length(unique(items$agency_id)), " agencies; ", nrow(items), " pairs; ", nrow(rk$dropped),
        " dropped by filters; ", nrow(rk$ranked), " ranked")

write_csv(rk$ranked, RANKING_CSV, na = "")
dir.create(DIR_OUTS, showWarnings = FALSE, recursive = TRUE)
top <- rk$ranked[rk$ranked$rank <= TOP_N, c("agency_id", "rank", "id", "name", "total", "why")]
top <- left_join(top, items[, c("id", "opp_number", "close_date", "date_note", "award_ceiling", "goal_snippet")], by = "id")
write_csv(top, file.path(DIR_OUTS, "top_results.csv"), na = "")
message("Wrote items.csv, ranking.csv, top_results.csv")
