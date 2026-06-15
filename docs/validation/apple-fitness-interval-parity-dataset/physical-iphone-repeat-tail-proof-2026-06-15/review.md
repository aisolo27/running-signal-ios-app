# Physical iPhone Repeat Tail Proof - 2026-06-15

## Scope

Physical-iPhone proof for the debug/export-only ambiguous repeat-tail prototype installed from commit `4c0a20e`.

This review covers the June 10, 2026 `Wednesday Interval (6kmm)` custom workout:

- `Warmup(2 km)`
- `4x` repeat block:
  - `Work(400 m)`
  - `Recovery(105 s)`
- `Cooldown(2.50 km)`
- inferred `Open / Extra` after the fixed final Cooldown

Normal workout detail remains blocked for this class. These rows are Parity Lab/export-only.

## Archived Inputs

- `june-10-2026-raw-healthkit-debug-export.md`
- `june-10-2026-parity-packet.json`

Original Downloads filenames:

- `/Users/adrielsolorzano/Downloads/text-E6974AD7CE8B-1.txt`
- `/Users/adrielsolorzano/Downloads/text-60AE66140830-1.txt`

## Result

Pass.

The physical-iPhone exports confirm the intended repeat-tail debug behavior:

- `customWorkoutComparisonSummary.status == supported`
- `fallbackReasons == []`
- `rowCount == 10`
- row confidences are all `supported`
- `tailAmbiguity == fixedCooldownFollowedByPossibleOpenExtraTail`
- `productionIntervalBehaviorChanged == false`
- `normalWorkoutUIChanged == false`
- `usesFITRuntimeTruth == false`

The candidate row export confirms the expected visible debug rows:

| Row | Label | Mapping | Distance | Duration |
|---:|---|---|---:|---:|
| 1 | Warmup | mappedByPlannedStepOrder | 2008.0 m | 749.9 s |
| 2 | Work 1 | mappedByPlannedStepOrder | 405.7 m | 90.3 s |
| 3 | Recovery 1 | mappedByPlannedStepOrder | 160.2 m | 104.1 s |
| 4 | Work 2 | mappedByPlannedStepOrder | 408.9 m | 90.5 s |
| 5 | Recovery 2 | mappedByPlannedStepOrder | 164.2 m | 104.7 s |
| 6 | Work 3 | mappedByPlannedStepOrder | 408.8 m | 88.0 s |
| 7 | Recovery 3 | mappedByPlannedStepOrder | 147.7 m | 104.2 s |
| 8 | Work 4 | mappedByPlannedStepOrder | 406.5 m | 86.9 s |
| 9 | Recovery 4 | mappedByPlannedStepOrder | 167.5 m | 104.3 s |
| 10 | Cooldown | mappedByPlannedStepOrder | 2504.9 m | 911.2 s |
| 11 | Open / Extra | inferredOpenTailFromWorkoutEnd | 5.2 m | 5.6 s |

The active-time scorer reports:

- paired pauses: `0`
- total paired pause: `0.0 s`
- candidate row count: `11`
- Open tail row count: `1`

## Interpretation

This closes the required physical proof for the no-pause repeat-tail debug prototype.

The important safety checks held:

- Repeat rows expanded in order as Work/Recovery rows.
- The final fixed `Cooldown` remained `Cooldown`.
- `Open / Extra` was inferred only after the final mapped Cooldown activity boundary.
- No pause/timer rule was needed for this proof because paired pauses were absent.
- FIT remained offline evidence only and was not used as runtime truth.
- Normal workout detail was not promoted.

## Next

The remaining correctness-lock work should move to deciding whether enough debug/export evidence now exists for a later, explicit normal-detail promotion discussion, or whether another blocked subclass needs proof first. No normal-detail promotion is approved by this review.
