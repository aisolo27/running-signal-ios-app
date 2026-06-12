# Apple Documentation Research

Updated: 2026-06-12

This note constrains RunSignal's WorkoutKit reconstructed interval validation to Apple-documented APIs and the current June 1-5 evidence set. Apple documentation defines the available model and APIs; it does not prove the exact row-boundary or row-label algorithm used by the Apple Fitness app.

## Apple-Documented Model Facts

Official Apple documentation and the local iOS 26.5 SDK public interfaces document these relevant pieces:

- `HKWorkout.workoutPlan` can expose a `WorkoutKit.WorkoutPlan?` from a completed `HKWorkout` asynchronously. It can also be unavailable or fail, so RunSignal must treat WorkoutKit plan evidence as optional.
- `CustomWorkout` has an activity, optional display name, optional `warmup`, repeatable `blocks`, and optional `cooldown`.
- `IntervalBlock` contains ordered `IntervalStep` values and an iteration count.
- `IntervalStep` has a purpose of `work` or `recovery` and wraps a `WorkoutStep`.
- `WorkoutStep` has a `WorkoutGoal` and an optional `WorkoutAlert`.
- `WorkoutGoal` supports `open`, `distance`, `time`, and `energy` goals.
- Workout alerts are documented as typed alerts, including heart-rate range/zone, speed threshold/range, cadence threshold/range, and power threshold/range/zone. RunSignal currently formats speed alerts as pace targets for running readability.
- `HKWorkout` is the workout session identity and exposes start/end/duration, workout events, and workout-level totals when available.
- `HKQuery.predicateForObjects(from:)` / `predicateForObjectsFromWorkout:` matches HealthKit samples added to a given workout. RunSignal uses workout-associated samples as the measured stats source.
- `HKWorkoutEventType` includes pause, resume, lap, marker, motion paused/resumed, segment, and pause-or-resume request.
- `HKWorkoutEvent.dateInterval` represents the time period for an event. Apple documents that most event types support only zero-duration intervals; lap and segment are the documented nonzero-duration event types.

Official references:

- https://developer.apple.com/documentation/workoutkit
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hkworkoutevent
- https://developer.apple.com/documentation/healthkit/hkworkouteventtype
- https://developer.apple.com/documentation/healthkit/hkquery
- https://developer.apple.com/documentation/healthkit/hksamplequery

## What Apple Documentation Does Not Confirm

Apple documentation does not confirm:

- The exact Apple Fitness interval-row rendering algorithm.
- Whether Apple Fitness uses exact distance crossings, crossing sample end dates, private smoothing, rounded displayed distances, active time, elapsed time, route data, or another private source when drawing interval rows.
- That `HKWorkoutEvent` segment or marker rows are Apple Fitness interval rows.
- That a final open tail after a completed planned cooldown should be merged into `Cooldown`.
- That an open planned cooldown should be labeled `Open` in the Apple Fitness UI.
- That Apple Fitness row labels are directly exposed through public HealthKit event metadata.

## RunSignal Evidence Contract

For this v1 Apple Fitness parity validation:

- Plan source: WorkoutKit when `HKWorkout.workoutPlan` exposes a custom workout plan.
- Actual stats source: HealthKit samples associated with the workout.
- Apple Fitness screenshots: visual parity reference.
- RunSignal Raw HealthKit Debug exports: RunSignal evidence source.
- HealthKit Segment Markers: raw/debug-only evidence.

HealthKit Segment Markers must not be used as Apple Fitness interval rows, must not be promoted into the normal workout interval table, and must remain explicitly labeled as not used for WorkoutKit reconstructed intervals.

## Tail Labeling Policy For Validation

WorkoutKit planned steps define the planned structure. HealthKit samples provide measured stats for those windows.

If the final planned step is `Cooldown` and its WorkoutKit goal is `open`, the cooldown has no fixed goal to complete. RunSignal should keep the planned `Cooldown` label and extend that row to workout end. This is different from relabeling a post-completed-cooldown tail.

If a planned `Cooldown` has a distance or time goal and that goal is completed, meaningful remaining activity after that completed cooldown should be labeled `Open / Extra`. Do not merge post-cooldown activity into `Cooldown` by default.

Only hide or merge a final tail when all of these are true:

- The tail is clearly a tiny reconstruction artifact below threshold.
- Apple Fitness does not show a separate `Open` row.
- Hiding or merging improves parity across the dataset.

If Apple Fitness shows a separate `Open` row, RunSignal should show `Open / Extra`.

If Apple Fitness shows `Cooldown`, first investigate whether RunSignal ended the cooldown boundary too early or whether the WorkoutKit plan contains an open cooldown step. Do not assume the fix is relabeling any final `Open / Extra` row as `Cooldown`.

If uncertain, keep `Open / Extra` in debug, add a diagnostic reason, and do not promote the behavior into the normal workout detail UI.

## June 3 Interpretation

The June 3 screenshot shows Apple Fitness labeling the final 1.03 km / 6:22 row as `Cooldown`, with no visible `Open` row after it. RunSignal's older export shows the WorkoutKit plan has `Cooldown: goal open`; the targeted app rule now reconstructs that final open planned cooldown as `Cooldown` through workout end. That resolves the June 3 label/structure blocker, but it is not evidence that post-cooldown activity after a completed distance/time cooldown should be merged into `Cooldown`.
