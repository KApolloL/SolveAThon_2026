# score_labels.R  -- scores filled label sheets against a ranking and the keyword baseline.
#
# Usage (from this folder):
#   Rscript score_labels.R sheets=sheets key=sheets/key_hidden_DO_NOT_SHARE.csv \
#           ranking=path/to/ranking.csv out=results
# ranking is optional (columns agency, opp_id, rank; 1 = best). Without it only the
# keyword baseline is scored. Functions below are also sourced by test_metrics.R.
#
# What it does NOT do: set pass marks, resolve label disagreements for you, or fill labels.
# Every number is computed on the small labeled pool only. See README.md for limits.

suppressMessages(library(data.table))

# ---- pass marks: Kent sets these BEFORE scoring. NA = show numbers, no pass/fail ----
PASS_PRECISION_AT_10 <- NA_real_   # e.g. 0.5 means "at least half of top 10 relevant"
PASS_RECALL_AT_25    <- NA_real_
PASS_KAPPA_MIN       <- NA_real_
TOP_K_PRECISION <- 10L
TOP_K_RECALL    <- 25L

# ---------------- pure metric functions (tested in test_metrics.R) ----------------

# Turn a ranking (data.frame with id, rank) into ids ordered best first.
# Ties in rank are broken by id (text order) so results are reproducible.
order_ids <- function(ids, rank) {
  ids <- as.character(ids)
  ids[order(rank, ids)]
}

# Precision@k on LABELED items only.
# ranked_ids: ids best first. verdict: named logical vector (name = id; TRUE relevant,
# FALSE not relevant, NA = no usable label). Items in the top k with NA are left out of
# the denominator and counted in n_unlabeled. Empty ranking -> NA.
precision_at_k <- function(ranked_ids, verdict, k = 10L) {
  top <- head(ranked_ids, k)
  v <- unname(verdict[top])
  n_lab <- sum(!is.na(v))
  list(value = if (n_lab == 0) NA_real_ else sum(v, na.rm = TRUE) / n_lab,
       n_relevant = sum(v, na.rm = TRUE), n_labeled = n_lab,
       n_unlabeled = length(top) - n_lab, n_in_top = length(top))
}

# Recall@k against the labeled pool: of labeled-relevant items, how many are in top k.
# Items with NA verdict are not counted as relevant. No relevant items -> NA.
recall_at_k <- function(ranked_ids, verdict, k = 25L) {
  rel <- names(verdict)[!is.na(verdict) & verdict]
  list(value = if (length(rel) == 0) NA_real_ else sum(rel %in% head(ranked_ids, k)) / length(rel),
       n_found = sum(rel %in% head(ranked_ids, k)), n_relevant = length(rel))
}

# Percent agreement and Cohen's kappa between two label vectors (same items, same order).
# Items where either label is NA are dropped. kappa is NA if chance agreement is 1.
agreement <- function(a, b) {
  ok <- !is.na(a) & !is.na(b)
  a <- a[ok]; b <- b[ok]
  n <- length(a)
  if (n == 0) return(list(n = 0L, pct = NA_real_, kappa = NA_real_))
  po <- mean(a == b)
  lv <- union(a, b)
  pe <- sum(vapply(lv, function(l) mean(a == l) * mean(b == l), numeric(1)))
  list(n = n, pct = po, kappa = if (isTRUE(all.equal(pe, 1))) NA_real_ else (po - pe) / (1 - pe))
}

# Combine two labelers' answers for one item under a rule. Never silent:
# strict = both yes; lenient = either yes. Returns TRUE/FALSE, or NA when either
# labeler left the item blank (we do not guess). "unsure" counts as not yes.
combine_verdict <- function(a, b, rule = c("strict", "lenient")) {
  rule <- match.arg(rule)
  ya <- a == "yes"; yb <- b == "yes"
  out <- if (rule == "strict") ya & yb else ya | yb
  out[is.na(a) | is.na(b)] <- NA
  out
}

norm_label <- function(x) {
  x <- tolower(trimws(as.character(x)))
  x[is.na(x) | x == ""] <- NA
  x
}

pass_text <- function(value, mark, higher_is_better = TRUE) {
  if (is.na(mark)) return("no pass mark set")
  if (is.na(value)) return("cannot tell (no value)")
  if (value >= mark) "PASS" else "FAIL"
}

