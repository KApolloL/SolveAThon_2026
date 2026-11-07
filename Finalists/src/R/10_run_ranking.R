# 10_run_ranking.R: open opportunities x active agencies -> filter, score, rank, explain,
# one ranking per agency. Reads opportunities.csv, the agency map, the goal table and the
# full plan text; writes data/processed/items.csv (one row per agency x opportunity),
# ranking.csv (per-agency ranks) and outs/top_results.csv (top N per agency).
# payload.json in the contract shape is built by the payload step (not here).
# Run: Rscript R/10_run_ranking.R

here::i_am("src/R/10_run_ranking.R")
source(here::here("src", "R", "00_config.R"))
source(here::here("src", "R", "helpers_io.R"))
source(here::here("src", "R", "helpers_rank.R"))
source(here::here("src", "R", "score.R"))
suppressPackageStartupMessages(library(readr))

stop_if_toy(CRITERIA_FILE)
cr <- read_csv(CRITERIA_FILE, show_col_types = FALSE, col_types = cols(.default = col_character()))
cr$weight <- if ("weight" %in% names(cr)) suppressWarnings(as.numeric(cr$weight)) else NA_real_

chr <- cols(.default = col_character())
opps <- prep_opportunities(read_csv(OPPS_FILE, show_col_types = FALSE, col_types = chr), REF_DATE)
opps <- opps[opps$status %in% OPEN_STATUSES, ]
opps$award_ceiling <- as.numeric(opps$award_ceiling)
amap <- read_csv(AGENCY_MAP_FILE, show_col_types = FALSE, col_types = chr)
ag <- agency_goals(read_csv(GOALS_FILE, show_col_types = FALSE, col_types = chr), amap)
plans <- plan_texts(amap, file.path(DIR_PROCESSED, "agency_plan_text", "all"))

pairs <- build_pairs(opps, ag, plans)
items <- pairs |>
  dplyr::left_join(opps[, c("opp_id", "opp_number", "title", "status", "close_date", "date_note", "days_left",
                            "award_ceiling", "log_ceiling", "cost_sharing")], by = "opp_id") |>
  dplyr::mutate(id = paste(agency_id, opp_id, sep = ":"),
                eligibility = NA_character_)   # TODO step 3: applicant codes -> yes / no / check eligibility
dir.create(DIR_PROCESSED, showWarnings = FALSE, recursive = TRUE)
write_csv(items, file.path(DIR_PROCESSED, "items.csv"), na = "")

# Rank inside each agency: an opportunity is compared with others for the same agency only.
by_agency <- lapply(split(items, items$agency_id), function(it)
  rank_items(it, cr, REF_DATE, ID_COL, NAME_COL, top_n = Inf))
ranked <- dplyr::bind_rows(lapply(names(by_agency), function(a)
  dplyr::mutate(by_agency[[a]]$ranked, agency_id = a, .before = 1)))
dropped <- dplyr::bind_rows(lapply(names(by_agency), function(a)
  dplyr::mutate(by_agency[[a]]$dropped, agency_id = a, .before = 1)))
message(length(by_agency), " agencies; ", nrow(items), " pairs; ", nrow(dropped), " dropped by filters; ", nrow(ranked), " ranked")

write_csv(ranked, RANKING_CSV, na = "")
dir.create(DIR_OUTS, showWarnings = FALSE, recursive = TRUE)
top <- ranked[ranked$rank <= TOP_N, c("agency_id", "rank", "id", "name", "total", "why")]
top <- dplyr::left_join(top, items[, c("id", "opp_number", "close_date", "date_note", "award_ceiling", "goal_snippet")], by = "id")
write_csv(top, file.path(DIR_OUTS, "top_results.csv"), na = "")
message("Wrote items.csv, ranking.csv, top_results.csv")
