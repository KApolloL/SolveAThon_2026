# AI usage log

Add a row every time AI is used for something that ends up in the project. Write it as it happens. The final disclosure is written from this table.

| When | Who | Tool and model | What it was used for | Output used? | Human check done |
|---|---|---|---|---|---|
| 2026-11-06 | Marco | Claude Code (Sonnet 5.5) | Azure CLI install and login help, read-only subscription/model checks, created storage, Log Analytics, container registry and Container Apps environment (each approved by Marco), wrote hello Shiny app, Dockerfile and `src/docs/azure_setup.md` | Yes | Marco signed in himself and approved the plan and the creates; resource list to be re-checked in the portal; app not yet built or tested |
| 2026-11-06 | Kent (Claude Code session) | Claude Sonnet 5.5 and Opus-class planning | Planned and wrote the opportunity ingestion pipeline (R/02a to 02e, 03, test_ingest.R), probed Grants.gov, Simpler, Federal Register, USAspending, SAM.gov and transportation.gov endpoints | Yes, scripts and tables | Counts compared against live Grants.gov search (884 posted, 588 forecasted); tests pass; state-agency name rule in 02c still needs a human review. AI error caught: first XML parser took over 10 minutes and was replaced; USAspending "state_government" filter returned 0 rows |

Notes for the disclosure:
- Say plainly what AI did and what people did.
- Say what was verified by a person, and how.
- Include UNC PromptLab and any other tool, not just Claude.
| 2026-11-06 | Matthew | Codex, GPT-6 | Extracted assigned agency plan PDFs locally, checked goal sections and prepared text-check and goal-summary CSVs. | Yes, pending human review | Need Matthew to open and spot-check 3 PDFs; automated quote checks and row counts performed. AI errors caught: the first Swift invocation treated a PDF argument as source and failed; a whitespace-sensitive quote check initially rejected valid line-wrapped text. Both were caught during verification; no source PDF was changed. |
