# Saturday plan: Nov 7, 2026 (for Marco to confirm)

Written Fri Nov 6, about 10:50 pm, by Claude for Marco. **This is a draft. Nothing here runs until Marco confirms it.** Team and framing decisions stay with Kent.

Related: [azure_setup.md](../src/docs/azure_setup.md) | [framing worksheet](02_framing_worksheet.md) | [discovery findings](07_discovery_findings.md)

## Where we start
**R on Azure works.** A Shiny app with all 6,523 real opportunities is live, so the R versus Python question has an answer unless Kent says otherwise.

URL: https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/

| Check | Result |
|---|---|
| `/` and `/tool.html` return 200 | Pass |
| Page shows `MODE = app` | Pass |
| Counts: 6,523 total; 884 posted, 588 forecasted, 4,947 closed, 104 notice | Pass |
| Websocket connects, table filters in a real browser, no console errors | Pass |
| No key in the build files or the commit | Pass |
| Warm page load | 0.09 to 0.16 seconds |
| Cold start | **38 seconds** after the app scales to zero |
| `MODE=job` in the cloud, phone hotspot, V8 on the server | Not tested |

This proves hosting only. There is no matching, ranking or AI yet, and no one should describe it as more than that.

## Confirm before 9:00
1. **Today's split.** Proposed: Marco owns Azure, the data flow into the app and the deploy. Kent owns criteria and scoring. Both work on the app screen.
2. **Stack.** Proposed: stay on R Shiny.
3. **Today's spending limit.** Proposed: stop and talk at **$50 added today**. Expected use is under $10.
4. **Azure OpenAI.** Ask at the 9:00 check-in whether it is ours to create. Do not create it before then.

## Bring to the 9:00 check-in
- **Azure OpenAI.** Option B, the worksheet's draft choice that Kent has not confirmed, needs it for plain-language reasons. Cost is not the obstacle: one full pass over 34 agencies at the top 20 each, plus embeddings for all open items, is roughly **$0.50** at list price [estimate; assumes 3,000 input and 300 output tokens per call]. If refused, Option A still works with TF-IDF.
- **Data handling.** Read Azure's documentation before anyone says prompts stay out of training. It is still [uncertain].
- **The $500.** It is a monthly budget *alert* that goes to the organizers, alongside a $6,000 annual alert. Neither is a hard limit, and the subscription's spending limit is off. Ask if there is a real limit.

## Findings for Kent
1. **The known-good test cannot pass as written.** The worksheet expects Clean School Bus (CFDA 66.045). That CFDA has **0 rows** in `opportunities.csv`. The nearest item is the 2026 DERA notice, `EPA-OAR-OTAQ-26-01` (CFDA 66.039, posted, closes 2027-01-22), which is the only opportunity whose title or summary mentions school buses. Pick a replacement before scoring, not after.
2. **Keyword noise is visible now.** Searching "school bus" in the live table returns 690 rows, because it matches each word separately across all columns. This is a table search, not a measured baseline, so it is not a slide number. It does show what the keyword baseline needs to beat.
3. **Missing values are common.** Of 1,472 open items, 723 have no award ceiling and 117 have no close date (68 of those are forecasts). Both must display as "unknown", as the worksheet says.
4. **Forecast dates go stale.** 197 forecasted items have a close date before Nov 6 (for example `RFA-HD-27-001`, Nov 2), so "days left" would be negative or misleading. Only 1 posted item does. Also: 47 open items close after 2030, 60 list an award of 0, and about 440 have HTML codes in their text. Decide how each is shown before the ranking uses them.
5. **Evaluation kit is ready for review** in `drafts/claude/eval/`: blank blind sheets for 2 agencies (30 items, 2 labelers each), keyword baseline, metrics (20 of 20 tests pass, on fake data only), and 12 proposed test cases. Kent decides the demo agencies, pass marks, the DERA replacement, and whether higher-education-only counts as ineligible. **Regenerate the sheets with the ranking file before labeling**, otherwise few of the ranker's top 10 will have labels and precision@10 means little. Labeling is people only.
6. **Nothing to score with yet.** `data/manual/` is empty, so `criteria.csv`, test cases and facts still need writing. The worksheet's [assumed] lines are not sponsor-approved, and Claude could not verify the mentor gate box.
7. **Required deliverables are drafts or empty.** Field notes and the state-developer README are drafted in `drafts/claude/docs/`, with a `[TO FILL]` list for Saturday. The fact sheet is empty. `handoff.md` still reads as Friday morning; suggested Azure row below.

