# Full-project review triage, Sat Nov 7, 2026 (10:52 am)

26 one-shot reviewers ran over `Finalists/` at main `95fed84` (transcripts 08 to 33 in `testing/transcripts/`). Run by Marco's Claude Code session: Opus 5.5 as review manager, every reviewer a Sonnet 5.5 subagent, three at a time. The manager ran the tests once, briefed each reviewer, and spot-checked at least one claim from every reviewer against the files (results below). Persona findings are hypotheses, never user evidence. Everything here is a proposal for Kent to confirm.

**Time check:** building stops 6:00 pm (`saturday/00_timeline.md:23`). Submission Sun 9:00 am. About 7 hours of build time left when this was written.

## Checks the manager ran (exact output)
- Fresh checkout, README order: `run_tests.R` and `check_facts.R` both **crash** ("using TOY EXAMPLE data", "criteria point at columns that are not in the items"). Cause: `data/processed/items.csv` is gitignored (`.gitignore:7`) and only `R/10_run_ranking.R` writes it; `00_config.R:47` falls back to toy data silently.
- After `Rscript R/10_run_ranking.R`: **78 of 79 tests pass** (the failure is hard-coded FALSE at `src/tests/run_tests.R:108`, "agreement test pending"); **17 of 17 rows pass**; `payload.json` rebuilds byte-identical.

