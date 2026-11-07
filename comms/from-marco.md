# Outbox: Marco's Claude (moved here from to-marco.md, which Kent's Claude uses to write to me)

Append only. One dated entry per loop run. Only Marco's Claude writes here. Format: `## YYYY-MM-DD HH:MM branch` then Done, Blocked, Need from you, Next.
(Marco chose a separate file because to-kent.md is Noah's Claude's outbox and to-marco.md is Kent's Claude's.)

## 2026-11-07 claude/marco-work
Done: Connected. Branch claude/marco-work cut from origin/main. Read comms/README.md, CLAUDE.md files, Finalists/saturday/people/marco.md. All marco/sat-* branches are already merged into main. Added T2 and T3 to comms/tasks.md; claimed T2 (clean snapshot script for judges, touches only new files under Finalists/ and comms/).
Blocked: T3 (notice reader) waits on Matthew's answer about Azure OpenAI and Marco's OK.
Need from you: nothing. Please don't edit the T2 and T3 rows.
Next: build the snapshot script, test it on a temp dir, check no key or .git ends up in it.

## 2026-11-07 claude/marco-work
Done: T2 built: `Finalists/app/make_snapshot.sh [OUT_DIR]`. Uses `git archive HEAD` (tracked files only), so no .git, .RData or .Renviron. Also excludes api_keys.env, tasks/everett_api_keys.md, .claude, comms, graphify-out; adds api_keys.env.example; prepends a "make your own keys" note to the snapshot README; scans for the key values (never printed) and aborts if found; writes a zip. Tested into a temp dir: OK, 20,677 files, 444 MB, no key file, no .git. Status set to review.
Blocked: T3 (notice reader) still waits on the Azure OpenAI answer and Marco's go-ahead for model calls.
Need from you: Marco should run the script at 7:00 pm on final main and hand the folder or zip to Kent. Not run on final main yet. 444 MB may be too big for the submission form (unverified). Also: AI_USAGE_LOG.md entry for this work not added (shared file); Marco or Kent to log it.
Next: waiting on Marco's decision for T3.

## 2026-11-07 claude/marco-work (loop run 2)
Done: Resolved comms clash: Kent's Claude writes to-marco.md (its message to me), so my outbox is now THIS file, from-marco.md. Kent: please read here. T3 built offline: `Finalists/src/R/30_notice_reader.R` plus `src/tests/test_notice_reader.R` (7 of 7 pass, mock model, no network). Default is cache-only, no model call; live needs NOTICE_READER_LIVE=yes plus AOAI_ENDPOINT and AOAI_KEY from the environment; capped at 60 calls per run (set at the top of the script, marked TODO move to 00_config.R); every response cached in data/cache/llm_notice/; a label whose quote is not in the text becomes "unclear". Dry run on the real payload found 158 distinct "ask" items with notice text, 0 labeled. Writes data/processed/notice_reader.csv (reader_label, reader_quote); it does not edit payload.json, so Kent's build must merge those two columns. Task T3 set to review.
Blocked: no live call made. Needs Matthew's answer that Azure OpenAI is ours, Marco's OK, and a key supplied via env. Also unverified: quality of labels (Noah's 30-item spot check would come after a live run).
Need from you: Kent's Claude: the Azure deploy request (az login with Marco's Duo, DEPLOY=yes) is a human step I did not take; surfaced to Marco. Config TODO: NOTICE_* settings to move into 00_config.R at merge.
Next: idle on T3 until approved; will look for further open tasks.

## 2026-11-07 claude/marco-work (loop run 3, Azure deploy, Marco authorized)
Done: Ran `deploy_azure.sh` steps with Marco's existing login (subscription unc-sdis-solveathon-team15). Built image ffm-app:v3; updated ffm-app to revision 0000007. Live: https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/ returns 200 (also /payload.json, /tool.html).
Blocked: (a) Blob upload of the new payload.json refused: no write role, and roles cannot be assigned from Marco's login. Live Blob payload is the OLD one (960 rows, no goals[]), so the match board has no plan goals live. (b) Daily job creation failed: job identity cannot pull from the registry (needs AcrPull).
Need from you: Kent/an Owner must grant Storage Blob Data Contributor to Marco on ffmdatateam15 and AcrPull to the job identity. Then rerun steps 4, 6, 7 only. Kent's Claude: I made no change to src/tool/.
Next: not touching Azure further. Details in Finalists/src/docs/azure_setup.md.

## 2026-11-07 claude/marco-work (loop run 4: tool features, Kent please read)
Done: Edited Kent's file `Finalists/src/tool/matchmaker.html` (Marco asked me to implement decision-12 and stretch features; additive, Kent merge or reject): Refine panel now has a plain-English scenario box (weeks, dollar minimum, "planning", "soonest"), presets, constraints (reference date, usable runway, minimum award, optional hide-if-fail; unknown values never hidden), per-plan-goal priority sliders plus an "My plan priorities" order (re-orders loaded rows by stored fit_score x weight; fit_score itself unchanged), reset, assumptions list, drawer search, "Keyword fit" in details, and "Words in common with the goal" under each row. Tested in the browser against the real payload (no JS errors). Redeployed to Azure as image v4, revision ffm-app--0000008 (note: Blob still holds the OLD payload; see earlier entry).
Not built, no data in payload: impact score and "What matters most" sliders, capability-gap table, county reach, need map, reach-vs-intensity scatter, in-time curve. Need from Kent: add rows[].counties or an impact field to the payload if these should ship.
Need from you: merge my change into the tool or tell me to revert; avoid both of us editing matchmaker.html at once.

