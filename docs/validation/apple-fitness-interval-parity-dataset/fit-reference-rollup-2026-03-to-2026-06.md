# FIT Reference Rollup: 2026-03 Through 2026-06

## Executive Summary

Inspected the provided Google Drive FIT folder and parsed the locally synced HealthFit copies from `/Users/adrielsolorzano/Library/Mobile Documents/iCloud~com~altifondo~HealthFit/Documents`. The run-relevant March through June set contains 86 outdoor-running FIT files. Those 86 unique FIT files match the 87 RunSignal monthly-rollup workout records by start time; one May 14 duplicate/same-start RunSignal record shares the same FIT file and remains excluded from production scoring.

For the 10 Priority 1 simple Work + Open candidates with large candidate-vs-current shifts, FIT lap boundaries support the debug-only `HKWorkoutActivity` candidate in all 10 cases. FIT does not support current reconstruction for any of those large-shift rows. In each case the first FIT lap aligns with the candidate Work row and the inferred FIT tail aligns with the candidate Open / Extra row.

This reduces uncertainty materially, but it still does not make production promotion safe by itself. FIT remains offline/reference evidence, not runtime truth, and this report does not prove Apple Fitness visual parity for the newly surfaced March/April large-shift cases. Structured interval and warmup/work/cooldown workouts also remain special cases rather than simple Work/Open approval evidence.

Recommendation: **debug-only prototype only; production still blocked** until Apple Fitness/manual references verify the priority large-shift cases and a representative guard set, and until structured/special handling remains explicitly separated from simple fixed-distance Work/Open scoring.

## FIT Files Found

- Drive folder inspected: `https://drive.google.com/drive/u/0/folders/1QUo6CaiRIBtgV0sk37Uc4wOhFmINyQyf`
- Local synced folder parsed: `/Users/adrielsolorzano/Library/Mobile Documents/iCloud~com~altifondo~HealthFit/Documents`
- March-June outdoor-running FIT files parsed: 86
- Unique FIT files matched to RunSignal workouts: 86
- RunSignal workout records associated with FIT evidence: 87
- Unmatched FIT files: 0
- Unmatched RunSignal workouts: 0