## Scores by judging stage
| Stage | Stage judge | Hostile judge | Median | Main reason |
|---|---|---|---|---|
| Understand | 2 | 2 | **2** | Sponsor notes are real, but no before/after/quote row in field notes; no outside person has used the tool; "payoff vs work" (the sponsors' key tradeoff) is off (weights 0) and award size is never shown |
| Frame | 3 | 3 | **3** | Clear problem; bar fixed before results. Two success tests still circulate (70% pool vs 50% award history); criteria rows sourced "[from notes; confirm with Kent]" |
| Solve | 3 | 2 | **2.5** | Real pipeline to a 32-agency payload, deterministic. Azure is a viewer: daily job is an echo stub, Azure OpenAI unused, top 10s contain obvious junk |
| Evaluate | 3 | 2 | **2.5** | Bar set at 1:17 am before any ranking (good). It fails, a deadline sort beats the tool in all 9 rows, the denominator flatters the tool, and nothing reaches the fact sheet |
| Drive Impact | 2 | 1 | **1.5** | No pilot ask with cost, owner or success measure; no slide brief; Q&A sheet blank |

## The one headline the team must own
**The backtest fails its own pre-set bar, and a soonest-deadline sort beats the tool.** 4-week windows: DPI 2 of 3 (67%), DEQ 3 of 7 (43%), DHHS 4 of 11 (36%); bar was 50% in 2 of 3 agencies, so 1 of 3 passes. Deadline baseline: 100%, 71%, 73%. Intervals run roughly 7% to 99%, so no better-or-worse claim is possible either way (`data/processed/backtest_result.csv`; reproduced on current rankings by reviewer 09). On top of that, the denominator only counts won programs already in the tool's own top 50, and both baselines are re-sorts of that same top 50 (`src/R/20_backtest_awards.R:79-82, 96-107`, manager confirmed). Every judge-facing reviewer (08, 09, 15, 16, 19, 20, 27, 28, 31) found this. Hiding it loses Evaluate; stating it plainly with the tradeoff is the best Evaluate answer available.

## Ranked fix list (severity x judge visibility x hours left)
| # | Fix | Why (verified evidence) | Sources | Owner (`saturday/03_contract.md`) | Proposal |
|---|---|---|---|---|---|
| 1 | Put the backtest verdict, counts, intervals and both baselines in `facts.csv` + `fact_sheet.md`, with one honest sentence; fix or relabel the denominator (add "won programs with any notice in window") | Headline evidence has no fact row, so by team rule it cannot be said on stage. Reviewer 09 estimates true denominators 8 / 15 / 32 | 09, 11, 15, 19, 20, 31 | Everett (20_*), Kent (fact sheet) | fix now |
| 2 | Show notice rows or stop them taking Top-10 slots | 61 of 320 Top-10 slots are Federal Register notices; `matchmaker.html:131` shows only `posted`, so Commerce, OAH, OSC see 2 rows; DEQ rank 9 silently missing | 10, 21, 25, 29 | Kent (11_build_payload) or Marco (tool) | fix now |
| 3 | Write the pilot ask: duration, agencies, monthly cost (computed), named owner role, success measure and stop date; fill Q&A "What should the director do Monday?" | No file holds a fundable ask (`planning/09_tool_plan_update.md:80-87` is a to-do list); every Impact reviewer and persona said "could not state next step" | 16, 19, 25, 27, 28, 29, 32 | Kent, with Marco for cost | fix now |
| 4 | Clean the obvious false positives: decode HTML entities before the geography match; add a raw-fit floor (Top 10 may be shorter than 10); drop items whose close date is before `data_as_of`; hide tribal-only and non-profit-only items | Verified: AFPRA-20-04 (Cape Verde embassy, non-profits only) is rank 1 for State Auditor; FA875025S7001 (Air Force research) rank 1 for Revenue; Hawai'i CESU (G27AS00073) escapes the geo penalty via `&#699;`; 11 tribal programs in Top 10 as "ask"; 10 Top-10 rows closed Nov 6 show "0 days left" | 08, 17, 20, 21, 22, 23, 30 | Kent (helpers_rank, 00_config) | fix now; a judge will click one agency |
| 5 | Render on screen what the payload already has: `elig_quote` for "No" and hidden rows, `award_ceiling`, cost share, `map_note`, and a source label on goal snippets ("DPI plan, Pillar 2") | DARRP hide for DEQ is correct and carries the exact exclusion quote, but the screen shows only "No". `award_ceiling` appears 0 times in `matchmaker.html` | 14, 22, 23, 25, 26, 30 | Marco (src/tool) | fix now; small |
| 6 | Rewrite `README.md` to the real run order (`10_run_ranking.R` before tests) and make `00_config.R` fail loudly instead of using toy data; move `data/example/` to `stale/` | Fresh clone crashes following README; README still says hello page / toy data | 10, 12, 18, 33 | Marco (README), Kent (config) | fix now |
| 7 | Update the field notes to Saturday: one before/after/sponsor-quote row per plan change, the failed label gate (kappa 0.44 on 3 items), DERA as "keyword missed it, a hand map fixed it", the 50% bar | Draft says "no scoring, no ranking" and the 70% pool bar; would be submitted wrong | 09, 11, 12, 14, 15, 28 | Noah (drafts), Kent | fix by 7 pm |
| 8 | Run the 2:00 pm mentor timed task on the live URL, log it in `saturday/mentor_log.md`, ship one change from it | Only route to a real "user shaped the build" row; log is empty | 14, 19, 31 | Matthew | at 2:00 |
| 9 | Judges' snapshot script (decision 10) written and tested now: no `.git`, no `api_keys.env`, no `tasks/everett_api_keys.md`, `notes/vault/`, `stale/`, eval answer key, organizer emails; scan output for both key values, `sig=`, `AccountKey`. Add `api_keys.env` to `.gitignore` | Keys are in pushed history (`78d3d2b`, on origin/main); no script exists. Manager confirmed transcripts contain no key values | 12, 13, 32, 33 | Marco; Kent signs off (rotation is Kent's call) | fix by 7 pm |
| 10 | Days-left honesty: compute days left in the browser from `close_date`, set `REF_DATE` and `data_as_of` from the build time, show "data as of" | `REF_DATE` fixed at 2026-11-06 (`00_config.R:23`); `data_as_of` is a fixed string; demo on Sunday shows 2-day-stale counts | 10, 17, 29, 30 | Kent (config), Marco (tool) | fix now |
| 11 | Coming-up panel: drop or badge forecasts whose date has passed and those marked "No" | 173 of 477 forecast rows say "date listed has passed" (manager confirmed) | 22, 23, 24, 29 | Kent or Marco | fix |
| 12 | Blob SAS expires about Nov 10: extend it or bundle a fallback payload in the image so the link still works for judges | `app/app.R` returns 502 without Blob | 08, 13, 29, 32, 33 | Marco | fix by 7 pm |
| 13 | Decide on Azure OpenAI: either one shipped advisory call (quoted one-line reason for top 10, checked by the quote script) or drop "AI-assisted" from the pitch and say keyword fit | Created, never called (`azure_setup.md`); data-use terms unread [uncertain] | 08, 19, 31, 32 | Marco + Kent decide | decide now |
| 14 | Delete or fix the dead R/JS duplicate (`ranker.js`, `ui.js`, `build_tool.R` on the old `items` shape) and the hard-coded red test | Suite can never print all-pass; `ranker.js` scores missing as 0, against `score.R` | 10, 21, 33 | Marco / Kent | defer unless cheap |
| 15 | Doc consistency sweep: building stops 6:00 pm not 7 to 8; superseded 70% bar marked in planning/08 and 02; `testing/context.md` refreshed (every reviewer reads it); mentor question F2 "8 to 38" is wrong (3 to 11); stale 1,472 / 723 counts | Verified 6:00 in `00_timeline.md:23` and F2 text | 11, 18 | Kent (context.md approval), each file owner | fix after code |

