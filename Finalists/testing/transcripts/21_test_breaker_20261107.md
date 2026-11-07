# Test breaker, Sat Nov 7 2026 (main 95fed84, after R/10_run_ranking.R)

Not run by me: `Rscript tests/run_tests.R` (manager's override). Manager's result at 10:35 am: "78 of 79 tests pass"; the one failure is hard-coded FALSE at `src/tests/run_tests.R:108` (agreement test pending). I read `payload.json` and `items.csv` read-only and probed `score.R` / `helpers_rank.R` with in-memory `Rscript -e` style snippets (nothing written to data/ or outs/). Expected results below come from criteria.csv, the draft cases and the brief, not from the output. `testing/context.md` is Fri-night stale (it says criteria.csv "does not exist"); I used the files. Nothing here is approved by Kent.

Existing cases c1-c5 and the draft ids KG1, KB1-KB4, DQ1-DQ7 are not repeated. Draft check on current payload (control, all pass): KG1 DERA 363936 is deq rank 1 and dpi rank 3, shown as "ask"; KB4 (358230) is not flagged for deq/dpi/dhhs; KB1/KB3 reach the dhhs hidden rows; the hard-coded "unknown tier" holds.

## 1. Test cases (paste-ready)

Ids are `agency_id:opp_id`, as in items.csv. `run_tests.R` only knows five types, and an unknown type scores FALSE, so the new types below fail loudly until built. Proposed new types: `not_in_top_n` (agency-scoped rank <= n, among posted+notice, as in payload), `payload_check` (the `expected` column holds the rule), `read_any_check`.

```csv
case_id,type,item_id,other_id,n,filter_id,criterion_id,expected,description
tb01,not_in_top_n,oah:fr:2026-02955,,10,,,TRUE,HUD 60-day information-collection notice has fit 1.0 and is oah rank 1; Federal Register notices the UI never shows must not fill Top 10 slots
tb02,not_in_top_n,oah:fr:2026-08400,,10,,,TRUE,Second HUD information-collection notice is oah rank 2
tb03,not_in_top_n,deq:fr:2026-07762,,10,,,TRUE,Proposed Data Collection notice sits at deq rank 9
tb04,not_in_top_n,dpi:334326,,10,,,TRUE,Tribal Colleges and Universities Program (TCUP) is dpi rank 1 and shows as ask; a tribal-college program is not open to a state education agency
tb05,not_in_top_n,ids:364036,,10,,,TRUE,BJA FY2026 Tribal Civil and Criminal Legal Assistance is ids rank 1 (also doj 6 and sbi 3)
tb06,not_in_top_n,doa:364222,,10,,,TRUE,OVW Grants to Tribal Domestic Violence programs is doa rank 2
tb07,dropped_by,dpi:334326,,,eligible,,,Same TCUP item should be hidden as clearly ineligible (needs Kent's rule for tribal-college programs coded 25)
tb08,not_in_top_n,osa:325599,,10,,,TRUE,AFPRA-20-04 US Embassy Praia (Cape Verde) $10000 self-help program is osa rank 1; posted in 2020 with no close date
tb09,not_in_top_n,osa:112354,,10,,,TRUE,PD-11-8031 posted 2011-08-08 with no close date is osa rank 9
tb10,not_in_top_n,dor:300997,,10,,,TRUE,NNH18ZHA002N-MUSIC posted 2018 with no close date is in dor Top 10
tb11,not_in_top_n,deq:332052,,10,,,TRUE,EDA Atlanta FY2021-FY2023 planning grant posted 2021-03-15 with no close date is deq rank 5
tb12,not_in_top_n,doj:363725,,10,,,TRUE,Closes 2026-11-06 which is before data_as_of 2026-11-07; a closed item must not be flagged (10 Top 10 rows share this date)
tb13,not_in_ranking,oshr:363546,,,,,TRUE,HRSA-27-072 closed 2026-09-20 (47 days before REF_DATE) yet is posted and ranked 66 for oshr; an expired posted item needs a deadline filter
tb14,not_in_ranking,deq:328026,,,,,TRUE,SFOP0007154 has fit 0 and still passes every filter; 24741 of 47402 ranked pairs have total 0 (no fit floor)
tb15,not_in_ranking,dpi:362349,,,,,TRUE,CDC STI health-department item has fit 0 for dpi and is still ranked
tb16,points_equal,deq:364083,,,,fit,0.28371534102883,Title carries Hawai&#699;i; decoded it names another state so fit 0.5674306820576593 should be halved (GEO_PENALTY 0.5)
tb17,points_equal,deq:364183,,,,fit,0.3014228,Great Basin CESU partner agreement is a western region; fit 0.6028456 should be halved (Great Basin is not in GEO_OTHER_PLACES; Kent to confirm the region rule)
tb18,points_equal,deq:363160,,,,award_size,NA,HRSA-27-063 lists a ceiling of 0 which is a placeholder; award points must be unknown not 0
tb19,points_equal,dpi:328026,,,,runway,NA,SFOP0007154 closes 2099-01-01 so the date reads rolling or no date listed and runway is unknown
tb20,points_equal,deq:362576,,,,runway,1,Exactly 60 days left is the top of the 7 to 60 scale and scores full runway
tb21,points_equal,deq:361997,,,,runway,0.981132075471698,59 days left scores 52 over 53 on the 7 to 60 scale
tb22,points_equal,oah:fr:2026-02955,,,,no_cost_share,NA,Notice rows have blank cost sharing; points unknown not 0 (decision 9)
tb23,ranks_above,oah:fr:2026-02955,oah:fr:2026-08400,,,,TRUE,Tie at fit 1.0 and total 100 is broken by id order (deterministic) so a rerun does not flip them
tb24,ranks_above,dpi:363936,dpi:358230,,,,TRUE,Mapped DERA school-bus program must sit above the unrelated NIH drug-discovery PAR-25-353 for dpi
tb25,payload_check,dpi,,,,,agencies[dpi].n_hidden_ineligible == count of rows with eligibility no,Payload says 98 hidden for dpi but carries 10 rows; all 32 agencies differ (toggle count must match what the toggle shows)
tb26,payload_check,osa,,,,,agencies[osa].plan_thin is not null,plan_thin is null for all 32 agencies; osa also has a stale plan so its thinness is the likely warning
tb27,payload_check,osa,,,,,agencies[osa].plan_stale == TRUE,Control that passes today: the four stale-plan agencies are osa ncsbe wrc commerce
tb28,payload_check,,,,,,no row title or opp_snippet contains &# or &amp;,14 Top 10 titles and 25 Top 10 snippets still carry entity codes (osa:325599 and deq:332052 among them)
tb29,payload_check,,,10,,,every agency has exactly 10 in_top10 rows and every one has a status of posted or notice,Control that passes today (32 of 32)
tb30,payload_check,,,,,,no in_top10 row has a status of notice,61 of 320 Top 10 rows are Federal Register notices
tb31,payload_check,,,,,,no in_top10 posted row lacks a close_date unless post_date is within 2 years,29 Top 10 posted rows have no date; post dates run from 2011 to 2022
tb32,read_any_check,deq:363936,,,,,map_note is character and non-null,read_any guesses map_note as logical and drops the DERA note (manager-reported; I did not reproduce it)
```

### Unit-level probes (no real item id; belong in run_tests.R section 2b)
```csv
case_id,type,item_id,other_id,n,filter_id,criterion_id,expected,description
u01,text_eligibility,,,,,,not no,"Eligible applicants are not limited to state governments." (actual: no)
u02,text_eligibility,,,,,,not no,"Notice to state agencies: apply by Dec 1." (actual: no, regex has no word boundary on not)
u03,text_eligibility,,,,,,not no,"Eligibility is notably open to state agencies." (actual: no)
u04,rule_eval,,,,,,c(NA TRUE) no error,date_gte_days on c("TBD" "2026-12-06") (actual: error, as.Date reads only the first element)
u05,geo_other,,,,,,FALSE,"Texas and N.C. pilot" (actual: TRUE)
u06,geo_other,,,,,,TRUE,"Washington State salmon recovery" (actual: FALSE, Washington missing from the list)
u07,geo_other,,,,,,FALSE,"Georgia (country) democracy grant" (actual: TRUE)
u08,rank_items,,,,,,clear error naming zz,weights=c(zz=1) (actual: subscript out of bounds)
u09,rank_items,,,,,,clear error naming the criterion,weight NA on a score row (actual: missing value where TRUE/FALSE needed)
u10,rule_eval,,,,,,FALSE,neq "no" on "No" (actual: TRUE, rules are case-sensitive; data values are 'No'/'Yes')
u11,prep_opportunities,,,,,,2029-12-31 kept and 2030-01-01 unknown,Boundary of FAR_FUTURE_DATE (control, passes)
u12,prep_opportunities,,,,,,posted close_date before REF_DATE is not an ordinary open item,A posted close of 2026-09-20 gets days_left -47 and no date_note (actual)
```

Proposed test cases: 32 item-level (tb01 to tb32) plus 12 unit probes = 44 (the 32 are the ones meant for test_cases.csv).

## 2. Failures found

| # | What I did | Expected | Actual | How to reproduce | Triage |
|---|---|---|---|---|---|
| 1 | Counted in_top10 rows by status | Top 10 holds items a user can act on | 61 of 320 Top 10 rows (19%) are `notice`; oah ranks 1 and 2 are HUD "Proposed Information Collection" notices at fit 1.0; 8 each for commerce, oah, osc | python3 over payload.json rows, in_top10 and status == notice | solution (no notice rule, no fit floor) |
| 2 | Searched Top 10 titles for Tribal/Indian/Native | Tribal-only programs hidden for a state agency | 12 matches: TCUP dpi 1, ncccs 3, unc 6; BJA Tribal ids 1, sbi 3, doj 6; OVW Tribal doa 2; dol Native American job placement 5; Tribal IRB ncsbe 6; Tribal Broadband osbm 9; all code 25 so "ask" | same | solution, plus Kent decision on tribal phrases |
| 3 | Ran geo_other on the raw title | Penalty for a title naming another state | `Hawai&#699;i` is not matched, so deq:364083 keeps fit 0.567 (deq rank 10 is G27AS00073, same family). Also Great Basin and Washington not in the list; "N.C." gets penalised; Georgia the country gets penalised | Rscript snippet geo_other(...) | solution (decode entities in prep_opportunities) |
| 4 | Read the Top 10 posted rows without a close date | Dated, recent items | 29 posted rows have no close date; posted 2011 to 2022 (PD-11-8031 osa 9, NNH18ZHA002N-MUSIC dor, AFPRA-20-04 osa/dst/sos rank 1, EDA-ATL 2021 deq 5). Cape Verde embassy self-help program is rank 1 for osa | python3 on payload plus items.csv post_date | data and solution (no staleness filter; unknown date counts as fine) |
| 5 | Checked fit scale | A rank-1 item should mean a real match | fit is divided by each agency's best, so every agency has a 1.0 item. Max raw fit is below 0.05 for doi, dol, dor, oshr, yet their best item shows 1.0. 24741 of 47402 ranked pairs have total 0 and none are removed. Top 10 fit_score falls to 0.19 (dmva) | p2 snippet over items.csv | solution; this is the false-positive threat |
| 6 | Compared REF_DATE to data_as_of | Nothing closed shows as open | REF_DATE 2026-11-06 vs data_as_of 2026-11-07 11:00: 10 Top 10 rows close 2026-11-06 with days_left 0 (doj, ids, sbi, dst, osa, dac, dps). 32 posted items have negative days_left (HRSA-27-072, -47) and are still ranked | python3 days_left filter | solution (config date and no expired filter) |
| 7 | Compared n_hidden_ineligible with hidden rows | Count equals what the toggle reveals | dpi says 98, carries 10 rows; 32 of 32 agencies differ (HIDDEN_N 10). Count also mixes forecasted and posted | python3 over agencies and rows | solution or UI text must say "showing 10 of 98" |
| 8 | Read agencies[].plan_thin | A thin-plan warning where a plan is thin | null for all 32; only plan_stale works (4 true) | python3 Counter(plan_thin) | solution (not measured) |
| 9 | Replayed how run_tests.R ranks | Per-agency Top N | Section 3 ranks all 32 agencies together, so `in_top_n` means a global rank: dpi:334326 is 12th and deq:363936 is 90th though each is rank 1 or 3 in its agency; 29 items tie at total 100. `in_top_n` therefore cannot test the flag (10 per agency) | Rscript: rank_items on items.csv | solution (test harness) |
| 10 | Probed points_equal | A missing item fails | For an id that does not exist the value is NA and expected "NA" or blank passes (all.equal(NA, NA) is TRUE). Add a nonexistent id with expected NA and it passes | Rscript snippet | solution (test harness) |
| 11 | Probed text_eligibility | "not" as a word | The negation regex has no word boundaries: "Notice to state agencies" and "notably open to state agencies" read "no" (hidden). Latent: the 416 rule-decided rows today include only the 32 exact "not be considered" ones | Rscript | solution (latent) |
| 12 | Probed rule_eval | A bad date gives NA | `date_gte_days` errors when the first value is not a date ("TBD"). Latent: no date filter is in criteria.csv | Rscript | solution (latent) |
| 13 | Probed rank_items inputs | Plain-language errors | `weights=c(zz=1)` gives "subscript out of bounds"; NA weight gives "missing value where TRUE/FALSE needed". `neq no` is case-sensitive | Rscript | instructions or solution (low) |
| 14 | Section 5 of run_tests.R | Shape check on payload | Hard-coded FALSE at line 108; no test compares R and the tool on the real payload, and no test reads the Top 10 contents (5b only checks counts and statuses), which is why items 1 to 4 and 6 are all green | read run_tests.R | solution (the one red test hides the gap) |

Controls that passed: reruns identical order; 10 Top 10 rows for every agency; Top 10 never holds "no" eligibility or forecasts; unknown ceiling is null; unknown tier is "unknown"; stale flags on osa/ncsbe/wrc/commerce; blank applicant types read "ask"; DERA reaches deq and dpi as "ask", not hidden.

## 3. Three ways this ranking is most likely to mislead a user

1. Fit 1.0 and rank 1 read as "strong match", but fit is relative to each agency's best item. A thin or off-topic agency still gets a 1.0 on whatever scored highest (an embassy self-help program, a HUD paperwork notice).
2. "Posted" and "no date listed" read as live. Items posted in 2011 to 2022, and items that closed yesterday or last quarter, rank with the same weight as open ones, and the user sees an agency-ready list with no sign it is stale.
3. The "ask" badge reads as "maybe eligible", but 181 of 320 Top 10 rows are "ask" because code 25 and blank codes are never decided. Tribal-only and federal-reporting items hide inside that badge, and the hidden-count toggle shows 10 rows against a count of 98.

## 4. [cannot assess]

- Whether the tool (`criteria_tool.html`) applies the 14-day window, filters notices or decodes entities; I read only the payload. 157 Top 10 rows have more than 14 days left and 90 have no date, so the window is a UI job.
- Whether each Top 10 tribal item is really tribal-only; I judged by title and applicant code 25, not by reading each notice.
- The real eligibility text for the 416 rule-decided rows (items.csv drops `eligibility_text`), so how often the "not" substring bug fires on live data beyond the 32 known.
- Item-level recall, or whether the 70% bar holds; that is the backtest, not this table.
- I did not run `tests/run_tests.R`; the manager's 78 of 79 is the only run result, and my probes were separate snippets, not part of the harness.
- The `map_note` / `read_any` parse failure (tb32) is from the manager's list; I did not reproduce it.
- Whether Great Basin should count as another region (tb17): Kent's rule.
