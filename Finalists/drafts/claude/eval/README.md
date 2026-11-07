# Evaluation kit (draft, for Kent to approve)

Purpose: check, with human judgment, whether the ranked list is useful, and compare it with what a plain keyword search would give. People label. AI does not.

## What is in this folder
- `make_label_sheets.R`: builds the blind sheets (30 items per agency, two copies each: labeler A and B).
- `keyword_baseline.R`: the simple comparison method (a keyword search). It is NOT our ranker, and generic words give it false positives.
- `score_labels.R`: computes the numbers from filled sheets.
- `test_metrics.R`: checks the math on made-up data. Run it first; it prints "N of N tests pass".
- `known_cases_draft.csv`: proposed must-pass and must-fail cases. Kent approves them.
- `sheets/`: the label sheets, plus a hidden key file. Labelers must never open the key.

## Steps
1. Kent decides (about 10 min): the two demo agencies (default `[assumed]`: Natural and Cultural Resources, Public Schools), and the pass marks. Pass marks go in the top of `score_labels.R` BEFORE anyone sees results. Until then the scorer shows numbers with no pass/fail.
2. Whoever has the ranking (about 5 min): when it lands, save a CSV with columns `agency, opp_id, rank` and run `Rscript make_label_sheets.R ranking.csv`. Do this BEFORE labeling so the ranker's picks are in the pool. Without it the pool holds only keyword-baseline hits and random items, and the ranker's top 10 will mostly be unlabeled.
3. Two labelers per agency, independently (estimate: 30 to 60 minutes each per 30-item sheet; not measured, try a few items first). Each opens only their own sheet in Excel or Sheets, reads the title, summary and link, and fills `relevant`, `eligible_state_agency`, `worth_the_effort` with yes, no or unsure, plus an optional note. Leave a cell blank only if you truly did not look.
4. Save the filled sheets back into `sheets/` under the same names.
5. Kent or a teammate runs `Rscript score_labels.R ranking=ranking.csv` (or without `ranking=` for the baseline alone). It writes tables into `results/`, including a list of items where A and B disagreed.
6. The two labelers talk through the disagreements together AFTER the first scoring. Record any change as a new file; do not overwrite the originals.

## Rules
- Label independently. Do not compare notes, and do not look at the app's ranking, scores, or the key file before you finish.
- AI must not fill any label or help decide one. A person reads the notice.
- "unsure" is allowed and counted. Do not guess to avoid it.
- "relevant" means: would this agency's grant writer want to look at it? "eligible_state_agency": could a state agency apply? "worth_the_effort": is the award worth the work?
- Disagreements are never settled silently. The scorer shows a strict rule (both say yes) and a lenient rule (either says yes) side by side.

## What the numbers mean, and what they cannot prove
- 30 items per agency is small. Treat results as indicative; one item moves precision@10 by 10 points.
- Recall is measured only against the labeled pool, not against all real opportunities. A relevant notice nobody sampled is invisible to us.
- Precision@10 counts only labeled items in the top 10 and reports how many were unlabeled.
- Agreement between two people shows the labels are consistent, not that they are right.
- The keyword baseline is a simple stand-in for a person's search, not the best possible search.
- These numbers do not prove the tool saves time, wins grants, or works for agencies we did not label.

## Known data issues (details in `known_cases_draft.csv`)
Missing and zero award amounts, missing or implausible close dates (47 after 2030), many forecasted items with past dates, and HTML codes in text. The sheets show unknown values as "unknown", never 0.
