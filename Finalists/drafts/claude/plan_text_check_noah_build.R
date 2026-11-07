suppressMessages(library(pdftools))
m <- read.csv("data/raw/agency_plans/MANIFEST.csv", stringsAsFactors=FALSE)[1:17,]
pages <- lapply(m$file, function(f) pdf_text(file.path("data/raw/agency_plans", f))); names(pages) <- m$file
norm <- function(x) trimws(gsub("[[:space:]]+", " ", x))
# find first line matching rx on given pages; join n lines; optionally cut at first sentence end
grab <- function(file, pgs, rx, n=1, cut=FALSE) {
  for (p in pgs) {
    ln <- strsplit(pages[[file]][p], "\n")[[1]]; ln <- ln[nzchar(trimws(ln))]
    i <- grep(rx, ln)
    if (length(i)) {
      t <- norm(paste(ln[i[1]:min(length(ln), i[1]+n-1)], collapse=" "))
      if (cut) t <- sub("^(.*?[a-z0-9\\)]\\.)( .*)?$", "\\1", t, perl=TRUE)
      return(list(page=p, text=t))
    }
  }
  stop(sprintf("no match %s %s", file, rx))
}
wc <- function(x) length(strsplit(x, " ")[[1]])
cap <- function(t, k=24) { w <- strsplit(t," ")[[1]]; if (length(w)>k) paste0(paste(w[1:k],collapse=" "),"...") else t }
F <- m$file
# ---- first-goal specs for the check CSV: file, pages, regex, nlines, cut
fg <- list(
 list(F[1],12,"Prepare Each Student",1,FALSE),
 list(F[2],1,"Goal I-Eliminate",1,FALSE),
 list(F[3],8,"Goal I-Eliminate",1,FALSE),
 list(F[4],4,"^ *Goal 1:",3,TRUE),
 list(F[5],8,"^Goal 1:",2,FALSE),
 list(F[6],4,"1\\.\\s+Use evidence",2,FALSE),
 list(F[7],6,"^ *Goal 1 ",2,FALSE),
 list(F[8],5,"Goal 1 ",2,FALSE),
 list(F[9],4,"^Increase the number of transitioning",2,FALSE),
 list(F[10],5,"^Goal 1:",2,FALSE),
 list(F[11],5,"^ *• Our Customers",1,FALSE),
 list(F[12],8,"1\\. Impactful Audits",1,FALSE),
 list(F[13],9,"^Goal 1:",2,FALSE),
 list(F[14],4,"1\\.\\s+Goal: Consumer",3,FALSE),
 list(F[15],3,"^ *Goal 1:",1,FALSE),
 list(F[16],4,"^Goal 1:",2,FALSE),
 list(F[17],7,"^Recruit and retain",1,FALSE))
meta <- data.frame(
 file=F,
 gpage=c(12,1,8,4,8,4,6,5,4,5,5,8,9,4,3,4,7),
 years=c("2025 – 2030","8/8/2019-9/30/2027","8/8/2019-9/30/2027","2022-2026","2022-2027","2025 – 2029","2025 – 2029","2025 – 2029","2025 – 2029","2025-2029","2025-2029","2023 – 2025","2025–2029","unknown","2025 – 2029","FY 2026-2029","2025 – 2029"),
 ypage=c(1,1,1,1,1,1,1,1,1,1,1,1,69,NA,1,1,1),
 stringsAsFactors=FALSE)
