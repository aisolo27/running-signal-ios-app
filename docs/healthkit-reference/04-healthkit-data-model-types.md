# 04. HealthKit Data Model Types

## Apple source
- https://developer.apple.com/documentation/healthkit/hkobject
- https://developer.apple.com/documentation/healthkit/hksample
- https://developer.apple.com/documentation/healthkit/hkquantitysample
- https://developer.apple.com/documentation/healthkit/hkcategorysample
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hksource
- https://developer.apple.com/documentation/healthkit/hksourcerevision
- https://developer.apple.com/documentation/healthkit/hkdevice

## Important model concepts

### HKObject
Base object for HealthKit records. Usually includes UUID, source revision, metadata, and device where available.

### HKSample
A time-bounded health data record. Quantity samples, category samples, workouts, and other records inherit sample-like behavior.

### HKQuantitySample
Numeric data with units. Examples:
- Heart rate
- Distance
- Energy
- Running power
- Running speed
- Step count
- Running dynamics where available

### HKCategorySample
Discrete or categorical data. Not the main source for running workouts, but may appear in broader health contexts.

### HKWorkout
A workout session with activity type, duration, start/end, totals, metadata, and events.

### Source and source revision
Source information matters because the same time window can include data from iPhone, Apple Watch, third-party devices, or apps.

## App storage guidance
Store:
- HealthKit UUID
- Sample type identifier
- Source name
- Source bundle identifier when available
- Source revision
- Device metadata when available
- Start and end date
- Unit-normalized value
- Original metadata keys

## Codex rules
- Always preserve source information.
- Normalize units at import time, but keep the original sample identity.
- Do not blend data from different sources without explicit reconciliation logic.
- Do not overwrite raw HealthKit values with derived values.
