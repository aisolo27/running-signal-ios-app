# 00. HealthKit Overview

## Apple source
- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework

## Summary
HealthKit is Apple's framework for reading and writing health and fitness data after the user grants permission. For a running app, HealthKit should be treated as the trusted system source for Apple Watch workouts, workout samples, health samples, workout routes, and metadata.

HealthKit does not always expose the exact same display labels shown in Apple Fitness. Apple Fitness may combine raw HealthKit records, Apple Watch samples, workout events, route points, and Apple-specific presentation logic. Your app should read the underlying data and calculate clear derived values when Apple does not provide a ready-made field.

## How this applies to the running app
Use HealthKit as the primary source for:
- Workout records such as distance, duration, activity type, start/end time, and energy where available.
- Time-series samples such as heart rate, running power, speed, step count, and other running dynamics when recorded.
- Workout routes when location permissions and route data exist.
- Workout events such as pause/resume, segment, lap, and marker events when available.

Do not assume HealthKit contains:
- Apple Fitness screen labels exactly as displayed.
- Human-readable interval names such as Warmup, Work, Cooldown, Open, or Recovery.
- Perfect splits already calculated.
- Total calories in the same exact form Apple Fitness displays.

## Codex implementation guidance
When importing workouts, Codex should build the app around raw HealthKit data plus explicit derived calculations:
- Store the original HealthKit identifiers and metadata.
- Store raw samples separately from derived metrics.
- Recalculate pace, splits, drift, and interval summaries from timestamped data.
- Keep a clear distinction between fields read directly from HealthKit and fields calculated by the app.
