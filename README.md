# RunningWorkoutAnalysis - iOS App

A modern iOS application using a **workspace + SPM package** architecture for clean separation between app shell and feature code.

## RunSignal Project Notes

RunSignal is a native iPhone SwiftUI app for evidence-grounded completed running workout analysis. The runtime data source is HealthKit, with real workout evidence verified on a physical iPhone.

- Completed workout summaries, samples, routes, and raw events come from HealthKit.
- Apple Watch custom workout planned structure should come from WorkoutKit `HKWorkout.workoutPlan` when available.
- HealthKit segment markers are retained for Raw HealthKit Debug only and should not be used as Apple Fitness interval labels.
- Production custom workout intervals use WorkoutKit planned steps plus complete contiguous HealthKit activity-boundary rows when the evidence gate passes.
- Debug and validation surfaces remain available for Raw HealthKit evidence review, but raw segment markers are not product interval rows.

## Codex Project Context

For current project direction and assistant rules, start with:

- `AGENTS.md`
- `docs/project-state/project-status.md`
- `docs/project-state/accuracy-ledger.md`
- `docs/project-state/documentation-index.md`

Archived template-era assistant rules live under `docs/archive/` and should only be opened for historical context.

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

## Key Architecture Points

### Workspace + SPM Structure
- **App Shell**: `RunningWorkoutAnalysis/` contains minimal app lifecycle code
- **Feature Code**: `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/` is where most development happens
- **Separation**: Business logic lives in the SPM package, app target just imports and displays it

### Buildable Folders (Xcode 16)
- Files added to the filesystem automatically appear in Xcode
- No need to manually add files to project targets
- Reduces project file conflicts in teams

## Development Notes

### Code Organization
Most development happens in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/` - organize your code as you prefer.

### Public API Requirements
Types exposed to the app target need `public` access:
```swift
public struct NewView: View {
    public init() {}
    
    public var body: some View {
        // Your view code
    }
}
```

### Adding Dependencies
Edit `RunningWorkoutAnalysisPackage/Package.swift` to add SPM dependencies:
```swift
dependencies: [
    .package(url: "https://github.com/example/SomePackage", from: "1.0.0")
],
targets: [
    .target(
        name: "RunningWorkoutAnalysisFeature",
        dependencies: ["SomePackage"]
    ),
]
```

### Test Structure
- **Unit Tests**: `RunningWorkoutAnalysisPackage/Tests/RunningWorkoutAnalysisFeatureTests/` (Swift Testing framework)
- **UI Tests**: `RunningWorkoutAnalysisUITests/` (XCUITest framework)
- **Test Plan**: `RunningWorkoutAnalysis.xctestplan` coordinates all tests

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

### SPM Package Resources
To include assets in your feature package:
```swift
.target(
    name: "RunningWorkoutAnalysisFeature",
    dependencies: [],
    resources: [.process("Resources")]
)
```

### Generated with XcodeBuildMCP
This project was scaffolded using [XcodeBuildMCP](https://github.com/cameroncooke/XcodeBuildMCP), which provides tools for AI-assisted iOS development workflows.
