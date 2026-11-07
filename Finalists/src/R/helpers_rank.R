# helpers_rank.R: turn opportunities.csv and the agency goal table into the
# agency x opportunity table that score.R ranks. Pure functions; sourced by
# 10_run_ranking.R and the tests. Thresholds come from 00_config.R.
#
# Keyword fit is TF-IDF cosine between one opportunity (title + summary) and an agency's
# full plan text, centered per opportunity (see build_pairs). `fit_fn` is the one swappable scoring function:
# Azure embeddings can replace keyword_fit() without touching anything else.
# Requires dplyr, stringr, Matrix.

suppressPackageStartupMessages({ library(dplyr); library(stringr); library(Matrix); library(readr) })

# Short English stop list; IDF over the whole corpus takes care of grant boilerplate.
STOPWORDS <- c("the", "and", "for", "with", "that", "this", "from", "are", "will", "its", "our",
               "their", "into", "all", "each", "not", "but", "can", "has", "have", "been", "who",
               "which", "these", "those", "such", "than", "they", "them", "also", "may", "any",
               "other", "more", "most", "through", "within", "under", "over", "about", "between",
               "was", "were", "you", "your", "his", "her", "how", "what", "when", "where", "while",
               "goal", "goals", "objective", "pillar", "priority", "nbsp", "amp", "http", "https", "www")

kw_tokenize <- function(x) {
  x <- tolower(ifelse(is.na(x), "", x))
  toks <- strsplit(str_replace_all(x, "[^a-z]+", " "), " ", fixed = TRUE)
  lapply(toks, function(t) {
    t <- t[nchar(t) >= 3 & !t %in% STOPWORDS]
    t <- sub("ies$", "y", t)
    sub("([^su])s$", "\\1", t)          # crude plural strip: grants -> grant, keeps "class", "status"
  })
}

# Rows of a sparse TF-IDF matrix, L2-normalised. Sublinear tf (1 + log tf).
tfidf <- function(tok_list, vocab, idf) {
  i <- rep(seq_along(tok_list), lengths(tok_list))
  j <- match(unlist(tok_list), vocab)
  keep <- !is.na(j)
  m <- sparseMatrix(i = i[keep], j = j[keep], x = 1, dims = c(length(tok_list), length(vocab)))
  m@x <- 1 + log(m@x)
  m <- m %*% Diagonal(x = idf)
  norms <- sqrt(rowSums(m^2)); norms[norms == 0] <- 1
  Diagonal(x = 1 / norms) %*% m
}

# opp_text, goal_text: character vectors. Returns a dense opp x goal cosine matrix.
keyword_fit <- function(opp_text, goal_text) {
  ot <- kw_tokenize(opp_text); gt <- kw_tokenize(goal_text)
  all_t <- c(ot, gt)
  vocab <- sort(unique(unlist(all_t)))
  df <- tabulate(match(unlist(lapply(all_t, unique)), vocab), nbins = length(vocab))
  idf <- log((1 + length(all_t)) / (1 + df)) + 1
  as.matrix(tfidf(ot, vocab, idf) %*% t(tfidf(gt, vocab, idf)))
}

# Clean opportunities: unique ids, ceiling 0 is unknown, far-future and past forecast dates
# become unknown with a note, days left from the reference date.
prep_opportunities <- function(opps, ref_date, far_future = FAR_FUTURE_DATE) {
  opps <- opps[!duplicated(opps$opp_id), ]
  cd <- as.Date(opps$close_date)
  ceiling <- suppressWarnings(as.numeric(opps$award_ceiling))
  opps |> mutate(
    award_ceiling = ifelse(!is.na(ceiling) & ceiling > 0, ceiling, NA_real_),
    log_ceiling = log10(award_ceiling),
    date_note = case_when(
      is.na(cd) | cd >= far_future ~ "rolling or no date listed",
      status == "forecasted" & cd < ref_date ~ "date listed has passed",
      TRUE ~ NA_character_),
    close_date = if_else(is.na(date_note), cd, as.Date(NA)),
    days_left = as.integer(close_date - ref_date),
    opp_text = paste(title, ifelse(is.na(summary), "", summary)))
}

