# API Symbol Index

This is a quick index for Codex. Verify each symbol in Apple documentation before implementation.

## Store and authorization
- `HKHealthStore`
- `HKObjectType`
- `HKSampleType`
- `HKQuantityType`
- `requestAuthorization(toShare:read:)`

## Samples and objects
- `HKObject`
- `HKSample`
- `HKQuantitySample`
- `HKCategorySample`
- `HKWorkout`
- `HKWorkoutEvent`
- `HKWorkoutRoute`

## Queries
- `HKSampleQuery`
- `HKAnchoredObjectQuery`
- `HKStatisticsQuery`
- `HKStatisticsCollectionQuery`
- `HKObserverQuery`
- `HKWorkoutRouteQuery`

## Running-related types to verify
- Distance walking/running
- Active energy burned
- Heart rate
- Step count
- Running speed
- Running power
- Running stride length
- Running vertical oscillation
- Running ground contact time

## Metadata/source
- `HKSource`
- `HKSourceRevision`
- `HKDevice`
- `HKMetadataKeySyncIdentifier`
- `HKMetadataKeySyncVersion`

## Units
- `HKUnit.meter()`
- `HKUnit.second()`
- `HKUnit.count()`
- `HKUnit.count().unitDivided(by: .minute())`
- `HKUnit.kilocalorie()`
- `HKUnit.watt()`
