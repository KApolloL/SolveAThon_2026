# Transcript 23: persona-user, 2026-11-07

Simulated persona (hypotheses, not user evidence). Material shown: the DEQ screen (agency "deq", Department of Environmental Quality) as `src/tool/matchmaker.html` renders `data/processed/payload.json` (data_as_of 2026-11-07T11:00, window 14 days). Counts line the page prints: "Showing 9 of 13 open opportunities. 4 hidden as not eligible, 0 ranked below the top 10, 16 not open yet, 1 notice (not ranked)." The page renders only: days left (or date note), title link, "Eligible: Yes/Ask/No" badge (plus "check the notice" when Ask), "Matches plan goal: <full goal sentence>", Pursue/Maybe/Pass buttons. No banner for DEQ (plan_stale false). No award size, no signature level, no cost share, no reason for eligibility, no quote. Top list (rank, days left, eligibility): 1 DERA National Program (77, Ask); 2 EDA FY25 Disaster Supplemental (no date, Ask); 3 RESTORE Act Direct Component Non-Construction (359, Yes); 4 EPSCoR E-CORE research infrastructure (256, Yes); 5 Atlanta FY 2021 - FY 2023 EDA Planning and Local Technical Assistance (no date, Yes); 6 Great Basin CESU cooperative agreement (24, Ask); 7 Solid Waste Management Grant Program (55, Ask); 8 North Atlantic Coast CESU (8, Ask); 10 Hawai'i-Pacific Islands CESU (8, Ask). Rank 9 is not on screen. Hidden-as-ineligible (4): Superfund P42 (689), DARRP Restoration Implementation Grants (12), Technical Assistance and Training Grant Program (55), Landscape Scale Restoration for Tribes (81). Coming up (16): mostly NIH/NIEHS and CDC items, several with "date listed has passed", four rated "Eligible: No".

## 1. First reaction

Monday, 20 minutes. Row 1 is DERA, which I do know, good. Then EDA disaster money with no date, a 2021-2023 EDA notice that sounds dead, and three "Cooperative Ecosystem Studies Unit" items for places like Hawai'i that are university-partner deals, not us. The badge says "Ask" on most rows and tells me nothing. No dollar amount, no who-signs, no match requirement. I can't tell what to do first. The 8-day items are scary but look irrelevant, and the one real 12-day item (DARRP) is hidden as "not eligible".

## 2. Findings

| # | Where in the material | What was unclear, wrong or missing | Type | Severity | Suggested fix |
|---|---|---|---|---|---|
| 1 | "Hidden as not eligible: 4" (DARRP Restoration Implementation Grants, 12 days) | The one hidden item with a real clock and an environmental-damage name is buried, with no reason shown. If hiding it is wrong I never see it. | trust | high | Show the one-line reason (who is eligible) in the hidden list; keep short-deadline hidden items visible in a flagged line. |
| 2 | Rows 6, 8, 10: "Cooperative Agreement for affiliated Partner with ... Cooperative Ecosystem Studies Unit" | Three of nine rows are the same university-network program for other regions (Great Basin, Hawai'i-Pacific). Looks obviously wrong to anyone who knows the job; wastes my top 10. | confusing output | high | Collapse near-duplicates into one row; down-rank university-only programs; say why a row matches. |
| 3 | "Eligible: Ask  check the notice" (6 of 9 rows) | "Ask" does not tell me what to check or who to ask. Checking is the work I am trying to avoid. | next step | high | Show the eligibility sentence from the notice and say "state agencies: not stated". |
| 4 | Row 5: "Atlanta FY 2021 - FY 2023 EDA Planning and Local Technical Assistance" | Looks like an old-year notice, shown as Eligible: Yes with no date. I cannot tell if it is open. Title also shows raw codes like "&#8211;" in other rows. | confusing output | high | Flag undated or old-year items; decode HTML codes in titles. |
| 5 | Rows 2 and 5: no days number, text "rolling or no date listed" | "No date" sits at rank 2 and 5 with the same visual weight as a countdown. Cannot tell if I have 3 days or 3 months. | missing requirement | medium | Label "date unknown, open the notice"; sort or separate from dated items. |
| 6 | "Matches plan goal: Goal 1 Environmental and Public Health Protection: Protect public health by setting..." | The same long goal sentence repeats down the page. It says nothing specific about this grant, so it reads like a generic stamp (a black-box reason). | trust | medium | Show a short phrase from the notice that matches, not the whole goal. |
| 7 | "Showing 9 of 13 ... Top 10" heading text and ranks 1 to 8, 10 | The page promises a top 10 but shows 9 and skips rank 9 without comment. Small, but it makes the list feel buggy. | trust | medium | Renumber, or say a rank was removed as ineligible. |
| 8 | Coming up (16): "date listed has passed", "Eligible: No" | The "coming up" list includes expired and ineligible items that are mostly NIH research. I will not open a 16-item panel full of clutter. | confusing output | medium | Drop expired and not-eligible forecasts from this panel or count them separately. |
| 9 | Rows have no dollar figure or match requirement | I cannot judge payoff versus effort, which the sponsors said matters. | missing requirement | medium | Show award ceiling and cost share when known, "not stated" otherwise. |
| 10 | Pursue / Maybe / Pass buttons | Saved only in this browser; my choice goes nowhere, so my supervisor never sees it. I cannot send or print a short list. | next step | medium | Add a plain copy or print of the Pursue list. |
| 11 | Rows with no "who signs" cue | I cannot tell whether I can submit this myself or need my director. | missing requirement | low | Show the signature level if it is already computed. |

## 3. Questions for the team

1. Why is DARRP (12 days left) hidden as not eligible, and who decided that, from what text?
2. Why do three Cooperative Ecosystem Studies Unit deals for other regions rank in my top 10?
3. What does "Ask" mean in practice, and what do I do about it in five minutes?
4. Is the EDA 2021-2023 item open at all?
5. Why is there no rank 9 and no dollar amount?
6. Who sees my Pursue marks, and can I send them to my boss?

## 4. Anything I needed that is not shown

Award size and match requirement; who signs; the eligibility sentence behind each badge; why each hidden item is hidden; the date a rolling item last updated; whether DEQ staff were involved in the plan matching; how the Top 10 was judged against what I would pick myself. I cannot tell how right the list is.

## 5. Could I state the next step?

No. I would open DERA (77 days) and probably the Solid Waste program (55 days), but the screen does not tell me that is the step, and I would not trust the 8-day items or the hidden DARRP without checking myself.
