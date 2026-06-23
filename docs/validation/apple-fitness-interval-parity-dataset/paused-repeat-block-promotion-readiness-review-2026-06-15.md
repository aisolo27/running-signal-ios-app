# Paused Repeat-Block Promotion Readiness Review

Last updated: 2026-06-23

## Decision

Narrow paused repeat-block normal detail promotion is implemented and physically proofed for the proven `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)` shape only. Simulator smoke, physical-iPhone install on `AIS17PM`, RunSignal raw/parity exports, and Apple Fitness screenshots passed for Apr 22, Apr 29, May 6, May 13, and May 27.

Do not broaden paused repeat blocks beyond that narrow open-cooldown shape. True Open/Extra paused-repeat tails, recovery-containing tails, ambiguous repeat tails, unpaired pauses, missing rows, non-contiguous rows, and cross-row pause overlaps remain blocked.

The physical-iPhone debug/export evidence is strong, and the interval timing semantics foundation now exists in code. The separate normal-detail promotion decision has now been made for the narrow open-cooldown paused-repeat shape only, with the display rule explicitly preserving two time values:

- elapsed row window duration from the HealthKit activity boundary
- active/timer duration after subtracting paired HealthKit pause overlap

Before the timing-semantics foundation, `ReconstructedWorkoutInterval` exposed one `actualDurationSeconds` field and normal detail displayed that single value as the interval time. The model now carries elapsed, pause-overlap, active/timer, display duration, and display-rule fields separately. The narrow paused-repeat open-cooldown gate now chooses active/timer duration as the primary paused-row display while preserving elapsed row-window evidence as secondary text:

- elapsed time preserves the correct row window but mismatches Apple Fitness timer-style row duration
- active time matches the timer-style row duration but hides the real HealthKit activity window used for samples and stats

## Evidence Status

Paused repeat-block proof is complete for the debug/export path:

- `physical-iphone-paused-repeat-proof-2026-06-15/`
- workouts: Apr 22, Apr 29, May 6, May 13, May 27
- `customWorkoutComparisonSummary.status == supported`
- fallback reasons are empty / `None`
- candidate rule scorer reports `candidate-rule-scoreable`
- tail ambiguity is `plannedOpenCooldownContinuesToWorkoutEnd`
- normal workout UI and production interval behavior remain unchanged

The critical timing rows are already preserved in debug/export output:

| Workout date | Row | Elapsed | Pause overlap | Active/timer |
| --- | --- | ---: | ---: | ---: |
| 2026-04-22 | Recovery 3 | 219.7 s | 99.8 s | 119.9 s |
| 2026-04-22 | Recovery 4 | 198.1 s | 78.3 s | 119.8 s |
| 2026-04-29 | Recovery 3 | 182.0 s | 62.9 s | 119.1 s |
| 2026-04-29 | Recovery 4 | 229.1 s | 110.1 s | 119.0 s |
| 2026-05-06 | Warmup | 900.9 s | 126.4 s | 774.5 s |
| 2026-05-13 | Recovery 7 | 172.0 s | 52.6 s | 119.4 s |
| 2026-05-27 | Recovery 8 | 150.0 s | 60.8 s | 89.2 s |

## Current Foundation Status

Normal detail intervals previously used:

- `actualStartDate`
- `actualEndDate`
- `actualDurationSeconds`
- `actualDistanceMeters`
- pace/HR/cadence/power calculated over the row window

The interval model now also carries:

- `elapsedDurationSeconds`
- `pauseOverlapSeconds`
- `activeDurationSeconds`
- `displayDurationSeconds`
- `durationDisplayRule`

That is enough to represent elapsed row windows and active/timer duration without collapsing them into one value. Current approved no-pause gates still display elapsed duration unchanged. The narrow paused-repeat open-cooldown gate is implemented and physical proof is archived in `physical-iphone-paused-repeat-normal-detail-promotion-proof-2026-06-23/`.

The debug/Parity Lab candidate path already exposed `elapsedDurationSeconds`, `pauseOverlapSeconds`, and `activeDurationSeconds`. `ReconstructedWorkoutInterval` can now carry the same timing semantics for normal-detail rows without collapsing elapsed row windows and active/timer duration.

## Completed Code Step

Interval timing semantics have been added before any paused repeat-block normal-detail gate:

1. `ReconstructedWorkoutInterval` now includes:
   - `elapsedDurationSeconds`
   - `pauseOverlapSeconds`
   - `activeDurationSeconds`
   - `displayDurationSeconds`
   - `durationDisplayRule`
2. Existing no-pause behavior remains stable:
   - elapsed = actual duration
   - pause overlap = nil or zero
   - active = actual duration
   - UI remains visually unchanged for the six pre-existing gates
3. Normal detail display reads the interval display duration while current approved gates continue to use elapsed row-window duration.
4. Tests prove the six pre-existing gates do not change.
5. Paused timing fixture tests prove:
   - elapsed row window is preserved
   - active/timer duration subtracts paired pause overlap
   - unpaired pause events still block
   - missing activity rows still block
   - non-contiguous or count-mismatched activity rows still block
   - cross-row pause overlaps still block
   - recovery-containing tail and ambiguous repeat-tail cases still block

The foundation, narrow gate implementation, and physical proof pass are now in place. This promotion remains limited to the open-cooldown paused-repeat shape.

## Recommended Next Product Step

Proceed next with the remaining blocked custom-workout classes only after separate explicit decisions: recovery-containing Open/Extra tails and ambiguous repeat-tail cases. Do not broaden beyond the narrow paused-repeat open-cooldown shape.

This keeps the current correctness strategy intact:

- no coaching
- no VDOT
- no training load
- no interval-row analytics
- no FIT runtime usage
- no broad custom-workout promotion
