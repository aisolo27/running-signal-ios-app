# FIT-Backed Two-Gate Validation Plan: March-June 2026

Generated: 2026-06-13

## Executive Summary

RunSignal should move away from Apple Fitness screenshots as the main promotion gate for interval boundary validation. They remain useful optional sanity evidence, but they are manual, slow, and not scalable enough to govern a month-scale boundary strategy.

The new validation direction is a two-gate model:

| Gate | Scope | Current decision |
| --- | --- | --- |
| Gate A | Simple fixed-distance Work + Open workouts | Passes for a narrow feature-flagged `HKWorkoutActivity` prototype only |
| Gate B | Structured intervals and warmup/work/cooldown specials | Blocked pending separate FIT-backed gates |

This does not change production behavior. HealthKit/WorkoutKit remains the only runtime source. FIT files are an offline validation oracle only.

## Source Rules

| Source | Role |
| --- | --- |
| HealthKit/WorkoutKit | Runtime source for completed workouts, plans, samples, and public activity rows |
| FIT files | Offline validation oracle for boundary scoring and evidence review |
| Apple Fitness screenshots/manual rows | Optional sanity evidence only |

FIT files must not be imported into the app, used at runtime, treated as app data input, or used to add a HealthFit dependency.

## Why Apple Fitness Screenshots Are Not Required

Apple Fitness screenshots are not scalable enough for this gate. They require manual capture, manual transcription, and repeated token-heavy review. The March-June dataset already has automated FIT references matched to RunSignal workouts, so FIT can provide a repeatable offline oracle for the boundary decision we are testing.

This changes the validation question. The gate no longer tries to prove exact Apple Fitness UI presentation parity. It tests whether public HealthKit/WorkoutKit reconstruction using `HKWorkoutActivity` boundaries matches the offline FIT lap/step evidence better than the current reconstruction.

## What FIT Can Prove

FIT can support automated offline checks for:

- workout start time, duration, and total distance matching
- lap rows and lap elapsed times
- workout step count where available
- Work/Open boundary elapsed-time comparison
- large candidate-vs-current shifts
- duplicate and same-day caveats
- whether a candidate is closer to FIT than the current reconstruction

## What FIT Cannot Prove

FIT cannot prove:

- exact Apple Fitness UI row presentation
- private Apple smoothing, labeling, or display rules
- runtime behavior inside RunSignal
- that structured and special workouts are safe through the simple Work/Open gate
- that FIT should become a production source

## Evidence Base

| Metric | Count |
| --- | ---: |
| RunSignal workouts in March-June monthly diagnostics | 87 |
| Parsed outdoor-running FIT files | 86 |
| Matched RunSignal workouts | 87 |
| Unmatched RunSignal workouts | 0 |
| Unmatched FIT files | 0 |
| Simple fixed-distance Work + Open candidates | 50 |
| Large-shift simple Work + Open candidates | 10 |
| Structured interval workouts | 20 |
| Warmup/work/cooldown special workouts | 5 |
| Excluded no-plan/duplicate/unknown workouts | 12 |

The May 14 duplicate/same-start RunSignal record shares one FIT file and remains excluded from production approval scoring.

## Gate A: Simple Work + Open

Gate A covers only simple fixed-distance workouts with one planned Work step plus a real Open tail.

Eligibility requirements:

- FIT file is matched.
- `HKWorkoutActivity` candidate is supported by FIT.
- Current reconstruction is not better than the candidate.
- `activityCount == 1`.
- `plannedStepCount == 1`.
- candidate has exactly two rows: Work and Open.
- duplicate, no-plan, structured, and special workouts are excluded.

Current March-June result:

| Check | Result |
| --- | ---: |
| Simple Work + Open total | 50 |
| FIT supports `HKWorkoutActivity` candidate | 50 |
| FIT supports current reconstruction | 0 |
| Large-shift total | 10 |
| Large-shift FIT supports candidate | 10 |
| Large-shift FIT supports current | 0 |
| FIT-inconclusive simple cases | 0 |

Decision: Gate A supports a narrow feature-flagged prototype using `HKWorkoutActivity` boundaries for simple Work + Open only.

It does not support broad production promotion.

## Gate B: Custom Multi-Step Workouts

Gate B covers custom workouts that need richer structure handling:

- structured interval workouts
- warmup/work/cooldown special workouts
- repeat blocks
- work/recovery intervals
- Open or Extra tails after planned work
- labels such as Warmup, Work, Recovery, Cooldown, Open, and Extra

Gate B must verify:

- activity count vs planned step count
- FIT lap count and workout step count vs WorkoutKit plan
- row-level FIT lap labels, timing, and distance vs current and candidate rows
- material row shifts between current and candidate rows
- repeat-block expansion
- Open tail behavior after cooldown
- label mapping for Warmup, Work, Recovery, Cooldown, Open, and Extra

Current March-June result:

| Class | Count | Decision |
| --- | ---: | --- |
| Structured interval workout | 20 | Blocked pending row-level FIT label/error extraction |
| Warmup/work/cooldown special | 5 | Blocked pending label mapping and Open/Extra tail rules |

The Gate B scorecard in `gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.md` confirms strong count alignment, but no Gate B subclass is approved yet. Gate B is not 100% certain for custom workouts because the current rollup does not yet extract full row-level FIT labels, timing, and distance for each structured/special row.

## Excluded Cases

| Class | Decision |
| --- | --- |
| Duplicate/same-day extra run candidate | Excluded from approval scoring |
| No WorkoutKit plan | Excluded from approval scoring |
| Drift/guard candidate unknown | Excluded from approval scoring |

These workouts can remain in reports as reference evidence, but they must not approve Gate A or Gate B unless they are clearly matched to a planned fixture and reclassified.

## Fallback Rules

Production code, when later prototyped, should fall back to current reconstruction when:

- `HKWorkoutActivity` rows are missing.
- activity count and planned step count do not reconcile for the active gate.
- Gate A candidate rows are not exactly Work + Open.
- the workout is structured, special, no-plan, duplicate, or otherwise excluded from Gate A.
- evidence is ambiguous or not scoreable.

FIT must never be read at runtime.

## Recommendation

- Simple fixed-distance Work + Open: proceed to a narrow feature-flagged `HKWorkoutActivity` boundary prototype only.
- Structured intervals: do not promote; build a separate FIT-backed structured interval gate.
- Warmup/work/cooldown specials: do not promote; build a separate FIT-backed special-workout gate.
- Duplicate/no-plan/excluded: keep excluded from approval scoring.
- Broad production promotion: not supported.

Production behavior remains unchanged until a later implementation task explicitly approves a narrow prototype.
