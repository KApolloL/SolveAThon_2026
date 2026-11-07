# persona-deputy-secretary, one-shot, 2026-11-07 (simulated persona; hypotheses, not user evidence)

Material: DHHS rows in data/processed/payload.json (data_as_of 2026-11-07), src/tool/matchmaker.html, data/manual/criteria.csv. Facts I relied on: DHHS has 30 rows: 10 posted top-10 (all eligibility "yes"), 5 posted hidden "no", 10 forecasts shown (8 yes, 2 ask) plus 5 forecasts hidden "no". All 30 have elig_source "code" and elig_quote empty. The screen shows days, title link, Eligible badge, "Matches plan goal: ...", Pursue/Maybe/Pass. It does not show award_ceiling, cfda, nc_won_before, opp_snippet, elig_quote, fit_score or cost share. criteria.csv: fit weight 1; award_size, no_cost_share, runway weight 0.

## 1. First reaction
I get a list of ten with a green "Eligible: Yes" and a sentence saying it matches our plan. Nothing says what it costs us, whether we need match, or who must sign. Four of the ten are NIH research grants a state agency may not even be able to lead. The "reason" for an animal food standards grant is our behavioral health crisis priority. I can't sign off on "the system recommended it." Show me what you dropped and why; right now I see titles and the word No.

## 2. Findings
| # | Where | What was unclear, wrong or missing | Type | Sev | Fix |
|---|---|---|---|---|---|
| 1 | "Eligible: Yes" badge, no quote | All 30 DHHS rows have elig_source "code" and empty elig_quote. "Yes" shows no evidence, so I can't tell "notice says states can apply" from "nothing excluded us". | trust | high | Show the notice sentence behind Yes/No; label code-only Yes as "not excluded" |
| 2 | "Matches plan goal: PRIORITY 3: Strengthen Behavioral Health Crisis Care" | Animal Food Regulatory Program (rank 8) and Preschool Development Grant (rank 7) carry the crisis-care goal. A reporter would laugh; the reason reads as made up. | trust | high | Show the opportunity text next to the goal, or say "weak match" under a score cutoff; fit 0.42 is shown as a rank only |
| 3 | Top 4: NIH PAR-25-285/310/283/317 | Investigator-initiated research (R01/R61) ranked 1-4 with 62-427 days left. Unclear if a state department can lead or if a university would. These push the real service grants (OJJDP, PDG B-5) down. | framing | high | Flag research/clinical-trial notices as "partner-led"; do not rank above service grants without a note |
| 4 | Row meta: nothing on money | Award size, cost sharing and runway are weight 0 in criteria.csv; award_ceiling, cost share, match are not on screen. PDG B-5 is $15,000,000 and the screen says nothing. I can't see match, staff or post-award reporting. | missing requirement | high | Show ceiling, cost-share Yes/No/unknown and reporting note; or say plainly the tool ignores them |
| 5 | "Hidden as not eligible: 5" | Hidden rows show title and "Eligible: No" but no reason; elig_quote empty for all. I can't verify I didn't lose a fit. Hidden also contains NIH "Limited Competition" items that may be limited to named institutions, and I can't tell. | trust | high | Print the exclusion sentence per hidden row; make hidden list readable by default |
| 6 | "Pursue / Maybe / Pass" | Saved only in my browser, never sent. No owner, no date, no handoff. No named person owns the follow-up; a Pass leaves no record I can show a reporter. | next step | high | Add owner and note, and an export; or state this is a pilot decision for OSBM |
| 7 | days_left 343 and 427 | Two to four of the "top ten" are a year out while OJJDP items close in 10 days with staffer time needed now. Order mixes urgency and fit with no urgency cue; runway weight is 0. | confusing output | medium | Show a closing-soon marker; separate "decide this week" |
| 8 | "Coming up (not open yet): 15" | Counts 15 forecasts, of which 5 are eligibility "no" and appear inside this list, and one shows "date listed has passed". Includes LEAP/HEDAP marked no. Unclear what I should do with a forecast. | confusing output | medium | Hide ineligible forecasts or label; say what to do before open |
| 9 | Banner logic: plan_stale False, plan_thin null | Null for DHHS means no warning, but the DHHS plan is the OCR'd one per handoff context. I can't tell whether the plan is trusted; the tool must not quietly rank us on a weak plan. | trust | medium | State the plan source and year on screen, with OCR caveat |
| 10 | "nc_won_before": True on OJJDP/PDG | Field exists in the payload but is invisible to me; a prior NC win would reassure me and cost the tool nothing. Also would not be proof. | confusing output | low | Show as context "NC has won this CFDA before" |
| 11 | Whole screen | No claim of how good the ranking is (recall, misses) for DHHS. I can't tell whether top 10 catches what staff would. | trust | medium | Show backtest result for DHHS on the page or in a one-pager |

## 3. Questions for the team (hardest first)
1. Who decided "fit to plan" should be the only ranking driver, and why are award size, cost share and deadline set to weight 0 when I must justify match and staff time?
2. What does "Eligible: Yes" rest on when no quote is stored, and what happens when a state agency is only allowed as a partner?
3. Why are four NIH investigator research grants our top four? Who at DHHS would write them?
4. Why does the animal food grant read as matching crisis care? How many top-10 reasons are this loose for DHHS?
5. Show me the five posted items you hid and the sentence that excluded each. Which would I regret?
6. Who owns the follow-up on a Pursue, and where is that decision recorded if not in my browser?

## 4. What I needed that is not shown
Cost share or match per item; award ceiling on screen; reporting and staffing burden; the exclusion sentence for hidden items; which division would own each grant; the plan's date and quality for DHHS; a measured miss rate for DHHS; who signs (the qualifier tier exists in payload as signature_tier but is not on screen); a one-page printable summary with a decision line.

## 5. Could I state the next step after reading it?
No. I'd tell staff "look at the OJJDP items closing in 10 days," but nothing on the page says so, and nothing says who or what is committed. Not stated: next step, owner, cost.
