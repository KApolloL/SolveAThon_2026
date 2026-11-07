# 17 threat-auditor, Sat Nov 7 2026

Reviewed: `docs/QUEST_BRIEF.md`, `data/processed/payload.json` (data_as_of 2026-11-07T11:00, 960 rows, 320 Top 10), `data/manual/*.csv`, `src/R/helpers_rank.R`, `src/R/11_build_payload.R`, `data/processed/backtest_result.csv`, `src/tool/matchmaker.html`, `app/app.R`, `app/entrypoint.sh`, `src/docs/fact_sheet.md`, `src/docs/qa_cheatsheet.md`, field notes draft, `planning/09_tool_plan_update.md`, `saturday/01_goals.md`, `drafts/claude/eval/`.

Stale statements noticed in `testing/context.md` (files win): "payload.json (not yet)", "criteria.csv does not exist", "fact_sheet empty", "qa_cheatsheet template" (partly true: Q&A sheet is still an empty template), "6,523 rows / 1,472 open" now 1,576 ranked, "723 no ceiling" now 887 in the fact sheet. Not relied on.

## 1. Threat table

| Threat | Defense in the build (file) | Measured? | Shown to the user? | Sentence the team can say on stage | Status |
|---|---|---|---|---|---|
| False positives | Top 10 per agency by TF-IDF fit; "Ask"/hide eligibility with exact quote only on 2 Top-10 rows (`helpers_rank.R` `assign_eligibility`); geo penalty 0.5 on 40 titles naming another state (`geo_other`); human review = Pursue/Maybe/Pass buttons (`matchmaker.html`). **No confidence threshold**: Top 10 is always filled; lowest Top-10 fit_score is 0.19 (payload). Reason shown is the plan goal heading, not a quote from the notice; 18 of 320 Top-10 rows have no goal snippet. | No. No false-positive rate. `sat_checks.csv` holds 16 spot checks (DERA, dates, applicant codes); none rates a Top 10. Model-vs-hand label gate in `drafts/claude/eval/model_labels/gate.txt` is FAIL and is on 60 pool items with one labeler. | Partly: fit score is not shown, only goal heading text plus Eligible badge. Marks are browser-only. | "We do not claim a hit rate. Every row links to the notice, shows the plan goal it matched, and a person presses Pursue, Maybe or Pass." (Do not say "confidence" or "threshold".) | partly |
| False negatives | `backtest_result.csv` award-history recall for DPI, DEQ, DHHS at 2/4/6 weeks, with CI and two baselines. Pilot plan keeps coordinators checking manually (`planning/09_tool_plan_update.md` l.82; `src/docs/organizer_materials_notes.md` l.33). | Yes, and it fails: 4-week recall DPI 2/3 (0.67), DEQ 3/7 (0.43), DHHS 4/11 (0.36); 1 of 3 agencies meets the 0.50 bar (pass needs 2 of 3). The soonest-deadline baseline beats the tool in DEQ and DHHS (0.71, 0.73). CIs run roughly 0.06 to 0.99. Denominator caveat already known (own top 50). | No. Not in the tool. Only the result file and a planned slide. | "We measured it, it missed the bar we set beforehand, and a deadline sort did better for two agencies. So the pilot keeps manual monitoring and measures recall against it." | partly (measured honestly, but result is a fail and the manual-monitoring line is only in planning notes, not in a shipped doc) |
| Uneven agency documentation | `plan_stale` flag (4 agencies: osa, ncsbe, wrc, commerce) drives a banner in `matchmaker.html` ("plan may be out of date"). Not ranked down (field notes, "flag, do not rank down"). | Stale: yes, from a goals-table flag. Thin: no, `plan_thin` is null for all 32 (`11_build_payload.R:40`, "not measured yet"); the thin-plan banner code can never fire. | Stale: yes. Thin: no. | "Four agencies have out-of-date plans and the page says so. We did not measure thin plans; that is a pilot task." | partly |
| Inconsistent data quality | `prep_opportunities`: ceiling 0 or blank becomes unknown; close dates on or after 2030-01-01 and lapsed forecast dates become "rolling or no date listed"; applicant code 25 and blank codes become "ask"; counts in the fact sheet (488 no usable date, 887 no ceiling, 3,030 hidden, 16,540 ask). Far-future dates were hand-checked in `sat_checks.csv` (10 rows; 2 are unclear). | Counted, not error-rated. | Date: yes, per row. Eligibility: yes, per-agency hidden/ask counts line. **Award ceiling is never rendered** (136 of 320 Top-10 rows have none, unseen). The 488 and 887 totals are not on the page. | "We show what the notice leaves out as 'no date listed' and 'check the notice', and count it: 488 open items have no usable date and 887 no ceiling." | partly |
| Minimum statewide reporting schema / standard profile template (the sub-asks in threats 3 and 4) | Only in the Starter Kit note ("profile template per agency") and planning. No schema or template file exists. | No | No | "In the pilot, each agency fills a one-page profile and a short outcome record; we have not drafted it." | promise only |

