# AI handoff (paste into Gemini, ChatGPT, UNC PromptLab or any chat tool)

This replaces the earlier Gemini handoff. It states only what is confirmed and lists what is not. Paste it first, then paste your task.

## What this is
- UNC Solve-a-thon Final Quest, Fri Nov 6 to Sun Nov 8, 2026, in person at Manning Hall. A 5-person team builds a data-driven solution a North Carolina government user can act on.
- **The problem is not known yet.** It is released Friday evening after registration. Do not assume the topic, the agency, the data, or that it is a grants problem. Earlier training examples used grants, but that is not confirmed for the finals.
- **Schedule:** Fri 5:30 PM registration; 6:30 PM client discovery workshop; 7:30 PM solution design sprint. Sat build sessions 9:30 AM to 1 PM and 2 to 6 PM; wrap up 7 to 8 PM. **Sun 9:00 AM submission deadline** (likely Devpost, unconfirmed). Presentations Sun 10:00 AM to 12:30 PM: **5 minutes plus 2 minute Q&A**, in person, live demo allowed.
- **Judging criteria (assumed to match the qualifier; confirm at release):** Understanding (criteria specific to this agency and user), Framing (problem and requirements), Solving (sensible, reproducible, wanted by an agency), Evaluating (names a real weakness and its tradeoff), Driving Impact (a non-technical decision maker knows the next step).

## Method (from the Deloitte finalist training)
Discover, Build, Test, Present.
- **Discover:** name one user (a role with a job, a deadline, little time) and the decision they make. Write 3 to 5 measurable criteria, each tied to a data field. Do not open the data until this is on paper.
- **Build:** offer 2 or 3 options with tradeoffs; pick the simplest method that works. Filter, score, rank, explain. A teammate must be able to rerun the raw file and get the same result.
- **Test:** write pass/fail criteria before looking at results. Unit, integration, then user acceptance. Try to break it. Report failures honestly.
- **Present:** lead with the answer. Five parts: the ask, why, how, limits, next step. Tell the client what they need to hear, not what they want to hear.

## Stack and where things are
- **R 4.5 and Quarto**, not Python. The tested pipeline is in `Finalists/` (`src/R`, `src/tool`, `src/tests`). Read `README.md`, "Pipeline skeleton".
- The criteria table `data/manual/criteria.csv` is the whole method. Code runs it deterministically. A language model may only label text with a quote copied from the source; it never ranks, scores or decides.
- All data, API pulls and model labels are cached to disk so the pipeline reruns offline.
- Rules for coding agents: `AGENTS.md`. Project background: `CLAUDE.md`.

## Who does what
- **Kent Lee:** technical lead; the only person who merges code; makes the final call on framing, criteria and scope.
- **Claude (main planner and drafter):** plans, designs the architecture, drafts prompts, tests and the slide brief, and does the final polish and check of everything other tools return.
- **OpenCode, Codex, Gemini, ChatGPT, UNC PromptLab:** smaller bounded tasks Claude or Kent assigns (a function, a summary, a draft, a second opinion, a practice Q&A). They return the result to Claude to polish and check. They do not make decisions.
- **Teammates (Everett, Marco, Matthew, Noah):** mostly use ChatGPT and PromptLab; they do research, labeling, testing, slides and Q&A prep. See `RUNBOOK.md`.

## Rules for any AI reading this
1. Do only the task you are given. Use only the inputs provided.
2. Never invent numbers, sources, quotes or names. Write "not found" when something is missing and say what you need.
3. Every number must come from `src/docs/fact_sheet.md` or a file the task names.
4. Plain English, short sentences, bold key points, concise bullets. No jargon, no em dashes.
5. Mark guesses `[uncertain]`.
6. If a task needs a framing, scope or criteria decision, write `NEEDS KENT` and stop.
7. No personal or participant data. No keys or secrets.
8. When you finish, list what you did, what you did not do, what you assumed, and what a human must check.
9. The team will log AI use and must name at least one place an AI was wrong. If you notice your own mistake or one by another AI, say so.

## Not confirmed (do not assume)
The topic and data; whether a starter kit, a data dictionary or agency strategic plans are provided; the exact Devpost requirements; the final rubric; whether finals data is grants data.
