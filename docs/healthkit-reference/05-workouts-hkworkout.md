# 05. Workouts and HKWorkout

## Apple source
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hkworkoutactivitytype
- https://developer.apple.com/documentation/healthkit/hkworkouttype

## What HKWorkout gives the app
`HKWorkout` represents a workout session. For running, it usually contains:
- Workout activity type
- Start date
- End date
- Duration
- Total distance, if recorded and available
- Total active energy, if recorded and available
- Metadata
- Workout events

## Direct fields vs derived fields
Treat the following as likely direct workout-level fields:
- Distance
- Duration
- Activity type
- Start/end time
- Active energy

Treat the following as often derived or sample-based:
- Average pace
- Split pace
- Heart rate averages
- Heart rate drift
- Elevation gain
- Cadence summaries
- Ground contact time summaries
- Vertical oscillation summaries
- Stride length summaries
- Interval labels

## Unit normalization
Recommended internal units:
- Distance: meters
- Duration: seconds
- Pace: seconds per kilometer
- Speed: meters per second
- Energy: kilocalories
- Heart rate: beats per minute
- Power: watts
- Cadence: steps per minute or strides per minute, explicitly labeled
- Ground contact time: milliseconds
- Vertical oscillation: centimeters or millimeters, explicitly labeled
- Stride length: meters

## Codex rules
- Do not calculate pace from rounded display distance.
- Use precise distance and duration when available.
- If total distance is missing, derive distance from distance samples or route points only when the derivation method is explicit.
- Show missing data honestly.
- Keep workout import idempotent using the HealthKit workout UUID.