## 2. Bonus quests

| Quest | Status | File | What is missing |
|---|---|---|---|
| Measure Your Reach (coverage metrics) | partly built | `backtest_result.csv`, `src/R/20_backtest_awards.R`, `12_backtest.R` | It is a recall-vs-award-history proxy that fails its bar. No "caught that manual monitoring might have missed" count; the in-time (21 days) curve is a stretch goal in `saturday/01_goals.md` and not built. Never shown in the tool. |
| Race the Clock (deadline alerts) | partly built | `matchmaker.html` (daysBlock) | Days-left per row exists. No Closing-soon panel, no new-since-last-visit, no alerts, and `REF_DATE` is fixed at 2026-11-06 so days-left goes stale. 90 Top-10 rows show no date; 73 have 14 days or less. Daily job is a stub (`app/entrypoint.sh`). |
| Learn From the Users (feedback loop) | partly built (buttons only) | `matchmaker.html` marks in localStorage | Pursue/Maybe/Pass never leaves the browser; no endpoint, no re-ranking, no Rocchio. It cannot "improve future recommendations". Label as a decision log, not a loop. |

## 3. Example bad matches (agencies other than OAH and DPI)

| Agency | opp_number | Title (short) | Why it looks wrong |
|---|---|---|---|
| State Auditor (osa, plan stale) | AFPRA-20-04 | U.S. Embassy Praia (Cape Verde) Ambassador's Special Self-Help Program | A foreign-embassy small-grant for Cape Verde, rank 1 for osa at fit 0.81, matched on "Culture of Excellence". Same item is rank 1 for dst and rank 2 for sos. Matching on generic management words, not subject. Eligibility "ask", so it shows. |
| Revenue (dor) | FA875025S7001 | Foundations of Trusted Systems (Air Force Research Lab) | Rank 1 at fit 1.0 with 760 days left; snippet is a bare sam.gov URL. Matched to "Tax System Modernization" by the word "systems". Same agency's ranks 2, 4, 6, 7 are NIH research programs; none relate to tax administration. |
| Environmental Quality (deq) | G27AS00073 (also G27AS00045) | Cooperative Agreement, Hawai'i-Pacific Islands Cooperative Ecosystem Studies Unit (invasive horticulture in Hawai'i); and Great Basin CESU (Lake Tahoe stream temperature) | Ranks 10 and 6 for a North Carolina agency. The geography penalty missed them because the title says "Hawai&#699;i-Pacific" (encoded character) or names a CESU not a state. Opp text says Hawai'i / Lake Tahoe Basin. Also deq rank 5 EDA Atlanta "FY2021-FY2023" planning notice, which is an old regional notice. |