# Active agencies and their goals (folded plans join their target; dropped plans leave).
agency_goals <- function(goals, amap) {
  amap <- amap |> mutate(target = coalesce(fold_into, agency_id))
  goals |>
    inner_join(filter(amap, is.na(drop_reason)) |> select(plan_file, agency_id = target), by = "plan_file") |>
    filter(is.na(duplicate_of_row)) |>
    mutate(goal_text = str_squish(paste(goal_text_exact, coalesce(goal_statement, ""))),
           goal_key = paste(agency_id, plan_file, goal_id, sep = "|"))
}

# Full plan text per active agency (folded plans join their target agency).
plan_texts <- function(amap, dir_text) {
  am <- amap |> filter(is.na(drop_reason)) |> mutate(target = coalesce(fold_into, agency_id))
  sapply(split(am$plan_file, am$target), function(f)
    paste(unlist(lapply(file.path(dir_text, sub("pdf$", "txt", f)), readLines, warn = FALSE)), collapse = " "))
}

# One row per agency x opportunity.
# fit: keyword fit of the opportunity to the agency's FULL plan, centered per opportunity
# (minus its mean fit over all agencies, so boilerplate that matches every plan cancels),
# floored at 0 and divided by the agency's best, giving 0..1. Goal headings alone ranked
# badly in testing (see AI_USAGE_LOG.md), so goal_id and goal_snippet are display only:
# the best-matching goal heading for that pair.
build_pairs <- function(opps, ag, plans, fit_fn = keyword_fit) {
  sim <- fit_fn(opps$opp_text, plans)
  colnames(sim) <- names(plans)
  cen <- sim - rowMeans(sim)
  gsim <- fit_fn(opps$opp_text, ag$goal_text)
  out <- lapply(names(plans), function(a) {
    raw <- pmax(cen[, a], 0); top <- max(raw)
    cols <- which(ag$agency_id == a)
    gs <- gsim[, cols, drop = FALSE]
    best <- max.col(gs, ties.method = "first")
    has <- gs[cbind(seq_len(nrow(gs)), best)] > 0
    tibble(agency_id = a, opp_id = opps$opp_id,
           fit_raw = cen[, a], fit = if (top > 0) raw / top else 0,
           goal_id = ifelse(has, ag$goal_id[cols[best]], NA),
           goal_snippet = ifelse(has, ag$goal_text_exact[cols[best]], NA))
  })
  bind_rows(out)
}

# ---- Eligibility ------------------------------------------------------------------
# Step 2, fixed text rules, per opportunity. Returns "yes" / "no" / NA (undecided) and the
# exact matched text as the quote. A "no" phrase wins; "yes" phrases are void when a
# negation sits just before them.
text_eligibility <- function(text) {
  t <- ifelse(is.na(text), "", text)
  no_re  <- regex(paste(ELIG_TEXT_NO, collapse = "|"), ignore_case = TRUE)
  yes_re <- regex(paste(ELIG_TEXT_YES, collapse = "|"), ignore_case = TRUE)
  neg_re <- regex(ELIG_TEXT_NEGATION, ignore_case = TRUE)
  no_q <- str_extract(t, no_re); neg_q <- str_extract(t, neg_re); yes_q <- str_extract(t, yes_re)
  call <- case_when(!is.na(no_q) | !is.na(neg_q) ~ "no", !is.na(yes_q) ~ "yes", TRUE ~ NA_character_)
  tibble(text_call = call, text_quote = coalesce(no_q, neg_q, yes_q))
}

# Step 1 (codes) then step 2 (text) per agency x opportunity.
# Returns eligibility yes | no | ask, elig_source code | rule, elig_quote (exact text or NA).
assign_eligibility <- function(agency_id, codes, text) {
  has <- function(c) vapply(codes, function(x) !is.na(x) && any(strsplit(x, "|", fixed = TRUE)[[1]] %in% c), logical(1))
  yes_code <- has(ELIG_YES_CODES)
  he_ok <- has(ELIG_HIGHER_ED_CODE) & agency_id %in% ELIG_HIGHER_ED_AGENCIES
  ask_code <- has(ELIG_ASK_CODES) | is.na(codes) | codes == ""
  tx <- text_eligibility(text)
  decided <- !is.na(tx$text_call)
  tibble(
    # A text phrase can rule an item out but never confirm it: "state governments" also appears in lists
    # of who is NOT the target (EPSCoR, Fair Housing). Text "yes" stays "ask" with its quote shown.
    eligibility = case_when(yes_code | he_ok ~ "yes", ask_code & decided & tx$text_call == "no" ~ "no",
                            ask_code ~ "ask", TRUE ~ "no"),
    elig_source = case_when(yes_code | he_ok ~ "code", ask_code & decided ~ "rule", TRUE ~ "code"),
    elig_quote  = if_else(!(yes_code | he_ok) & ask_code & decided, tx$text_quote, NA_character_))
}

