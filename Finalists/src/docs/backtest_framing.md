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
