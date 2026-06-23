# Paused Repeat-Block Promotion Readiness Review

Last updated: 2026-06-23

## Decision

Do not promote paused repeat blocks into normal workout detail yet.

The physical-iPhone debug/export evidence is strong, and the interval timing semantics foundation now exists in code. Paused repeat blocks still need a separate normal-detail promotion decision because the product must decide how to display two time values:

- elapsed row window duration from the HealthKit activity boundary
- active/timer duration after subtracting paired HealthKit pause overlap

Before the timing-semantics foundation, `ReconstructedWorkoutInterval` exposed one `actualDurationSeconds` field and normal detail displayed that single value as the interval time. The model now carries elapsed, pause-overlap, active/timer, display duration, and display-rule fields separately. Promotion is still blocked until the normal-detail gate explicitly chooses the display policy for paused rows:

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

That is enough to represent elapsed row windows and active/timer duration without collapsing them into one value. Current approved no-pause gates still display elapsed duration unchanged. Paused repeat blocks remain blocked from normal detail pending a separate gate decision and proof pass.

The debug/Parity Lab candidate path already exposed `elapsedDurationSeconds`, `pauseOverlapSeconds`, and `activeDurationSeconds`. The 2026-06-23 follow-up also adds those timing fields to `reconstructedIntervals` JSON payloads for future raw debug/parity exports.

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
   - UI remains visually unchanged for current six gates
3. Normal detail display reads the interval display duration while current approved gates continue to use elapsed row-window duration.
4. Tests prove current six gates do not change.
5. Paused timing fixture tests prove:
   - elapsed row window is preserved
   - active/timer duration subtracts paired pause overlap
   - unpaired pause events still block
   - missing activity rows still block
   - recovery-containing tail and ambiguous repeat-tail cases still block

Only after this foundation should paused repeat blocks be considered for normal-detail promotion.

## Recommended Next Product Step

Proceed next with an explicit paused-repeat normal-detail gate decision and proof pass only if that promotion is approved as a separate task.

This keeps the current correctness strategy intact:

- no coaching
- no VDOT
- no training load
- no interval-row analytics
- no FIT runtime usage
- no broad custom-workout promotion
