# Solution Design and GenAI Field Notes (Federal Funds Matchmaker)

> **DRAFT. Not for submission as written.**
> State of the project as of **Fri Nov 6, 2026, late evening**. Written from the repo files only.
>
> **What is true now**
> - Data is loaded: 6,523 opportunity rows in one table (`data/processed/opportunities.csv`; counts in `src/docs/azure_setup.md`).
> - Agency plan text and goal tables exist for all 34 plans (`handoff.md`, data setup notes).
> - A display-only R Shiny page with that table runs on Azure Container Apps (`src/docs/azure_setup.md`, proof run).
> - Framing worksheet is drafted by Claude and its gate is ticked at Kent's request (`planning/02_framing_worksheet.md`).
>
> **What is not true yet**
> - There is no scoring, no ranking, no AI summary and no Azure OpenAI resource.
> - `data/manual/` is empty, so there is no `criteria.csv`, no test cases and no hand labels.
> - No evaluation has been run and no real user has seen the tool.
>
> **Update (Fri Nov 6 night, after Kent's decisions).** Kent confirmed 15 product decisions (`planning/08_product_decisions.md`, on `origin/main`, not yet in this branch). They override the worksheet's "chosen option" lines. **Those decisions came from a grilling interview with Kent, not from sponsors.** Only some of them trace to the discovery notes; each row below says which. All 15 are decided and **none are built**. Nothing in the live app has changed.
>
> **Who must fill the rest.** Kent owns the design decisions and the framing. Marco owns the Azure facts and the Azure items below. `docs/RUNBOOK.md` on `origin/main` now names roles: Noah (A, client lead), Everett (B, data and testing), Matthew (C, story and slides), Marco and Kent (D, Q&A and proof, including the AI log and disclosure). The submitting teammate must replace every `[TO FILL]` before the form is sent. Do not predict results to fill a blank.
>
> Tags used: `[from notes]` means our merged discovery notes, not a verbatim quote. `[assumed]` means we inferred it and no sponsor said it. `[uncertain]` means not checked.

Sources: `docs/QUEST_BRIEF.md` (what these notes must show), `planning/07_discovery_findings.md`, `planning/02_framing_worksheet.md`, `AI_USAGE_LOG.md`, `src/docs/azure_setup.md`, `planning/08_saturday_plan.md`.

## 1. End user and goals

**Primary user.** A grants lead or coordinator inside an NC state agency [from notes]. In the room, one agency had one person who writes grants and screens Grants.gov all the time. Another agency had nobody in charge of scanning, and each person scans a little [from notes]. There is no "grant explorer" role. Some agencies have dedicated grant workers and most do not [from notes].

**Who else must be able to use it.** Many users will not be grant experts. The tool has to work for "the average person who does not normally do grants" [from notes, paraphrase].

**Second user.** OSBM staff who want a cross-agency view [assumed]. No sponsor said this. It comes from the framing worksheet draft.

**What they want [from notes]:**
- Find the opportunities that fit their agency early enough to act.
- Spend almost no time doing it. Waiting minutes for an answer fails. More questions to the user is bad.
- Have the tool sort eligibility so the person does not have to know the criteria.
- Know whether a grant is worth the effort, not just whether it fits.

**What they do today [from notes].** Scan Grants.gov by hand and use mailing lists, other agencies' notices and what people already know. A past fix was to ask each agency's point of contact and run a periodic survey. It did not work. Nobody knows how many opportunities are missed.

**The decision the tool supports.** Which open or forecast federal opportunities are worth pursuing for the agency before the close date. A person decides. The tool does not apply for anything (`docs/QUEST_BRIEF.md`, rules for the road).

Evidence gap: we have discovery notes from one session. We have not tested with any real user yet. `testing/` holds teammate personas, which are not user evidence (`planning/05_user_criteria_and_feedback.md`, section 4).

## 2. What we heard and what changed

All "sponsors said" cells come from `planning/07_discovery_findings.md` and `notes/vault/Solveathon_DiscoverySession.md`. They are our notes, not quotes. Status says whether the change is built.

| Before the session | What sponsors said [from notes] | After (decision) | Status |
|---|---|---|---|
| Rank opportunities by fit to the agency plan | No agency chases a grant without a real payoff. A small grant is not worth it for a statewide agency. Payoff versus work is the key tradeoff | Added award size (log scale) and effort (cost sharing, funding type) as criteria beside fit (`planning/02_framing_worksheet.md`, section 5) | Decided in the worksheet, a draft by Claude with [assumed] lines. **Not built.** No scoring exists |
| Eligibility is one score component | The tool, not the person, must sort for eligibility. A user may not know the answer to a criterion | Eligibility is a filter or a flag with a reason. A blank field becomes "check eligibility", never a silent drop (worksheet, section 5) | Decided in the worksheet. **Not built.** The fields `applicant_types` and `eligibility_text` are in the table |
| A deadline was one input among others | Short deadlines caused the school bus miss. Time is the key constraint | Show days left and a "closing soon" flag on every match. Reference date is a config value (`src/R/00_config.R`, `REF_DATE`) | Reference date exists. Display is decided and **not built**. Decision 8 (Kent): the 70 posted items with close dates after 2030 read "rolling or no date listed", have an unknown deadline and sort last on soonest. Kent's own call; sample 10 against Grants.gov first. 117 of 1,472 open items have no close date and must show "unknown" (`planning/08_saturday_plan.md`) |
| Onboarding step: user ranks 10 sample grants first (`planning/05_user_criteria_and_feedback.md`) | Do not ask busy users more questions. More work for the user is bad. They cannot wait minutes | **Decided (decision 10, Kent):** an optional "pick 3 good, 3 bad" button shown after results, which nudges the weights. It is never required to start. The decisions file does not record why. The sponsors' "fewer questions" note is consistent with it, but I cannot say it drove the choice [assumed]. The blank `[cut or shrank]` in `07_discovery_findings.md` is still unfilled in that file; the answer is "moved to after results and made optional" | Decided, **not built**. First on the cut list (decision 15) |
| Grants.gov as the only source | Grants.gov is not comprehensive. Other agencies and SAM.gov post separately | Also pulled Simpler.Grants.gov, Federal Register notices and USAspending past awards (`handoff.md`, data setup notes). The SAM.gov Assistance Listings catalog (program descriptions and statutory authority, not postings) was added Sat Nov 7 from GSA's public bulk file (`src/R/05b_sam_listings.R`); SAM.gov postings and the USDOT page are not loaded (SAM rate limit, USDOT returned 403) | Built for the four sources. Whether the sponsor comments caused this pull is [assumed]. The log does not say |
| Coverage was not a goal | Nobody knows how many opportunities are missed | Plan a recall test against a hand-labelled pool, with a stated baseline (worksheet, section 4) | Decided as a plan. **No labels exist yet** |
| Table was one list for one agency view | Cross-agency by design; no dedicated OSBM team [from notes] | Decision 1 (Kent): one scored table of every opportunity against every agency, agency picker with multiselect as main screen, second tab grouped by opportunity. Closed items are scored too | Decided, **not built**. Link to sponsors: the cross-agency point only |
| Unclear what "missed" means | Nobody knows how many are missed [from notes] | Decisions 2 and 3 (Kent): "missed" means the tool would have flagged it, with no claim about what the agency saw. "NC has won under this CFDA before" is a separate context column, never proof. Flag = score above a threshold, capped at N; the threshold is the lowest score keeping 70% recall in the top N on the pool | Decided, **not built**. The interview, not the sponsors, set the 70% bar |
| Notices were just rows | Grants.gov alone is not comprehensive [from notes] | Decision 9 (Kent): the 104 Federal Register rows stay with a "notice" badge and no deadline or award parts. The pitch says "surfaces notices", not "finds more grants". Keyword recall of the notice pull is [uncertain] | Decided, **not built** |
| Signature tiers were a qualifier idea only | Not raised in the discovery notes | Decision 13 (Kent): a second axis from the qualifier's `tiering.js`. Fields-only first pass for all rows; an Azure OpenAI labeling pass for flagged and top rows; "unknown" never defaults to Tier 1; fields-only ships if the labeling pass is untested at the freeze | Decided, **not built**. Kent's decision, not sponsor-driven |
| Proposal drafting was not considered | A tool that also drafts the proposal would be top tier | Not solving. At most a checklist of requirements as a stretch (worksheet, section 7) | Decided |
| Privacy was not considered | Do not send sensitive information to an arbitrary model. The note recorded "local model", which conflicts with the Azure rule | Inputs to the model are public (opportunities and plans). Whether Azure OpenAI keeps prompts out of training is **[uncertain]**; nobody has read the Azure documentation yet (`07_discovery_findings.md`, `azure_setup.md`) | **Open.** No Azure OpenAI resource exists, and decision 6 now depends on one. Decision 7 says the model never decides; it only writes reasons |
| Demo would run as built | Waiting minutes fails | The deployed proof took 38.2 s to answer after scale to zero (`azure_setup.md`). Plan is one warm replica before any demo | Plan only. Not done. See `planning/08_saturday_plan.md` |

Not in the table because nothing was decided: pursuing private foundations, the federal budget and earmarks (noted by sponsors; worksheet lists them under "not solving until the core works").

## 3. Problem and key requirements

**Problem [from notes, confirmed in the session].** Agency grant coordinators miss or find late federal opportunities that fit their agency. Monitoring Grants.gov and judging fit against strategic plans is manual and uneven (`planning/02_framing_worksheet.md`, section 1).

**Requirements the sponsors stated or implied** (`07_discovery_findings.md`, list of 10), shortened:
1. Save time, never add work.
2. Fast and simple.
3. The tool sorts eligibility, not the person.
4. Rank by payoff and effort, not fit alone.
5. Work across agencies, with a handover plan and some training for turnover.
6. Use public data.
7. Do not send sensitive information to an arbitrary model.
8. Look beyond Grants.gov.
9. Drafting proposals is top tier (we treat it as a stretch).
10. Explain simply.

**Requirements from the organizers** (`docs/QUEST_BRIEF.md`): runs on Azure; public data only; a human decides; address false positives, false negatives, uneven agency documentation and inconsistent data quality.

**Success test, written before any result.** Worksheet section 4 gave the shape. Decision 12 (Kent) now fixes it: three agencies (Department of Public Schools, Department of Environmental Quality, Department of Health and Human Services), 20 items each, two labelers per item, a 70% recall pass bar, labels relevant / maybe / not relevant fixed before labelling, and the pool drawn and written down before scoring. Labels are called "team-labelled", never ground truth. Claude chose the three agencies on Kent's instruction. The DHHS plan text is partly OCR, so its goals need a check first. Also still required: a known-bad item ranks last or is filtered with a reason, and the same input gives the same output (decision 7: temperature 0 and a cache). The known-good case has a problem. See section 7.

**Named weakness (decision 11, Kent):** recall versus shortlist length, measured on our pool. Stale plans and missing sources (SAM.gov postings, the USDOT page; the SAM program catalog is loaded) go on the limits slide and in the Q&A sheet. Pilot ask: a few agencies, a named contact who labels results, threshold retuned from their labels. The measured number is `[TO FILL]`.

## 4. Design decisions and tradeoffs

Dates are from commit dates and file stamps in the repo. "Who" is who the file says, or [unrecorded] if it does not say.

| Date | Decision | Who | Options and tradeoff | State |
|---|---|---|---|---|
| Nov 6 (Fri morning) | **R and Quarto, with a small deployable front end.** Python and Streamlit were the other path | Kent (`handoff.md`, Decisions) | R reuses the qualifier code. The Starter Kit assumes Python, so we write and debug more ourselves. "Revisit if Azure hosting of R is painful" | Superseded in part by the next row |
| Nov 6 (night) | **Stack (decision 6): the qualifier's JS tool reading `payload.json`; Azure OpenAI writes embeddings and reasons; Blob holds payload and cache; Container Apps hosts. Marco's R Shiny proof is the fallback** | Kent, after the interview (`planning/08_product_decisions.md`) | Reuses a tested front end and keeps R for the pipeline. Needs Azure OpenAI and Blob access, neither of which exists. The Shiny proof proves hosting only | Decided, **not built**. `planning/08_saturday_plan.md` (Marco's draft) still says "stay on R Shiny" |
| Nov 6 (night) | **Serve all agencies**, not the one agency the Starter Kit recommends. Evaluate on three (decision 12) | Kent (worksheet status line; decisions 1 and 12) | All agencies matches the sponsors' cross-agency point and the 34 plans we hold. The kit says one real plan "is enough to prove the method". Risk is breadth over depth; the recall test covers only three agencies | Decided, **not built** |
| Nov 6 (night) | **Goal categories use each agency's own goal labels**, no shared taxonomy | Kent (`planning/02_framing_worksheet.md`, final line) | Avoids forcing 34 plans into one scheme. Cross-agency comparison is harder | Decided |
| Nov 6 (night) | **Flag thin or stale plans; do not rank them down** | Draft by Claude; Kent has not edited it (worksheet, section 9) [assumed] | Fairer to agencies with weak documents. Users may trust a low-quality profile | Columns `plan_stale` and `cross_cutting` exist in `agency_goal_summaries.csv`. Ranking behavior is **not built** |
| Nov 6 (night) | **Option B on Option A, now confirmed (decision 7).** Azure embeddings score every opportunity-agency pair once and cache it. Azure chat writes a short reason with a plan quote and a notice quote only for flagged or shown pairs. A script checks each quote appears in its source. The LLM never decides | Worksheet drafted by Claude; Kent confirmed in the interview | A plain reason and Azure use, against credit cost and misreading risk, which the quote check is meant to catch. Option A (TF-IDF) remains the fallback if Azure OpenAI is refused (`08_saturday_plan.md`) | Decided, **not built**. Azure OpenAI does not exist yet |
| Nov 6 (night) | **Eligibility (decision 4):** clearly ineligible items hidden by default with a visible count and a toggle; blank or unclear shows "check eligibility"; applicant-type codes verified against the Grants.gov list first | Kent | Hiding reduces noise but a wrong code hides a real opportunity, hence the count and toggle | Decided, **not built**. Code check is open (Kent) |
| Nov 6 (night) | **Ordering (decision 5):** the qualifier's impact score (percentile parts, missing parts dropped and weights rescaled, slider weights 0 to 3, presets, per-item breakdown). Rules decide the flag; the score only orders | Kent | Reuses a tested method. Percentile ranks hide absolute size | Decided, **not built** |
| Nov 6 (night) | **Scenario presets (decision 14)** and **cut order (decision 15):** cut the feedback button first, then the LLM tier upgrade, then presets. Never cut the table, fit score, flag rule, quote check or recall test | Kent | Protects the evidence the judges score. This replaces the Starter Kit cut order in `08_saturday_plan.md` | Decided, **not built** |
| Nov 6 (night) | **Starter Kit Azure design**: one image, two roles by `MODE` (`app` or `job`); state kept as JSON files in one Blob container | Marco with Claude Code (`azure_setup.md`) | Matches the kit and is simple. Blob access for the app is not wired, so the page reads a CSV baked into the image | `MODE=app` works. `MODE=job` is a stub that exits 0 and is untested in the cloud |
| Nov 6 (night) | **Display-only proof first.** The deployed page shows the opportunities table. No scoring or AI | Marco with Claude Code, commit 4d44b7e | Proves hosting and build before spending time on the product. It proves nothing about match quality | Done. `08_saturday_plan.md` says nobody should describe it as more than hosting |
| Nov 6 (night) | **Container App size**: 0.5 vCPU, 1 Gi, min replicas 0, max 1, identity-based registry pull, no admin password | Marco with Claude Code (`azure_setup.md`) | Cheapest and safest. Scale to zero costs a 38.2 s first load | Min replicas stays 0 until a demo is near |
| Nov 6 | **Keep team API keys in `api_keys.env`, committed** | Kent (commit 78d3d2b; `handoff.md`) | Easy for five people. Safe only while the repo stays private | Decided for the private repo. Must change before the repo goes public. See the state developer README |
| Nov 6 | **Scope kept at ingestion**: all posted and forecasted items, plus closed items with a close date on or after 2024-11-06. Nothing dropped for eligibility | Kent (`handoff.md`, data setup notes) | Keeps the full picture for coverage counting. The table includes 4,947 closed items that a user must not mistake for open ones | Done |
| Nov 6 | **USAspending: pull "government" recipients and flag state agencies by name** because the `state_government` filter returned 0 rows | Kent's Claude session (`src/R/02c_usaspending.R`) | The name rule is a guess. 348 recipients are unclassified | Needs human review (`handoff.md`) |
| Nov 6 | Onboarding ranking | Kent's idea (`planning/05_user_criteria_and_feedback.md`); changed by decision 10 | See section 2 | Decided: optional feedback button after results. Not checked with sponsors |

## 5. GenAI tools used

From `AI_USAGE_LOG.md` only. Dates are all Nov 6, 2026.

| Who | Tool and model (as logged) | Used for |
|---|---|---|
| Noah | Codex (GPT-6) | Rechecked discovery notes and plan inputs; drafted an AI handoff for the plan text check |
| Noah | Claude Code (Sonnet 5.5) | Plan text check rows 1 to 17: extracted text from 17 plans, built `plan_text_check_noah.csv` and `agency_goal_summaries_noah.csv` |
| Marco | Claude Code (Sonnet 5.5) | Azure CLI install and login help, read-only checks, created storage, Log Analytics, container registry and Container Apps environment (each approved by Marco), wrote the hello app and `azure_setup.md` |
| Marco | Claude Code (Opus 5.5 planning, Sonnet subagent execution) | Wrote the Azure proof app, created the budget, built the image, deployed `ffm-app`, tested with curl, wrote results into `azure_setup.md` |
| Kent | Claude Sonnet 5.5 and Opus-class planning | Planned and wrote the ingestion pipeline (`02a` to `02e`, `03`, `test_ingest.R`); probed Grants.gov, Simpler, Federal Register, USAspending, SAM.gov and transportation.gov endpoints |
| Kent | Claude Sonnet 5.5 (3 read-only subagents) | Re-extracted 34 plan PDFs with pdftools and local Vision OCR; drafted the framing worksheet; extracted agency goals for manifest rows 18 to 34 |
| Matthew | Codex, GPT-6 | Extracted assigned plan PDFs locally, checked goal sections, prepared text-check and goal-summary CSVs |

Not in the log, so not claimed here: UNC PromptLab or any chat tool. The log's own note says to include it if used. `[TO FILL: confirm with all five whether any other tool was used]`.

The Saturday plan (`planning/08_saturday_plan.md`) and the overnight handoff were written by Claude for Marco. Those sessions have no row in the log yet. `[TO FILL: add log rows for the overnight session and the Saturday plan]`.

What AI did and what people did, as the log records it: AI wrote code and drafts and ran extractions. Marco signed in to Azure and approved the creates. Kent ticked the framing gate on a Claude draft. People still owe the checks listed in the log (open three PDFs each, open the live URL in a browser, read the portal resource list).

## 6. Key prompts

Excerpts are copied from `planning/06_tonight_plan.md` and `tasks/teammate_ai_rules.md`. They were written by Kent's Claude session for teammates to paste. The repo does not hold the prompts used to write the ingestion pipeline or the framing worksheet. `[TO FILL: paste those from the sessions, or say they are not saved]`.

**1. Azure skeleton (Marco, Claude Code).** Purpose: stand up Azure with approval at each create, no secrets in files.
> "You are helping me stand up the Azure skeleton for our Solve-a-thon prototype... Work only inside the Finalists/ folder of this repo."
> "NEVER write a key, token, connection string or password to any file, commit, or chat output."
> "Stop and ask before: any az create or delete, any role assignment, changing an existing resource, installing anything..."
> "On any failed command: show the exact command and the exact error, then propose one fix. Do not retry the same command blindly."

Result: storage, registry and environment were created Friday with Marco's approval (`azure_setup.md`). The later proof run used a longer plan, not this prompt.

**2. Plan text check (Noah and Matthew, any repo-aware AI).** Purpose: decide which plan PDFs are usable as text without letting the AI guess.
> "Accuracy matters more than speed. If you cannot verify something, write 'unknown'; never guess."
> "Every goals_quote and plan_years value MUST be copied from the extracted text, not paraphrased or recalled."
> "NEVER modify, move or rename anything in Finalists/data/raw/."

The prompt also tells them to spot-check three PDFs by hand and note any AI error for these notes.

**3. Rules block for any chat AI (all teammates).** Purpose: keep teammate AIs from inventing facts. From `tasks/teammate_ai_rules.md`:
> "Do not invent numbers, sources, quotes, names or facts. If something is missing, write 'not found' and tell me."
> "Every number you use must come from the files I give you. Say where each number came from."
> "If you are unsure, say [uncertain] next to the claim."

The quote-check script that backs prompt 2 is `tests/test_plan_tables.R` (56 of 56 pass per `handoff.md`). `[TO FILL: Kent to confirm this check was run again after the final edits]`.

Only three distinct prompts are in the repo. Add more only from real saved text.

## 7. Where AI was wrong and how we caught it

Source: `AI_USAGE_LOG.md`, `handoff.md`, and the repo files named. Each item says whether the fault was the model's content, the model's code, or a tool failure.

| # | What happened | Kind | Who caught it, and how | Check in repo |
|---|---|---|---|---|
| 1 | **Slow XML parser.** AI-written code parsed the Grants.gov extract with `xml2` node by node. It took over 10 minutes. It was replaced by cutting the text into records and using vectorized regexes, about a minute | Code that worked but was too slow. A design flaw, not a wrong fact | Kent's Claude session, by running it and timing it (log: "caught"; the log does not name a person) | Comment in `src/R/02a_grantsgov_extract.R` lines 32 to 33 |
| 2 | **USAspending `state_government` filter returned 0 rows** for NC. The code assumed that filter would find state agencies. The query was changed to "government" (about 12,800 awards that include cities and counties) and state agencies are flagged by recipient name | Wrong assumption about an outside service. Found by probing the live API, so it is an API behavior and not clearly a model hallucination | Kent's Claude session, by seeing 0 rows | Header of `src/R/02c_usaspending.R`; `handoff.md` data setup notes. The replacement name rule is still unreviewed |
| 3 | **Swift invocation error.** A first attempt to run the OCR helper treated a PDF argument as source code and failed | **Tool failure**, not wrong content. Labelled as such because the AI ran a command wrongly | Matthew with Codex; the command failed (log) | Log row only. `[TO FILL: Matthew to confirm the exact error]` |
| 4 | **Quote check rejected valid text.** The check was whitespace sensitive and rejected correct line-wrapped text | **Tool failure** in a checking script, a false alarm, not a wrong result | Matthew with Codex, during verification (log) | Log row only |
| 5 | **Missed goals and cut-off lines.** A first regex missed a goal because of multi-space gaps. Goal lines were cut at line wraps (DMVA, DIT) and carried stray table headers. All fixed | Model content and code error | Noah, with a script that checks every quote against its cited page (log) | Log row; `src/tests/test_plan_tables.R` |
| 6 | **A file that was claimed but empty.** Matthew's Codex CSV said the Justice text had 20,160 characters, but the saved text file was 1 byte | **AI stated something false** about its own output | Kent's Claude session, by comparing the CSV claim to the file (log; `handoff.md` "Bug caught") | `handoff.md`; `src/R/04_plan_text_extract.R` redid all 34 |
| 7 | **OCR timing.** Local Vision OCR run through interpreted Swift took 1 m 52 s per page until compiled | **Tool performance**, not a wrong answer | Kent's Claude session (log) | `.gitignore` notes the compile command |
| 8 | **Known-good test case does not exist in the data.** The AI-drafted framing worksheet names Clean School Bus (CFDA 66.045) as the known-good case, tagged `[uncertain]` (`planning/02_framing_worksheet.md`, section 4). `data/processed/opportunities.csv` has **0 rows** with that CFDA (`planning/08_saturday_plan.md`, finding 1; I re-checked by searching the file for "66.045" and got 0). The only item whose title or summary mentions school buses is the 2026 DERA notice `EPA-OAR-OTAQ-26-01` (CFDA 66.039), per the same plan | Model content error that was flagged as uncertain at the time, then confirmed wrong by a count | Claude, writing the Saturday plan, by checking the table. The `[uncertain]` tag in the draft is what made it a cheap check. A person has not yet reviewed this | See files named. **Still unresolved after the decisions:** the 1:00 PM gate in `planning/08_product_decisions.md` (Order of work, step 3) still requires Clean School Bus (CFDA 66.045 [uncertain]) to appear for education and environment, and that CFDA has 0 rows. As written the gate cannot pass. `[TO FILL: Kent to pick the replacement known-good case and record who confirmed this]` |
| 9 | **Model labels failed the gate, twice.** The local model (`qwen2.5:14b`, prompt `evalpool-v3`) labels each grant relevant, maybe or not relevant for an agency. Its first check, on the hand-labelled validation items the prompt was written against, already FAILED the gate (`drafts/claude/eval/model_labels/gate.txt` says FAIL). We then ran a held-out check on blind items that were not used to write the prompt, labelled by Noah and Matthew without seeing model output. It FAILED again under both ways of combining the two labelers. The two human labelers also disagreed on some items, so the hand labels are noisy too | **Model content error** (labels that miss what people judged relevant), shown by a measurement, not by a hallucination | The gate script on the validation set (Kent's Claude session); the held-out check by Noah and Matthew with `src/R/40_label_check.R` | `drafts/claude/docs/holdout/label_check_result.md`, `data/manual/label_holdout.csv`. The figures (catch share, kappa) are **not found in `src/docs/fact_sheet.md`**: `[TO FILL: Kent to add them to the fact sheet before they are quoted; strict versus lenient combining rule is Kent's call]`. Very few items were hand-relevant, so the result is indicative only. These labels stay out of the 1:00 payload |
| 10 | **Silent row loss in AI-written code.** The SAM listings script (`src/R/05b_sam_listings.R`) kept only program numbers shaped `NN.NNN`, so it silently dropped 210 of the 2,875 rows in GSA's file (lettered numbers such as 11.63A and 93.1CF). The AI first described the gap as "non-CFDA rows and duplicates" in a source note, which was an unchecked guess. It reported 2,665 listings, 2,502 with an authority and 1,456 pool matches; the true figures are 2,875, 2,672 and 1,457 | **Model code error**, plus a wrong explanation written down before it was checked | Noah's Claude, by checking the one number that did not reconcile (2,875 rows in the file against 2,665 out), then counting duplicates (0) and non-matching numbers (210) by script. The wrong counts had already been merged and were corrected in a later PR. Nothing in the ranking reads that file, so no result changed | `src/R/05b_sam_listings.R` now warns when it drops any row; `data/raw/README.md` states the right counts |
| 11 | **Reviewer agents mixed right and wrong claims.** A test-breaker subagent could not run the page and said so. It reported 12 "tribal" rows in Top 10 and 18 of 32 agencies with short lists. Re-checked against `payload.json`: 10 are real tribal programs (the other 2 are Housing Voucher notices) and the short lists were real (18 of 32, from 61 notice rows hidden by the page). It also reported a `localStorage` crash that did not reproduce in a real browser for the two bad inputs I tried (a string and a wrong-shaped array); other inputs were not tried. Separately, the AI's own comms messages carried forward-dated timestamps and one false statement (that its outbox was missing from main) | **Mixed**: mostly correct findings, one overcount, one unreproduced claim, and the AI misreading git state | Noah's Claude, by recomputing every data claim by script and re-running the page in a browser; the false outbox claim was caught by diffing `origin/main:comms/to-kent.md` and corrected in a later entry | `drafts/claude/docs/tool_review_sat.md` tags each finding [verified], [run], [read] or [persona] |

Not an AI error, but related: the worksheet's mentor gate box was ticked by Claude at Kent's request. Claude could not verify that mentors saw the page (worksheet, section 10). `[TO FILL: Kent to say whether mentors did see it]`.

A weakness we can already name for Evaluate: keyword search for "school bus" in the live table returns 690 of 6,523 rows, because each word matches separately across all columns. That is a table search, not a measured baseline (`azure_setup.md`, browser check). Do not use it as a slide number.

## 8. Timeline from the git log

| Date | What |
|---|---|
| Oct 23 to 24 | Planning worksheets, reviewers and teammate guide added (Kent) |
| Nov 4 | OpenCode agents, AGENTS.md, runbook (Kent) |
| Nov 6 | Organizer materials, 34 agency plans and discovery findings committed (6658ebb). Azure skeleton (a94f306). Data ingestion and keys (4095a16, 78d3d2b). Plan text checks by Noah and Matthew merged. Plan re-extraction and framing worksheet draft (ccad3b2, 22:06). Gate ticked (4c3b7e3, 22:15). Azure proof app deployed (4d44b7e, 22:36). Saturday plan draft (68fbe56, 22:38) |

## 9. TO FILL (Saturday and Sunday)

Do not guess any of these. Leave `[TO FILL]` visible until a person has the real answer.

**Decisions** (settled ones removed: onboarding ranking, stack, Option B, agency scope, pool design, named weakness, all in section 4)
- [ ] Privacy: what we tell the sponsors about data sent to the model. Needs the Azure OpenAI data-handling documentation read first. Owner: Marco, Kent.
- [ ] Is Azure OpenAI ours to create (9:00 check-in answer)? Decision 6 depends on it. Owner: Marco.
- [ ] Replacement known-good case for the failed Clean School Bus test, and an update to the 1:00 gate. Owner: Kent.
- [ ] Values Kent has not set: threshold, N, labeled-row cap (`src/R/00_config.R`).
- [ ] Whether decision 6 (JS tool) or the fallback (R Shiny) is what ships, with date and who.
- [ ] Any other plan change made on Saturday, with time and who decided.

**Evidence (never predict)**
- [ ] Evaluation results: recall in the top N against the 70% bar, recall versus shortlist length (the named weakness), keyword baseline, two or more recorded failures. Numbers go in `src/docs/fact_sheet.md` first, from a script.
  - Partly answered (Noah's Claude, Sat Nov 7, from `src/docs/fact_sheet.md` rows 15 and 16, both still "Everett and Kent to confirm"): the award-history backtest on 4-week windows FAILS the 50% bar. DPI 2 of 3 programs (67%), DEQ 3 of 7 (43%), DHHS 4 of 11 (36%), so 1 of 3 agencies pass where the bar needs 2 of 3. The soonest-deadline baseline beats the model in all 3 agencies. This is a second recorded failure beside the label gate. Recall versus shortlist length is still `[TO FILL]`: not in the fact sheet.
- [ ] The drawn pool and the label sheet, written down before scoring (decision 12). Record the date and time they were fixed.
- [x] Held-out label check (model labels): done by Noah and Matthew, blind to model output; method and result in `drafts/claude/docs/holdout/label_check_result.md`. Result: gate FAIL, both readings. Figures are not in the fact sheet yet: `[TO FILL: Kent to add to src/docs/fact_sheet.md]`.
- [ ] Team labels: who labelled each item (two per item), how many items (60 planned), agreement between labelers, whether they saw scores. Call them team-labelled, not ground truth.
- [ ] User feedback: from a real person, with date and role, not a teammate persona. Say plainly if none was collected.
- [ ] What the mentor drop-in said about a real failure (planned 2:00 to 4:00 Saturday).
- [ ] Cost actually spent (`azure_setup.md` plans a 6:00 pm check).
- [ ] Cold start after any change, and whether the demo URL works on venue Wi-Fi and a phone hotspot.

**AI documentation**
- [ ] Log rows for the overnight session and the Saturday plan.
- [ ] Confirm no other AI tool was used (the log note mentions UNC PromptLab).
- [ ] Missing prompts for ingestion and the framing worksheet, or a statement that they are not saved.
- [ ] Three PDF spot checks each by Noah and Matthew, and Marco's browser and portal checks, recorded in the log as done or not done.
- [ ] Any new AI errors caught Saturday (add to section 7 with who and how).

**Names and facts to verify before use**
- [ ] The "$5B" figure and school bus program details, "about 30 AI grants posted now" and "350 K-12" are unverified in the discovery notes. Do not use them as facts.
- [ ] State staff names stay out of this document.
