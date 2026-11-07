# stage-judge-evaluate, Sat Nov 7 2026, ~10:40 am, main 95fed84

Judged: `data/processed/backtest_result.csv`, `src/R/12_backtest.R`, `20_backtest_awards.R`, `21_audit_clearinghouse.R`, `data/manual/*`, `src/docs/fact_sheet.md`, `src/docs/qa_cheatsheet.md`, `drafts/claude/eval/`, `drafts/claude/docs/field_notes_draft.md`, `saturday/01_goals.md`, `saturday/02_decisions.md`, `AI_USAGE_LOG.md`, `handoff.md`. Read-only git for dates. I did not run `run_tests.R` or `check_facts.R`. To check the arithmetic I replicated the logic of `20_backtest_awards.R` in a scratch R script (outside the repo, read-only on repo files); on the current `rankings_backtest.csv` it reproduces all nine rows of `backtest_result.csv` exactly (caught, pct, interval, both baselines). So the DERA lift (244df5a, 10:19) and the geography penalty did not change the result.

Stale statements noticed or relied on:
- `testing/context.md` says the success test is a 20-item hand-labelled pool with a 70% bar, and that `criteria.csv`, the ranking file and `payload.json` do not exist. All superseded. Saturday decision 7 (award-history backtest, 50% bar) is now the main evidence.
- `drafts/claude/docs/field_notes_draft.md` (Fri night) still says the success test is the 70% pool bar, "no evaluation has been run", and the measured number is `[TO FILL]`. Stale.
- `handoff.md` status table (Fri 9 pm) says evaluation, fact sheet, scoring "not started". Stale.
- `drafts/claude/eval/README.md` and `pool_rules.md` describe the pool test. Its hand-label sheets are empty (0 of 20 rows labelled in the two sheets I opened) and there is no `results/` folder, so that test has not run.

## 1. Score

**3 of 5.** The team fixed a bar in writing at 1:17 am, ran it, and its own commit message says the bar "fails" and is "evidence, not tuned"; that is what this criterion rewards. But the denominator is built from the tool's own top 50, both baselines are drawn from that same top 50, and the result is in no fact, no Q&A answer and no field note yet. The headline is "one agency in three passes, and the tool does no better than a random pick from its own shortlist".

## 2. Backtest verdict table (4-week rows are the bar; 2 and 6 weeks shown for context)

Pass bar: at least 50% in each agency at 4 weeks, 2 of 3 agencies. Interval = Clopper-Pearson 95% as in the file.

| agency | window | won | caught | pct | interval | deadline baseline | random baseline | passes bar? | beats baselines? |
|---|---|---|---|---|---|---|---|---|---|
| dpi | 2 wk | 4 | 2 | 50% | 7-93% | 100% | 50% | n/a | no (below deadline, ties random) |
| **dpi** | **4 wk** | **3** | **2** | **67%** | **9-99%** | **100%** | **67%** | **yes (bar met)** | **no (below deadline, ties random)** |
| dpi | 6 wk | 4 | 2 | 50% | 7-93% | 75% | 50% | n/a | no |
| deq | 2 wk | 9 | 3 | 33% | 7-70% | 89% | 56% | n/a | no |
| **deq** | **4 wk** | **7** | **3** | **43%** | **10-82%** | **71%** | **57%** | **no** | **no (below both)** |
| deq | 6 wk | 7 | 3 | 43% | 10-82% | 71% | 57% | n/a | no |
| dhhs | 2 wk | 11 | 4 | 36% | 11-69% | 82% | 73% | n/a | no |
| **dhhs** | **4 wk** | **11** | **4** | **36%** | **11-69%** | **73%** | **64%** | **no** | **no (below both)** |
| dhhs | 6 wk | 11 | 3 | 27% | 6-61% | 55% | 36% | n/a | no |

**Verdict:** 1 of 3 agencies passes at 4 weeks (DPI only, on 2 of 3 programs), so the pre-set bar of 2 of 3 is **not met**; and at 4 weeks the tool is below the soonest-deadline baseline in all three agencies and below the random baseline in two (tie in DPI).

## 3. One honest sentence for the stage

"On our own pre-set test, only 1 of 3 agencies cleared the 50% bar (DPI 2 of 3 programs; DEQ 3 of 7; DHHS 4 of 11), and a soonest-deadline list did as well or better in every one, so on this test the ranking adds nothing yet over sorting by deadline." (All numbers from `backtest_result.csv`; the baseline caveat in finding 2 should be said with it.)

## 4. Evaluation inventory

