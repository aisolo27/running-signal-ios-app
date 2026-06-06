# 07. Workout Routes, Location, and Elevation

## Apple source
- https://developer.apple.com/documentation/healthkit/hkworkoutroute
- https://developer.apple.com/documentation/healthkit/hkworkoutroutequery
- https://developer.apple.com/documentation/corelocation/cllocation

## Workout route role
A workout route stores location points associated with a workout, when route recording is available and the user grants permission.

Route data can support:
- Map display
- Distance validation
- Pace over route segments
- Elevation gain estimation
- Start/end location display
- Detecting GPS gaps or bad samples

## Elevation
Elevation gain is usually calculated from altitude values on route points. Be careful:
- GPS altitude can be noisy.
- Small altitude changes should often be filtered.
- Indoor runs may have no route.
- Treadmill workouts usually do not have useful route points.
- Apple Fitness may use smoothing or device-specific logic not exposed as a direct field.

## Route-based calculations
When calculating from route points:
- Sort by timestamp.
- Remove invalid or duplicate points.
- Detect gaps.
- Apply reasonable smoothing for altitude.
- Do not overcount tiny altitude fluctuations.
- Document the calculation.

## Codex rules
- Do not require route data for workout import.
- Treat route and elevation as optional enrichment.
- Preserve raw `CLLocation` values where possible.
- Do not use route distance to override workout distance unless the app has a clear reconciliation rule.
