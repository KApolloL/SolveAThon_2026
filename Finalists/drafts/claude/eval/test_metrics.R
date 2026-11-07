# test_metrics.R -- hand-computed FAKE data (ids "x1".. are made up; nothing real).
here <- dirname(normalizePath(sub("^--file=", "", commandArgs(FALSE)[grep("^--file=", commandArgs(FALSE))][1])))
source(file.path(here, "score_labels.R"))
n_pass <- 0L; n_all <- 0L
check <- function(name, got, want, tol = 1e-9) {
  n_all <<- n_all + 1L
  ok <- if (is.na(want)) is.na(got) else (!is.na(got) && abs(got - want) < tol)
  if (ok) n_pass <<- n_pass + 1L else cat("FAIL:", name, "got", got, "want", want, "\n")
}

# FAKE ranking of 12 items, best first; verdict TRUE = relevant.
ids <- paste0("x", 1:12)
v <- setNames(c(TRUE,FALSE,TRUE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,TRUE,TRUE), ids)
# top 10 has 2 relevant (x1,x3) -> precision@10 = 0.2 ; relevant total 4 ; top 5 has 2 -> recall@5 = 0.5
check("precision@10", precision_at_k(ids, v, 10)$value, 0.2)
check("precision@3", precision_at_k(ids, v, 3)$value, 2/3)
check("recall@5", recall_at_k(ids, v, 5)$value, 0.5)
check("recall@12", recall_at_k(ids, v, 12)$value, 1)

# Missing labels: x2 and x4 unlabeled; top 4 -> labeled x1 T, x3 T -> precision 1, 2 unlabeled
v2 <- v; v2[c("x2","x4")] <- NA
p <- precision_at_k(ids, v2, 4)
check("precision with missing", p$value, 1); check("unlabeled count", p$n_unlabeled, 2)
# all unlabeled -> NA, no relevant -> recall NA
check("precision all NA", precision_at_k(ids, setNames(rep(NA, 12), ids), 10)$value, NA)
check("recall no relevant", recall_at_k(ids, setNames(rep(FALSE, 12), ids), 10)$value, NA)

# Empty ranking
check("precision empty ranking", precision_at_k(character(0), v, 10)$value, NA)
check("recall empty ranking", recall_at_k(character(0), v, 25)$value, 0)

# Ties: ids b,a,c all rank 1, d rank 2 -> order a,b,c,d (broken by id)
check("tie order", as.numeric(identical(order_ids(c("b","a","c","d"), c(1,1,1,2)), c("a","b","c","d"))), 1)
# tie at the cut: k=2 takes a,b; relevant only c -> precision 0 (deterministic)
check("tie at cut", precision_at_k(order_ids(c("b","a","c","d"), c(1,1,1,2)), c(a=FALSE,b=FALSE,c=TRUE,d=FALSE), 2)$value, 0)

# Kappa, hand computed. 10 items: A = yes x5 then no x5; B agrees on 4 yes, 4 no (2 disagree: one each way).
a <- c(rep("yes",5), rep("no",5)); b <- c(rep("yes",4), "no", "yes", rep("no",4))
# po = 8/10 = 0.8 ; A yes .5 no .5 ; B yes .5 no .5 ; pe = .25+.25 = .5 ; kappa = .3/.5 = 0.6
ag <- agreement(a, b); check("pct agreement", ag$pct, 0.8); check("kappa", ag$kappa, 0.6)
# perfect agreement with both always "yes": pe = 1 -> kappa NA, not a crash
check("kappa undefined", agreement(rep("yes",4), rep("yes",4))$kappa, NA)
# missing labels dropped: last two NA -> only 8 compared (all agree here)
check("agreement drops NA", agreement(c("yes","no","yes",NA), c("yes","no",NA,"no"))$n, 2)
# Cohen's kappa 0 for chance-level: A yes,yes,no,no ; B yes,no,yes,no -> po .5, pe .5 -> 0
check("kappa zero", agreement(c("yes","yes","no","no"), c("yes","no","yes","no"))$kappa, 0)

# Strict vs lenient, with unsure and blank
A <- c("yes","yes","no","unsure",NA); B <- c("yes","no","no","yes","yes")
check("strict", sum(combine_verdict(A, B, "strict"), na.rm = TRUE), 1)
check("lenient", sum(combine_verdict(A, B, "lenient"), na.rm = TRUE), 3)
check("blank stays NA", as.numeric(is.na(combine_verdict(A, B, "lenient")[5])), 1)

cat(n_pass, "of", n_all, "tests pass\n")
if (n_pass != n_all) quit(status = 1)
