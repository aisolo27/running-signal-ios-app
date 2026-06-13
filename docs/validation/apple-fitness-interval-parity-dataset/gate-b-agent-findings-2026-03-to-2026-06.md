# Gate B Agent Findings: March-June 2026

Last updated: 2026-06-13

## Executive summary

Gate B remains blocked for production and for any broad Phase 3 custom workout prototype. Five focused review passes found one narrow debug-only candidate class worth discussing later, but repeat-block rules, Open/Extra tail rules, and timer-vs-elapsed drift still block structured interval promotion.

New docs-only scorecards now make the blockers repeatable:

- `gate-b-narrow-warmup-work-cooldown-candidate-scorecard-2026-03-to-2026-06.md`: 4 exact warmup/work/open-cooldown rows reviewed, 2 supported, 2 excluded.
- `gate-b-repeat-block-evidence-2026-03-to-2026-06.md`: 17 repeat-block rows reviewed, 9 close-but-blocked rows, 8 excluded until drift is explained.
- `gate-b-open-tail-evidence-2026-03-to-2026-06.md`: 4 tail rows reviewed, 0 explicit FIT tail laps, 4 session-minus-lap evidence rows.

FIT remains an offline validation oracle only. Runtime source remains HealthKit/WorkoutKit.

## Agent A findings

Scope: candidate-supported warmup/work/open-cooldown cases:

- `2026-03-05T14:37:43Z`
- `2026-04-24T12:02:30Z`

These are the closest prototype candidates because they avoid every unresolved Gate B subclass rule:

- exact shape is `Warmup(2 km) > one Work step > Cooldown(Open)`
- current, candidate, FIT lap, expanded WorkoutKit plan, and FIT workout-step counts are all `3`
- candidate labels map cleanly from expanded WorkoutKit order
- candidate max timing error is `0.0 s`
- candidate max distance error is within tolerance: `7.5 m` and `6.7 m`
- no recovery rows, no repeat expansion, and no fixed cooldown tail

They are clean enough for a future debug-only Phase 3 discussion, but not for production promotion. The evidence count is only two rows, nearby same-shape rows still fail, and current reconstruction is already close enough that support must depend on row-level checks instead of count alignment.

Required false-positive checks:

- Require exact `Warmup`, `Work 1`, `Cooldown(Open)` expanded shape.
- Require the workout is not duplicate, no-plan, summary-only, stale, or excluded.
- Require `3/3/3/3/3` counts across current, candidate, FIT laps, plan, and FIT workout steps.
- Require activity rows have positive duration, end boundaries, row stats, and contiguity.
- Require zero label mismatches from expanded WorkoutKit order.
- Require each candidate row inside timing, end-offset, and distance tolerances.
- Reject repeat rows, recovery rows, fixed cooldown tails, count mismatches, non-cooldown open goals, and ambiguous tail evidence.
- Treat tiny FIT session-minus-lap residuals after an open cooldown as validation noise unless they exceed a future explicit threshold.

Repeatable tooling needed: golden debug fixtures for the two supported rows plus reject fixtures for `2026-03-19T16:51:00Z`, `2026-05-29T11:49:28Z`, `2026-06-05T11:53:53Z`, and representative repeat-block rows.

## Agent B findings

Scope: inconclusive warmup/work/cooldown outliers:

- `2026-03-19T16:51:00Z`
- `2026-05-29T11:49:28Z`

`2026-03-19T16:51:00Z` is blocked by distance drift, not label mapping or timing. Candidate row timing aligns with FIT, but the warmup candidate distance is `1976.0 m` against the FIT lap's `2000.0 m`, producing a `24.0 m` distance error.

`2026-05-29T11:49:28Z` is blocked by timer-vs-elapsed ambiguity. Candidate distances and labels are close, but the cooldown row has a large timing mismatch because FIT elapsed and timer durations diverge by about `159 s`.

Both should be excluded from any narrow prototype until the row-level cause is explained.

Additional debug output needed:

