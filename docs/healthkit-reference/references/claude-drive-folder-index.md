# Claude Google Drive HealthKit Pack Index

Source folder:
https://drive.google.com/drive/folders/1pEbVDEcLPypxXnNZX34rYf1BmFg92e7Z

This Drive pack is supplemental. Use it for alternate explanations, broad checklists, and Swift snippet ideas. Do not treat it as stronger than Apple documentation, this local reference pack, the repo code, or `docs/bug-log.md`.

## Files In Drive Pack

| Drive File | Best Use |
| --- | --- |
| `00_INDEX.md` | Broad table of contents and quick HealthKit setup reminder. |
| `01_framework_overview.md` | General HealthKit architecture and conceptual overview. |
| `02_setup_and_configuration.md` | Entitlements, Info.plist strings, authorization gotchas, platform availability. |
| `03_data_types.md` | Type hierarchy, common units, quantity/category/correlation concepts. |
| `04_reading_data_queries.md` | Query examples and comparison across sample, statistics, observer, and anchored queries. |
| `05_writing_data.md` | Writing samples. Usually not applicable to this app because HealthKit v1 is read-only. |
| `06_workouts_and_activity.md` | Workout and activity concepts. Use as a supplement to local `05-workouts-hkworkout.md`. |
| `07_health_records.md` | Clinical records. Usually not relevant to this running app. |
| `08_background_delivery.md` | Background delivery and observer query supplement. |
| `09_privacy_and_permissions.md` | Privacy and permission best-practice supplement. |
| `10_data_type_reference.md` | Broad HealthKit identifier cheat sheet. Verify identifiers against Apple docs before coding. |
| `11_codex_patterns_snippets.md` | Swift snippets and patterns. Adapt to this repo's service layer; do not paste blindly. |

## Useful Notes To Carry Forward

- `requestAuthorization` success means the authorization flow completed without a system error; it does not prove read access was granted.
- Denied read access often appears as empty query results, not a direct authorization error.
- Query callbacks may arrive off the main actor; UI updates must return to the main actor.
- Observer queries are notifications; pair them with anchored queries for actual changed data.
- Snippets in the Drive pack are generic. For this repo, prefer existing async/service abstractions and add tests around mapping, missing data, units, duplicates, and confidence.

## When Not To Use It

- Do not use `05_writing_data.md` to justify HealthKit writes in this app.
- Do not use broad data-type tables as proof that a metric exists in a user's real workout history.
- Do not use generic snippets if they conflict with `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/` patterns.
