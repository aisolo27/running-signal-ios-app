# Physical iPhone Interval Timing Semantics Proof

Captured: 2026-06-23
Device: physical iPhone `AIS17PM`
Installed app baseline: interval-timing semantics build from commit `e0592ec`

## Scope

This proof set validates the interval timing semantics foundation for paused repeat-block workouts:

- elapsed row-window duration is preserved from HealthKit activity windows
- paired pause overlap is reported separately
- active/timer duration subtracts paired pause overlap
- comparison output remains debug/export-only
- normal workout detail remains unpromoted for paused repeat blocks
- FIT remains offline validation evidence only, not runtime truth

This proof does not approve paused repeat-block normal-detail promotion.

## Raw Exports

| Workout date | Raw HealthKit debug export | Parity packet |
|---|---|---|
| 2026-04-22 | `raw-exports/2026-04-22-raw-healthkit-debug.txt` | `raw-exports/2026-04-22-parity-packet.txt` |
| 2026-04-29 | `raw-exports/2026-04-29-raw-healthkit-debug.txt` | `raw-exports/2026-04-29-parity-packet.txt` |
| 2026-05-06 | `raw-exports/2026-05-06-raw-healthkit-debug.txt` | `raw-exports/2026-05-06-parity-packet.txt` |
| 2026-05-13 | `raw-exports/2026-05-13-raw-healthkit-debug.txt` | `raw-exports/2026-05-13-parity-packet.txt` |
| 2026-05-27 | `raw-exports/2026-05-27-raw-healthkit-debug.txt` | `raw-exports/2026-05-27-parity-packet.txt` |

## Structured Comparison Summary

All five parity packets report:

- `customWorkoutComparisonSummary.status == supported`
- `fallbackReasons == []`
- `scope == debug/export-only`
- `promotesProductionBehavior == false`
- `normalWorkoutUIChanged == false`
- `productionIntervalBehaviorChanged == false`
- `usesFITRuntimeTruth == false`
- `customWorkoutCandidateRuleSummary.ruleStatus == candidate-rule-scoreable`
- `tailAmbiguity == plannedOpenCooldownContinuesToWorkoutEnd`

| Workout date | Workout ID | Rows | Paired pauses | Total paired pause | Status |
|---|---|---:|---:|---:|---|
| 2026-04-22 | `0335DE40-44C5-48AC-9A05-F32314713DE1` | 12 | 2 | 178.1 s | supported |
| 2026-04-29 | `9DF73D06-448A-4384-A27C-E3B34B2CD592` | 12 | 2 | 173.0 s | supported |
| 2026-05-06 | `2941455F-F0BE-444B-80FB-2054CA20D8B4` | 14 | 2 | 126.4 s | supported |
| 2026-05-13 | `75C27BC6-E833-4BC4-B5A1-1DEDB1F0BC37` | 18 | 1 | 52.6 s | supported |
| 2026-05-27 | `B0DB0318-7B7F-4F4F-B583-7684D660FC29` | 22 | 1 | 60.8 s | supported |

## Rows With Pause Overlap

| Workout date | Row | Label | Elapsed | Pause overlap | Active/timer | Distance |
|---|---:|---|---:|---:|---:|---:|
| 2026-04-22 | 7 | Recovery 3 | 219.7 s | 99.8 s | 119.9 s | 172.6 m |
| 2026-04-22 | 9 | Recovery 4 | 198.1 s | 78.3 s | 119.8 s | 163.6 m |
| 2026-04-29 | 7 | Recovery 3 | 182.0 s | 62.9 s | 119.1 s | 157.6 m |
| 2026-04-29 | 9 | Recovery 4 | 229.1 s | 110.1 s | 119.0 s | 170.9 m |
| 2026-05-06 | 1 | Warmup | 900.9 s | 126.4 s | 774.5 s | 2007.8 m |
| 2026-05-13 | 15 | Recovery 7 | 172.0 s | 52.6 s | 119.4 s | 162.4 m |
| 2026-05-27 | 17 | Recovery 8 | 150.0 s | 60.8 s | 89.2 s | 93.8 m |

## Implementation Note

These exports already prove the candidate scorer and structured comparison carry elapsed, pause-overlap, and active/timer values from the installed interval-timing semantics build. A follow-up code change in this validation pass also adds the same timing semantics fields to the `reconstructedIntervals` JSON payload for future raw debug/parity exports.

## Remaining Blockers

Paused repeat blocks remain blocked from normal workout detail until a separate promotion decision and proof pass explicitly approve:

- normal-detail row display policy for active/timer duration
- continued blocked behavior for unpaired pauses and missing activity rows
- no regression in the six currently approved narrow gates
- no promotion of recovery-containing tails or ambiguous repeat-tail cases
