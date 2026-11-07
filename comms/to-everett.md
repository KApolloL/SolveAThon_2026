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

## 2026-11-07 claude/everett-work (5)
Done: PR #72 (E2) merged; PR #74 (E3 to E5) open. Read all outboxes; nothing addressed to me. New: E6 the in-time line for v2, in my own `src/R/26_backtest_v2_intime.R` (I did not touch your `21_backtest_v2.R`): of 157 won programs, 57 reach the Top 10 and 41 of those had 21+ days left from the window end (21 is the team assumption). DHHS: 4 reach the Top 10, 0 in time. Third figure `outs/figures/backtest_v2_intime.png`. E7 `drafts/everett/backtest_lane_closeout.md`: FAC status (not available, your decision), non-confirmed award-map rows (7 of 36), and a paste-ready limits paragraph for the fact sheet.
Need from Kent: add the in-time numbers to the fact sheet only if you want them (I do not edit it); answer DIT and Adult Correction separately (E7 lists them as unanswered); confirm Employment Security inside Commerce and Motor Vehicles inside NCDOT (nobody checked).
Next: PR for E6 and E7 after Everett's say-so is not needed (he asked me to keep going); opening it now.

## 2026-11-07 claude/everett-work (6)
Done: Everett told me to check the open items and decide. Checked the four award-map questions by web search (links in `Finalists/drafts/everett/award_map_open_checks.md`): Employment Security is inside Commerce (statute 96-3); DMV is inside NCDOT (secondary sources only); Adult Correction is a separate department since 1 Jan 2023 and has its own plan (`dac`); DIT has its own plan but the name has no NC marker, so I left it uncertain. Also fixed my E7 count (35 rows, 28 confirmed, not 36 and 29).
Decision: I did NOT change `agency_award_map.csv`, because it would move your fact rows 26 to 29. A scratch rerun with Employment Security, DMV and Adult Correction promoted gives 58 of 159 Top 10 (was 57 of 157), 42 in time (was 41).
Need from Kent: apply the three promotions (58 of 159) or keep the map and say in Q&A that divisions are not counted; also confirm the DMV line against an official NCDOT page.
Next: PR for E8.

## 2026-11-07 claude/everett-work (7)
Done: Kent's message (via Everett's session) asked for the task list; answered in chat. Ran a hostile-judge pass on the backtest evidence: `Finalists/drafts/everett/backtest_hostile_judge.md`. Facts 39 of 39 and tests 83 of 83 on main after `10_run_ranking.R`.
For Kent (your files): `backtest_framing.md:32` ("beats both baselines once fair") holds pooled only, not for Commerce, DEQ, DHHS, DNCR; `:40` ("at its ceiling") overreaches for a 9-setting grid; `slide_brief.md:35` figure name; the Top 20, Top 50 baseline and in-time numbers are not in the fact sheet, so do not speak them unless you add them. In my files I fixed the pooled-figure title ("later won" removed) and corrected my E2 timing wording.
Need from Kent: the earlier list (E5 placeholders, map promotions 58 of 159, fact-sheet numbers, DMV source).
Next: PR for E9.

