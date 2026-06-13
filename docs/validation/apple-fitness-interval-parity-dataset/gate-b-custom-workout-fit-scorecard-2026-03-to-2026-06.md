# Gate B Custom Workout FIT Scorecard: March-June 2026

Generated: 2026-06-13T01:48:47Z

## Executive Summary

Gate B remains blocked for production and for Swift implementation. FIT matching shows strong count alignment for structured intervals and warmup/work/cooldown specials, but the current FIT rollup does not yet extract full row-level label/error evidence for custom multi-step workouts.

FIT remains an offline validation oracle only. HealthKit/WorkoutKit remains the runtime source.

## Class Findings

| Class | Total | FIT matched | activity==planned | FIT lap==activity | FIT step==planned | Equivalent | Inconclusive | Decision |
| --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- |
| Structured interval | 20 | 20 | 20 | 20 | 2 | 18 | 2 | Blocked pending row-level FIT labels/errors |
| Warmup/work/cooldown | 5 | 5 | 5 | 5 | 5 | 3 | 2 | Blocked pending label/tail rules |

## Candidate vs Current

| Candidate better | Current better | Equivalent | Inconclusive |
| ---: | ---: | ---: | ---: |
| 0 | 0 | 21 | 4 |

Equivalent means current and candidate are not materially different in the current rollup. It does not mean production approval.

## Open / Extra Tail Findings

- Gate B rows with Open/Extra tail evidence: 4
- Structured interval rows with Open/Extra tail evidence: 3
- Warmup/work/cooldown rows with Open/Extra tail evidence: 1
- Rule needed: Detect Open/Extra only after planned steps are exhausted, preserve cooldown labels, and avoid folding extra tail into the final planned step.

## Repeat Block Findings

- Rows where FIT workout-step count differs from expanded planned steps: 18
- Structured rows with this mismatch: 18
- Warmup/work/cooldown rows with this mismatch: 0
- Rule needed: Use WorkoutKit expanded planned steps for row order; use FIT workout steps only as unexpanded-plan reference evidence.

## Label Mapping Findings

- Rows needing a label mapping rule: 25
- Rule needed: Map labels from WorkoutKit planned step order, including Warmup, Work, Recovery, Cooldown, Open, and Extra; do not infer production labels from FIT at runtime.

## Safe Subclasses

None approved yet.

## Promising But Blocked Subclasses

| Shape | Count | Blocked reason |
| --- | ---: | --- |
| structured intervals with activityCount == plannedStepCount == FIT lap count and no material current/candidate shift | 18 | needs row-level FIT label/error extraction and repeat-block label rules |
| three-step warmup/work/cooldown with activityCount == plannedStepCount == FIT lap count and no Open/Extra tail | 3 | needs label mapping proof for Warmup, Work, and Cooldown |

## Blocked Subclasses

- `structured_interval_repeat_blocks`
- `structured_interval_work_recovery_mapping`
- `warmup_work_cooldown_label_mapping`
- `warmup_work_cooldown_open_or_extra_tail_after_cooldown`
- `any_gate_b_case_without_row_level_fit_label_error_extraction`

## Recommendation

- Do not approve Gate B production promotion.
- Do not implement a Gate B Swift prototype yet.
- Next Gate B work should extract row-level FIT lap labels/timing/distance and compare them to current and candidate rows.
- Gate A must remain separate and must not approve structured or warmup/work/cooldown workouts.
