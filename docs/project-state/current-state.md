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
- Raw HealthKit Debug now has diagnostics-only Parity Lab infrastructure: selected-workout force re-enrich invalidates only that workout's cached evidence, reruns the existing HealthKit/WorkoutKit evidence queries, and can export a stable parity packet JSON with cache status, fresh-query result, counts, plan audit, reconstructed intervals, and warnings.
- April 28 physical-device force re-enrich recovered rich HealthKit evidence and a WorkoutKit plan; it is now an evidence-recovery / fresh-query validation fixture, not an evidence-unavailable blocker.
- Physical-device parity packets are archived for the full active validation set: April 28, May 26, June 1, June 2, June 3, June 4, June 5, and June 12.
- Debug-only candidate boundary scoring is available at `docs/validation/apple-fitness-interval-parity-dataset/score_candidate_boundary_strategies.py`; the generated scorecard does not approve any production boundary strategy.
- Boundary pattern investigation found no public-API observable separator that explains drift cases without regressing guard cases; production boundary behavior remains unchanged.
- Guard-case collection now has a bounded plan: collect 5-10 more simple fixed-distance Work + Open tail examples before revisiting production boundary logic.
- Keep only the latest active parity investigation, latest active evidence review, and current blocker in active validation docs; archive completed date-specific evidence to `docs/archive/old-validation/`.
- Real HealthKit proof requires a physical iPhone; Simulator checks prove UI/sample-data behavior only.

## Current Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- Apple Fitness interval row boundaries may use private smoothing or presentation rules that public HealthKit/WorkoutKit APIs do not expose.
- Fixed-distance Work plus real Open tail drift now has three research examples across 6.45 km and 5.00 km goals; no boundary strategy is approved for production yet.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Physical-device parity packet collection has succeeded for the active fixture set; candidate boundary scoring remains debug-only and no production boundary strategy is approved.
- Mechanics, trends, and stronger run-type claims remain confidence-gated.

## Current Next Steps

- Use `docs/project-state/next-work.md` for the short current priority list.
- Continue Step 7 from `docs/milestones/09-healthkit-evidence-contract.md` only when the task is milestone work.
- For parity work, use `docs/validation/apple-fitness-interval-parity-dataset/README.md`, `analysis-summary.md`, and `next-boundary-validation-plan.md`.
- Review `candidate-boundary-strategy-scorecard.md` before changing boundary logic; the current scorecard says no candidate is production-safe.
- Use `boundary-pattern-investigation.md` for the current drift-vs-guard feature comparison before proposing any boundary experiment.
- Use `guard-case-collection-plan.md` for the physical-iPhone evidence checklist and stopping criteria.
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
