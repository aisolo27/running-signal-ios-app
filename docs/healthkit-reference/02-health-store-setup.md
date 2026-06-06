# 02. Health Store Setup

## Apple source
- https://developer.apple.com/documentation/healthkit/hkhealthstore
- https://developer.apple.com/documentation/healthkit/hkobjecttype
- https://developer.apple.com/documentation/healthkit/hkquantitytype
- https://developer.apple.com/documentation/healthkit/hksampletype

## Role of HKHealthStore
`HKHealthStore` is the central object used to request authorization and run HealthKit queries. The app should use a single HealthKit service layer rather than scattering HealthKit calls across views.

## Recommended app structure
Create a dedicated service such as:

```swift
final class HealthKitClient {
    private let healthStore = HKHealthStore()

    func requestAuthorization() async throws { }
    func fetchWorkouts(...) async throws -> [HKWorkout] { }
    func fetchSamples(...) async throws -> [HKQuantitySample] { }
    func fetchRoute(...) async throws -> [CLLocation] { }
}
```

Then expose app-specific models:

```swift
struct ImportedRunWorkout {
    let healthKitUUID: UUID
    let startDate: Date
    let endDate: Date
    let duration: TimeInterval
    let distanceMeters: Double?
    let activeEnergyKilocalories: Double?
    let sourceName: String
    let rawMetadata: [String: Any]
    let derived: DerivedRunMetrics
}
```

## Availability checks
Before using HealthKit:
- Check whether HealthKit is available on the device.
- Check whether the app has the needed entitlement.
- Request authorization for the exact object types.
- Handle empty results as normal, not as a crash path.

## Codex rules
- Keep HealthKit code behind a client/service layer.
- Do not access HealthKit directly from SwiftUI views.
- Do not mix HealthKit raw models with UI display models.
- Preserve HealthKit UUIDs so the app can dedupe and update existing imported workouts.
