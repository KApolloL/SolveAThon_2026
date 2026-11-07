# make_label_sheets.R  -- builds blind label sheets for people to fill in.
# Run from anywhere:  Rscript make_label_sheets.R [ranking_file.csv]
# Optional ranking file columns: agency, opp_id, rank  (1 = best). Items the ranker
# puts at its top 10 and a middle 5 are added to the pool. Run it AFTER the ranking
# lands if you want the ranker's picks labeled; otherwise the pool is baseline + random.
#
# Nothing here fills a label. The sheet shows no rank, score, stratum or keyword hits.
# Where each item came from lives only in the key file (sheets/key_hidden_DO_NOT_SHARE.csv).

suppressMessages(library(data.table))

# ---- parameters ------------------------------------------------------------
# [assumed] both had people at the discovery session; Kent can change them.
# Names must match agency_goal_summaries.csv exactly.
DEMO_AGENCIES <- c("Department of Natural and Cultural Resources",
                   "Department of Public Schools")
N_BASELINE_TOP <- 10   # top keyword-baseline hits
N_BASELINE_MID <- 10   # mid-rank keyword hits
N_RANDOM       <- 10   # random from everything else
N_RANKER_TOP   <- 10   # from the ranking file, if given
N_RANKER_MID   <- 5
SEED           <- 2026
LABELERS       <- c("A", "B")
SUMMARY_CHARS  <- 500

# ---- paths (relative to this script) --------------------------------------
args_all <- commandArgs(FALSE)
here <- dirname(normalizePath(sub("^--file=", "", args_all[grep("^--file=", args_all)][1])))
repo <- normalizePath(file.path(here, "..", "..", ".."))
opp_path  <- file.path(repo, "data", "processed", "opportunities.csv")
goal_path <- file.path(repo, "src", "docs", "agency_goal_summaries.csv")
out_dir   <- file.path(here, "sheets")
source(file.path(here, "keyword_baseline.R"))

ranking_arg <- commandArgs(TRUE)[1]
ranking <- NULL
if (!is.na(ranking_arg) && file.exists(ranking_arg)) {
  ranking <- fread(ranking_arg, colClasses = list(character = c("agency", "opp_id")))
  need <- c("agency", "opp_id", "rank")
  if (!all(need %in% names(ranking))) stop("Ranking file needs columns: ", paste(need, collapse = ", "))
  message("Using ranking file: ", ranking_arg)
} else {
  message("No ranking file given: pool = baseline + random only.")
}

# ---- load ------------------------------------------------------------------
opps  <- fread(opp_path, colClasses = list(character = c("opp_id", "opp_number")))
goals <- fread(goal_path)
opps[, opp_id := as.character(opp_id)]

clean_text <- function(x) {   # decode the few HTML entities seen in the data, flatten whitespace
  x <- gsub("&amp;", "&", x, fixed = TRUE)
  x <- gsub("&#8217;|&#39;|&rsquo;", "'", x)
  x <- gsub("&#8211;|&ndash;", "-", x)
  x <- gsub("&quot;|&#8220;|&#8221;", "\"", x)
  x <- gsub("&nbsp;", " ", x, fixed = TRUE)
  trimws(gsub("\\s+", " ", x))
}
or_unknown <- function(x) { x <- as.character(x); ifelse(is.na(x) | !nzchar(trimws(x)), "unknown", x) }

# spaced pick of n positions across [lo, hi] (deterministic)
spaced <- function(lo, hi, n) {
  if (hi < lo) return(integer(0))
  n <- min(n, hi - lo + 1)
  unique(round(seq(lo, hi, length.out = n)))
}

