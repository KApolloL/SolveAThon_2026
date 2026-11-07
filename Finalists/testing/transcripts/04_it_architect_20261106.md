# IT Office of AI architect review (one-shot)
No secret values read or repeated. Repo files not modified.

## Findings, ranked
1. **Key file committed.** Finalists/api_keys.env is tracked (commit 78d3d2b), holding SIMPLER_GRANTS_KEY and SAM_API_KEY. The team chose this knowingly (private repo), but it stays in git history forever, and judges/state staff are going to be given repo access. Rotate both keys before access is shared; move to Key Vault / Container Apps secrets. Also the .gitignore/.dockerignore protections are good (*.env excluded from image; stage_proof_assets.sh value-scans app/).
2. **Public, unauthenticated app.** Container App ingress is external with no auth (no Entra ID/easy-auth, no IP limit, no rate limit). Today it serves public Grants.gov data, so impact is low. But the planned POST /feedback endpoint is unspecified: who reads it, what it stores, retention, abuse/spam, rate limits. Not designed anywhere.
3. **Azure OpenAI not created; training/data-retention claim unverified.** azure_setup.md correctly marks it [uncertain]. Nothing in the product yet sends data to a model, so no privacy evidence exists. "We think so" is not acceptable; cite Microsoft's data/privacy page and the abuse-monitoring/opt-out status for the subscription.
4. **Cost: $500 is an alert, not a cap.** Budget alerts only, no emails configured on ffm-guard, no action group, no automated stop. Spend figures are estimates at list price. Cold start 38 s measured; recommended min replicas 1 adds roughly $40/month (0.5 vCPU, 1 GiB always on, my estimate). Pilot-scale monthly cost (app + ACR Basic + Log Analytics + embeddings + chat) is not computed.
5. **Daily refresh job does not exist.** MODE=job is a stub that prints a line. Nothing handles Grants.gov API change, failed run, partial data, alerting, retry, or where output lands. Blob container exists but app reads a CSV baked into the image (stale until rebuild). No runtime data flow.
6. **Reproducibility/handover.** README is still the team-process README and says the app is a "hello page"; the "How to rebuild" in handoff.md is empty; the pipeline is R 4.5 + Quarto + macOS-only Vision OCR + V8 + local Ollama, and the app stages a file from QualifierChallenge/outs (a generated, gitignored-style output) via a script. A state developer could not rebuild end to end. rocker/shiny:4.4.2 and unpinned CRAN installs (no renv lockfile) mean non-reproducible images. Shiny/R: my team can support Container Apps containers, but R Shiny is a niche skill; JS tool is easier. Say who maintains it.
7. **Data handling.** Public data only (good, say so). Also large data/cache committed to git. Image includes a 3.6 MB tool.html; plan PDFs, OCR text, nothing sensitive noted. No retention or logging policy; Log Analytics ingestion cost/privacy not set.
8. **Explainability.** The design (LLM labels only with checked quotes, humans decide) is the right story for AI-in-government questions, but none of it is built yet; fact_sheet.md is empty; the only live search is noisy keyword matching (school bus test).
9. **Supply chain/ops.** Single replica, single region, no health probe, no CI, no tests in deploy path, no managed-identity Blob role yet, no tagging/IaC (commands only in markdown, no Bicep/Terraform).

## Credit
Honest about limits: unverified items flagged, no admin password on ACR, system-assigned identity pull, scale-to-zero, cost ledger, rollback list.

## Five clarifying questions
1. After the weekend, who owns this (OSBM has no team): which agency or IT group hosts and pays?
2. Will you rotate the two API keys and remove api_keys.env from history, and where will secrets live in production?
3. What exact data will go to Azure OpenAI, and have you read Microsoft's no-training/abuse-monitoring terms for this subscription?
4. What does the feedback endpoint store, who can read it, and how is it protected from abuse?
5. What is the estimated monthly cost at pilot scale (users, runs, tokens), and what actually stops spend at $500?