# ---------------- main (only when run as a script) ----------------
score_main <- function(argv) {
  kv <- strsplit(argv, "=", fixed = TRUE)
  opt <- setNames(lapply(kv, function(z) paste(z[-1], collapse = "=")), vapply(kv, `[`, "", 1))
  sheets_dir <- if (!is.null(opt$sheets)) opt$sheets else "sheets"
  key_path   <- if (!is.null(opt$key)) opt$key else file.path(sheets_dir, "key_hidden_DO_NOT_SHARE.csv")
  rank_path  <- opt$ranking
  out_dir    <- if (!is.null(opt$out)) opt$out else "results"
  dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)

  if (any(is.na(c(PASS_PRECISION_AT_10, PASS_RECALL_AT_25, PASS_KAPPA_MIN)))) {
    message("\n*** Kent sets pass marks before scoring. ***")
    message("*** Pass marks are NA, so numbers below are shown WITHOUT pass/fail. ***\n")
  }

  key <- fread(key_path, colClasses = list(character = c("opp_id", "opp_number")))
  files <- list.files(sheets_dir, pattern = "^labels_.*_labeler[A-Z]\\.csv$", full.names = TRUE)
  if (length(files) == 0) stop("No filled label sheets found in ", sheets_dir)
  lab <- rbindlist(lapply(files, function(f) { d <- fread(f, colClasses = "character"); d[, file := basename(f)]; d }), fill = TRUE)
  for (cc in c("relevant", "eligible_state_agency", "worth_the_effort")) lab[[cc]] <- norm_label(lab[[cc]])
  bad <- lab[(!is.na(relevant) & !relevant %in% c("yes","no","unsure")) |
             (!is.na(eligible_state_agency) & !eligible_state_agency %in% c("yes","no","unsure")) |
             (!is.na(worth_the_effort) & !worth_the_effort %in% c("yes","no","unsure"))]
  if (nrow(bad)) { warning(nrow(bad), " rows have labels other than yes/no/unsure; treated as invalid (NA)."); 
    for (cc in c("relevant","eligible_state_agency","worth_the_effort")) lab[!(get(cc) %in% c("yes","no","unsure")), (cc) := NA_character_] }
  lab[, item_no := as.integer(item_no)]
  # which agency does each sheet belong to: join through the key on item_no is ambiguous
  # across agencies, so use the file name slug.
  slug <- function(x) gsub("^_|_$", "", gsub("[^a-z]+", "_", tolower(x)))
  key[, slug := slug(agency)]
  lab[, slug := sub("^labels_(.*)_labeler[A-Z]\\.csv$", "\\1", file)]
  lab <- merge(lab, key[, .(slug, item_no, agency, opp_id, kw_rank)], by = c("slug", "item_no"), all.x = TRUE)
  if (anyNA(lab$opp_id)) stop("Some sheet rows do not match the key (item_no/agency). Wrong key file?")

  ranking <- NULL
  if (!is.null(rank_path) && nzchar(rank_path)) {
    ranking <- fread(rank_path, colClasses = list(character = c("agency", "opp_id")))
    if (!all(c("agency","opp_id","rank") %in% names(ranking))) stop("ranking needs agency, opp_id, rank")
  } else message("No ranking file: scoring the keyword baseline only.")

  # need the baseline over the FULL open pool, so recompute it (same code as the sheets)
  here <- tryCatch(dirname(normalizePath(sub("^--file=", "", commandArgs(FALSE)[grep("^--file=", commandArgs(FALSE))][1]))), error = function(e) ".")
  source(file.path(here, "keyword_baseline.R"))
  repo <- normalizePath(file.path(here, "..", "..", ".."))
  opps <- fread(file.path(repo, "data", "processed", "opportunities.csv"), colClasses = list(character = c("opp_id","opp_number")))
  goals <- fread(file.path(repo, "src", "docs", "agency_goal_summaries.csv"))

  summ <- list(); detail <- list(); disag_all <- list()
  for (ag in unique(lab$agency)) {
    L <- lab[agency == ag]
    labelers <- sort(unique(L$labeler))
    if (length(labelers) != 2) { warning(ag, ": expected 2 labelers, found ", length(labelers)); next }
    wide <- dcast(L, opp_id ~ labeler, value.var = c("relevant","eligible_state_agency","worth_the_effort"))
    ca <- paste0("relevant_", labelers[1]); cb <- paste0("relevant_", labelers[2])
    wide[, strict := combine_verdict(get(ca), get(cb), "strict")]
    wide[, lenient := combine_verdict(get(ca), get(cb), "lenient")]
    agr <- agreement(wide[[ca]], wide[[cb]])
    disag <- wide[!is.na(get(ca)) & !is.na(get(cb)) & get(ca) != get(cb)]
    disag[, agency := ag]; disag_all[[ag]] <- disag[, .(agency, opp_id, A = get(ca), B = get(cb))]
    n_unsure <- sum(wide[[ca]] == "unsure", na.rm = TRUE) + sum(wide[[cb]] == "unsure", na.rm = TRUE)
    n_blank <- sum(is.na(wide[[ca]])) + sum(is.na(wide[[cb]]))

    # rankings: ranker (optional) and baseline over the full open pool
    pool <- opps[status %in% OPEN_STATUSES]
    kb <- keyword_baseline(pool, agency_terms(ag, goals))
    kb_ids <- kb$opp_id
    rk_ids <- NULL
    if (!is.null(ranking)) {
      r <- ranking[agency == ag]
      if (nrow(r) == 0) warning(ag, ": no rows for this agency in ranking file")
      else rk_ids <- order_ids(r$opp_id, r$rank)
    }
    for (rule in c("strict", "lenient")) {
      v <- setNames(wide[[rule]], wide$opp_id)
      methods <- list(keyword_baseline = kb_ids); if (!is.null(rk_ids)) methods <- c(list(ranker = rk_ids), methods)
      for (m in names(methods)) {
        ids <- methods[[m]]
        p <- precision_at_k(ids, v, TOP_K_PRECISION); r25 <- recall_at_k(ids, v, TOP_K_RECALL)
        rel <- names(v)[!is.na(v) & v]
        top10 <- head(ids, TOP_K_PRECISION)
        fp <- names(v)[!is.na(v) & !v & names(v) %in% top10]
        miss <- setdiff(rel, head(ids, TOP_K_RECALL))
        # eligibility flag among this method's top 10 (either labeler says "no")
        elig_no <- wide[opp_id %in% top10 & (get(paste0("eligible_state_agency_", labelers[1])) %in% "no" |
                                              get(paste0("eligible_state_agency_", labelers[2])) %in% "no"), opp_id]
        summ[[paste(ag, rule, m)]] <- data.table(agency = ag, rule = rule, method = m,
          precision_at_10 = p$value, labeled_in_top10 = p$n_labeled, unlabeled_in_top10 = p$n_unlabeled,
          recall_at_25 = r25$value, relevant_in_pool = r25$n_relevant, relevant_found_top25 = r25$n_found,
          misses_outside_top25 = length(miss), false_positives_top10 = length(fp), top10_flagged_ineligible = length(elig_no),
          precision_status = pass_text(p$value, PASS_PRECISION_AT_10), recall_status = pass_text(r25$value, PASS_RECALL_AT_25))
        detail[[paste(ag, rule, m)]] <- data.table(agency = ag, rule = rule, method = m,
          kind = c(rep("miss_relevant_outside_top25", length(miss)), rep("false_positive_in_top10", length(fp))),
          opp_id = c(miss, fp))
      }
      if (!is.null(rk_ids)) {
        rt <- head(rk_ids, TOP_K_RECALL); bt <- head(kb_ids, TOP_K_RECALL); rel <- names(v)[!is.na(v) & v]
        detail[[paste(ag, rule, "cmp")]] <- data.table(agency = ag, rule = rule, method = "ranker_vs_baseline",
          kind = c(rep("found_by_ranker_missed_by_baseline", length(setdiff(intersect(rel, rt), bt))),
                   rep("found_by_baseline_missed_by_ranker", length(setdiff(intersect(rel, bt), rt)))),
          opp_id = c(setdiff(intersect(rel, rt), bt), setdiff(intersect(rel, bt), rt)))
      }
    }
    summ[[paste(ag, "agree")]] <- data.table(agency = ag, rule = "agreement", method = "labelers",
      precision_at_10 = NA_real_, labeled_in_top10 = agr$n, recall_at_25 = agr$pct, relevant_in_pool = NA_integer_,
      relevant_found_top25 = NA_integer_, misses_outside_top25 = n_unsure, false_positives_top10 = n_blank,
      top10_flagged_ineligible = NA_integer_,
      precision_status = sprintf("kappa=%.3f %s", ifelse(is.na(agr$kappa), NA, agr$kappa), pass_text(agr$kappa, PASS_KAPPA_MIN)),
      recall_status = "(this row: labeled_in_top10 = items both labeled, recall_at_25 = percent agreement, misses = unsure labels, false_positives = blank labels)")
    cat(sprintf("\n== %s ==\nitems both labelled: %d | percent agreement: %.1f%% | kappa: %s | unsure labels: %d | blank labels: %d | disagreements: %d\n",
        ag, agr$n, 100 * agr$pct, ifelse(is.na(agr$kappa), "NA", sprintf("%.3f", agr$kappa)), n_unsure, n_blank, nrow(disag)))
  }
  S <- rbindlist(summ, fill = TRUE); D <- rbindlist(detail, fill = TRUE); G <- rbindlist(disag_all, fill = TRUE)
  fwrite(S, file.path(out_dir, "scores_summary.csv")); fwrite(D, file.path(out_dir, "scores_items_detail.csv"))
  fwrite(G, file.path(out_dir, "labeler_disagreements_to_discuss.csv"))
  options(width = 220); print(S[rule != "agreement", .(agency = substr(agency, 1, 30), rule, method, precision_at_10, labeled_in_top10,
          recall_at_25, relevant_in_pool, misses_outside_top25, false_positives_top10, precision_status, recall_status)])
  short <- S[rule != "agreement" & method == "ranker" & labeled_in_top10 < TOP_K_PRECISION]
  if (nrow(short)) cat("\nWARNING: for the ranker, fewer than 10 of its top 10 were labeled (", paste(unique(short$agency), collapse = "; "),
      "). Precision@10 rests on fewer items. Fix: rerun make_label_sheets.R with the ranking file BEFORE labeling.\n", sep = "")
  cat("\nStrict = both labelers say yes. Lenient = either says yes. Both are shown; neither is 'the' answer.\n",
      "Disagreements are listed in labeler_disagreements_to_discuss.csv for the two labelers to resolve out loud.\n",
      "Numbers are on the labeled pool only (about 30 items per agency): indicative, not proof.\n", sep = "")
  invisible(list(summary = S, detail = D))
}

if (sys.nframe() == 0 && !interactive() && length(grep("score_labels.R", commandArgs(FALSE))) > 0) score_main(commandArgs(TRUE))
