# AI usage log

Add a row every time AI is used for something that ends up in the project. Write it as it happens. The final disclosure is written from this table.

| When | Who | Tool and model | What it was used for | Output used? | Human check done |
|---|---|---|---|---|---|
| 2026-11-06 | Noah Goldblatt | Codex (GPT-6) | Rechecked Finalists discovery notes and agency-plan inputs; drafted an AI handoff for the agency plan text-check task | Yes, handoff saved in `drafts/codex/agency_plan_text_handoff.md` | Verified file presence and guidance against the current repo; plan text itself was not extracted or checked |
| 2026-11-06 | Noah Goldblatt | Claude Code (Sonnet 5.5) | Plan text check rows 1-17: installed R pdftools, extracted full text of 17 plans, built `plan_text_check_noah.csv` and `agency_goal_summaries_noah.csv` (exact extracted text, no classification) | Yes (pending human review) | Script check that every quote/goal text is found on its cited PDF page and 17 manifest rows match once; a person must still open 3 PDFs. AI mistakes caught: first regex missed a goal because of multi-space gaps; initial goal lines cut off at line wraps (DMVA, DIT) and had stray table headers, fixed. Cover pages of Treasurer and Insurance are images, so no plan years in text for Insurance |
| | | | | | |

Notes for the disclosure:
- Say plainly what AI did and what people did.
- Say what was verified by a person, and how.
- Include UNC PromptLab and any other tool, not just Claude.
