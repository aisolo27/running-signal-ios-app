# Paused Repeat Open/Extra Debug Prototype Plan

Last updated: 2026-06-24

Scope: plan the next docs/debug-only prototype for true paused repeat fixed-tail `Open / Extra` cases. This does not approve Swift implementation, normal workout detail promotion, interval-row analytics, FIT runtime usage, FIT import, HealthFit dependency, or file-based workout ingestion.

Runtime truth remains HealthKit plus optional WorkoutKit planned structure. FIT remains an offline validation oracle only.

## Candidate Shape

The only candidate shape for the next debug/export prototype is:

`Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`

with paired pause evidence somewhere inside the mapped activity rows.

This is deliberately narrower than broad Gate B. It does not cover open final cooldowns, unresolved fixed cooldowns, recovery-containing broad tails, no-plan workouts, duplicate/same-day extra workouts, summary-only workouts, or any case where `Open / Extra` can be created only by relabeling a planned Work, Recovery, or Cooldown row.

## Entry Guards

A workout can enter the debug/export prototype only when all of these are true:

1. WorkoutKit planned structure is present and expands to a known ordered sequence of Warmup, repeated Work/Recovery rows, and one fixed final Cooldown.
2. Every expanded planned row maps to one complete contiguous HealthKit activity row.
3. The final fixed Cooldown has a resolved end boundary from its mapped HealthKit activity row.
4. Positive residual movement remains after the resolved fixed Cooldown boundary and exceeds the Gate B tail threshold.
5. The residual does not overlap any planned Work, Recovery, or Cooldown activity window.
6. Pause/resume evidence is paired and assignable to row windows by the existing pause-window state machine.
7. Pause overlap does not cross planned-row boundaries in a way that changes labels or row ordering.
8. FIT row-level lap/workout-step evidence can validate label, elapsed duration, timer duration, distance, and tail residual offline without becoming runtime truth.
9. A matching open-cooldown control remains labeled `Cooldown` through workout end and does not create `Open / Extra`.

## Required Debug/Export Fields

Raw HealthKit Debug, Parity Lab candidate rows, and parity packet structured comparison should expose the same facts for this prototype:

- row count and planned expanded row count
- row labels and planned label source
- row start and end offsets
- elapsed duration
- pause overlap
- active/timer duration
- duration display rule
- distance
- activity-row mapping status
- final fixed-row exhaustion status
- tail status
- tail elapsed duration and distance
- fallback reasons
- safety flags
- FIT validation status as offline evidence only

The output must make blocked cases visible. Do not silently omit unsupported rows when the prototype rejects a workout.

## Fallback Reasons

Use stable reasons that can be tested and scored:

- `repeat-expansion-unresolved`
- `repeat-row-map-incomplete`
- `repeat-label-order-conflict`
- `final-row-open-cooldown`
- `final-fixed-row-unresolved`
- `cooldown-map-incomplete`
- `tail-below-threshold`
- `tail-overlaps-planned-row`
- `open-tail-healthkit-evidence-missing`
- `unpaired-pause-events`
- `cross-row-pause-overlap`
- `paused-cooldown-timer-unapproved`
- `fit-row-validation-conflict`
- `fit-tail-residual-conflict`
- `guard-unknown-repeat-tail`
- `fit-runtime-truth-disallowed`

If existing Swift enums already use equivalent names, keep the existing enum names and map exports/docs to these labels only if the codebase already has a display-label pattern.

## Regression Checks

Before any normal-detail promotion discussion, tests must prove:

1. The exact supported shape can pass in debug/export output.
2. A similar paused repeat shape ending in `Cooldown(Open)` does not create `Open / Extra`.
3. Missing WorkoutKit repeat expansion blocks.
4. Missing or incomplete HealthKit activity rows block.
5. Missing fixed Cooldown exhaustion blocks.
6. Tail residual below threshold blocks.
7. Tail residual overlapping a planned row blocks.
8. Unpaired pauses block.
9. Cross-row pause overlap blocks.
10. FIT-only tail evidence blocks and is reported as validation evidence only.
11. Already approved clean no-pause repeat-tail fixtures stay supported.
12. Already approved narrow paused open-cooldown fixtures stay supported and unchanged.
13. Broad Gate B rollup stays blocked.

## Scorecard Workflow

After any debug/export prototype or fallback-rule change:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py
```

Confirm the regenerated scorecards show:

- approved clean fixtures still supported,
- paused fixed-tail candidate fixtures only supported when every entry guard passes,
- unsupported paused tail controls receive explicit fallback reasons,
- open-cooldown controls remain `Cooldown`,
- broad Gate B promotion remains blocked.

If two-gate rollup inputs change, run the summary scorer first:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py
```

These scripts overwrite scorecard JSON/markdown files, so treat them as deliberate regeneration steps.

## Physical iPhone Proof Criteria

Physical proof is required only after app behavior changes. A real promotion task must include:

1. `swift test --package-path RunningWorkoutAnalysisPackage`
2. XcodeBuildMCP `session_show_defaults` before simulator build/run.
3. Simulator smoke check with the `RunningWorkoutAnalysis` scheme.
4. Physical iPhone install/launch proof.
5. Current-build Raw HealthKit Debug export for the exact candidate workout.
6. Current-build parity packet export for the exact candidate workout.
7. Proof that FIT appears only as offline validation evidence, not app input.
8. A repo-local proof folder with README/review notes.
9. `docs/project-state/project-status.md` and `docs/project-state/accuracy-ledger.md` updates.

Normal detail remains blocked unless a later task separately approves promotion after the debug/export prototype, scorecards, regression checks, and physical proof all pass.

## Stop Conditions

Stop and keep the shape blocked if any of these occur:

- WorkoutKit planned repeat expansion is missing or ambiguous.
- Any planned row lacks a complete mapped HealthKit activity row.
- The final fixed Cooldown boundary is inferred only from leftover time/distance.
- The tail is FIT-only, below threshold, negative, or overlaps a planned row.
- Pause events are duplicate, dangling, unpaired, cross-row, or otherwise caveated.
- Passing requires relabeling a planned Work, Recovery, or Cooldown row as `Open / Extra`.
- The change would affect normal workout detail before separate promotion approval.
- The change would feed interval-row analytics.

## Next Implementation Handoff

If implementation is explicitly approved later, start with the debug/export path only:

- inspect `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/DiagnosticsExport.swift`,
- inspect the `CustomWorkoutComparisonModel` and candidate-row tests that already cover Raw HealthKit Debug and parity packet consistency,
- add the smallest prototype branch needed to emit the fields above,
- add focused fallback tests before running scorecard regeneration.
