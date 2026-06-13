# May 1 Open-Tail Pause Evidence

Status: docs/debug validation evidence. This does not change Swift, production interval behavior, normal workout UI, `HKWorkoutActivity` promotion, FIT runtime use, HealthFit dependency status, or Phase 3 implementation.

## Source Files

User-supplied exports in `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/txt files/`:

- `text-5019FD05E619-1.txt`: selected-workout Raw HealthKit Debug export for `2026-05-01T12:07:44Z`.
- `text-AD332E369B38-1.txt`: selected-workout parity packet JSON for `2026-05-01T12:07:44Z`.
- `text-B010E05D75B3-1.txt`: May 2026 Monthly Diagnostics JSON export.
- `text-262F7F5BA6DD-1.txt`: May 2026 Monthly Diagnostics Summary export.

Updated Apple Fitness screenshots:

- `/Users/adrielsolorzano/Downloads/updated may 1 v1.PNG`
- `/Users/adrielsolorzano/Downloads/updated may 1 v2.PNG`

User-supplied Google Drive FIT export:

- Drive file: `2026-05-01-080744-Outdoor Running-Adriel's Apple Watch.fit`
- Local evidence copy: `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing/fit files/2026-05-01-080744-Outdoor Running-Adriel Apple Watch.fit`
- Metadata match: filename start `2026-05-01-080744` matches workout start `2026-05-01T12:07:44Z`.
- File verification: local copy is a FIT binary, not an HTML Drive download.

## Apple Fitness Visible Reference

| Metric | Apple Fitness |
| --- | ---: |
| Workout time | `0:49:08` |
| Elapsed time | `0:53:01` |
| Elapsed minus workout | `233 s` |
| Distance | `9.22 km` |

| Row | Label | Distance | Time |
| ---: | --- | ---: | ---: |
| 1 | Warmup | `2.00 km` | `12:52` |
| 2 | Recovery | `194 m` | `2:00` |
| 3 | Work | `5.00 km` | `21:44` |
| 4 | Cooldown | `1.99 km` | `12:22` |
| 5 | Open | `16 m` | `0:10` |

## Fresh HealthKit Debug Evidence

The May 2026 monthly refresh reports May 1 as:

| Field | Value |
| --- | --- |
| Start | `2026-05-01T12:07:44Z` |
| Workout ID | `8BF85190-5583-47BF-A975-576D77980137` |
| Refresh status | `success` |
| Evidence source | `freshQuery` |
| WorkoutKit plan | available |
| Planned steps | 4 |
| `HKWorkoutActivity` rows | 4 |
| Reconstructed rows | 5 |
| Raw workout events | 21 |

The selected-workout parity packet reports:

| Metric | Value |
| --- | ---: |
| Duration | `2948.6 s` |
| Elapsed | `3181.4 s` |
| Elapsed minus duration | `232.8 s` |
| Distance | `9222.1 m` |

## Pause Evidence

Raw HealthKit events include two paired pause/resume intervals and a terminal pause marker:

| Pair | Pause offset | Resume offset | Duration |
| ---: | ---: | ---: | ---: |
| 1 | `27:56` | `30:17` | `141.0 s` |
| 2 | `39:06` | `40:37` | `91.8 s` |
| Total paired pause |  |  | `232.8 s` |

This matches the Apple Fitness overview gap:

| Source | Elapsed minus workout/duration |
| --- | ---: |
| Apple Fitness overview | `233 s` |
| RunSignal parity packet | `232.8 s` |
| Paired HealthKit pause intervals | `232.8 s` |

## Activity Boundary Candidate Rows

The debug-only activity-boundary candidate has four direct `HKWorkoutActivity` rows plus an inferred Open/Extra tail:

| Row | Label | Distance | Elapsed duration | Pause overlap | Active duration | Apple time | Active delta |
| ---: | --- | ---: | ---: | ---: | ---: | ---: | ---: |
| 1 | Warmup | `2009.1 m` | `772.5 s` | `0.0 s` | `772.5 s` | `772 s` | `+0.5 s` |
| 2 | Recovery | `194.8 m` | `119.5 s` | `0.0 s` | `119.5 s` | `120 s` | `-0.5 s` |
| 3 | Work | `5005.7 m` | `1445.4 s` | `141.0 s` | `1304.4 s` | `1304 s` | `+0.4 s` |
| 4 | Cooldown | `1995.9 m` | `834.0 s` | `91.8 s` | `742.2 s` | `742 s` | `+0.2 s` |
| 5 | Open / Extra | `16.6 m` | `9.9 s` | `0.0 s` | `9.9 s` | `10 s` | `-0.1 s` |

## FIT Cross-Check

The May 1 HealthFit FIT export contains four workout steps and four lap rows:

| FIT row | Type | Target/intensity | Distance | Elapsed | Timer |
| ---: | --- | --- | ---: | ---: | ---: |
| Step 1 | distance | warmup | `2000.0 m` |  |  |
| Step 2 | time | recover |  | `120.0 s` target |  |
| Step 3 | distance | active | `5000.0 m` |  |  |
| Step 4 | distance | cooldown | `2000.0 m` |  |  |
| Lap 1 | lap |  | `2000.0 m` | `772.5 s` | `772.5 s` |
| Lap 2 | lap |  | `194.8 m` | `119.5 s` | `119.5 s` |
| Lap 3 | lap |  | `5000.0 m` | `1445.4 s` | `1304.4 s` |
| Lap 4 | lap |  | `1995.9 m` | `834.0 s` | `742.2 s` |

FIT timer-vs-elapsed deltas match the paired HealthKit pause intervals:

| FIT lap | Elapsed minus timer | Matching HealthKit pause |
| ---: | ---: | --- |
| 3 | `141.0 s` | pause pair 1 |
| 4 | `91.8 s` | pause pair 2 |
| Total | `232.8 s` | both paired pauses |

FIT supports the fixed planned workout structure and pause-subtracted timer rows. It is less precise for the exact Apple Fitness `Open 16 m` tail if calculated only as session distance minus fixed FIT lap distances, because some FIT laps use fixed target-like distances (`2000.0 m`, `5000.0 m`) while HealthKit activity rows carry measured distances (`2009.1 m`, `5005.7 m`). For this workout, the exact `Open 16 m / 0:10` tail remains best supported by Apple Fitness screenshots plus HealthKit activity-boundary evidence.

## Findings

- May 1 now has paired HealthKit pause evidence that explains the `233 s` Apple Fitness elapsed-vs-workout-time gap.
- Apple Fitness row durations match the activity-boundary candidate when row duration uses active time, meaning elapsed row duration minus pause overlap.
- Apple Fitness labels the post-fixed-cooldown residual as `Open`; the debug candidate labels the same residual as `Open / Extra`.
- The May 1 `Open / Extra` tail is `16.6 m / 9.9 s`, which matches Apple Fitness `16 m / 0:10` within display rounding.
- The May 1 FIT export independently confirms four planned workout steps, four lap rows, and pause-subtracted timer rows for Work and Cooldown.
- The current evidence supports a debug-only rule direction: keep elapsed and active/timer duration separate, subtract paired pause overlap for row duration comparisons, and infer Open/Extra only after fixed planned steps are exhausted.

## Remaining Limits

- FIT confirms timer-vs-elapsed pause subtraction but should not be used alone to derive the exact `Open 16 m` tail distance for this workout.
- This evidence does not approve production interval reconstruction.
- This evidence does not approve normal workout UI changes.
- This evidence does not implement or approve Phase 3.
