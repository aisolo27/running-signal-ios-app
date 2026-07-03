# Physical iPhone Recovery Tail Normal Detail Promotion Proof - 2026-06-23

## Scope

Current-build physical-iPhone proof folder for the narrow May 1-style recovery-containing Open/Extra normal-detail gate.

Target workout:

- Date: May 1, 2026
- Apple Fitness name: `Friday Tempo 9km`
- Shape: `Warmup(2 km) > Recovery(120 s) > Work(5 km) > Cooldown(2 km) > inferred Open / Extra`

## Gate Under Proof

This proof is for the narrow normal-detail gate only:

- WorkoutKit planned rows are present.
- Planned rows are exactly `Warmup`, `Recovery`, `Work`, `Cooldown`.
- The final planned `Cooldown` is fixed time or distance, not open.
- HealthKit activity rows are complete, contiguous, distance-backed, and count-aligned with the fixed planned rows.
- Paired HealthKit pause/resume intervals are assignable to exact row windows.
- `Open / Extra` is inferred only after all fixed planned rows are exhausted.
- FIT remains offline validation evidence only and is not a runtime input.

## Archived Apple Fitness Screenshots

These were already present in the central screenshot archive and were copied here so this proof folder is self-contained:

- `apple-fitness-screenshots/2026-05-01-apple-fitness-summary.PNG`
- `apple-fitness-screenshots/2026-05-01-apple-fitness-intervals.PNG`

Screenshot-confirmed Apple Fitness rows:

| Row | Label | Distance | Time |
|---:|---|---:|---:|
| 1 | Warmup | 2.00 km | 12:52 |
| 2 | Recovery | 194 m | 02:00 |
| 3 | Work | 5.00 km | 21:44 |
| 4 | Cooldown | 1.99 km | 12:22 |
| 5 | Open | 16 m | 00:10 |

Apple Fitness summary shows:

- Workout Time: `0:49:08`
- Elapsed Time: `0:53:01`
- Distance: `9.22 km`

## Supporting Prior Debug Proof

The `supporting-debug-proof/` files are copied from `physical-iphone-recovery-tail-proof-2026-06-15/`.

They prove the earlier debug/export-only recovery-tail rule, not the current normal-detail promotion build:

- `supporting-debug-proof/2026-05-01-prior-debug-raw-healthkit-export.md`
- `supporting-debug-proof/2026-05-01-prior-debug-parity-packet.json`

Prior debug proof confirmed:

- `customWorkoutComparisonSummary.status == supported`
- `fallbackReasons == []`
- preserved `Recovery 1`
- inferred post-Cooldown `Open / Extra`
- paired pauses: `2`
- total paired pause: `232.8 s`
- Work pause overlap: `141.0 s`
- Cooldown pause overlap: `91.8 s`

## Current-Build RunSignal Proof

Current-build artifacts exported from the app installed on physical iPhone `AIS17PM` are archived:

- `raw-exports/2026-05-01-raw-healthkit-debug.txt`
- `raw-exports/2026-05-01-parity-packet.txt`

The Raw HealthKit Debug export was generated at `2026-06-23T20:01:19Z` from fresh evidence loaded at `2026-06-23T20:01:04Z`.

The archived parity packet validates the required shape:

- `customWorkoutComparisonSummary.status == supported`
- `fallbackReasons == []`
- `tailAmbiguity == fixedCooldownFollowedByPossibleOpenExtraTail`
- `candidateRowCount == 5`
- `openTailRowCount == 1`
- `pairedPauseCount == 2`
- `totalPairedPauseSeconds == 232.8 s`
- `usesFITRuntimeTruth == false`

Current-build candidate rows:

| Row | Label | Mapping | Distance | Elapsed | Pause overlap | Active |
|---:|---|---|---:|---:|---:|---:|
| 1 | Warmup | mappedByPlannedStepOrder | 2009.1 m | 772.5 s | 0.0 s | 772.5 s |
| 2 | Recovery 1 | mappedByPlannedStepOrder | 194.8 m | 119.5 s | 0.0 s | 119.5 s |
| 3 | Work 1 | mappedByPlannedStepOrder | 5005.7 m | 1445.4 s | 141.0 s | 1304.4 s |
| 4 | Cooldown | mappedByPlannedStepOrder | 1995.9 m | 834.0 s | 91.8 s | 742.2 s |
| 5 | Open / Extra | inferredOpenTailFromWorkoutEnd | 16.6 m | 9.9 s | 0.0 s | 9.9 s |

## Result

Pass.

The May 1-style recovery-containing Open/Extra normal-detail gate is physically proven for this narrow shape only.

Safety boundaries remain:

- `Recovery 1` is preserved and not treated as tail.
- `Open / Extra` is inferred only after fixed `Cooldown`.
- Paused rows preserve elapsed row-window duration and subtract paired pause overlap for active/timer duration.
- FIT remains offline validation evidence only.
- Broad recovery-tail behavior, ambiguous repeat tails, true Open/Extra paused-repeat tails, and broad custom-workout promotion remain blocked.
