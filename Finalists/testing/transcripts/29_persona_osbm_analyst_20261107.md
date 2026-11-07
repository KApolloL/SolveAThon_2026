# Persona review: OSBM analyst (simulated persona, not user evidence)
Date: Sat Nov 7, 2026. Material: payload.json (data_as_of 2026-11-07T11:00, window_days 14, 960 rows, 32 agencies), matchmaker.html, agency_map.csv, plan_text_check.csv, azure_setup.md, app/entrypoint.sh, 00_config.R (REF_DATE 2026-11-06).

## 1. First reaction
It looks like a clean agency picker, but I cannot run it. The daily job is a print-and-exit stub, the app serves a 3-day SAS-key blob, and nobody is named to refresh it. The same fit score rules for 32 agencies, and several get a list that looks wrong. When an agency calls me, I have no why-not trail.

## 2. Findings
| # | Where | What was unclear, wrong or missing | Type | Sev | Fix |
|---|---|---|---|---|---|
| 1 | "MODE=job: refresh stub ran at" | The daily refresh does not exist. Data is a hand-uploaded payload.json; no job, owner or hours. "Data as of" will freeze while the page looks live. | cost / next step | high | Name one owner and schedule; until the job exists, show age in days and turn amber after 2 days. |
| 2 | "Read-only SAS on that one blob, expires 3 days" | The data link dies about Tue Nov 10 unless someone renews it; the role fix needs a subscription Owner. A pilot would go dark silently. | trust / privacy or security | high | Get the managed-identity role before the pilot; document who renews. |
| 3 | `data_as_of` 2026-11-07T11:00 vs REF_DATE 2026-11-06 | days_left is computed against Nov 6 (SBIR closing Nov 17 shows 11 days) while the banner says Nov 7. Every count is a day too long, and the page does not say which date it uses. | confusing output | high | One reference date, derived from data_as_of, shown on screen. |
| 4 | Agencies in payload: ncsbe, osa, wrc, commerce all plan_stale | 4 of 32 flagged stale; plan_thin is null for all 32 even though plan_text_check lists DHHS as "partial" extraction (OCR). Banner says only "may be out of date". Elections still gets 7 rows of NSF/biomedical and DOE items; State Auditor gets 10 NASA ROSES rows. | confusing output / trust | high | Hide or demote the list when the plan is stale; state what the match used. Explain why thin is empty. |
| 5 | Visible on-screen Top-10 per agency | Posted, in_top10, not "no": 259 slots, 189 distinct items, 52 items repeat across agencies (BJA Justice Reinvestment, Fair Housing, OJP in 4 agencies each). Same item, same score, different agency, no one told to coordinate. Spread: 10 shown for 15 agencies, but only 2 for Commerce, OAH and State Controller, 3 for OSBM. | missing requirement | high | Show "also matched to: X, Y" on each row; say plainly that a short list is a signal, not an error. |
| 6 | "Coming up (not open yet)" | 477 forecasted rows; 173 carry "date listed has passed" and 85 "rolling or no date listed". Only 219 have a usable date. These are listed under "not open yet" while the date is already behind us. | confusing output | medium | Move past-date forecasts into a separate "check status" group; do not count them as upcoming. |
| 7 | Pursue / Maybe / Pass, "saved in this browser only" | Feedback is local, never sent, so it cannot change results and I cannot read it. Good for privacy, but then "feedback improves matches" must not be claimed. No disputed-match path. | missing requirement | high | Either say plainly "no learning", or send a Pass reason to Blob with a named reader. Add a "this is wrong" link to a mailbox. |
| 8 | Card: "Matches plan goal: ..." and `fit_score` 0.9802 | Commerce rank 1 is a USDA SBIR with a goal about "services to businesses". The score is shown nowhere and the reason is a plan sentence, not why this program fits. I cannot explain a 0.98 to an agency or a legislator. | trust | high | Show matched terms and the notice sentence; publish how the score is computed and its known false-positive rate. |
| 9 | `signature_tier` unknown for all 960; `nc_won_before` true for 93 | Qualifier tier axis is empty in the payload; "won before" is not shown. Dead columns suggest the data model promises more than the page gives. | framing | low | Drop or hide unused columns before anyone cites them. |
| 10 | Cold start 38 s; min replicas 0 | Sponsors said waiting fails; a Monday user hits 35-40 s on first open. Min 1 needs approval and costs money, not decided. | cost | medium | Decide min replicas 1 for the pilot and put the cost in the ask. |
| 11 | agency_map.csv, 35 lines | 34 plan files become 32 agencies by hand-fold (SBE into DPI; Guiding Principles dropped). UNC and NCCCS show 45 hidden vs 98 for others; I cannot tell why. State Board of Elections plan runs 2023-2025 and is expired. | trust | medium | Explain hidden counts; say which plan years are expired. |
| 12 | Eligibility `elig_source` code 948, rule 12; `reader_label` null | Eligibility "no" hides 163 posted rows (about 39% of 422) by a code rule, and I see no check of how often it hides a real fit. Hidden list exists but is not counted in any recall figure I was shown. | trust | medium | Sample 30 hidden rows per week and report the error rate. |

## 3. Questions I would put to the team (hardest first)
1. Who runs the daily refresh on Nov 10, with what hours, and what do they do when it fails at 6 am?
2. When the State Auditor opens this and sees NASA research, what do you tell them, and why does an agency with a stale plan get a list at all?
3. Which date does "days left" use, and will it match Grants.gov on the morning someone checks?
4. When two agencies get the same Justice item, who decides which applies?
5. Where does a "Pass" go, who may read it, and does it ever change a ranking?
6. What is the share of hidden-as-ineligible items that are actually eligible, and how was it measured?

## 4. Not shown
Who owns OSBM's side after the pilot; a reproducible score recipe; any measured agency-level recall outside the three test agencies; how the 38 hours of weekend data refreshed; whether Azure OpenAI terms allow this data; log of changes between payloads (I cannot tell what moved this week).

## 5. Could I state the next step?
Partly. The next step is to pick the owner and approve a daily job with min replicas 1 and a managed-identity role. The material shows the need but no named owner or cost figure, so I could not give a number.
