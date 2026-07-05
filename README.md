# RunSignal iOS

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis. It reads completed running workouts from Apple Health/HealthKit and focuses on making Apple Watch custom workout evidence understandable: whole-run stats, charts, splits, official interval rows, Best Efforts, and reviewed run-purpose labels.

Last updated: 2026-07-05.

## Current Product Direction

RunSignal v1 is HealthKit-only and read-only.

- Runtime workout data comes from HealthKit completed running workouts.
- Apple Watch custom workout plans come from WorkoutKit `HKWorkout.workoutPlan` when available.
- Production custom-workout interval rows use WorkoutKit planned steps plus complete contiguous HealthKit activity-boundary rows when the public evidence gate passes.
- HealthKit segment markers are kept as Raw HealthKit Debug evidence only; they are not product interval rows or Apple Fitness labels.
- FIT files, HealthFit exports, screenshots, and archived validation packets are offline evidence only, not app inputs.
- Debug and validation screens remain available for evidence review, but the normal user workflow should lead with trusted whole-run stats, readiness states, official rows, and clear unavailable reasons.

Recent UX work includes:

- Faster perceived launch by deferring HealthKit background-delivery registration and foreground sync until after first render.
- Manual Analytics run-category labels that update optimistically and persist after a short guarded save.
- A user-facing Workout Plan card in workout detail that shows the WorkoutKit planned row structure before interval analysis.
- A normal full-analysis readiness card so Raw HealthKit Debug is secondary, not the primary path for loading or judging evidence.

## Key Features

- Completed runs list with HealthKit readiness and sample-data warnings.
- All-Time Best Efforts with exact evidence-backed records where detailed distance samples are available.
- Analytics tab with Week, Month, Year, and All-Time summaries.
- Manual run-purpose labeling for Analytics purpose mix.
- Workout detail with summary metrics, route/series evidence, Swift Charts cards, 1 km splits, WorkoutKit plan overview, and official interval analysis when supported.
- Raw HealthKit Debug, diagnostics export, parity packets, and monthly evidence refresh tools for validation work.

## Codex Project Context

For current project direction, assistant rules, and validation state, start with:

- `AGENTS.md`
- `docs/project-state/project-status.md`
- `docs/project-state/accuracy-ledger.md`
- `docs/project-state/documentation-index.md`

Use `docs/bug-log.md` as a selective lookup for recurring HealthKit, SwiftUI, startup, and validation gotchas. Archived docs under `docs/archive/` are historical context and should not be loaded by default.

## Project Architecture

```
RunningWorkoutAnalysis/
├── RunningWorkoutAnalysis.xcworkspace/              # Open this file in Xcode
├── RunningWorkoutAnalysis.xcodeproj/                # App shell project
├── RunningWorkoutAnalysis/                          # App target (minimal)
│   ├── Assets.xcassets/                # App-level assets (icons, colors)
│   ├── RunningWorkoutAnalysisApp.swift              # App entry point
│   └── RunningWorkoutAnalysis.xctestplan            # Test configuration
├── RunningWorkoutAnalysisPackage/                   # 🚀 Primary development area
│   ├── Package.swift                   # Package configuration
│   ├── Sources/RunningWorkoutAnalysisFeature/       # Your feature code
│   └── Tests/RunningWorkoutAnalysisFeatureTests/    # Unit tests
└── RunningWorkoutAnalysisUITests/                   # UI automation tests
```

Most implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`. The app target is intentionally thin and imports the package feature module.

## Build And Test

Open and run the app from:

```bash
open RunningWorkoutAnalysis.xcworkspace
```

Run package tests from the repo root:

```bash
swift test --package-path RunningWorkoutAnalysisPackage
```

For Xcode builds, use the `RunningWorkoutAnalysis` scheme with an iPhone destination. The project currently keeps `Package.swift` compatible with iOS 26 and macOS 14 so local package tests can run on macOS while the product remains iPhone-focused.

Physical iPhone verification matters for HealthKit behavior. Simulator runs use sample data and cannot prove real Apple Health permissions, real workout availability, HealthKit cache pressure, or physical launch performance.

## HealthKit And Validation Rules

- HealthKit is read-only. Do not add write/share HealthKit mutations for v1.
- Do not add FIT import, HealthFit import/export, or file-based workout ingestion unless the product direction changes explicitly.
- Keep WorkoutKit planned goals separate from measured HealthKit distance/time/pace.
- Whole-run stats remain usable even when interval rows are unavailable.
- Missing WorkoutKit plans, incomplete activity rows, inconsistent repeat context, unsupported tails, stale summary-only evidence, and malformed pause streams should show unavailable/review states rather than invented interval rows.
- After a fresh install or missing data state, use `Settings > Load HealthKit Runs` on the iPhone before judging HealthKit-dependent screens such as Best Efforts or official interval analysis.

## Configuration

### XCConfig Build Settings
Build settings are managed through **XCConfig files** in `Config/`:
- `Config/Shared.xcconfig` - Common settings (bundle ID, versions, deployment target)
- `Config/Debug.xcconfig` - Debug-specific settings  
- `Config/Release.xcconfig` - Release-specific settings
- `Config/Tests.xcconfig` - Test-specific settings

### Entitlements Management
App capabilities are managed through a **declarative entitlements file**:
- `Config/RunningWorkoutAnalysis.entitlements` - All app entitlements and capabilities
- AI agents can safely edit this XML file to add HealthKit, CloudKit, Push Notifications, etc.
- No need to modify complex Xcode project files

### Asset Management
- **App-Level Assets**: `RunningWorkoutAnalysis/Assets.xcassets/` (app icon, accent color)
- **Feature Assets**: Add `Resources/` folder to SPM package if needed

### Generated with XcodeBuildMCP
This project was scaffolded using [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP), which provides tools for AI-assisted iOS development workflows.
