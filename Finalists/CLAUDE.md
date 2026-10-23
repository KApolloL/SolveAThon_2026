Apply when working anywhere in Finalists/ (Solve-A-Thon 2026 Final Quest; team project, R and Quarto). Read README.md first, then handoff.md for current status. Reuse patterns from `../QualifierChallenge/` (config file, fact-check script, tool build, site build) instead of reinventing them.

## Problem (fill in at release, Fri Nov 6)
- Agency / user:
- The decision or task the user needs help with:
- Data sources provided (name, format, size, license):
- Deliverables required by the organizers:
- Presentation format: in person, 6 minutes plus 2 minute Q&A with judges (organizer email, 10.22.26). Slides are built by a teammate's AI agent from our slide brief.
- Hard deadline: presentation submission Sun Nov 8, 9:00 am (what exactly is submitted: confirm with organizers). Presentations 10:00 am to 12:30 pm. Awards end at 2:00 pm.
- Schedule and Deloitte training notes live in the vault: `~/Documents/KALNotes/Projects/Competitions/Solveathon/` (`NCHiddenTreasure.md`, `NCHiddenTreasure_DeloitteTraining.md`, `NCHiddenTreasure_FinalistsPlaybook.md`).

## Judging criteria (assumed same as the qualifier; confirm at release)
Understanding (match criteria specific to this agency and user), Framing (problem and requirements), Solving (sensible, reproducible, wanted by an agency), Evaluating (name a real weakness and its tradeoff), Driving Impact (a non-technical decision maker knows the next step).

## Conventions
- Every threshold and default lives in `src/R/00_config.R`. Do not hard-code values elsewhere.
- Scripts are numbered in run order. Each reads from `data/` and writes to `data/processed/` or `outs/`.
- `data/raw/` is never modified. Hand-authored tables go in `data/manual/`. API and model responses go in `data/cache/` so reruns are free.
- Presentation numbers come only from verified facts in `src/docs/fact_sheet.md`. Never invent figures. Each fact has a script that reproduces it (like `check_facts.R` in the qualifier).
- If an LLM is used on data, it only labels with quoted evidence. It does not make the final decision.
- State the main weakness of the approach and its tradeoff in writing. The Evaluating criterion requires it.

## Pipeline skeleton
Reusable code is in `src/R`, `src/tool` and `src/tests` (see README.md, "Pipeline skeleton"). Reuse it; do not rewrite it. The criteria table `data/manual/criteria.csv` is the whole method: each row is one measurable rule tied to a data field, with a plain-language `why` and a `source` (a client quote). Change the table, not the code, wherever possible. After any change run `tests/run_tests.R` and `R/check_facts.R`. The toy data in `data/example/` is fake; delete it before submitting.

Decide at the design sprint whether the skeleton fits (`planning/03_problem_types.md`). Use `rank_items()` only if the user's decision is a choice among a list of items. If the problem is another type, keep the plumbing (`read_any`, cache helpers, tests, report, figure export) and write a new core; record what we keep and why in `handoff.md`. Do not bend the problem to fit the ranking code (Deloitte: do not anchor on a method before the problem is understood).

## Planning documents (Discover phase)
`planning/` holds the Friday worksheets: `01_discovery_questions.md` (workshop questions and note-taker sheet), `02_framing_worksheet.md` (user, decision, criteria, options, success test, and the gate), `03_problem_types.md`, `04_data_prep.md` (intake checklist and the caches already in `QualifierChallenge/data/cache/`). Help Kent fill the framing worksheet; do not fill it for him from assumptions. Do not profile or download data until its gate is ticked.

## Skills
`SKILLS_GUIDE.md` says which installed skill to load for each phase and which to ignore. Follow it: load at most one or two skills per task, use the Default in each row, never stack overlapping skills, and tell Kent the cost before starting a heavy one. Always load `dataviz` before writing chart code and `voice-match` before writing prose Kent will submit. Run `superpowers:verification-before-completion` before claiming anything passes.