notes <- c(
 "Statewide public-schools plan with 8 'pillars' (described p13 as 'thematic goals'); no numbered 'Goal 1'. Quote taken from the pillar list p12. Plan page numbers match PDF index.",
 "2-page web printout (SBE plan, printed 5/23/2024). 9 U+FFFD replacement characters (fi/fl ligatures lost, e.g. 'pro�cient'). Goals I-III on pp1-2. Board-level plan, not a department. Years are plan dates '8/8/2019-9/30/2027'.",
 "NOT AN AGENCY: SBE 'Guiding Principles' packet, 39 pp, same SBE 2027 plan header and Goal I text as row 2 (overlap with row 2 not fully checked). 50 U+FFFD characters (ligatures lost). Printed 5/23/2024.",
 "Plan ends 2026 [uncertain whether superseded]. Goals overview p4 (five goals); full goal chapters start p12. System office, not a department.",
 "University system, not a department. Plan 2022-2027 per cover. p21 has <50 chars (not visually checked). Two-column layout: text of later goals (3,5,10-12) is interleaved/spaced ('pro gres s'); goal summaries limited to cleanly extracted goals.",
 "Goals are numbered 1-4 under heading C; quote taken from PDF p4. Cover states 'Sept 12, 2025'.",
 "Five goals pp6-16 with objective/measure tables. Cover dated August 28, 2025.",
 "Seven goals pp5-7; goal list shown with asterisk note. Cover dated August 28, 2025. Plan p8 says next five-year plan scheduled for 2026 [per text].",
 "No 'Goal 1' wording: 'GOAL #1' heading then statement; quote is truncated to 24 words (full sentence continues on p4: '...through 2028.'). Four goals pp4-11. Years from cover p1.",
 "Cover shows '2025-2029' and 'SEPTEMBER 1, 2025'. Three goals on pp5-7.",
 "Goals/objectives/measures table pp11-16 is column-interleaved in extracted text (goal titles split across lines), so quote is the first of 'four key priorities' (p5), not a table goal. p2 short page (<50 chars, not visually checked).",
 "Plan years 2023 – 2025: likely expired [uncertain]. 'Strategic approaches (goals)' are three; quote is first. p2 short page (not visually checked).",
 "Cover (p1) and p4 have no extractable text (cover is an image). Years quoted from p69 'planning horizon'. Goals 1-4 start pp9, 30, 44, 59 (PDF index; printed TOC pages are one lower). 69 pp, 98,560 chars. The text also has 'Updates to 2023-25 Initiatives' (p11).",
 "Cover p1 is an image with no extractable text; viewing the rendered cover shows '2025 – 2029' but that was a visual check, not extracted text, so plan_years is unknown. Four goals pp4-11.",
 "Four goals pp3-4. Cover dated August 28th, 2025. Short plan (4 pp).",
 "Cover says 'FY 2026-2029'. Three goals pp4-6. p8 short (not visually checked).",
 "Five goals pp7-15. p2 short (not visually checked).")
ext <- c("yes","partial","partial","yes","yes","yes","yes","yes","yes","yes","yes","yes","partial","partial","yes","yes","yes")
rows <- lapply(seq_len(17), function(i) {
  g <- do.call(grab, setNames(fg[[i]],c("file","pgs","rx","n","cut")))
  q <- g$text; trunc <- wc(q) > 24; q <- cap(q)
  txt <- paste(pages[[F[i]]], collapse=" ")
  stopifnot(grepl(meta$years[i], norm(txt), fixed=TRUE) || meta$years[i]=="unknown")
  data.frame(agency=m$agency[i], file=F[i], pages=length(pages[[F[i]]]), text_extractable=ext[i],
    chars_extracted=sum(nchar(pages[[F[i]]])), goals_section_found="yes", goals_page=meta$gpage[i],
    goals_quote=q, plan_years=if (meta$years[i]=="unknown") "unknown" else sprintf('%s (p%d)', meta$years[i], meta$ypage[i]),
    notes=notes[i], stringsAsFactors=FALSE)})
out <- do.call(rbind, rows)
# chars_extracted: count of characters in the saved .txt of per-page text (pdftools), excl. page markers
write.csv(out, "src/docs/plan_text_check_noah.csv", row.names=FALSE, na="")
print(out[,c("file","pages","text_extractable","chars_extracted","goals_page","goals_quote","plan_years")], right=FALSE)

