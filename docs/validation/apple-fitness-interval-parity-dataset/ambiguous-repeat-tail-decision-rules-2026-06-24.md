# Ambiguous Repeat-Tail Decision Rules

Last updated: 2026-06-24

Scope: AIS-47 docs/debug-only rules for Gate B repeat-tail scoring. This does not approve new Swift behavior, normal workout detail promotion, interval-row analytics, FIT runtime usage, FIT import, HealthFit dependency, or file-based workout ingestion. Runtime truth remains HealthKit plus optional WorkoutKit plan structure. FIT remains offline validation evidence only.

## Decision Goal

For repeat-block workouts with possible residual movement after repeated Work/Recovery rows, decide whether the residual belongs to:

1. The expanded repeat block.
2. A fixed final `Cooldown`.
3. A post-plan `Open / Extra` tail.
4. A blocked ambiguous or unsupported fallback.

The only already-approved clean repeat-tail shape remains:

`Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`

Broader repeat tails, true paused Open/Extra repeat tails, ambiguous repeat tails, and broad recovery-containing tails remain blocked unless a later task approves a named narrow gate.

## Evidence Order

Use evidence in this order when scoring/debugging ambiguous repeat tails:

1. WorkoutKit planned structure, if present, expands the repeat block and defines planned row labels, order, fixed distances/durations, and whether the final cooldown is fixed or open.
2. HealthKit activity rows decide measured contiguous activity boundaries, completion, distance, elapsed duration, and pause overlap.
3. FIT row-level laps/workout steps validate offline label, timing, distance, and session-minus-lap residual agreement. FIT can confirm or challenge a debug score, but it must not create runtime rows or override HealthKit/WorkoutKit in production.
4. Apple Fitness screenshots, when available, are sanity evidence only.

## Repeat Block End

A repeat-block section may end at the boundary after the last resolved expanded Work/Recovery row only when:

- planned expanded row count and label order are known,
- each repeated row has one mapped HealthKit activity row,
- row distance and elapsed timing are within the active Gate B scoring tolerance,
- no residual movement overlaps the time or distance window of an unresolved Work/Recovery row, and
- pause evidence is absent or covered by an already-approved timer rule.

Fallback instead of ending the repeat block when any of these are true:

- `repeat-expansion-unresolved`: planned repeat count, order, or expansion cannot be read.
- `repeat-row-map-incomplete`: one or more expanded Work/Recovery rows do not have a complete contiguous HealthKit activity row.
- `repeat-label-order-conflict`: WorkoutKit, HealthKit activity order, and offline FIT labels cannot be reconciled without guessing.
- `tail-overlaps-planned-row`: residual movement overlaps a planned Work/Recovery or Cooldown row.

## Fixed Cooldown Exhaustion

A fixed final `Cooldown` is exhausted only after the final planned fixed cooldown row has a resolved end boundary. The resolved boundary must come from the planned fixed cooldown shape plus a complete mapped HealthKit activity row, with row distance/timing inside Gate B tolerance.

Treat the cooldown as not exhausted when:

- the cooldown is open-ended,
- the fixed cooldown row has no complete mapped HealthKit activity row,
- the row boundary is inferred only from leftover session distance/time,
- pause overlap cannot be assigned under an approved timer rule, or
- FIT residual conflicts with the mapped HealthKit activity rows.

Fallback reasons:

- `final-row-open-cooldown`
- `final-fixed-row-unresolved`
- `cooldown-map-incomplete`
- `fit-tail-residual-conflict`
- `paused-cooldown-timer-unapproved`

## Open / Extra Tail

Residual movement becomes `Open / Extra` only after every planned fixed row is exhausted. The residual must be positive, above the scoring threshold used by the Gate B script, and outside all planned Work/Recovery/Cooldown row windows.

Do not create `Open / Extra` when:

- the final planned row is `Cooldown(Open)`,
- a planned fixed row remains unresolved,
- the residual is negative, zero, below threshold, or only a reconstruction artifact,
- the residual overlaps a planned row boundary,
- the only support is FIT session-minus-lap residual without matching HealthKit activity evidence, or
- the workout is a duplicate, no-plan, same-day extra, summary-only, or guard-unknown case.

Fallback reasons:

- `tail-below-threshold`
- `tail-overlaps-planned-row`
- `open-tail-healthkit-evidence-missing`
- `fit-tail-residual-conflict`
- `guard-unknown-repeat-tail`

## Tie-Breakers

When FIT, WorkoutKit, and HealthKit activity rows disagree:

- Prefer WorkoutKit for planned row labels and order.
- Prefer HealthKit activity rows for completed measured boundaries, distance, duration, and pause overlap.
- Use FIT only as offline validation evidence for row-level scoring and fixture review.
- If WorkoutKit planned rows and HealthKit activity rows agree but FIT disagrees, keep the row debug-supported only when the mismatch is inside Gate B tolerance; otherwise block with `fit-row-validation-conflict`.
- If FIT and WorkoutKit agree but HealthKit activity rows are missing or incomplete, block with `healthkit-activity-row-missing`.
- If FIT and HealthKit agree but WorkoutKit repeat expansion or final fixed row shape is missing, block with `workoutkit-plan-missing`.
- If labels can be made to pass only by reclassifying a planned Work/Recovery/Cooldown row as `Open / Extra`, block with `repeat-label-order-conflict`.

