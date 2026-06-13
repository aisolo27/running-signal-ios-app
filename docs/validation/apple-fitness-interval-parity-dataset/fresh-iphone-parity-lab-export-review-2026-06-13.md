# Fresh iPhone Parity Lab Export Review

Generated: 2026-06-13

Status: docs/debug validation evidence only. This does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency status, or Phase 3 implementation.

## Source Files

User-supplied latest-debug-build exports in `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/txt files/`:

| File | Type | Workout / Scope |
| --- | --- | --- |
| `text-A284927A230E-1.txt` | selected-workout parity JSON | `2026-05-01T12:07:44Z` |
| `text-539D0FFB16E8-1.txt` | selected-workout parity JSON | `2026-04-22T11:39:58Z` |
| `text-D80864BB3CB0-1.txt` | selected-workout parity JSON | `2026-06-05T11:53:53Z` |
| `text-58FAB9E98BB8-1.txt` | selected-workout parity JSON | `2026-06-10T11:27:51Z` |
| `text-348ADD51C34E-1.txt` | selected-workout parity JSON | `2026-05-29T11:49:28Z` |
| `text-E1B64CE78D1D-1.txt` | monthly diagnostics JSON | May 2026, 26 fresh-query records |

Additional raw HealthKit debug markdown exports were present for the same selected-workout evidence batch. The selected parity JSON packets were used as the primary source because they directly expose `customWorkoutCandidateRuleSummary` and `customWorkoutCandidateRuleRows`.

## Selected Packet Result

| Start | Scorecard class | Rows Apple/Candidate | Open tail | Paired pause | Max active dt | Max distance delta | Result |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `2026-04-22T11:39:58Z` | paused_repeat_block | 12/12 | 0 | `178.1 s` | `0.64 s` | `8.14 m` | matches |
| `2026-05-01T12:07:44Z` | fixed_cooldown_open_tail | 5/5 | 1 | `232.8 s` | `0.48 s` | `9.06 m` | matches |
| `2026-05-29T11:49:28Z` | paused_warmup_work_open_cooldown | 3/3 | 0 | `159.0 s` | `0.15 s` | `9.09 m` | matches |
| `2026-06-05T11:53:53Z` | fixed_cooldown_open_tail | 4/4 | 1 | `0.0 s` | `0.45 s` | `6.57 m` | matches |
| `2026-06-10T11:27:51Z` | repeat_block_fixed_cooldown_open_tail | 11/11 | 1 | `0.0 s` | `0.90 s` | `8.92 m` | matches |

No selected packet had a row-count mismatch, label mismatch, unexpected production flag, or missing scorer output.

## May Monthly Cross-Check

The May monthly diagnostics JSON reports 26 records, 26 fresh queries, zero failed records, zero missing-evidence records, and scorer rows for all May records. Against May screenshot-confirmed fixtures:

| Start | Scorecard class | Rows Apple/Candidate | Open tail | Paired pause | Max active dt | Max distance delta | Result |
| --- | --- | ---: | ---: | ---: | ---: | ---: | --- |
| `2026-05-01T12:07:44Z` | fixed_cooldown_open_tail | 5/5 | 1 | `232.8 s` | `0.48 s` | `9.06 m` | matches |
| `2026-05-06T12:02:13Z` | paused_repeat_block | 14/14 | 0 | `126.4 s` | `0.92 s` | `8.11 m` | matches |
| `2026-05-13T11:52:06Z` | paused_repeat_block | 18/18 | 0 | `52.6 s` | `0.76 s` | `11.20 m` | matches |
| `2026-05-20T11:43:00Z` | clean_repeat_block | 10/10 | 0 | `0.0 s` | `0.95 s` | `8.73 m` | matches |
| `2026-05-29T11:49:28Z` | paused_warmup_work_open_cooldown | 3/3 | 0 | `159.0 s` | `0.15 s` | `9.09 m` | matches |

## May 1 Focus

The fresh selected parity packet preserves the prior May 1 findings:

- Overview duration remains `2948.6 s`; elapsed remains `3181.4 s`; elapsed minus duration remains `232.8 s`.
- The scorer reports two paired pauses totaling `232.8 s`.
- Work row elapsed is `1445.4 s`, pause overlap is `141.0 s`, and active duration is `1304.4 s`, matching Apple Fitness `21:44`.
- Cooldown row elapsed is `834.0 s`, pause overlap is `91.8 s`, and active duration is `742.2 s`, matching Apple Fitness `12:22`.
- The inferred `Open / Extra` row is `16.6 m / 9.9 s`, matching Apple Fitness `Open 16 m / 0:10` within display rounding.

## Findings

- The fresh iPhone exports reinforce the current docs/debug scorecard rather than changing it.
- `customWorkoutCandidateRuleRows` correctly keep elapsed duration, pause overlap, and active duration separate for paused rows.
- `Open / Extra` appears only after fixed planned steps are exhausted in the selected Open-tail fixtures.
- Repeat-block rows expand with stable Work/Recovery labels and row counts in the selected Apr 22 and May monthly repeat fixtures.
- The scorer export flags remain debug-only: `boundaryLogicChanged=false`, `productionIntervalBehaviorChanged=false`, `normalWorkoutUIChanged=false`, `usesFITRuntimeTruth=false`, and `usesAppleFitnessManualRuntimeLogic=false`.

## Decision

The new iPhone evidence supports the existing docs/debug candidate reconstruction rule scorecard. It does not approve production interval reconstruction, normal workout detail UI changes, or any Phase 3 prototype.
