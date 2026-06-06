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
- XcodeBuildMCP build/run on physical iPhone.
- Unit tests for normalization-adjacent helpers.

## Simulator Checks
- Tap Data tab.
- Confirm permission state and sample fallback are visible.

## Known Risks
- Deeper per-workout evidence series still needs follow-up for workouts reported as pending series.

## Completion Notes
- Completed for v1 Simulator path. HealthKit entitlement, usage description, read-only authorization service, workout query service, route availability check, and Data tab load control are implemented.
- Added anchored HealthKit workout sync scaffolding with local anchor persistence, inserted/updated/deleted-detected counts, sync diagnostics, and a Data tab sync panel.
- Physical iPhone verification passed on AIS17PM running iOS 26.5.1. XcodeBuildMCP built, installed, and launched the app on device. User-verified Data tab loaded 620 total local records with 617 duplicates excluded, 3 duplicate candidate matches, moderate confidence, and current data gate.
- Physical iPhone anchored sync passed the idempotency check. First sync reported last sync June 5, 2026, fetched 620 changed workouts, inserted 0 new local records, updated 620 existing records, deleted 0 detected-only records, and showed 323 pending evidence series. Immediate second sync reported 0 changed workouts, 0 inserted, 0 updated, 0 deleted, with the same 323 pending evidence series.
