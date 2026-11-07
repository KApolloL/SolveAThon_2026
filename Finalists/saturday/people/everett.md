# Everett: evidence (award-history backtest)

You are Everett's Claude. Read `../README.md` rules first. Everett is new to git: explain each git step in plain words, branch `everett/sat-<topic>`, never touch `main`.

## Goal
By 12:15: the award-history backtest result for DPI, DEQ and DHHS against the pass bar in `01_goals.md`, with counts, intervals and two baselines. Award data never goes into the score.

## You own
`src/R/20_backtest_awards.R`, `src/R/21_audit_clearinghouse.R`, `data/manual/agency_award_map.csv`, `outs/figures/backtest_*`.

## Inputs
- `data/processed/nc_awards_by_cfda.csv` (columns `cfda, recipient, n_awards, total_obligated, last_fy`) and `nc_awards_recipients.csv` (348 unclassified recipients; state agencies flagged by name, a heuristic).
- `data/processed/rankings_backtest.csv`: stub from Kent at 9:30, real at 11:00. Schema in `03_contract.md`.
- Background: `planning/09_tool_plan_update.md`, section "Evaluation, no new labels". Earlier closed-row counts from a quick name match: Public Schools 30 (8 programs), DEQ 47 (15), DHHS 133 (38). These are estimates. Recompute.

## Pass bar (fixed, do not change after looking)
At least 50% of each agency's won programs that had an open notice in the backtest period appear in its top 10 in at least one 4-week window. Pass if 2 of 3 agencies hit it. Report counts, binomial interval, and two baselines (soonest-deadline top 10, random 10 with a fixed seed). Also compute at 2 and 6 weeks.

## Steps
1. **9:30 to 11:00.** Build `agency_award_map.csv`: map USAspending recipient names to `agency_id` for the three agencies. Write down every uncertain match. Write `20_backtest_awards.R` against Kent's stub. Ask faculty F1 and F2 with Matthew at 9:30 to 10:30 and adjust the reporting if Kaiying advises.
2. **11:00 to 12:15.** Run on the real `rankings_backtest.csv`. Write the result to `data/processed/backtest_result.csv` (`agency_id, window_weeks, won_programs, caught, pct, ci_low, ci_high, baseline_deadline_pct, baseline_random_pct`) and a figure in `outs/figures/`.
3. **12:15 onward.** In-time version: a catch counts only if at least 21 days remained before close at the end of the window (X = 21 is a team assumption). Two lines: all catches, in-time catches.
4. **2:30.** Check whether the Federal Audit Clearinghouse gives NC awards by state agency (C) [uncertain]. If yes, add it as a second source and report by agency. If no, write "not available" in your handoff and stop.

## Rules specific to this lane
- Say "would have flagged" and "programs this agency has won". Never say "missed".
- Report by agency. Never one statewide number.
- The program-level match favors repeat funding; state that limit beside the result.
- Tell Kent the result whatever it is. A failed bar is evidence for the field notes, not something to rerun until it passes.

## Done means
- [ ] `backtest_result.csv` exists and reruns identically.
- [ ] Each result row shows counts and an interval.
- [ ] Every unmatched or uncertain recipient is listed.

## Handoff
To Kent: `backtest_result.csv`, the figure, the uncertain-match list, and a one-paragraph limits note for the fact sheet. Kent adds the numbers to `fact_sheet.md`; you do not.
