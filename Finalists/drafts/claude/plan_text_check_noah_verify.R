norm <- function(x) trimws(gsub("[[:space:]]+", " ", x))
chk <- read.csv("src/docs/plan_text_check_noah.csv", stringsAsFactors=FALSE)
gs <- read.csv("src/docs/agency_goal_summaries_noah.csv", stringsAsFactors=FALSE)
man <- read.csv("data/raw/agency_plans/MANIFEST.csv", stringsAsFactors=FALSE)[1:17,]
stopifnot(identical(names(chk), strsplit("agency,file,pages,text_extractable,chars_extracted,goals_section_found,goals_page,goals_quote,plan_years,notes",",")[[1]]))
stopifnot(identical(chk$file, man$file), identical(chk$agency, man$agency), !anyDuplicated(chk$file))
bad <- 0
for (i in seq_len(nrow(gs))) {
  tx <- readLines(file.path("data/processed/agency_plan_text/noah", sub("\\.pdf$",".txt",gs$plan_file[i])), warn=FALSE, encoding="UTF-8")
  pgidx <- grep("^=== PAGE ", tx); s <- pgidx[gs$plan_page[i]]; e <- if (gs$plan_page[i] < length(pgidx)) pgidx[gs$plan_page[i]+1]-1 else length(tx)
  page <- norm(paste(tx[s:e], collapse=" "))
  q <- sub("\\.\\.\\.$","",gs$goal_text_exact[i])
  if (!grepl(q, page, fixed=TRUE)) { bad <- bad+1; cat("NOT FOUND on page:", i, q, "\n") }
}
for (i in seq_len(nrow(chk))) {
  tx <- readLines(file.path("data/processed/agency_plan_text/noah", sub("\\.pdf$",".txt",chk$file[i])), warn=FALSE, encoding="UTF-8")
  pgidx <- grep("^=== PAGE ", tx); p <- chk$goals_page[i]; e <- if (p < length(pgidx)) pgidx[p+1]-1 else length(tx)
  page <- norm(paste(tx[pgidx[p]:e], collapse=" ")); q <- sub("\\.\\.\\.$","",chk$goals_quote[i])
  if (!grepl(q, page, fixed=TRUE)) { bad <- bad+1; cat("QUOTE NOT FOUND:", i, q, "\n") }
  if (length(strsplit(chk$goals_quote[i]," ")[[1]]) > 25) cat("long quote", i, "\n")
  # char count check
  cat(sprintf("%s pages_in_txt=%d csv=%d\n", chk$file[i], length(pgidx), chk$pages[i]))
}
cat("failures:", bad, " check rows:", nrow(chk), " goal rows:", nrow(gs), "\n")
