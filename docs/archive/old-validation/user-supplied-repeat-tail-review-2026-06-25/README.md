# June 25, 2026 User-Supplied Repeat Tail Review

Workout: `Thursday Interval 5km`

## Inputs

- `june-25-2026-raw-healthkit-debug-reexport-2026-06-25T1633Z.txt`
- `june-25-2026-parity-packet-reexport-2026-06-25T1633Z.txt`
- `2026-06-25-074953-Outdoor-Running-Adriels-Apple-Watch.fit`
- `apple-fitness-template.png`
- `apple-fitness-summary.png`
- `apple-fitness-intervals.png`

## Apple Fitness Shape

- `Warmup`: 2.00 km
- Repeat 5x: `Work` 400 m plus `Recovery` 2:00
- Fixed `Cooldown`: 1.00 km
- Final `Open`: 10 m / 00:08 row

## RunSignal Current-Build Evidence

- `plannedExpandedRowCount`: 12
- `candidateRowCount`: 13
- `openTailRowCount`: 1
- `tailStatus`: `open-extra-tail-present`
- `fixedRowExhaustionStatus`: `fixed-rows-exhausted-before-tail`
- Tail duration: 8.25 s
- Tail distance: 10.33 m
- `pairedPauseCount`: 0
- `totalPairedPauseSeconds`: 0.0
- `fallbackReasons`: `openExtraTailAmbiguous`
- `fallbackReasonLabels`: `Open / Extra tail handling is ambiguous for this workout shape.`
- `customWorkoutComparisonSummary.status`: `open-tail-needs-rule`

## FIT Offline Evidence

- Session count: 1
- Lap count: 12
- Workout step count: 5
- Session elapsed: 2206.748 s
- Session distance: 5991.91 m
- Lap elapsed total: 2198.493 s
- Lap distance total: 5958.98 m
- Session-minus-laps residual: 8.255 s and 32.93 m

FIT remains offline validation evidence only. It does not replace HealthKit or WorkoutKit runtime truth.

## Validation

Strict file validation:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/validate_parity_export_consistency.py \
  --require-readable-fallback-labels \
  docs/archive/old-validation/user-supplied-repeat-tail-review-2026-06-25/june-25-2026-parity-packet-reexport-2026-06-25T1633Z.txt \
  docs/archive/old-validation/user-supplied-repeat-tail-review-2026-06-25/june-25-2026-raw-healthkit-debug-reexport-2026-06-25T1633Z.txt
```

Result:

```text
Validated 2 parity export payload(s) in 2 file(s); skipped 0 JSON/text file(s) without debug parity fields.
```

Strict folder validation:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/validate_parity_export_consistency.py \
  --require-readable-fallback-labels \
  docs/archive/old-validation/user-supplied-repeat-tail-review-2026-06-25
```

Result:

```text
Validated 2 parity export payload(s) in 2 file(s); skipped 1 JSON/text file(s) without debug parity fields.
```

## Decision

This is strict-validator-clean current-build evidence for a no-pause repeat fixed-cooldown plus `Open / Extra` tail shape, with FIT offline tail evidence.

This does not satisfy the active paired-pause fixed-tail blocker because the candidate scorer reports `pairedPauseCount == 0`. Do not use this folder as rung 2 evidence for true paused repeat fixed-tail `Open / Extra`.