| Month | FIT filename | FIT start | Distance | Duration | Laps | Steps |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-03 | 2026-03-01-133801-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-01 18:38:01 | 5037.6 m | 1427.6 s | 2 | 0 |
| 2026-03 | 2026-03-02-102606-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-02 15:26:06 | 6022.4 m | 2251.5 s | 1 | 1 |
| 2026-03 | 2026-03-03-083937-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-03 13:39:37 | 7117.2 m | 2512.4 s | 18 | 5 |
| 2026-03 | 2026-03-04-104546-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-04 15:45:46 | 5044.5 m | 1959.7 s | 1 | 1 |
| 2026-03 | 2026-03-05-093743-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-05 14:37:43 | 6129.3 m | 2070.2 s | 3 | 3 |
| 2026-03 | 2026-03-06-081115-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-06 13:11:15 | 5038.1 m | 1888.0 s | 1 | 1 |
| 2026-03 | 2026-03-08-163544-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-08 20:35:44 | 10078.6 m | 4116.9 s | 1 | 1 |
| 2026-03 | 2026-03-09-101632-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-09 14:16:32 | 8098.4 m | 3062.1 s | 1 | 1 |
| 2026-03 | 2026-03-10-094908-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-10 13:49:08 | 9067.7 m | 3372.3 s | 13 | 6 |
| 2026-03 | 2026-03-11-094015-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-11 13:40:15 | 5050.8 m | 1932.0 s | 1 | 1 |
| 2026-03 | 2026-03-12-094102-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-12 13:41:02 | 9069.5 m | 3168.6 s | 8 | 5 |
| 2026-03 | 2026-03-13-112025-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-13 15:20:25 | 5027.2 m | 1879.9 s | 1 | 1 |
| 2026-03 | 2026-03-15-135735-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-15 17:57:35 | 13060.3 m | 4758.6 s | 1 | 1 |
| 2026-03 | 2026-03-16-084324-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-16 12:43:24 | 9063.3 m | 3225.9 s | 1 | 1 |
| 2026-03 | 2026-03-17-082937-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-17 12:29:37 | 9138.8 m | 3292.8 s | 18 | 5 |
| 2026-03 | 2026-03-18-105046-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-18 14:50:46 | 5123.4 m | 1876.2 s | 1 | 1 |
| 2026-03 | 2026-03-19-125100-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-19 16:51:00 | 9130.9 m | 3029.7 s | 3 | 3 |
| 2026-03 | 2026-03-21-185901-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-21 22:59:01 | 6038.4 m | 2226.8 s | 1 | 1 |
| 2026-03 | 2026-03-22-141944-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-22 18:19:44 | 21154.5 m | 7758.6 s | 1 | 1 |
| 2026-03 | 2026-03-23-175936-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-23 21:59:36 | 7063.5 m | 2538.0 s | 1 | 1 |
| 2026-03 | 2026-03-25-104756-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-25 14:47:56 | 8158.2 m | 3008.3 s | 14 | 5 |
| 2026-03 | 2026-03-26-101548-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-26 14:15:48 | 5043.6 m | 1873.8 s | 1 | 1 |
| 2026-03 | 2026-03-27-085926-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-27 12:59:26 | 7052.8 m | 2447.7 s | 8 | 5 |
| 2026-03 | 2026-03-29-144339-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-29 18:43:39 | 170.2 m | 66.8 s | 1 | 1 |
| 2026-03 | 2026-03-29-144545-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-29 18:45:45 | 12169.0 m | 4702.1 s | 1 | 1 |
| 2026-03 | 2026-03-30-191925-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-30 23:19:25 | 6004.2 m | 2155.0 s | 1 | 1 |
| 2026-03 | 2026-03-31-112628-Outdoor Running-Adriel’s Apple Watch.fit | 2026-03-31 15:26:28 | 6056.0 m | 2106.0 s | 10 | 5 |
| 2026-04 | 2026-04-05-171847-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-05 21:18:47 | 5019.0 m | 1335.4 s | 1 | 1 |
| 2026-04 | 2026-04-07-102102-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-07 14:21:02 | 6062.0 m | 2209.8 s | 1 | 1 |
| 2026-04 | 2026-04-08-110823-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-08 15:08:23 | 5049.6 m | 1825.8 s | 1 | 1 |
| 2026-04 | 2026-04-10-074735-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-10 11:47:35 | 5154.7 m | 1906.1 s | 1 | 1 |
| 2026-04 | 2026-04-11-072132-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-11 11:21:32 | 2208.1 m | 777.9 s | 3 | 0 |
| 2026-04 | 2026-04-11-082539-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-11 12:25:39 | 2371.4 m | 827.2 s | 3 | 0 |
| 2026-04 | 2026-04-12-120133-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-12 16:01:33 | 5179.1 m | 1833.3 s | 2 | 2 |
| 2026-04 | 2026-04-14-185752-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-14 22:57:52 | 69.8 m | 64.4 s | 1 | 0 |
| 2026-04 | 2026-04-14-191630-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-14 23:16:30 | 8119.6 m | 2595.2 s | 9 | 0 |
| 2026-04 | 2026-04-16-072941-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-16 11:29:41 | 5055.2 m | 1815.6 s | 1 | 1 |
| 2026-04 | 2026-04-17-073334-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-17 11:33:34 | 5038.8 m | 1866.9 s | 1 | 1 |
| 2026-04 | 2026-04-18-184059-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-18 22:40:59 | 10092.5 m | 2929.1 s | 1 | 1 |
| 2026-04 | 2026-04-20-091753-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-20 13:17:53 | 8326.2 m | 3075.4 s | 1 | 1 |
| 2026-04 | 2026-04-21-054300-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-21 09:43:00 | 2484.5 m | 987.3 s | 3 | 0 |
| 2026-04 | 2026-04-21-062235-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-21 10:22:35 | 8696.9 m | 3334.6 s | 9 | 0 |
| 2026-04 | 2026-04-22-073958-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-22 11:39:58 | 9037.7 m | 3275.6 s | 12 | 5 |
| 2026-04 | 2026-04-23-080324-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-23 12:03:24 | 6617.9 m | 2546.6 s | 1 | 1 |
| 2026-04 | 2026-04-24-080230-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-24 12:02:30 | 8044.4 m | 2598.2 s | 3 | 3 |
| 2026-04 | 2026-04-26-073835-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-26 11:38:35 | 14564.8 m | 5310.4 s | 1 | 1 |
| 2026-04 | 2026-04-27-081621-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-27 12:16:21 | 8119.3 m | 3075.4 s | 1 | 1 |
| 2026-04 | 2026-04-28-074452-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-28 11:44:52 | 7304.6 m | 2791.8 s | 1 | 1 |
| 2026-04 | 2026-04-29-074902-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-29 11:49:02 | 9018.6 m | 3283.8 s | 12 | 5 |
| 2026-04 | 2026-04-30-075229-Outdoor Running-Adriel’s Apple Watch.fit | 2026-04-30 11:52:29 | 6538.3 m | 2546.9 s | 1 | 1 |
| 2026-05 | 2026-05-01-080744-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-01 12:07:44 | 9222.1 m | 3181.4 s | 4 | 4 |
| 2026-05 | 2026-05-03-080610-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-03 12:06:10 | 15371.0 m | 5643.2 s | 1 | 1 |
| 2026-05 | 2026-05-04-084042-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-04 12:40:42 | 8134.8 m | 3120.3 s | 1 | 1 |
| 2026-05 | 2026-05-05-080506-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-05 12:05:06 | 7317.5 m | 2854.7 s | 1 | 1 |
| 2026-05 | 2026-05-06-080213-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-06 12:02:13 | 10146.2 m | 3757.5 s | 14 | 11 |
| 2026-05 | 2026-05-07-074357-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-07 11:43:57 | 6485.4 m | 2489.6 s | 1 | 1 |
| 2026-05 | 2026-05-08-075507-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-08 11:55:07 | 8252.6 m | 2852.2 s | 6 | 5 |
| 2026-05 | 2026-05-10-073109-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-10 11:31:09 | 4944.7 m | 1316.2 s | 1 | 1 |
| 2026-05 | 2026-05-11-081009-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-11 12:10:09 | 8113.4 m | 3285.6 s | 1 | 1 |
| 2026-05 | 2026-05-13-075206-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-13 11:52:06 | 10032.3 m | 3937.6 s | 18 | 5 |
| 2026-05 | 2026-05-14-075859-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-14 11:58:59 | 6683.3 m | 2624.2 s | 1 | 1 |
| 2026-05 | 2026-05-15-080012-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-15 12:00:12 | 9112.0 m | 3072.3 s | 8 | 5 |
| 2026-05 | 2026-05-17-074735-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-17 11:47:35 | 13068.2 m | 5090.8 s | 1 | 1 |
| 2026-05 | 2026-05-18-080004-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-18 12:00:04 | 8176.5 m | 3217.4 s | 1 | 1 |
| 2026-05 | 2026-05-19-081402-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-19 12:14:02 | 7281.6 m | 2982.1 s | 1 | 1 |
| 2026-05 | 2026-05-20-074300-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-20 11:43:00 | 9066.2 m | 3243.8 s | 10 | 5 |
| 2026-05 | 2026-05-21-075100-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-21 11:51:00 | 6493.1 m | 2655.1 s | 1 | 1 |
| 2026-05 | 2026-05-22-075511-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-22 11:55:11 | 8521.1 m | 2895.9 s | 6 | 5 |
| 2026-05 | 2026-05-24-075420-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-24 11:54:20 | 13071.4 m | 5313.7 s | 1 | 1 |
| 2026-05 | 2026-05-25-075227-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-25 11:52:27 | 7270.1 m | 2875.6 s | 1 | 1 |
| 2026-05 | 2026-05-26-073621-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-26 11:36:21 | 6551.4 m | 2572.7 s | 1 | 1 |
| 2026-05 | 2026-05-27-074547-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-27 11:45:47 | 8514.1 m | 3222.3 s | 22 | 5 |
| 2026-05 | 2026-05-28-074847-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-28 11:48:47 | 6472.1 m | 2632.8 s | 1 | 1 |
| 2026-05 | 2026-05-29-074928-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-29 11:49:28 | 7320.4 m | 2645.1 s | 3 | 3 |
| 2026-05 | 2026-05-31-081937-Outdoor Running-Adriel’s Apple Watch.fit | 2026-05-31 12:19:37 | 10137.7 m | 4159.2 s | 1 | 1 |
| 2026-06 | 2026-06-01-075129-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-01 11:51:29 | 6463.0 m | 2571.0 s | 1 | 1 |
| 2026-06 | 2026-06-02-075150-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-02 11:51:50 | 5708.9 m | 2202.7 s | 1 | 1 |
| 2026-06 | 2026-06-03-074508-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-03 11:45:08 | 6668.1 m | 2336.7 s | 8 | 5 |
| 2026-06 | 2026-06-03-082505-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-03 12:25:05 | 1015.2 m | 389.3 s | 2 | 0 |
| 2026-06 | 2026-06-04-074706-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-04 11:47:06 | 5702.0 m | 2216.5 s | 1 | 1 |
| 2026-06 | 2026-06-05-075353-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-05 11:53:53 | 6961.8 m | 2296.1 s | 3 | 3 |
| 2026-06 | 2026-06-07-082128-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-07 12:21:28 | 8112.8 m | 3259.7 s | 1 | 1 |
| 2026-06 | 2026-06-08-082128-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-08 12:21:28 | 5065.3 m | 1964.5 s | 1 | 1 |
| 2026-06 | 2026-06-09-082342-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-09 12:23:42 | 5039.8 m | 1974.9 s | 1 | 1 |
| 2026-06 | 2026-06-10-072751-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-10 11:27:51 | 6787.5 m | 2439.8 s | 10 | 5 |
| 2026-06 | 2026-06-12-074954-Outdoor Running-Adriel’s Apple Watch.fit | 2026-06-12 11:49:54 | 5044.8 m | 1940.8 s | 1 | 1 |

