# 07_top_results.R — the competition's "top results list": every opportunity in Tiers 1-3
# of the tool's opening scenario (and DMVA's view), ordered by tier then impact score, each
# with a one-line rationale tied to the five match criteria:
#   1. can be the applicant  2. has the capabilities  3. enough runway
#   4. award worth the effort  5. match is survivable
# Tiers, impact and capability gaps come from src/tool/tiering.js run through V8, so the list
# is exactly what the tool shows. Output: outs/top_results.csv and outs/top_results.xlsx.

suppressPackageStartupMessages({ library(dplyr); library(purrr); library(stringr); library(jsonlite); library(tibble) })

TOP_RESULTS_MAX_TIER <- 3L

run_tiering_piles_js <- function(payload, settings) {
  ctx <- V8::v8()
  ctx$source(tiering_js_path())
  to_js <- function(x) toJSON(x, auto_unbox = TRUE, null = "null", na = "null", digits = NA)
  ctx$eval(paste0("var P = ", to_js(list(opportunities = payload$opportunities,
                                           capabilities = payload$capabilities)), ";"))
  ctx$eval(paste0("var S = ", to_js(settings), ";"))
  out <- ctx$eval("JSON.stringify((function () {
      var res = Tiering.run(P, S), prof = P.capabilities.profiles[S.agency] || {}, rows = [];
      [1, 2, 3, 4].forEach(function (k) {
        res.piles[k].forEach(function (it, i) {
          rows.push({ number: it.opp.number, tier: k, rank_in_tier: i + 1,
                      impact: it.impact ? it.impact.score : null, tier_reason: it.tier_reason,
                      days_left: it.days_left, gaps: Tiering.capabilityGaps(it.opp, prof) });
        });
      });
      return rows;
    })())")
  fromJSON(out, simplifyVector = FALSE)
}

usd_short <- function(x) {
  if (is.null(x) || is.na(x)) return("award size not stated")
  if (x >= 1e6) return(paste0("~$", format(round(x / 1e6, 1), nsmall = 1), "M"))
  paste0("~$", round(x / 1e3), "K")
}

one_line_rationale <- function(row, opp, settings, tier_names) {
  applicant <- if (isTRUE(opp$screen$is_nih) || isTRUE(opp$screen$is_research_mechanism)) "research award (a university would apply)"
               else if (isTRUE(opp$screen$not_administrable)) "a partner would likely lead"
               else "state agency can apply"
  if (identical(opp$status, "forecasted")) applicant <- paste0(applicant, ", forecast (not yet posted)")
  gaps <- row$gaps
  need <- keep(gaps, ~ .x$control %in% c("partner", "none"))
  caps <- if (length(gaps) == 0) "no special capabilities detected"
          else if (length(need) == 0) "required capabilities in-house or contracted"
          else paste(map_chr(need, ~ paste0(if (.x$control == "none") "no route to " else "partner needed for ",
                                            tolower(.x$label))), collapse = "; ")
  runway <- if (is.null(row$days_left)) "no deadline stated" else paste0(row$days_left, " days to deadline")
  award <- paste0(usd_short(opp$award_estimate_usd), if (identical(opp$award_basis, "total_over_count")) " implied award" else if (identical(opp$award_basis, "ceiling")) " ceiling" else "")
  match <- if (isTRUE(opp$cost_share)) paste0("cost share required", if (!is.null(opp$match_pct)) paste0(" (", opp$match_pct, "% stated)") else " (percentage not published)")
           else "no cost share"
  paste0(applicant, " · ", caps, " · ", runway, " · ", award, " · ", match,
         " → Tier ", row$tier, ": ", tier_names[[as.character(row$tier)]])
}

build_top_results <- function(payload, agency = "DHHS", settings = payload$config$opening) {
  settings$agency <- agency
  tier_names <- list("1" = "writer can act", "2" = "needs supervisor or division",
                     "3" = "needs secretary or legislature", "4" = "partner-led research")
  by_num <- setNames(payload$opportunities, map_chr(payload$opportunities, "number"))
  rows <- run_tiering_piles_js(payload, settings)
  rows <- keep(rows, ~ .x$tier <= TOP_RESULTS_MAX_TIER)
  map_dfr(rows, function(r) {
    o <- by_num[[r$number]]
    tibble(agency = agency, tier = r$tier, rank_in_tier = r$rank_in_tier,
           impact_score = r$impact %||% NA_real_,
           opportunity_number = r$number, title = o$title, issuing_agency = o$agency_code,
           status = o$status, deadline = if (is.null(o$close_day)) NA else as.Date(o$close_day, origin = "1970-01-01"),
           estimated_award = o$award_estimate_usd %||% NA_real_,
           rationale = one_line_rationale(r, o, settings, tier_names),
           rules_that_fired = r$tier_reason, link = o$url %||% NA_character_)
  }) |> arrange(tier, rank_in_tier)
}

write_top_results <- function(tr) {
  csv <- file.path(DIR_OUTS, "top_results.csv"); readr::write_csv(tr, csv, na = "")
  wb <- openxlsx::createWorkbook(); openxlsx::addWorksheet(wb, "Top results")
  openxlsx::writeData(wb, 1, tr, withFilter = TRUE)
  openxlsx::addStyle(wb, 1, openxlsx::createStyle(textDecoration = "bold", fgFill = "#D9EAF7", wrapText = TRUE),
                     rows = 1, cols = seq_along(tr), gridExpand = TRUE)
  openxlsx::addStyle(wb, 1, openxlsx::createStyle(wrapText = TRUE, valign = "top"),
                     rows = 2:(nrow(tr) + 1), cols = seq_along(tr), gridExpand = TRUE)
  openxlsx::freezePane(wb, 1, firstRow = TRUE)
  openxlsx::setColWidths(wb, 1, cols = seq_along(tr),
                         widths = c(8, 6, 8, 8, 20, 45, 16, 10, 11, 12, 70, 50, 30)[seq_along(tr)])
  xlsx <- file.path(DIR_OUTS, "top_results.xlsx"); openxlsx::saveWorkbook(wb, xlsx, overwrite = TRUE)
  c(csv, xlsx)
}

if (sys.nframe() == 0L) {
  here::i_am("src/R/07_top_results.R")
  for (f in c("00_config", "01_load_clean", "02_capabilities")) source(here::here("src", "R", paste0(f, ".R")))
  payload <- jsonlite::fromJSON(PAYLOAD_JSON, simplifyVector = FALSE)
  tr <- bind_rows(build_top_results(payload, "DHHS"), build_top_results(payload, "DMVA"))
  message("Wrote ", paste(write_top_results(tr), collapse = ", "), " (", nrow(tr), " rows)")
  print(select(tr, agency, tier, impact_score, rationale) |> head(8), width = 250)
}
