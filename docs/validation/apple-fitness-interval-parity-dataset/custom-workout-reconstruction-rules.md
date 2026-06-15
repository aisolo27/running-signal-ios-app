# Custom Workout Reconstruction Rules

Last updated: 2026-06-13

## Scope

These rules define the ideal model RunSignal should use for completed Apple Watch custom running workouts. They are a validation and future-implementation contract only. Runtime source remains HealthKit and WorkoutKit. FIT files remain an offline validation oracle only and must never become a runtime input, dependency, import path, or production truth source.

This spec does not approve a Swift prototype, does not promote `HKWorkoutActivity` rows, and does not change normal workout UI.

## Source Model

RunSignal should treat a WorkoutKit custom workout as a planned structure with three ordered parts:

1. Optional warmup step.
2. Zero or more ordered interval blocks.
3. Optional cooldown step.

Each interval block contains ordered steps. For running workouts, block steps are usually Work and Recovery/Rest. A block can repeat for multiple iterations. Each planned step has one goal, and the goal defines when the workout should progress to the next planned step.

Supported goal types:

- `time`: step ends when elapsed step duration reaches the planned time.
- `distance`: step ends when step distance reaches the planned distance.
- `open`: step ends only when the user manually progresses or the completed workout exposes a reliable step transition.
- `energy`: not approved for custom running interval reconstruction in this phase.
- `unavailable`: mark the row inconclusive.

Completed scheduled WorkoutKit structure does not contain completed health stats by itself. Actual distance, duration, heart rate, cadence, power, and route-derived values must come from HealthKit samples, HealthKit summary statistics, and, for validation only, offline FIT comparison.

## Expanded Planned Timeline

RunSignal should preserve both the original unexpanded structure and the expanded planned timeline.

Original unexpanded structure should retain:

- warmup presence and goal
- cooldown presence and goal
- block index
- block iteration count
- block step order
- block step role
- block step goal

Expanded planned steps should be created in execution order:

1. Add warmup as step 1 when present.
2. For each block in order, repeat the block `iterations` times.
3. For each repeated block iteration, append each block step in order.
4. Add cooldown as the final planned step when present.

Each expanded planned row should retain:

- `originalStepIndex`: original step position within warmup, block, or cooldown context.
- `expandedStepIndex`: 1-based execution-order index.
- `blockIndex`: block number when the row came from a block.
- `repeatIteration`: repeat iteration when the row came from a repeated block.
- `role`: `warmup`, `work`, `recovery`, `cooldown`, `open`, `extra`, or `unknown`.
- `goalType`: `time`, `distance`, `open`, `energy`, or `unavailable`.
- `goalValue`: seconds for time goals, meters for distance goals, nil for open goals.
- `source`: `WorkoutKit`, `HealthKit`, or `FIT-reference-only`.

The expanded planned timeline is the canonical order for mapping labels. It is not automatically the canonical boundary source.

## Mapping Rules

### Expanded Steps To HealthKit Activity Rows

`HKWorkoutActivity` rows may be used only as a debug/candidate boundary source until a later implementation is explicitly approved.

A candidate activity mapping is valid only when:

- expanded planned steps exist
- activity rows exist
- activity row count reconciles with expanded planned step count, or a documented Open/Extra tail explains the extra row
- activity rows have positive duration and completed end dates
- activity rows are contiguous within a small tolerance
- activity rows expose enough distance/time stats for row-level scoring
- labels can be mapped from expanded planned step order without guessing

If any condition fails, keep the current reconstruction and mark the activity candidate inconclusive with a fallback reason.

### Expanded Steps To FIT Laps

FIT laps are validation rows only. Use them to score offline row-level correctness:

- FIT lap count vs `HKWorkoutActivity` count.
- FIT lap count vs expanded planned steps.
- FIT lap start/end offsets vs current rows.
- FIT lap start/end offsets vs candidate rows.
- FIT lap distance vs current rows.
- FIT lap distance vs candidate rows.
- FIT inferred label vs expanded WorkoutKit label.

