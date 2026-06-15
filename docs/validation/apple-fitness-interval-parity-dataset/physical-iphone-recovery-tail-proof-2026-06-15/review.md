# Physical iPhone Recovery Tail Proof - 2026-06-15

## Scope

Physical-iPhone proof for the debug/export-only recovery-containing Open/Extra tail prototype installed from commit `a0855ad`.

This review covers the May 1, 2026 `Friday Tempo 9km` custom workout:

- `Warmup(2 km)`
- `Recovery(120 s)`
- `Work(5 km)`
- `Cooldown(2 km)`
- inferred `Open / Extra` after the final fixed Cooldown

Normal workout detail remains blocked for this class. These rows are Parity Lab/export-only.

## Archived Inputs

- `may-1-2026-raw-healthkit-debug-export.md`
- `may-1-2026-parity-packet.json`

Original Downloads filenames:

- `/Users/adrielsolorzano/Downloads/text-E564EE6B4BD4-1.txt`
- `/Users/adrielsolorzano/Downloads/text-535BB5FF554A-1.txt`

## Result

Pass.

The physical-iPhone exports confirm the intended recovery-tail behavior:

- `customWorkoutComparisonSummary.status == supported`
- `fallbackReasons == []`
- `rowCount == 4`
- row confidences are all `supported`
- `tailAmbiguity == fixedCooldownFollowedByPossibleOpenExtraTail`
- `productionIntervalBehaviorChanged == false`
- `normalWorkoutUIChanged == false`
- `usesFITRuntimeTruth == false`

The candidate row export also confirms the expected visible debug rows:

| Row | Label | Mapping | Distance | Duration |
|---:|---|---|---:|---:|
| 1 | Warmup | mappedByPlannedStepOrder | 2009.1 m | 772.5 s |
| 2 | Recovery 1 | mappedByPlannedStepOrder | 194.8 m | 119.5 s |
| 3 | Work 1 | mappedByPlannedStepOrder | 5005.7 m | 1445.4 s |
| 4 | Cooldown | mappedByPlannedStepOrder | 1995.9 m | 834.0 s |
| 5 | Open / Extra | inferredOpenTailFromWorkoutEnd | 16.6 m | 9.9 s |

The active-time scorer reports:

- paired pauses: `2`
- total paired pause: `232.8 s`
- Work pause overlap: `141.0 s`
- Cooldown pause overlap: `91.8 s`
- Open / Extra tail active time: `9.9 s`

## Interpretation

This closes the required physical proof for the recovery-containing Open/Extra tail debug prototype.

The important safety checks held:

- Recovery stayed `Recovery 1`; it was not relabeled as tail.
- The Open / Extra row was inferred only after the fixed final Cooldown activity boundary.
- FIT remained offline evidence only and was not used as runtime truth.
- Normal workout detail was not promoted.

## Next

Proceed to the next blocked correctness-lock shape: ambiguous repeat-tail proof/prototype discussion, still debug/export-only unless a later task explicitly approves normal-detail promotion.
