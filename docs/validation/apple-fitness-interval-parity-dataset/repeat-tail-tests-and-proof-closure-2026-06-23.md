# Repeat-Tail Tests And Proof Closure

Last updated: 2026-06-23

## Decision

AIS-26 is closed with docs-only validation.

AIS-25 changed tests and active documentation only. It did not broaden normal-detail behavior, change runtime reconstruction, add a new gate, add a new HealthKit read, or change UI display. Fresh Simulator smoke or physical iPhone proof is therefore not required for AIS-26.

## What AIS-25 Proved

Package tests now lock the two unresolved repeat-tail fallback paths that matter after AIS-24:

- Paused fixed-cooldown repeat-tail cases remain blocked behind the pause-adjusted timer blocker and retain `fixedCooldownFollowedByPossibleOpenExtraTail` tail diagnostics.
- Unapproved no-pause repeat fixed-cooldown/Open-tail cases remain blocked as `open-tail-needs-rule` with `openExtraTailAmbiguous` fallback and `fixedCooldownFollowedByPossibleOpenExtraTail` tail diagnostics.

The already-approved clean June 10-style no-pause fixed-cooldown repeat-tail gate remains unchanged.

## Existing Physical Proof

Use the existing proof folders instead of requesting new app artifacts:

- `physical-iphone-repeat-block-proof-2026-06-14/README.md`
  - May 20 and June 3 prove open-cooldown repeat controls keep the final open cooldown as `Cooldown`.
  - June 10 proves the clean fixed-cooldown repeat-tail normal-detail gate on the latest installed build covered by that proof.
- `physical-iphone-repeat-tail-proof-2026-06-15/review.md`
  - June 10 debug/export proof confirms expanded Work/Recovery rows, fixed final `Cooldown`, inferred post-Cooldown `Open / Extra`, no paired pauses, and no FIT runtime truth.
- `ambiguous-repeat-tail-evidence-decision-2026-06-23.md`
  - AIS-24 decides no new broad repeat-tail gate should be promoted and routes unresolved cases to fallback/test hardening.

## Validation

Completed locally on 2026-06-23:

- `swift test --package-path RunningWorkoutAnalysisPackage`
- `git diff --check`

No UI behavior changed, so no Simulator smoke was required for this AIS-26 closure. No runtime HealthKit behavior changed, so no physical iPhone proof was required.

## Remaining Blocked Cases

- True Open/Extra paused-repeat tails.
- Broader or unresolved ambiguous repeat-tail cases.
- Missing, count-mismatched, non-contiguous, distance-missing, or unresolved final-row evidence.
- Below-threshold, overlapping, negative, or artifact-only residual tails.
- Duplicate, no-plan, same-day extra, summary-only, and guard-unknown workouts.

## Boundaries

- HealthKit remains read-only runtime truth.
- WorkoutKit remains optional planned-structure evidence.
- FIT and screenshots remain validation evidence only.
- No FIT import, file ingestion, HealthFit dependency, new HealthKit permissions, coaching, VDOT, training load, recovery scoring, race prediction, WeatherKit, or interval-row analytics.
