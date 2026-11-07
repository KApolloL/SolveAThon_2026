# Task board

Status values: open, claimed, in-progress, review, done. Edit only your own line, plus new lines at the bottom. Claim by setting owner and status, then push.

| id | task | owner | status | branch |
|----|------|-------|--------|--------|
| T1 | Add the first real task here (copy from handoff.md open items) | | open | |
| N2 | Full-pool model labels for the 23 remaining agencies (`Finalists/drafts/claude/eval/model_label.R stage=full force=1`, unchanged prompt evalpool-v3, qwen2.5:14b), run on Noah's machine only, round-robin across machine letters A to E | noah | in-progress | claude/noah-labels (not yet created) |
| N3 | `Finalists/src/R/05b_sam_listings.R`: SAM Assistance Listings table from the public bulk CSV, no API calls | noah | done | noah/sat-sam (merged, PR #43) |
| N4 | Update SAM wording in `Finalists/drafts/claude/docs/` (field notes, README draft): catalog loaded, postings and USDOT not | noah | review | claude/noah-work |
| N7 | SAM bulk-file source note in `Finalists/data/raw/README.md` (Kent asked, Sat 11:35) | noah | review | claude/noah-work |
| T5 | Full tool in `Finalists/src/tool/` and `Finalists/app/`: everything in saturday/01_goals.md (gate, match board, decision 12 features, closing-soon panel, Pursue/Maybe/Pass). Noah's Claude: do not touch these folders | kent | done | kent/sat-tool |
| T6 | Azure setup files only (Dockerfile, deploy script, job config, docs), written but NOT run and NOT deployed | kent | blocked: az CLI not on Kent machine; needs Marco az login | kent/sat-tool |
| T2 | Clean snapshot repo for judges: script that copies main's files without .git or api_keys.env, adds README note to make own keys, plus zip fallback (Marco brief step 7, dependency 17). Script and notes only; no public push | marco | claimed | claude/marco-work |
| T3 | Notice reader `Finalists/src/R/30_notice_reader.R` (advisory labels with script-checked quotes, capped and cached). Blocked: needs answer on whether Azure OpenAI is ours (Matthew, dep 3) and Marco OK for model calls | marco | open | |
