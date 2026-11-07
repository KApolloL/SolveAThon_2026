# Graph Report - Finalists  (2026-11-06)

## Corpus Check
- 119 files · ~74,597 words
- Verdict: corpus is large enough that graph structure adds value.
- Unclassified: 29 file(s) not represented in the graph (top: (none) 14, .csv 11, .Rproj 1)

## Summary
- 569 nodes · 855 edges · 32 communities (29 shown, 3 thin omitted)
- Extraction: 82% EXTRACTED · 18% INFERRED · 0% AMBIGUOUS · INFERRED: 152 edges (avg confidence: 0.83)
- Token cost: 0 input · 0 output

## Community Hubs (Navigation)
- Community 0
- Community 1
- Community 2
- Community 3
- Community 4
- Community 5
- Community 6
- Community 7
- Community 8
- Community 9
- Community 10
- Community 11
- Community 12
- Community 13
- Community 14
- Community 15
- Community 16
- Community 17
- Community 18
- Community 19
- Community 20
- Community 21
- Community 22
- Community 23
- Community 24
- Community 25
- Community 26
- Community 27
- Community 28
- Community 29
- Community 30

## God Nodes (most connected - your core abstractions)
1. `Quest: Federal Funds Matchmaker (OSBM)` - 14 edges
2. `bash` - 10 edges
3. `data/raw intake log (never modify, no participant data)` - 9 edges
4. `persona_director roleplay` - 9 edges
5. `hostile-judge: scores 5 criteria, 8 hardest Q&A questions` - 8 edges
6. `architecture-security-diagram SKILL` - 8 edges
7. `hostile-judge reviewer` - 8 edges
8. `persona_user roleplay` - 8 edges
9. `persona_supervisor roleplay` - 8 edges
10. `llm_label()` - 8 edges

## Surprising Connections (you probably didn't know these)
- `Deliverables: 6-min pitch, Solution Design and GenAI Field Notes, repository` --semantically_similar_to--> `Submit: slides, Solution Design and GenAI Field Notes, repo README, product link`  [INFERRED] [semantically similar]
  docs/QUEST_BRIEF.md → README.md
- `During: build filter-score-rank-explain, gate 1 pm, find one real failure` --semantically_similar_to--> `Sat schedule: 1:00 gate working ranking, test-breaker, slide brief by 5:00, code freeze 7-8`  [INFERRED] [semantically similar]
  notes/vault/Solveathon_FinalsChecklist.md → docs/RUNBOOK.md
- `Evaluation recipe: label 20-30 opps blind, precision@10, recall top 25, keyword baseline, two failures` --semantically_similar_to--> `Success test: hand-labeled recall in top N, known-bad ranks last, Clean School Bus known-good, deterministic rerun`  [INFERRED] [semantically similar]
  src/docs/organizer_materials_notes.md → planning/02_framing_worksheet.md
- `All weekend: log AI use, numbers from fact_sheet, run tests before saying passes` --semantically_similar_to--> `Rule: every slide number from src/docs/fact_sheet.md`  [INFERRED] [semantically similar]
  notes/vault/Solveathon_FinalsChecklist.md → README.md
- `Rules: Azure, public data only, any model, humans decide` --semantically_similar_to--> `Must run on Azure`  [INFERRED] [semantically similar]
  docs/QUEST_BRIEF.md → README.md

## Import Cycles
- None detected.

