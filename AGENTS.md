# RunSignal Agent Router

- Start every task with `docs/project-state/project-status.md`; it is the only current project-status and next-work authority.
- Read `docs/project-state/change-and-decision-log.md` before changing an established architecture, performance boundary, data contract, or runner-facing behavior, or when the request asks why a prior decision exists.
- Read `docs/project-state/regression-cases.md` only for interval behavior, edge cases, or evidence retention.
- Read `docs/healthkit-contract.md` only for HealthKit, WorkoutKit, ingestion, or persistence decisions.
- Skim the index in `docs/bug-log.md` before coding and load only the relevant section.
- Do not treat old commits or retained proof notes as current plans.

## Build And Verification

- Native iPhone SwiftUI app. Open `RunningWorkoutAnalysis.xcworkspace`; use the `RunningWorkoutAnalysis` scheme.
- Primary implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`; keep the app target thin.
- Package tests: `swift test --package-path RunningWorkoutAnalysisPackage`.
- Keep `Package.swift` compatible with iOS 26 and macOS 14.
- Before Xcode build/run/test, call XcodeBuildMCP `session_show_defaults` and reuse the workspace, scheme, and an iPhone simulator such as iPhone 17.
- Use the `build-ios-apps:ios-debugger-agent` skill for Simulator build/run/debug work.
- Treat physical-iPhone and Simulator proof separately. Simulator uses sample data and cannot prove HealthKit behavior.
- “Push/run/install live to my iPhone” means package tests, Simulator smoke, then physical-device install/run when available.

## Specialized Swift Skills

- Use the global `swiftdata-pro` skill for SwiftData models, queries, persistence, migrations, and store correctness.
- Use the global `swift-concurrency-pro` skill for actors, isolation, `Sendable`, async task design, cancellation, and concurrency warnings or failures.
- Use the global `swift-testing-pro` skill when adding or reviewing Swift Testing coverage, diagnosing test failures, or improving test structure.
- Invoke `$swiftui-pro-audit` only when the user explicitly requests a UI audit, a major SwiftUI screen change, or a pre-release UI quality review. It is review-first and must not change code unless implementation is requested.
- Preserve RunSignal's established visual language and runner-facing behavior. Local product decisions and current project authority override generic skill preferences; do not broadly redesign or reorganize the UI merely because a skill suggests a different pattern.

## Product Boundaries

- HealthKit v1 is read-only and HealthKit-only. Do not add FIT/HealthFit/file ingestion, HealthKit writes, backend sync, or AI calls unless the user changes direction.
- WorkoutKit planned rows are planned structure. HealthKit samples and activities are completed evidence.
- Product custom-workout rows use the generalized evidence gate documented in `project-status.md`.
- Raw HealthKit markers and old plan/sample reconstruction remain debug-only.
- When the product row gate fails, preserve whole-run analytics and show a clear unavailable reason.
- Interval UI must keep prescribed values, measured totals, elapsed windows, pause overlap, active/timer duration, and display basis distinct.

## Scope And Hygiene

- Start implementation work on a `codex/` feature branch instead of changing `main` directly.
- When the user says `push live`, verify the in-scope work, merge the feature branch into `main`, delete the local feature branch, and then push `main` to GitHub unless told otherwise.
- Inspect the smallest relevant file set; prefer `rg` and focused diffs.
- Preserve unrelated user changes.
- Do not commit, push, release, or mutate live/provider data without explicit authorization.
- Cleanup work must retain the canonical cases in `docs/validation/regression-evidence/` unless the matching registry entry and tests are deliberately replaced.
- Add only recurring project-specific gotchas to `docs/bug-log.md`.
- Add durable decisions and supersessions to `docs/project-state/change-and-decision-log.md`; keep Git history as the exhaustive file-level record and do not turn the decision log into a backlog.
- After meaningful changes, update `project-status.md` only when current direction, limitations, verification, or next work actually changed.
