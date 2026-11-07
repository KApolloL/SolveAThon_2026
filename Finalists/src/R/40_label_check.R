# 40_label_check.R: held-out check for the model labels (prompt evalpool-v3).
# Base R only (no packages), no outside calls. Run from Finalists/src/:
#   Rscript R/40_label_check.R stage=draw
#
# WHY: prompt v3 was written and gated on the 60 validate items (kappa 0.44, in-sample).
# A fair check needs items that were NOT used for that, labelled by people who never
# see model output. stage=draw makes those blind sheets. Nothing here fills a label,
# and the draw never looks at any model label.
#
# stage=draw   writes, in drafts/claude/docs/holdout/:
#   holdout_labeler_A.csv, holdout_labeler_B.csv   same 30 items, different order; blind
#   goals_for_labelers.md                          the agencies' plan goals, exact text
#   holdout_key_DO_NOT_OPEN.csv                    item_no -> opp_id and how it was drawn
# (stage=score comes after both sheets are filled; not written yet.)
#
# Draw rule (written before any label exists): per agency, from the open pool
# (status posted, forecasted or notice) minus the 60 validate items,
#   N_TOP    items with the most plan-goal words in title + summary (ties by opp_id), then
#   N_RANDOM items drawn at random from the rest (seeded).
# Known bias: the top-match half favours what keyword overlap finds, so recall can be
# overstated; the random half is the guard. About 30 items cannot prove anything: one
# item moves recall by several points.

# TODO move to 00_config.R
HOLDOUT_AGENCIES <- c("Department of Justice", "Department of Agriculture and Consumer Services",
                      "Department of Labor")   # model-labelled, not in the validate set
N_TOP <- 5
N_RANDOM <- 5
HOLDOUT_SEED <- 2026
POOL_STATUSES <- c("posted", "forecasted", "notice")
FAR_FUTURE <- as.Date("2029-12-31")   # decision 8: later dates read "rolling or no date listed"
SUMMARY_CHARS <- 500
# Words too common in plans and notices to count as a match (short list; a judgment call)
GENERIC_WORDS <- c("north","carolina","state","states","department","program","programs","public",
  "service","services","improve","ensure","support","strengthen","across","throughout","advance",
  "expand","enhance","leading","excellence","operations","efficiency","collaboration","customer",
  "community","communities","local","provide","work","using","goals","every","people","system",
  "systems","national","federal","future","serve","working","fully","change","grant","grants",
  "funding","award","awards","project","projects","applicants","application","information",
  "development","management","include","includes","including","based","their","which","through")

args <- commandArgs(TRUE)
stage <- sub("^stage=", "", grep("^stage=", args, value = TRUE)[1])
if (is.na(stage) || stage != "draw") stop("Usage: Rscript R/40_label_check.R stage=draw")
if (!dir.exists("../data/processed")) stop("Run this from Finalists/src/.")

opps  <- read.csv("../data/processed/opportunities.csv", stringsAsFactors = FALSE,
                  colClasses = c(opp_id = "character", opp_number = "character"))
goals <- read.csv("docs/agency_goal_summaries.csv", stringsAsFactors = FALSE)
# ids of the 60 validate items, read ONLY to exclude them (no hand labels are read)
val_key <- read.csv("../drafts/claude/eval/sheets/key_hidden_DO_NOT_SHARE.csv", stringsAsFactors = FALSE,
                    colClasses = c(opp_id = "character"))
validate_ids <- unique(val_key$opp_id)
stopifnot(nrow(val_key) == 60)   # 60 items = 55 unique grants (5 appear under two agencies)

clean_text <- function(x) {
  x <- gsub("&amp;", "&", x, fixed = TRUE); x <- gsub("&#8217;|&#39;|&rsquo;", "'", x)
  x <- gsub("&#8211;|&ndash;", "-", x); x <- gsub("&quot;|&#8220;|&#8221;", "\"", x)
  x <- gsub("&nbsp;", " ", x, fixed = TRUE); trimws(gsub("\\s+", " ", x))
}
or_unknown <- function(x) { x <- as.character(x); ifelse(is.na(x) | !nzchar(trimws(x)), "unknown", x) }
words_of <- function(x) unique(unlist(strsplit(tolower(gsub("[^A-Za-z ]", " ", x)), " +")))

pool <- opps[opps$status %in% POOL_STATUSES & !(opps$opp_id %in% validate_ids), ]
pool$text <- tolower(clean_text(paste(pool$title, pool$summary)))
cat("Pool after excluding validate items:", nrow(pool), "rows\n")