## Hyperedges (group relationships)
- **Opportunity ingest scripts (02a-02e)** — src_r_02a_grantsgov_extract, src_r_02b_grantsgov_api, src_r_02c_usaspending, src_r_02d_federal_register, src_r_02e_simpler_grants [EXTRACTED 1.00]
- **Opportunity and plan data sources pulled Nov 6** — data_raw_readme_grantsgov_extract, data_raw_readme_simpler, data_raw_readme_fedreg, data_raw_readme_usaspending, data_raw_readme_agency_plans [EXTRACTED 1.00]
- **Final submission set due Sun 9:00 am** — readme_deliverables_submit, docs_quest_brief_deliverables, docs_quest_brief_field_notes, deliverables_slide_brief_template_constraints [EXTRACTED 1.00]
- **Five judging criteria** — claude_judging_understand, claude_judging_frame, claude_judging_solve, claude_judging_evaluate, claude_judging_drive_impact [EXTRACTED 1.00]
- **Framing gate before data** — finalists_planning_02_framing_worksheet_problem, finalists_planning_02_framing_worksheet_user_card, finalists_planning_02_framing_worksheet_decision, finalists_planning_02_framing_worksheet_success_test, finalists_planning_02_framing_worksheet_criteria, finalists_planning_02_framing_worksheet_gate, finalists_notes_vault_vaulthub_claude_deloitte_method [EXTRACTED 1.00]
- **Custom role-play chain: persona + scenario -> roleplay prompt -> observer prompt -> results log** — finalists_testing_persona_template, finalists_testing_scenario_template, finalists_testing_prompts_roleplay_prompt_template, finalists_testing_prompts_observer_prompt_template, finalists_testing_results_log [EXTRACTED 1.00]
- **Six reviewer/persona specs built to two formats** — finalists_testing_readme_hostile_judge, finalists_testing_readme_data_critic, finalists_testing_readme_test_breaker, finalists_testing_readme_persona_user, finalists_testing_readme_persona_supervisor, finalists_testing_readme_persona_director, finalists_testing_readme_build_reviewers [EXTRACTED 1.00]
- **Reviewer agents sharing testing/context.md** — _claude_agents_test_breaker_test_breaker_reviewer, _claude_agents_hostile_judge_hostile_judge_reviewer, _claude_agents_data_critic_data_critic_reviewer, _claude_agents_hostile_judge_testing_context_md [EXTRACTED 1.00]
- **Consulting-meeting personas** — _claude_commands_persona_user_persona_user, _claude_commands_persona_supervisor_persona_supervisor, _claude_commands_persona_director_persona_director, _claude_agents_hostile_judge_testing_context_md [EXTRACTED 1.00]
- **Single-file tool bundle** — src_tool_index, src_tool_styles, src_tool_ranker, src_tool_ui, data_data_processed_payload_json [EXTRACTED 1.00]
- **Azure deployment chain** — finalists_src_docs_azure_setup_state, finalists_src_docs_azure_setup_sat_plan, finalists_src_docs_organizer_materials_notes_starter_kit, finalists_planning_06_tonight_plan_marco_prompt [INFERRED 0.75]
- **Discover-Build-Test-Present method and gate** — notes_vault_solveathon_deloittetraining_four_phases, notes_vault_solveathon_deloittetraining_four_questions, notes_vault_solveathon_deloittetraining_fsre, notes_vault_solveathon_deloittetraining_testing, docs_runbook_gate, docs_ai_handoff_method [INFERRED 0.85]
- **Friday discovery to framing flow** — finalists_planning_01_discovery_questions_question_list, finalists_planning_07_discovery_findings_requirements, finalists_planning_07_discovery_findings_plan_changes, finalists_planning_02_framing_worksheet_gate, finalists_planning_06_tonight_plan_schedule [INFERRED 0.85]
- **Ranking pipeline (score.R, ranker.js, agreement test)** — src_r_score, src_tool_ranker, src_tests_agreement [INFERRED 0.95]

## Communities (32 total, 3 thin omitted)

### Community 0 - "Community 0"
Cohesion: 0.06
Nodes (54): data-critic: attacks proxies, weights, missing data, leakage, hostile-judge: scores 5 criteria, 8 hardest Q&A questions, testing/context.md: page every reviewer reads first, test-breaker: writes expected-vs-actual tests, test_cases.csv rows, /checkpoint: six-hour checkpoint, updates handoff.md, /kickoff: release-day Discover gate, Persona: non-technical budget director, 5 min, Persona: supervisor, risk/staff time/accountability (+46 more)