# ---------------- goal summaries (exact extracted text, no paraphrase) ----------------
G <- list()
add <- function(i, id, pgs, rx, n=1, cut=FALSE, flag="") { G[[length(G)+1]] <<- list(i=i,id=id,pgs=pgs,rx=rx,n=n,cut=cut,flag=flag) }
pil <- c("Prepare Each Student","Revere Public School","Enhance Parent","Ensure Healthy","Optimize Operational","Lead Transformative","Celebrate the Excellence","Galvanize Champions")
for (k in 1:8) add(1, paste0("Pillar ",k), 12, paste0("^\\s*",k,"\\.\\s*",pil[k]), 1, FALSE, "plan calls pillars 'thematic goals' (p13)")
add(2,"Goal I",1,"Goal I-"); add(2,"Goal II",1,"Goal II-"); add(2,"Goal III",2,"Goal III-")
add(3,"Goal I",8,"Goal I-"); add(3,"Goal II",1:39,"Goal II-"); add(3,"Goal III",1:39,"Goal III-")
for (k in 1:5) add(4,paste("Goal",k),4,paste0("^ *Goal ",k,":"),3,TRUE)
add(5,"Goal 1",8,"^Goal 1:",2); add(5,"Goal 2",10,"^Goal 2:",2,FALSE,"truncated at line wrap (two-column layout); other goals (3,5,10-12) not captured cleanly")
add(6,"Goal 1",4,"1\\.\\s+Use evidence",2); add(6,"Goal 2",4,"2\\.\\s+Advance technology",2)
add(6,"Goal 3",6,"3\\.\\s+Ensure a team culture",2); add(6,"Goal 4",7,"4\\.\\s+Foster a statewide",2)
for (k in 1:5) add(7,paste("Goal",k),6:16,paste0("^ *Goal ",k," "),3,TRUE)
for (k in 1:7) add(8,paste("Goal",k),5:7,paste0("Goal ",k," [–-]"),2)
add(9,"Goal 1",4,"^Increase the number of transitioning",2,TRUE); add(9,"Goal 2",6,"^Enhance the quality of care",6,TRUE)
add(9,"Goal 3",8,"^Strengthen sector collaboration",3,TRUE); add(9,"Goal 4",10,"^Empower, develop",1)
add(10,"Goal 1",5,"^Goal 1:",2,TRUE); add(10,"Goal 2",6,"^Goal 2:",1); add(10,"Goal 3",7,"^Goal 3:",2,TRUE)
for (k in c("Our Customers","Our People","Fiscal Sustainability","Technological Innovation")) add(11,paste("Priority:",k),5,paste0("^\\s*• ",k),1,FALSE,"strategic priority (p5); goals/objectives table pp11-16 is column-interleaved, not captured")
add(12,"Approach 1",8,"1\\. Impactful Audits",1,FALSE,"first line only; sentence continues past line wrap"); add(12,"Approach 2",8,"2\\. Operational Excellence",1,FALSE,"first line only; sentence continues past line wrap"); add(12,"Approach 3",8,"3\\. Culture of Excellence",1,FALSE,"first line only; sentence continues past line wrap")
for (k in 1:4) add(13,paste("Goal",k),c(9,30,44,59)[k],paste0("^Goal ",k,":"),2)
add(14,"Goal 1",4,"1\\.\\s+Goal: Consumer",3); add(14,"Goal 2",9,"2\\.\\s*Goal: Insurer",3)
add(14,"Goal 3",10,"3\\.\\s*Goal: Marketplace",3); add(14,"Goal 4",11,"4\\.\\s*Goal: Fraud",3)
for (k in 1:4) add(15,paste("Goal",k),3:4,paste0("^ *Goal ",k,":"),1)
for (k in 1:3) add(16,paste("Goal",k),4:6,paste0("^Goal ",k,":"),2)
add(17,"Goal 1",7,"^Recruit and retain"); add(17,"Goal 2",9,"^Continuously improve enterprise"); add(17,"Goal 3",12,"^Continually track statewide")
add(17,"Goal 4",13,"^Ensure state employees are paid"); add(17,"Goal 5",15,"^Provide statewide accounting support")
rows <- lapply(G, function(g) { r <- grab(F[g$i], g$pgs, g$rx, g$n, g$cut)
  data.frame(row=g$i, agency=m$agency[g$i], plan_file=F[g$i], plan_page=r$page, goal_id=g$id, goal_text_exact=r$text,
   text_type="verbatim extracted heading/statement (whitespace normalized)", extraction_flag=g$flag,
   classification_status="NEEDS KENT", classification_category="", stringsAsFactors=FALSE) })
gs <- do.call(rbind, rows)
gs$goal_text_exact <- sub(" (Performance Measures|Actions & Performance Measures|Office of State Treasurer)$", "", gs$goal_text_exact)
write.csv(gs, "src/docs/agency_goal_summaries_noah.csv", row.names=FALSE, na="")
print(gs[,c("row","plan_page","goal_id","goal_text_exact")], right=FALSE)
cat("rows:", nrow(gs), "\n")
