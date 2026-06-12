# Apple Fitness Interval Model Research

Date: Jun 11, 2026

## Current Evidence

Jun 10, 2026 Apple Fitness workout:

- Workout ID: `EDD82D4A-5683-4C60-A561-CED12D24DF0A`
- Apple Fitness title: `Wednesday Interval (6kmm)`
- Custom workout definition:
  - Warmup: 2 km, target pace 6:00-6:30 /km
  - Repeat 4 times:
    - Work: 400 m, target pace 3:40-3:50 /km
    - Recovery: 1:45
  - Cooldown: 2.5 km, target pace 6:00-6:30 /km
- Apple Fitness completed interval rows:
  - Warmup: 2.00 km, 12:30, 6:15 /km, 129 bpm
  - Work: 400 m, 1:30, 3:46 /km, 164 bpm
  - Recovery: 160 m, 1:45, 10:55 /km, 147 bpm
  - Work: 400 m, 1:31, 3:46 /km, 163 bpm
  - Recovery: 164 m, 1:45, 10:40 /km, 150 bpm
  - Work: 400 m, 1:28, 3:40 /km, 166 bpm
  - Recovery: 147 m, 1:45, 11:51 /km, 152 bpm
  - Work: 400 m, 1:27, 3:37 /km, 166 bpm
  - Recovery: 167 m, 1:45, 10:27 /km, 154 bpm
  - Cooldown: 2.50 km, 15:11, 6:04 /km, 150 bpm
  - Open: 5 m, 0:06, 17:56 /km, 154 bpm
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

## WorkoutKit Plan Audit Direction

The next useful investigation is Apple Watch custom workout recognition, not coaching logic. In the local iOS 26.5 SDK, WorkoutKit exposes `HKWorkout.workoutPlan: WorkoutPlan?` as an async throwing property. The SDK also exposes the pieces needed to describe a custom workout plan:

- `CustomWorkout` with `warmup`, repeatable `blocks`, and `cooldown`
- `IntervalBlock` / `IntervalStep` with work and recovery purposes
- `WorkoutStep` with a `WorkoutGoal` and optional alert
- `WorkoutGoal.open`, `.distance`, `.time`, and `.energy`
- alert types for pace, heart rate, power, and cadence ranges or thresholds

That gives RunSignal a cleaner source for the planned structure if Apple makes it available for this completed `HKWorkout`. It still must be treated as optional. The API can return `nil` or throw, and the current HealthKit segment markers prove that raw events alone are not enough to recreate Apple Fitness labels.

Audit-first scope:

1. On the physical iPhone, attempt to read `workout.workoutPlan` for workout `EDD82D4A-5683-4C60-A561-CED12D24DF0A`.
2. Log whether a plan is available, unavailable, or failed with an error.
3. If available, dump only durable public fields: custom workout display name, warmup goal/alert, block iteration count, work/recovery goals and alerts, cooldown goal/alert, and any public display names.
4. Continue dumping raw `HKWorkoutEvent` type, date interval, duration, and metadata keys/values for comparison.
5. Keep private metadata keys audit-only; do not make production logic depend on them.
6. Do not display an Apple Fitness Intervals table in the main UI until the app can pair plan steps with actual HealthKit sample windows with explicit confidence.

If `workoutPlan` is available for this completed workout, the next model should distinguish planned rows from actual completed rows:

```swift
enum StructuredWorkoutPlanSource: String, Codable, Sendable {
    case workoutKitComposition
    case runSignalScheduledWorkout
    case healthKitWorkoutEventsOnly
    case heuristic
    case unavailable
}

struct CompletedWorkoutStep: Codable, Equatable, Sendable {
    var index: Int
    var stepType: DerivedIntervalLabel
    var repeatIndex: Int?
    var plannedGoal: String?
    var plannedTarget: String?
    var actualStartDate: Date
    var actualEndDate: Date
    var actualDurationSeconds: Double
    var actualDistanceMeters: Double?
    var actualPaceSecondsPerKm: Double?
    var averageHeartRateBpm: Double?
    var confidence: ConfidenceLevel
    var notes: [String]
}
```

This should stay v1 parity-focused: recognize Apple Watch custom workout structure, compute actual stats from HealthKit samples, and show targets only when WorkoutKit or a future RunSignal-owned plan provides them.

Implementation note on Jun 11, 2026: RunSignal now attaches a `WorkoutKit Plan Audit` result to persisted workout evidence and shows it in Raw HealthKit Debug. The audit attempts `HKWorkout.workoutPlan`, reports available/unavailable/failed/unsupported, and dumps public custom-workout structure when available. This is still read-only evidence gathering; the main Apple Fitness Intervals card remains gated.

Physical-iPhone result on Jun 11, 2026: WorkoutKit returned a plan for the completed Jun 10 workout.

