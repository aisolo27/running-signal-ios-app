# Gate B Phase 3 Readiness Review

Last updated: 2026-06-13

## Executive summary

Gate B remains blocked. Phase 1 and Phase 2 added internal/debug validation models, but they do not approve a Phase 3 prototype, production interval behavior, normal workout UI changes, or `HKWorkoutActivity` promotion.

The closest future prototype candidate is a very narrow warmup/work/cooldown shape:

- planned `Warmup(2 km) > Work(fixed time or distance) > Cooldown(Open)`
- current rows, `HKWorkoutActivity` candidate rows, FIT lap rows, and expanded WorkoutKit planned rows all have 3 rows
- row-level candidate timing error is 0.0 seconds and distance error is within 10 meters in the current scorecard
- there is no fixed-cooldown Open/Extra tail rule needed

Only two workouts meet that candidate-supported pattern in the March-June 2026 Gate B set:

| Start | Shape | Rows current/candidate/FIT/plan/FIT step | Current max error | Candidate max error | Decision |
| --- | --- | --- | ---: | ---: | --- |
| 2026-03-05T14:37:43Z | `Warmup(2 km) > Work(900 s) > Cooldown(Open)` | 3/3/3/3/3 | 3.2s / 6.0m | 0.0s / 7.5m | candidate row-level supported |
| 2026-04-24T12:02:30Z | `Warmup(2 km) > Work(4 km) > Cooldown(Open)` | 3/3/3/3/3 | 5.0s / 8.4m | 0.0s / 6.7m | candidate row-level supported |

These rows are safe to consider later for a debug-only Phase 3 discussion, but not safe to promote. Count alignment alone is not proof; support depends on row-level timing, distance, labels, plan shape, and fallback behavior.

## Safe-to-consider-later shapes

Safe-to-consider-later means "worth discussing as a future debug prototype candidate after an explicit approval step." It does not mean production-ready.

### Candidate-supported warmup/work/cooldown with open cooldown

Exact shape:

- Warmup: fixed 2 km
- Work: one fixed work step, either fixed time or fixed distance
- Cooldown: open cooldown
- No recovery rows
- No fixed cooldown followed by post-plan running
- No activity/planned/FIT count mismatch

Why this shape is closest:

- Expanded WorkoutKit planned rows reconcile with FIT lap count and activity candidate count.
- Labels are simple: Warmup, Work, Cooldown.
- FIT `workout_step` rows are also 3, so there is no repeat expansion conflict.
- Candidate rows have 0.0 second timing error against FIT laps in the two supported examples.
- Distance errors are within the current Gate B tolerance envelope used by the scorecard.

Candidate examples:

- `2026-03-05T14:37:43Z`: `Warmup(2 km) > Work(900 s) > Cooldown(Open)`.
- `2026-04-24T12:02:30Z`: `Warmup(2 km) > Work(4 km) > Cooldown(Open)`.

Rule still needed before any Phase 3 prototype:

- Approval must say that this exact no-tail warmup/work/open-cooldown shape can be tested debug-only when row-level candidate timing, distance, label mapping, and fallback checks pass. It must also state that open cooldown remains Cooldown through workout end.

## Still-blocked shapes

The following exact shape groups remain blocked:

| Shape group | Count | Main blocker |
| --- | ---: | --- |
| Structured repeat-block intervals with warmup and open cooldown | 17 | Repeat-block rules are not approved, even when row counts align |
| Structured or simple planned rows followed by possible Open/Extra tail | 4 | Tail rule is not approved |
| Warmup/work/cooldown outliers with row-level timing or distance drift | 2 | Inconclusive row-level evidence |

Blocked does not mean the current rows are always bad. Several structured interval rows have close candidate timing or distance. They remain blocked because the rule set is incomplete, especially around repeat expansion and Open/Extra tails.

## Repeat-block blockers

Seventeen structured interval workouts are classified as `repeat_block_needs_rule`.

Common exact shape:

- Warmup, usually fixed 2 km.
- Repeated Work/Recovery block, expanded to 2 to 10 Work rows and 2 to 10 Recovery rows.
- Cooldown, usually open.
- FIT `workout_step` rows remain unexpanded while FIT lap rows and WorkoutKit planned rows are expanded.

