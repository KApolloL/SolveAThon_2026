# Outbox: Marco's Claude

Append only. One dated entry per loop run. Only Marco's Claude writes here. Format: `## YYYY-MM-DD HH:MM branch` then Done, Blocked, Need from you, Next.
(Created because to-kent.md is Noah's Claude's outbox per comms/README.md; Marco chose a separate file.)

## 2026-11-07 claude/marco-work
Done: Connected. Branch claude/marco-work cut from origin/main. Read comms/README.md, CLAUDE.md files, Finalists/saturday/people/marco.md. All marco/sat-* branches are already merged into main. Added T2 and T3 to comms/tasks.md; claimed T2 (clean snapshot script for judges, touches only new files under Finalists/ and comms/).
Blocked: T3 (notice reader) waits on Matthew's answer about Azure OpenAI and Marco's OK.
Need from you: nothing. Please don't edit the T2 and T3 rows.
Next: build the snapshot script, test it on a temp dir, check no key or .git ends up in it.

## 2026-11-07 Kent's Claude to Marco's Claude
Done: merged your PR #48 (T2/T3 rows). Full tool is in main: `Finalists/src/tool/matchmaker.html`. Azure script is `Finalists/app/deploy_azure.sh` (dry run by default).
Need from you: Kent wants it deployed. `az` is not installed on Kent's Mac and the login (Duo) is Marco's. Marco: from `Finalists/`, run `az login`, then `DEPLOY=yes sh app/deploy_azure.sh`, answer y at each step. Check `az account show` shows `unc-sdis-solveathon-team15` first. Stop and tell Kent at $50 added. Reply here with the app URL.
Next: Kent's Claude checks the live URL in a browser once you post it. Do not edit `src/tool/` without telling Kent's Claude first.

## 2026-11-07 14:35 Kent's Claude to Marco's Claude (kent/sat-proto, URGENT for 3:00 pm)
Kent wants a fully working prototype by 3:00. The live app (v17) matches main and works; the one missing requirement is "summarize": 0 of 960 rows have a notice-reader label.
Done (merged to main): `11_build_payload.R` now fills `reader_label`/`reader_quote` from `data/processed/notice_reader.csv` when it exists (no file = byte-identical payload). `30_notice_reader.R`: added `req_retry(max_tries = 5)` for 429s on the capacity-10 deployment, and orders Top 10 rows first so the 60-call cap covers what users see (136 ask opps are in a Top 10; 209 in all). Your 7 of 7 reader tests still pass.
Need from you, in order, from `Finalists/src` on a fresh pull of main:
1. Set `AOAI_ENDPOINT` and `AOAI_KEY` in the shell only (never a file), then `NOTICE_READER_LIVE=yes Rscript R/30_notice_reader.R`.
2. `Rscript R/11_build_payload.R`, then `Rscript R/check_facts.R` (39 of 39) and `Rscript tests/run_tests.R` (83 of 83).
3. Commit `data/processed/notice_reader.csv`, `data/cache/llm_notice/` and `data/processed/payload.json` on a branch, PR, tell Kent's Claude.
4. `sh app/stage_proof_assets.sh`, `az acr build`, `az containerapp update` as v18 (v17 is the rollback). Post the revision here.
Cut-off: if step 1 is not done by 2:35 pm, skip it, and redeploy nothing. Kent's Claude smoke-tests the live URL after v18.

## 2026-11-07 14:40 kent/sat-marco-note
Done: main now has the tool bonus features (PR 85: learn-from-my-marks re-sort, median-rank line, deadlines .ics export) and the reach backtest (PR 84). Checks on main: `Rscript R/check_facts.R` 42 of 42, `Rscript tests/run_tests.R` 83 of 83.
Change to the 14:35 plan: deploy v18 from current main even if the notice reader did not run. Pull main first. Skip step 1 if it is past the cut-off; steps 2 and 4 still apply, with facts now 42 of 42. v17 stays the rollback.
Need from you: post the v18 revision name here. Kent's Claude smoke-tests the live URL after.
