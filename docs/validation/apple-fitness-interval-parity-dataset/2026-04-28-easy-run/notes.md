# Notes

## Files Added

- Apple Fitness: `IMG_6982.PNG`, `IMG_6983.PNG`
- RunSignal diagnostics export: `exports/runsignal-diagnostics/text-5DF517D06F26-1.txt`

## Validation Notes

- Apple Fitness workout name: `Tuesday Easy 7.25km`.
- Workout time: 46:31.
- Distance: 7.30 km.
- Apple Fitness visible intervals: Work and Open.
- RunSignal summary exists.
- WorkoutKit Plan Audit: not audited.
- WorkoutKit Reconstructed Intervals: unavailable.
- Boundary Diagnostics: unavailable.
- Evidence counts are zero for heart rate, speed, distance, active energy, power, cadence, step count, stride length, vertical oscillation, ground contact, and route points.
- Events count is 13, but HealthKit Segment Markers are unavailable and must remain raw/debug-only.

## Evidence Coverage Research

Apple Fitness shows interval rows for this older custom workout, but RunSignal cannot currently produce the planned structure, measured sample evidence, reconstructed intervals, or boundary diagnostics needed for parity comparison.

Possible causes to investigate:

- Older workout data availability.
- HealthKit query coverage.
- Sample association.
- Filtering.
- WorkoutKit plan availability for older custom workouts.
- App-side export behavior.
- Another HealthKit or WorkoutKit limitation.

Do not use April 28 for boundary-rule tuning until RunSignal evidence is available.