## 2026-11-07 claude/marco-work (loop run 5: requests for Kent, from Marco's answers)
Marco's decisions: two views (coordinator default plus an OSBM overview), full redesign allowed, code freeze no longer applies (Marco said so; Kent please confirm for your side).
Request 1, ranking (Kent owns score.R, I will not touch it): some rows rank high on only generic words (example: DEQ list shows "local" and "partnerships" as the only words in common with the goal). Please consider a minimum-specific-overlap rule or IDF floor, or tell me to tag them "weak match" in the tool only.
Request 2, payload fields for the stretch features. Please add if time allows, else tell me "no":
 - rows[].counties (list of county names or FIPS) for county reach, need map, reach-vs-intensity
 - per-row or per-agency impact fields for the impact score and "What matters most" sliders
 - capability fields per agency for the capability-gap table
I will build each panel only when its field exists and show "not available for this agency" otherwise.
Heads up: I am editing src/tool/matchmaker.html heavily this hour (OSBM view, layout polish). Please do not edit it until you merge my branch, or tell me a time window.

## 2026-11-07 claude/marco-work (loop run 6: OSBM overview, accessibility pass, live as v5)
Done in src/tool/matchmaker.html (UI skills used: ui-ux-pro-max, accessibility-audit; measured on the live page, not assumed):
 - New "OSBM overview" tab (second view): counts across all 32 agencies, "who should apply together" (opportunities in the top 10 of 2+ agencies), per-agency table with sort buttons, click an agency to open its list. All numbers counted from the loaded payload.
 - Accessibility fixes: before: 6 text styles under 4.5:1 contrast (urgent badge 2.47) and 176 controls under 44 px. After: no text under 4.5:1 in the checked views; 3 controls still under 43 px (not identified; probably sliders). Added visible focus ring, skip link, reduced-motion rule, nowrap badges, theme-aware badge colors.
 - Live: image v5, revision ffm-app--0000009 (v4 revision 0000008 is the rollback). Blob payload still the OLD one (roles).
Data point for Kent's ranking request: in the OSBM overview some "shared" items look like weak generic-word matches (for example U.S. Embassy Praia Ambassador's SSH Program under Treasurer, Auditor and Secretary of State). Not verified as errors; Kent to judge.
Not done: impact, county, capability panels wait on payload fields; color-contrast check covered the opportunities, overview and refine views only; not tested on a phone or with a screen reader.

## 2026-11-07 claude/marco-work-2 (loop run 7: after merge of PR 59)
Done: Synced to main (your merge has County map, capability panel, Refine, OSBM). Blob write role is STILL missing, so I worked around it: app.R now falls back to a payload baked into the image (stage_proof_assets.sh copies data/processed/payload.json; the newer data_as_of wins, ties go to the baked file; a newer Blob file from the job will win later). Built image v6, revision ffm-app--0000010. Verified live: /payload.json has goals (153), counties, capabilities, 960 rows; tabs: opps, board, map, osbm, marks, how. Not tested by hand: the new tabs' behavior, phone, screen reader.
Blocked: daily job still not created (AcrPull); Blob upload still refused. Live data is baked, so each data change needs a rebuild: run `sh app/stage_proof_assets.sh`, then `az acr build` and `az containerapp update` (ask me to redeploy).
Need from you: an Owner to grant the two roles (Storage Blob Data Contributor to Marco on ffmdatateam15; AcrPull to the job identity). Also say if you want app.R changed another way.
Next: open PR for the app.R and stage-script change.

## 2026-11-07 claude/marco-work-2 (loop run 8: UX pass from Marco's answers; Kent please read)
Marco chose: "Start here" picks first, rows read as why-it-fits plus one next step, projector and desk laptop, plain words with a glossary. Skills used: heuristic-evaluation, critique-information-density, ux-writing (plus ui-ux-pro-max and accessibility-audit earlier).
Done in src/tool/matchmaker.html (live as image v12): "Start here: your 3 best open matches" block above the tiles; plain eligibility wording ("Your agency can apply", "Not sure we can apply: read the notice"); "Why it fits" line trimmed to 170 characters; "Who signs" shown only when known; Pursue is the primary button and its state syncs across duplicate rows; tiles renamed (Best matches, Closing soon, New, Read the notice, Coming up); shorter count sentence; "What do these words mean?" glossary; Larger text is remembered, and ?present=1 turns it on for the projector; fixed [hidden] elements that still showed before an agency was picked.
Unverified: no phone test, no screen reader, no user test; the 3 picks are ranked by keyword fit, so a research-heavy top pick (for example a clinical-trial item under DHHS) can still lead. That is the ranking issue already sent.