## Unsupported Guard Shapes

Keep these shapes blocked from normal detail and interval-row analytics:

- open final cooldown with invented Open/Extra tail,
- unresolved fixed cooldown followed by inferred tail,
- paused repeat-tail without approved active/timer and pause-overlap rule,
- residual movement crossing Work, Recovery, or Cooldown row boundaries,
- recovery-containing broad Open/Extra tails not covered by a named narrow gate,
- duplicate workouts, no-plan workouts, same-day extras, summary-only exports, and guard-unknown workouts,
- any case needing FIT, screenshots, or file imports as runtime truth.

## Narrow Debug/Export Candidate

Candidate shape for a paused repeat fixed-tail `Open / Extra` prototype:

`Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`

This is docs/debug-only. It is not normal workout detail behavior, interval-row analytics, broad Gate B promotion, FIT runtime ingestion, or HealthFit dependency.

Required guards:

- WorkoutKit plan expands the repeat block into ordered `Warmup`, numbered `Work`/`Recovery`, and a fixed final `Cooldown`; repeat count, labels, goals, and final cooldown fixed distance or duration are visible.
- Every expanded `Work`/`Recovery` row and the final fixed `Cooldown` maps one-to-one to a complete contiguous HealthKit activity row with distance and elapsed boundary evidence.
- The final fixed `Cooldown` has a resolved end boundary from planned fixed-row shape plus mapped HealthKit activity evidence; it is not inferred only from session leftover distance or time.
- The residual tail starts strictly after the resolved final cooldown boundary, is positive and above the tail threshold, and does not overlap any planned `Work`, `Recovery`, or `Cooldown` row.
- Pause events are absent, or all pause/resume windows are paired, assigned to exact row windows, and covered by the approved active/timer pause-overlap rule; no pause overlap may cross a planned-row boundary.
- FIT may confirm row-level labels, distances, and residuals inside Gate B tolerance, but cannot create runtime truth or rescue missing WorkoutKit/HealthKit evidence.

Fallback reasons to preserve:

- `repeat-expansion-unresolved`
- `repeat-row-map-incomplete`
- `repeat-label-order-conflict`
- `final-row-open-cooldown`
- `final-fixed-row-unresolved`
- `cooldown-map-incomplete`
- `tail-below-threshold`
- `tail-overlaps-planned-row`
- `open-tail-healthkit-evidence-missing`
- `paused-cooldown-timer-unapproved`
- `fit-tail-residual-conflict`
- `fit-row-validation-conflict`
- `healthkit-activity-row-missing`
- `workoutkit-plan-missing`
- `guard-unknown-repeat-tail`

Positive fixtures before Swift changes:

- A known clean no-pause repeat fixed-cooldown tail fixture, currently June 10, must stay supported and show expanded repeat rows, fixed final `Cooldown`, and post-final-row `Open / Extra`.
- At least one true paused repeat fixed-tail candidate must show paired pause windows, active/timer diagnostics, final fixed cooldown exhaustion, and a post-final-row tail that stays above threshold without row overlap.
- If the paused candidate includes Recovery rows, evidence must prove those Recovery rows remain planned repeat rows and are not reclassified as tail.

Negative controls before Swift changes:

- Open final cooldown repeat fixtures, currently May 20 and June 3, must stay `Cooldown` through workout end and must not invent `Open / Extra`.
- Unresolved fixed-cooldown, missing HealthKit activity row, summary-only, duplicate/no-plan/same-day-extra, guard-unknown, below-threshold residual, and FIT-conflict cases must produce stable blocked fallback reasons.
- Broad recovery-containing tails outside a named narrow gate remain blocked.

Evidence that must be visible before Swift changes:

- Raw HealthKit Debug or parity packet rows showing WorkoutKit expanded plan order, planned row goals, repeat indexes, mapped HealthKit activity boundaries, distance, elapsed duration, pause overlap, active/timer duration, and fallback reasons.
- Row-level FIT scorecard output showing label and boundary agreement or the exact conflict reason; FIT remains offline validation evidence only.
- Open-cooldown controls and unresolved/ambiguous controls in the same review packet so the candidate cannot pass by broad tail inference.
- A short review note naming the exact candidate workout IDs, positive fixtures, negative controls, tolerance used, and any remaining blocker.

## Scoring Script

After any Gate B scoring, fallback, or rollup change that uses these rules, rerun:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py
```

Use the generated row-level scorecard to confirm that clean approved fixtures stay supported, ambiguous repeat-tail fixtures receive explicit fallback reasons, and broad Gate B promotion remains blocked.

If the two-gate rollup inputs also change, run the summary-level scorer first:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py
```

`score_gate_b_custom_workout_fit.py` overwrites the Gate B scorecard JSON and markdown files, so treat it as a deliberate regeneration step.
