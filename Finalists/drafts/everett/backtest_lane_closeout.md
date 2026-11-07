# Backtest lane closeout (E7 draft, Everett's Claude, for Kent)

Status: draft, unverified by a human. Kent adds numbers to `fact_sheet.md`; Everett does not. Counts below are read from the files named beside them.

## 1. Audit Clearinghouse (FAC)
- Verdict: "not available" as a second awards-by-agency source. The header of `src/R/21_audit_clearinghouse.R` says FAC holds audit packages, not NC awards by state agency, and its federal_awards CSV has no DPI/DEQ/DHHS field.
- Kent decision, same header: do not bulk-download. Keep USAspending (`nc_awards_by_cfda.csv`) as the only awards source. The script writes `outs/audit_clearinghouse_check.csv` with result "not available".

## 2. Award map: rows that are not `confirmed`
Source: `data/manual/agency_award_map.csv` (35 data rows; 28 confirmed, 7 not; corrected by Everett's Claude after a recount). Award counts from `data/processed/nc_awards_recipients.csv` where the file shows them.

| Agency | Recipient | Certainty | Note |
|---|---|---|---|
| none (possible DHHS division) | DHHS STATE PUBLIC HEALTH LAB | uncertain | 2 awards per map note; not in `nc_awards_by_cfda.csv`; excluded from won set |
| none (local district) | DURHAM PUBLIC SCHOOLS | excluded | Local school district, not the DPI state agency; listed so DPI is not over counted |
| none (DIT) | DEPARTMENT OF INFORMATION TECHNOLOGY | uncertain | Name has no NC marker; 6 awards in recipients file; excluded |
| none (Adult Correction) | DEPARTMENT OF ADULT CORRECTION | uncertain | Name has no NC marker; 2 awards in recipients file; excluded |
| none (DMVA?) | VETERANS AFFAIRS, NORTH CAROLINA DIVISION OF | uncertain | Whether it belongs to the DMVA plan is not checked; excluded |
| none (inside Commerce?) | DIVISION OF EMPLOYMENT SECURITY | uncertain | Said to sit inside Commerce; not verified by Noah [not checked]; excluded |
| none (inside NCDOT?) | MOTOR VEHICLES, NORTH CAROLINA DIVISION OF | uncertain | Said to sit inside NCDOT; not verified by Noah [not checked]; excluded |

Confirmed rows that still carry an open flag in their note [unverified]:
- DNCR older names (`STATE OF NORTH CAROLINA DEPARTMENT OF CULTURAL RESOURCES`; `CULTURAL RESOURCES, NORTH CAROLINA DEPARTMENT OF`): mapped to `dncr`, naming history "Kent to confirm". Noah found NCpedia says the rename was 2015 (`drafts/claude/docs/award_map_check.md`), still [uncertain] until Kent confirms. Kent's answer in `comms/to-noah.md`: stay mapped, open check. Whether those awards belong to units the DNCR plan covers is [not checked].
- `DEPARTMENT OF COMMERCE NORTH CAROLINA`: "Claude assigned from the name, Kent to confirm."

Agencies known to be unmapped (no row in the map):
| Group | Recipients in `nc_awards_recipients.csv` | Awards | Kent's answer (`comms/to-noah.md`) |
|---|---|---|---|
| UNC campuses (UNC System is one of the 32 ranked agencies, zero award history) | NC State University 14; NC A&T State University 4; NC Central University 2 (Noah's N12 count: 3 campuses, 20 awards) | 20 | Stay unmapped; campuses apply for themselves |
| Commission on Volunteerism | NC COMMISSION ON VOLUNTEERISM & COMMUNITY SERVICE | 19 | Stay unmapped for now |
| DIT | in map as uncertain (row above) | 6 | not answered separately [unverified] |
| Adult Correction | in map as uncertain (row above) | 2 | not answered separately [unverified] |

Also in the recipients file as `unclassified`, not counted by Noah: Fayetteville State 7, Elizabeth City State 3, Winston-Salem State 1, Appalachian State 2 awards. Whether they are in scope for the UNC System row is [unverified].

## 3. Limits paragraph for the fact sheet (paste-ready)
Limits of the award-history backtest. The test asks whether the tool would have flagged, in an agency's Top 10, programs that agency has won money from. It cannot show that the tool finds good new opportunities, because it only counts programs an agency has already won, and that favors repeat funding. The award data has no link to a notice, so we match at program level, not notice level. Each agency has few won programs (the original bar covered 3, 7 and 11; the exploratory version covers 157 across 12 agencies), so the intervals are wide. Awards were tied to agencies by recipient name, assigned by Claude and not all confirmed, and some agencies are not mapped at all: UNC campuses apply for themselves, so the UNC System has no award history here. The original test failed its pre-set bar (fact sheet row 15: 1 of 3 agencies at or above 50%; DPI 2 of 3, DEQ 3 of 7, DHHS 4 of 11), and a soonest-deadline sort did at least as well in all three (row 16). The second version (rows 26 to 29) was built after we saw the first result, so it is exploratory and does not rescue the bar: it would have flagged 57 of 157 won programs in the Top 10 (36%), 95 of 157 in the Top 50 (61%), against 17% for a deadline sort and 13% for a random 10, with 4 of 12 agencies at or above 50% (row 28). The number of agencies mapped by exact name is 18, 12 with 3 or more won programs (row 26).

## Gaps
- No `backtest_result.csv` or figure was opened; numbers come only from fact sheet rows 15, 16, 26 to 29 and the other files named above.
- DIT and Adult Correction: Kent has not answered them separately in `comms/to-noah.md` [unverified].
- Employment Security and Motor Vehicles "inside Commerce / NCDOT" is unchecked.