FIT `workout_step` rows should be treated as unexpanded planned-structure evidence. For repeat blocks, FIT `workout_step` count is expected to be lower than expanded planned-step count. Do not reject repeat blocks solely because FIT step count differs from expanded planned-step count.

## Boundary Progression Rules

### Time Goals

A time-goal planned step normally uses the row elapsed wall-clock window, but paused custom workouts must preserve a separate active/timer duration.

For paused repeat-block docs/debug scoring, use `paused-repeat-block-timer-rule-2026-06-15.md`: keep the HealthKit activity row elapsed window, subtract paired HealthKit pause overlap inside that row window to compute active/timer duration, and compare paused time-goal rows against active/timer duration. FIT may validate this offline, but runtime code must derive pause overlap from HealthKit events.

If pause-adjusted step timing is unavailable, unpaired, ambiguous, or outside tolerance, confidence must be lowered or the row must remain debug-only/blocked.

### Distance Goals

A distance-goal planned step ends at the step-local distance boundary, not at a generic split boundary. The boundary should be computed from HealthKit distance evidence from the current step start.

Accepted debug comparison fields:

- interpolated distance crossing
- crossing sample end
- previous sample
- next sample
- overshoot meters
- boundary adjustment seconds

Production behavior must not change until row-level validation proves the rule for the target subclass.

### Open Goals

An open-goal step ends only when the user manually progresses or the completed workout exposes a reliable transition boundary. If that manual transition is not available, RunSignal must mark the step boundary uncertain instead of guessing.

A final planned cooldown with an open goal remains `Cooldown` through workout end unless a reliable user/manual transition proves otherwise. It is not an Open/Extra tail.

### Open/Extra Tails

Open/Extra tail starts only after all planned steps are exhausted.

An Open/Extra tail may be created only when:

- every planned fixed time/distance step has a resolved end boundary
- the final planned step was not an open cooldown that should extend to workout end
- remaining workout duration or distance exceeds a small threshold
- the tail can be explained as post-plan activity, not as a planned cooldown row

During FIT validation, if FIT lacks an explicit Open/Extra lap, use FIT session-minus-lap totals as reference evidence only.

## Label Mapping Rules

Labels come from the expanded WorkoutKit planned timeline, not from FIT and not from raw HealthKit segment markers.

Required label rules:

- Warmup: planned warmup step.
- Work: block work step; number by repeat iteration when useful, for example `Work 1`.
- Recovery: block recovery/rest step; number by repeat iteration when useful, for example `Recovery 1`.
- Cooldown: planned cooldown step, including open cooldowns that continue to workout end.
- Open: a planned open step when WorkoutKit explicitly exposes it as a planned row.
- Extra: post-plan activity after all planned steps are exhausted.
- Open / Extra: display/debug label for a tail when the public evidence cannot distinguish user-open continuation from extra post-plan running.
- Unknown: use when role cannot be mapped safely.

If labels cannot be mapped from expanded plan order, mark the row inconclusive.

## Fallback Rules

Fallback to current reconstruction when:

- `HKWorkoutActivity` rows are missing.
- activity rows and expanded planned steps cannot reconcile.
- activity rows are non-contiguous or missing end boundaries.
- labels cannot be mapped from expanded planned step order.
- Open/Extra tail status is ambiguous.
- the workout is duplicate, no-plan, summary-only, or otherwise excluded from validation scoring.

Never use FIT at runtime. Never use Apple Fitness/manual rows at runtime. Never promote raw HealthKit segment markers as Apple Fitness interval rows.

## Approval Rules

Do not approve a custom workout subclass from count alignment alone. A subclass can become a future Swift prototype candidate only when row-level validation proves:

- expanded planned steps reconcile with candidate or current rows
- labels reconcile
- timing errors are within tolerance
- distance errors are within tolerance
- repeat-block behavior is explicit
- Open/Extra tail behavior is explicit
- fallback behavior is defined for missing or ambiguous evidence

Gate A simple Work/Open remains separate and does not approve Gate B structured workouts.