- Status: available
- Plan type: custom workout
- Display name: `Wednesday Interval (6kmm)`
- Plan ID: `77EBFFFA-254C-4E57-B567-DF975A19415A`
- Warmup: 2 km, current pace/speed range equivalent to roughly 6:00-6:30 /km
- Block 1: 4 iterations, 2 steps
- Work step: 400 m, current pace/speed range equivalent to roughly 3:40-3:50 /km
- Recovery step: 105 seconds, no alert
- Cooldown: 2.50 km, current pace/speed range equivalent to roughly 6:00-6:30 /km

This confirms WorkoutKit is the right source for planned custom-workout structure on this device/OS combination. HealthKit segment markers should remain raw evidence; the next implementation layer should pair WorkoutKit plan steps with actual HealthKit sample windows.

Implementation note on Jun 11, 2026: Added a debug-only `WorkoutKit Reconstructed Intervals` prototype. It flattens available WorkoutKit custom workout plans into ordered planned steps, reconstructs distance-goal windows from HealthKit distance samples, reconstructs time-goal windows from elapsed time, adds an Open/Extra tail when remaining time or distance is nontrivial, and computes distance, duration, pace, heart-rate, cadence, and power stats from HealthKit evidence. It explicitly labels HealthKit segment markers as not used for reconstruction.

Physical-iPhone reconstruction result on Jun 11, 2026:

| Row | Apple Fitness | RunSignal reconstruction | Initial read |
| --- | --- | --- | --- |
| Warmup | 2.00 km, 12:30, 6:15 /km, 129 bpm | 2.00 km, 12:25, 6:12 /km, 129 bpm | Close; HealthKit distance interpolation ends about 5 sec early. |
| Work 1 | 400 m, 1:30, 3:46 /km, 164 bpm | 0.40 km, 1:30, 3:45 /km, 159 bpm | Close. |
| Recovery 1 | 160 m, 1:45, 10:55 /km, 147 bpm | 0.17 km, 1:45, 10:15 /km, 151 bpm | Close distance/time; pace/HR differ modestly. |
| Work 2 | 400 m, 1:31, 3:46 /km, 163 bpm | 0.40 km, 1:30, 3:45 /km, 158 bpm | Close. |
| Recovery 2 | 164 m, 1:45, 10:40 /km, 150 bpm | 0.17 km, 1:45, 10:08 /km, 156 bpm | Close distance/time; pace/HR differ modestly. |
| Work 3 | 400 m, 1:28, 3:40 /km, 166 bpm | 0.40 km, 1:28, 3:39 /km, 158 bpm | Close pace/time; HR lower from current sample window. |
| Recovery 3 | 147 m, 1:45, 11:51 /km, 152 bpm | 0.16 km, 1:45, 11:11 /km, 157 bpm | Close distance/time; pace/HR differ modestly. |
| Work 4 | 400 m, 1:27, 3:37 /km, 166 bpm | 0.40 km, 1:27, 3:37 /km, 162 bpm | Close. |
| Recovery 4 | 167 m, 1:45, 10:27 /km, 154 bpm | 0.18 km, 1:45, 9:58 /km, 157 bpm | Close distance/time; pace/HR differ modestly. |
| Cooldown | 2.50 km, 15:11, 6:04 /km, 150 bpm | 2.50 km, 15:10, 6:04 /km, 150 bpm | Very close. |
| Open | 5 m, 0:06, 17:56 /km, 154 bpm | 0.01 km, 0:11, 15:05 /km, 154 bpm | Tail is larger because the reconstructed warmup ended early. |

This proves the architecture: WorkoutKit provides the planned rows and HealthKit samples can reproduce the completed interval table closely enough for debug validation. The remaining accuracy issue is boundary alignment/tolerance, especially the first distance-goal boundary. Do not use raw segment markers as labels, but future matching may use them only as optional boundary evidence if it is explicitly labeled and tested as boundary refinement.

Implementation note on Jun 11, 2026: Refined WorkoutKit distance-goal reconstruction to compare the interpolated cumulative-distance crossing with the crossing HealthKit distance sample end. Production now prefers the crossing sample end only when overshoot is inside a small step-size-aware tolerance; otherwise it falls back to interpolation. Reconstructed distance rows expose a compact debug note with the boundary strategy, adjustment from interpolation, and overshoot. Added a Jun 10 Apple Fitness tolerance fixture plus tests for interpolated fallback, crossing-sample-end selection, cursor advancement, Open/Extra tail shrinkage, and the rule that HealthKit segment markers are not reconstructed interval rows.

