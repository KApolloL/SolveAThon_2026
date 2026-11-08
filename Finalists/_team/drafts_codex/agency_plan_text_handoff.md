# Handoff: NC Agency Strategic Plan Text Check

**For:** the AIs assisting Noah Goldblatt and Matthew
**Prepared:** November 6, 2026
**Workspace:** `SolveAThon_2026/Finalists/`

## Task

Check all 34 strategic-plan PDFs listed in `data/raw/agency_plans/MANIFEST.csv`. Extract and save the full text from each plan, assess whether each plan is usable as text, and produce a source-based summary of each agency's goals. Do not invent missing facts. Separate what the PDFs state from any classification or interpretation.

The 34 manifest data rows are split evenly:

- **Noah:** rows 1–17. Save `src/docs/plan_text_check_noah.csv`; save extracted text under `data/processed/agency_plan_text/noah/`.
- **Matthew:** rows 18–34. Save `src/docs/plan_text_check_matthew.csv`; save extracted text under `data/processed/agency_plan_text/matthew/`.
- **Combined handoff:** after both halves are complete, Noah combines the individual check CSVs into `src/docs/plan_text_check.csv`, preserving every source value and checking for one row per manifest entry. Keep both individual CSVs and both extracted-text folders.

The user's broader request is to cover all agencies, preserve complete extracted text, and summarize each agency's goals. Each person should prepare goal summaries for their assigned rows; after both halves are complete, combine them into `src/docs/agency_goal_summaries.csv` with citations to plan filename and page. Do not combine, overwrite, or edit the other person's working files. Goal-category classification remains subject to Kent's approval as described below.

## Read first

1. `AGENTS.md` (rules for Codex and other agents; takes precedence over `CLAUDE.md` for agent behavior).
2. `CLAUDE.md` and `docs/AI_HANDOFF.md` for project context and constraints.
3. `planning/06_tonight_plan.md`, especially “Noah and Matthew: plan text checks.”
4. `planning/07_discovery_findings.md` and `notes/vault/Solveathon_DiscoverySession.md` for discovery context.
5. `docs/QUEST_BRIEF.md`, `data/raw/agency_plans/README.md`, and `MANIFEST.csv`.

## Verified context from the repo

- This is the UNC Solve-a-thon Final Quest, **Federal Funds Matchmaker**, sponsored by NC OSBM. The prototype is intended to help NC agencies find and act on federal funding opportunities; humans make final decisions.
- Discovery notes describe users as agency grants leads or staff who screen opportunities among other duties. Some agencies lack a dedicated grants scanner. Notes say time, short deadlines, unclear eligibility, and uncertainty about which agency should apply are key problems. These are organized notes, **not verbatim sponsor quotes**; mark claims `[from notes]` unless checked against a recording or field notes.
- Sponsors' stated or implied needs in those notes include fast, simple results; low user effort; eligibility guidance; payoff-versus-effort; understandable rationale; and cross-agency usefulness. The notes do not settle which agency to serve first.
- `data/raw/agency_plans/` exists and contains 34 PDF rows in the manifest, including a row called “Guiding Principles.” Do not silently call all rows agencies; use the manifest's labels and flag non-agency or cross-cutting documents.
- The folder README says the PDFs are public and unmodified, downloaded from the OSBM strategic-planning page on Nov 6, 2026. `MANIFEST.csv` records each plan's agency label, source URL, HTTP status, content type, byte count, and filename. It reports PDF content types and successful HTTP responses for the listed rows.
- The task-specific plan-check instructions require: page count; extractability (`yes`, `partial`, `no`); extracted character count; whether a goals/objectives/priorities section is found; its starting page; a first goal quoted exactly (under 25 words); plan years quoted from the PDF; and notes on anomalies. Use `unknown` when not verifiable.
- The discovery notes do **not** provide a completed framing worksheet or approved 3–5 measurable criteria. `planning/02_framing_worksheet.md`, `testing/context.md`, and `src/docs/fact_sheet.md` remain templates/blank. Do not claim inferred criteria are sponsor-approved or use them to rank agencies.

## Important boundaries

- Do not modify, move, or rename anything in `data/raw/`.
- Do not profile federal opportunity data, download new data, call external services, install dependencies, or make cloud changes.
- No participant, patient, or personal data. No secrets or keys.
- Keep source facts separate from interpretation. Every goal summary must cite the plan filename and page. Copy all quotes exactly from extracted text.
- The user explicitly wants the complete extracted plan text saved. Save it only in the assigned `data/processed/agency_plan_text/noah/` or `.../matthew/` folder, never beside or over source PDFs. If extraction or writing fails, report the exact limitation; do not silently omit a plan.
- Do not finalize a goal classification taxonomy, agency shortlist, match scoring, or success metric on your own. The repo says Kent owns framing, scope, and criteria. Mark such decisions `NEEDS KENT`.
- Do not present a PDF-derived summary as a verified agency priority when extraction is partial, garbled, or ambiguous. Flag it for a person to check.

## Expected deliverables

For Noah's assigned rows 1–17 and Matthew's assigned rows 18–34, independently:

1. Their individual check CSV (`src/docs/plan_text_check_noah.csv` or `src/docs/plan_text_check_matthew.csv`) with exactly the columns and order in `planning/06_tonight_plan.md`'s prompt: `agency,file,pages,text_extractable,chars_extracted,goals_section_found,goals_page,goals_quote,plan_years,notes`.
2. Full extracted text files for assigned plans under their own folder in `data/processed/agency_plan_text/`, with filenames traceable to the manifest. Do not modify `data/raw/`.
3. A compact goal summary per plan. Once combined, use `src/docs/agency_goal_summaries.csv`, with fields for agency, plan file, plan page, goal/objective text or concise source-based summary, and classification status. Include a classification category only if Kent has approved the taxonomy; otherwise set status to `NEEDS KENT` and leave the category unset.
4. A top-three shortlist from each person's rows may be reported only as a **preliminary technical shortlist** based on text extractability, presence of a goals section, and stated plan years. It is not a strategic choice of which agency the product should serve. Cite the evidence and mark currentness judgments `[uncertain]` unless the project owner has defined what counts as current.

After both halves are complete, Noah combines both check CSVs into `src/docs/plan_text_check.csv` and both goal-summary tables into `src/docs/agency_goal_summaries.csv`. Verify that the combined outputs cover every manifest data row exactly once, without changing source values. Retain the two individual CSVs and extracted-text folders.

## Framing still needed before agency matching/classification

Before turning goal summaries into a product classification or opportunity-matching system, get Kent's decision on:

- whether the first pilot covers one agency or all agencies;
- the primary user's role and the action the output should trigger;
- 3–5 measurable match criteria, each tied to an available field and a source from the discovery session;
- a pass/fail evaluation target and baseline;
- what “classify agency goals” means (for example, a shared cross-agency goal taxonomy versus each agency's own objective labels).

The discovery notes support these as questions, not answers. Existing qualifier classifications concern grant authority tiers and program domains; do not reuse them as an agency-goal taxonomy without Kent's approval.

## Response format

Report: files created; rows/plans covered; extraction method already available in the environment; any unreadable or partial PDFs; top-three preliminary technical shortlist with page citations; what was not done; assumptions and `NEEDS KENT` decisions; any mistake caught during spot-checking. Do not say a validation passed unless it was run and its output checked. Log AI use in `AI_USAGE_LOG.md` as the project requires.
