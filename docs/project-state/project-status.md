# RunSignal Project Status

Last updated: 2026-06-29

## Product Direction

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis. The current v1 priority is Apple Watch custom workout correctness across warmup, work, recovery, cooldown, repeat blocks, pauses, and `Open / Extra` tails.

Coaching expansion, backend sync, AI calls, FIT import, HealthFit import/export, and file-based workout ingestion remain out of scope.

The active milestone is `Custom Workout Correctness Lock v1`: promote generalized evidence-gated custom workout rows for normal detail when WorkoutKit planned rows and complete contiguous HealthKit activity rows agree, while keeping ambiguous or incomplete evidence on explicit fallback paths.

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

Production custom workout intervals now use resolved candidate rows when the evidence gate passes: WorkoutKit planned rows are present and ordered, HealthKit activity rows are complete/contiguous and map to those rows or to a completed prefix for stopped-early workouts, pause/resume events are paired and contained within one row, and any post-fixed-row tail is deterministic. The row boundary source is the former Parity Lab candidate path; HealthKit samples enrich those rows with average HR, max HR, average power, and cadence where available.

Parity Lab/debug exports now label stopped-early rows as completed planned prefixes, show stopped-early row counts once at the section level, keep shared debug/FIT caveats at summary level, and report structured comparison status against the completed prefix instead of the full unfinished plan.

Normal workout detail supports these resolved custom-workout row classes when the evidence gate passes:

- Stopped-early single fixed-distance `Work`.
- Stopped-early multi-step custom workouts when complete contiguous HealthKit activity rows map to the completed WorkoutKit planned prefix; uncompleted planned rows are not invented.
- Simple fixed-distance `Work > inferred Open / Extra`.
- `Warmup(2 km) > one Work step > Cooldown(Open)`.
- `Warmup(2 km) > one Work step > fixed Cooldown > inferred Open / Extra`.
- Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`.
- Clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra`.
- Narrow paused-repeat `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)` with active/timer display for paused rows only.
- Narrow paused-repeat `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra` with paired pause windows assignable to one row and active/timer display for paused rows only.
- Narrow May 1-style `Warmup > Recovery > Work > fixed Cooldown > inferred Open / Extra`.

Paused timing semantics use a pause-window state machine for explicit pause/resume, motion pause/resume, and `pauseOrResumeRequest` toggle events. Duplicate, dangling, unpaired, cross-row, or otherwise caveated pause streams stay blocked from normal-detail promotion.

`DerivedAnalyticsEngine.intervalCandidates` remains a raw HealthKit event-marker debug path only. Derived interval analytics publish rows only from the resolved custom-workout row path when the normal-detail evidence gate passes; raw segment markers are not interval analytics rows.

Gate A simple fixed-distance `Work > Open / Extra` is promoted only for the exact one-step shape with one complete HealthKit activity row and positive `Open / Extra` tail. It must not broaden into structured/special workouts, paused workouts, recovery rows, repeat rows, or missing-evidence cases.

Gate B broad shape-whitelist work has been replaced by the generalized resolved-row contract. FIT and Apple Fitness screenshots remain offline validation evidence; runtime truth remains WorkoutKit plus read-only HealthKit evidence.

## Current Next Work

