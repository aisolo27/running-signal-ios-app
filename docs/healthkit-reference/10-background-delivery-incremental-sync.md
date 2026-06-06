# 10. Background Delivery and Incremental Sync

## Apple source
- https://developer.apple.com/documentation/healthkit/hkobserverquery
- https://developer.apple.com/documentation/healthkit/hkanchoredobjectquery
- https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery

## Sync model
Use a durable sync process:
1. Request authorization.
2. Run an initial historical import.
3. Save anchors per object type.
4. Register observer queries.
5. When HealthKit notifies changes, run anchored queries.
6. Update local database records by HealthKit UUID.
7. Preserve deletion handling where supported.

## What to store
For each synced object type:
- Object type identifier
- Last anchor
- Last successful sync date
- Last error
- Number of inserted, updated, and deleted objects
- Source app/device if useful

## Error handling
HealthKit sync should be resilient:
- Retry on transient errors.
- Do not wipe local data on temporary authorization or query failures.
- Avoid full re-sync unless the anchor is invalid or the user requests it.
- Log enough information to debug data gaps.

## Codex rules
- Do not run expensive full-history queries on every app launch.
- Use anchored queries for incremental sync.
- Keep sync logic outside SwiftUI views.
- Make sync idempotent.
- Avoid duplicate workouts by matching HealthKit UUIDs.