| check | ran? | result | file |
|---|---|---|---|
| Award-history backtest, 3 agencies, 4-week bar | yes (Everett 10:02, reproduced by me on current rankings) | bar not met, 1 of 3; below both baselines in 5 of 6 agency comparisons at 4 weeks | `data/processed/backtest_result.csv`, `src/R/20_backtest_awards.R` |
| Binomial intervals | yes | 6-99%; every interval overlaps every baseline | same |
| Two baselines | yes, but drawn from the tool's top 50, not from all open notices | deadline and random both at or above the tool | same, line 76 |
| In-time curve (21-day) | computed in the script, **not written to the CSV**; only in the figure | not reported in any text | `outs/figures/backtest_recall.png` |
| Model-label check (decision 3) | yes, in-sample, one labeler | FAIL: kappa 0.44 against 0.60; hand "relevant" = 3 of 60 items, DEQ has 0 | `drafts/claude/eval/model_labels/agreement_report.md`, `gate.txt` |
| Held-out label check after 10:00 (decision 3) | no | n/a | none |
| Notice-reader spot check (decision 9, Noah 30 items) | no: `data/manual/reader_spotcheck.csv` does not exist and no reader script exists | n/a | none |
| Human checks | yes, 15 rows: DERA eligibility (yes, with quote), school-bus window (not the "one month" in discovery notes; DERA runs about four months), 10 far-future dates, codes 25 and 99 | useful; mostly data-quality, not output quality | `data/manual/sat_checks.csv` |
| Quote checks | plan goals: 56 of 56 (per handoff, `tests/test_plan_tables.R`) | pass; reasons and notice quotes: not yet | `handoff.md` |
| Hand-label pool, 70% recall (Friday plan) | no: sheets empty, no `results/` | n/a | `drafts/claude/eval/` |
| Human check of a top 10 for false positives | no | none | none |
| Unit and integration tests | yes (manager): 78 of 79 pass; 17 of 17 facts | one test, "R and JS agree", pending | manager's report |
| Second awards source (Audit Clearinghouse) | checked, not available | script writes a "not available" CSV; no data pulled | `src/R/21_audit_clearinghouse.R` |

## 5. Findings

| # | where | problem | severity | suggested fix |
|---|---|---|---|---|
| 1 | `src/R/20_backtest_awards.R:80-82` | The denominator is described as "won programs that had an open notice" (`saturday/01_goals.md:33`) but is coded as won programs that appear in the tool's own rank 1-50 for that agency and window length. Recall at rank 50 is therefore 100% by construction (I checked: 3 of 3, 7 of 7, 11 of 11). From `opportunities.csv` and the award map, the won programs that had any closed notice in range are 8 (DPI), 15 (DEQ) and 32 (DHHS), against 3, 7 and 11 reported. With those denominators the same catches are about 25%, 20% and 13% (my scratch calculation, upper bounds). The reported pass for DPI depends on this filter. | high | Redo the denominator from `opportunities.csv` closed items in range matched to the award map, independent of rank. Report both and say which is the bar. |
| 2 | `src/R/20_backtest_awards.R:76,99-107` | Both baselines take their "soonest deadline 10" and "random 10" from `sub`, which is already the tool's top 50, not from all open notices. They are the tool's shortlist re-sorted, not independent comparators. A random 10 of the tool's own 50 beating its top 10 shows the ranking inside the shortlist adds nothing on this measure, but it does not show how the tool compares with a plain deadline sort of everything. Also "caught" is a union over 26 four-week windows, and so is each baseline. | high | Draw baselines from all open items in each window (needs the full ranked list, not the 50-row file), and state what they mean. |
| 3 | `src/docs/fact_sheet.md` (14 rows, none on the backtest), `src/docs/qa_cheatsheet.md` (blank), `data/manual/facts.csv` | The backtest, the team's main Evaluate evidence, is in no fact, no Q&A answer and no `check_facts.R` row, and the team's slide rule is "numbers only from the fact sheet". Everett's brief says Kent adds them. As of 10:40 there is nothing a presenter may say. | high | Add the nine 4-week numbers plus the verdict as facts with a check, and fill the "biggest weakness" Q&A row. |
| 4 | `saturday/01_goals.md:33` and `drafts/claude/docs/field_notes_draft.md:85,200` | Two incompatible success tests are in the repo. Field notes and the eval kit say "70% recall on a 20-item hand-labelled pool"; the Saturday goals say "50% of won programs, 2 of 3". A judge reading the notes will look for a number the team no longer computes. The pool test has no filled labels. | high | Say in the field notes that decision 7 replaced the pool test, and that the pool test was not run; delete or label the 70% text. |
| 5 | `data/processed/nc_awards_by_cfda.csv` via `20_backtest_awards.R:38` (comment says FY2022-2026) | The won set is every program the agency has ever won in the file: last-award years run 2014 to 2027 (DHHS 90 programs, DEQ 41, DPI 17), and the comment's FY2022-2026 is wrong. A program last won in 2014 counts as a "win" for a notice in 2025, and awards after a window are used as the answer for it. | medium | Restrict to awards in the test period (or before each window), or state the span as a limit; fix the comment. |
| 6 | `data/processed/backtest_result.csv` | The CSV drops the in-time columns (`caught_intime`, `pct_intime`) that the script computes and plots; goals item 3 promised the in-time curve. The figure carries a number that no file does. | medium | Write the in-time columns to the CSV and a fact. |
| 7 | whole repo | No false positive measure exists. There is no human check of any top 10 (precision), the notice reader (decision 9) and its spot check do not exist, the hand-label sheets are empty, and the 3 hand-relevant items behind kappa 0.44 cannot support a kappa at all. The organizers named false positives as a threat. | high | One human pass over the DPI, DEQ and DHHS top 10: relevant, maybe, not, with a quote. Report x of 30. |
| 8 | `data/processed/backtest_result.csv` (n = 3 to 11) | With 3 to 11 programs, intervals of 6-99% mean no agency can be called better or worse than either baseline, and one program moves DPI by 33 points. The file shows the intervals but nothing says so. | medium | Add a line to the fact sheet: "counts too small to separate the tool from either baseline"; keep the counts beside every percentage. |
| 9 | `saturday/01_goals.md:33`, `data/manual/agency_award_map.csv` | The measure is "has won before", which favors repeat funding. The code comment and goals say so; the only recipients mapped are the six state-agency names. DHHS lab and Durham schools are excluded and listed, which is good. A win only shows the agency is eligible and capable, not that the tool found a good match or that a lead was missed. | medium | Say this in one sentence beside the number; do not use the word "missed" (the script already avoids it). |
| 10 | `data/manual/program_map.csv`, `AI_USAGE_LOG.md` last row | DERA reaches the top 10 only because a hand map lifts its fit to 0.8; the log says the map exists "because the keyword fit missed DERA". Honest, but it means the named worked example is hand-placed, not found by the ranking, and rank 84 / 754 before the lift is the real fit result. | medium | Present DERA as a known failure of keyword fit that a map patched, with ranks before and after. |
| 11 | pass bar history | The 50% bar and "2 of 3" were written at 01:17 am (commit 1feebcb) before the ranking existed (first real `rankings_backtest.csv` c21e486, 09:57; first result 09:46 stub, 10:02 real) and the bar lines were not changed in e6d8561 (09:14). That is good. But Kent's scoring changed twice in the 25 minutes around the first real run (geography penalty 10:00, DERA map 10:19). Neither changed the result (I reproduced it), but the order should be stated. | low | Say in the notes that the bar was set before any ranking and was not moved after a fail. |
| 12 | `saturday/01_goals.md:33-37` | "Say so on the slide" that 50% is a team judgment: file `src/R/20_backtest_awards.R:15` says it, no slide brief exists yet (`deliverables/slide_brief_TEMPLATE.md` only). | low | Put it in the slide brief. |

