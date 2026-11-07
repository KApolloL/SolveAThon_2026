# Assumptions and open questions (architecture, security, stakeholders)

Draft v0.1, state read 2026-11-06. For Kent to confirm. No keys or secrets are in this file.

## Verified by read-only checks on 2026-11-06 (Azure CLI show and list only)
- ffm-app is running, external ingress, min replicas 0, max 1, system-assigned identity; no secrets set on the app; platform auth not enabled (so no login).
- Container Apps environment ffm-env is wired to a Log Analytics workspace (customer id present). It is ffm-logs by name in azure_setup.md; the link by name was not separately checked.
- Registry ffmacrteam15: admin user off. AcrPull for the app identity is from the proof-run notes in `src/docs/azure_setup.md`, not re-read.
- Storage ffmdatateam15: no public blob access, TLS 1.2, zero role assignments at account scope. Nothing in the app reads it.
- Zero Azure OpenAI (Cognitive Services) accounts and zero Container Apps jobs in the resource group.
- Everything else tagged LIVE (image contents, 6,523 rows, 38 s cold start, budget alert levels, browser checks) comes from the proof-run notes in `azure_setup.md` and `planning/08_saturday_plan.md`, not from a fresh test.

## ASSUMED (architecture)
1. The planned design follows `planning/08_product_decisions.md` (decisions 6, 7, 13) as relayed by the coordinator: JS tool reading payload.json, Azure OpenAI for embeddings and reasons, Blob for payload and cache, Container Apps hosting, R Shiny as fallback. I could not read that file directly in this worktree; I used `git show origin/main` only. Confirm the details.
2. The scheduled job is kept as PLANNED and optional. Kent's decisions do not name it; it comes from the Saturday plan. Runs may be done by hand from a team laptop first.
3. The scoring pipeline is drawn as a separate planned box. Where it runs (laptop, job, or in the app) is not decided.
4. The earlier "decisions store" (Pursue, Maybe, Pass saved to Blob) from the Saturday plan is not drawn, because Kent's 15 decisions do not include it. The feedback button is not drawn. Confirm if either should appear.
5. Flow 9 authentication (key or managed identity) is not decided; shown as [assumed].
6. tool.html is a static file served by ffm-app and uses qualifier data, not Finals data (stated by the coordinator, not tested by me).
7. Team developer and GitHub: the private repo is drawn with no runtime link. The repo holds the committed key file (private; chosen on purpose by Kent).

## ASSUMED (security)
8. Severity ratings (High, Medium, Low) are my judgment of likelihood times impact, not a formal score. T1 is Medium because data is public; it would rise if any non-public data were added.
9. TLS: ffm-app is reachable over HTTPS on the platform domain (seen working in the proof run). I did not check certificate or minimum-version settings.
10. The prompts-not-used-for-training claim for Azure OpenAI is [uncertain] and stays so until the Azure data-handling documentation is read. Nothing here claims it.
11. Key Vault, Entra sign-in, private endpoints, rate limiting, content filtering, audit logging and an as-of date are recommendations for a pilot. None exists today.
12. "Keys committed in a private repo" is Kent's recorded choice (CLAUDE.md). I treat it as a gap only for public or State handoff.

## ASSUMED (stakeholders)
13. All power and interest scores and all attitudes are [assumed] except attitudes marked [from notes] in the register (the OSBM sponsor lead's goal, the privacy concern, the no-dedicated-team point). The notes are our organized discovery notes, not verbatim sponsor quotes.
14. Roles only. Several people named in the notes are intentionally not named here. Role spellings in the notes are unverified.
15. The RACI is entirely a draft. Who is Accountable for security review (State IT) and pilot funding (OSBM budget decider) is a guess.
16. "Dedicated grant staff" as a possibly sceptical group is an inference from the notes that some agencies have grant workers.
17. The "build team" appears as a stakeholder so the map is honest about who makes claims.

## Questions to confirm
- Who in State IT or the agencies decides whether Azure OpenAI is acceptable, and what is the answer to the sponsor privacy question (the "local model" note vs the Azure rule)?
- Is Azure OpenAI ours to create or provided by the organizers? (Open at the 9:00 check-in.)
- Who would operate the tool after a pilot, given there is no dedicated team?
- Should the scheduled job and a decisions store stay on the slides, or be cut?

## What was not checked
- Visual rendering in a browser of report.html. SVGs were rendered to images with the macOS Quick Look thumbnailer (which clips wide images) and inspected in pieces. Printing to PDF was not tested.
- Azure state beyond the commands listed above; no Azure changes were made.
