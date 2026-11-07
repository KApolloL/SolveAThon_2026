# 11_build_payload.R: items.csv + ranking.csv -> data/processed/payload.json (contract in
# saturday/03_contract.md). Run 10_run_ranking.R first.
#
# rows per agency, three groups:
#   Top 10   posted and notice items that pass the filters, best first: rank 1..TOP10_N, in_top10 TRUE
#   Coming up forecasted items that pass the filters: rank 1..COMING_UP_N within forecasts, in_top10 FALSE
#   Hidden   the HIDDEN_N best-fitting items the eligibility filter hides (eligibility "no", rank null),
#            so the tool can show its count and toggle. agencies[].n_hidden_ineligible is the full count
#            (an addition to the contract).
# map_note (additive field) says why a hand-mapped program was lifted; null otherwise.
# Unknown values are null, never 0. nc_won_before is shown only; it never enters fit or rank.
# Run: Rscript R/11_build_payload.R

here::i_am("src/R/11_build_payload.R")
source(here::here("src", "R", "00_config.R"))
source(here::here("src", "R", "helpers_rank.R"))
suppressPackageStartupMessages(library(jsonlite))

stop_if_toy(CRITERIA_FILE)
items_file <- file.path(DIR_PROCESSED, "items.csv")
if (!file.exists(items_file) || !file.exists(RANKING_CSV)) stop("Run R/10_run_ranking.R first.", call. = FALSE)
chr <- cols(.default = col_character())
items <- read_csv(items_file, show_col_types = FALSE, col_types = chr)
ranking <- read_csv(RANKING_CSV, show_col_types = FALSE, col_types = chr)
inp <- load_rank_inputs()
opps <- inp$opps; amap <- inp$amap

# ---- agencies -------------------------------------------------------------------------
active <- filter(amap, is.na(fold_into), is.na(drop_reason))
stopifnot(nrow(active) == 32, setequal(active$agency_id, unique(items$agency_id)))
stale <- read_csv(GOALS_FILE, show_col_types = FALSE, col_types = chr) |>
  group_by(plan_file) |> summarise(stale = any(plan_stale == "yes"), .groups = "drop")
n_hidden <- table(items$agency_id[items$eligibility == "no"])
agencies <- lapply(seq_len(nrow(active)), function(i) {
  a <- active[i, ]
  folded <- filter(amap, fold_into == a$agency_id)
  files <- c(a$plan_file, folded$plan_file)
  list(agency_id = a$agency_id, agency_name = a$agency_name, plan_files = I(files),
       plan_stale = any(stale$stale[stale$plan_file %in% files]),
       plan_thin = NA,                       # not measured yet
       folded_from = I(folded$agency_name),
       n_hidden_ineligible = as.integer(n_hidden[a$agency_id] %||% 0L))
})

# ---- rows -----------------------------------------------------------------------------
best_first <- function(d, col) d[order(-as.numeric(d[[col]]), d$opp_id, method = "radix"), ]
pick_rows <- function(a) {
  it <- items[items$agency_id == a, ]
  rk <- ranking[ranking$agency_id == a, ]
  rk$opp_id <- sub("^[^:]*:", "", rk$id)
  rk <- merge(rk, it[, c("id", "status")], by = "id")
  open <- best_first(rk[rk$status != "forecasted", ], "total") |> head(TOP10_N)
  soon <- best_first(rk[rk$status == "forecasted", ], "total") |> head(COMING_UP_N)
  hid <- best_first(it[it$eligibility == "no", ], "fit") |> head(HIDDEN_N)
  bind_rows(
    transmute(open, agency_id, opp_id, rank = seq_len(nrow(open)), in_top10 = TRUE),
    transmute(soon, agency_id, opp_id, rank = seq_len(nrow(soon)), in_top10 = FALSE),
    transmute(hid, agency_id, opp_id, rank = NA_integer_, in_top10 = FALSE))
}
sel <- bind_rows(lapply(active$agency_id, pick_rows))
sel$rank <- as.integer(sel$rank)

o <- opps[, c("opp_id", "summary", "cfda_list", "url", "nc_won_before")]
rows <- sel |>
  left_join(items, by = c("agency_id", "opp_id")) |>
  left_join(o, by = "opp_id") |>
  arrange(agency_id, is.na(rank), !in_top10, rank, opp_id) |>
  transmute(
    agency_id, opp_id, opp_number, title = clean_text(title), status,
    close_date = na_if(close_date, ""), days_left = as.integer(days_left), date_note = na_if(date_note, ""),
    fit_score = round(as.numeric(fit), 4), rank, in_top10,
    eligibility, elig_source = na_if(elig_source, ""), elig_quote = na_if(clean_text(elig_quote), ""),
    reader_label = NA_character_, reader_quote = NA_character_,
    map_note = na_if(map_note, ""), goal_id = na_if(goal_id, ""), goal_snippet = na_if(clean_text(goal_snippet), ""),
    opp_snippet = str_sub(clean_text(summary), 1, SNIPPET_CHARS),
    cfda_list, award_ceiling = as.numeric(award_ceiling),
    signature_tier = "unknown", tier_source = NA_character_,
    nc_won_before = as.logical(nc_won_before), url)

# Closing soon: open Top 10 rows with CLOSING_SOON_DAYS or fewer days left (the tool's panel reads days_left itself;
# this count lets it show a badge without scanning).
soon <- rows[rows$in_top10 & !is.na(rows$days_left) & rows$days_left >= 0 & rows$days_left <= CLOSING_SOON_DAYS, ]
for (i in seq_along(agencies)) agencies[[i]]$n_closing_soon <- sum(soon$agency_id == agencies[[i]]$agency_id)

payload <- list(data_as_of = PAYLOAD_AS_OF, window_days = WINDOW_DEFAULT_WEEKS * 7L,
                agencies = agencies, rows = rows)
write_json(payload, PAYLOAD_JSON, auto_unbox = TRUE, null = "null", na = "null", pretty = TRUE, digits = NA)
message("Wrote payload.json: ", length(agencies), " agencies, ", nrow(rows), " rows (",
        sum(rows$in_top10), " top 10, ", sum(!rows$in_top10 & rows$eligibility != "no"), " coming up, ",
        sum(rows$eligibility == "no"), " hidden)")
