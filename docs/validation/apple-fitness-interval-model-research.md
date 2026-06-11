# Apple Fitness Interval Model Research

Date: Jun 11, 2026

## Current Evidence

Jun 10, 2026 Apple Fitness workout:

- Workout ID: `EDD82D4A-5683-4C60-A561-CED12D24DF0A`
- Apple Fitness title: `Wednesday Interval (6kmm)`
- Apple Fitness interval rows visible in screenshots:
  - Warmup: 2.00 km, 12:30, 6:15 /km
  - Work: 400 m, 1:30, 3:46 /km
  - Recovery: 160 m, 1:45, 10:55 /km
  - Work: 400 m, 1:31, 3:46 /km
  - Recovery: 164 m, 1:45, 10:40 /km
- RunSignal raw HealthKit event summary for this workout: `12 segment markers, 1 pause markers`
- Apple Fitness split breakdown shows seven 1 km split rows: 6:16, 6:12, 4:52, 5:57, 6:33, 6:02, and 4:46.
- The first RunSignal event-window debug pass showed several HealthKit segment windows matching those split rows rather than the Apple Fitness interval table. Example: marker 1 was 6:16 / 1.01 km, marker 3 was 6:12 / 1.00 km, marker 5 was 4:52 / 1.00 km, marker 6 was 5:57 / 1.00 km, and marker 8 was 6:33 / 0.99 km.

## Why Raw Events Are Not Enough

Apple's HealthKit documentation describes `HKWorkoutEvent` as workout events such as pause, resume, lap, segment, and marker. Apple also documents that lap and segment events can have nonzero date intervals.

That is enough to preserve raw markers, but not enough to present Apple Fitness interval rows, because Apple Fitness displays:

- Human labels such as Warmup, Work, and Recovery
- Distance for each interval row
- Time for each interval row
- Pace for each interval row
- Sometimes heart-rate context in deeper views

The current HealthKit event payload we can see does not prove those row labels or distances. Therefore RunSignal should keep the current `Not comparable yet` card until it builds a derived interval layer with explicit confidence.

## Proposed Derived Model

```swift
struct DerivedWorkoutInterval: Codable, Equatable, Sendable {
    var index: Int
    var label: DerivedIntervalLabel
    var startDate: Date
    var endDate: Date
    var durationSeconds: Double
    var distanceMeters: Double?
    var paceSecondsPerKm: Double?
    var averageHeartRateBpm: Double?
    var source: DerivedIntervalSource
    var confidence: ConfidenceLevel
    var caveats: [String]
}

enum DerivedIntervalLabel: String, Codable, Sendable {
    case warmup
    case work
    case recovery
    case cooldown
    case open
    case unknown
}

enum DerivedIntervalSource: String, Codable, Sendable {
    case healthKitLabeledEvent
    case healthKitSegmentPattern
    case inferredPattern
    case manual
}
```

## Derivation Strategy

Phase 1 should be analysis-only, hidden from the main workout UI unless confidence is moderate or better.

1. Preserve raw `HKWorkoutEvent` rows exactly as debug evidence.
2. Build candidate intervals only from event date intervals when the event duration is positive and within the workout bounds.
3. Calculate interval distance from the distance series by interpolating cumulative distance at each interval start and end.
4. Calculate pace from interval distance and interval duration.
5. Calculate average heart rate from heart-rate samples inside the interval window.
6. Label rows only when there is evidence:
   - Use exposed labels if HealthKit metadata has plain labels.
   - Use `unknown` if labels are missing.
   - Consider `work/recovery` inference only when repeated distance/time patterns match a planned interval structure.
7. Never call inferred rows "Apple Fitness Intervals"; label them as RunSignal-derived intervals until parity is proven.

## Confidence Rules

- `strong`: labeled HealthKit or workout-plan intervals plus distance and heart-rate samples.
- `moderate`: repeated segment pattern with interpolated distance and duration matching Apple Fitness within tolerance.
- `limited`: event durations exist, but labels or distances are missing.
- `unavailable`: no usable event intervals or no distance/time series.

## Jun 10 Hypothesis

For the visible Apple Fitness rows, the likely intended pattern is:

- 2 km warmup
- 400 m work repeats
- roughly 160 m recoveries
- later cooldown/open running after repeats

The key research question is whether the 12 HealthKit segment markers align with those boundaries. If they do, RunSignal can derive interval rows from marker windows plus distance-series interpolation. If they do not, RunSignal should avoid interval rows and continue showing splits plus the explanatory unavailable state.

## Next Implementation Slice

Status: started on Jun 11, 2026. RunSignal now has a hidden `DerivedWorkoutInterval` candidate model, a pure event-window derivation function, synthetic tests, and Raw HealthKit Debug output. The main Apple Fitness Intervals card still stays in the explanatory unavailable state.

Follow-up on Jun 11, 2026: Raw HealthKit Debug now labels these rows as `HealthKit Segment Markers`, includes start/end offsets from workout start, and classifies split-like or overlapping marker windows so they are not mistaken for Apple Fitness intervals.

Remaining:

1. Re-export the Jun 10 Raw HealthKit Debug output from the iPhone.
2. Compare candidate boundaries against the Apple Fitness interval screenshot before showing any interval table in the main v1 UI.
3. Add fixture tests using real Jun 10 candidate values if the debug output shows candidate boundaries close enough to Apple Fitness.

Completed:

- Add a hidden `DerivedWorkoutInterval` model and pure derivation function.
- Add fixture tests using synthetic event windows and distance samples:
   - 2 km warmup at 12:30
   - 400 m work at 1:30
   - 160 m recovery at 1:45
- Add a debug view section that prints candidate intervals with source, confidence, distance, time, pace, heart rate, and caveats.