Physical-iPhone boundary-refinement check on Jun 11, 2026: The revised Raw HealthKit Debug screenshots show the WorkoutKit + HealthKit reconstructed interval approach is validated for the Jun 10 Apple Watch custom workout within the current tolerance bands. Warmup moved from 12:25 to 12:26 with crossing sample end, adjustment +1.8s, overshoot 5.3 m; this remains 4 seconds short of Apple Fitness 12:30, inside the acceptable 5-second tolerance but outside the preferred 3-second target. Open / Extra shrank from 0:11 to 0:08, close to Apple Fitness 0:06. Work reps stayed close at 1:30, 1:29, 1:27, and 1:27. Recoveries stayed exactly 1:45, with distances still slightly high but within short-recovery tolerance. Cooldown stayed close at 15:12, 2.51 km, using crossing sample end with adjustment +2.3s and overshoot 6.2 m. The debug source still states HealthKit segment markers are not used.

Documentation-informed re-check on Jun 12, 2026: Apple documentation confirms the public WorkoutKit and HealthKit model but not Apple Fitness's exact row-rendering algorithm. For v1 parity, keep WorkoutKit as the planned structure source, HealthKit samples as the measured stats source, Apple Fitness screenshots as the visual reference, Raw HealthKit Debug exports as RunSignal evidence, and HealthKit Segment Markers as raw/debug-only. Post-cooldown `Open / Extra` can be correct when a distance/time cooldown goal is complete and running continues; do not merge it into `Cooldown` by default. The June 3 dataset blocker is narrower: Apple Fitness shows a final `Cooldown` row and the WorkoutKit plan has `Cooldown: goal open`, while RunSignal currently treats the remaining open planned cooldown as `Open / Extra`.

Targeted app refinement on Jun 12, 2026: RunSignal now reconstructs a final planned `Cooldown` step with goal `open` as `Cooldown` through workout end and does not create a separate `Open / Extra` row for that case. Fixed distance/time cooldowns still end at their planned goal boundary, and meaningful continued running after that boundary remains `Open / Extra`. Raw HealthKit Debug now includes compact boundary-neighbor diagnostics for distance-goal rows and final-tail diagnostics for `Open / Extra` rows so June 1 can be re-exported before changing boundary logic.

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

The key research question is whether the 12 HealthKit segment markers align with those boundaries. Current physical-iPhone screenshots show they do not expose the completed custom-workout interval labels. The split-like marker rows align with Apple Fitness split rows, while overlapping segment windows cross custom-workout boundaries. RunSignal should avoid interval rows and continue showing splits plus the explanatory unavailable state.

## Next Implementation Slice

Status: started on Jun 11, 2026. RunSignal now has a hidden `DerivedWorkoutInterval` candidate model, a pure event-window derivation function, synthetic tests, and Raw HealthKit Debug output. The main Apple Fitness Intervals card still stays in the explanatory unavailable state.

Follow-up on Jun 11, 2026: Raw HealthKit Debug now labels these rows as `HealthKit Segment Markers`, includes start/end offsets from workout start, and classifies split-like or overlapping marker windows so they are not mistaken for Apple Fitness intervals.

Physical-iPhone screenshots from Jun 11, 2026 show the split-like marker durations align with Apple Fitness split rows, not Apple Fitness interval rows:

| Marker rows | Durations | Interpretation |
| --- | --- | --- |
| 1, 3, 5, 6, 8, 10, 11 | 6:16, 6:12, 4:52, 5:57, 6:33, 6:02, 4:46 | Matches Apple Fitness split rows, including the final partial split. |
| 2, 4, 7, 9, 12 | 10:01, 9:13, 9:31, 9:43, 2:08 | Overlapping segment windows; keep raw/debug-only. |

The rows still show `Unknown` labels, so HealthKit has not exposed Apple Fitness Warmup/Work/Recovery/Cooldown/Open labels for this workout.

This evidence is now enough to reject promoting raw segment markers to the main Apple Fitness Intervals card. A future derived interval model would need a separate source of custom-workout step labels or a clearly tested inference layer, because these HealthKit marker rows alone describe split-like and overlapping windows.

Remaining:

1. Refine boundary alignment for distance-goal steps, starting with the warmup 5-second drift and the extra-tail size.
2. Keep the main Apple Fitness Intervals UI gated until boundary tolerance and source labels are explicit.
3. Add fixture tests for the Jun 10 reconstructed table and accepted tolerance bands.

Completed:

- Add a hidden `DerivedWorkoutInterval` model and pure derivation function.
- Add fixture tests using synthetic event windows and distance samples:
   - 2 km warmup at 12:30
   - 400 m work at 1:30
   - 160 m recovery at 1:45
- Add a debug view section that prints candidate intervals with source, confidence, distance, time, pace, heart rate, and caveats.
- Re-export and review the Jun 10 Raw HealthKit Debug output from the physical iPhone.
- Compare marker boundaries against Apple Fitness split rows.
- Add a WorkoutKit plan audit hook to Raw HealthKit Debug.
- Verify that WorkoutKit returns the completed Jun 10 custom workout plan on the physical iPhone.
- Add a debug-only WorkoutKit interval reconstruction prototype.
