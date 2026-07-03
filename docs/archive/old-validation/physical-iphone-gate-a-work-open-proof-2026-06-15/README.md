# Physical iPhone Gate A Work/Open Proof

Captured: 2026-06-15

## Source Files

These files were copied from `/Users/adrielsolorzano/Downloads/` so the Downloads copies can be deleted after review.

| Workout date | Workout | Archived files |
| --- | --- | --- |
| 2026-05-26 | Tuesday Easy 6.45km | `raw-exports/2026-05-26-raw-healthkit-debug.txt`, `raw-exports/2026-05-26-parity-packet.txt` |
| 2026-06-01 | Monday easy 6.45km | `raw-exports/2026-06-01-raw-healthkit-debug.txt`, `raw-exports/2026-06-01-parity-packet.txt` |
| 2026-06-02 | Tuesday Easy 5.65km | `raw-exports/2026-06-02-raw-healthkit-debug.txt`, `raw-exports/2026-06-02-parity-packet.txt` |
| 2026-06-04 | Thursday Recovery 5.65k | `raw-exports/2026-06-04-raw-healthkit-debug.txt`, `raw-exports/2026-06-04-parity-packet.txt` |
| 2026-06-12 | Friday Easy 5km | `raw-exports/2026-06-12-raw-healthkit-debug.txt`, `raw-exports/2026-06-12-parity-packet.txt` |

## Review Result

All five workouts are the intended Gate A simple fixed-distance `Work > Open` shape:

- WorkoutKit plan is available.
- Expanded planned step count is one `Work` step.
- HealthKit activity count is one.
- Candidate rows are `Work 1` plus inferred `Open / Extra`.
- Candidate rule scorer reports `candidate-rule-scoreable`.
- Normal workout UI and production interval behavior remain unchanged.

The first physical export review exposed a debug-gate mismatch: all five structured comparisons still reported `open-tail-needs-rule` with fallback `openExtraTailAmbiguous`.

The cause is real WorkoutKit one-step blocks exporting the single `Work` step with `repeatBlockIndex: 1` and `repeatIndex: 1` (`Block 1: 1x, 1 step(s)`). That is not a real repeat block, but the first Gate A prototype implementation required repeat metadata to be nil. The follow-up fix allows `repeatIndex == 1` while continuing to block true repeated rows where `repeatIndex > 1`.

## Current Status

These exports prove the real physical-iPhone packet shape and caught the one-iteration block metadata issue. They should be kept as evidence.

Fresh fixed-build exports for 2026-06-12 are archived in `fixed-build-exports/`:

- `2026-06-12-raw-healthkit-debug-fixed.txt`
- `2026-06-12-parity-packet-fixed.txt`

Both fixed-build exports confirm the intended Gate A debug result:

- `customWorkoutComparisonSummary.status == supported`
- fallback reasons are empty / `None`
- row confidence is `supported`
- candidate rows remain `Work 1` and inferred `Open / Extra`
- normal workout UI and production interval behavior remain unchanged

Fresh post-promotion exports for 2026-06-12 are archived in `normal-detail-promotion-exports/`:

- `2026-06-12-raw-healthkit-debug-normal-detail-promotion.txt`
- `2026-06-12-parity-packet-normal-detail-promotion.json`

These were captured after commit `466a23a` promoted the exact Gate A simple fixed-distance `Work > Open / Extra` class into normal workout detail. They confirm:

- Raw HealthKit Debug generated at `2026-06-15T04:11:39Z` for `Friday Easy 5km`.
- Workout date is Jun 12, 2026, duration is `32:21`, distance is `5.04 km`.
- WorkoutKit plan is one `Work` step with a `5 km` goal and one HealthKit activity row.
- Normal reconstructed intervals are `Work 1` and `Open / Extra`.
- Parity packet `customWorkoutComparisonSummary.status == supported`.
- Fallback reasons are empty / `None`.
- Guard status remains narrow: no FIT runtime truth and no broad production interval behavior promotion.
