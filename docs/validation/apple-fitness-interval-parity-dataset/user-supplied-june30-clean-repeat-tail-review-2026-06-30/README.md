# June 30 Clean Repeat Fixed-Cooldown Tail Review

Date reviewed: 2026-06-30

## Workout

- Workout ID: `AE4EC20C-4F58-4F0B-82E3-7372B977B67E`
- Apple Fitness display name: `Tuesday interval (6.2km)`
- Shape: `Warmup 2 km > 10x Work 200 m / Recovery 90 s > Cooldown 2 km > Open / Extra`
- Workout summary: 47:09, 7.22 km, 6:32/km, 146 bpm

## Evidence Files

- Apple Fitness screenshots: `june 30 v1.jpg`, `june 30 v2.PNG`, `june 30 v3.PNG`, `june 30 v4.PNG`
- Raw HealthKit Debug export: `raw-healthkit-debug-markdown.txt`
- Parity packet JSON: `parity-packet.json`
- Selected screen-recording frames: `frames/`
- Full screen recording was reviewed from Downloads but not copied into the repo because it is 165 MB.

## Findings

- Apple Fitness shows 23 rows: warmup, 10 work rows, 10 recovery rows, cooldown, and `Open`.
- The app/export candidate resolver shows 22 planned rows plus one inferred `Open / Extra` tail.
- The candidate rows match the visible Apple Fitness sequence closely:
  - `Cooldown`: 2.01 km, 12:34, 6:15/km.
  - `Open / Extra`: 32.9 m, 22.3 s, 11:17/km.
  - Recovery distances and durations match the Apple Fitness continuation screenshots within expected rounding.
- The screen recording confirms the row evidence is visible and coherent in Raw HealthKit Debug.

## Mismatch To Retire

The physical export and screen recording still show the structured comparison status as blocked:

- `status`: `open-tail-needs-rule`
- `fallbackReasons`: `openExtraTailAmbiguous`
- `promotesProductionBehavior`: `false`

Current source now has a regression test for this exact June 30 shape:

- `debugCustomWorkoutComparisonBridgeSupportsJune30TenRepeatFixedCooldownTail`

`swift test --package-path RunningWorkoutAnalysisPackage` passed after adding the test, which means a fresh current-build install and re-export should be used before treating the old blocked JSON as current proof.

## Verdict

This is strong supporting evidence for the proven clean no-pause repeat block with fixed cooldown plus inferred `Open / Extra` tail. The remaining task is not HealthKit math; it is to regenerate physical-iPhone Raw Debug/Parity exports from the current build and confirm the status layer reports `supported`.