- per-row comparison against FIT elapsed and FIT timer durations
- pause/resume and auto-pause event inventory by row
- row wall-clock start/end, active-timer start/end, elapsed duration, timer duration, distance source, and distance sample count
- boundary-neighbor distance samples around the March 19 warmup end

## Agent C findings

Scope: Open/Extra tail blockers:

- `2026-04-12T16:01:33Z`
- `2026-05-01T12:07:44Z`
- `2026-06-05T11:53:53Z`
- `2026-06-10T11:27:51Z`

All four tail cases use FIT session-minus-lap evidence. None has an explicit FIT tail lap.

| Start | Final planned row | Tail evidence | Safe read |
| --- | --- | --- | --- |
| `2026-04-12T16:01:33Z` | fixed Work `2.50 km` | `179.6 m / 63.2 s` | tail starts after two fixed Work rows are exhausted |
| `2026-05-01T12:07:44Z` | fixed Cooldown `2 km` | `31.4 m / 0.0 s` | tail is internally ambiguous because planned-row timing is already drifted |
| `2026-06-05T11:53:53Z` | fixed Cooldown `2.50 km` | `465.2 m / 159.2 s` | strongest fixed-cooldown plus Open/Extra tail candidate |
| `2026-06-10T11:27:51Z` | fixed Cooldown `2.50 km` after expanded repeats | `43.0 m / 5.6 s` | tail starts after expanded repeat rows plus fixed cooldown |

Safe classification rule:

- Classify tail only after fixed planned steps are exhausted.
- Keep final open cooldown labeled Cooldown through workout end.
- If final cooldown is fixed and running continues, classify the remainder as Open/Extra only after the cooldown boundary.
- Use FIT session-minus-lap tail evidence only for offline validation when FIT lacks an explicit lap.
- Fallback when fixed-step exhaustion, pause timing, or session totals are ambiguous.

## Agent D findings

Scope: repeat-block close cases:

- `2026-03-12T13:41:02Z`
- `2026-03-31T15:26:28Z`
- `2026-05-08T11:55:07Z`
- `2026-06-03T11:45:08Z`

These look close because expanded rows align and candidate row-level errors are inside tolerance:

| Start | Rows current/candidate/FIT/plan/FIT step | Candidate max error |
| --- | --- | ---: |
| `2026-03-12T13:41:02Z` | `8/8/8/8/5` | `0.0 s / 7.6 m` |
| `2026-03-31T15:26:28Z` | `10/10/10/10/5` | `0.0 s / 8.0 m` |
| `2026-05-08T11:55:07Z` | `6/6/6/6/5` | `0.0 s / 7.4 m` |
| `2026-06-03T11:45:08Z` | `8/8/8/8/5` | `0.0 s / 8.6 m` |

They remain blocked because FIT `workout_step` rows are unexpanded while FIT laps and WorkoutKit planned rows are expanded. That is not a data failure, but it means FIT workout steps can only validate the compact plan shape, not row-by-row execution.

Safe repeat rule:

- Use expanded WorkoutKit planned rows as label/order source.
- Treat FIT workout_step rows as unexpanded plan evidence.
- Compare FIT laps against expanded planned rows.
- Require row-level label, timing, and distance tolerance for every expanded Work/Recovery row.
- Never approve from count alignment alone.

Fallback: keep current/debug-only behavior when activity rows are missing, non-contiguous, label-ambiguous, count-mismatched, outside tolerance, or paired with unresolved Open/Extra tail evidence.

## Agent E findings

Scope: repeat-block high-error outliers:

- `2026-03-10T13:49:08Z`
- `2026-04-22T11:39:58Z`
- `2026-04-29T11:49:02Z`
- `2026-05-06T12:02:13Z`
- `2026-05-13T11:52:06Z`
- `2026-05-27T11:45:47Z`

These are primarily timer-vs-elapsed or pause-time outliers, not label mapping failures. Candidate rows are generally closer in distance but worse in time:

