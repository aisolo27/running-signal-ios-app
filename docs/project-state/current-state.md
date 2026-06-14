# RunSignal Current State

Last updated: 2026-06-14

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

- Broad production interval behavior remains unchanged. Swift interval changes are limited to the existing debug validation models and the explicitly approved narrow normal-detail internal gates.
- Raw HealthKit Debug has diagnostics-only Parity Lab infrastructure, selected-workout force re-enrich, monthly evidence refresh, parity packet export, and side-by-side `activityBoundaryCandidateSummary` / `activityBoundaryCandidateIntervals`.
- Raw HealthKit Debug and parity packet exports now include a debug-only `customWorkoutCandidateRuleSummary` / `customWorkoutCandidateRuleRows` scorer. It displays candidate elapsed duration, paired-pause overlap, active duration, distance, duration rule, and Open/Extra tail rows for selected workouts. It is Parity Lab/export-only and does not change production interval behavior or the normal workout detail UI.
- Raw HealthKit Debug now renders a debug-only "Parity Lab Candidate Rows" section in-app. It mirrors the scorer shape by showing structured comparison status/fallback, candidate row count, Open-tail count, paired pause count/total, elapsed duration, pause overlap, active duration, distance, and row mapping status. It remains debug-only and does not replace normal workout detail intervals.
- Raw HealthKit Debug and parity packet exports now include debug-only `customWorkoutComparisonSummary` with structured status, fallback reasons, row confidences, tail ambiguity, and explicit safety flags showing no production interval behavior change, no normal workout UI change, and no FIT runtime truth.
- Physical-iPhone structured comparison exports from 2026-06-14 exposed and fixed a false repeat-block blocker for one-iteration WorkoutKit blocks (`Block 1: 1x, 1 step(s)`). The bridge now treats actual expanded repeat iterations, not one-step blocks, as `repeat-block-needs-rule` blockers.
- Regenerated physical-iPhone exports from 2026-06-14 confirmed March 5, 2026 and April 24, 2026 now report `supported` with empty fallback reasons, while April 22 repeat-block and May 1 Open/Extra-tail guard cases remain blocked with the expected structured statuses.
- Normal workout detail now has internal gates for four narrow classes only: `Warmup(2 km) > one Work step > Cooldown(Open)`, `Warmup(2 km) > one Work step > fixed Cooldown > inferred Open / Extra tail`, clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > Cooldown(Open)`, and clean no-pause repeat blocks shaped as `Warmup(2 km) > repeated Work/Recovery rows > fixed Cooldown > inferred Open / Extra tail` when planned rows map one-to-one to HealthKit activity rows and the only extra row is the final tail. Physical iPhone screenshots from 2026-06-14 confirmed March 5, 2026 and April 24, 2026 show reconstructed Warmup/Work/Cooldown rows, and `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-repeat-block-proof-2026-06-14/` confirms May 20 and June 3 render expanded repeat rows with final `Cooldown` and no `Open / Extra` tail, while June 10 renders expanded repeat rows, fixed `Cooldown`, and final `Open / Extra`. Normal-detail gates now also require paired pauses to be absent for promoted time-goal rows and require reconstructed row starts/ends/distances to stay within tolerance of the matching HealthKit activity rows. April 22, 2026 and May 1, 2026 keep the blocked placeholder behavior. Paused repeat blocks, recovery-containing tail cases, ambiguous repeat tails, missing evidence, and unsupported shapes stay blocked.
- The debug-section build was installed and launched successfully on physical iPhone `AIS17PM` on 2026-06-13. Physical-phone Raw HealthKit Debug/parity packet exports for May 1, Jun 5, and Jun 10 are archived in `docs/validation/apple-fitness-interval-parity-dataset/physical-iphone-parity-lab-proof-2026-06-13/` and match the expected candidate rows within tolerance.
- Debug-only candidate boundary scoring is available at `docs/validation/apple-fitness-interval-parity-dataset/score_candidate_boundary_strategies.py`.
- Refreshed March-June 2026 monthly diagnostics are summarized in `docs/validation/apple-fitness-interval-parity-dataset/monthly-diagnostics-rollup-2026-03-to-2026-06.md`.
- March-June 2026 FIT reference evidence is summarized in `docs/validation/apple-fitness-interval-parity-dataset/fit-reference-rollup-2026-03-to-2026-06.md`.
- The FIT-backed two-gate plan is documented in `docs/validation/apple-fitness-interval-parity-dataset/fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md`.
- Gate A: FIT supports a narrow feature-flagged `HKWorkoutActivity` prototype for simple fixed-distance Work + Open only, but that prototype is intentionally not being implemented yet.
- Gate B: `docs/validation/apple-fitness-interval-parity-dataset/gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.md` adds row-level FIT lap/workout_step extraction. It found 2 warmup/work/cooldown cases with candidate row-level support, 17 repeat-block rule cases, 4 Open/Extra tail rule cases, and 2 inconclusive rows. Structured intervals remain blocked; no broad custom workout promotion or Swift prototype is approved.
- Gate B agent findings are consolidated in `docs/validation/apple-fitness-interval-parity-dataset/gate-b-agent-findings-2026-03-to-2026-06.md`. Derived docs-only scorecards now cover repeat-block evidence, Open/Extra tail evidence, and the narrow warmup/work/open-cooldown candidate class. Phase 3 remains blocked, but the exact no-tail `Warmup(2 km) > one fixed Work step > Cooldown(Open)` class has 2 supported rows worth a later debug-only discussion.
- Gate B timer-drift evidence is documented in `docs/validation/apple-fitness-interval-parity-dataset/gate-b-timer-drift-evidence-2026-03-to-2026-06.md`. The primary timer outliers remain excluded; candidate rows match FIT elapsed duration while FIT timer duration subtracts pause intervals exposed by debug HealthKit event packets.
- Custom workout shape coverage is inventoried in `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-shape-coverage-audit-2026-03-to-2026-06.md`. The narrow candidate understates real training coverage: easy fixed-goal runs are mostly Gate A Work/Open, Friday tempo-like rows split across no-tail, repeat/recovery, fixed-tail, and timer-drift shapes, and Wednesday intervals remain repeat/timer-rule blocked. Evidence collection should be balanced across easy, tempo, interval, tail, and pause/timer cases.
- Apple Fitness screenshot-confirmed custom workout rows are now captured in `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-confirmed-rows-2026-03-to-2026-06.json` and scored by `score_screenshot_confirmed_custom_workouts.py`. The scorecard confirms Apple Fitness expands repeat blocks into Work/Recovery rows, labels post-fixed-step residual movement as `Open`, and exposes workout-vs-elapsed time deltas that match debug pause evidence for 5 of 6 paused screenshot fixtures. May 1 targeted evidence is documented in `docs/validation/apple-fitness-interval-parity-dataset/may-1-open-tail-pause-evidence-2026-05-01.md`: fresh HealthKit debug exports and a matching HealthFit FIT export show two pause intervals totaling `232.8 s`, matching Apple Fitness's `233 s` elapsed-vs-workout-time gap, and the post-fixed-cooldown `Open / Extra` tail matches Apple Fitness `Open 16 m / 0:10`.
- `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-candidate-reconstruction-rule-scorecard-2026-03-to-2026-06.md` scores candidate reconstruction rules across all 12 screenshot-confirmed fixtures. The docs/debug rule set matches all 12 within tolerance, supports 3 Open-tail fixtures, supports 6 pause overview gaps, and shows May 1 is not an isolated overfit: the same active/timer duration rule also resolves paused repeat-block and paused warmup/work/cooldown fixtures. This is docs/debug validation only and does not approve production interval reconstruction.
- Fresh latest-debug-build iPhone parity exports are reviewed in `docs/validation/apple-fitness-interval-parity-dataset/fresh-iphone-parity-lab-export-review-2026-06-13.md`. Selected packets for May 1, Apr 22, May 29, Jun 5, and Jun 10 plus the May monthly diagnostics JSON all match the scorecard expectations for row counts, active duration, pause overlap, and Open/Extra tails. This reinforces the docs/debug scorer only; production interval behavior and normal workout UI remain unchanged.
- A complete balanced evidence batch is reviewed in `docs/validation/apple-fitness-interval-parity-dataset/balanced-evidence-batch-review-2026-06-13.md`. It covers all 12 screenshot-confirmed fixtures across easy/simple, tempo-like warmup/work/cooldown, repeat-block intervals, paused workouts, no-pause workouts, and Open-tail cases. All 12 match the current docs/debug scorer within the working tolerances. Apple Fitness screenshots are archived in `docs/validation/apple-fitness-interval-parity-dataset/apple-fitness-screenshot-archive-2026-06-13/`, and the external HealthFit FIT archive link is recorded in the batch review for future offline validation.
- Custom workout rule/spec work is documented in `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-reconstruction-rules.md`, `custom-workout-swift-gap-analysis.md`, and `custom-workout-implementation-plan.md`. Phase 1 internal expanded-step model types and Phase 2 debug comparison model types now exist for validation/debug use only; they do not change production interval behavior or normal workout UI.
- The current production-readiness path is documented in `docs/validation/apple-fitness-interval-parity-dataset/custom-workout-production-readiness-plan.md`. It keeps production interval behavior frozen, requires a separate debug-only prototype approval before Swift work, and requires a later production UI promotion gate before normal workout detail changes.
- Phase 2 debug comparison remains fallback-first: repeat blocks stay `repeat-block-needs-rule` unless an explicit repeat rule is approved, missing evidence wins over support/equivalence, and Open/Extra tail ambiguity blocks support unless the caller explicitly opts into the narrow fixed-cooldown tail rule.
- Duplicate, no-plan, and drift/guard-unknown workouts remain excluded from approval scoring.

## Current Known Limitations

- Some older runs are summary-only because detailed HealthKit series may be unavailable.
- FIT does not prove exact Apple Fitness UI presentation parity or private Apple smoothing/labeling rules.
- FIT is offline validation evidence only. It is not runtime truth, not an app data input, not a HealthFit dependency, and not a production data source.
- WorkoutKit plan data can be unavailable or throw and must stay optional.
- Structured and special custom workouts are not 100% settled; Gate B now has row-level FIT extraction, but repeat-block mapping, recovery-containing Open/Extra tail cases, repeat-block tail cases, and inconclusive warmup/work/cooldown outliers still block broad promotion.
- Mechanics, trends, and stronger run-type claims remain confidence-gated.

## Current Next Steps

- Use `docs/project-state/next-work.md` for the short current priority list.
- For parity work, use `docs/validation/apple-fitness-interval-parity-dataset/README.md`, `analysis-summary.md`, and `next-boundary-validation-plan.md`.
- Review `candidate-boundary-strategy-scorecard.md`, `hkworkoutactivity-boundary-scorecard.md`, and `fit-backed-two-gate-validation-plan-2026-03-to-2026-06.md` before changing boundary logic.
- Next implementation should keep the narrow normal-detail gates in place and avoid broad interval promotion until paused repeat-block, recovery-containing Open/Extra-tail, and ambiguous repeat-tail rules are explicitly approved.
- Continue Gate B work by reviewing row-level outliers and defining repeat-block plus Open/Extra tail rules before changing structured interval or warmup/work/cooldown behavior. Gate A simple Work/Open remains validated but parked.
- Next Gate B debug work should keep elapsed-vs-timer and pause-event diagnostics visible before reconsidering timer-drift outliers, and should use balanced shape coverage rather than only collecting more narrow warmup/work/open-cooldown rows.
- Next custom-workout work should use the production-readiness plan before any debug-only prototype discussion. Normal workout detail UI and production interval behavior remain blocked unless a later task explicitly approves them.
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
