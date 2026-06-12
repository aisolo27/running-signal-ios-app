# RunSignal Current State

Last updated: 2026-06-12

## Current Product Direction

RunSignal is a native iPhone SwiftUI app focused on Apple Fitness parity for completed running workouts. The current v1 priority is evidence-grounded workout analysis, not coaching expansion, backend sync, AI calls, or file imports.

## Current Data Source

- HealthKit is the source of truth for completed running workouts.
- HealthKit access is read-only.
- Apple Fitness screenshots are the visual parity reference for validation.
- WorkoutKit `HKWorkout.workoutPlan` is the planned-structure source when available.
- HealthKit samples associated with each workout are the measured-stats source.
- HealthKit segment markers stay raw/debug-only.

## Current Architecture

- Open/build `RunningWorkoutAnalysis.xcworkspace`.
- The app target is a thin shell.
- Primary implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- Local package tests run with `swift test --package-path RunningWorkoutAnalysisPackage`.
- Keep `Package.swift` compatible with iOS 26 and macOS 14 for local package tests.

## Current Validation Focus

- Apple Fitness interval parity remains the active validation focus.
- Preserve the Jun 10, 2026 interval validation docs and the current parity dataset.
- The normal workout detail interval UI should not be promoted until the current boundary-validation blockers are resolved or explicitly accepted.
- Keep only the latest active parity investigation, latest active evidence review, and current blocker in active validation docs; archive completed date-specific evidence to `docs/archive/old-validation/`.
- Real HealthKit proof requires a physical iPhone; Simulator checks prove UI/sample-data behavior only.

## Current Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- Apple Fitness interval row boundaries may use private smoothing or presentation rules that public HealthKit/WorkoutKit APIs do not expose.
- Fixed-distance Work plus real Open tail behavior still needs more examples before changing boundary logic.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Mechanics, trends, and stronger run-type claims remain confidence-gated.

## Current Next Steps

- Use `docs/project-state/next-work.md` for the short current priority list.
- Continue Step 7 from `docs/milestones/09-healthkit-evidence-contract.md` only when the task is milestone work.
- For parity work, use `docs/validation/apple-fitness-interval-parity-dataset/README.md`, `analysis-summary.md`, and `next-boundary-validation-plan.md`.
- Collect more fixed-distance Work plus real Open tail examples with Apple Fitness screenshots and RunSignal diagnostics before changing boundary logic.
- Keep `docs/project-state/current-state.md` and `docs/project-state/next-work.md` updated when project direction, validation status, known limitations, or next steps change.

## Read Only When Relevant

- `docs/project-state/next-work.md`: current priorities and blocked work.
- `docs/project-state/documentation-index.md`: choose which docs matter for a task.
- `docs/project-state/do-not-read-by-default.md`: files to avoid unless historical context is explicitly required.
- `docs/bug-log.md`: read the index, then only the relevant section.
- `docs/healthkit-reference/00-START-HERE-CODEX.md`: HealthKit API decisions only.
- `docs/validation/`: Apple Fitness parity or evidence-review work only.
- `docs/milestones/09-healthkit-evidence-contract.md`: milestone status and Step 7 work only.
- `docs/archive/`: historical context only.
