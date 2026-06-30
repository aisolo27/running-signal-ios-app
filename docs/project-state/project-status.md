# RunSignal Project Status

Last updated: 2026-06-30

## Product Direction

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis. The current v1 priority is Apple Watch custom workout correctness across warmup, work, recovery, cooldown, repeat blocks, pauses, and `Open / Extra` tails.

Coaching expansion, backend sync, AI calls, FIT import, HealthFit import/export, and file-based workout ingestion remain out of scope.

The active milestone is `Custom Workout Correctness Lock v1`: keep the generalized evidence-gated custom workout row resolver stable now that WorkoutKit planned rows plus complete contiguous HealthKit activity rows are approved as the v1 normal-detail source when the evidence gate passes.

Decision rule: do not grow support by hard-fitting one workout shape at a time when the generalized resolved-row evidence source applies. The default and only product custom-workout row strategy is WorkoutKit planned row order plus complete contiguous HealthKit activity boundaries, enriched with HealthKit samples for distance, time, pace, heart rate, power, cadence, and pause/active timing. Older plan/sample-derived reconstruction must not substitute product fallback rows; if the resolved-row gate is unavailable or blocked, show whole-run-only/unavailable reasons and keep any reconstruction only as clearly internal investigation.

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

Production custom workout intervals now use resolved activity-boundary rows when the evidence gate passes: WorkoutKit planned rows are present and ordered, HealthKit activity rows are complete/contiguous and map to those rows or to a completed prefix for stopped-early workouts, pause/resume events are paired and contained within one row, and any post-fixed-row tail is deterministic. The row boundary source is the former Parity Lab candidate path; HealthKit samples enrich those rows with average HR, max HR, average power, and cadence where available.

Parity Lab/Raw Debug exports inspect the same resolver, label stopped-early rows as completed planned prefixes, show stopped-early row counts once at the section level, keep shared FIT caveats at summary level, and report structured comparison status against the completed prefix instead of the full unfinished plan. They no longer describe scoreable activity-boundary rows as categorically non-production; blocked comparisons still remain audit-only.

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

- Keep resolved activity-boundary row behavior stable across the archived Apple Fitness fixtures and priority workouts.
- Re-export the June 30 clean no-pause repeat fixed-cooldown/`Open / Extra` workout from a fresh current-build physical-iPhone install; the row evidence is validated, and the next proof is to confirm visible/export status labels now agree with the official resolved-row source.
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
- Structured custom workouts are settled only when the generalized resolver evidence gate passes. Missing plans, incomplete or non-contiguous activity rows, rows exceeding the plan, unpaired/cross-row pauses, unresolved repeat context, ambiguous recovery tails, repeat-tail cases, and reviewed warmup/work/cooldown outliers stay on fallback paths.
- Mechanics, trends, stronger run-type claims, and interval-row analytics remain confidence-gated.

## Recent Proof And Follow-Up

- `docs/validation/apple-fitness-interval-parity-dataset/user-supplied-june30-clean-repeat-tail-review-2026-06-30/` archives the June 30 user-supplied Apple Fitness screenshots, Raw HealthKit Debug markdown, parity packet JSON, and selected screen-recording frames for a clean no-pause `Warmup 2 km > 10x Work 200 m / Recovery 90 s > Cooldown 2 km > Open / Extra` workout. Resolved activity-boundary rows match the visible Apple Fitness sequence, cooldown, and `Open / Extra` tail. The user-supplied export still reports `open-tail-needs-rule`, so the next proof step is a fresh current-build physical-iPhone re-export that should show supported structured-comparison metadata.
- `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-priority-repeat-proof-2026-06-28/` archives the five-priority physical proof set. Priorities 1-5 have Apple Fitness screenshots, typed manual rows, and Raw HealthKit Debug/Parity Lab exports. Priority 1 drove the narrow paused fixed-cooldown/`Open / Extra` normal-detail gate; priorities 2-4 are clean no-pause controls; priority 5 is a paused/manual-skip guard case where activity-boundary candidate rows match Apple Fitness active/timer timing better than plan-derived reconstruction.
- Health Context follow-up: in-app Today/Data verification cards and neutral physical-iPhone check wording are implemented. Remaining proof is to verify VO2 Max and Resting Heart Rate on the physical iPhone after granting Apple Health read access.
- Best Efforts follow-up: visible official segment bests use `PersonalBestEffortEngine` exact distance-window records. Summary-only whole-run estimates must remain excluded. The likely blocker for older benchmark PRs is detailed HealthKit distance evidence coverage.
- Refresh architecture follow-up: monthly evidence refresh is transactional and persists month-scoped job/item checkpoints. Next proof is a physical-iPhone check for activation/scroll responsiveness, thermal behavior, and archived diagnostics/logs.
## 2026-06-28 Interval UI Note

- Paused reconstructed interval rows now expose elapsed row-window duration, paired pause overlap, active/timer duration, display basis, and matching pace basis so Priority-style review can compare normal detail, Raw Debug resolved activity-boundary rows, and Apple Fitness screenshots without hidden duration-basis mismatches.

## 2026-06-28 Resolved Custom Workout Rows

- Normal detail now resolves custom workout interval rows from complete contiguous HealthKit activity boundaries mapped to expanded WorkoutKit planned steps. The primary row duration uses active/timer time when paired pause overlap exists; RunSignal also exposes pause and elapsed row-window duration visibly.
- Resolved rows aggregate average HR, max HR, average running power, and cadence from HealthKit samples over the resolved row window.
- Resolved activity-boundary rows remain visible in evidence/debug inspection, but they are no longer categorically separate from production: they are the boundary source when evidence gates pass.

## 2026-06-29 Stopped-Early Prefix Rows

- Stopped-early custom workouts can now show the completed prefix of planned rows instead of blocking solely because planned row count is greater than HealthKit activity row count.
- Resolved activity-boundary rows and Raw Debug exports use the same completed-prefix mapping and suppress `Open / Extra` tails when planned rows remain uncompleted.

## 2026-06-29 UI Source Guardrail

- Raw Debug official rows, parity packets, and derived interval analytics use the same supported resolved-row resolver as the app view. Plan-derived reconstruction is not an official fallback interval source; blocked custom interval cases stay whole-run-only/unavailable with explicit reasons while separate boundary audit sections may show investigation evidence.
- Regression tests cover the repeated failure mode where row math is correct but a visible pace/duration tile still uses an older plan-derived or raw-marker source.
- Priority 5 screen-recording follow-up fixed the Raw Debug fallback display so a blocked legacy reconstruction does not mix a plan-derived row header with activity-boundary candidate tiles. When candidate rows are available for a blocked shape, the debug/export surface shows candidate Work, Cooldown, and Open / Extra rows coherently while keeping normal-detail promotion unchanged.

## 2026-06-30 Interval Status Agreement
- Normal detail fallback copy now uses one clean `Intervals under review` state with a `View Interval Evidence` path to Raw Debug, and the June 30 fixed-cooldown `Open / Extra` review message reports resolved boundary row evidence without adding unpaired-pause wording when paired pauses are zero.
- Raw Debug and exports now use `Official Interval Rows`, `Resolved Row Evidence`, and `Not promoted yet` labels so evidence existence and promotion status do not read as contradictory.
- Raw Debug developer controls, monthly diagnostics, and source/device metadata now sit behind a collapsed `Developer tools` disclosure, while official/resolved interval evidence rows use compact expandable rows so the first debug view is scan-friendly.