- Keep resolved candidate-row behavior stable across the archived Apple Fitness fixtures and priority workouts.
- Continue hardening fallback reasons for missing plans, incomplete activity rows, unpaired pauses, cross-row pauses, and stale summary-only evidence.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_fit_backed_two_gate_validation.py` after rollup changes.
- Run `docs/validation/apple-fitness-interval-parity-dataset/score_gate_b_custom_workout_fit.py` after Gate B rollup changes.
- Use `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-correctness-lock-v1.md` as the detailed acceptance matrix before approving new debug prototypes, normal-detail interval rows, or interval-row analytics.
- Use `docs/validation/apple-fitness-interval-parity-dataset/ambiguous-repeat-tail-decision-rules-2026-06-24.md` before repeat-tail prototype or scorecard work.
- Keep elapsed-vs-timer, active/timer, and pause-event diagnostics visible in future Gate B scoring.
- Keep interval analytics limited to evidence-gated resolved rows until supported and blocked custom-workout styles have stable rows, diagnostics agreement, and regression fixtures.

## Blocked

- Missing WorkoutKit plans, missing/non-contiguous/incomplete HealthKit activity rows, activity rows that exceed planned row count, unpaired or cross-row pause streams, stale summary-only evidence, and non-prefix partial repeat context remain blocked from custom interval rows.
- HealthKit segment markers remain raw/debug-only and must not be treated as Apple Fitness row truth.
- March 19-style material distance drift remains blocked until renewed evidence resolves the drift.
- Duplicate, no-plan, same-day extra, drift/guard-unknown, stale summary-only, or missing-detail workouts remain excluded from production approval scoring.
- Interval-row analytics remain blocked until the relevant workout-style rows are supported with evidence or intentionally blocked with stable fallback behavior.

## Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Structured and special custom workouts are not fully settled; repeat-block mapping, recovery-containing tails, repeat-tail cases, and reviewed warmup/work/cooldown outliers still block broad promotion.
- Mechanics, trends, stronger run-type claims, and interval-row analytics remain confidence-gated.

## Recent Proof And Follow-Up

- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-priority-repeat-proof-2026-06-28/` archives the five-priority physical proof set. Priorities 1-5 have Apple Fitness screenshots, typed manual rows, and Raw HealthKit Debug/Parity Lab exports. Priority 1 drove the narrow paused fixed-cooldown/`Open / Extra` normal-detail gate; priorities 2-4 are clean no-pause controls; priority 5 is a paused/manual-skip guard case where activity-boundary candidate rows match Apple Fitness active/timer timing better than plan-derived reconstruction.
- Health Context follow-up: in-app Today/Data verification cards and neutral physical-iPhone check wording are implemented. Remaining proof is to verify VO2 Max and Resting Heart Rate on the physical iPhone after granting Apple Health read access.
- Best Efforts follow-up: visible official segment bests use `PersonalBestEffortEngine` exact distance-window records. Summary-only whole-run estimates must remain excluded. The likely blocker for older benchmark PRs is detailed HealthKit distance evidence coverage.
- Refresh architecture follow-up: monthly evidence refresh is transactional and persists month-scoped job/item checkpoints. Next proof is a physical-iPhone check for activation/scroll responsiveness, thermal behavior, and archived diagnostics/logs.
## 2026-06-28 Interval UI Note

- Paused reconstructed interval rows now expose elapsed row-window duration, paired pause overlap, active/timer duration, display basis, and matching pace basis so Priority-style review can compare normal detail, Raw Debug reconstructed intervals, Parity Lab candidate rows, and Apple Fitness screenshots without hidden duration-basis mismatches.

## 2026-06-28 Resolved Custom Workout Rows

- Normal detail now resolves custom workout interval rows from complete contiguous HealthKit activity boundaries mapped to expanded WorkoutKit planned steps. The primary row duration uses active/timer time when paired pause overlap exists; RunSignal also exposes pause and elapsed row-window duration visibly.
- Resolved rows aggregate average HR, max HR, average running power, and cadence from HealthKit samples over the resolved row window.
- Parity Lab candidate rows remain visible as evidence/debug inspection, but they are no longer categorically separate from production: they are the boundary source when evidence gates pass.

## 2026-06-29 Stopped-Early Prefix Rows

- Stopped-early custom workouts can now show the completed prefix of planned rows instead of blocking solely because planned row count is greater than HealthKit activity row count.
- Parity Lab candidate rows and Raw Debug exports use the same completed-prefix mapping and suppress `Open / Extra` tails when planned rows remain uncompleted.

## 2026-06-29 UI Source Guardrail

- Raw Debug labels resolved/activity-boundary rows versus legacy plan-derived reconstruction, exports use the same supported-row resolver as the app view, and derived interval analytics publish only resolved custom-workout rows when the gate passes.
- Regression tests cover the repeated failure mode where row math is correct but a visible pace/duration tile still uses an older plan-derived or raw-marker source.
- Priority 5 screen-recording follow-up fixed the Raw Debug fallback display so a blocked legacy reconstruction does not mix a plan-derived row header with activity-boundary candidate tiles. When candidate rows are available for a blocked shape, the debug/export surface shows candidate Work, Cooldown, and Open / Extra rows coherently while keeping normal-detail promotion unchanged.
