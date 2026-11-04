# Competition-day runbook (Fri Nov 6 to Sun Nov 8)

For all five of us. Kent fills the names in "Roles" by Thursday. Times are the organizers' schedule. Read your role first.

## How work moves
- **Kent** builds the pipeline with Claude as the main planner and drafter. Other AI tools do small tasks and return them to Claude to polish and check.
- **Teammates** work in the shared Google Drive folder, one subfolder per role (`A_client`, `B_data`, `C_story`, `D_qa`). Save everything there. Kent copies what is needed into the repo. You do not need to use git. If you do, make a branch and never touch `main`.
- **Each task** has a one-page brief (`tasks/TASK_BRIEF_TEMPLATE.md`): inputs, output file, what done means. Do only that task. Stuck for 20 minutes: ask Kent.
- **Your AI** (ChatGPT or UNC PromptLab): paste `tasks/teammate_ai_rules.md` first, then your brief. Always check its output yourself. Log every use in `AI_USAGE_LOG.md` (ask Kent to add the row, or send him the line).
- **Numbers:** only numbers from `src/docs/fact_sheet.md` go on slides. If a number is not there, ask Kent.
- **No personal data. No keys or passwords in any file.**

## Roles (fill in names)
| Role | Name | Job all weekend |
|---|---|---|
| Kent | Kent | Technical lead. Frames with the team, builds the pipeline, makes final calls on criteria and scope, merges code. |
| A: Client lead | | Leads the questions in the workshop. Then researches the agency's goals and drafts the user persona. Runs the persona role-plays. |
| B: Data and testing | | Takes workshop notes. Then writes test cases before results exist, hand-labels a blind sample, spot-checks results against the raw data. Runs the test-breaker. |
| C: Story and slides | | Follows up in the workshop. Then builds the slides with their AI from Kent's slide brief and owns the demo script and the Devpost text. |
| D: Q&A and proof | | Keeps time in the workshop. Then builds the Q&A cheat sheet, runs the hostile judge, checks every slide number against the fact sheet, and keeps the AI-use log and the disclosure. |

## Friday Nov 6 (Manning 209)
- **5:30 to 6:00 Registration and dinner:** everyone has a charged laptop and a notebook. Kent checks the repo and Claude work.
- **6:00 to 6:30 Welcome:** C and D write down who the agency is, who the user is, and words the sponsors use. Roles only, no personal data.
- **6:30 to 7:30 Client Discovery Workshop** (use `planning/01_discovery_questions.md`):
  - A asks the questions. B writes answers word for word. C asks follow-ups ("can you give an example?"). D keeps time and makes sure the priority questions get answered. Kent listens for what data we will need.
  - Do not pitch our ideas. End by saying back: "the user is X, the decision is Y, a good answer looks like Z."
- **7:30 to 8:45 Solution Design Sprint:**
  - Kent runs the framing worksheet (`planning/02_framing_worksheet.md`) with Claude. A drafts the user persona. B drafts 5 test ideas from the criteria. C and D draft the one-sentence problem and the ask.
  - The gate: user, decision, 3 to 5 measurable criteria, success test, and options with tradeoffs written down. Nobody opens the data before this.
- **8:45 to 9:15 Mentor check-in (optional, Weitong Zhang):** show the one-page framing, ask them to attack the criteria.
- Then rest. Do not build before the framing is written.

## Saturday Nov 7 (Manning Library)
- **9:00 to 9:30 Check-in:** Kent restates the framing in one sentence; roles confirmed.
- **9:30 to 1:00 Morning build:**
  - Kent builds. Technical mentors Pratik Patekar and Girish Wangikar: ask them data and code questions, not framing questions.
  - A: agency research and persona drafts. B: test cases and the blind hand-label sample. C: slide skeleton and demo script outline. D: Q&A question bank.
  - Industry mentor Rhett Lavender (ThermoFisher) drops in: show the framing and ask what is unclear.
- **1:00 to 2:00 Lunch and mid-day check-in:** the gate. Is there a working ranking? If not, cut scope.
- **2:00 to 6:00 Afternoon build:**
  - Kent finishes the pipeline. B runs the test-breaker and finds at least one real failure. A runs the persona role-plays. D runs the hostile judge on a first pitch.
  - 2:00 to 4:00 Industry mentor Aries Rosales (GeniusLabsAI): bring the failure and the draft ask. Technical mentors Haihan Gao and Girish Wangikar.
  - By 5:00: Kent gives C the slide brief and figures.
- **6:00 to 7:00 Dinner:** decide the main weakness, its tradeoff, and the ask.
- **7:00 to 8:00 Work wrap up (Weitong Zhang, Haihan Gao):** code freeze at the end. Fact sheet complete. First slide draft exists. Decide the late block.
- **Late block (optional):** C finishes slides, D checks every number, everyone rehearses out loud with a timer. Set a stop time and sleep.

## Sunday Nov 8 (Manning 209)
- **Before 9:00 Submission:** C and Kent submit (likely Devpost; Kent confirms what it needs). D checks slide numbers against the fact sheet. One full rehearsal.
- **9:30 to 10:00 Team and judge check-in.**
- **10:00 to 12:30 Presentations: 5 minutes plus 2 minute Q&A.** Plan: the ask 0:30, why 1:15, how 0:45, limits 1:00, next step 0:45, buffer 0:45. That is about 650 to 750 spoken words. Lead with the answer; show the demo if it is good; ask the judges a question.
- **Q&A:** answer from the fact sheet. If you do not know, say so and say what you would check.
- Afterwards: Kent and D finish the AI-use disclosure from the log.

## Rules for everyone
- Tell Kent the moment anything looks wrong or a number does not match.
- Eat, sleep, and do not hide a failed test: a failure we found and explained is evidence for the judges.
