# Ambiguous Repeat-Tail Evidence Decision

Last updated: 2026-06-23

## Decision

Do not promote a new broad repeat-tail gate from the ambiguous repeat-tail evidence.

The clean no-pause fixed-cooldown repeat-tail shape is already approved and implemented as a narrow normal-detail gate:

`Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > inferred Open / Extra`

June 10 is the proof fixture for that closed gate. It does not justify broader repeat-tail promotion.

AIS-25 should therefore harden fallback and test coverage for unresolved ambiguous repeat-tail cases instead of adding another normal-detail product gate, unless new evidence identifies a different exact narrow shape.

## Evidence

- `physical-iphone-repeat-tail-proof-2026-06-15/review.md` proves the June 10 clean no-pause fixed-cooldown repeat-tail path in debug/export evidence: expanded Work/Recovery rows, fixed final `Cooldown`, inferred post-Cooldown `Open / Extra`, no paired pauses, and no FIT runtime truth.
- `physical-iphone-repeat-block-proof-2026-06-14/README.md` proves the open-cooldown controls: May 20 and June 3 keep the final open cooldown as `Cooldown` and do not invent `Open / Extra`.
- `ambiguous-repeat-tail-rule-2026-06-15.md` now separates the approved clean shape from unresolved ambiguous cases.
- `custom-workout-correctness-lock-v1.md` already lists the clean no-pause repeat fixed-cooldown/Open-tail shape as one of the eight approved narrow normal-detail gates.
- Source inspection confirms the clean path is implemented through the narrow no-pause repeat fixed-cooldown/Open-tail gate and guarded separately from paused or unresolved repeat-tail cases.

## AIS-25 Direction

Implement fallback/test hardening for unresolved ambiguous repeat-tail cases.

Required behavior to lock:

- Approved clean June 10-style no-pause fixed-cooldown repeat-tail remains supported.
- Open-cooldown repeat controls remain `Cooldown` with no `Open / Extra`.
- Paused repeat blocks with true Open/Extra tails remain blocked until a separate paused-tail rule is approved.
- Missing, count-mismatched, non-contiguous, distance-missing, or unresolved final-row evidence remains blocked.
- Below-threshold, overlapping, negative, or artifact-only residual tails remain blocked.
- Duplicate, no-plan, same-day extra, summary-only, and guard-unknown workouts remain excluded from approval scoring.
- FIT remains offline validation evidence only, not runtime truth.

AIS-25 should add focused tests or fallback wording for these cases without broadening normal detail.

## AIS-26 Direction

If AIS-25 changes Swift behavior, require package tests, Simulator smoke, physical iPhone install, and archived RunSignal Raw HealthKit Debug/parity exports for June 10 plus May 20/June 3 controls.

If AIS-25 is docs/test-only hardening with no behavior change, AIS-26 can be docs-only validation that cites the existing June 10, May 20, and June 3 proof folders and clearly states that no product behavior changed.

## Boundaries

- HealthKit remains read-only runtime truth.
- WorkoutKit remains optional planned-structure evidence.
- FIT and screenshots remain validation evidence only.
- No FIT import, file ingestion, HealthFit dependency, new HealthKit permissions, coaching, VDOT, training load, recovery scoring, race prediction, WeatherKit, or interval-row analytics.
