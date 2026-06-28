# RunSignal Project Status

Last updated: 2026-06-28

## Product Direction

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis. The current v1 priority is Apple Watch custom workout correctness across warmup, work, recovery, cooldown, repeat blocks, pauses, and `Open / Extra` tails.

Coaching expansion, backend sync, AI calls, FIT import, HealthFit import/export, and file-based workout ingestion remain out of scope.

The active milestone is `Custom Workout Correctness Lock v1`: keep the nine physically proven normal-detail gates stable, use the workout-style acceptance matrix for future validation/prototype decisions, and defer interval-row analytics until custom workout structure is stable.

## First-Read Map

- Use this file for the project state, next work, known blockers, and out-of-scope boundaries.
- Use `docs/project-state/accuracy-ledger.md` for workout-shape status, promotion rungs, proof bars, and allowed/blocked interval behavior.
- Use `docs/project-state/documentation-index.md` only when choosing deeper source docs, scorecards, scripts, or archives.

## Runtime Data Contract

- HealthKit is the runtime source of truth for completed running workouts.
- HealthKit access is read-only.
- VO2 Max and Resting Heart Rate are optional whole-run Health Context signals for readiness evidence and Data/Today tiles; missing values use neutral physical-iPhone check wording.
- Whole-run HealthKit review is a safe lane: completed-run distance, duration, pace, route, splits, Health Context, and whole-run stats remain usable even when custom interval rows are blocked.
- WorkoutKit `HKWorkout.workoutPlan` is the planned-structure source when available.
- HealthKit samples and `HKWorkout.workoutActivities` are the measured-stats and boundary evidence sources.
- HealthKit segment markers stay raw/debug-only.
- FIT files are offline validation evidence only, not runtime truth and not an app input.
- Apple Fitness screenshots/manual rows are optional sanity evidence, not the main promotion gate.

## Project Shape

- Open/build `RunningWorkoutAnalysis.xcworkspace`.
- The app target is a thin shell.
- Primary implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- Package tests run with `swift test --package-path RunningWorkoutAnalysisPackage`.
- Keep `Package.swift` compatible with iOS 26 and macOS 14 so local package tests remain usable.

## Current Validation State

Broad production interval behavior remains frozen outside the nine physically proven narrow normal-detail gates. Debug validation models and Parity Lab exports may expose candidate rows, comparison summaries, fallback reasons, pause overlap, active/timer duration, and `Open / Extra` tail diagnostics, but they do not approve production UI by themselves.

Normal workout detail currently supports these nine narrow classes:

- Stopped-early single fixed-distance `Work`.
- Simple fixed-distance `Work > inferred Open / Extra`.
- `Warmup(2 km) > one Work step > Cooldown(Open)`.
- `Warmup(2 km) > one Work step > fixed Cooldown > inferred Open / Extra`.
- Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`.
- Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra`.
- Narrow paused-repeat `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)` with active/timer display for paused rows only.
- Narrow paused-repeat `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra` with paired pause windows assignable to one row and active/timer display for paused rows only.
- Narrow May 1-style `Warmup > Recovery > Work > fixed Cooldown > inferred Open / Extra`.

Paused timing semantics use a pause-window state machine for explicit pause/resume, motion pause/resume, and `pauseOrResumeRequest` toggle events. Duplicate, dangling, unpaired, cross-row, or otherwise caveated pause streams stay blocked from normal-detail promotion.

`DerivedAnalyticsEngine.intervalCandidates` is a separate raw HealthKit event-marker path. It uses elapsed event-window duration and does not consume `WorkoutIntervalReconstruction` or the pause-window resolver, so it must not be treated as trusted custom-workout interval analytics or a pause-adjusted active-duration source until the interval analytics gate is explicitly reopened.

Gate A simple fixed-distance `Work > Open / Extra` is promoted only for the exact one-step shape with one complete HealthKit activity row and positive `Open / Extra` tail. It must not broaden into structured/special workouts, paused workouts, recovery rows, repeat rows, or missing-evidence cases.

Gate B remains blocked for broad production promotion and for any new Swift prototype. Row-level FIT label, timing, distance, tail, and fallback evidence is available through `gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.*` and is linked from `gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.*`, but exact-shape label/tail/fallback rules are still required.

## Current Next Work

- Keep production interval behavior unchanged outside the nine proven narrow gates.
- Continue Gate B work by approving or rejecting exact repeat-block, `Open / Extra` tail, warmup/work/cooldown, and fallback rules from the row-level evidence.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py` after rollup changes.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py` after Gate B rollup changes.
- Use `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-correctness-lock-v1.md` as the detailed acceptance matrix before approving new debug prototypes, normal-detail interval rows, or interval-row analytics.
- Use `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-decision-rules-2026-06-24.md` before repeat-tail prototype or scorecard work.
- Keep elapsed-vs-timer, active/timer, and pause-event diagnostics visible in future Gate B scoring.
- Keep interval analytics whole-workout-level until supported and blocked custom-workout styles have stable rows, diagnostics agreement, and regression fixtures.

## Blocked

- Broad production promotion of `HKWorkoutActivity` boundary rows is not approved.
- Structured intervals are not approved through Gate A.
- Warmup/work/cooldown specials are not approved through Gate A.
- No broad Gate B subclass is approved for production.
- Ambiguous repeat tails, broad recovery-tail behavior, broad custom-workout promotion, paused warmup/work/cooldown timer outliers, and March 19-style distance drift remain blocked.
- Duplicate, no-plan, same-day extra, drift/guard-unknown, stale summary-only, or missing-detail workouts remain excluded from production approval scoring.
- Interval-row analytics remain blocked until the relevant workout-style rows are supported with evidence or intentionally blocked with stable fallback behavior.

## Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Structured and special custom workouts are not fully settled; repeat-block mapping, recovery-containing tails, repeat-tail cases, and reviewed warmup/work/cooldown outliers still block broad promotion.
- Mechanics, trends, stronger run-type claims, and interval-row analytics remain confidence-gated.

## Recent Proof And Follow-Up

- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-priority-repeat-proof-2026-06-28/` partially archives the five-priority physical proof set. Priorities 1-3 have Apple Fitness screenshots, typed manual rows, and Raw HealthKit Debug/Parity Lab exports. Priority 1 drove the narrow paused fixed-cooldown/`Open / Extra` normal-detail gate; priorities 2-3 are clean no-pause controls. Priorities 4-5 remain pending.
- Health Context follow-up: in-app Today/Data verification cards and neutral physical-iPhone check wording are implemented. Remaining proof is to verify VO2 Max and Resting Heart Rate on the physical iPhone after granting Apple Health read access.
- Best Efforts follow-up: visible official segment bests use `PersonalBestEffortEngine` exact distance-window records. Summary-only whole-run estimates must remain excluded. The likely blocker for older benchmark PRs is detailed HealthKit distance evidence coverage.
- Refresh architecture follow-up: monthly evidence refresh is transactional and persists month-scoped job/item checkpoints. Next proof is a physical-iPhone check for activation/scroll responsiveness, thermal behavior, and archived diagnostics/logs.
