# RunSignal Current State

Last updated: 2026-06-25

## Product Direction

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis. The current v1 priority is Apple Watch custom workout correctness across warmup, work, recovery, cooldown, repeat blocks, pauses, and Open/Extra tails.

Coaching expansion, backend sync, AI calls, FIT import, HealthFit import/export, and file-based workout ingestion remain out of scope.

The active milestone is `Custom Workout Correctness Lock v1`: keep the eight physically proven normal-detail gates stable, use the workout-style acceptance matrix for future validation/prototype decisions, and defer interval-row analytics until custom workout structure is stable.

The first-read roadmap for this milestone is `docs/project-state/accuracy-ledger.md`. Use it as the mission-control map for workout-shape status, promotion rungs, blocked classes, and which older validation docs it supersedes for day-to-day planning.

## Runtime Data Contract

- HealthKit is the runtime source of truth for completed running workouts.
- HealthKit access is read-only.
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

Broad production interval behavior remains frozen outside the explicitly approved narrow normal-detail gates. Debug validation models and Parity Lab exports may expose candidate rows, comparison summaries, fallback reasons, pause overlap, active/timer duration, and Open/Extra tail diagnostics, but they do not approve production UI by themselves.

Normal workout detail currently supports eight physically proven narrow classes:

- Stopped-early single fixed-distance `Work`.
- Simple fixed-distance `Work > inferred Open / Extra`.
- `Warmup(2 km) > one Work step > Cooldown(Open)`.
- `Warmup(2 km) > one Work step > fixed Cooldown > inferred Open / Extra`.
- Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`.
- Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra`.
- Narrow paused-repeat `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)` with active/timer display for paused rows only.
- Narrow May 1-style `Warmup > Recovery > Work > fixed Cooldown > inferred Open / Extra`.

Paused timing semantics now use a pause-window state machine for explicit pause/resume, motion pause/resume, and `pauseOrResumeRequest` toggle events. Duplicate, dangling, unpaired, cross-row, or otherwise caveated pause streams stay blocked from normal-detail promotion.

`DerivedAnalyticsEngine.intervalCandidates` is a separate raw HealthKit event-marker path. It uses elapsed event-window duration and does not consume `WorkoutIntervalReconstruction` or the pause-window resolver, so it must not be treated as trusted custom-workout interval analytics or a pause-adjusted active-duration source until the interval analytics gate is explicitly reopened.

Derived interval-candidate caveats backfill lazily on the next derived-analysis recompute; `DerivedWorkoutAnalysis.currentVersion` was not bumped because this only labels existing elapsed-duration semantics and does not change metrics, confidence, filtering, or schema.

Gate A simple fixed-distance `Work > Open / Extra` is promoted only for the exact one-step shape with one complete HealthKit activity row and positive Open/Extra tail. It must not broaden into structured/special workouts, paused workouts, recovery rows, repeat rows, or missing-evidence cases.

Gate B remains blocked for broad production promotion and for any new Swift prototype. Row-level FIT label, timing, distance, tail, and fallback evidence is available through `gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.*` and is linked from `gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.*`, but exact-shape label/tail/fallback rules are still required.

The remaining blocked workout-style classes have explicit boundary docs:

- Unresolved ambiguous repeat-tail cases.
- True paused repeat fixed-tail `Open / Extra`.
- Broad recovery-containing `Open / Extra` tails outside the narrow May 1-style gate.

## Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Structured and special custom workouts are not fully settled; repeat-block mapping, recovery-containing tails, repeat-tail cases, and reviewed warmup/work/cooldown outliers still block broad promotion.
- Mechanics, trends, stronger run-type claims, and interval-row analytics remain confidence-gated. Whole-workout derived analytics can stay cached; custom-workout row analytics should not consume raw event candidates as reconstructed rows.

## Current Next Steps

- Use `docs/project-state/accuracy-ledger.md` first for the workout-shape status board, numeric promotion bars, and active blocker sequence.
- Use `docs/project-state/next-work.md` for the short current priority list.
- Use `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-correctness-lock-v1.md` as the detailed acceptance matrix before approving new debug prototypes, normal-detail interval rows, or interval-row analytics.
- Continue Gate B work by approving or rejecting exact repeat-block, Open/Extra tail, warmup/work/cooldown, and fallback rules from the row-level evidence.
- Use `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-decision-rules-2026-06-24.md` before repeat-tail prototype or scorecard work; it keeps broad repeat tails blocked and defines tie-breakers/fallback reasons for docs/debug scoring.
- Use `docs/validation/apple-fitness-interval-parity-dataset/paused-repeat-open-extra-debug-prototype-plan-2026-06-24.md` for the paused repeat fixed-tail `Open / Extra` debug/export prototype; Raw HealthKit Debug/parity output and the in-app Parity Lab status expose row/tail/pause/fallback diagnostics and standardized fallback labels, while the exact paired-pause fixed-tail row remains evidence-blocked until current Raw HealthKit Debug plus parity packet proof exists. For fresh proof folders exported by builds with readable fallback labels, run `docs/validation/apple-fitness-interval-parity-dataset/validate_parity_export_consistency.py --require-readable-fallback-labels <proof-folder>` before archiving or promotion review.
- Keep elapsed-vs-timer, active/timer, and pause-event diagnostics visible in future Gate B scoring.
- Keep interval analytics whole-workout-level until supported and blocked custom-workout styles have stable rows, diagnostics agreement, and regression fixtures.

## Read Only When Relevant

- `docs/project-state/next-work.md`: current priorities and blocked work.
- `docs/project-state/documentation-index.md`: choose which docs matter for a task.
- `docs/project-state/do-not-read-by-default.md`: files to avoid unless historical context is explicitly required.
- `docs/bug-log.md`: read the index, then only the relevant section.
- `docs/healthkit-reference/00-START-HERE-CODEX.md`: HealthKit API decisions only.
- `docs/validation/`: Apple Fitness parity, FIT-backed validation, or evidence-review work only.
- `docs/milestones/09-healthkit-evidence-contract.md`: milestone status and Step 7 work only.
- `docs/archive/`: historical context only.
