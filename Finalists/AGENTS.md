# AGENTS.md: rules for OpenCode, Codex, Gemini and any other coding agent

Read this first. Also read `CLAUDE.md` for background; if the two disagree, this file wins for you.

## Project
UNC Solve-a-thon Final Quest, Fri Nov 6 to Sun Nov 8, 2026, in person. A 5-person team builds a data-driven workflow that helps a North Carolina government user act on public data. The problem is released Friday evening and is not known yet. Stack: R 4.5 and Quarto. Kent Lee is the technical lead and the only person who merges.

## Your role
You do small, bounded tasks that Claude (the planner and drafter) hands you in a task brief. You write the output to a file. Claude then polishes and checks it. You do not plan the project, choose the user, the metric or the criteria, drop data, or decide what goes on a slide. If a task needs one of those, write `NEEDS KENT` and stop.

## How a task works
1. Read the task brief (a file in `tasks/` or the text Kent pastes). It names the inputs, the output path, and what done means.
2. Write your output only to the named path. If none is named, write to `drafts/<tool>/<task-name>.<ext>`. Never overwrite a file outside that path.
3. Run the checks named in the brief. For code, run `Rscript tests/run_tests.R` from `src/`; it must print "N of N tests pass".
4. Reply with: files written, what you did, what you did not do, assumptions, and how you verified it. Do not claim a check passed unless you ran it and read the output.

## Code rules
- Reuse the pipeline in `src/R`, `src/tool` and `src/tests` (see `README.md`, "Pipeline skeleton"). Do not rewrite it.
- The criteria table `data/manual/criteria.csv` is the method. Change the table, not the code, wherever possible.
- Everything that decides a result is deterministic code. A language model may only label text, and every label needs a quote copied from the source text. A model never ranks, scores or decides.
- Cache every external call to `data/cache/` and read from the cache on reruns. Ask before any new bulk download or paid API.
- Every threshold and default lives in `src/R/00_config.R`. Do not hard-code numbers elsewhere.
- Smallest change that fully works. No new dependency, abstraction or feature that was not asked for.
- Write the test case (input and expected result) before you look at results.

## Numbers and writing
- Every number you write must come from `src/docs/fact_sheet.md` or a file the brief names. Never invent a number, source or quote. Write "not found" when something is missing.
- Plain English. Short sentences. Bold the key point, concise bullets. No jargon. No em dashes.
- Mark anything uncertain `[uncertain]`.

## Do not touch
`data/raw/`, `.Renviron`, `.RData`, `CLAUDE.md`, `AGENTS.md`, `.claude/`, `opencode.json`.

## Git
Do not commit, push, merge, rebase or force-push unless the brief says to. Never touch `main`. If told to commit, use a branch named `<tool>/<task>`.

## Safety
- No personal, participant or patient data in any file. If you see some, stop and tell Kent.
- No API keys or secrets in files you write.
- Do not run commands that delete files. Move to a dated `stale/` folder instead.

## Logging
Add one row to `AI_USAGE_LOG.md`: when, tool and model, what for, whether the output was used, and what a human checked. The team must disclose AI use and name at least one place an AI was wrong.

## Local and free models
If you run on a small or free model: one file at a time, short outputs, and verify every claim against the files. If a task is too big for you, say so and stop; do not guess.
