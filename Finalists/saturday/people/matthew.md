# Matthew: human checks and mentors

You use ChatGPT, not Claude Code. Start a new chat and paste the rules block from `tasks/teammate_ai_rules.md`, then paste this whole file under it. ChatGPT cannot open Grants.gov or the repo for you: open each page yourself and paste the text you want checked into the chat. Never accept a number, quote or eligibility answer from ChatGPT that you have not confirmed on the page yourself, and write the page link in `sat_checks.csv`. Log every ChatGPT use in `AI_USAGE_LOG.md`. For git, ask Kent or a teammate's Claude; if you only fill `sat_checks.csv` and `mentor_log.md`, send the files to Kent and he commits them.

## Goal
Run every mentor slot, finish the verification sheet by **12:15**, and ask two questions of the organizers at the 9:00 check-in.

## You own
`data/manual/sat_checks.csv`, `saturday/mentor_log.md`.

## Steps
1. **9:00 check-in, ask the organizers:**
   - Is Azure OpenAI (`ffm-aoai-team15`) ours to use?
   - Does the Final Submission form want a link to a repo, or a file upload?
   Write their words in `mentor_log.md`.
2. **9:30 to 10:30, faculty and tech mentors.** Questions F1, F2 (Kaiying O'Hare), T1 to T3 (Pratik Patekar or Girish Wangikar) from `04_mentor_questions.md`. Everett stands beside you for F, Marco for T. Ask follow-ups when an answer is vague. Log each answer straight away in `mentor_log.md`.
3. **9:30 to 12:15, verification sheet** (`data/manual/sat_checks.csv`, columns `check, item, what_i_found, source_link, date_checked`):
   - **DERA notice** `EPA-OAR-OTAQ-26-01` on Grants.gov: who is eligible? Quote the text. Can a state agency lead?
   - **School bus window:** discovery notes said an application window of about one month. Is that true for DERA? Find it on Grants.gov.
   - **Far-future dates:** pick 10 of the 70 posted items with close dates after 2030 in `data/processed/opportunities.csv` (include some dated 2030). Open each on Grants.gov. Is the date real or a placeholder?
   - **Applicant codes:** the Grants.gov list of applicant type codes. Write the meaning of codes 25 and 99 and any code used in `opportunities.csv` that isn't clear.
4. **11:00 to 12:00, Rhett Lavender.** Questions I1 to I3. For I3, put the live URL in front of him and say nothing; write down his first confusion.
5. **2:00 to 4:00, Aries Rosales, Jo Kwon, Haihan Gao, Girish Wangikar.** Run the timed task I4 first (stopwatch, say nothing, note every pause), then I5, F3, T4, T5. Use the timed-task block at the bottom of `mentor_log.md`.
6. **7:00 to 8:00.** F4 with Weitong Zhang and T6 with Haihan Gao.

## Done means
- [ ] Every answer logged with the mentor's name, time and question number.
- [ ] Every check row has a source link.
- [ ] "not found" written wherever you could not confirm something.

## Handoff
Tell Kent the moment a mentor's answer should change something. Answers go to the owner named in `04_mentor_questions.md` ("Informs" column).