## Marco's day
| When | Do | Done means |
|---|---|---|
| 7:00 | Read the overnight summary | |
| Before 9:00 | Confirm this plan. Open the URL on your phone. Run `az account show`, and `az login` with Duo if needed. Check Cost analysis | URL loads; login works |
| 9:00 | Check-in questions above | Azure OpenAI answer in hand |
| 9:30 to 10:00 | **Speed up builds.** The first build took 7.7 minutes, largely compiling R packages from source. Use prebuilt Linux packages and put the data in a late layer | A code change rebuilds in about 2 minutes |
| 10:00 to 11:00 | If approved: create `ffm-aoai-team15`, deploy `gpt-4o-mini` and `text-embedding-3-small` at small capacity, test both. If refused: record the error and tell Kent | Both calls return 200, or fallback chosen |
| 10:00 to 12:30 | **Data flow.** Give `ffm-app` Blob access (ask first; it needs a role assignment). Upload opportunities and goals to `ffm-data` using the agreed layout. App reads from Blob instead of the image | New data appears without a rebuild |
| 11:00 to 1:00 | **App screen with Kent.** Agency picker, ranked list, plain reason, days left, Pursue / Maybe / Pass | A non-grants person can use it unaided |
| **1:00 gate** | A working ranking at the Azure URL for at least one agency | If not, use the cut order below |
| 2:00 to 4:00 | Mentor drop-in with one real failure. Save decisions to Blob. Test `MODE=job` if time allows | Decisions survive a restart |
| By 5:00 | Send the slide team architecture facts and screenshots. Test on a phone hotspot. Record the backup demo | Backup video exists |
| 6:00 | Cost check and scale check | Spend written in `azure_setup.md` |
| 7:00 to 8:00 freeze | Finish `azure_setup.md` and the README deploy section. Commit, then open the PR for Kent | PR open |
| Sun before 10:00 | Set min replicas to 1 and load the page once | No 38-second wait in the demo |

**Demo cold start:** keeping one replica warm is cheap, about $0.05 per hour at most, so turn it on before rehearsals too. Turn it back off afterward.

**Cut order if behind (Starter Kit):** second agency views, then feedback-tuned weights, AI summaries, embeddings, the scheduled job. Never cut one real agency profile, real data, a ranked list with reasons, a human decision button, one evaluation number and one honest failure.

**Scope note:** Kent chose to serve all agencies, while the Starter Kit recommends one. Build so one agency works end to end first, and treat the rest as the same steps repeated. Flag thin or stale plans; do not rank them down.

## How Claude can help today
- Sonnet subagents for routine code and deploys, one writer per file. Opus for design, review and the evaluation.
- Repo reviewers: `test-breaker` before the 1:00 gate, `data-critic` once criteria exist, `hostile-judge` near freeze.
- Pull main before each work block. Push only to `marco_testing`; PR for Kent.

## Suggested `handoff.md` Azure row (Kent's file, so not edited)
> Azure: `ffm-app` live at the URL above (R Shiny, image `ffm-app:v1`, 0.5 vCPU, 1 Gi, min 0, max 1, managed identity pull). Display only. Budget alerts `ffm-guard` at $50, $100, $250, $400. Azure OpenAI not created; awaiting the 9:00 answer. Details in `src/docs/azure_setup.md`.
