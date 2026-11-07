# Hostile-judge pass on the award-history backtest (Evaluate only)

> Numbers updated Sat Nov 7 (~5:30 pm) after the overseas-embassy filter (`us_based` in `criteria.csv`); new values from `src/docs/fact_sheet.md`. Edited by Kent's docs-sync Claude session.

Draft by Everett's Claude, from an Opus read-only pass; I spot-checked the figure and wording claims and fixed two in my own files. Numbers only from `src/docs/fact_sheet.md` (row given). Unverified by a human. Kent owns `backtest_framing.md` and the slide brief.

## Six hard questions, honest answers
1. **"Isn't the first test circular?"** Yes, it kept only won programs already in the top 50; `backtest_framing.md:29` says so. The fair-denominator v2 reaches 59 of 159 won programs in the Top 10 (row 26).
2. **"Doesn't this reward repeat funding?"** Yes. The match is by program, not notice (row 15). It cannot score a good new opportunity; we have no number for one.
3. **"You built v2 after v1 failed."** Do not call it a pass. The pre-set bar failed: 1 of 3 agencies (row 15), and a deadline sort scored higher in all 3 (row 16). v2 is exploratory, 4 of 12 at the same 50% line (row 28); tuning changed nothing (row 30).
4. **"Intervals are huge."** Agreed. DPI 2 of 3 (row 15) is not a result. Only the pooled 159 (rows 26, 29) carries weight, and it mixes agencies of very different size. No pooled interval is in the fact sheet.
5. **"Where does 21 days come from?"** A team assumption, not a sponsor figure. The in-time count (42 of 59) is fact sheet row 32 (4-week windows).
6. **"DHHS does worst."** First test 4 of 11 (row 15). The v2 DHHS count is not in the fact sheet; say "weakest case" only.

## Overreaches to fix (owner)
- `backtest_framing.md:32` "ranking beats both baselines once the denominator is fair": pooled only; by agency the deadline sort is at or above the tool for Commerce, DEQ, DHHS and DNCR (Kent).
- `backtest_framing.md:40` "keyword method is at its ceiling": a 9-setting grid cannot show a ceiling (Kent).
- E2 timing paragraph: fixed in my file (two different in-time measures; see note there).
- Pooled figure title said "later won": awards have no link to a notice, so "later" cannot be shown. Fixed to "won".
- Figure numbers not in the fact sheet, so not to be spoken: Top 20 bars, Top 50 deadline 53% and random 41%, the in-time 41. Noted in the script header.
- Not disclosed: in the first test the random baseline tied the tool for DPI and beat it for DEQ and DHHS (`backtest_result.csv`, 4-week rows). Not in the fact sheet; if asked, it shows the first denominator was broken (Kent decides whether to add).
- `slide_brief.md:35` points to `backtest_recall_v2.png`; check the right figure file goes on the slide (my three figures are `backtest_v2_*.png`) (Kent).

## Biggest weakness and the tradeoff to write down
The only outcome test measures recall on programs agencies already win; the pre-set version failed and lost to a deadline sort (rows 15, 16). We have no evidence the tool finds new good-fit grants. Tradeoff: widening Top 10 to Top 50 raises recall from 37% to 63% (rows 26, 27) at five times the reading load for a part-time staffer. The cheaper fix, embeddings, is untested (`backtest_framing.md:17`).