### Community 1 - "Community 1"
Cohesion: 0.05
Nodes (42): Lessons for finals: build slide brief early, commit early, rotate Census key, tests before results, Qualifier tool: 1,662 opps in Tiers 1-4, Reusable skeleton: config file, cached fetch, hand-label sample, fact-check script, single-file tool, Qualifier weaknesses named (no Tier 1-3 spot check, $1M placeholder, prompt v3.1), Deloitte method: Discover, Build, Test, Present; no data until user and 3-5 criteria written, Finals Fri Nov 6 to Sun Nov 8 2026, Manning Hall; 5 min + 2 min Q&A; Devpost due Sun 9:00 AM, Team: Kent (primary coder), Everett, Marco, Matthew, Noah, Note-taker sheet: verbatim words, measurable detail, follow-up (+34 more)

### Community 2 - "Community 2"
Cohesion: 0.08
Nodes (27): Teammate AI rules block (9 rules), UNC Solve-a-thon, Nov 6-8 2026, in person, Supervisor / decision maker (blank, to fill), Judging criteria: Understand, Frame, Solve, Evaluate, Drive Impact, Organizer threats: false positives, false negatives, uneven docs, data quality, OSBM Federal Funds Matchmaker problem (AI-assisted, human final call), Primary user: agency grant coordinator [assumed], confirm after 6:30 pm workshop, Talk: 6 min with demo plus 2 min Q&A (earlier email said 5+2) [assumed conflict] (+19 more)

### Community 3 - "Community 3"
Cohesion: 0.08
Nodes (34): criteria.csv (the whole method), facts.csv (slide numbers as R exprs), test_cases.csv, items.csv (or toy example), payload.json, raw-file profile CSVs, ranking.csv, data/raw files (csv/xlsx/json/rds) (+26 more)

### Community 4 - "Community 4"
Cohesion: 0.06
Nodes (38): api_keys.env (team API keys, private), cache/api/simpler, LLM label cache (sha256 keyed), API_SLEEP_SEC, CLOSED_SINCE, CRITERIA_FILE, FACTS_FILE, FR_API_BASE (+30 more)

### Community 5 - "Community 5"
Cohesion: 0.06
Nodes (29): cache/api/federalregister, cache/api/grantsgov_extract zip+xml, cache/api/grantsgov_status, cache/api/usaspending, federal_register_notices.csv, grantsgov_api_status.csv, grantsgov_extract.csv, grantsgov_status_disagreements.csv (+21 more)

### Community 6 - "Community 6"
Cohesion: 0.07
Nodes (27): Architecture assumptions A1-A6 (Cosmos DB, Entra ID, App Insights, public data, SAM key in .env, AI Search not built), Open questions: who may change scoring weights, retention, test tenant, labelled good-match set, Example architecture: Function App + Azure OpenAI + Cosmos + Blob + Streamlit web app, 10 numbered data flows, Next steps: Key Vault for SAM key, injection defenses, 30-item labelled eval set, Threat register T1-T10 (prompt injection T5, SAM key T6, wrong AI match T8), Azure Well-Architected quick check, Stakeholder assumptions A1-A6 (agency leadership decides, NCDIT approves pilot, scores ASSUMED) (+19 more)

### Community 7 - "Community 7"
Cohesion: 0.13
Nodes (20): Talk plan 5 min + 2 min Q&A: Ask 0:30, why 1:15, how 0:45, limits 1:00, next 0:45, buffer 0:45, Marco Azure setup prompt (Claude Code, stop-and-ask on creates, no secrets), Noah/Matthew plan text check prompt: 34 PDFs split rows 1-17 / 18-34, CSV output, Owners: Kent planning, Marco Azure, Noah/Matthew plan text checks, Everett unassigned, Top-3 agency shortlist due to Kent before 7:30 PM, Blob layout ffm-data: profiles, raw, opportunities, scored, decisions, eval, runs, Open decisions: Azure OpenAI ours? R Shiny vs Python?, Rollback: delete only own resources, ask first (+12 more)

