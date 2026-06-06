# 08. Running Metrics: Heart Rate, Power, Cadence, and Form

## Apple source
- https://developer.apple.com/documentation/healthkit/hkquantitytypeidentifier
- https://developer.apple.com/documentation/healthkit/hkquantitysample
- https://developer.apple.com/documentation/healthkit/workouts_and_activity_rings

## Common running metrics
Apple Watch and HealthKit may provide some of the following, depending on watch model, watchOS, workout type, and permissions:
- Heart rate
- Running power
- Running speed
- Step count
- Running stride length
- Running vertical oscillation
- Running ground contact time
- Distance walking/running
- Active energy burned

Some metrics may not exist for older workouts, older watch models, or workouts recorded by third-party apps.

## Heart rate
Use heart rate samples to calculate:
- Average heart rate
- Max heart rate
- Heart rate over time
- Zone distribution
- Heart rate drift
- Recovery heart rate patterns

Be careful with missing samples, sparse samples, and sensor dropouts.

## Running power
Power should be treated as a time-series metric. Use source and timestamps. Do not assume a single workout-level value exists unless HealthKit provides it or the app calculates it.

## Cadence
Cadence may come from running-specific samples if available, or it may need to be estimated from steps over time. If estimated, label it clearly.

## Running dynamics
Ground contact time, vertical oscillation, and stride length are optional. Do not force these fields into every workout.

## Codex rules
- Never assume Apple Watch recorded every running metric.
- Use optional fields and missing-data states.
- Calculate averages from time-aligned samples.
- Exclude obvious dropouts when the app has documented filtering rules.
- Keep sample-level data available for charts and future recalculation.
