# Task board

Status values: open, claimed, in-progress, review, done. Edit only your own line, plus new lines at the bottom. Claim by setting owner and status, then push.

| id | task | owner | status | branch |
|----|------|-------|--------|--------|
| T1 | Add the first real task here (copy from handoff.md open items) | | open | |
| T5 | Full tool in `Finalists/src/tool/` and `Finalists/app/`: everything in saturday/01_goals.md (gate, match board, decision 12 features, closing-soon panel, Pursue/Maybe/Pass). Noah's Claude: do not touch these folders | kent | review | kent/sat-tool |
| T6 | Azure setup files only (Dockerfile, deploy script, job config, docs), written but NOT run and NOT deployed | kent | review | kent/sat-tool |
| T2 | Clean snapshot repo for judges: script that copies main's files without .git or api_keys.env, adds README note to make own keys, plus zip fallback (Marco brief step 7, dependency 17). Script and notes only; no public push | marco | review | claude/marco-work |
| T3 | Notice reader `Finalists/src/R/30_notice_reader.R` (advisory labels with script-checked quotes, capped and cached). Blocked: needs answer on whether Azure OpenAI is ours (Matthew, dep 3) and Marco OK for model calls | marco | open | |
