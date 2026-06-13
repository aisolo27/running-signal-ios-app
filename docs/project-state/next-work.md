# Next Work

Last updated: 2026-06-13

## Priority 1

- Keep production interval behavior unchanged until a later task explicitly approves a prototype.
- Use FIT as the automated offline validation oracle for boundary scoring.
- Keep Apple Fitness screenshots/manual rows optional; they are no longer the main validation gate.
- Review `docs/validation/apple-fitness-interval-parity-dataset/fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md`.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py` after rollup changes.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py` after Gate B rollup changes.
- Gate A: simple fixed-distance Work + Open is eligible for a narrow feature-flagged `HKWorkoutActivity` prototype only.
- Gate B: structured interval workouts remain blocked; count alignment is strong, but row-level FIT label/error extraction is missing.
- Gate B: warmup/work/cooldown specials remain blocked; count alignment is strong, but label mapping and Open/Extra tail rules are missing.
- Duplicate, no-plan, same-day extra, and drift/guard-unknown workouts remain excluded from production approval scoring.

## Priority 2

- Extract row-level FIT lap timing/distance/labels for structured intervals and compare those rows against current and `HKWorkoutActivity` candidate rows.
- Define Gate B evidence rules for structured intervals: repeat-block expansion, work/recovery mapping, activity count, planned step count, FIT lap count, FIT workout step count, and material row shifts.
- Define Gate B evidence rules for warmup/work/cooldown specials: Warmup, Work, Recovery, Cooldown, Open/Extra labels and Open tail handling after cooldown.
- Preserve the current production reconstruction while Gate B is incomplete.
- Archive completed date-specific validation evidence to `docs/archive/old-validation/` after it is no longer active.

## Priority 3

- Run physical-device validation only when the task needs real HealthKit proof.
- Capture new parity packets only for new validation workouts or re-checks.
- For month-scale review, refresh selected-month evidence before exporting monthly diagnostics.

## Blocked

- Broad production promotion of `HKWorkoutActivity` boundary rows is not approved.
- Structured intervals are not approved through Gate A.
- Warmup/work/cooldown specials are not approved through Gate A.
- No Gate B subclass is approved yet.
- Normal workout detail interval UI promotion remains blocked until the relevant gate is approved or the limitation is explicitly accepted.

## Not In Scope

- Coaching expansion.
- VDOT.
- Training load expansion.
- Recovery scoring.
- Race prediction.
- FIT import, FIT backup, HealthFit export, or file-based workout ingestion.
- HealthFit as a production dependency or FIT as runtime truth.