Representative blocked shapes:

| Start | Expanded shape | Rows current/candidate/FIT/plan/FIT step | Candidate max error | Reason blocked |
| --- | --- | --- | ---: | --- |
| 2026-03-03T13:39:37Z | Warmup + 8 Work + 8 Recovery + Cooldown | 18/18/18/18/5 | 0.0s / 15.3m | Repeat block evidence is unexpanded in FIT steps; distance error also exceeds 10m |
| 2026-03-12T13:41:02Z | Warmup + 3 Work + 3 Recovery + Cooldown | 8/8/8/8/5 | 0.0s / 7.6m | Looks close, but repeat-block mapping rule is not approved |
| 2026-03-31T15:26:28Z | Warmup + 4 Work + 4 Recovery + Cooldown | 10/10/10/10/5 | 0.0s / 8.0m | Looks close, but count alignment plus low error is not enough |
| 2026-05-08T11:55:07Z | Warmup + 2 Work + 2 Recovery + Cooldown | 6/6/6/6/5 | 0.0s / 7.4m | Small repeat shape, still blocked until repeat rule is explicit |
| 2026-06-03T11:45:08Z | Warmup + 3 Work + 3 Recovery + Cooldown | 8/8/8/8/5 | 0.0s / 8.6m | Looks close, still repeat-block-needs-rule |

Higher-error repeat-block outliers that need manual review before any structured prototype:

| Start | Expanded shape | Current max error | Candidate max error | Why manual review matters |
| --- | --- | ---: | ---: | --- |
| 2026-03-10T13:49:08Z | Warmup + 5 Work + 6 Recovery + Cooldown | 141.9s / 21.8m | 151.3s / 7.3m | Large timing shift despite candidate distance closeness |
| 2026-04-22T11:39:58Z | Warmup + 5 Work + 5 Recovery + Cooldown | 88.1s / 47.0m | 99.8s / 8.1m | Large timing shift and current distance drift |
| 2026-04-29T11:49:02Z | Warmup + 5 Work + 5 Recovery + Cooldown | 108.4s / 63.0m | 110.1s / 7.6m | Similar shape to Apr 22; needs pair review |
| 2026-05-06T12:02:13Z | Warmup + 6 Work + 6 Recovery + Cooldown | 122.5s / 9.1m | 126.4s / 8.1m | Multiple repeated block groups; timing drift is too large |
| 2026-05-13T11:52:06Z | Warmup + 8 Work + 8 Recovery + Cooldown | 35.6s / 66.4m | 52.6s / 11.2m | Candidate still above distance tolerance |
| 2026-05-27T11:45:47Z | Warmup + 10 Work + 10 Recovery + Cooldown | 55.2s / 22.4m | 60.8s / 11.4m | Large repeat count plus candidate distance over tolerance |

Repeat-block rule that must be approved before Phase 3 can include structured intervals:

- Treat WorkoutKit expanded planned rows as the label/order source.
- Treat FIT `workout_step` rows as unexpanded planned-structure evidence only.
- Compare FIT laps against expanded planned rows.
- Do not approve from count alignment alone.
- Require row-level timing and distance tolerances for each expanded Work/Recovery row.
- Define fallback for missing activities, non-contiguous activities, label ambiguity, and Open/Extra tails after repeat blocks.

## Open/Extra tail blockers

Four workouts are classified as `open_tail_needs_rule`.

| Start | Class | Shape | Rows current/candidate/FIT/plan/FIT step | Candidate max error | Tail evidence |
| --- | --- | --- | --- | ---: | --- |
| 2026-04-12T16:01:33Z | Structured | `Work(2.50 km) > Work(2.50 km)` plus tail | 3/3/2/2/2 | 0.0s / 8.7m | FIT session-minus-lap tail: 179.6m / 63.2s |
| 2026-05-01T12:07:44Z | Structured | `Warmup(2 km) > Recovery(120 s) > Work(5 km) > Cooldown(2 km)` plus tail | 5/5/4/4/4 | 141.0s / 9.1m | FIT tail is internally odd: 31.4m / 0.0s with reversed-looking offsets |
| 2026-06-05T11:53:53Z | Warmup/work/cooldown | `Warmup(2 km) > Work(2 km) > Cooldown(2.50 km)` plus tail | 4/4/3/3/3 | 0.0s / 6.6m | FIT session-minus-lap tail: 465.2m / 159.2s |
| 2026-06-10T11:27:51Z | Structured | Warmup + 4 Work + 4 Recovery + `Cooldown(2.50 km)` plus tail | 11/11/10/10/5 | 0.0s / 8.9m | FIT session-minus-lap tail: 43.0m / 5.6s |

