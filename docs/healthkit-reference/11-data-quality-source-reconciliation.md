# 11. Data Quality, Source, and Reconciliation

## Apple source
- https://developer.apple.com/documentation/healthkit/hksource
- https://developer.apple.com/documentation/healthkit/hksourcerevision
- https://developer.apple.com/documentation/healthkit/hkdevice
- https://developer.apple.com/documentation/healthkit/hkmetadata

## Why source matters
A user can have overlapping data from:
- Apple Watch
- iPhone
- Third-party apps
- Imported FIT/GPX files
- Manual entries
- Duplicate workout services

A robust running app must avoid blindly merging everything.

## Reconciliation strategy
For workouts:
- Prefer `HKWorkout` as the workout session identity.
- Use workout UUID for dedupe.
- Keep source information visible for debugging.
- Do not merge two workouts unless there is explicit evidence they are duplicates.

For samples:
- Filter by workout timeframe.
- Consider source if multiple devices overlap.
- Prefer Apple Watch data for Apple Watch workouts unless the user chose another source.
- Avoid combining third-party samples into an Apple Watch workout without a clear rule.

## Missing and suspicious data
Flag but do not crash on:
- Missing route
- Missing heart rate
- Missing distance
- Missing power
- Gaps in samples
- Zero or impossible values
- Unusually high GPS distance
- Duplicate workouts

## Codex rules
- Add quality flags instead of silently correcting data.
- Store original source and metadata.
- Keep a reconciliation audit trail for derived values.
- Do not hide missing data behind zero values.