sheet_rows <- list(); key_rows <- list()
for (ag in DEMO_AGENCIES) {
  if (!ag %in% goals$agency) {
    stop("Agency label not found in goals file: '", ag, "'. Exact labels available include: ",
         paste(head(unique(goals$agency), 40), collapse = " | "))
  }
  terms <- agency_terms(ag, goals)
  message(ag, ": ", length(terms), " keyword terms")
  pool <- opps[status %in% OPEN_STATUSES]
  kb <- keyword_baseline(pool, terms)
  pool <- merge(pool, kb, by = "opp_id")
  setorder(pool, kw_rank)

  picked <- list()  # opp_id -> stratum label vector
  add <- function(ids, label) for (i in ids) picked[[i]] <<- c(picked[[i]], label)

  hits <- pool[kw_score > 0]
  if (nrow(hits) < N_BASELINE_TOP + N_BASELINE_MID)
    warning(ag, ": only ", nrow(hits), " keyword hits; baseline strata will be short.")
  top_ids <- head(hits$opp_id, N_BASELINE_TOP)
  add(top_ids, "baseline_top")
  # mid band: middle third of the remaining hits, evenly spaced
  rem <- hits[!opp_id %in% top_ids]
  if (nrow(rem) > 0) {
    lo <- ceiling(nrow(rem) / 3); hi <- floor(2 * nrow(rem) / 3)
    mid_pos <- spaced(max(lo, 1), max(hi, 1), N_BASELINE_MID)
    add(rem$opp_id[mid_pos], "baseline_mid")
  }
  if (!is.null(ranking)) {
    rk <- ranking[agency == ag][order(rank, opp_id)]
    rk <- rk[opp_id %in% pool$opp_id]
    if (nrow(rk) == 0) warning(ag, ": ranking file has no open items for this agency.")
    add(head(rk$opp_id, N_RANKER_TOP), "ranker_top")
    rem_rk <- rk[!opp_id %in% head(rk$opp_id, N_RANKER_TOP)]
    if (nrow(rem_rk) > 0) {
      c0 <- ceiling(nrow(rem_rk) / 2)
      pos <- spaced(max(c0 - 2, 1), min(c0 + 2, nrow(rem_rk)), N_RANKER_MID)
      add(rem_rk$opp_id[pos], "ranker_mid")
    }
  }
  # random from the rest (not already picked)
  set.seed(SEED + match(ag, DEMO_AGENCIES))
  rest <- sort(setdiff(pool$opp_id, names(picked)))
  rnd <- sample(rest, min(N_RANDOM, length(rest)))
  add(rnd, "random_rest")

  sel <- pool[opp_id %in% names(picked)]
  # shuffle item order (seeded); item_no is just the shuffled position
  set.seed(SEED + 100 + match(ag, DEMO_AGENCIES))
  sel <- sel[sample.int(nrow(sel))]
  sel[, item_no := seq_len(.N)]
  sel[, strata := vapply(opp_id, function(i) paste(unique(picked[[i]]), collapse = ";"), "")]
  rk_lookup <- if (!is.null(ranking)) ranking[agency == ag, .(opp_id, ranker_rank = rank)] else
    data.table(opp_id = character(), ranker_rank = numeric())
  sel <- merge(sel, rk_lookup, by = "opp_id", all.x = TRUE, sort = FALSE)
  setorder(sel, item_no)

  award <- ifelse(is.na(sel$award_ceiling), "unknown",
           ifelse(sel$award_ceiling == 0, "unknown (listed as 0)", format(as.numeric(sel$award_ceiling), scientific = FALSE, big.mark = ",")))
  base <- data.table(
    item_no = sel$item_no,
    opp_number = sel$opp_number,
    title = clean_text(sel$title),
    agency_funder = clean_text(or_unknown(sel$agency)),
    status = sel$status,
    close_date = or_unknown(format(sel$close_date)),
    award_ceiling = award,
    summary_short = {s <- clean_text(or_unknown(sel$summary)); substr(s, 1, SUMMARY_CHARS)},
    url = or_unknown(sel$url))
  base[close_date == "NA", close_date := "unknown"]

  slug <- gsub("^_|_$", "", gsub("[^a-z]+", "_", tolower(ag)))
  for (lb in LABELERS) {
    sh <- copy(base)
    if (lb != LABELERS[1]) {   # different row order per labeler to reduce order effects; item_no unchanged
      set.seed(SEED + 200 + match(lb, LABELERS) + match(ag, DEMO_AGENCIES))
      sh <- sh[sample.int(nrow(sh))]
    }
    sh[, `:=`(labeler = lb, relevant = "", eligible_state_agency = "", worth_the_effort = "", note = "")]
    setcolorder(sh, c("item_no","opp_number","title","agency_funder","status","close_date","award_ceiling",
                      "summary_short","url","labeler","relevant","eligible_state_agency","worth_the_effort","note"))
    f <- file.path(out_dir, sprintf("labels_%s_labeler%s.csv", slug, lb))
    fwrite(sh, f)
    message("  wrote ", basename(f), " (", nrow(sh), " rows)")
  }
  key_rows[[ag]] <- data.table(agency = ag, item_no = sel$item_no, opp_id = sel$opp_id,
    opp_number = sel$opp_number, source_stratum = sel$strata, kw_rank = sel$kw_rank,
    kw_score = sel$kw_score, kw_hits = sel$kw_hits, ranker_rank = sel$ranker_rank)
  print(table(unlist(strsplit(sel$strata, ";"))))
}
key <- rbindlist(key_rows)
fwrite(key, file.path(out_dir, "key_hidden_DO_NOT_SHARE.csv"))
message("wrote key_hidden_DO_NOT_SHARE.csv (", nrow(key), " rows). Labelers must never open it.")
