# Milestone 2: HealthKit Foundation

## Goal
Add read-only HealthKit authorization and running workout loading with clear unavailable, denied, partial, and error states.

## Affected Areas
- HealthKit entitlements and Info.plist usage text
- HealthKit service
- Data tab authorization controls
- Mock/sample fallback

## Exact Tasks
- Add HealthKit entitlement.
- Add HealthKit share usage description.
- Request read access for workouts, routes, and running metrics.
- Query running workouts.
- Keep sample data active when HealthKit is unavailable or empty.

## Acceptance Criteria
- HealthKit button exists on Data tab.
- HealthKit is read-only.
- No backend or external service is introduced.
- Missing or denied HealthKit keeps UI usable.

## Test Commands
- XcodeBuildMCP build/run on Simulator.
- Unit tests for normalization-adjacent helpers.

## Simulator Checks
- Tap Data tab.
- Confirm permission state and sample fallback are visible.

## Known Risks
- Real HealthKit permissions and real workout records require physical iPhone verification.

## Completion Notes
- Completed for v1 Simulator path. HealthKit entitlement, usage description, read-only authorization service, workout query service, route availability check, and Data tab load control are implemented. Real-device HealthKit verification remains required.
- Added anchored HealthKit workout sync scaffolding with local anchor persistence, inserted/updated/deleted-detected counts, sync diagnostics, and a Data tab sync panel. Simulator build/UI pass, but anchored-query behavior still needs physical-iPhone verification.
