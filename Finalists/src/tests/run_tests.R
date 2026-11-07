# run_tests.R: unit tests, integration test, your own test cases, R/JS agreement, and
# the LLM label guard. Prints "N of N tests pass" and writes outs/test_report.csv.
# Test cases are written BEFORE looking at results (Deloitte: set the rule first).
# Run from Finalists/src: Rscript tests/run_tests.R

here::i_am("src/tests/run_tests.R")
source(here::here("src", "R", "00_config.R"))
source(here::here("src", "R", "helpers_io.R"))
source(here::here("src", "R", "helpers_llm.R"))
source(here::here("src", "R", "score.R"))
source(here::here("src", "tests", "agreement.R"))
suppressPackageStartupMessages({ library(readr); library(tibble); library(dplyr) })

results <- list()
check <- function(section, name, ok, got = "") {
  results[[length(results) + 1]] <<- tibble(section = section, name = name, ok = isTRUE(ok), got = as.character(got))
}
fails <- function(expr) inherits(try(expr, silent = TRUE), "try-error")
ref <- as.Date("2026-11-06")

# ---- 1. Unit: every rule on known input ---------------------------------------------
u <- "unit: rules"
check(u, "eq", identical(rule_eval(c("a", "b", NA), "eq", "a", ref), c(TRUE, FALSE, NA)))
check(u, "in", identical(rule_eval(c("a", "c"), "in", "a|b", ref), c(TRUE, FALSE)))
check(u, "gte", identical(rule_eval(c(1, 5, NA), "gte", "5", ref), c(FALSE, TRUE, NA)))
check(u, "between", identical(rule_eval(c(1, 5, 9), "between", "2|8", ref), c(FALSE, TRUE, FALSE)))
check(u, "contains is case-insensitive", identical(rule_eval(c("Rural clinic", "urban"), "contains", "rural|farm", ref), c(TRUE, FALSE)))
check(u, "is_true", identical(rule_eval(c("TRUE", "no", "yes"), "is_true", "", ref), c(TRUE, FALSE, TRUE)))
check(u, "not_na treats empty as missing", identical(rule_eval(c("x", "", NA), "not_na", "", ref), c(TRUE, FALSE, FALSE)))
check(u, "date_gte_days", identical(rule_eval(c("2026-12-06", "2026-11-20"), "date_gte_days", "30", ref), c(TRUE, FALSE)))
check(u, "scale clamps to 0..1", isTRUE(all.equal(rule_eval(c(0, 50, 200), "scale", "0|100", ref), c(0, 0.5, 1))))
check(u, "scale can run downhill (smaller is better)", isTRUE(all.equal(rule_eval(c(0, 100), "scale", "100|0", ref), c(1, 0))))
check(u, "unknown rule errors", fails(rule_eval(1, "nope", "", ref)))

# ---- 2. Unit: bad criteria are rejected with a clear error --------------------------
toy <- tibble(id = c("a", "b"), name = c("A", "B"), x = c(1, 2))
base_cr <- tibble(id = "s", type = "score", label = "S", field = "x", rule = "scale", value = "0|2", weight = 1)
check("unit: criteria", "missing field is rejected", fails(rank_items(toy, mutate(base_cr, field = "zzz"), ref)))
check("unit: criteria", "duplicate ids are rejected", fails(rank_items(toy, bind_rows(base_cr, base_cr), ref)))
check("unit: criteria", "scale not allowed on a filter", fails(rank_items(toy, mutate(base_cr, type = "filter"), ref)))

# ---- 3. Integration: whole pipeline on the project data -----------------------------
i <- "integration"
items <- read_any(ITEMS_FILE)
cr <- read_csv(CRITERIA_FILE, show_col_types = FALSE, col_types = cols(.default = col_character()))
cr$weight <- if ("weight" %in% names(cr)) suppressWarnings(as.numeric(cr$weight)) else NA_real_
rk <- rank_items(items, cr, REF_DATE, ID_COL, NAME_COL)
check(i, "every item is ranked or dropped exactly once", nrow(rk$ranked) + nrow(rk$dropped) == nrow(items),
      paste(nrow(rk$ranked), "+", nrow(rk$dropped), "of", nrow(items)))
check(i, "ids are unique", !anyDuplicated(items[[ID_COL]]))
check(i, "totals are between 0 and 100", all(rk$ranked$total >= 0 & rk$ranked$total <= 100))
check(i, "ranking is sorted by total", !is.unsorted(rev(rk$ranked$total)))
check(i, "rerun gives the same ranking (reproducible)", identical(rk$ranked$id, rank_items(items, cr, REF_DATE, ID_COL, NAME_COL)$ranked$id))
sc <- cr$id[cr$type == "score"]
if (length(sc)) {
  zero_w <- rank_items(items, cr, REF_DATE, ID_COL, NAME_COL, weights = setNames(rep(0, length(sc)), sc))
  check(i, "all weights zero gives total 0, no crash", all(zero_w$ranked$total == 0))
}
filt <- cr$id[cr$type == "filter"]
if (length(filt)) {
  off <- rank_items(items, cr, REF_DATE, ID_COL, NAME_COL, filters_on = setNames(rep(FALSE, length(filt)), filt))
  check(i, "turning every filter off keeps every item", nrow(off$ranked) == nrow(items))
}