picked <- list()
for (ai in seq_along(HOLDOUT_AGENCIES)) {
  ag <- HOLDOUT_AGENCIES[ai]
  g <- goals[!is.na(goals$agency) & goals$agency == ag, ]
  if (nrow(g) == 0) stop("Agency not found in goals file: ", ag)
  terms <- setdiff(words_of(paste(g$goal_text_exact, collapse = " ")), c(GENERIC_WORDS))
  terms <- terms[nchar(terms) >= 5]
  pool$score <- vapply(pool$text, function(t) sum(vapply(terms, grepl, TRUE, x = t, fixed = TRUE)), 0)
  ord <- pool[order(-pool$score, pool$opp_id), ]
  top <- head(ord[ord$score > 0, ], N_TOP)
  rest <- sort(setdiff(pool$opp_id, top$opp_id))
  set.seed(HOLDOUT_SEED + ai)
  rnd_ids <- sample(rest, N_RANDOM)
  cat(ag, ":", length(terms), "goal words;", nrow(top), "top matches +", length(rnd_ids), "random\n")
  sel <- rbind(
    data.frame(agency = ag, opp_id = top$opp_id, source = "top_match", match_score = top$score, stringsAsFactors = FALSE),
    data.frame(agency = ag, opp_id = rnd_ids, source = "random", match_score = pool$score[match(rnd_ids, pool$opp_id)], stringsAsFactors = FALSE))
  picked[[ag]] <- sel
}
sel <- do.call(rbind, picked)
if (anyDuplicated(sel$opp_id)) {   # an item drawn for two agencies would be labelled twice; keep first
  sel <- sel[!duplicated(sel$opp_id), ]; warning("duplicate item across agencies removed")
}
set.seed(HOLDOUT_SEED + 100); sel <- sel[sample(nrow(sel)), ]
sel$item_no <- seq_len(nrow(sel))
m <- merge(sel, opps, by = "opp_id", sort = FALSE); m <- m[order(m$item_no), ]
stopifnot(nrow(m) == nrow(sel), !any(m$opp_id %in% validate_ids))

is_notice <- m$status == "notice"
cd <- suppressWarnings(as.Date(m$close_date))
close_txt <- ifelse(is_notice, "no deadline (notice)", ifelse(is.na(cd), "no date listed",
             ifelse(cd > FAR_FUTURE, "rolling or no date listed", format(cd))))
aw <- suppressWarnings(as.numeric(m$award_ceiling))
award_txt <- ifelse(is_notice, "none (notice)", ifelse(is.na(aw), "unknown",
             ifelse(aw == 0, "unknown (listed as 0)", format(aw, scientific = FALSE, big.mark = ","))))
base <- data.frame(item_no = m$item_no, agency_for_fit = m$agency.x, opp_number = m$opp_number,
  title = clean_text(m$title), funder = clean_text(or_unknown(m$agency.y)), status = m$status,
  close_date = close_txt, award_ceiling = award_txt,
  summary_short = substr(clean_text(or_unknown(m$summary)), 1, SUMMARY_CHARS), url = or_unknown(m$url),
  stringsAsFactors = FALSE)

out_dir <- "../drafts/claude/docs/holdout"; dir.create(out_dir, showWarnings = FALSE, recursive = TRUE)
for (lb in c("A", "B")) {
  sh <- base
  if (lb == "B") { set.seed(HOLDOUT_SEED + 200); sh <- sh[sample(nrow(sh)), ] }
  sh$labeler <- lb; sh$label <- ""; sh$note <- ""   # label: relevant / maybe / not relevant
  write.csv(sh, file.path(out_dir, paste0("holdout_labeler_", lb, ".csv")), row.names = FALSE, na = "")
}
write.csv(data.frame(item_no = sel$item_no, agency = sel$agency, opp_id = sel$opp_id,
                     source = sel$source, match_score = sel$match_score),
          file.path(out_dir, "holdout_key_DO_NOT_OPEN.csv"), row.names = FALSE)

gl <- c("# Plan goals for the held-out labelers", "",
  "Exact text from each agency's strategic plan (`src/docs/agency_goal_summaries.csv`). Label every item for the agency named in its `agency_for_fit` column.",
  "", "- **relevant**: this agency's grant writer would want to look at it.",
  "- **maybe**: unclear from the notice.", "- **not relevant**: no.", "",
  "Work alone. Do not open any model output, rank, score or the key file. AI must not fill, suggest or check a label.", "")
for (ag in HOLDOUT_AGENCIES) {
  g <- goals[!is.na(goals$agency) & goals$agency == ag, ]
  gl <- c(gl, paste0("## ", ag), "", paste0("- ", gsub("\\s+", " ", g$goal_text_exact)), "")
}
writeLines(gl, file.path(out_dir, "goals_for_labelers.md"))
cat("Wrote", nrow(base), "items to", out_dir, "\n")
print(table(sel$agency, sel$source))