Smaller items (defer or fold in): `read_any` guesses `map_note` as logical and drops the DERA rows on read (`guess_max`), `plan_thin` null for all 32, counts line uses sample rows (DHHS shows 5 hidden of 98), `AI_USAGE_LOG.md` blank row breaks the table, SBIR/STTR items should be "No" for state agencies, `text_eligibility` "not" has no word boundary (latent), test harness `in_top_n` ranks all agencies pooled.

## Findings the manager rejected or downgraded
- "Revere Public School Educators is a misextracted goal" (08, 24, 28): **rejected.** It is DPI's real Pillar 2 (`data/processed/agency_plan_text/all/department_of_public_schools.txt:599`). Three readers misread it, so fix #5 (label the source) instead.
- "STUB DATA banner on matchmaker.html" (19): **rejected.** The banner is `hidden` unless the payload is a stub; the real payload is not.
- "Pursue/Pass button not built" (15): **rejected.** Built at `matchmaker.html:85-93`, browser localStorage only. The valid point stands: it is a decision log, not a feedback loop.
- "DARRP wrongly hidden" (23): **rejected.** Correctly hidden with the exclusion quote; the screen just doesn't show it (fix #5).
- "32 posted items with negative days left ranked" (21): **downgraded.** One item repeated across 32 agencies in `items.csv`; never reaches the payload.
- "`tasks/everett_api_keys.md` is a key file" (12): **downgraded.** No key-like strings in it; still leave it out of the snapshot.
- "backtest_result.csv is stale after the DERA map" (11, 31): **resolved.** Reviewer 09 recomputed all 9 rows on the current rankings and they match.

## Not assessed by anyone
The live Azure URL and what it serves today, live Blob contents, browser rendering, key validity, repo visibility, the submission form's format, any real user's reaction.

## Process notes for the next run
- `tests/run_tests.R` rebuilds `payload.json`; reviewers must not run it in parallel. The `/full-review` command now has the manager run it once and quote it.
- The manager briefly ran 4 reviewers at once (over the CLAUDE.md cap of 3) for a few minutes; no shared files were written.
- Recommendation from reviewer 13, not applied (Kent owns config): add `Read(**/api_keys.env)` to the deny list in `.claude/settings.json`.
