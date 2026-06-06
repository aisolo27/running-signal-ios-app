# 01. Privacy, Permissions, and Entitlements

## Apple source
- https://developer.apple.com/documentation/healthkit/setting-up-healthkit
- https://developer.apple.com/documentation/healthkit/hkhealthstore
- https://developer.apple.com/documentation/bundleresources/entitlements/com_apple_developer_healthkit

## Core principle
Health data is sensitive. The app must request only the HealthKit read and write permissions it needs, explain why each data type is needed, and handle denial gracefully.

## App requirements
For an iOS app using HealthKit:
- Enable the HealthKit capability in the app target.
- Include the HealthKit entitlement.
- Add user-facing privacy strings in `Info.plist`.
- Request authorization before reading or writing HealthKit data.
- Do not block the entire app if the user denies a non-critical metric.

## Permissions for a running app
Likely read permissions:
- Workouts
- Workout routes
- Distance walking/running
- Active energy burned
- Heart rate
- Running power if available
- Running speed if available
- Step count or cadence-related data if available
- Running stride length if available
- Running vertical oscillation if available
- Running ground contact time if available

Write permissions are optional and should only be requested if the app creates workouts, samples, routes, or analysis records in HealthKit.

## Permission UX
The app should explain in plain language:
- Why workout data is needed.
- Why heart rate and running metrics improve analysis.
- Why location route data helps calculate route, elevation, and pace.
- That the user controls HealthKit access in the Health app and Settings.

## Codex rules
- Do not request broad write access unless the feature actually writes HealthKit records.
- Do not assume authorization means every requested type was granted.
- Check authorization per type and degrade gracefully.
- Do not show fake zeros when data is missing because of permission denial.
- Use explicit missing-data states such as `notAuthorized`, `notRecorded`, `notAvailableOnDevice`, or `notImportedYet`.
