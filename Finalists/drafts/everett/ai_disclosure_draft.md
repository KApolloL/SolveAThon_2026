# AI-usage disclosure (first draft)

> Numbers updated Sat Nov 7 (~7 pm) after the embassy filter, region list and tribal-title rule (won-program denominator now 157); values from `src/docs/fact_sheet.md`. Edited by Kent's docs-sync Claude session.

**Draft by Everett's Claude for Kent and Marco; they own the real one.** Not for submission as written. `docs/RUNBOOK.md` line 20 gives the log and the disclosure to role D (Marco and Kent).

Every claim below cites a source. "Log line N" means line N of `Finalists/AI_USAGE_LOG.md`. "Notes line N" means `Finalists/drafts/claude/docs/field_notes_draft.md`. Tool and model names are copied as the log wrote them; none were checked against a vendor [unverified]. The only numbers used are from `src/docs/fact_sheet.md`.

## 1. Which tools were used for what

| Tool (as logged) | Used for | Log lines |
|---|---|---|
| Claude Code, Sonnet 5.5 and Opus 5.5 (Kent, Marco, Noah, Everett) | Planning and writing the R pipeline: ingestion, ranking, eligibility, payload, backtests. Also the evaluation kit, drafts, and the tool page `matchmaker.html` | 10-13, 22-26, 32-36, 41-42, 45-47, 50-52, 54-58 |
| Claude Code (Marco): Azure work | Azure CLI help, creating Azure resources (each approved by Marco), proof app, Azure OpenAI test calls | 10, 15, 23 |
| Claude Code (Noah, Kent): plan PDFs | Extracting text from the agency plan PDFs and goal tables | 8, 22 |
| Claude Code with many subagents (Marco, Noah) | Reviewer runs over the repo (26, then 50 subagents). Findings are hypotheses, not user evidence | 26, 44, 49 |
| Codex, GPT-6 (Noah, Matthew) | Agency plan handoff; plan PDF extraction; EPA DERA and Grants.gov eligibility checks | 7, 21, 31 |
| OpenCode: Big Pickle (Matthew); DeepSeek V4.1 Flash Free (Everett); "Default chat model" (Everett) | Matthew's eligibility checks; Everett's persona agents; Everett's award backtest scripts and mapping | 27, 37, 39, 40, 43 |
| Local Ollama, qwen2.5:14b (Kent) | Labelled the evaluation pool as relevant, maybe or not relevant per agency goals (prompt `evalpool-v3`) | 38, 53 |
| Azure OpenAI (Marco) | Created and called twice to test. Logged use stops at the test. Whether the product uses it: not found in the log [unverified] | 15 |
| UNC PromptLab | **Not found in the log.** The log's own note says to include it if used (log line 20). Notes line 126 and 215 still ask the team to confirm | n/a |

## 2. The rule: the AI labels, people decide

- Project rule: "If an LLM is used on data, it only labels with quoted evidence. It does not make the final decision." (`Finalists/CLAUDE.md` line 28). The brief also says humans make the final decision (`docs/QUEST_BRIEF.md` line 54).
- Design decision 7: Azure chat writes a short reason with plan and notice quotes, a script checks each quote appears in its source, and "The LLM never decides" (Notes line 100).
- Ranking and eligibility are rules in R, not model calls. Text rules can rule an item out but never confirm it; a text "yes" becomes "check eligibility" with the quote shown (log line 50). The fact sheet counts these pairs: 16,288 marked check eligibility, 5,394 hidden by the filters (clearly not eligible, run by a U.S. embassy abroad, or a tribal-only program) (fact sheet rows 7 and 8).
- The model labels from the local qwen run failed the validation gate and stay out of the tool's payload; they are "model labels, unvalidated", not ground truth (log lines 38, 47).
- The tool never applies for anything (Notes line 41).

## 3. What humans checked, and what they did not

