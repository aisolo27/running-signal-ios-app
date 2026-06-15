# Paused Repeat-Block Promotion Readiness Review

Last updated: 2026-06-15

## Decision

Do not promote paused repeat blocks into normal workout detail yet.

The physical-iPhone debug/export evidence is strong, but the normal interval model and UI are not ready to represent paused rows correctly. Paused repeat blocks need two time values:

- elapsed row window duration from the HealthKit activity boundary
- active/timer duration after subtracting paired HealthKit pause overlap

`ReconstructedWorkoutInterval` currently exposes one `actualDurationSeconds` field. Normal detail displays that single value as the interval time. If paused repeat blocks were promoted now, the app would either show elapsed wall-clock time for paused Recovery rows or overwrite the row window duration with active time. Both would be misleading:

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

## Current Code Gap

Normal detail intervals use:

- `actualStartDate`
- `actualEndDate`
- `actualDurationSeconds`
- `actualDistanceMeters`
- pace/HR/cadence/power calculated over the row window

That is enough for clean no-pause rows, Gate A simple Work/Open, and clean fixed-tail classes. It is not enough for paused rows because one duration field cannot safely carry both row-window duration and active/timer duration.

The debug/Parity Lab path already has the right conceptual shape through fields like `elapsedDurationSeconds`, `pauseOverlapSeconds`, and `activeDurationSeconds`. Normal detail needs a narrow equivalent before paused rows can be trusted in the main UI.

## Recommended Next Code Step

Add interval timing semantics before any paused repeat-block normal-detail gate:

1. Extend `ReconstructedWorkoutInterval` with optional timing fields:
   - `elapsedDurationSeconds`
   - `pauseOverlapSeconds`
   - `activeDurationSeconds`
   - `durationDisplayRule`
2. Keep existing no-pause behavior stable:
   - elapsed = actual duration
   - pause overlap = nil or zero
   - active = actual duration
   - UI remains visually unchanged for current six gates
3. Update normal detail display so paused rows can show active/timer duration without losing elapsed row-window evidence.
4. Add tests proving current six gates do not change.
5. Add paused-repeat fixture tests proving:
   - elapsed row window is preserved
   - active/timer duration subtracts paired pause overlap
   - unpaired pause events still block
   - missing activity rows still block
   - recovery-containing tail and ambiguous repeat-tail cases still block

Only after that foundation should paused repeat blocks be considered for normal-detail promotion.

## Recommended Next Product Step

Proceed with a narrow "interval timing semantics foundation" task, not a paused-repeat UI promotion task.

This keeps the current correctness strategy intact:

- no coaching
- no VDOT
- no training load
- no interval-row analytics
- no FIT runtime usage
- no broad custom-workout promotion

