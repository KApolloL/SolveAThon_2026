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

## 2026-11-07 claude/everett-work (3)
Done: PR #72 (E2) opened. Built E3, E4, E5 with three subagents; all drafts under `Finalists/drafts/everett/`, new files only. E3 `ai_disclosure_draft.md` (Kent and Marco own the real one; gaps listed: PromptLab not in log, saved prompts missing). E4 `src/R/25_backtest_keyword_gap.R` + CSV + note: the 62 below-rank-50 notices all score under their agency's Top-10 median (median fit 0.102 vs 0.540), 11 have fit exactly 0; this is near-circular by construction, so it is consistent with a keyword gap but not proof; DPI shows many shared words yet low fit. A 10-row hand-tag table awaits Everett. E5 `pilot_one_pager_draft.md` from fact-sheet rows, placeholders for length, agencies, cost, decision, owner, date.
Need from Kent: fill the E5 placeholders; say whether the E3 draft should replace or feed your disclosure. The script prints "NOTE: using TOY EXAMPLE data" from shared code on every run, though the numbers match the fact sheet; please confirm it is harmless.
Next: PR for E3 to E5 after Everett hand-tags the 10 rows.

## 2026-11-07 claude/everett-work (4)
Done: read Kent's, Noah's and Marco's outboxes; nothing is addressed to me and I see no file clash (my files are all new, under `Finalists/drafts/everett/`, `src/R/23` to `25`, `outs/figures/backtest_v2_*`). Everett asked me to do the E4 hand-tags myself: I tagged the 10 sample rows as PROVISIONAL (4 real gap, 4 off-mission, 2 other) from titles and general knowledge of NC agencies, marked [unverified], for Everett to overwrite. Opened a PR for E3 to E5.
For Kent and Marco: E2 and E4 both point to DHHS as the weak agency (19 of 30 won programs below rank 50). Marco's note that the "Start here" top picks can lead with a research-heavy DHHS item fits the same pattern. I am not proposing a score change; that is Kent's file.
Need from you: Kent, fill the E5 placeholders and decide whether E3 feeds your disclosure; confirm the "TOY EXAMPLE data" printout is harmless. Marco: no request.
Next: watch for replies; then idle unless a task is added to `tasks.md`.
