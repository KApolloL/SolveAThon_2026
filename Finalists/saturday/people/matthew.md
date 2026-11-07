# Matthew: human checks and mentors

You use ChatGPT on your computer, connected to GitHub. Paste your block from `prompts.md` as the first message. It pulls `main` and works on the branch `matthew/sat-checks`. Never accept a number, quote or eligibility answer from ChatGPT that you have not confirmed on the Grants.gov page yourself, and write the page link in `sat_checks.csv`. Log every ChatGPT use in `AI_USAGE_LOG.md`. Tell Kent when your branch is pushed so he can merge it at the next window.

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

## Added by Marco's Claude: what to ask the ThermoFisher mentor and the others at the early slot
Timing note: the plan has the 9:00 to 9:30 check-in for organizers only, mentors from 9:30, and Rhett Lavender (ThermoFisher Scientific, industry) from 11:00. If he or the others are there at 9:00, use the lists below in this order. Same rule as always: mentor input, never "users said". Log each answer in `mentor_log.md` with the question number.

### Rhett Lavender (ThermoFisher): ask in this order, two good answers beat five rushed ones
1. **I1, set the top-10 cap.** "When you triage funding or bids, which costs more: chasing a bad lead or missing a good one? Would you show 10 per agency, or fewer?"
2. **I2, pilot shape.** "What would make a budget director fund a 60-day pilot? What proof did your last approved pilot need?" Follow-up: "Who would sign, and what would they ask first?"
3. **I3, first confusion.** Put the live URL in front of him (https://ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io/), pick an agency, say nothing, write his first confusion. The page may still show stub data (banner at the top); say so.
4. **I5 in short.** "A model reads eligibility and we show its quote, never hide the item. Would a skeptical buyer trust that?"
5. If time: "Our evidence is a backtest on what agencies won before. How would you show a buyer that this finds things they would otherwise miss?"

### Kaiying O'Hare (faculty): F1 and F2, plus two sharper follow-ups
- F1 and F2 as written in `04_mentor_questions.md`.
- Follow-up: "Our 50% pass bar is our own judgment. How do we say that so it does not read as cherry-picked?"
- Follow-up: "We report counts and a binomial interval, and two baselines (soonest deadline, random 10). Is that enough, or what is missing?"

### Pratik Patekar or Girish Wangikar (technical): T1 to T3, plus four from what we hit this morning
- T1 to T3 as written. Marco stands beside you.
- **Blob access (new):** "Our login cannot assign Storage Blob Data roles on the storage account, so we used a read-only SAS (3-day expiry) kept as a Container App secret. Is that acceptable for a demo, and who in this subscription can grant the roles so we can use managed identity?"
- **Key use:** "We used the storage account key once from the CLI to upload and to mint the SAS. Is that a problem for the submission, and how should we say it in the README?"
- **Spend:** "Azure only alerts at $500. Is there a cheap way to hard-cap spend for the weekend?"
- **Warm-up:** "Min replicas 1 for the Sunday talk: roughly what does that cost for 0.5 vCPU, 1 Gi over a day?" Write the number they give; do not estimate it yourself.

### Organizers at check-in (the two required questions, plus two)
- Is Azure OpenAI (`ffm-aoai-team15`) ours to use? Does the Final Submission form want a repo link or a file upload?
- Add: Who can assign Storage Blob Data roles to our app identity? Is a public product link needed, or is the Azure URL enough?
