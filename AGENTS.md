# AGENTS.md

- Start each new task by reading `docs/project-state/project-status.md`, then load only the additional docs that are directly relevant.
- Native iPhone SwiftUI app. Open and build `RunningWorkoutAnalysis.xcworkspace`; primary implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`, while the app target stays a thin shell.
- Before any Xcode build/run/test, call XcodeBuildMCP `session_show_defaults`; use the `RunningWorkoutAnalysis` scheme with an iPhone simulator such as `iPhone 17`. Avoid macOS build/run tools for this project.
- For simulator build/run/UI/log debugging, use the `build-ios-apps:ios-debugger-agent` skill. Use `build-ios-apps:ios-simulator-browser` only when the user asks to watch/interact through the browser, capture browser-visible proof, or iterate on SwiftUI previews.
- Treat "push/run/install live to my iPhone" as a physical-device install/verification request, not git push/deploy. First run package tests plus a Simulator smoke check, then use device workflow if available or give exact Xcode run steps; clearly report whether proof came from Simulator or the physical iPhone. After a successful physical-iPhone install/run, include a 1-3 item app-visible smoke checklist tailored to the change, and mention when a fresh install requires `Settings > Load HealthKit Runs` or another manual bootstrap before data-dependent screens such as Best Efforts can be judged.
- Package tests may run with `swift test --package-path RunningWorkoutAnalysisPackage`; keep `Package.swift` compatible with iOS 26 and macOS 14 so local package tests do not fail on SwiftUI/SwiftData availability.
- HealthKit v1 is read-only and Simulator-safe: keep sample data fallback, do not mutate HealthKit, and treat real workout/permission verification as a physical-iPhone step.
- Product data source is HealthKit-only. Do not add FIT file import, FIT backup, HealthFit export, or file-based workout ingestion unless the user explicitly reverses this direction.
- For Apple Watch custom workout intervals, use WorkoutKit `HKWorkout.workoutPlan` as the planned structure source when available and HealthKit samples for completed stats. Keep HealthKit segment markers raw/debug-only; do not treat them as Apple Fitness interval rows or labels.
- For custom workout interval strategy, use one official row pipeline: WorkoutKit planned rows plus complete contiguous HealthKit activity-boundary rows when the evidence gate passes. Do not hard-fit individual Apple Fitness screenshots into support. Do not substitute older plan/sample-derived reconstruction as product fallback rows; if the resolved-row gate is unavailable or blocked, show whole-run-only/unavailable reasons and keep any reconstruction only as clearly internal investigation.
- For interval UI changes, verify the same row across normal detail, Raw HealthKit Debug reconstructed intervals, Parity Lab candidate rows, and Apple Fitness screenshots when available. Explicitly check headline duration, pace, elapsed row-window duration, paired pause overlap, active/timer duration, distance, and whether the card is using active-timer or elapsed-window display.
- For HealthKit-heavy work, use `docs/healthkit-reference/` as the selective reference pack: start with `00-START-HERE-CODEX.md`, read `13-codex-rules-for-healthkit.md`, then only the relevant topic file(s). Avoid the archived combined HealthKit pack unless explicitly needed; verify API decisions against Apple docs.
- Keep milestone docs in `docs/milestones/` current. Do not mark a milestone complete until tests pass, Simulator launch is checked, and completion notes include remaining limitations.
- Before coding, skim `docs/bug-log.md` index and read only the section relevant to the task; add new entries only for durable recurring bugs or gotchas.
- After meaningful implementation or debugging work, before the final response, review whether any new durable gotcha belongs in `docs/bug-log.md`. Update it only for recurring project-specific issues, failed assumptions, toolchain gotchas, or verification lessons likely to affect future work; skip one-off temp paths, incidental errors, and generic advice.

## Context Loading and Documentation Policy

- Start each new task by reading `docs/project-state/project-status.md`.
- Read `docs/project-state/accuracy-ledger.md` after `project-status.md` only for workout-shape status, promotion, interval-row, or validation-status work.
- Do not automatically read all docs.
- Before reading any file, decide whether it is required for the task.
- Read `README.md` only when project setup or architecture is unclear.
- Read `docs/project-state/documentation-index.md` when deciding which docs are relevant.
- Do not load files listed in `docs/project-state/do-not-read-by-default.md` unless the task explicitly requires historical context.
- Read HealthKit reference docs only for HealthKit API decisions.
- Read validation docs only for Apple Fitness parity or evidence-review work.
- Read milestone docs only when updating or checking milestone status.
- Read bug-log sections selectively based on the current task.
- Do not open archived docs unless the task specifically asks for historical context.
- Treat repo cleanup as a separate audit track. For cleanup requests, first inventory folders/files, classify current vs stale vs archive-candidate, and propose moves; do not delete evidence, screenshots, exports, generated scorecards, or historical docs without explicit approval.
- Avoid broad reads of old validation fixture folders by default. Date-specific folders under `docs/validation/apple-fitness-interval-parity-dataset/`, screenshot archives, physical proof exports, `_nonfixture-exports`, `_future-*` templates, and `docs/archive/**` are evidence/history; read them only when the task names them, asks for cleanup, or the active project-state docs point to them.
- Keep `docs/project-state/project-status.md` updated after meaningful project changes.
- When a task changes project direction, validation status, known limitations, or next steps, update `docs/project-state/project-status.md` before the final response.
- Keep `project-status.md` concise. Do not let it become another long milestone document.
- Prefer updating `docs/project-state/documentation-index.md` when docs are added, archived, or reclassified.

## Token and Tool-Efficiency Rules

- Keep context small. Do not broadly scan the repo unless the task truly requires it.
- Start each task by identifying the smallest relevant file set, then inspect only those files.
- Do not load more than 10 files unless the task clearly requires broader investigation; if more context is needed, explain why before loading more.
- For UI-only changes, do not read HealthKit references, validation docs, or milestone docs unless the UI directly depends on them.
- For documentation-only changes, do not inspect Swift source files.
- For isolated feature changes, read only the files directly involved.
- Prefer `rg`, targeted file reads, and focused diffs over opening large files or directories.
- Do not reread README, AGENTS.md, milestone docs, HealthKit references, or validation docs unless they are directly relevant to the task.
- Do not reread files already inspected during the current task unless necessary.
- Do not use XcodeBuildMCP for routine code inspection or simple text edits.
- Use XcodeBuildMCP only for build, test, simulator, device, preview, or debugger workflows.
- Before any XcodeBuildMCP build/run/test action, call `session_show_defaults` and reuse the existing workspace, scheme, and simulator defaults.
- Do not rediscover schemes, simulators, package layout, or workspace structure unless a build failure indicates the defaults are stale.
- Prefer `swift test --package-path RunningWorkoutAnalysisPackage` for package-level validation before full Xcode builds.
- Run one focused validation pass after changes instead of repeated build loops.
- If validation fails, inspect the specific error output and affected files before rerunning.
- Keep final responses concise: changed files, validation performed, result, and remaining risks only.
