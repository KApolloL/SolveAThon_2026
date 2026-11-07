---
description: Full-project review. The main (Opus) session dispatches every reviewer in testing/reviewers/ as a Sonnet subagent, in waves of 3, then triages all transcripts into one ranked fix list against the five judging criteria.
argument-hint: [optional: reviewer names to run, or "all"]
allowed-tools: Read, Grep, Glob, Write, Edit, Bash(Rscript:*), Bash(git log:*), Bash(git status:*), Bash(git ls-files:*), Bash(date:*), Bash(ls:*), Agent
---
You are the review manager (run this on the strongest model). You do not review the work yourself first; you brief, dispatch, check and triage.

1. Run `date` and `git log --oneline -1`. Note both in the triage file. Pick the next free transcript number NN from `testing/transcripts/`. Then, from `src/`, run `Rscript R/10_run_ranking.R` (items.csv is gitignored, so a fresh checkout falls back to toy data without it), `Rscript tests/run_tests.R` and `Rscript R/check_facts.R` once yourself, and quote the result lines in every brief. Reviewers must not run `run_tests.R`: it rebuilds `payload.json` while other reviewers are reading it.
2. Reviewers to run: $ARGUMENTS (empty or "all" means every spec in `testing/reviewers/`). Read each spec's `description` so you know what material it wants.
3. For each reviewer, write a self-contained brief and dispatch a `general-purpose` subagent with `model: sonnet`, in the background:
   - "You are the `<name>` reviewer. Read `Finalists/.claude/agents/<name>.md` and follow it exactly; it is your whole instruction."
   - The exact material paths for that reviewer (from its description; see the default table below).
   - The freshness rule: `testing/context.md` is from Fri Nov 6 night; `handoff.md`, `saturday/`, `src/docs/fact_sheet.md` and the files themselves win.
   - Read-only on everything except its own transcript file `testing/transcripts/NN_<name_with_underscores>_YYYYMMDD.md`. No commits, no pushes, no outside-service scripts (02a to 02e, LLM, Azure calls). Never print a secret.
   - Return: the transcript path and its five most severe findings, one line each.
4. Waves: at most 3 subagents at once (CLAUDE.md subagent rule). Order: Solve, Evaluate and code first (code freeze is 7:00 pm), then facts, deliverables and security, then the other stage judges, then the remaining critics, then personas.
5. When each returns, open its transcript and spot-check two findings against the files. An agent's report is a claim, not proof. Note any finding you reject and why.
6. Triage into `testing/triage_YYYYMMDD_full_review.md`: score table per judging stage (median of reviewers that scored it, with the range), then one deduplicated fix list ranked by (severity x judge visibility x hours left), each row with source transcripts, the owner from `saturday/03_contract.md`, and fix / defer / ignore. Persona findings are hypotheses, never user evidence.
7. Add one row per run to `testing/results_log.md` and one row to `AI_USAGE_LOG.md` for the whole pass.
8. Report in ten lines or fewer: stage scores, the five fixes to make first with owners, and anything you could not assess.

Default material per reviewer (all paths relative to `Finalists/`):
| Reviewer | Material |
|---|---|
| stage-judge-solve, code-auditor | `src/R/`, `src/tool/`, `src/tests/`, `app/`, `data/processed/payload.json`, `src/docs/azure_setup.md`, `saturday/01_goals.md`, `saturday/03_contract.md` |
| stage-judge-evaluate, data-critic | `data/processed/backtest_result.csv`, `src/R/12_backtest.R`, `src/R/20_backtest_awards.R`, `data/manual/`, `src/docs/fact_sheet.md`, `drafts/claude/eval/`, `drafts/claude/docs/field_notes_draft.md` |
| stage-judge-understand, stage-judge-frame | `planning/07_discovery_findings.md`, `planning/02_framing_worksheet.md`, `planning/08_product_decisions.md`, `saturday/02_decisions.md`, `saturday/mentor_log.md`, `data/manual/criteria.csv`, `drafts/claude/docs/field_notes_draft.md`, `src/tool/` |
| stage-judge-impact, hostile-judge, persona-director, persona-osbm-sponsor, persona-osbm-analyst | `drafts/claude/docs/`, `deliverables/`, `README.md`, `src/docs/fact_sheet.md`, `src/docs/qa_cheatsheet.md`, `src/docs/azure_setup.md`, `data/processed/backtest_result.csv` |
| fact-tracer, consistency-auditor, deliverables-auditor | whole repo docs: `README.md`, `handoff.md`, `saturday/`, `planning/`, `docs/`, `drafts/claude/docs/`, `deliverables/`, `src/docs/`, `testing/context.md`, `AI_USAGE_LOG.md`, `src/tool/` |
| security-auditor | whole repo and git history |
| threat-auditor, test-breaker | `data/processed/payload.json`, `data/manual/criteria.csv`, `data/manual/test_cases.csv`, `src/R/helpers_rank.R`, `data/processed/backtest_result.csv`, `src/tool/` |
| persona-user, persona-nongrants-staffer, persona-supervisor | `src/tool/matchmaker.html`, `src/tool/ui.js`, `data/processed/payload.json` (one agency's rows) |
| persona-dhhs-grant-writer, persona-deputy-secretary, persona-federal-program-officer | `data/processed/payload.json` (DHHS or DEQ rows), `data/manual/criteria.csv`, `src/R/helpers_rank.R` eligibility rules |
| persona-it-architect, persona-state-developer | `README.md`, `drafts/claude/docs/README_state_developer_draft.md`, `app/`, `src/docs/azure_setup.md`, `src/R/00_config.R`, `src/tests/` |
| persona-industry-mentor | `data/processed/backtest_result.csv`, `drafts/claude/docs/field_notes_draft.md`, `saturday/mentor_log.md`, `AI_USAGE_LOG.md` |