## Matching Method And Caveats

- Matched FIT to RunSignal primarily by FIT session `start_time` against RunSignal `startDate`, accepting exact or near-exact UTC starts.
- Used FIT session distance/duration, lap count, workout-step count, nearby same-day runs, and monthly-rollup classification as secondary checks.
- For simple fixed-distance Work + Open rows, used the first FIT lap as the planned Work reference and inferred Open / Extra as FIT session elapsed time and distance minus the first lap.
- FIT elapsed time is used for row timing comparisons because RunSignal exported row durations are elapsed workout offsets; FIT timer time can exclude pauses.
- FIT is not runtime truth, not an app data source, and not a HealthFit dependency. It is only offline validation/reference evidence.

## Matched / Unmatched Summary

| Metric | Count |
| --- | --- |
| RunSignal workouts in monthly rollup | 87 |
| Outdoor-running FIT files parsed | 86 |
| Unique FIT files matched | 86 |
| RunSignal records matched by start time | 87 |
| Unmatched FIT files | 0 |
| Unmatched RunSignal workouts | 0 |

Shared FIT match caveat:
| RunSignal start | Workout ID | Classification | FIT filename | Caveat |
| --- | --- | --- | --- | --- |
| 2026-05-14T11:58:59Z | `491EF7CB-9B78-46B6-8550-84B22EB84276` | duplicate/same-day extra run candidate | 2026-05-14-075859-Outdoor Running-Adriel’s Apple Watch.fit | same FIT already matched to another RunSignal workout with same/near start |

