# security-auditor, Sat Nov 7 2026

Read-only run. No secret value printed; values masked to 4 characters or less. No outside service called. `.Renviron` and `.RData` not read. Scope: `Finalists/` plus `QualifierChallenge/`, tracked tree at this worktree's HEAD and all 130 commits across all local and remote-tracking refs.

Stale statements noticed in `testing/context.md` (Fri Nov 6): it says the Azure proof app is "live" with a static display only. Since then `src/docs/azure_setup.md` records v2, a `/payload.json` route reading Blob with a SAS, and Azure OpenAI created but not wired in. Files win; I used them.

## 1. Findings

| # | file:line or commit | kind | masked evidence | severity | fix |
|---|---|---|---|---|---|
| 1 | `Finalists/api_keys.env:4-5`; added in commit `78d3d2b` (2026-11-06) | secret | `SIMPLER_GRANTS_KEY=6dZg****` (25 chars), `SAM_API_KEY=SAM-****` (40 chars). Value match shows each appears only in this file at HEAD and only in `78d3d2b` in history | high | Committed on purpose, but `78d3d2b` is reachable from `origin/main` and 4 other remote branches, so the keys are in history on GitHub. Decision 10 (history-free snapshot) is the only no-rotation fix; if the snapshot is not built or the repo is made visible, rotate both keys (Kent) |
| 2 | `.gitignore` (whole file) | process | `git check-ignore api_keys.env` returns "NOT ignored". `.dockerignore` excludes `*.env`; `.graphifyignore` excludes it | medium | Nothing stops `git add -A` or `cp -r` into the snapshot from taking it. The snapshot script must exclude it by name and then grep the result for the key values |
| 3 | `saturday/02_decisions.md:14` (decision 10) | process | "Marco builds it at 7:00 pm"; no script found. `git ls-files` matches nothing for snapshot/judges/export; only `app/stage_proof_assets.sh` has a secret check, and it covers `app/` only | high | The snapshot has no script and no verification step. Write one (see exclusion list) and run the value check against the output. Today 7:00 pm may already be past |
| 4 | `src/docs/azure_setup.md` (Auth to Blob, Sat section); `app/app.R:19,24-34` | exposure | Blob read via `BLOB_SAS` (Container App secret `blob-sas`), expires 3 days from Sat Nov 7, i.e. about Tue Nov 10. Fallback path uses managed identity | medium | No SAS value in any tracked file or commit (searched `sig=`, `AccountKey=`, `SharedAccessSignature`, `sv=` at HEAD and with `-G` across all refs: zero hits). Risk is operational: SAS dies about Nov 10, after judging may still run; `/payload.json` returns 502 then. Extend or switch to managed identity once Kent/Owner grants the role |
| 5 | `app/app.R:19` and docs | exposure | Storage account name `ffmdatateam15`, container `ffm-data`, app FQDN `ffm-app.bluepebble-2cbaa7af.eastus.azurecontainerapps.io`, registry `ffmacrteam15`, AOAI `ffm-aoai-team15`, subscription name `unc-sdis-solveathon-team15`, in 15+ files | low | Resource names, not secrets. Storage is private (no public blob access, per azure_setup.md); fine to leave. The subscription GUID is not in any tracked file (searched) |
| 6 | Azure ingress (`azure_setup.md` Proof run: "external ingress") | exposure | App URL has no auth. `/` serves matchmaker, `/tool.html`, `/shiny` (full `opportunities.csv` table), `/payload.json` (`no-store`) | low | Content is public Grants.gov, Federal Register and public agency-plan text, so acceptable. Say so in the README; do not add private data. Not an NC data-security claim |
| 7 | `saturday/04_mentor_questions.md:23` (T4) | exposure | `POST /feedback` is asked about; no `/feedback` route in `app/app.R`, no `fetch(` POST in `src/tool/matchmaker.html` (only `fetch(src)` at line 147) | low | No free-text store exists today. If added, it needs a length cap, no PII warning and a non-public store. Do not claim it exists |
| 8 | `src/docs/azure_setup.md:50`; `planning/02_framing_worksheet.md:71` | model use | "Azure OpenAI keeps prompts out of training: not verified." Deployment `gpt-4o-mini` as `DataZoneStandard`, "processes within the US data zone [read the docs before claiming this]". "Not done: wired into the app or pipeline; no call cap in code" | medium | Data-use terms are assumed, not evidenced in the repo. Current labelling used local `qwen2.5:14b` via Ollama (`planning/09_tool_plan_update.md:49`), not Azure. Say "not verified" on the limits slide, or paste the Azure doc URL and date. Also no call cap |
| 9 | `Finalists/data/cache/api/grantsgov/fetch/*.json` (about 5,070 files across Finalists and QualifierChallenge, first key `token`) | secret (low-grade) | `"token":"eyJ0eXAi****"`, a session token returned by the Grants.gov fetch endpoint, in each cached response, plus `.accessed` files | low | Anonymous server-issued session tokens, almost certainly expired and not account credentials [cannot confirm lifetime]. Strip the `token` field from cache files in the snapshot, or drop `data/cache/api/grantsgov/fetch/` if not needed to rebuild |
| 10 | `planning/06_tonight_plan.md:36,40`; `src/docs/organizer_materials_notes.md:46,48`; `handoff.md:51`; `drafts/claude/docs/README_state_developer_draft.md:109`; `azure_setup.md` (Signed in as) | personal data | Marco's UNC login `gullotto@AD.UNC.EDU` (full text in azure_setup.md); the literal placeholder `ONYEN@ad.unc.edu` elsewhere; three organizer/mentor emails `pat***@unc.edu`, `hhg***@unc.edu`, `gir***@unc.edu` | medium | Team member's own account is acceptable but unnecessary; the three organizer emails are third-party personal data. Remove before the snapshot or accept consciously |
| 11 | `notes/vault/Solveathon.md:19,29,30,34,35`; `notes/vault/Solveathon_DeloitteTraining.md:228`; `saturday/04_mentor_questions.md:14,15,23,25` | personal data | Full names of faculty and technical mentors (e.g. `Weit***`, `Jo K***`, `Haih***`, `Giri***`); organizers/mentors are named in the schedule | low | They are event staff, named by their roles; context.md rule is "no personal data in any file". Names are not discovery attendees. `notes/vault/*` is Marco's personal vault copy (see snapshot list) |
| 12 | `planning/07_discovery_findings.md`, `notes/vault/Solveathon_DiscoverySession.md:45-51` | personal data | Discovery attendees recorded by role only ("grants lead at DNCR", "Deloitte manager", "project manager and architect"); no attendee names found | low | OK. Keep it that way |
| 13 | `planning/overnight_handoff_nov6.md:5`; `QualifierChallenge/handoff.md:189`; `QualifierChallenge/src/diagnostic.qmd:22`, `legacy_solveathon_project.qmd:21`, `solveathon_project.Rmd:17` | personal data | Absolute home paths `/Users/mar***/...` and `/Users/ken***/...` (reveals team members' OS usernames) | low | Cosmetic; scrub in the snapshot if time allows |
| 14 | `QualifierChallenge/docs/notebook.html:9898,12459,5047`, `outs/*.html` | personal data | Public-agency contact emails (`OVW***@usdoj.gov`, `Cai***@state.gov`) inside grant text | low | Federal notice contact emails, public data. No action |
| 15 | `.claude/settings.json` | process | Denies `Read(**/.Renviron)`, `.RData`, `git push origin main`, `git reset --hard`; allows `git add`, `git commit` | low | Good. Note it does not deny `Read(**/api_keys.env)`; add it so reviewers and agents cannot print the keys |
| 16 | `src/R/00_config.R:112-114` | secret handling | Key loaded with `readRenviron(here("api_keys.env"))`, never echoed; `.Renviron.example` holds only the empty `CENSUS_API_KEY=` | low | Fine. `tasks/everett_api_keys.md` says "Do not share them outside the team": consistent with decision 10 only if the snapshot drops the file |
| 17 | History scan | process | `git log --all -G` for `AccountKey`, `SharedAccessSignature`, `BLOB_SAS=`, `AOAI_KEY=<value>`, `api-key: <value>`, `CENSUS_API_KEY=<value>`: zero commits. `.Renviron`, `.RData`, `*.pem`, other `*.env` never added in any commit. Only `api_keys.env` (and file names containing "secret" such as Department of Secretary of State plan files, false positives) | low (good news) | No further history cleanup needed beyond finding 1 |
| 18 | Known token shapes at HEAD (`sk-`, `ghp_`, `github_pat_`, `AKIA`, `xox`, `AIza`, private key blocks) | process | zero hits | low (good news) | None |

Also confirmed: no key value appears in `app/` (staged assets script checks this), in any untracked file, in `data/cache/` request records, or in the other transcripts under `testing/transcripts/` (value match across `Finalists/` and `QualifierChallenge/` found only `Finalists/api_keys.env`).

## 2. Snapshot exclusion list (decision 10)

Whole-snapshot rules: copy main's files with no `.git`, then run a value check of both key values over the output, and a `grep -rn -E 'sig=|AccountKey|api_keys'` over it. No script exists for this yet (finding 3).

Must leave out:
- `Finalists/api_keys.env`
- any `.Renviron` and `.RData` (not tracked today; keep it that way)
- `.git` of both Finalists and the parent repo (history holds `78d3d2b`)
- `Finalists/notes/vault/` (personal Obsidian copy: mentor names, schedule, `VaultHub_CLAUDE.md`)
- `Finalists/stale/` (old reviewer copies, patch file)
- `Finalists/tasks/everett_api_keys.md` (points at the keys; low value)
- `Finalists/testing/transcripts/` and `Finalists/testing/` reviewer prompts if not wanted by judges (they contain reviewer chatter and Marco's account references)
- `Finalists/planning/06_tonight_plan.md`, `src/docs/organizer_materials_notes.md`, `saturday/mentor_log.md` (once filled), `saturday/people/`: scrub or drop organizer emails and names (finding 10, 11)
- `Finalists/drafts/claude/eval/sheets/key_hidden_DO_NOT_SHARE.csv` (hidden label key; also an integrity problem for the evaluation)
- `Finalists/data/cache/api/grantsgov/fetch/` token fields (finding 9), or strip the field

Likely keep but check: `QualifierChallenge/` (also goes to judges; no secrets found in tree or history; its `.Renviron.example` is empty; absolute home paths in four files, finding 13), `Finalists/app/`, `Finalists/src/`, `Finalists/data/processed/`.

## 3. Three actions before 9:00 am Sunday

1. Write and run the decision-10 snapshot script, then verify it: build from main with no `.git`, exclude the list above, and run a value-match for both key variables plus `grep` for `sig=` and `AccountKey` over the output. Marco, with Kent reviewing the result. If this cannot be done, rotate both keys at Simpler.Grants.gov and SAM.gov and tell judges nothing, because `78d3d2b` is on `origin/main` (Kent).
2. Confirm the repo's GitHub visibility stays private until the snapshot is the thing judges get, and add `Read(**/api_keys.env)` to the deny list in `.claude/settings.json` plus a `.gitignore` line so no one re-adds a copy. Kent.
3. Check the Blob SAS date: it expires about Tue Nov 10. Either get the role from a subscription Owner and switch to managed identity (azure_setup.md steps already written), or extend the SAS past judging. Also set the data-use claim on the limits slide to "not verified" or paste the Azure doc link. Marco.

## 4. [cannot assess]

- Whether the GitHub repo is currently private and who has access (no outside calls allowed).
- Whether the Simpler.Grants.gov and SAM.gov keys are still valid, rate-limited or tied to a person's account; rotation process.
- Actual SAS permissions, expiry timestamp and whether it also covers other blobs (value is not in the repo; read it from Azure).
- Live Azure state: Blob public access setting, Container App secrets, whether ingress IP restrictions exist, spend (azure_setup.md is the only evidence).
- Azure OpenAI data-use, abuse-monitoring and training terms (no evidence in the repo; Azure docs not read).
- Whether the Grants.gov `token` values in cache files are still live.
- Whether `GRANTS.GOV`, SAM or Federal Register terms restrict redistribution of cached responses in a public-facing snapshot.
- Contents of `.Renviron` and `.RData` (denied by project settings).
- Whether other copies of the keys exist outside git (chat, Obsidian vault elsewhere, `KALNotes`).
- Binary files (35 PDFs/XLSX under tracked paths) for metadata such as author names or embedded emails; not opened.
