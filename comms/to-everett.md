# Outbox: Everett's Claude

Append only. Only Everett's Claude writes here. Created because to-kent.md is Noah's Claude's outbox per comms/README.md.

## 2026-11-07 claude/everett-work
Done: connected; branched from main (comms/ already there). Read comms/README.md, tasks.md, all outboxes and the CLAUDE.md files. Claimed E1 (v2 backtest figure) and built it: `Finalists/src/R/23_backtest_v2_figure.R` (not 22: `22_backtest_tune.R` exists) plus `outs/figures/backtest_v2_pooled.png` and `backtest_v2_by_agency.png`. Reads `backtest_v2_result.csv` only; no edits to your files. Pooled 4-week shares from the CSV match fact sheet rows 26 to 29: Top 10 36% vs 17% deadline vs 13% random (157 programs); Top 50 61%. The script is offline; no outside call made.
Blocked: the in-time line (01_goals.md:80). `backtest_v2_result.csv` has no in-time column and `21_backtest_v2.R` is Kent's file. Not drawn; stated in the script header.
Need from Kent: either add an in-time count (21 days before close, `IN_TIME_DAYS`) to `21_backtest_v2.R` and the CSV, or say no. Also, odd items for you: (1) many untracked `Finalists/src/data/cache/llm/*.json` files, under `src/` not `data/`, probably a run from the wrong folder; (2) your handoff says Azure is not deployed but Marco's outbox says it is live; every fact-sheet row still reads "Kent to confirm".
Next: wait for Everett's OK to open a PR; then E2 (why won programs missed the Top 10) if no one else claims it.

## 2026-11-07 claude/everett-work (2)
Done: PR #66 (E1) was merged by a human. Claimed and built E2: `Finalists/src/R/24_backtest_misses.R` (offline, ~1 min, reads only) writes `data/processed/backtest_misses.csv`; draft note `Finalists/drafts/everett/backtest_error_analysis.md`. It reproduces fact rows 26 and 27 (57 and 95 of 157). Of the 157 won programs, 38 rank 11 to 50 and 62 rank below 50 (median best rank 167 in a pool of about 750); none was dropped by a gate. DHHS: 19 of 30 below rank 50. Deadline timing does not separate flagged from not flagged. Keyword gap is the likeliest cause but is NOT tested (only titles looked at).
Need from Kent: say whether any of these numbers should go in the fact sheet (I do not edit it); say whether he wants the word-level keyword test.
Next: open a PR for E2 when Everett says; otherwise wait.
