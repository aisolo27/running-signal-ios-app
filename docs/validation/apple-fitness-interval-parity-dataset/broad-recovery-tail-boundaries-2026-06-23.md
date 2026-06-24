# Broad Recovery-Tail Boundaries

Last updated: 2026-06-23

## Decision

Broad recovery-containing `Open / Extra` tail behavior remains blocked from normal-detail promotion.

The only approved recovery-containing normal-detail gate is the narrow May 1-style shape already physically proven:

`Warmup(fixed) > Recovery(fixed) > Work(fixed) > Cooldown(fixed) > inferred Open / Extra`

This rule does not approve recovery rows in arbitrary order, repeat blocks with recovery rows, open final cooldowns, missing activity rows, partial recovery rows, or tail inference from count alignment alone.

## Approved Narrow Shape

The approved shape requires:

- WorkoutKit planned rows in the exact supported order: `Warmup`, `Recovery`, `Work`, `Cooldown`.
- No repeat block metadata on any planned row.
- Every planned row is fixed-distance or fixed-time, with no open final cooldown.
- Every planned row maps to one complete, contiguous HealthKit activity row.
- HealthKit activity rows carry distance evidence.
- The final fixed cooldown ends before workout end.
- The inferred `Open / Extra` tail is positive and above the existing threshold.
- Pause evidence is absent or resolves into paired, row-assignable pause windows.

## Broad Blocked Cases

Keep broad recovery-tail behavior blocked when:

- Recovery appears inside repeat blocks.
- Recovery order differs from the approved May 1-style shape.
- The final planned step is `Cooldown(Open)`.
- Any planned row is missing a matching complete HealthKit activity row.
- Activity rows are non-contiguous, count-mismatched, or missing distance evidence.
- The inferred tail overlaps planned `Recovery`, `Work`, or `Cooldown`.
- Residual movement is negative, zero, below threshold, or only a reconstruction artifact.
- Pause windows are unpaired, duplicate, dangling, cross-row, or otherwise caveated.
- FIT or screenshot evidence conflicts with mapped HealthKit activity rows.
- The workout has duplicate, no-plan, same-day extra, summary-only, or guard-unknown status.

## Implementation Boundary

Swift normal-detail routing should keep using the narrow recovery gate only. Debug/export code may report blocked reasons for broad recovery-tail candidates, but it must not silently fall through into normal-detail interval rows.

Interval analytics remain blocked for broad recovery-tail shapes. Future analytics can only use recovery-containing rows once the exact workout style is either supported in `custom-workout-correctness-lock-v1.md` or intentionally blocked with stable fallback reasons.
