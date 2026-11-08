# Finalists reorganization plan (execute after the Sunday Nov 8, 9:00 am submission)

Status: **Phase 1 done** (Sat Nov 7): inert folders moved to `archive/`. **Phase 2 not started**; do not begin before submission, because teammates are pushing and `app/Dockerfile`, `app/deploy_azure.sh`, the README, CLAUDE.md and the R scripts hard-code the current paths.

## Phase 1 (done)
- `stale/` -> `archive/stale/`, `graphify-out/` -> `archive/graphify-out/`, `tasks/done/` -> `archive/tasks-done/`.
- References updated: README.md, CLAUDE.md, AGENTS.md, tasks/TASK_BRIEF_TEMPLATE.md, app/make_snapshot.sh, .gitignore, .opencode/agents/security-auditor.md.

## Phase 2 (proposed target)
Problem: roughly nine overlapping top-level markdown/work folders and three agent config files.

| Today | Target |
|---|---|
| `planning/`, `saturday/`, `notes/`, `drafts/`, `tasks/`, `docs/` | `docs/` with subfolders: `brief/` (QUEST_BRIEF, RUNBOOK), `planning/` (01-08 + saturday/), `notes/vault/`, `drafts/` (by author), `tasks/` |
| `testing/` | `docs/testing/` (or keep top-level if the personas stay in the demo) |
| `deliverables/` | keep top-level: it is what judges look for |
| `outs/` | keep top-level, generated only |
| `AGENTS.md`, `CLAUDE.md`, `GEMINI.md`, `opencode.json` | keep at root (tools look for them there); make AGENTS.md the single source and have the others point to it |
| `handoff.md`, `AI_USAGE_LOG.md` | keep at root |
| `app/`, `src/`, `data/` | unchanged |

## Steps for Phase 2
1. Announce a freeze in `comms/`; ask everyone to merge or rebase first.
2. `git mv` the folders above (one commit per folder, so history and review stay readable).
3. `grep -rn` each old path across README, CLAUDE.md, AGENTS.md, GEMINI.md, handoff.md, `.opencode/`, `app/*.sh`, `app/Dockerfile`, `src/R/*.R`, `src/_quarto.yml`, `.gitignore` and fix hits.
4. Run `Rscript R/check_facts.R` and `Rscript tests/run_tests.R` from `src/` and rebuild the Azure image before and after.
5. Update the README layout table.

## Open issues found while planning (not part of the reorganization)
- `api_keys.env` is tracked in git (two real-length keys). The file says Kent chose this because the repo is private. Before the repo is shared with judges or made public, remove it from the tree, rotate the keys, and load them from `.Renviron` instead.
- `Rscript R/check_facts.R` and `Rscript tests/run_tests.R` failed in this worktree before any change, with "criteria point at columns that are not in the items". Likely the processed data is not present in a fresh worktree; not investigated.