| Start | Candidate max error | Read |
| --- | ---: | --- |
| `2026-03-10T13:49:08Z` | `151.3 s / 7.3 m` | distance closer, timing much worse |
| `2026-04-22T11:39:58Z` | `99.8 s / 8.1 m` | distance closer, timing much worse |
| `2026-04-29T11:49:02Z` | `110.1 s / 7.6 m` | distance closer, timing much worse |
| `2026-05-06T12:02:13Z` | `126.4 s / 8.1 m` | distance close, timing much worse |
| `2026-05-13T11:52:06Z` | `52.6 s / 11.2 m` | timing and distance fail |
| `2026-05-27T11:45:47Z` | `60.8 s / 11.4 m` | timing and distance fail |

All six must stay excluded from any safe subclass or production-approval scoring until the scorer separates FIT elapsed time from timer time and the repeat-block rule is approved.

## Root-cause matrix

| Root cause | Affected rows | Evidence | Safe status |
| --- | --- | --- | --- |
| Narrow no-tail warmup/work/open-cooldown support | `2026-03-05`, `2026-04-24` | exact counts, labels, timing, distance pass | future debug-only discussion candidate |
| Warmup/work/cooldown distance drift | `2026-03-19` | candidate warmup distance error `24.0 m` | excluded |
| Timer-vs-elapsed ambiguity | `2026-05-29`, high-error repeat outliers | large timing error with clean labels and close distances | excluded pending elapsed/timer diagnostics |
| Repeat-block expansion rule missing | 17 repeat-block rows | FIT steps unexpanded, FIT laps expanded | blocked until explicit rule |
| Open/Extra tail rule missing | 4 tail rows | no explicit FIT tail lap; session-minus-lap only | blocked until explicit rule |
| Count alignment overclaim risk | most Gate B rows | counts can align while rules remain incomplete | never approve from counts alone |

## Proposed debug/validation fixes

Implemented in this pass:

- Add `score_gate_b_rule_evidence.py`.
- Generate repeat-block evidence scorecards.
- Generate Open/Extra tail evidence scorecards.
- Generate a narrow warmup/work/open-cooldown candidate scorecard.

Still useful future debug-only fixes:

- Add per-row elapsed-vs-timer FIT comparison fields.
- Add pause/resume and auto-pause event inventory to row-level exports.
- Add boundary-neighbor distance samples around fixed-distance transitions.
- Add debug model fields for tail classification details: final planned row, fixed-step exhaustion, FIT tail source, threshold status, and fallback reason.
- Add golden tests around supported, excluded, tail-ambiguous, repeat-block, and missing-evidence classifications.

## What can be safely implemented now

The only safe changes from this evidence are docs/debug/validation changes:

- Keep the three generated scorecards active.
- Use the narrow candidate scorecard for later Phase 3 discussion.
- Use the repeat and tail scorecards to prevent accidental promotion of blocked subclasses.
- Document Phase 3 as still blocked except for a future discussion about the exact no-tail warmup/work/open-cooldown class.

## What remains blocked

- Broad Gate B production promotion.
- Normal workout UI changes.
- Runtime `HKWorkoutActivity` promotion.
- FIT import, HealthFit dependency, or runtime FIT usage.
- Repeat-block structured interval prototype.
- Fixed-cooldown plus Open/Extra tail prototype.
- Any prototype that includes the inconclusive warmup/work/cooldown outliers.
- Any prototype that includes timer-vs-elapsed high-error repeat outliers.

## Explicit no-production-change statement

This investigation is docs/debug/validation only. It does not change production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, HealthKit runtime sourcing, FIT runtime usage, FIT import behavior, HealthFit dependency status, or custom workout reconstruction behavior.

Phase 3 remains blocked. There is now a narrow debug-only candidate worth discussing later: `Warmup(2 km) > one fixed Work step > Cooldown(Open)` with exact `3/3/3/3/3` evidence, no recovery rows, no fixed cooldown tail, clean labels, and row-level timing/distance support.
