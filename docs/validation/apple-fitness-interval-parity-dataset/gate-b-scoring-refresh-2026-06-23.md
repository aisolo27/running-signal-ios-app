# Gate B Scoring Refresh

Last updated: 2026-06-23

## Scope

AIS-27 reran the FIT-backed Gate B scoring scripts after the paused-repeat, recovery-tail, and repeat-tail cleanup work.

This is offline validation only. It does not change runtime reconstruction, normal workout detail gates, HealthKit reads, FIT usage, or app UI.

## Commands

Run from the repo root:

```bash
python3 docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py
python3 docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py
```

Validation after the refresh:

```bash
git diff --check
```

## Result

Both scoring scripts completed successfully.

The generated Gate B scorecard files were already current, so rerunning the scripts produced no file diff:

- `gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.json`
- `gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.md`

The two-gate validator still reports:

- Runtime source: HealthKit/WorkoutKit.
- Validation oracle: FIT offline reference.
- FIT runtime use allowed: false.
- Broad production promotion: not supported.
- Gate B custom multi-step decision: blocked pending separate gate.

The Gate B custom workout FIT scorecard still reports:

- Structured interval rows: 20 total, 20 FIT matched, 18 equivalent, 2 inconclusive.
- Warmup/work/cooldown rows: 5 total, 5 FIT matched, 3 equivalent, 2 inconclusive.
- Open/Extra tail rows in Gate B evidence: 4 total.
- Repeat-block rows where FIT workout-step count differs from expanded plan: 18.
- Gate B production promotion: not approved.
- Gate B Swift prototype now: not approved.

## Current Interpretation

Current promotions do not change Gate B's offline scorecard conclusion.

The eight narrow normal-detail gates remain separate, evidence-backed exceptions. Gate B still needs row-level FIT label/error extraction and per-shape rule decisions before any broad structured interval or warmup/work/cooldown promotion.

## Next Work

AIS-28 should review the remaining warmup/work/cooldown outliers, especially:

- `2026-03-19T16:51:00Z`
- `2026-05-29T11:49:28Z`

Each outlier should be classified as candidate, blocked, duplicate/no-plan, or needs new evidence.

## Boundaries

- HealthKit remains read-only runtime truth.
- WorkoutKit remains optional planned-structure evidence.
- FIT remains offline validation evidence only.
- No FIT import, file ingestion, HealthFit dependency, new HealthKit permissions, coaching, VDOT, training load, recovery scoring, race prediction, WeatherKit, or interval-row analytics.
