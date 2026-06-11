# RunSignal HealthKit Permission Review

RunSignal is read-only for this milestone. It requests no write permissions.

Permission explanation shown before HealthKit access:

> RunSignal reads HealthKit data to analyze running workouts, routes, heart rate, pace, power, cadence, mechanics, calories, training load, recovery context, and progress. Health data is used for in-app analysis and is not used for advertising or sold.

Requested read types are documented in `HealthKitPermissionCatalog.swift` with one reason per type. The app intentionally skips unrelated nutrition, glucose, insulin, menstruation, swimming, cycling, rowing, wheelchair, underwater, and unrelated mobility metrics.

Apple manual heart-rate zones are not assumed to be readable. Zone source must be labeled as Apple Health, RunSignal manual, RunSignal estimated, or unavailable only after current SDK support is verified.
