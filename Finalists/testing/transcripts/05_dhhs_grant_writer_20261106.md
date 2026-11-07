# DHHS grant writer review (persona, one-shot)
Read: Finalists/testing/context.md, QualifierChallenge/outs/top_results.csv (57 rows), src/tool/tiering.js, handoff, presentation_brief weakness list, Finalists planning/08 decision 13. I did not open the underlying notices; judgments below are from titles, tier rules and what I know of these programs. Verify against the notices.

## Findings, ranked
1. Tier 1 is the default bucket and it is polluted. tiering.js falls to T1_clear when no rule fires; with no capability detected the text says "no special capabilities detected (unverified)", yet the list says "writer can act". 27 of 57 rows are Tier 1. The team admits tiers 1-3 were never hand spot-checked (presentation_brief.md ~line 191).
2. Obvious wrong matches in DHHS Tier 1 / 2:
   - HRSA-27-006/007/008 Service Area Competition (ranks 2, 3, 5, $19-22M): SAC funds community health centers (FQHCs), not a state health department. The tool says "state agency can apply" because state governments are on the applicant list. Three of the top five are this.
   - Rural Residency Planning (HRSA-27-046), Rural Health Network Development (-051), Radiation Exposure Screening (-039), Regional Nutrition Hubs, Telehealth Nutrition: rural-provider, nonprofit or university programs; DHHS is not a likely applicant. Tier 1 "writer can act" is wrong.
   - Tier 2: DHS-26-MT-144 Flood Mitigation Assistance (FEMA, emergency management agency, not DHHS), VA GPD forecast (a VA housing grant for nonprofits, listed under both DHHS and DMVA).
   - NIOSH/CDC research centers (U19, T03, Construction Safety research) in Tier 2 while a "research -> Tier 4" rule exists: the Tier 4 flag is not catching center-of-excellence awards.
   - Stale ID FOR-FD-23-014 (FY23 number) in Tier 1.
3. Misses the reverse way: the real DHHS formula/steady money (Ryan White Part B, ADAP, MIECHV, Title X, PDG B-5) is correctly surfaced, but MIECHV and Title X are Tier 3 because of a "$1M appropriation line" that the team admits is invented. Title X cost share is unclear; PDG B-5 "formal designation" rule fired. A writer cannot tell which Tier 3 is real. Continuations (recurring awards NC already holds) look the same as new competitions; no "we already receive this" signal.
4. Forecasts dominate. Most listed rows are forecasts with an estimated "deadline" (e.g. 2026-12-30). The notice is not out, so eligibility, match and staffing are guesses from last year's notice. List labels them but sorts them as if actionable.
5. Staff burden is a lookup by instrument type (0.25/0.5 FTE) not read from the notice. Ceiling used as "estimated award" ($22M) inflates impact scores. 723 of 1,472 open items lack ceilings (Finalists context).
6. Rationales are templated strings, not quoted from notice or the DHHS plan. No plan quote. DHHS plan is OCR and 2023-25; Finalists says so, the qualifier says "newer plans exist" but the tool does not flag it per row.
7. Duplicate/overlapping items (three SAC, two Infant-Toddler Court, two Rural Communities Opioid Response, VA GPD in two agencies) crowd the top.
8. Finalists reuse: planned, not built (decision 13). The fix "unknown never defaults to Tier 1" is correct and should be applied; the Finalists plan is better than the qualifier here. Risk: signature tier is a different problem (OSBM wants cross-agency matching), and "fields-only" tier will repeat finding 1 unless the unknown state ships.
9. Eligibility logic is the root: `state_eligible` just checks the "State governments" token. Needs the NOFO's own eligibility text; also the "audience" tag appears keyword-based.

## Clarifying questions
1. What exactly does "state_eligible" test, and how many of the 27 Tier 1 rows list only "state governments" generically while the NOFO text limits applicants to health centers, hospitals or universities?
2. Why do SAC awards pass the audience filter for DHHS, and what was checked about them in the 60 blind labels?
3. Is the $1M appropriation line used anywhere in the Finalists version, and who in NC would set it?
4. Can the tool show a "DHHS already receives this" flag from USAspending awards so continuations separate from new competitions?
5. For forecasts, will Finalists show an "estimated, notice not out" badge and exclude them from the in-time recall count?
