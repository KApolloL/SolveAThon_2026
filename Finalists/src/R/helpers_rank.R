# helpers_rank.R: turn opportunities.csv and the agency goal table into the
# agency x opportunity table that score.R ranks. Pure functions; sourced by
# 10_run_ranking.R and the tests. Thresholds come from 00_config.R.
#
# Keyword fit is TF-IDF cosine between one opportunity (title + summary) and an agency's
# full plan text, centered per opportunity (see build_pairs). `fit_fn` is the one swappable scoring function:
# Azure embeddings can replace keyword_fit() without touching anything else.
# Requires dplyr, stringr, Matrix.

suppressPackageStartupMessages({ library(dplyr); library(stringr); library(Matrix) })

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
