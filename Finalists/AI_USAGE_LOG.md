# AI usage log

Add a row every time AI is used for something that ends up in the project. Write it as it happens. The final disclosure is written from this table.

| When | Who | Tool and model | What it was used for | Output used? | Human check done |
|---|---|---|---|---|---|
| | | | | | |

Notes for the disclosure:
- Say plainly what AI did and what people did.
- Say what was verified by a person, and how.
- Include UNC PromptLab and any other tool, not just Claude.
| 2026-11-06 | Matthew | Codex, GPT-6 | Extracted assigned agency plan PDFs locally, checked goal sections and prepared text-check and goal-summary CSVs. | Yes, pending human review | Need Matthew to open and spot-check 3 PDFs; automated quote checks and row counts performed. AI errors caught: the first Swift invocation treated a PDF argument as source and failed; a whitespace-sensitive quote check initially rejected valid line-wrapped text. Both were caught during verification; no source PDF was changed. |
