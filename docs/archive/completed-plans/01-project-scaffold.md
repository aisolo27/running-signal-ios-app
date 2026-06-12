# Milestone 1: Project Scaffold

## Goal
Create the native iPhone SwiftUI project, tab shell, sample fixtures, core models, and unit-test target.

## Affected Areas
- Xcode workspace and app shell
- `RunningWorkoutAnalysisPackage`
- SwiftUI tabs and sample data
- Swift Testing target

## Exact Tasks
- Scaffold real Xcode workspace/project with XcodeBuildMCP.
- Build five tabs: Today, Latest Run, Race Goal, History, Data.
- Add sample running workouts for Simulator.
- Add canonical workout models and pace helpers.
- Add unit tests for core math.

## Acceptance Criteria
- App opens as a native iPhone SwiftUI app.
- Every tab has nonblank content with sample data.
- Core pace math stores pace as seconds per kilometer.
- Unit tests are present and runnable.

## Test Commands
- XcodeBuildMCP `session_show_defaults`
- XcodeBuildMCP unit test/build/run commands

## Simulator Checks
- Launch on iPhone simulator.
- Verify five tabs are visible.
- Verify no blank first screen or obvious text overlap.

## Known Risks
- HealthKit cannot be fully verified in Simulator.
- App icon remains default.

## Completion Notes
- Completed. XcodeBuildMCP scaffolded `RunningWorkoutAnalysis.xcworkspace`; sample data tabs render on iPhone 17 Simulator. Package tests and iOS simulator tests passed.
