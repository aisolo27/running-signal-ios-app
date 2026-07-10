# RunSignal iOS

RunSignal is a native iPhone SwiftUI app for evidence-grounded analysis of completed running workouts from Apple Health.

## Product

- HealthKit-only and read-only.
- Whole-run summaries, routes, charts, kilometer splits, Best Efforts, and period analytics.
- Manual run categories: Easy, Long, Interval, Threshold, Race, and Other.
- WorkoutKit plan display and official custom-workout interval analysis when public HealthKit evidence passes the resolver gate.
- Pause-aware interval timing, prescribed-versus-measured values, pace-target results, interval grouping, and trends.
- No FIT/HealthFit/file import, HealthKit writes, backend, or AI dependency.

## Architecture

```text
RunningWorkoutAnalysis.xcworkspace
├── RunningWorkoutAnalysis/                         thin app target
├── RunningWorkoutAnalysisPackage/
│   ├── Sources/RunningWorkoutAnalysisFeature/      primary implementation
│   └── Tests/RunningWorkoutAnalysisFeatureTests/   package tests
├── RunningWorkoutAnalysisUITests/                  UI smoke coverage
└── Config/                                         xcconfig and entitlements
```

Open `RunningWorkoutAnalysis.xcworkspace` and run the `RunningWorkoutAnalysis` scheme on an iPhone destination.

Package tests:

```bash
swift test --package-path RunningWorkoutAnalysisPackage
```

`Package.swift` supports iOS 26 and macOS 14 so package tests can run locally while the product remains iPhone-focused.

## Data Contract

- HealthKit completed workouts are runtime truth.
- WorkoutKit `HKWorkout.workoutPlan` supplies optional planned structure.
- HealthKit samples and `HKWorkoutActivity` rows supply completed metrics and boundaries.
- Product interval rows require complete evidence; otherwise the app keeps whole-run analytics and explains why intervals are unavailable.
- Simulator uses sample data. Real HealthKit permissions, workouts, background delivery, performance, and battery behavior require physical-iPhone verification.

## Current Context

- Current status and next work: `docs/project-state/project-status.md`
- Canonical edge cases and regression tests: `docs/project-state/regression-cases.md`
- HealthKit/WorkoutKit implementation contract: `docs/healthkit-contract.md`
- Recurring gotchas: `docs/bug-log.md`
