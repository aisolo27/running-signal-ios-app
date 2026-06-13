# Next Work

Last updated: 2026-06-13

## Priority 1

- Keep production interval behavior unchanged until a later task explicitly approves a prototype.
- Use FIT as the automated offline validation oracle for boundary scoring.
- Keep Apple Fitness screenshots/manual rows optional; they are no longer the main validation gate.
- Review `docs/validation/apple-fitness-interval-parity-dataset/fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md`.
- Current priority is custom workout correctness, especially warmup/work/recovery/cooldown, repeat blocks, and Open/Extra tails.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py` after rollup changes.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py` after Gate B rollup changes.
- Gate A: simple fixed-distance Work + Open is eligible for a narrow feature-flagged `HKWorkoutActivity` prototype only, but it is not being implemented yet.
- Gate B: structured interval workouts remain blocked; row-level FIT extraction exists, but repeat-block expansion and Open/Extra tail rules are not production-approved.
- Gate B: warmup/work/cooldown specials remain blocked for broad promotion; 2 rows are candidate row-level supported, 2 are inconclusive, and 1 fixed-cooldown-plus-tail case still needs an Open/Extra rule.
- Production interval behavior remains unchanged while custom workout reconstruction rules are being defined. Phase 1 internal expanded-step model types and Phase 2 debug comparison model types exist for validation/debug use only.
- Duplicate, no-plan, same-day extra, and drift/guard-unknown workouts remain excluded from production approval scoring.

## Priority 2

- Review `docs/validation/apple-fitness-interval-parity-dataset/gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.md` before any Gate B implementation discussion.
- Review `docs/validation/apple-fitness-interval-parity-dataset/gate-b-phase-3-readiness-review.md` before any Phase 3 prototype discussion.
- Review `docs/validation/apple-fitness-interval-parity-dataset/gate-b-agent-findings-2026-03-to-2026-06.md` and the derived repeat-block, Open/Extra tail, and narrow candidate scorecards before any further Gate B rule work.
- Review `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-shape-coverage-audit-2026-03-to-2026-06.md` before any Phase 3 prototype or narrow evidence collection plan; collect balanced easy, tempo, interval, tail, and pause/timer evidence instead of only more narrow warmup/work/open-cooldown rows.
- Use `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-balanced-evidence-collection-plan.md` when collecting new custom workout evidence; it defines minimum and better targets, Apple Watch templates, screenshot/export checklists, and subclass acceptance criteria.
- Use `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-evidence-collection-tracker.md` to track the next validation cycle's target templates, completed counts, screenshots, FIT exports, monthly diagnostics refreshes, and parity packet exports.
- Use `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-reconstruction-rules.md` and `custom-workout-swift-gap-analysis.md` before any custom workout Swift design.
- Define Gate B evidence rules for structured intervals: repeat-block expansion, work/recovery mapping, activity count, planned step count, FIT lap count, FIT workout step count, and material row shifts.
- Define Gate B evidence rules for warmup/work/cooldown specials: Warmup, Work, Recovery, Cooldown, Open/Extra labels and Open tail handling after cooldown.
- Use `docs/validation/apple-fitness-interval-parity-dataset/gate-b-timer-drift-evidence-2026-03-to-2026-06.md` before reconsidering timer-drift outliers such as `2026-05-29T11:49:28Z` or the high-error repeat-block rows.
- Keep elapsed-vs-timer and pause-event debug output visible in future Gate B scoring; do not collapse row timing to one derived duration.
- Continue `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-implementation-plan.md` with Phase 3 only after a later task explicitly approves prototype work.
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
- No Gate B subclass is approved for production. A narrow no-tail warmup/work/open-cooldown candidate subclass has 2 supported rows and may be discussed later as debug-only only; no Swift prototype is recommended now.
- Normal workout detail interval UI promotion remains blocked until the relevant gate is approved or the limitation is explicitly accepted.

## Not In Scope

- Coaching expansion.
- VDOT.
- Training load expansion.
- Recovery scoring.
- Race prediction.
- FIT import, FIT backup, HealthFit export, or file-based workout ingestion.
- HealthFit as a production dependency or FIT as runtime truth.