## 6. Three hardest questions and the answer the files support

1. **"Your own bar was 2 of 3 at 50%. Did you pass?"** No. At 4 weeks DPI 2 of 3 (67%), DEQ 3 of 7 (43%), DHHS 4 of 11 (36%), so 1 of 3. The bar was set at 1:17 am before any ranking and not moved. What the files do not yet support: whether it would pass on a denominator that does not depend on the tool's own top 50 (finding 1).
2. **"Is that better than just sorting by deadline?"** On this test, no: the soonest-deadline top 10 caught 100%, 71% and 73% and a random 10 caught 67%, 57% and 64% in the same windows. But the intervals (6-99%) overlap everything, and both baselines are drawn from the tool's own top 50, so the files cannot say how the tool compares with a deadline sort of all open notices.
3. **"What is your false positive rate?"** The files have none. Recall against programs the agency has won is the only measured quantity; there is no human-checked top 10 and the notice reader spot check (decision 9) does not exist. The honest answer today is "not measured; we can do 30 items by 2 pm", and only if someone does it.

## 7. [cannot assess]

- Whether the 12:15 Merge 3 or a later rerun changes `backtest_result.csv` (I judged the file as of the 10:02 commit; it matches current rankings).
- Whether the figure `outs/figures/backtest_recall.png` matches the CSV (I did not open it); the in-time numbers.
- Whether the award map covers all state-agency recipient spellings (692 rows in `nc_awards_recipients.csv`; I checked only that six names are confirmed).
- Whether the 15 `sat_checks.csv` entries are right on the notice pages (I did not open any page; Matthew's note says he still must confirm).
- Anything said at the 9:30 faculty slots (F1, F2 in `saturday/04_mentor_questions.md`); `saturday/mentor_log.md` is empty.
- Whether any other evaluation was run on other machines or branches (Noah's label check, `origin/*` branches).
- Time-to-first-match or user value; no real user has used the tool.