## Priority 1 Large-Shift Comparison

| Start | Workout ID | Goal | FIT file | Current FIT error | Candidate FIT error | FIT support | Conclusion |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-03-06T13:11:15Z | `918E7C4E-A413-4FAC-8D6E-5601C03C5D61` | 5 km | 2026-03-06-081115-Outdoor Running-Adriel’s Apple Watch.fit | 25.5 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-03-08T20:35:44Z | `7ABBE25E-6837-44D1-901C-AE05240F9E70` | 10 km | 2026-03-08-163544-Outdoor Running-Adriel’s Apple Watch.fit | 24.8 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-03-15T17:57:35Z | `B36F1A98-EF3E-4BCB-A6BA-43E239959297` | 13 km | 2026-03-15-135735-Outdoor Running-Adriel’s Apple Watch.fit | 25.2 | 0.1 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-03-18T14:50:46Z | `5E93C8CA-9906-4628-9E8B-3209B2832772` | 5 km | 2026-03-18-105046-Outdoor Running-Adriel’s Apple Watch.fit | 9867.9 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-03-23T21:59:36Z | `92CE211F-DF75-47AA-876F-6A44E4577663` | 7 km | 2026-03-23-175936-Outdoor Running-Adriel’s Apple Watch.fit | 24.8 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-03-29T18:45:45Z | `5EB80EEB-6060-4594-B73F-591A540628CF` | 12 km | 2026-03-29-144545-Outdoor Running-Adriel’s Apple Watch.fit | 22831.0 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-04-16T11:29:41Z | `4F478C27-6F64-4189-9F6D-49A601EF21F0` | 5 km | 2026-04-16-072941-Outdoor Running-Adriel’s Apple Watch.fit | 32.0 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-04-23T12:03:24Z | `8047BF00-6861-4DEB-B0FB-9D7E5C891441` | 6.50 km | 2026-04-23-080324-Outdoor Running-Adriel’s Apple Watch.fit | 21.5 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-04-27T12:16:21Z | `06D024DF-A406-4245-93BF-F40E1ECE6631` | 8.10 km | 2026-04-27-081621-Outdoor Running-Adriel’s Apple Watch.fit | 24.2 | 0.0 | HKWorkoutActivity candidate | candidate likely fixes drift |
| 2026-06-01T11:51:29Z | `559663F5-6229-4079-A483-39A04BBA9385` | 6.45 km | 2026-06-01-075129-Outdoor Running-Adriel’s Apple Watch.fit | 25.0 | 0.1 | HKWorkoutActivity candidate | candidate likely fixes drift |

