# Noah: extra data, label check, docs

You are Noah's Claude. Read `../README.md` rules first. Noah is new to git: explain each git step in plain words, branch `noah/sat-<topic>`, never touch `main`.

## Goal
Pull the extra datasets (A county need, B SAM listings), run the held-out check on the overnight model labels at 10:00, spot-check the notice reader, and keep the field notes and fact-sheet inputs moving.

## You own
`src/R/05a_county_need.R`, `src/R/05b_sam_listings.R`, `src/R/40_label_check.R`, `data/manual/label_holdout.csv`, `data/manual/reader_spotcheck.csv`, `drafts/claude/docs/`.

## Steps
1. **By 9:00: B feasibility, 10 minutes.** Does a bulk SAM.gov Assistance Listings (CFDA catalog) file exist that avoids the key's rate limit? The SAM key allows too few calls for the 2,873 listings page by page (see `handoff.md`). Do not call the paged API. If a bulk file exists and is public, download it into `data/raw/` (note source in `data/raw/README.md`). If not, write "B not available" in your handoff and move to A.
2. **9:00 to 11:00: A.** Copy the qualifier's county need caches from `../QualifierChallenge/data/cache/api/` (ACS 2023 county, congressional district, state; CDC PLACES; HRSA mental health and primary care; FEMA declarations; NCHS drug poisoning; tigris boundaries) into `data/cache/api/`. Reuse the qualifier code (`../QualifierChallenge/src/R/01b_alignment.R`, `00_config.R` county need layers). Output: `data/processed/county_need.csv` (county, indicator, value, percentile). No new API calls: caches only. Display or score use is Kent's call at 11:00.
3. **10:00: label check.** Overnight labels finish. Find where the output was written (PR #12 was reverted; ask Kent). The model gate failed on the earlier set (kappa 0.44, in-sample). Score the labels only on items **not** used to write prompt v3. If no held-out items exist, make a held-out set of about 30 blind items: two people label them without seeing model output, write `data/manual/label_holdout.csv`. Report: caught share of hand "relevant", Cohen's kappa on relevant-plus-maybe versus not relevant. Gate is 80% catch and kappa 0.6. These labels stay out of the 1:00 payload either way.
4. **After 12:15.** Spot-check 30 notice-reader labels from Marco's output: label correct, quote appears in the source text. Write `reader_spotcheck.csv`.
5. **Afternoon.** Field notes drafts in `drafts/claude/docs/`: fill the `[TO FILL]` items. Include the label check result in the "AI was wrong and we caught it" section. Numbers come from `fact_sheet.md` only; if a number isn't there, write "not found" and tell Kent.

## Done means
- [ ] Each dataset has a source note and an access date.
- [ ] Label check reports counts and kappa, and states how the held-out set was made.
- [ ] No invented numbers in the drafts.

## Handoff
To Kent: PRs for each script, the label check result as a three-line summary, and the B feasibility answer by 9:00.

### B feasibility (Noah, 2026-11-07)
**B available.** A public bulk SAM.gov Assistance Listings CSV exists, so the paged API is not needed.
- Source: SAM.gov Assistance Listings bulk CSV, published by GSA (CC0). `https://s3.amazonaws.com/falextracts/Assistance%20Listings/datagov/AssistanceListings_DataGov_PUBLIC_CURRENT.csv`
- Accessed: 2026-11-07. Server last-modified: 2026-11-01. No API calls used.
- Local copy: `data/raw/sam_assistance_listings/AssistanceListings_DataGov_PUBLIC_CURRENT.csv` (22,196,202 bytes, 2,875 rows, 38 columns, encoding cp1252 not UTF-8).
- Statutory authority column: yes, `Authorization (040)`. Kent's question is answered.
- Open: handoff.md says 2,873 listings; the file has 2,875 rows. Not reconciled.
- Not done: no entry in `data/raw/README.md` (not a file Noah owns). Kent to add the source note there if wanted.