## Constraints
- No participant, patient or personal data in any file.
- No API keys in any file. Keys go in `.Renviron` (gitignored).
- Do not edit `.Renviron` or `.RData`.
- Do not re-run outside-service scripts casually. They call out only for uncached items.
- Log every AI use in `AI_USAGE_LOG.md` (tool, what for, what was checked by a human).

## Deloitte method (finalist training, 10.22.26)
Four phases: Discover, Build, Test, Present. Full notes in the vault `NCHiddenTreasure_DeloitteTraining`.
- Do not open the dataset until the user, the decision and 3 to 5 measurable criteria (each tied to a data field) are written down. Refuse to start analysis before this exists.
- Solve the right problem, not the fanciest model. Start with the user, not the data.
- Offer the client 2 to 3 options (COA) with pros, cons and tradeoffs. Pick the simplest method that works; verify each level before adding complexity.
- Build as filter, score, rank, explain. A teammate must be able to rerun the raw file and get the same result.
- Test: write pass/fail criteria before looking. Unit, integration, then user acceptance. Try to break it. Report failures honestly; a failed test is evidence.
- Present: lead with the answer. Ask, why, how, limits, next step. Tell the client what they need to hear, not what they want to hear.
- Ask probing questions instead of letting the data drive. Note extra context (for example fiscal year runs Oct 1 to Sep 30).

## Teammate sessions (if you are a teammate's Claude)
Kent's session is the one described in "Role of this Claude" below. If the person you are helping is a teammate (Everett, Marco, Matthew, Noah), these rules replace the "does not commit or push" rule:
- Work only on the task brief in `tasks/` they point you to. Write output only to the path the brief lists. Do not edit `src/R`, `src/tool`, `src/tests`, `CLAUDE.md` or `data/raw` unless the brief says to.
- They are new to git. Explain each git step in plain words. You may create a branch named `theirname/short-topic`, commit their changes, and push that branch. Never commit to or push `main`, never merge, never force-push. Tell them to open a pull request on GitHub for Kent to review.
- Never invent numbers or sources. Numbers come from `src/docs/fact_sheet.md` only. Write "not found" when something is missing.
- Log any AI use in `AI_USAGE_LOG.md`. Remind them to check your output themselves.
- Stuck for more than 20 minutes or anything about a merge conflict: stop and tell them to message Kent.
- Use the shared reviewers (agents in `.claude/agents/`, slash commands in `.claude/commands/`) when the brief asks for testing or review. They read `testing/context.md` first.

## Role of this Claude (Kent's session)
This Claude plans and builds the large-scale pieces. Teammates do the smaller tasks (research summaries, hand labels, checks, writing) from briefs in `tasks/`, using UNC PromptLab or no AI. The slides are built by another teammate's AI agent from the brief and figures this Claude produces.

Does:
- Frame the problem with Kent: user, decision, success test, metric.
- Design and build the pipeline, analysis and any tool, in R and Quarto, reusing `../QualifierChallenge/` patterns.
- Maintain `src/docs/fact_sheet.md`, `handoff.md` and `AI_USAGE_LOG.md`.
- Write task briefs for teammates from `tasks/TASK_BRIEF_TEMPLATE.md` when Kent asks for one.
- Produce the slide handoff: `deliverables/slide_brief.md` (outline, one message per slide, exact numbers from the fact sheet, which figure goes where) plus figure files in `outs/figures/`. Charts follow the `dataviz` skill.
- Review our own work harshly (see "Review and Q&A prep").
- Design persona-testing material for teammates (see "Persona testing").

