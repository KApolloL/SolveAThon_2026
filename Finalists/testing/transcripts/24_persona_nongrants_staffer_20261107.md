# Persona run 24: persona-nongrants-staffer (simulated, not user evidence)
Material: first screen a Public Schools staffer sees, built from src/tool/matchmaker.html and data/processed/payload.json (agency "dpi", data_as_of 2026-11-07T11:00). Page counts line would read: "Showing 10 of 13 open opportunities. 3 hidden as not eligible, 0 ranked below the top 10, 17 not open yet." All 10 shown rows say "Eligible: Ask / check the notice". Rows show days left (66, 116, 77, 341, 12, 145, 33, 427, 263, then "rolling or no date listed"). Reasons read "Matches plan goal: <goal text>". Buttons: Pursue / Maybe / Pass. Panels: "Coming up (not open yet): 17", "Hidden as not eligible: 3".

## 1. First reaction
I land on a page that says "Pick your agency." Fine, I find "Department of Public Schools", though my office says Public Instruction. Then ten federal things with big numbers. The first is a Tribal Colleges program. Number four mentions "Revere Public School Educators", which is not us. Every row says "Eligible: Ask, check the notice", so the tool did not answer my main question. I would close it.

## 2. Findings
| # | Where | What was unclear, wrong or missing | Type | Severity | Suggested fix |
|---|---|---|---|---|---|
| 1 | "Eligible: Ask check the notice" (all 10 rows) | Every top-10 row is "Ask". "Ask" is not a word I understand here (ask whom?). The tool does not tell me if we may apply; that is the job I gave it. I must read a federal notice to find out. | confusing output | high | Say "Not sure if Public Schools can apply: open the notice and look for 'Eligible applicants'". Show why it is unsure. Lead with any "Yes" rows. |
| 2 | "Matches plan goal: 2. Revere Public School Educators" | Rows 4 and 5 cite a goal that reads like another school system, not ours. Row 1 is a tribal-college program, row 6 a West Point announcement, row 8 a health-professional research award. I do not trust a "match" that looks off at a glance. I cannot tell whether the plan text is wrong or the match is. | trust | high | Check plan-goal text for non-DPI goals; show the sentence from the notice that links to the goal; drop obvious higher-ed/research/military items from a K-12 list or label them. |
| 3 | Rank order with no reason | No score, no "why #1 over #2", no award size, nothing on effort. The reason line is only a goal title. I cannot tell what the first step is or why this one is first. Row 5 has 12 days left yet ranks 5th, below ones with 66 to 427 days. | missing requirement | high | One plain sentence per row: why it fits us, how much money, deadline, what to do next. State what ranking is by. |
| 4 | "Pursue / Maybe / Pass" | I do not know what pressing Pursue does. Nothing is sent, nobody is told (only saved in my browser, which the page never says in view). I would not click it, or I would think it alerted someone. No next step after Pursue. | next step | high | Replace with "Next step" text, e.g. "Send this link to your division head" or a mailto/copy button; say marks stay on this computer only. |
| 5 | "Showing 10 of 13 open opportunities. 3 hidden as not eligible, 0 ranked below..." | Jargon-heavy sentence of five numbers. "Ranked below the top 10: 0" is odd when I see only 13 total. "Not open yet 17" is a different thing from "open" and I do not know what a not-yet-open one is for. The payload also carries 98 hidden-ineligible for dpi; the page says 3. I cannot tell which is right. | confusing output | medium | One sentence: "13 open grants fit Public Schools; here are the 10 best." Explain or reconcile the 98 vs 3 count. |
| 6 | "Coming up (not open yet): 17" and its rows | Many rows say "date listed has passed" while sitting under "not open yet". That contradicts itself. "Forecasted" is never explained. 7 of 17 are marked not eligible and still shown here. | confusing output | medium | Hide passed forecasts or label them "expected, date has gone by"; apply the eligibility filter here too. |
| 7 | Days block: "341", "427", "rolling or no date listed" | A deadline 427 days away in the top 10 looks like a data mistake. For a "do this soon" tool these crowd out real urgency. Also no actual date shown, only a count. | trust | medium | Show the date next to the count; flag far-out dates; sort or tag "closing soon". |
| 8 | Header / agency name | "Department of Public Schools" is not our name (Public Instruction); first screen is a bare picker with no sentence on what this is, who made it, or that it is a draft. Nothing says how current the data is except "Data as of 2026-11-07T11:00..." (raw timestamp). | framing | medium | Add 2 lines under title: what it does, what it does not decide. Use our real name. Human date format. |
| 9 | Titles | Raw federal titles ("R15 Clinical Trial Not Allowed", "BAA", "NOFO", "RFI", "APS") with no plain description. The opportunity snippet exists in the data but is not shown. | confusing output | medium | Show a one-line plain-language summary and funder name. |
| 10 | Whole page | No help, no legend, no "what does this tool not know" (stale plan banner only appears for some agencies). No place to say a result is wrong. | trust | low | Add a short "How to read this" and a "this looks wrong" link. |

## 3. Questions I would put to the team (hardest first)
1. Why are ten out of ten "Ask"? Does that mean the tool cannot tell, or that none are clearly open to us?
2. Why does a list for Public Schools start with a tribal college program, a military academy announcement and a health-professional research award?
3. Why does a goal about "Revere Public School Educators" appear for us?
4. What happens when I press Pursue? Who sees it?
5. Is the top 10 ranked by deadline, by fit, or by money? Why is a 12-day item fifth?
6. The data says 98 ineligible for us but the page says 3 hidden. Which is it?

## 4. Needed but not shown
Award amount; what the funder is; whether we have ever won this; what applying takes (hours, partners); plain definitions of Ask, forecasted, Pursue; who to hand a "Pursue" to; the ranking basis; how I get a new list next month (a reminder or email).

## 5. Could I state the next step?
No. I could say "open one of the links and read the notice to see if we can apply", but the page never tells me that, and I would not know which row deserves my time.