Priority 1 answer: FIT reduces uncertainty for all 10 large-shift simple candidates. The FIT first-lap boundary supports the HKWorkoutActivity candidate in all 10. It does not identify any large-shift case where current reconstruction is closer.

## Simple Work + Open FIT Comparison Summary

| Group | Count |
| --- | --- |
| HKWorkoutActivity candidate | 50 |

All 50 simple Work + Open candidates have matched FIT evidence. FIT supports the HKWorkoutActivity candidate for all 50 simple candidates under the elapsed-time/lap-boundary comparison. The 40 no-large-shift candidates are spot-check support: they do not show a candidate guard break, but Apple Fitness/manual references are still needed before production promotion.

## Structured / Special FIT Comparison Summary

| Start | Workout ID | Classification | Activity/planned | FIT laps | FIT steps | Read |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-03-03T13:39:37Z | `A631421F-D5AA-4E86-8DB3-6167ED4B0FC7` | structured interval workout | 18/18 | 18 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-05T14:37:43Z | `F43BA3E4-19FF-4071-B3AD-8631967A7BD3` | warmup/work/cooldown special | 3/3 | 3 | 3 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-10T13:49:08Z | `BFD992B2-C866-4E2E-A5A9-FCFC0BF9F0BE` | structured interval workout | 13/13 | 13 | 6 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-12T13:41:02Z | `1A7502AE-CF69-4680-8D8C-CE636D70FAEA` | structured interval workout | 8/8 | 8 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-17T12:29:37Z | `5BFAB7FE-171E-43C0-9433-C8D39D2B6B7C` | structured interval workout | 18/18 | 18 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-19T16:51:00Z | `A1C01AA7-2955-4759-93E3-289691D204A6` | warmup/work/cooldown special | 3/3 | 3 | 3 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-25T14:47:56Z | `CFD67D1B-41E8-44F6-ABB3-80CE5793099F` | structured interval workout | 14/14 | 14 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-27T12:59:26Z | `1594F1C9-A897-4C5C-8B61-3013BFBE570B` | structured interval workout | 8/8 | 8 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-03-31T15:26:28Z | `EEF8B26E-093E-44D0-AFD7-FFEC318390F2` | structured interval workout | 10/10 | 10 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-04-12T16:01:33Z | `AE8AF4B2-FB7E-4D9C-92FD-D3BA9AE6E88F` | structured interval workout | 2/2 | 2 | 2 | reference only; keep separate from simple Work/Open scoring |
| 2026-04-22T11:39:58Z | `0335DE40-44C5-48AC-9A05-F32314713DE1` | structured interval workout | 12/12 | 12 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-04-24T12:02:30Z | `BE962B2D-5081-4AC1-888D-F5502B6CDBEA` | warmup/work/cooldown special | 3/3 | 3 | 3 | reference only; keep separate from simple Work/Open scoring |
| 2026-04-29T11:49:02Z | `9DF73D06-448A-4384-A27C-E3B34B2CD592` | structured interval workout | 12/12 | 12 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-01T12:07:44Z | `8BF85190-5583-47BF-A975-576D77980137` | structured interval workout | 4/4 | 4 | 4 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-06T12:02:13Z | `2941455F-F0BE-444B-80FB-2054CA20D8B4` | structured interval workout | 14/14 | 14 | 11 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-08T11:55:07Z | `C3CD1346-60D3-4F3A-9F7D-8A8ADBDBC68E` | structured interval workout | 6/6 | 6 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-13T11:52:06Z | `75C27BC6-E833-4BC4-B5A1-1DEDB1F0BC37` | structured interval workout | 18/18 | 18 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-15T12:00:12Z | `4947444A-1965-413A-ABC5-886041756F09` | structured interval workout | 8/8 | 8 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-20T11:43:00Z | `7F742555-48CB-403A-8916-58661DA98555` | structured interval workout | 10/10 | 10 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-22T11:55:11Z | `A10FBDC7-042C-4FF7-AB20-A6C2A82B1651` | structured interval workout | 6/6 | 6 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-27T11:45:47Z | `B0DB0318-7B7F-4F4F-B583-7684D660FC29` | structured interval workout | 22/22 | 22 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-05-29T11:49:28Z | `5243F1B1-AF84-4A91-A647-9EE742E5A329` | warmup/work/cooldown special | 3/3 | 3 | 3 | reference only; keep separate from simple Work/Open scoring |
| 2026-06-03T11:45:08Z | `F6D47A51-9510-4C7A-9186-6BAFE3C128C9` | structured interval workout | 8/8 | 8 | 5 | reference only; keep separate from simple Work/Open scoring |
| 2026-06-05T11:53:53Z | `9C09006E-9850-435C-95F5-A0AA0BE42A33` | warmup/work/cooldown special | 3/3 | 3 | 3 | reference only; keep separate from simple Work/Open scoring |
| 2026-06-10T11:27:51Z | `EDD82D4A-5683-4C60-A561-CED12D24DF0A` | structured interval workout | 10/10 | 10 | 5 | reference only; keep separate from simple Work/Open scoring |