Also seen: Commerce Top 10 is 8 Federal Register notices on USDA Rural Development programs (ranks 2,3,5 to 10), none with a deadline; DHHS rank 8 PAR-25-003 Animal Food Regulatory Program Standards matched to "Behavioral Health Crisis" snippet.

## 4. Findings

| # | Where | Problem | Severity | Suggested fix |
|---|---|---|---|---|
| 1 | `matchmaker.html`, `10_run_ranking.R` | No confidence floor: Top 10 is always 10 rows, minimum fit 0.19. Fit is normalised by the agency's best match, so the best item scores 1.0 even when nothing fits (dor, ncsbe). Brief names confidence thresholds. | high | Add a raw-fit floor in `00_config.R`, show "weak match" on rows under it, allow fewer than 10 (planning 09 already says "never padded"). |
| 2 | Top 10 overall | No measured false-positive rate; spot checks (`sat_checks.csv`) are about dates and eligibility, not match quality. | high | 20-minute hand rating of 10 rows for 3 agencies (relevant/maybe/not), report it as team-labelled. |
| 3 | `11_build_payload.R:40` | `plan_thin` is NA for all agencies, so the thin-plan warning is dead code; threat 3 is half answered. | medium | Compute a thin flag (goal count 3 or fewer, per planning/09, 12 agencies) and rerun the payload, or drop the banner claim. |
| 4 | `matchmaker.html` | `award_ceiling` never shown; 136 of 320 Top-10 rows have none; the 488 / 887 data-quality counts exist only in the fact sheet. | medium | Render ceiling or "not listed" per row and a one-line data-quality count under the picker. |
| 5 | `helpers_rank.R` `geo_other` | Encoded titles ("Hawai&#699;i") and CESU/regional names bypass the geography penalty; out-of-state items remain in DEQ's list. | medium | Decode HTML entities in titles before matching; add region terms and "Cooperative Ecosystem Studies Unit". |
| 6 | Payload / ranking | Generic-word matches: same Embassy Praia item is Top 3 for dst, osa, sos; research NIH/NSF/DoD items fill dor, doa, osa. | medium | Add per-opportunity cap on how many agencies it can top (it is matching boilerplate), or require a minimum overlap on non-generic terms. Put in the Q&A as a known failure. |
| 7 | `matchmaker.html` | Feedback buttons are local only; bonus quest 3 is labelled as a loop in plans. | medium | Call it "decision log" on slides, or ship `/feedback` before Saturday freeze. |
| 8 | `app/entrypoint.sh`, `REF_DATE` | Daily job is a stub and REF_DATE is fixed, so "days left" and Closing-soon are stale after Nov 6. | high for bonus 2 | Compute days_left in the browser from `close_date`, add the Closing-soon tile (under 14 days, 73 Top-10 rows qualify). |
| 9 | Docs | No profile template or minimum reporting schema file; threats 3 and 4 asks are promise-only. | medium | One page `docs/agency_profile_template.md` and a 6-field outcome schema; mention as pilot deliverable. |
| 10 | `backtest_result.csv` | 1 of 3 agencies passes; baseline beats the tool for DEQ and DHHS. On-stage claim must not be "recall is good". | high | State the miss plainly and use it as the named weakness; pitch manual monitoring as the pilot control. |
| 11 | `sat_checks.csv` | 2 of 10 far-future dates are unclear (CDC RFA-DD-18-000, RFA-TS-18-000), yet all >=2030 become "rolling or no date listed". | low | Footnote that the label is a display choice. |

## 5. [cannot assess]

- Whether the live Azure site matches the local `matchmaker.html` and payload (no network use).
- Whether `data/manual/sat_checks.csv` quotes truly appear on the cited pages (not re-fetched).
- Whether any real user or sponsor reviewed the result; none recorded.
- Slide deck contents (not in the material list); whether manual monitoring and templates appear on slides.
- Hand labels from labelers A/B: only the model-vs-Kent validation exists; no scored recall file was found.
