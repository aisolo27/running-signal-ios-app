# 03. Reading Data and Queries

## Apple source
- https://developer.apple.com/documentation/healthkit/hksamplequery
- https://developer.apple.com/documentation/healthkit/hkanchoredobjectquery
- https://developer.apple.com/documentation/healthkit/hkstatisticsquery
- https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery
- https://developer.apple.com/documentation/healthkit/hkobserverquery

## Query types
Use the query type based on the job:

### HKSampleQuery
Use for fetching matching samples in a date range. Good for:
- Workouts
- Heart rate samples
- Running power samples
- Speed samples
- Quantity samples tied to a workout timeframe

### HKAnchoredObjectQuery
Use for incremental sync. Good for:
- Importing only new or changed samples after the previous sync.
- Persisting an anchor between app launches.
- Avoiding full re-imports every time.

### HKStatisticsQuery
Use for aggregate totals over a date range. Good for:
- Total distance in a period.
- Sum of active energy.
- Average heart rate over a range when appropriate.

### HKStatisticsCollectionQuery
Use for bucketed aggregates. Good for:
- Daily totals.
- Per-minute or per-kilometer calculations when time buckets make sense.
- Charts where the app needs consistent intervals.

### HKObserverQuery
Use to be notified when HealthKit data changes. Pair this with anchored queries to fetch the actual changed data.

## Workout-specific sample filtering
When possible, associate samples to a specific workout. Depending on the data type and availability, the app may need to query by:
- Workout start/end date
- Source
- Metadata
- Device/source revision
- Associated workout relationship, if exposed for the sample type

## Codex rules
- Use `HKAnchoredObjectQuery` for sync instead of repeatedly importing all historical data.
- Use observer queries for change notifications, not as the actual data source.
- Never assume a sample exists just because a workout exists.
- Use date predicates carefully. Include a small tolerance around start/end times when necessary, but do not merge unrelated workouts.
