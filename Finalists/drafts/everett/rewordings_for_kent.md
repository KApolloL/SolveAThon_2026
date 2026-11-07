# Exact rewordings for the overreach lines (draft by Everett's Claude; Kent pastes, I edit none of his files)

> Historical note (Sat Nov 7, ~5:30 pm): this file records an earlier change and is kept as written. After the overseas-embassy filter the current values are in `src/docs/fact_sheet.md` (Top 10 59 of 159, Top 50 100, baselines 19.5% and 14.0%, in-time 4-week 42 of 59, hidden pairs 4,758).

Source: `backtest_hostile_judge.md`. Numbers shown are the NEW ones after the award-map promotions (58 of 159); update first, then paste.

## `src/docs/backtest_framing.md` line 32 (Reading, v2)
Now: "the ranking beats both baselines once the denominator is fair, but most won programs still do not reach the Top 10."
Replace with: "Pooled over the 159 won programs, the ranking reaches more than a soonest-deadline sort or a random 10 (36% vs 17% and about 13 to 14% at Top 10). By agency the picture is mixed: the deadline sort is at or above the ranking for Commerce, DEQ, DHHS and DNCR, and agencies are small. Most won programs still do not reach the Top 10. The denominator fix is our own judgment, built after the first test failed, so this does not rescue the pre-set bar."

## `src/docs/backtest_framing.md` line 40 (Reading, tuning)
Now: "the keyword method is at its ceiling with this plan text."
Replace with: "a 9-setting grid found nothing better, so this keyword method is not easy to improve by tuning; that is not proof of a ceiling. A different kind of matching (embeddings) is untested."

## Slide brief slide 4 (`deliverables/slide_brief.md:35`)
Now: names `backtest_recall_v2.png` (exists, Kent's) as the optional figure.
Add: "Alternative, draft figures from Everett's Claude: `backtest_v2_pooled.png` (Top 10/20/50 vs deadline vs random), `backtest_v2_by_agency.png`, `backtest_v2_intime.png`. Speak only numbers in the fact sheet: the Top 20 bars, Top 50 baselines and in-time counts are not in it unless you add them."

## Optional fact-sheet line the judge asked about (Kent decides)
"In the pre-set test the random baseline tied the tool for DPI and beat it for DEQ and DHHS (`backtest_result.csv`, 4-week rows). This shows the first test's denominator was shaped by the ranking being tested." Source: `data/processed/backtest_result.csv`; not currently a fact row.

## Numbers in `backtest_framing.md` lines 31 to 40 that change with the map
Top 10 57 to 58 and 157 to 159; Top 20 72 to 74 (47%); Top 50 95 to 97 (61%); tuning 61 vs 57 and 40 of 157 become 63 vs 58 and 41 of 159; the held-out fold counts (28 of 79, 26 vs 29 of 78) were NOT re-read by me and need a look at `backtest_tune_result.csv`.
