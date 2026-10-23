# Framing worksheet (Fri 7:30 to 8:45 PM sprint)

Fill this in on paper or here before any data is opened. One page. Plain words. Anything the client did not say is [assumed].

## 1. One-sentence problem
(The user, the decision, and why it is hard today.)

## 2. User card
- **Who (role, not a name):**
- **Job and time available:**
- **What they do today:**
- **Their words for the problem:**
- **What makes them distrust a tool:**

## 3. Decision and action
- **Decision they make:**
- **Action our result should trigger (a specific next step, owner, date):**

## 4. Success test
- **How the user would know it worked:**
- **How we will show it works (a test we can run):**

## 5. Criteria (3 to 5; each measurable and tied to a data field)
Copy into `data/manual/criteria.csv` (columns: id, type, label, field, rule, value, weight, if_missing, why, source).

| Vague (their words) | Measurable rule | Likely data field | Source (client quote) | Filter or score |
|---|---|---|---|---|
| | | | | |

Check: could you explain each criterion to a stranger in one sentence?

## 6. Options (course of action) with tradeoffs
Offer the client two or three. Pick the simplest that works.

| Option | What we build | Pros | Cons | Tradeoff | Time and data needed |
|---|---|---|---|---|---|
| A (simplest) | | | | | |
| B | | | | | |
| C | | | | | |

**Chosen and why:**

## 7. Not solving
(What is out of scope, and who handles it.)

## 8. Assumptions to verify
(Each with how we will check it and who checks.)

## 9. How it could fail
(Edge cases, missing data, a plausible but wrong answer. These become test cases.)

## 10. Gate: may we open the dataset?
- [ ] User named as a role with a job and a deadline
- [ ] Decision and the action it triggers written
- [ ] 3 to 5 criteria, each measurable and mapped to a field we expect to exist
- [ ] Success test written
- [ ] Two or three options compared; one chosen
- [ ] Failure cases listed
- [ ] Mentors have seen this page
Only when every box is ticked: profile the data (`Rscript R/01_profile.R`) and check each criterion's field exists and is usable.
