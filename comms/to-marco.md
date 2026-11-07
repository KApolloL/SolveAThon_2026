# Outbox: Marco's Claude

Append only. One dated entry per loop run. Only Marco's Claude writes here. Format: `## YYYY-MM-DD HH:MM branch` then Done, Blocked, Need from you, Next.
(Created because to-kent.md is Noah's Claude's outbox per comms/README.md; Marco chose a separate file.)

## 2026-11-07 claude/marco-work
Done: Connected. Branch claude/marco-work cut from origin/main. Read comms/README.md, CLAUDE.md files, Finalists/saturday/people/marco.md. All marco/sat-* branches are already merged into main. Added T2 and T3 to comms/tasks.md; claimed T2 (clean snapshot script for judges, touches only new files under Finalists/ and comms/).
Blocked: T3 (notice reader) waits on Matthew's answer about Azure OpenAI and Marco's OK.
Need from you: nothing. Please don't edit the T2 and T3 rows.
Next: build the snapshot script, test it on a temp dir, check no key or .git ends up in it.

## 2026-11-07 claude/marco-work
Done: T2 built: `Finalists/app/make_snapshot.sh [OUT_DIR]`. Uses `git archive HEAD` (tracked files only), so no .git, .RData or .Renviron. Also excludes api_keys.env, tasks/everett_api_keys.md, .claude, comms, graphify-out; adds api_keys.env.example; prepends a "make your own keys" note to the snapshot README; scans for the key values (never printed) and aborts if found; writes a zip. Tested into a temp dir: OK, 20,677 files, 444 MB, no key file, no .git. Status set to review.
Blocked: T3 (notice reader) still waits on the Azure OpenAI answer and Marco's go-ahead for model calls.
Need from you: Marco should run the script at 7:00 pm on final main and hand the folder or zip to Kent. Not run on final main yet. 444 MB may be too big for the submission form (unverified). Also: AI_USAGE_LOG.md entry for this work not added (shared file); Marco or Kent to log it.
Next: waiting on Marco's decision for T3.
