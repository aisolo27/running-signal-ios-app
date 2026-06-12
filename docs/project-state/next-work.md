# Next Work

Last updated: 2026-06-12

## Priority 1

- Review the debug-only candidate boundary scorecard and decide whether more evidence is needed before any boundary logic experiment.
- Keep WorkoutKit reconstructed intervals gated from normal UI; the current scorecard does not approve a production boundary strategy.

## Priority 2

- Collect pass-case boundary diagnostics before changing distance-goal boundary behavior.
- Preserve the current production interval reconstruction behavior until packet-backed pass/regression evidence supports a strategy change.
- Archive completed date-specific validation evidence to `docs/archive/old-validation/` after it is no longer active.

## Priority 3

- Run physical-device validation only when the task needs real HealthKit proof.
- Capture and save additional parity packets only for new validation workouts or re-checks.

## Blocked

- Apple Fitness interval labeling and boundary behavior remain partly uncertain.
- April 28 is no longer blocked by unavailable evidence; it remains separate from production boundary tuning as an evidence-recovery fixture.
- Normal workout detail interval UI promotion is blocked until boundary evidence is resolved or accepted.
- Candidate boundary scoring is debug-only; no strategy is approved for production.

## Not In Scope

- Coaching expansion.
- VDOT.
- Training load expansion.
- Recovery scoring.
- Race prediction.
- FIT import, FIT backup, HealthFit export, or file-based workout ingestion.