Checked by people, as logged:
- Noah and Matthew hand-labelled a blind held-out sample without seeing model output; the gate failed on it (log lines 30, 48; Notes line 174).
- Marco approved each Azure create and signed in himself (log lines 10, 15).
- Kent chose every option in the planning interview; Claude only recommended (log line 24). Kent also read the Top 10 "yes" eligibility rows (log line 50).
- Matthew opened the cited Grants.gov pages and copied exact quotes (log line 43).

Checked only by script or by Claude, not yet by a person:
- Plan text and goal quotes: scripts confirm quotes sit on the cited page; a person still had to open 3 PDFs (log line 8).
- Relevance of the Top 10 rows and the match board: "A person still has to read" them (log line 54).
- The funder-to-agency map and the 0.8 floor are guesses, not human-checked (log line 42).
- Backtest agency assignments, DNCR older names least certain (log line 55).
- Backtest figures and error analysis, "Not human-checked yet" (log lines 57, 58). Cause statements are "inferred from titles and ranks, not tested" (log line 58).
- Scoring facts in the fact sheet are marked "Claude; Kent to confirm" (fact sheet rows 3 to 30).
- Simulated reviewers and personas are not user evidence (`Finalists/CLAUDE.md` line 140). Whether any real agency user has seen the tool: not found in these files [unverified].

## 4. Where an AI was wrong and how we caught it

All from rows already recorded.

1. **Goal-heading fit looked reasonable and failed on real data.** Claude's first fit score used goal headings only; the DERA notice ranked 1036 for DEQ and NIH research led for DPI. Caught by running it on the real data; fit now uses the full plan text (log line 33).
2. **A "known-good" test case did not exist.** The AI-drafted worksheet named Clean School Bus (CFDA 66.045); the data has 0 rows with it. Caught by searching the file for "66.045" (Notes line 173). Tagged `[uncertain]` at the time; no person had reviewed it.
3. **Text rules gave false "yes" on eligibility.** Two Top 10 rows were wrongly "yes" because phrases named state agencies in passing. Caught by reading the Top 10 yes rows; rule changed so text never confirms (log line 50).
4. **Everett's own session.** OpenCode rewrote reviewer specs without checking the remote, duplicating merged work. A persona then found a committed keys file that the AI "had walked past" (log line 27).
5. **Smaller ones:** a stub that chose a forecast with a 2019 close date, caught on inspection (log line 32); a backtest step miscounted won programs, caught on a message check (log line 37); a stray reference that made the first backtest v2 draft fail (log line 55); reviewer subagents mixed right and wrong claims, three called a real DPI goal a misextraction, caught by grepping the plan text (log line 44).
6. **Own AI said something false:** a Codex CSV claimed 20,160 characters for the Justice text but the file was 1 byte, caught by comparing claim to file (log line 22).

If only one is needed for the form, row 1 is the clearest: cause, catch, and fix are all in one log row.

## 5. Key prompts: where they live

Not reproduced here. Do not paste invented prompts.
- `Finalists/drafts/claude/docs/field_notes_draft.md` section 6 (Notes lines 132-158) quotes three prompts: Azure skeleton (Marco), plan text check (Noah, Matthew), and a rules block for any chat AI. Sources it names: `planning/06_tonight_plan.md` and `tasks/teammate_ai_rules.md` [file contents not opened by this draft].
- Local labelling prompt `evalpool-v3`: used by `drafts/claude/eval/model_label.R` (log line 38). Text not read by this draft.
- Ingestion pipeline and framing worksheet prompts: "the repo does not hold" them (Notes line 134).

## 6. Gaps (do before submitting)

- UNC PromptLab or any other chat tool: confirm with all five whether used (Notes lines 126, 215).
- Some Everett rows say "Default chat model" with no model name (log lines 37, 39, 40).
- Log table formatting: blank row at line 9, and rows after the "Notes for the disclosure" block (line 21); several late rows have fewer than 6 cells.
- Notes line 128 says the overnight session and Saturday plan lacked log rows; whether log lines 12 to 14 close that: [unverified].
- Missing prompts above; three PDF spot-checks and Marco's portal checks not recorded as done (Notes line 217).
- Real user feedback: not found.
