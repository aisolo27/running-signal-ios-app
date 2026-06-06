# 06. Workout Events, Intervals, and Laps

## Apple source
- https://developer.apple.com/documentation/healthkit/hkworkoutevent
- https://developer.apple.com/documentation/healthkit/hkworkouteventtype

## What workout events may represent
Workout events can represent changes or markers inside a workout, such as:
- Pause
- Resume
- Lap
- Segment
- Marker
- Other system-supported event types

The exact event availability depends on watchOS, workout type, recording app, and what the user did during the workout.

## Important limitation
HealthKit events may not include the same plain-English interval labels shown in Apple Fitness or the Workout app. Labels like:
- Warmup
- Work
- Recovery
- Cooldown
- Open

may need to be inferred from timing, workout structure, user-created plan data, manual labels, or app-specific rules.

## Recommended interval model
```swift
struct WorkoutInterval {
    let index: Int
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distanceMeters: Double?
    let label: IntervalLabel
    let source: IntervalSource
}

enum IntervalSource {
    case healthKitEvent
    case workoutPlan
    case inferred
    case manual
}
```

## Inference rules
When labels are not available:
- Do not pretend inferred intervals are Apple-provided.
- Use a confidence field.
- Preserve raw events.
- Prefer user workout-plan data when available.
- Use timestamps and distance boundaries for splits.

## Codex rules
- Store raw `HKWorkoutEvent` data.
- Build intervals as a separate derived layer.
- Label inferred intervals as inferred.
- Do not assume every lap is a work interval.
- Do not assume every pause means the workout should be excluded from analysis.