Structured and warmup/work/cooldown workouts remain special cases. FIT lap/step structure is useful for offline review, but these should not be collapsed into the simple fixed-distance guard/drift scoring bucket.

## No-Plan / Duplicate / Excluded FIT Comparison Summary

| Start | Workout ID | Classification | FIT file | Match confidence | Read |
| --- | --- | --- | --- | --- | --- |
| 2026-03-01T18:38:01Z | `54E08E28-1DE5-4FE2-848E-92F1A56925C4` | no WorkoutKit plan | 2026-03-01-133801-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-03-29T18:43:39Z | `6BB0DE2C-2E1E-48DC-B168-AE4BC9243D35` | drift/guard candidate unknown | 2026-03-29-144339-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-11T11:21:32Z | `88AB3093-C1DB-4823-A280-78C9A0F190A6` | duplicate/same-day extra run candidate | 2026-04-11-072132-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-11T12:25:39Z | `D01EA29B-1C6C-4E1D-96A9-1365D5EE016D` | duplicate/same-day extra run candidate | 2026-04-11-082539-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-14T22:57:52Z | `B716E266-7C7E-4F99-A283-E0FDA4FB88A9` | duplicate/same-day extra run candidate | 2026-04-14-185752-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-14T23:16:30Z | `B9263EDD-B4E0-4B35-8923-B146A271DC14` | duplicate/same-day extra run candidate | 2026-04-14-191630-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-18T22:40:59Z | `F20D3C57-E1F4-47AA-B5A5-D8C981F4F680` | drift/guard candidate unknown | 2026-04-18-184059-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-21T09:43:00Z | `4E6FC89C-0873-4DD9-BDB0-A47F580D4F88` | duplicate/same-day extra run candidate | 2026-04-21-054300-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-04-21T10:22:35Z | `0BF7209B-8ABD-4FB8-BBE2-E35CB3CA9793` | duplicate/same-day extra run candidate | 2026-04-21-062235-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-05-10T11:31:09Z | `C427D2ED-D3FD-4CBC-87D0-A3AB76CBCE14` | drift/guard candidate unknown | 2026-05-10-073109-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-05-14T11:58:59Z | `491EF7CB-9B78-46B6-8550-84B22EB84276` | duplicate/same-day extra run candidate | 2026-05-14-075859-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |
| 2026-06-03T12:25:05Z | `0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73` | duplicate/same-day extra run candidate | 2026-06-03-082505-Outdoor Running-Adriel’s Apple Watch.fit | high | structured, special, no-plan, duplicate, or unknown classification kept separate |