Open/Extra rule that must be approved before Phase 3 can include tail cases:

- If the final planned cooldown is open, keep it labeled Cooldown through workout end unless a reliable transition proves otherwise.
- If the final planned cooldown is fixed time or distance and running continues after it completes, classify the remainder as Open/Extra only after the cooldown boundary.
- If FIT has no explicit tail lap, use session-minus-lap tail only as offline validation evidence.
- Do not allow a count mismatch to fail or pass automatically; classify it by a tail rule and fallback reason.

The 2026-06-05 fixed-cooldown warmup/work/cooldown tail case is the closest tail-specific future candidate, but it is not prototype-ready until the Open/Extra tail rule is approved.

## Inconclusive outliers

Two warmup/work/cooldown special workouts remain `row_level_inconclusive`.

| Start | Shape | Rows current/candidate/FIT/plan/FIT step | Current max error | Candidate max error | Why inconclusive |
| --- | --- | --- | ---: | ---: | --- |
| 2026-03-19T16:51:00Z | `Warmup(2 km) > Work(1500 s) > Cooldown(Open)` | 3/3/3/3/3 | 5.6s / 19.5m | 0.0s / 24.0m | Candidate timing aligns, but distance error is too high and there is no FIT inferred tail |
| 2026-05-29T11:49:28Z | `Warmup(2 km) > Work(3 km) > Cooldown(Open)` | 3/3/3/3/3 | 161.1s / 11.5m | 158.9s / 6.6m | Distance is close, but timing shift is far outside tolerance |

Manual review before any Phase 3 prototype:

- Review the 2026-03-19 and 2026-05-29 workouts against raw diagnostics and Apple Fitness screenshots if available.
- Determine whether the drift is caused by plan goal interpretation, FIT lap labeling, HealthKit activity boundaries, pause/timer time, or stale/summary evidence.
- Do not include these shapes in a future prototype candidate list until their row-level cause is understood.

## Recommended next decision

Do not start Phase 3 yet.

The exact approval decision needed before any Phase 3 debug prototype is:

1. Approve or reject a narrow debug-only candidate class:
   `Warmup(2 km fixed distance) > one Work step fixed time or fixed distance > Cooldown(Open)`, with 3 planned rows, 3 activity rows, 3 FIT laps, no recovery rows, no fixed cooldown tail, no duplicate/no-plan/summary-only exclusion, and row-level candidate timing/distance/label checks inside tolerance.
2. Decide whether the two supported examples are enough for a debug prototype, or require more examples before Swift work.
3. Explicitly exclude repeat-block structured intervals from Phase 3 unless a separate repeat-block rule is approved.
4. Explicitly exclude Open/Extra tail cases from Phase 3 unless a separate tail rule is approved.
5. Keep the Phase 3 prototype, if later approved, debug-only and fallback-first. It must not replace production interval reconstruction.

The most conservative next docs/debug step is to manually review the four outlier dates before approving even a narrow Phase 3 candidate:

- `2026-03-19T16:51:00Z`
- `2026-05-29T11:49:28Z`
- `2026-06-05T11:53:53Z`
- `2026-05-01T12:07:44Z`

## Explicit no-production-change statement

This review is documentation only. It does not approve Phase 3, production interval reconstruction, normal workout UI changes, `HKWorkoutActivity` promotion, FIT import, HealthFit dependency, runtime FIT usage, coaching, readiness, VDOT, training load, recovery, or race prediction.

Runtime source remains HealthKit and WorkoutKit. FIT remains an offline validation oracle only. Gate B remains blocked until an explicit later decision approves a narrow debug prototype scope.