### Community 9 - "Community 9"
Cohesion: 0.13
Nodes (15): Rule canary: reply must be NEEDS KENT when framing/criteria decision needed, ChatGPT/Codex project 'Solveathon Finals' with only Finalists/ attached; canary passed; Drive plugin blocked, Kent checkpoints: Fri 5:30 setup, 6:30 workshop, 7:30 /kickoff gate, Sat 1:00 PM ranking gate, Sat 5:00 slide brief, Sat 8:00 code freeze, Sun <9 AM Devpost, Gemini setup: Flash model, solveathon-finals skill chip, partial canary pass, Hand-off loop: Claude writes brief, tool writes drafts/<tool>/, Claude checks, promote, log in AI_USAGE_LOG, OpenCode setup: free opencode/deepseek-v4.1-flash-free passed 18/18 tests; qwen2.5-coder:32b failed, Roles A client lead, B data/testing, C story/slides, D Q&A/proof (names blank), Tool routing: Claude Code main; OpenCode, Codex/ChatGPT, Gemini, PromptLab for small tasks (+7 more)

### Community 10 - "Community 10"
Cohesion: 0.12
Nodes (12): Qualifier verified numbers (296 open, 27/24/3/366 tiers, 60 hand labels), Judging criterion: Evaluating (name a real weakness), Judging criterion: Framing, Judging criterion: Driving Impact (budget director knows next step), Solve-a-thon judging rubric (5 criteria), Judging criterion: Solving, Judging criterion: Understanding, Rule: every slide number listed here with reproducing script (+4 more)

### Community 11 - "Community 11"
Cohesion: 0.20
Nodes (10): Judging: Understand, Frame, Solve, Evaluate, Drive Impact, Not confirmed: topic/data, starter kit, Azure LLM endpoint, agencies, Who does what: Kent lead and only merger; Claude planner; other AIs bounded tasks; teammates research/test/slides, Deliverables: 6-min pitch, Solution Design and GenAI Field Notes, repository, Field notes must show: target user, sponsor-driven plan changes, tools, key prompts, one AI error caught, Five stages: Understand, Frame, Solve, Evaluate, Drive Impact, Roles: Kent tech lead; A client lead; B data and testing; C story and slides; D Q&A and proof, Work flow: Drive folders A_client..D_qa, task briefs, log AI use in AI_USAGE_LOG.md (+2 more)

### Community 12 - "Community 12"
Cohesion: 0.13
Nodes (14): git diff*, git log*, git merge*, git push*, git rebase*, git reset --hard*, git status*, rm -rf* (+6 more)

### Community 13 - "Community 13"
Cohesion: 0.20
Nodes (9): cache/ocr per-page text, agency_plan_text/all/<plan>.txt, agency_plans/MANIFEST.csv + 34 plan PDFs, ocr_vision (macOS Vision swift helper), agency_goal_summaries.csv, plan_text_check.csv, plan_text_extract_log.csv, MIN_CHARS (OCR trigger) (+1 more)

### Community 14 - "Community 14"
Cohesion: 0.20
Nodes (10): Fri schedule: 6:30 discovery workshop, 7:30 design sprint, gate: no data before framing, Gate: user, decision, 3-5 criteria, success test, options with tradeoffs before opening data, Four questions before any spreadsheet: user, decision, good match, distrust, Weekend plan with hour splits (5-min version, now 6), At release: paste prompt to CLAUDE.md, decide problem type, hand out roles, fill framing worksheet, Goals: user and criteria Friday before data; working ranking by Sat 8 PM, Mentors: Zhang, Lavender, Rosales, Patekar, Wangikar, Gao, O Hare, Kwon, Next steps: confirm Devpost vs form, late block, dry-run team setup, PromptLab trial (+2 more)

### Community 15 - "Community 15"
Cohesion: 0.22
Nodes (9): Repo notes: different from qualifier, confirm Azure path, 6 vs 5 min, Rules: Azure, public data only, any model, humans decide, Azure: sub unc-sdis-solveathon-team15, owner Marco, $500 limit, OpenAI not provisioned, Blockers: is Azure OpenAI ours to create; Shiny on Container Apps unknown; $500 cap, Decisions: keep R and Quarto plus small Azure front end; user assumed grant coordinator; Rank + Classify, Next three steps: Azure (Marco), workshop + sprint gate, then profile data, Open questions: R vs Python, lanes, what 9am submits, Azure services, which agencies, real user, Status table: quest brief done, Azure in progress, framing not started, ingestion done (+1 more)