No-plan, duplicate/same-day extra, and drift/guard-unknown records remain excluded from production approval scoring unless later evidence clearly maps them to a planned fixture. The May 14 duplicate shares the same FIT start as the planned run and is not independent approval evidence.

## Cases Supporting Current Reconstruction

No simple Work + Open cases in this FIT pass support current reconstruction over the HKWorkoutActivity candidate.

## Cases Supporting HKWorkoutActivity Candidate

FIT supports the HKWorkoutActivity candidate for 50 simple Work + Open candidates, including all 10 large-shift priority cases. See the Priority 1 table for the highest-risk rows.

## Inconclusive Cases

No matched simple Work + Open FIT comparisons were inconclusive at the FIT-lap level. Production readiness is still inconclusive because FIT is not runtime truth and Apple Fitness visual/manual confirmation is still missing for many newly surfaced cases.

## Updated Production-Readiness Assessment

- Do the FIT files reduce uncertainty for the 10 large-shift simple candidates? Yes. FIT supports the HKWorkoutActivity candidate for all 10.
- Do FIT boundaries tend to align more with current reconstruction or HKWorkoutActivity candidates? HKWorkoutActivity candidates for the simple Work + Open set.
- Are there cases where HKWorkoutActivity clearly breaks a guard? None found in the FIT-lap comparison.
- Are there cases where HKWorkoutActivity clearly fixes drift? FIT strongly suggests yes for all 10 large-shift priority cases, especially the March 18 and March 29 row-boundary failures.
- Do structured/special workouts remain special cases? Yes.
- Is there enough evidence to promote activity-boundary rows to production? No. FIT improves confidence, but production needs Apple Fitness/manual visual parity checks for the priority cases and guard set, plus explicit acceptance of structured/special fallback rules.

## Recommendation

- Production-safe now: no.
- Debug-only prototype only: yes.
- Collect more Apple Fitness screenshots/manual references: yes, focused on the 10 large-shift cases and a representative no-large-shift guard set.
- Production still blocked: yes.

Exact evidence still missing: Apple Fitness/manual rows for the newly identified March/April large-shift cases, Apple Fitness/manual checks for representative guard/no-large-shift cases, and explicit structured/special fixture scoring that proves activity-boundary use cannot regress multi-step workouts. Production interval behavior, fixed-distance boundary logic, normal workout UI, FIT import, HealthFit dependency, and coaching/training features remain unchanged.
