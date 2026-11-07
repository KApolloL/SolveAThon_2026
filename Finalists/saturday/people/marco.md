# Marco: Azure and the tool

You are Marco's Claude. Read `../README.md` rules first. Marco is new to git: explain each git step in plain words, branch `marco/sat-<topic>`, never touch `main`.

## Goal
By 1:00: the JS tool is live on Azure at the Container App URL, reads `payload.json` from Blob, and shows an agency picker and a top 10. A mentor can click it by 11:00 (stub data is fine then).

## You own
`app/`, `src/tool/`, Azure resources, `src/R/30_notice_reader.R`, `src/docs/azure_setup.md`.

## Facts
- `ffm-app` is live: https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/ (Shiny at `/`, qualifier tool at `/tool.html`). 0.5 vCPU, 1 Gi, min 0, max 1. Cold start 38 seconds.
- Azure OpenAI `ffm-aoai-team15` has `gpt-4o-mini` and `text-embedding-3-small`, both tested, not wired in. Matthew asks at 9:00 whether it is ours to use.
- Azure does not enforce the $500 budget. Alerts only. Stop and tell Kent at $50 added today. Cap model calls in config and cache every call.
- The qualifier tool is in `../QualifierChallenge/src/tool/` (`ui.js`, `tiering.js`, `build_tool.R`). Reuse it. Do not rewrite it.

## Steps
1. **By 9:30.** Read `03_contract.md`. Pull Merge 1 (stub `payload.json`).
2. **9:30 to 11:00.** Put the stub `payload.json` in Blob. Give `ffm-app` read access with a role assignment (managed identity, no keys in files). Serve the JS tool as the main page, reading the Blob file; keep Shiny at a side path as fallback. Build the first screen from `planning/09_tool_plan_update.md` "First screen": agency picker is the only required step, days left as the headline, plain eligibility words, one-line reason, a count line that accounts for hidden items. Ask the tech mentors T1 to T3 (Matthew asks, you stand beside him).
3. **11:00.** Point it at the real `payload.json` after Merge 2. Set min replicas 1 for the mentor demo if T3 says it is cheap.
4. **11:00 to 12:15.** Fix what Rhett's I3 finds. Pursue / Maybe / Pass button per row. "Coming up (not open yet)" tile for forecasts.
5. **12:15 to 12:45.** Redeploy after Merge 3. Check the URL on your phone.
6. **2:00 to 5:30.** Daily Container Apps Job (`MODE=job`): pulls new items from cache, scores, writes `payload.json` to Blob, stamps "data as of". Closing-soon and new-since-last-visit panel (localStorage). Notice reader (`30_notice_reader.R`, advisory only): label plus an exact quote the script checks; cache every call; cap calls in config. `POST /feedback` only if time holds (cut order).
7. **7:00 to 8:00.** Build the clean snapshot repo for judges: main's files, no `.git`, no `api_keys.env`, README tells a developer to make their own keys. Fill `azure_setup.md` with spend. Do not push it anywhere public without Kent's OK.
8. **Sunday before 8:30.** min replicas 1, load the page once. After the talk set it back to 0.

## Done means
- [ ] URL loads in under 3 seconds warm, with real data, on a phone.
- [ ] No key in any file, image or commit.
- [ ] Spend written in `azure_setup.md`.

## Handoffs
- From Kent: contract and stub (9:30), real `payload.json` (11:00). To Kent: PRs for `app/` and `src/tool/` before each merge window, and a list of any config settings you added.