### Community 16 - "Community 16"
Cohesion: 0.20
Nodes (9): Threats: false positives, false negatives, uneven agency docs, inconsistent data quality, Quest TL;DR: AI-assisted matchmaker on Azure, humans make final call, Budget, staffing, training: no dedicated OSBM team; non-technical users, Core problem: unknown how many grants missed; crowdsource attempt failed, Kickoff: goal is NC pulls down federal funds it qualifies for; school bus missed deadline example, Why missed: no time, short deadlines, unclear owner, hard eligibility, Open: resolve privacy vs Azure, verify $5B figure, which agency to serve, Privacy: public data only; notes say local model, conflicts with Azure rule (+1 more)

### Community 17 - "Community 17"
Cohesion: 0.27
Nodes (7): Sun schedule: submit before 9:00, present 10:00-12:30 (6 + 2), All weekend: log AI use, numbers from fact_sheet, run tests before saying passes, Submission due Sun Nov 8 9:00 am via Final Submission form, Submit: slides, Solution Design and GenAI Field Notes, repo README, product link, Federal Funds Matchmaker finals task (NC OSBM), Team: Kent, Everett, Marco, Matthew, Noah, Primary user assumed: agency grant coordinator, confirm at discovery workshop

### Community 18 - "Community 18"
Cohesion: 0.25
Nodes (7): 34 NC agency strategic plan PDFs (OSBM), Framing needed from Kent: one vs all agencies, user role, 3-5 criteria, eval target, goal taxonomy, Outputs: plan_text_check.csv, agency_goal_summaries.csv, extracted text folders, Split: Noah rows 1-17, Matthew rows 18-34; Noah combines, Plan text check: extract text, assess usability, summarize goals for 34 plans, Kent decision Nov 6: category = each agency own goal label, no shared taxonomy, Plan text extraction: 34 plans, 158 goal rows, tests 56 of 56 pass

### Community 19 - "Community 19"
Cohesion: 0.25
Nodes (8): Sat schedule: 1:00 gate working ranking, test-breaker, slide brief by 5:00, code freeze 7-8, Project agents hostile-judge, data-critic, test-breaker plus persona commands, Testing: pass/fail first, unit/integration/UAT, failed test is evidence, During: build filter-score-rank-explain, gate 1 pm, find one real failure, Before Nov 5: teammate AI setup, reviewers, slide AI prompt trial, Publish prep: remove internal files, rewrite README for judges, make repo public, Code freeze Sat 7-8 pm wrap up, Repo layout (docs, app, src, data, outs, planning, testing, tasks, deliverables)

### Community 20 - "Community 20"
Cohesion: 0.32
Nodes (8): Federal Register notices cache, Grants.gov API search2/fetchOpportunity cache, data/raw intake log (never modify, no participant data), SAM.gov listings and transportation.gov not pulled, Simpler.Grants.gov API (1,471 records, key needed), USAspending NC awards (10,000 awards FY2022-26), Resources: Grants.gov/SAM.gov API, OSBM strategic plans, Azure guide, template, submission form, Data ingestion done: opportunities.csv 6,523 rows from Grants.gov, Simpler, Federal Register, USAspending

### Community 21 - "Community 21"
Cohesion: 0.25
Nodes (7): Checks: numbers match fact_sheet, speaking time 6 min, slide 1 states recommendation, Slide constraints: 6 min + 2 Q&A, 6-8 slides, numbers only from fact_sheet.md, write NEEDED if missing, Five-part structure: ask, why, how, limits, next step, Slide brief handoff to teammate AI agent (C), Talk plan: user 1:00, solution/demo 1:30, evidence 1:15, pilot 1:00, roadmap 0:45, buffer 0:30, Five-part pitch: ask, why, how, limits, next step, 6 min talk with demo plus 2 min Q&A, Sun 10:00-12:30

### Community 22 - "Community 22"
Cohesion: 0.29
Nodes (5): 60-second quick start (remove secrets, run skill, check assumptions), additional-tools zip (two diagram skills and samples), Azure Access Guide docx, Organizer Starter Kit docx, Presentation template pptx (13 slides, 6 min)

### Community 23 - "Community 23"
Cohesion: 0.29
Nodes (4): Vault note copies index (vault is source), Turn good into measurable criteria (relevant, can apply, enough time, worth the effort), Open items: Devpost question, Deloitte case competition in January, Worth it: payoff vs work, small grants not worth state agency effort