## 2026-11-07 claude/everett-work (8)
Done: Kent (via Everett's session) answered: apply the three award-map promotions; fact-sheet numbers to carry: in-time, miss split, keyword-gap counts; E5 placeholders (length, agencies, cost, decision/owner/date) are Kent's to supply, values not given yet; draft rewordings for his files. Applied the map change (Adult Correction to `dac`, Employment Security to `commerce`, Motor Vehicles to `ncdot`) and reran 20, 21, 22, 24, 25, 26 and the figures, offline. Results: v2 Top 10 58 of 159 (was 57 of 157), Top 50 97 of 159, in time 42 of 58, split 58 / 39 / 62 (reached / 11 to 50 / below 50). The v1 pre-set result is unchanged.
BREAKS until you act: `R/check_facts.R` is now 33 of 39. Six values in `facts.csv` need updating: f33 157 to 159, f34 57 to 58, f35 95 to 97, f37 57 to 58, f38 40 to 41, f39 61 to 63. Table with fact-sheet rows in `Finalists/drafts/everett/award_map_open_checks.md`. I did not edit `facts.csv` or the fact sheet. Anything quoting 57 of 157 (slide 4, Q&A draft, framing doc, tool text) needs the same change.
Need from Kent: apply those six; tell me pilot length, agencies, cost and staffing, decision, owner, date for E5 (I will not invent them).
Next: PR; then rewordings for your overreach lines.

## 2026-11-07 claude/everett-work (9)
Done: Kent said "you decide" on the E5 placeholders. I filled them as PROPOSALS, labeled "[proposed]" or "[to decide]": 3-month pilot, 3 agencies that differ on purpose (one strong, one middle, DHHS as the hard case), measures as before. I did not invent a cost, staffing level, owner name or date: those stay "[to decide]" because nothing in the repo gives them. Also asked: `drafts/everett/rewordings_for_kent.md` and the six `facts.csv` values (still your action).
Need from Kent: confirm or change the proposals; supply cost, owner, date.
Next: PR #77 carries everything; waiting.

## 2026-11-07 claude/everett-work (10)
Done: Kent/Everett's session said "you decide, and merge it". Decision: apply everything so main stays consistent. Updated `facts.csv` (f33 159, f34 58, f35 97, f37 58, f38 41, f39 63), `fact_sheet.md` rows 26, 27, 29, 30, `handoff.md` lines 112 and 116, `slide_brief.md` slide 4, `backtest_framing.md` (numbers, plus the two overreach lines reworded as in `rewordings_for_kent.md`), the subtitle in `23_figure_backtest_v2.R` (157 to 159) and regenerated `backtest_recall_v2.png`. The tuning verdict still holds on the new map (fold A to B tie 28 of 80; B to A worse 27 vs 30 of 79; nothing adopted). `check_facts.R` 39 of 39, `run_tests.R` 83 of 83. Merging PR #77 now by the PR route, on the human's say-so.
Still open for Kent: Noah's `drafts/claude/docs/qa_cheatsheet_draft.md` lines 17, 18 and 65 still quote 57 of 157 and 61 vs 57; Noah's Claude should update them. Cost, owner and date for E5. DIT stays uncertain. Row 29's random baseline is 13.5%.
Next: idle unless a task is added.

## 2026-11-07 claude/everett-work (11)
Done: Kent's session said "answer all the open tasks yourself, keep working". Inventory of open board items: N2 labels and Marco's Azure and notice-reader steps are not mine and need a person with az or Ollama; the rest are in review or done. What I could close: updated the stale 57-of-157 numbers in Noah's `drafts/claude/docs/qa_cheatsheet_draft.md` (lines 17, 18, 65 now 58 of 159, 97 of 159, 63 vs 58, 41 of 159, random about 13.5%); numbers only, wording is Noah's.
Observed (Everett's machine E): the full-pool label job (`machine=E`, qwen2.5:14b) is running; `nc_community_college_system.csv` finished 13:13 and is still untracked on `everett/labels-E`. I did not touch the job, the cache or that file. Switching my working tree between claude/everett-work and main did not change `opportunities.csv` or `model_label.R` (diffed), so the run is not affected.
Need from Kent: nothing new.
Next: idle.

## 2026-11-07 claude/everett-work (12)
Done: Everett asked why I was waiting; I was not blocked. Swept the repo for stale 157-based numbers (only my own closeout draft had them; fixed). Drafted Evaluating answers for your empty Q&A rows: `Finalists/drafts/everett/qa_evaluating_rows_draft.md` (weakness, tradeoff, why trust v2, repeat funding, tuning, the miss split, in-time, DHHS). Rows marked "not yet a fact row" use numbers from my CSVs; add them to the fact sheet or drop those answers.
Need from Kent: paste or reject; add fact rows for the in-time and miss-split numbers if you want them spoken.
Next: PR; then check for new messages.

## 2026-11-07 claude/everett-work (13)
Done: PR #80 merged; main still 39 of 39 facts and 83 of 83 tests after the repo reorganization (PR #78). Ran a simulated budget-director read of the E5 pilot one-pager. Verdict "not yet": no price, no owner, no stop/expand rule, no baseline for "replaces reading by hand". Applied what I can without inventing: row 29 random baseline 13.5%; one-question framing (does the Top 10 add anything beyond a deadline sort: 36% vs 17% exploratory, failed pre-set test); stop/expand rule and a week-one timing baseline as proposals; removed the pointer to a CSV not in the fact sheet. Simulated persona is not user evidence.
Need from Kent: cost and staffing, owner, date, and the stop/expand rule for E5; whether a real coordinator has confirmed the user role (the page still says assumed).
Next: PR, then keep checking.

## 2026-11-07 claude/everett-work (14)
Done: Everett said labeling is only a supplement; I stopped watching it and went to the final deliverables. Drafted `Finalists/drafts/everett/field_notes_evaluation_draft.md`: (A) the evaluation results for the field notes' open `[TO FILL]` on recall versus shortlist length (Top 10, 20, 50 of 159; rows 26, 27, 29), the five recorded failures, the miss split and in-time (marked not fact rows); (B) four AI-error rows for section 7, all from this Saturday's work with how each was caught.
Need from Noah or Kent: paste into `drafts/claude/docs/field_notes_draft.md` sections 9 and 7 (Noah's draft; I did not edit it). Add fact rows for Top 20, in-time and the miss split if you want them stated.
Next: PR; then look for other deliverable gaps (README promotion, results list).

## 2026-11-07 claude/everett-work-2 (15)
Done: read your bonus-1 reach rows (fact row 31, f40 to f42) and `backtest_framing.md`. The numbers are internally consistent (both = 34 - 12 = 22; ours = 22 + 36 = 58). Added a Q&A row for it in `drafts/everett/qa_evaluating_rows_draft.md`, worded as you instruct (a stand-in newest-first alert, never "manual monitoring", and 12 programs the alert reaches that ours misses). One thing a judge may ask: the pre-set test lost to a deadline sort, but this comparison wins against a newest-first list; both lists are stand-ins, so say which one when quoting.
Need from Kent: nothing.
Next: more deliverable gaps.
