# Guard-Case Collection Plan

Generated: 2026-06-12

This is a docs-only plan for physical-iPhone evidence collection. It does not change production interval reconstruction, fixed-distance boundary logic, normal workout UI, or scorer behavior.

## Purpose

The current dataset shows a real tension:

- Drift cases May 26, June 1, and June 12 improve when candidate strategies move the Work boundary later.
- Guard cases June 2 and June 4 regress when the same later-boundary strategies are applied.
- The boundary pattern investigation found no public-API observable feature that cleanly separates the drift cases from the guard cases.
- The only clean separator so far is Apple Fitness/manual delta, which is valid for offline validation but not runtime logic.

Before any production boundary experiment, collect a stronger guard/pass fixture set.

## Target Collection

Collect 5-10 additional simple fixed-distance Work + real Open / Extra tail workouts from the physical iPhone before revisiting production boundary logic.

Prioritize:

- Simple planned custom runs with one fixed-distance `Work` step followed by brief continued running.
- Workouts where Apple Fitness shows both `Work` and `Open`.
- Workouts where current RunSignal may already be close to Apple Fitness, similar to June 2 and June 4.
- Target distances around 5.00 km, 5.65 km, 6.45 km, and 7.25 km when available.
- Easy runs and similar steady planned runs.

Do not use complex repeated interval workouts as simple guard cases. Keep June 3 and June 5 as special fixtures. Keep April 28 as evidence recovery / single-tail reference, not main tuning evidence.

## Case Classification

Count a workout as a guard case when:

- The plan is simple fixed-distance Work followed by real Open / Extra.
- Apple Fitness shows both `Work` and `Open`.
- RunSignal current Work/Open rows are already within preferred or temporary tolerance.
- A later-boundary strategy would risk making either row worse.
- The parity packet includes boundary diagnostics for the Work row and tail diagnostics for the Open / Extra row.

Count a workout as a drift case when:

- The plan is simple fixed-distance Work followed by real Open / Extra.
- Apple Fitness shows both `Work` and `Open`.
- RunSignal current Work ends early and Open / Extra is too long by more than preferred tolerance.
- The same direction appears in both Work and Open timing deltas.
- Boundary diagnostics are present.

Treat as special, not simple guard/drift:

- Repeated Work/Recovery interval structures.
- Warmup + Work + fixed-distance Cooldown + Open structures.
- Planned open cooldown cases.
- Workouts with missing WorkoutKit plan data, missing boundary diagnostics, missing Apple Fitness reference rows, or ambiguous manual edits/pauses.
- April 28-style evidence recovery cases.

## Phone Export Checklist

For each collected workout, save:

- RunSignal parity packet JSON after physical-device force re-enrich.
- Raw HealthKit Debug markdown export if available.
- Apple Fitness screenshots showing the interval rows or split rows.
- Manually recorded Apple Fitness rows when screenshots are incomplete.
- Workout date.
- Workout source/device.
- WorkoutKit plan name.
- Goal distance.
- Whether Apple Fitness shows Open.
- Whether RunSignal shows Open / Extra.
- Work row distance and time.
- Open row distance and time.
- Boundary diagnostics availability.
- Tail diagnostics availability.
- Any obvious pause, GPS issue, treadmill/manual edit, or continued-running note.

Required parity packet fields:

- `packetVersion`
- `evidenceSource`
- `forceReenrichResult.freshQueryReturnedWorkout`
- `diagnosticsWarnings`
- `workout.id`
- `workout.startDate`
- `workout.distanceMeters`
- `workout.durationSeconds`
- `workoutKitPlanAudit`
- `reconstructedIntervals`
- Work row `boundaryDiagnostics`
- Open / Extra row `tailDiagnostics`
- `evidenceCounts`

## Storage And Naming

Create or update one folder per workout:

```text
docs/validation/apple-fitness-interval-parity-dataset/YYYY-MM-DD-<workout-slug>/
```

Save RunSignal exports under:

```text
docs/validation/apple-fitness-interval-parity-dataset/YYYY-MM-DD-<workout-slug>/exports/runsignal-diagnostics/
```

Use these filenames:

```text
runsignal-parity-packet-YYYY-MM-DD.json
runsignal-raw-healthkit-debug-YYYY-MM-DD.md
```

Save Apple Fitness screenshots under:

```text
docs/validation/apple-fitness-interval-parity-dataset/YYYY-MM-DD-<workout-slug>/screenshots/apple-fitness/
```

Record visible Apple Fitness rows in:

```text
expected_apple_fitness_intervals.md
```

## Apple Fitness Manual Rows

For each visible row, record:

- Label exactly as Apple Fitness shows it.
- Distance exactly as Apple Fitness displays it.
- Time exactly as Apple Fitness displays it.
- Any visible pace, heart-rate, or row detail if already shown.
- Screenshot filename used as evidence.

Do not infer hidden rows or invisible precision from screenshots.

## Revisit Criteria

Revisit candidate boundary scoring after either:

- At least 5 additional guard cases are collected with complete parity packets and Apple Fitness references, or
- 10 total additional simple Work + Open tail examples are collected across guard and drift categories.

Only consider a production boundary experiment if a public-API observable rule:

- Improves all current and newly collected drift cases.
- Preserves all guard cases within their existing tolerances.
- Does not regress June 3 or June 5 special fixtures.
- Does not depend on Apple Fitness/manual expected values as runtime logic.
- Does not depend on private Apple Fitness-only behavior.
- Is explainable from WorkoutKit and HealthKit packet fields.

Keep production boundary logic blocked if:

- No public-API separator emerges after 5-10 more examples.
- A candidate improves drift cases but regresses any guard case.
- A candidate only works by using Apple Fitness/manual expected Open values.
- Boundary diagnostics are missing or inconsistent.
- The evidence relies on complex special fixtures rather than simple Work + Open examples.

## Stopping Point For This Phase

Do not let this become endless research. After 5-10 more simple Work + Open tail examples, rerun the scorer and update the scorecard.

If there is still no public-API separator, the product decision should be:

- Keep current public reconstruction.
- Keep exact Apple Fitness boundary matching as a documented limitation.
- Show confidence/delta language only in debug surfaces if needed.
- Do not chase Apple Fitness exactness in production interval logic for this phase.
