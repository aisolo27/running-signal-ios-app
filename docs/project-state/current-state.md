# RunSignal Current State

Last updated: 2026-06-13

## Current Product Direction

RunSignal is a native iPhone SwiftUI app focused on evidence-grounded completed running workout analysis. The current v1 priority is custom Apple Watch running workout correctness: warmup, work, recovery, cooldown, repeat blocks, and Open/Extra tails. Coaching expansion, backend sync, AI calls, and file imports remain out of scope.

## Current Data Source

- HealthKit is the runtime source of truth for completed running workouts.
- HealthKit access is read-only.
- WorkoutKit `HKWorkout.workoutPlan` is the planned-structure source when available.
- HealthKit samples associated with each workout are the measured-stats source.
- Public `HKWorkout.workoutActivities` rows are the strongest current public-API lead for boundary reconstruction.
- HealthKit segment markers stay raw/debug-only.
- FIT files are now the automated offline validation oracle for interval boundary scoring.
- Apple Fitness screenshots/manual rows are optional sanity evidence only, not the main promotion gate.

## Current Architecture

- Open/build `RunningWorkoutAnalysis.xcworkspace`.
- The app target is a thin shell.
- Primary implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- Local package tests run with `swift test --package-path RunningWorkoutAnalysisPackage`.
- Keep `Package.swift` compatible with iOS 26 and macOS 14 for local package tests.

## Current Validation Focus

- Production interval behavior remains unchanged.
- Swift source remains unchanged unless a later task explicitly approves a prototype.
- Raw HealthKit Debug has diagnostics-only Parity Lab infrastructure, selected-workout force re-enrich, monthly evidence refresh, parity packet export, and side-by-side `activityBoundaryCandidateSummary` / `activityBoundaryCandidateIntervals`.
- Debug-only candidate boundary scoring is available at `docs/validation/apple-fitness-interval-parity-dataset/score_candidate_boundary_strategies.py`.
- Refreshed March-June 2026 monthly diagnostics are summarized in `docs/validation/apple-fitness-interval-parity-dataset/monthly-diagnostics-rollup-2026-03-to-2026-06.md`.
- March-June 2026 FIT reference evidence is summarized in `docs/validation/apple-fitness-interval-parity-dataset/fit-reference-rollup-2026-03-to-2026-06.md`.
- The FIT-backed two-gate plan is documented in `docs/validation/apple-fitness-interval-parity-dataset/fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md`.
- Gate A: FIT supports a narrow feature-flagged `HKWorkoutActivity` prototype for simple fixed-distance Work + Open only, but that prototype is intentionally not being implemented yet.
- Gate B: `docs/validation/apple-fitness-interval-parity-dataset/gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.md` adds row-level FIT lap/workout_step extraction. It found 2 warmup/work/cooldown cases with candidate row-level support, 17 repeat-block rule cases, 4 Open/Extra tail rule cases, and 2 inconclusive rows. Structured intervals remain blocked; no broad custom workout promotion or Swift prototype is approved.
- Custom workout rule/spec work is documented in `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-reconstruction-rules.md`, `custom-workout-swift-gap-analysis.md`, and `custom-workout-implementation-plan.md`. Phase 1 internal expanded-step model types and Phase 2 debug comparison model types now exist for validation/debug use only; they do not change production interval behavior or normal workout UI.
- Duplicate, no-plan, and drift/guard-unknown workouts remain excluded from approval scoring.

## Current Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- FIT is offline validation evidence only. It is not runtime truth, not an app data input, not a HealthFit dependency, and not a production data source.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Structured and special custom workouts are not 100% settled; Gate B now has row-level FIT extraction, but repeat-block mapping, Open/Extra tail rules, and inconclusive warmup/work/cooldown outliers still block broad promotion.
- Mechanics, trends, and stronger run-type claims remain confidence-gated.

## Current Next Steps

- Use `docs/project-state/next-work.md` for the short current priority list.
- For parity work, use `docs/validation/apple-fitness-interval-parity-dataset/README.md`, `analysis-summary.md`, and `next-boundary-validation-plan.md`.
- Review `candidate-boundary-strategy-scorecard.md`, `hkworkoutactivity-boundary-scorecard.md`, and `fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md` before changing boundary logic.
- Next implementation requires explicit approval before any Phase 3 prototype or production interval behavior change.
- Continue Gate B work by reviewing row-level outliers and defining repeat-block plus Open/Extra tail rules before changing structured interval or warmup/work/cooldown behavior. Gate A simple Work/Open remains validated but parked.
- Keep `docs/project-state/current-state.md` and `docs/project-state/next-work.md` updated when project direction, validation status, known limitations, or next steps change.

## Read Only When Relevant

- `docs/project-state/next-work.md`: current priorities and blocked work.
- `docs/project-state/documentation-index.md`: choose which docs matter for a task.
- `docs/project-state/do-not-read-by-default.md`: files to avoid unless historical context is explicitly required.
- `docs/bug-log.md`: read the index, then only the relevant section.
- `docs/healthkit-reference/00-START-HERE-CODEX.md`: HealthKit API decisions only.
- `docs/validation/`: Apple Fitness parity, FIT-backed validation, or evidence-review work only.
- `docs/milestones/09-healthkit-evidence-contract.md`: milestone status and Step 7 work only.
- `docs/archive/`: historical context only.