# ---- 4. Your test cases (data/manual/test_cases.csv) -------------------------------
tc_path <- TEST_CASES_FILE
tc <- read_csv(tc_path, show_col_types = FALSE, col_types = cols(.default = col_character()))
ranked <- rk$ranked
for (r in seq_len(nrow(tc))) {
  t <- tc[r, ]
  ok <- switch(t$type,
    in_top_n       = t$item_id %in% head(ranked$id, as.integer(t$n)),
    ranks_above    = t$item_id %in% ranked$id && t$other_id %in% ranked$id &&
                       match(t$item_id, ranked$id) < match(t$other_id, ranked$id),
    not_in_ranking = !(t$item_id %in% ranked$id),
    dropped_by     = grepl(cr$label[cr$id == t$filter_id], rk$dropped$dropped_by[rk$dropped$id == t$item_id], fixed = TRUE),
    points_equal   = isTRUE(all.equal(rk$all[[paste0("pts_", t$criterion_id)]][match(t$item_id, rk$all$id)], as.numeric(t$expected))),
    FALSE)
  check("your test cases", paste0(t$case_id, ": ", t$description), ok)
}

# ---- 5. R and JS agree -------------------------------------------------------------
if (!file.exists(PAYLOAD_JSON)) {
  check("R and JS agree", "payload.json exists (run R/10_run_ranking.R)", FALSE)
} else if (!is.null(jsonlite::fromJSON(PAYLOAD_JSON)$rows)) {
  # Contract-shape payload (saturday/03_contract.md); tool/ranker.js still expects the toy shape.
  check("R and JS agree", "agreement test pending new ranker for contract-shape payload.json", FALSE)
} else {
  ag <- check_r_js_agreement()
  for (k in seq_len(nrow(ag))) check("R and JS agree", ag$name[k], ag$ok[k], ag$got[k])
}

# ---- 6. LLM guard: labels need a verifiable quote; cache; shards -------------------
l <- "llm guard"
DIR_CACHE_LLM <- tempfile("llm_cache_"); LLM_MODEL <- "test-model"
text <- "The program funds clinics in rural counties with few doctors."
levs <- c("yes", "no")
good <- llm_label(text, "Does it serve rural areas?", levs, .chat_fn = function(p) '{"label":"yes","evidence":"clinics in rural counties"}')
check(l, "label with a real quote is kept", good$label == "yes" && good$evidence_ok)
bad <- llm_label("A different text about roads.", "Does it serve rural areas?", levs, .chat_fn = function(p) '{"label":"yes","evidence":"funds rural clinics"}')
check(l, "label with a made-up quote falls back to the none level", bad$label == "no" && !bad$evidence_ok)
junk <- llm_label("Roads text.", "Rural?", levs, .chat_fn = function(p) "not json")
check(l, "unparseable model output falls back to the none level", junk$label == "no")
again <- llm_label(text, "Does it serve rural areas?", levs, .chat_fn = function(p) stop("should not be called"))
check(l, "second call is served from the cache", again$cached && again$label == "yes")
df <- tibble(id = 1:7, txt = rep(text, 7))
parts <- lapply(1:3, function(k) label_items(df, "id", "txt", "Does it serve rural areas?", levs, shard = c(k, 3), .chat_fn = function(p) '{"label":"yes","evidence":"clinics in rural counties"}'))
ids_seen <- sort(unlist(lapply(parts, `[[`, "id")))
check(l, "shards cover every item exactly once", identical(ids_seen, 1:7))

# ---- 7. Ingest: merged opportunities table -----------------------------------------
source(here::here("src", "tests", "test_ingest.R"))
source(here::here("src", "tests", "test_plan_tables.R"))

# ---- Report ------------------------------------------------------------------------
rep <- bind_rows(results)
dir.create(DIR_OUTS, showWarnings = FALSE, recursive = TRUE)
write_csv(rep, file.path(DIR_OUTS, "test_report.csv"))
if (!all(rep$ok)) print(as.data.frame(rep[!rep$ok, c("section", "name", "got")]))
cat(sprintf("%d of %d tests pass%s\n", sum(rep$ok), nrow(rep), if (USING_EXAMPLE) " (on TOY example data)" else ""))
if (!all(rep$ok)) quit(status = 1)