# TRUE when a title names another US state or region and not North Carolina.
geo_other <- function(title) {
  t <- ifelse(is.na(title), "", title)
  other <- str_detect(t, regex(paste0("\\b(", paste(GEO_OTHER_PLACES, collapse = "|"), ")\\b"), ignore_case = TRUE))
  other & !str_detect(t, regex("\\bNorth Carolina\\b|\\bNC\\b", ignore_case = TRUE))
}

# Program map: adds map_note and lifts fit to MAP_FIT_FLOOR for agency x Assistance Listing pairs in the table.
apply_program_map <- function(items, cfda_list, pmap) {
  hit <- vapply(seq_len(nrow(items)), function(i) {
    m <- pmap$why[pmap$agency_id == items$agency_id[i] & pmap$cfda %in% strsplit(cfda_list[i], "[|,; ]+")[[1]]]
    if (length(m)) m[1] else NA_character_
  }, character(1))
  items$map_note <- hit
  items$fit <- ifelse(!is.na(hit), pmax(items$fit, MAP_FIT_FLOOR), items$fit)
  items
}

# ---- Shared steps for 10_run_ranking.R, 11_build_payload.R and 12_backtest.R ------------
read_criteria <- function(path = CRITERIA_FILE) {
  cr <- read_csv(path, show_col_types = FALSE, col_types = cols(.default = col_character()))
  cr$weight <- if ("weight" %in% names(cr)) suppressWarnings(as.numeric(cr$weight)) else NA_real_
  cr
}

# Cleaned opportunities (all statuses), the agency goal table and the full plan texts.
load_rank_inputs <- function() {
  chr <- cols(.default = col_character())
  amap <- read_csv(AGENCY_MAP_FILE, show_col_types = FALSE, col_types = chr)
  opps <- prep_opportunities(read_csv(OPPS_FILE, show_col_types = FALSE, col_types = chr), REF_DATE)
  opps$post_date <- as.Date(opps$post_date)
  list(opps = opps, amap = amap,
       pmap = read_csv(PROGRAM_MAP_FILE, show_col_types = FALSE, col_types = chr),
       ag = agency_goals(read_csv(GOALS_FILE, show_col_types = FALSE, col_types = chr), amap),
       plans = plan_texts(amap, file.path(DIR_PROCESSED, "agency_plan_text", "all")))
}

# One row per agency x opportunity with fit, goal match, dates, award and eligibility.
build_items <- function(opps, ag, plans, pmap) {
  items <- build_pairs(opps, ag, plans) |>
    left_join(opps[, c("opp_id", "opp_number", "title", "status", "post_date", "close_date", "date_note", "days_left",
                       "award_ceiling", "log_ceiling", "cost_sharing", "applicant_types", "eligibility_text")], by = "opp_id") |>
    mutate(id = paste(agency_id, opp_id, sep = ":"))
  items <- bind_cols(items, assign_eligibility(items$agency_id, items$applicant_types, items$eligibility_text))
  items$eligibility_text <- NULL
  items$geo_other <- geo_other(items$title)
  items$fit <- ifelse(items$geo_other, items$fit * GEO_PENALTY, items$fit)
  apply_program_map(items, opps$cfda_list[match(items$opp_id, opps$opp_id)], pmap)
}

# Rank inside each agency (needs score.R sourced). Returns the ranked and dropped rows with agency_id.
rank_by_agency <- function(items, cr) {
  res <- lapply(split(items, items$agency_id), function(it) rank_items(it, cr, REF_DATE, ID_COL, NAME_COL, top_n = Inf))
  tag <- function(part) bind_rows(lapply(names(res), function(a) mutate(res[[a]][[part]], agency_id = a, .before = 1)))
  list(ranked = tag("ranked"), dropped = tag("dropped"))
}