### Community 24 - "Community 24"
Cohesion: 0.47
Nodes (5): outs/figures PNGs, export_figure(), FIG_COLORS, plot_ranking(), theme_finals()

### Community 25 - "Community 25"
Cohesion: 0.33
Nodes (4): Method: Discover, Build, Test, Present (Deloitte), Skills not for this project (bio, paper writing, vault), Skills by phase: Discover, Build, Test, Present, Four phases: Discover, Build, Test, Present

### Community 26 - "Community 26"
Cohesion: 0.40
Nodes (4): Toy example data (fake, delete before submitting), Stack: R 4.5 + Quarto, criteria.csv is the method, Filter, score, rank, explain; reproducible top 10, R pipeline skeleton (filter, score, rank, explain)

### Community 28 - "Community 28"
Cohesion: 0.50
Nodes (3): AppKit, Foundation, Vision

### Community 29 - "Community 29"
Cohesion: 0.67
Nodes (3): Grants.gov XML extract (83,693 records, no key), Data setup notes: status derived, 70 posted items close after 2030, SAM/USDOT not pulled, keys in api_keys.env, How grants work today: Grants.gov main, plus SAM.gov, agency sites, mailing lists; no grant explorer role

### Community 30 - "Community 30"
Cohesion: 0.67
Nodes (3): Bonus quests: Measure Your Reach, Race the Clock, Learn From the Users, Design idea: users rank sample grants blind to calibrate weights; bonus order deadline alerts, feedback, coverage, Time is key: quick, easy, no extra questions for users

## Ambiguous Edges - Review These
- `Must run on Azure` → `Privacy: public data only; notes say local model, conflicts with Azure rule`  [AMBIGUOUS]
  notes/vault/Solveathon_DiscoverySession.md · relation: conceptually_related_to
- `helpers_llm.R` → `score.R`  [AMBIGUOUS]
  src/R/helpers_llm.R · relation: conceptually_related_to

## Knowledge Gaps
- **140 isolated node(s):** `Foundation`, `Vision`, `AppKit`, `Decision: which federal opportunities to pursue in time (pending discovery)`, `Deliverables: pitch, Solution Design and GenAI Field Notes, repository README` (+135 more)
  These have ≤1 connection - possible missing edges or undocumented components. (Counts symbols only; 191 node(s) total have ≤1 connection when file, concept and rationale nodes are included.)
- **3 thin communities (<3 nodes) omitted from report** — run `graphify query` to explore isolated nodes.

## Suggested Questions
_Questions this graph is uniquely positioned to answer:_

- **Why does `Organizer AI diagram skills (architecture-security, stakeholder-map)` connect `Community 6` to `Community 22`?**
  _High betweenness centrality (0.014) - this node is a cross-community bridge._
- **Are the 3 inferred relationships involving `persona_director roleplay` (e.g. with `Supervisor / decision maker (blank, to fill)` and `Observer role: finds failures, no praise; table + 3 worst answers + next step yes/no`) actually correct?**
  _`persona_director roleplay` has 3 INFERRED edges - model-reasoned connections that need verification._
- **What connects `Foundation`, `Vision`, `AppKit` to the rest of the system?**
  _140 weakly-connected nodes found - possible documentation gaps or missing edges._
- **Should `Community 0` be split into smaller, more focused modules?**
  _Cohesion score 0.05858585858585859 - nodes in this community are weakly interconnected._
- **Why does `Who was in the room: NCDNCR grants lead, DPI, NCDIT Office of AI, OSBM, mentors` connect `Community 6` to `Community 16`?**
  _High betweenness centrality (0.011) - this node is a cross-community bridge._

### Low-confidence Hints
_AMBIGUOUS edges — the extractor was unsure. Verify before acting on these._

- **What is the exact relationship between `Must run on Azure` and `Privacy: public data only; notes say local model, conflicts with Azure rule`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._
- **What is the exact relationship between `helpers_llm.R` and `score.R`?**
  _Edge tagged AMBIGUOUS (relation: conceptually_related_to) - confidence is low._