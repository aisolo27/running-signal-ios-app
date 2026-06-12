# Next Work

Last updated: 2026-06-12

## Priority 1

- Use Raw HealthKit Debug's Parity Lab force re-enrich and parity packet export on the physical iPhone for the remaining validation workouts.
- Verify WorkoutKit planned intervals against Apple Fitness with packet evidence before any normal UI promotion.

## Priority 2

- Score interval parity evidence for fixed-distance Work plus real Open tail cases, including the June 12 5K sample.
- Collect pass-case boundary diagnostics before changing distance-goal boundary behavior.
- Preserve the current production interval reconstruction behavior until packet-backed pass/regression evidence supports a strategy change.
- Archive completed date-specific validation evidence to `docs/archive/old-validation/` after it is no longer active.

## Priority 3

- Run physical-device validation only when the task needs real HealthKit proof.
- Capture and save parity packets from the physical device before claiming that force re-enrich resolved an evidence gap.

## Blocked

- Apple Fitness interval labeling and boundary behavior remain partly uncertain.
- April 28 is no longer blocked by unavailable evidence; it remains separate from production boundary tuning as an evidence-recovery fixture.
- Normal workout detail interval UI promotion is blocked until boundary evidence is resolved or accepted.
- Candidate boundary scoring remains unbuilt; no strategy is approved for production.

## Not In Scope

- Coaching expansion.
- VDOT.
- Training load expansion.
- Recovery scoring.
- Race prediction.
- FIT import, FIT backup, HealthFit export, or file-based workout ingestion.