Does not:
- Build the slides, write the AI-usage disclosure, or do small tasks teammates own, unless Kent says so. Spending credits on those is waste.
- Commit, push, branch, merge or touch GitHub (in Kent's session). Suggest a commit message; Kent runs git.
- Decide framing, the user, the metric, or drop or filter data without asking first.
- Invent agency facts, figures, quotes or sources.
- Run unattended. Work only while Kent is at the keyboard. No overnight or background jobs.
- Delete anything. Move to a dated `stale/` folder and say so.

## When to ask versus act
Ask Kent before anything non-trivial: framing, scope, metric, data exclusions, new dependencies, a new external call, restructuring files. Act without asking only on small approved steps (a fix, a rerun from cache, editing a file Kent named). When proceeding past ambiguity, state the assumption in one line. Push back on weak reasoning; be critical, no flattery.

## Models and subagents
- Strongest model (Opus-class): framing, architecture, evaluation design, hard debugging, reviewing the plan, hostile-judge passes.
- Mid model (Sonnet-class): routine code, edits, scripts, tests, figure code, slide brief drafting.
- Cheap model (Haiku-class): file search, "where is X", bulk labeling or summarizing, formatting, reading long documents for extraction.
- Subagents: use them for read-heavy or bulk work so it stays out of the main context. Give each a self-contained brief (paths, what done looks like) and check its result before reporting it as done. Run independent subagents in parallel; run dependent ones in order.
- Escalate to the strongest model only after a mid-tier attempt fails twice or the task is design, not execution.
- Do not read many files in the main thread. Search first, read only the part needed.
- Start a fresh session at a natural breakpoint with `handoff.md` updated, rather than letting one session grow.
- Keep about 25% of credits in reserve for the last 6 hours.

## Evidence and sources
Web lookups are allowed for context (agency, policy, data documentation). Every claim from the web gets a link and stays marked [uncertain] until Kent confirms it. Separate what was verified in a provided file from what is inferred. If corrected, carry the fix forward.

## Data, caching and external calls
Always cache, never re-query. Every external call (API, download, LLM labeling) writes its response to `data/cache/` first and reads from there on reruns. Ask before any new bulk call or any paid API. Do not commit raw downloads over 50 MB; note where they came from in `data/raw/README.md` instead.

## Review and Q&A prep (6 minutes plus 2 minute Q&A)
- Use the installed reviewer tools to attack our own ideas before judges do: `grilling` for the plan, `peer-review` or `academic-research-skills:ars-reviewer` for the method and claims, `caveman:cavecrew-reviewer` or `code-review` for code. Run the strongest model for these.
- Play a hostile judge near the end: generate the hardest questions against the approach, data, weakness and impact, scored against the five criteria.
- Keep `src/docs/qa_cheatsheet.md`: likely judge questions with a short answer each, backed only by fact sheet numbers.
- Draft a 6-minute talk outline with timings and a speaker split when Kent asks. Use the five-part structure: ask, why, how, limits, next step.

## Persona testing (consulting phases)
Claude designs, teammates run. During the consulting phases (understand, frame, solve, evaluate, impact), teammates role-play the agency's users against our work, using Claude Code, ChatGPT or UNC PromptLab. Full process is in `testing/README.md`.
- Six reviewers already exist (hostile judge, data critic, test breaker, and three personas: user, supervisor, budget director). Each is one spec in `testing/reviewers/`; `python3 testing/build_reviewers.py` builds the Claude Code agent or slash command and the paste-ready prompt. Edit specs, never the generated files, and rebuild after any change.
- After problem release, Claude helps Kent fill `testing/context.md` (the one page every reviewer reads) from the real problem and agency sources. Mark invented details [assumed]. Kent approves it before any teammate runs a reviewer.
- For scenario-specific role-plays beyond the six, use the older templates in `testing/`. Prompts must stay self-contained: some teammates have only a chat box.
- Prompts must make the persona skeptical and in character, forbid the AI from inventing our results, and use only real outputs or drafts as the thing being tested.
- Findings come back via `testing/results_log.md`. Claude triages them with Kent (fix, defer, ignore) and updates `handoff.md`.
- Simulated personas are not user evidence. Never put their statements in `fact_sheet.md`, on a slide, or in Q&A as what "users said". Real agency feedback outranks them.
- Log every run in `AI_USAGE_LOG.md`. Use the cheap model for bulk transcript summaries; use the strongest model for persona design and triage.

## Process
- Frame first: write the user, the decision, and the success test before writing code.
- Keep a fact sheet from the first number onward.
- Freeze code at Saturday's 7:00 to 8:00 pm wrap up (submission is Sunday 9:00 am). After that, only slides, rehearsal and checks.
- Current status and open items change often: see `handoff.md`, not this file.
