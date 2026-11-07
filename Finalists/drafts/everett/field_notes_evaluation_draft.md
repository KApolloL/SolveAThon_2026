# Field notes: Evaluation and AI-error rows (draft by Everett's Claude, for Kent and Noah)

> Numbers updated Sat Nov 7 (~5:30 pm) after the overseas-embassy filter (`us_based` in `criteria.csv`); new values from `src/docs/fact_sheet.md`. Edited by Kent's docs-sync Claude session.

Paste-ready text for `drafts/claude/docs/field_notes_draft.md` section 9 ("Evidence") and section 7. Numbers only from `src/docs/fact_sheet.md` (row given) unless marked "not a fact row". Unverified by a human; nothing here is user evidence.

## A. Evaluation results (fills the `[TO FILL]` for "recall versus shortlist length")
Test: the award-history backtest. For programs a state agency has already won money from, would the tool have put an open notice for that program in the agency's list? 4-week windows, program-level match (it favors repeat funding), 12 agencies with 3 or more won programs, 159 won programs.

| Shortlist length | Won programs reached | Fact row |
|---|---|---|
| Top 10 | 59 of 159 (37%) | 26 |
| Top 20 | 74 of 159 (47%) before the embassy filter; not a fact row, not rechecked (`backtest_v2_result.csv`) |
| Top 50 | 100 of 159 (63%) | 27 |

Baselines at Top 10: soonest deadline first 19.5%, a random 10 about 14% (row 29). So the measured named weakness is: recall rises with shortlist length, and a Top 10 still leaves most won programs out.

Recorded failures (say these plainly):
1. The test we set in advance failed: the bar was 50% of won programs in 2 of 3 agencies; DPI 2 of 3, DEQ 3 of 7, DHHS 4 of 11, so 1 of 3 passed (row 15).
2. A soonest-deadline sort beat the tool in all 3 agencies on that test (row 16).
3. The model-label gate failed twice (Noah and Matthew's blind check; `drafts/claude/docs/holdout/label_check_result.md`; figures not yet fact rows).
4. Tuning the text fit on 9 settings, checked on held-out agencies, adopted nothing (row 30).
5. DHHS is the weakest case: 4 of its 30 won programs reach the Top 10 and none with 21 or more days left (`backtest_v2_intime.csv`; not a fact row).

What we did after the failure (exploratory, built after seeing the result, so not a pass): a fairer denominator (every won program with an open notice in the pool), more agencies (18 mapped, 12 with 3+), Top 10, 20 and 50 (rows 26 to 29).

Why some won programs are not in the Top 10 (`backtest_misses.csv`, `backtest_keyword_gap.csv`; not fact rows): of 159, 39 rank 11 to 50 and 62 rank below 50; none was hidden by an eligibility rule. The 62 all score under their agency's Top-10 median keyword fit. That is consistent with a keyword gap, not proof; a 10-row hand check (provisional tags) split 4 on-mission, 4 off-mission, 2 other.

In time (not a fact row, 21 days is our assumption): 42 of the 59 Top 10 catches had 21 or more days left (row 32, 4-week windows).

## B. Section 7 rows (AI wrong, how caught). From this Saturday's work, all in the log or outbox
Columns match section 7: # | What happened | Kind | Who caught it, and how | Check in repo. Numbering continues after row 11.

| 12 | **AI-written count was wrong.** Everett's Claude's closeout draft said the award map had 36 rows with 29 confirmed. A recount from the CSV gave 35 and 28. | **Model content** | Caught by recounting from the file when checking another claim; corrected the same day (`comms/to-everett.md` entry 6, `drafts/everett/backtest_lane_closeout.md`). | `data/manual/agency_award_map.csv` row count |
| 13 | **Overclaim in an AI analysis.** The miss analysis said deadline timing "does not separate" programs that reach the Top 10 from those that do not. The shares were 65%, 82% and 77% under 21 days, which is not "no difference". | **Model content** | A hostile-judge subagent read flagged it; also found that two different "in time" counts (37 of 57 vs 41 of 57) were easy to confuse. Reworded (`drafts/everett/backtest_error_analysis.md`, `backtest_hostile_judge.md`). | `drafts/everett/backtest_error_analysis.md` item 4 |
| 14 | **Figure title the data cannot support.** The first pooled backtest figure was titled "programs NC agencies later won". Awards have no link to a notice, so "later" cannot be shown. | **Model content** | Hostile-judge read; title changed in `src/R/23_backtest_v2_figure.R`. | `src/R/23_backtest_v2_figure.R` |
| 15 | **Subagent left a table empty.** A subagent reported the keyword-gap hand-tag table done; it had only the header. | **Tool/agent failure** | Caught by reading the output file before committing; filled from the CSV. | `drafts/everett/backtest_keyword_gap.md` |

Caveat for all four: found by the same Claude session or its subagents, not by an outside person.
