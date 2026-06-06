# 13. Codex Rules for HealthKit Work

This file should be read first by Codex before changing any iOS HealthKit logic.

## Non-negotiable rules

1. Apple documentation is the source of truth.
Before adding or changing HealthKit logic, verify the relevant Apple documentation link in `references/apple-healthkit-links.md`.

2. Never copy Apple Fitness assumptions blindly.
Apple Fitness may display fields that are calculated or presented differently from raw HealthKit data.

3. Separate raw data from derived data.
Raw HealthKit objects and app-derived metrics must be stored separately.

4. Preserve HealthKit identity.
Every imported workout and sample should preserve UUID, source, source revision, date range, and metadata when available.

5. Do not use zero as missing data.
Use explicit missing states.

6. Use optional metrics.
Running power, cadence, stride length, vertical oscillation, ground contact time, route, and elevation may be unavailable.

7. Query incrementally.
Use anchored queries and observer queries for ongoing sync. Do not re-import full history on every app launch.

8. Make calculations auditable.
Derived pace, splits, intervals, elevation, and drift should have documented inputs and calculation methods.

9. Keep HealthKit out of SwiftUI views.
Use a service/client layer.

10. Protect privacy.
Request only needed data types and provide clear user-facing explanations.

## App-specific HealthKit interpretation
For the current running app:
- Distance: prefer `HKWorkout` total distance when available; otherwise use documented fallback.
- Duration: use workout duration, and keep elapsed vs moving time separate.
- Active calories: use HealthKit active energy where available.
- Total calories: do not invent unless the app has a documented basal/resting calculation.
- Heart rate: derive average, max, and chart values from samples.
- Pace: calculate from distance/time or speed samples. Do not rely on rounded UI values.
- Splits: derive from distance/time samples or route points with interpolation.
- Intervals: use workout events or workout-plan data if available; otherwise infer and label as inferred.
- Elevation: calculate from route altitude if available, with smoothing/filtering.
- Running power/form metrics: optional sample-based values, not guaranteed.

## Required tests
When Codex changes HealthKit import or metrics logic, it should add or update tests for:
- Workout deduplication
- Missing heart rate
- Missing route
- Pace formatting
- Split boundary interpolation
- Pause/resume handling
- Interval labeling confidence
- Unit conversion
- Duplicate source handling
