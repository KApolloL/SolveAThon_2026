---
description: Six-hour checkpoint. Update handoff.md, run the checks, report hours left and the next three steps.
allowed-tools: Read, Grep, Glob, Edit, Bash(Rscript:*), Bash(git status:*), Bash(git diff:*), Bash(date:*)
---
1. Run `date`. Compute hours left to the submission deadline, Sun Nov 8, 9:00 am.
2. From `src/`, run `Rscript tests/run_tests.R` and `Rscript R/check_facts.R`. Quote the pass lines. If either fails, print the failing line and stop before editing.
3. Run `git status --short` and name files changed since the last commit.
4. Update `handoff.md`: last updated, hours remaining, the status table, decisions with reasons, open questions, blockers, next three steps. Edit sections; do not rewrite the file.
5. Check that every number in `deliverables/` and `src/docs/qa_cheatsheet.md` traces to `src/docs/fact_sheet.md`. List any that do not.
6. Report in five lines or fewer: hours left, test result, what changed, biggest risk, first next step. Do not commit or push.
7. After `handoff.md` is saved, this is a safe point to compact: call `request_compact` once, with the next three steps and open blockers in `instructions`.
