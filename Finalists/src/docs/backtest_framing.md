# Backtest framing for the slide and Q&A

Numbers below come from `data/processed/backtest_result.csv` (Everett, `src/R/20_backtest_awards.R`) and are in `fact_sheet.md` rows 15 and 16 (facts f18 to f22). Do not quote a figure that is not in the fact sheet.

## What we say
- We tested whether the tool would have put, in an agency's Top 10, the programs that agency actually won money from. We set the bar before running it: at least 50% of won programs per agency, on 4-week windows, in 2 of 3 agencies.
- We did not meet the bar. DPI caught 2 of 3 programs, DEQ 3 of 7, DHHS 4 of 11. Only DPI is at or above 50%.
- A plain sort by soonest deadline did at least as well in all three agencies on the same test. This test does not show that our ranking beats a deadline sort.
- We did not change the bar or the scoring after seeing this.

## Why we still think the tool is useful
- The test only counts programs an agency has already won. It cannot reward a new, good-fit opportunity the agency has never applied to, which is what the tool is for. A deadline sort that surfaces everything closing soon will always look good on repeat-funding programs.
- The sample is small (3 to 11 won programs per agency) and the intervals are wide. DPI's 2 of 3 spans roughly 9% to 99%.
- The tool does things a deadline sort cannot: it removes opportunities the agency cannot apply to, shows the plan goal each match comes from, flags tribal-only and other-state items, and puts the national DERA program in front of DEQ and DPI.

## Named weakness (for the Evaluating criterion)
Keyword fit to the plan text is the likeliest source of misses. A program can be a real match and use words the plan never uses. The fix is better matching (Azure embeddings), not a lower bar. We have not tested that.

## What to say if asked
- "Missed": say "would not have flagged", not "missed".
- "Why not tune it until it passes": the bar was set before the run; moving it after looking would make the result meaningless.
- "Is 50% right": it is a team judgment, not derived. Say so.
- Do not use model labels as evidence. The held-out label check failed its gate on about 30 items (Noah, `drafts/claude/docs/holdout/label_check_result.md`), and model labels are not in the payload.

## Open
- Kent to confirm this framing before it goes on a slide.

## Step 1 fix of the measure (v2, exploratory; the failed bar above stands)
- Problem found in the first test: a won program only counted if it already sat in the stored top 50, so the denominator was shaped by the ranking being tested. Recall could not be widened past Top 10 and was inflated by that filter.
- v2 (`src/R/21_backtest_v2.R`) counts every won program with an open notice in the agency's full pool for the window, adds Top 20 and Top 50, and adds 15 more agencies mapped by exact recipient name (18 in all, 12 with 3 or more won programs). Same ranking, same 4-week windows. Baselines use the same pool.
- Result, 4-week windows, 12 agencies, 159 won programs: Top 10 reaches 60 (38%), Top 50 reaches 101 (64%) (fact rows 26, 27; after the overseas-embassy filter and the region-list fix, Sat Nov 7). Top 20 was 74 (47%) before that filter and is not a fact row. A soonest-deadline sort reaches about 19.5% at Top 10 and a random 10 about 14% (row 29). Four of 12 agencies are at or above 50% in the Top 10.
- Reading: pooled over the 159 won programs, the ranking reaches more than a soonest-deadline sort or a random 10 (38% vs 19.5% and about 14% at Top 10). By agency the picture is mixed: the deadline sort is at or above the ranking for Commerce, DEQ, DHHS and DNCR, and agencies are small. Most won programs still do not reach the Top 10. This does not rescue the pre-set bar: the original test failed it and that stays reported. v2 is exploratory and was built after seeing the first result.
- Still true: program-level match favors repeat funding; denominators are small for many agencies (see `backtest_v2_result.csv` for intervals); notice-level match is impossible because the award data has no link to a notice. Exact-name agency rows were assigned by Claude and need Kent's confirmation (DNCR's older "Cultural Resources" names are the least certain).

## Step 2: tuning the text fit with held-out agencies (exploratory, tuned after seeing results)
- `src/R/22_backtest_tune.R` tried 9 text settings (title repeated 1 to 3 times, and three ways to center fit across agencies). Award data only chose among settings; it never enters the shipped score.
- Method: the 12 agencies were split into two folds; the best setting on one fold was scored on the other, both directions.
- Result: no setting beat the current one on held-out agencies in both directions (fold A to B: tie, 28 of 80; B to A: worse, 27 vs 30 of 79). The best overall (spread-scaled centering) gains 5 programs of 159 (63 vs 58), within noise. Nothing was adopted.
- One real finding: removing the centering across agencies drops recall to 41 of 159 (26%). The centering is doing real work.
- Reading: a 9-setting grid found nothing better, so this keyword method is not easy to improve by tuning; that is not proof of a ceiling. The honest next lever is better matching (embeddings), which we have not tested. Say this under the named weakness.

## Reach: against a new-postings alert (bonus quest 1, exploratory)
The brief asks how many opportunities we catch that manual monitoring might miss. We had no measured baseline from coordinators, so we used a stand-in: a new-postings alert, read newest first, which is the plain Grants.gov habit. Same 12 agencies, same 159 won programs, same windows as v2, Top 10. The alert reaches 34 won programs; our list reaches 60. Ours reaches 38 the alert misses, and the alert reaches 12 ours misses (fact sheet row 31). Limits: the stand-in is our assumption, not coordinator behavior; program-level match and small denominators still apply; this was built after the first backtest. Say "against a newest-first alert", never "against manual monitoring".
