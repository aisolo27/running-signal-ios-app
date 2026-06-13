# Monthly Diagnostics Rollup: 2026-03 Through 2026-06

## Executive Summary

The refreshed March through June monthly diagnostics exports cover 87 workouts. All 87 refreshed successfully, all 87 records came from `freshQuery`, and the dataset reports zero missing evidence after refresh.

The exports expose 50 simple fixed-distance Work + Open candidates. All simple candidates are scoreable by the debug-only `hkworkoutactivity_boundary` candidate because each has one `HKWorkoutActivity` row mapped to one planned WorkoutKit step, plus an inferred Open / Extra tail.

This is good evidence for offline scoring coverage, but it is not enough to promote production behavior. 10 simple candidates materially shift Work/Open distance or time relative to current reconstruction, and the monthly export alone cannot classify those shifts as Apple Fitness-preserving drift fixes versus guard regressions. Structured interval and warmup/work/cooldown fixtures remain special cases, not simple Work/Open approval evidence.

Recommendation: **production still blocked**. Keep `HKWorkoutActivity` rows debug/export-only, run broader offline scoring on this monthly dataset, and collect Apple Fitness/FIT references for selected large-shift and guard-like fixtures. Apple Fitness/manual rows and FIT remain references only, not runtime truth.

## Files Found And Matched

Source folder: `/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing`

| File | Content type | Matched month | Evidence from content |
| --- | --- | --- | --- |
| `text-338130C8007F-1.txt` | Markdown summary | `2026-03` | Header says `Selected month: 2026-03` |
| `text-51B0D409F50C-1.txt` | Markdown summary | `2026-04` | Header says `Selected month: 2026-04` |
| `text-9F32DF0123F2-1.txt` | Markdown summary | `2026-05` | Header says `Selected month: 2026-05` |
| `text-46D6DF978892-1.txt` | Markdown summary | `2026-06` | Header says `Selected month: 2026-06` |
| `text-44BB7E225229-1.txt` | JSON export | `2026-03` | JSON `selectedMonth: 2026-03`, `generatedAt: 2026-06-13T00:56:03Z` |
| `text-2E259B41185E-1.txt` | JSON export | `2026-04` | JSON `selectedMonth: 2026-04`, `generatedAt: 2026-06-13T00:41:59Z` |
| `text-478921EE13CF-1.txt` | JSON export | `2026-05` | JSON `selectedMonth: 2026-05`, `generatedAt: 2026-06-13T00:30:38Z` |
| `text-E3D0DDF29E8B-1.txt` | JSON export | `2026-06` | JSON `selectedMonth: 2026-06`, `generatedAt: 2026-06-13T00:58:30Z` |
| `.DS_Store` | Finder metadata | n/a | ignored |

All four JSON exports use the refreshed monthly format: they include a `summary`, per-record `refreshStatus`, `evidenceSource`, `activityBoundaryCandidateSummary`, and `activityBoundaryCandidateIntervals`, while `productionIntervalBehaviorChanged`, `normalWorkoutUIChanged`, and `boundaryLogicChanged` are all `false`.

## Per-Month Summary

| Month | Generated at | Workouts | Refresh success | Refresh failed | Skipped | Fresh query | Cached state | Missing evidence | Simple Work+Open | Structured | Special | No plan | No activity rows | Duplicate extra | Drift/guard unknown |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-03 | 2026-06-13T00:56:03Z | 27 | 27 | 0 | 0 | 27 | 0 | 0 | 16 | 7 | 2 | 1 | 0 | 0 | 1 |
| 2026-04 | 2026-06-13T00:41:59Z | 23 | 23 | 0 | 0 | 23 | 0 | 0 | 12 | 3 | 1 | 0 | 0 | 6 | 1 |
| 2026-05 | 2026-06-13T00:30:38Z | 26 | 26 | 0 | 0 | 26 | 0 | 0 | 15 | 8 | 1 | 0 | 0 | 1 | 1 |
| 2026-06 | 2026-06-13T00:58:30Z | 11 | 11 | 0 | 0 | 11 | 0 | 0 | 7 | 2 | 1 | 0 | 0 | 1 | 0 |

## Cross-Month Totals

- Total workouts: 87
- Total refreshed successfully: 87
- Total missing after refresh: 0
- Total simple Work + Open candidates: 50
- Total structured intervals: 20
- Total specials: 5
- Total no-plan / nonfixture workouts: 9
- Total drift/guard unknown workouts: 3
- Total scoreable HKWorkoutActivity candidates: 78
- Total non-scoreable HKWorkoutActivity candidates: 9

Non-scoreable reason: `WorkoutKit planned steps are missing.` for all 9 non-scoreable records.

## Simple Work + Open Candidate Table

Large shift thresholds used for triage: at least 5 seconds or at least 10 meters difference between current reconstruction and the activity-boundary candidate. `Class` is intentionally conservative because the monthly exports do not include Apple Fitness/FIT reference rows.

| Month | Start | Goal | Workout ID | Activity/planned | Current Work | Candidate Work | Work delta | Current Open | Candidate Open | Open delta | Status | Flags |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-03 | 2026-03-02T15:26:06Z | 6 km | `E007B98E-CFA6-47F8-B064-9CD68B583159` | 1/1 | 6002.6 m / 2237.9 s | 6000.8 m / 2239.8 s | -1.8 m / 1.9 s | 19.8 m / 13.6 s | 21.6 m / 11.7 s | 1.8 m / -1.9 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-04T15:45:46Z | 5 km | `CA382610-CA9E-48EE-9A3F-F1396A05200D` | 1/1 | 5002.0 m / 1935.8 s | 5007.4 m / 1940.4 s | 5.4 m / 4.6 s | 42.5 m / 23.9 s | 37.1 m / 19.2 s | -5.4 m / -4.7 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-06T13:11:15Z | 5 km | `918E7C4E-A413-4FAC-8D6E-5601C03C5D61` | 1/1 | 5000.7 m / 1870.2 s | 5008.3 m / 1875.4 s | 7.6 m / 5.2 s | 37.3 m / 17.8 s | 29.8 m / 12.6 s | -7.5 m / -5.2 s | unknown; needs Apple/FIT reference | work time +5.2, open time -5.2 |
| 2026-03 | 2026-03-08T20:35:44Z | 10 km | `7ABBE25E-6837-44D1-901C-AE05240F9E70` | 1/1 | 10000.1 m / 4078.6 s | 10007.1 m / 4084.0 s | 7.0 m / 5.4 s | 78.5 m / 38.2 s | 71.4 m / 32.9 s | -7.1 m / -5.3 s | unknown; needs Apple/FIT reference | work time +5.4, open time -5.3 |
| 2026-03 | 2026-03-09T14:16:32Z | 8 km | `C7E151DD-14F3-47EE-8441-C7E44F0C0C98` | 1/1 | 8001.4 m / 3019.3 s | 8006.4 m / 3024.2 s | 5.0 m / 4.9 s | 97.0 m / 42.8 s | 91.9 m / 37.9 s | -5.1 m / -4.9 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-11T13:40:15Z | 5 km | `7B17660D-0100-438F-A095-269037D9967A` | 1/1 | 5006.7 m / 1907.6 s | 5007.7 m / 1910.5 s | 1.0 m / 2.9 s | 44.0 m / 24.3 s | 43.1 m / 21.4 s | -0.9 m / -2.9 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-13T15:20:25Z | 5 km | `F63F21DC-78B1-49BE-B511-21009BF960E9` | 1/1 | 5006.2 m / 1866.0 s | 5007.5 m / 1869.2 s | 1.3 m / 3.2 s | 21.1 m / 13.8 s | 19.8 m / 10.7 s | -1.3 m / -3.1 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-15T17:57:35Z | 13 km | `B36F1A98-EF3E-4BCB-A6BA-43E239959297` | 1/1 | 13000.5 m / 4731.9 s | 13007.8 m / 4737.2 s | 7.3 m / 5.3 s | 59.8 m / 26.7 s | 52.6 m / 21.4 s | -7.2 m / -5.3 s | unknown; needs Apple/FIT reference | work time +5.3, open time -5.3 |
| 2026-03 | 2026-03-16T12:43:24Z | 9 km | `93BCC1B3-589D-4EF6-8B6C-75BFC29DCEBF` | 1/1 | 9007.1 m / 3201.7 s | 9008.3 m / 3204.7 s | 1.2 m / 3.0 s | 56.2 m / 24.1 s | 55.0 m / 21.1 s | -1.2 m / -3.0 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-18T14:50:46Z | 5 km | `5E93C8CA-9906-4628-9E8B-3209B2832772` | 1/1 | 5003.6 m / 1823.9 s | 1379.2 m / 514.3 s | -3624.4 m / -1309.6 s | 119.9 m / 52.3 s | 3744.2 m / 1361.9 s | 3624.3 m / 1309.6 s | unknown; needs Apple/FIT reference | work time -1309.6, open time +1309.6, work distance -3624.4, open distance +3624.3 |
| 2026-03 | 2026-03-21T22:59:01Z | 6 km | `92F02C49-8927-4367-88F8-453B2ABD96B0` | 1/1 | 6007.0 m / 2211.0 s | 6008.1 m / 2212.0 s | 1.1 m / 1.0 s | 25.7 m / 15.8 s | 30.3 m / 14.8 s | 4.6 m / -1.0 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-22T18:19:44Z | 21.10 km | `AE264AA7-C10A-4F37-A507-7778CD9B0822` | 1/1 | 21105.0 m / 7736.1 s | 21109.0 m / 7737.4 s | 4.0 m / 1.3 s | 41.7 m / 22.6 s | 45.5 m / 21.2 s | 3.8 m / -1.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-23T21:59:36Z | 7 km | `92CE211F-DF75-47AA-876F-6A44E4577663` | 1/1 | 7000.7 m / 2509.3 s | 7007.8 m / 2514.6 s | 7.1 m / 5.3 s | 62.8 m / 28.7 s | 55.7 m / 23.4 s | -7.1 m / -5.3 s | unknown; needs Apple/FIT reference | work time +5.3, open time -5.3 |
| 2026-03 | 2026-03-26T14:15:48Z | 5 km | `94553155-8A06-4097-B6D2-A106102BA53C` | 1/1 | 5001.4 m / 1853.0 s | 5008.5 m / 1857.8 s | 7.1 m / 4.8 s | 42.2 m / 20.9 s | 35.1 m / 16.0 s | -7.1 m / -4.9 s | likely guard/preserved by candidate, unverified | none |
| 2026-03 | 2026-03-29T18:45:45Z | 12 km | `5EB80EEB-6060-4594-B73F-591A540628CF` | 1/1 | 12001.8 m / 4636.8 s | 3604.7 m / 1618.0 s | -8397.1 m / -3018.8 s | 168.1 m / 65.3 s | 8564.4 m / 3084.1 s | 8396.3 m / 3018.8 s | unknown; needs Apple/FIT reference | work time -3018.8, open time +3018.8, work distance -8397.1, open distance +8396.3 |
| 2026-03 | 2026-03-30T23:19:25Z | 6 km | `8B505857-D598-49D9-8B8D-B9431336236B` | 1/1 | 6001.6 m / 2145.8 s | 6004.0 m / 2150.7 s | 2.4 m / 4.9 s | 2.6 m / 9.2 s | 0.3 m / 4.3 s | -2.3 m / -4.9 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-05T21:18:47Z | 5 km | `98A8E900-27FD-4E4F-A7B7-7FB54E2C8DE8` | 1/1 | 5008.1 m / 1325.4 s | 5011.5 m / 1328.8 s | 3.4 m / 3.4 s | 10.9 m / 10.0 s | 7.5 m / 6.6 s | -3.4 m / -3.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-07T14:21:02Z | 6 km | `86346FD7-8F91-4EE2-B519-3B21F66476F1` | 1/1 | 6005.9 m / 2180.7 s | 6007.9 m / 2184.1 s | 2.0 m / 3.4 s | 56.1 m / 29.1 s | 54.1 m / 25.7 s | -2.0 m / -3.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-08T15:08:23Z | 5 km | `0F11D6D3-10E3-4FC7-A224-169F89DD4406` | 1/1 | 5003.2 m / 1799.3 s | 5006.7 m / 1803.6 s | 3.5 m / 4.3 s | 46.5 m / 26.5 s | 42.9 m / 22.2 s | -3.6 m / -4.3 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-10T11:47:35Z | 5 km | `148C5043-4E13-464E-8DDF-B4B4A196E536` | 1/1 | 5006.3 m / 1845.7 s | 5008.6 m / 1847.0 s | 2.3 m / 1.3 s | 142.3 m / 60.4 s | 146.1 m / 59.1 s | 3.8 m / -1.3 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-16T11:29:41Z | 5 km | `4F478C27-6F64-4189-9F6D-49A601EF21F0` | 1/1 | 5005.3 m / 1791.0 s | 5015.0 m / 1797.3 s | 9.7 m / 6.3 s | 50.0 m / 24.6 s | 40.3 m / 18.3 s | -9.7 m / -6.3 s | unknown; needs Apple/FIT reference | work time +6.3, open time -6.3 |
| 2026-04 | 2026-04-17T11:33:34Z | 5 km | `357E1F59-6017-4329-9FF7-0BFDF971B3B3` | 1/1 | 5003.9 m / 1846.6 s | 5008.5 m / 1850.7 s | 4.6 m / 4.1 s | 34.9 m / 20.3 s | 30.3 m / 16.2 s | -4.6 m / -4.1 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-20T13:17:53Z | 8 km | `BBB3E49E-593D-4C1A-B157-19B9DB7D7AA1` | 1/1 | 8003.1 m / 2948.9 s | 8007.1 m / 2953.3 s | 4.0 m / 4.4 s | 323.1 m / 126.5 s | 319.1 m / 122.1 s | -4.0 m / -4.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-23T12:03:24Z | 6.50 km | `8047BF00-6861-4DEB-B0FB-9D7E5C891441` | 1/1 | 6501.5 m / 2493.8 s | 6507.3 m / 2498.7 s | 5.8 m / 4.9 s | 116.3 m / 52.9 s | 110.5 m / 47.9 s | -5.8 m / -5.0 s | unknown; needs Apple/FIT reference | open time -5.0 |
| 2026-04 | 2026-04-26T11:38:35Z | 14.50 km | `CCFDA569-20ED-45F1-827C-0BCAF9535962` | 1/1 | 14505.4 m / 5282.3 s | 14508.1 m / 5285.8 s | 2.7 m / 3.5 s | 59.3 m / 28.1 s | 56.7 m / 24.7 s | -2.6 m / -3.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-27T12:16:21Z | 8.10 km | `06D024DF-A406-4245-93BF-F40E1ECE6631` | 1/1 | 8103.5 m / 3060.8 s | 8107.9 m / 3066.5 s | 4.4 m / 5.7 s | 19.8 m / 14.6 s | 11.4 m / 8.9 s | -8.4 m / -5.7 s | unknown; needs Apple/FIT reference | work time +5.7, open time -5.7 |
| 2026-04 | 2026-04-28T11:44:52Z | 7.25 km | `9AD88333-024B-4476-B81F-7D15A8E0FC89` | 1/1 | 7256.3 m / 2768.8 s | 7257.8 m / 2771.9 s | 1.5 m / 3.1 s | 48.3 m / 23.0 s | 46.8 m / 19.9 s | -1.5 m / -3.1 s | likely guard/preserved by candidate, unverified | none |
| 2026-04 | 2026-04-30T11:52:29Z | 6.50 km | `2EA52659-32A7-4C08-9F65-32B986B55348` | 1/1 | 6505.1 m / 2526.9 s | 6507.5 m / 2530.4 s | 2.4 m / 3.5 s | 33.3 m / 20.0 s | 30.8 m / 16.6 s | -2.5 m / -3.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-03T12:06:10Z | 15.30 km | `DF0EA915-0E36-42AE-B37E-54CF45AD77C5` | 1/1 | 15306.1 m / 5610.7 s | 15308.2 m / 5614.1 s | 2.1 m / 3.4 s | 64.9 m / 32.5 s | 62.8 m / 29.1 s | -2.1 m / -3.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-04T12:40:42Z | 8.10 km | `AE7281A6-3E05-47F5-AECD-6F43935F7730` | 1/1 | 8102.9 m / 3105.0 s | 8102.3 m / 3103.4 s | -0.6 m / -1.6 s | 22.7 m / 15.3 s | 32.5 m / 16.9 s | 9.8 m / 1.6 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-05T12:05:06Z | 7.25 km | `89DCB4E9-D9B3-4E74-855B-1245E444565B` | 1/1 | 7254.3 m / 2824.8 s | 7257.9 m / 2828.9 s | 3.6 m / 4.1 s | 63.2 m / 29.9 s | 59.5 m / 25.9 s | -3.7 m / -4.0 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-07T11:43:57Z | 6.45 km | `05534C31-2C93-4E90-B087-0F7525232ABD` | 1/1 | 6453.2 m / 2471.6 s | 6458.0 m / 2475.8 s | 4.8 m / 4.2 s | 32.3 m / 18.0 s | 27.5 m / 13.8 s | -4.8 m / -4.2 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-11T12:10:09Z | 8.10 km | `AF488DF7-3335-442F-9827-ABE91ACD20F1` | 1/1 | 8103.0 m / 3273.3 s | 8102.4 m / 3275.7 s | -0.6 m / 2.4 s | 10.4 m / 12.3 s | 10.9 m / 9.9 s | 0.5 m / -2.4 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-14T11:58:59Z | 6.45 km | `646E0788-5729-4DE0-A0E4-C2A929A01761` | 1/1 | 6451.8 m / 2518.3 s | 6457.5 m / 2523.1 s | 5.7 m / 4.8 s | 231.5 m / 105.9 s | 225.9 m / 101.1 s | -5.6 m / -4.8 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-17T11:47:35Z | 13 km | `AA3AE762-3AFA-4CA9-A5AD-19672E560510` | 1/1 | 13003.3 m / 5054.8 s | 13006.5 m / 5059.0 s | 3.2 m / 4.2 s | 64.9 m / 36.0 s | 61.7 m / 31.8 s | -3.2 m / -4.2 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-18T12:00:04Z | 8.10 km | `BA2EF5A8-1666-4D35-B1BD-4FD40523C234` | 1/1 | 8102.9 m / 3180.8 s | 8106.6 m / 3185.0 s | 3.7 m / 4.2 s | 73.6 m / 36.6 s | 69.9 m / 32.4 s | -3.7 m / -4.2 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-19T12:14:02Z | 7.25 km | `2F860A63-E7A9-4D57-AD74-023DBDF6CB78` | 1/1 | 7252.4 m / 2964.2 s | 7256.7 m / 2968.7 s | 4.3 m / 4.5 s | 29.2 m / 17.9 s | 24.9 m / 13.4 s | -4.3 m / -4.5 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-21T11:51:00Z | 6.45 km | `80FC7775-07BF-4739-A4C1-D0E26AA4533F` | 1/1 | 6455.4 m / 2633.6 s | 6457.5 m / 2636.9 s | 2.1 m / 3.3 s | 37.7 m / 21.5 s | 35.6 m / 18.2 s | -2.1 m / -3.3 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-24T11:54:20Z | 12.10 km | `14E299BD-DCEB-49F5-B5CE-44B77A89D994` | 1/1 | 12103.1 m / 4914.3 s | 12106.8 m / 4918.5 s | 3.7 m / 4.2 s | 968.3 m / 399.4 s | 964.6 m / 395.2 s | -3.7 m / -4.2 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-25T11:52:27Z | 7.25 km | `99FA2220-31D0-4F63-8536-963655E01DED` | 1/1 | 7255.7 m / 2863.5 s | 7257.4 m / 2866.6 s | 1.7 m / 3.1 s | 14.3 m / 12.1 s | 12.7 m / 9.0 s | -1.6 m / -3.1 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-26T11:36:21Z | 6.45 km | `7D4AA638-AFA0-4875-88B2-C87EDF5EC600` | 1/1 | 6454.2 m / 2527.5 s | 6457.4 m / 2531.3 s | 3.2 m / 3.8 s | 97.2 m / 45.2 s | 94.0 m / 41.4 s | -3.2 m / -3.8 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-28T11:48:47Z | 6.45 km | `E9823581-47B3-475A-82DE-4D6EA1816691` | 1/1 | 6452.1 m / 2616.1 s | 6456.1 m / 2620.8 s | 4.0 m / 4.7 s | 20.0 m / 16.6 s | 16.1 m / 11.9 s | -3.9 m / -4.7 s | likely guard/preserved by candidate, unverified | none |
| 2026-05 | 2026-05-31T12:19:37Z | 10 km | `9200F66D-D17C-4CAF-855A-F1BFB2E12548` | 1/1 | 10000.8 m / 4096.6 s | 10000.9 m / 4099.2 s | 0.1 m / 2.6 s | 136.9 m / 62.6 s | 136.8 m / 60.0 s | -0.1 m / -2.6 s | likely guard/preserved by candidate, unverified | none |
| 2026-06 | 2026-06-01T11:51:29Z | 6.45 km | `559663F5-6229-4079-A483-39A04BBA9385` | 1/1 | 6450.6 m / 2558.3 s | 6457.8 m / 2563.5 s | 7.2 m / 5.2 s | 12.3 m / 12.7 s | 5.1 m / 7.4 s | -7.2 m / -5.3 s | unknown; needs Apple/FIT reference | work time +5.2, open time -5.3 |
| 2026-06 | 2026-06-02T11:51:50Z | 5.65 km | `298CF214-ADD6-4161-8DCC-0BC7F1F55A55` | 1/1 | 5651.9 m / 2172.6 s | 5651.2 m / 2174.8 s | -0.7 m / 2.2 s | 57.0 m / 30.1 s | 57.7 m / 27.8 s | 0.7 m / -2.3 s | likely guard/preserved by candidate, unverified | none |
| 2026-06 | 2026-06-04T11:47:06Z | 5.65 km | `0F92DFB9-F99B-4950-9D00-6B499F0714FB` | 1/1 | 5652.9 m / 2194.3 s | 5657.2 m / 2195.6 s | 4.3 m / 1.3 s | 42.0 m / 22.2 s | 44.8 m / 20.9 s | 2.8 m / -1.3 s | likely guard/preserved by candidate, unverified | none |
| 2026-06 | 2026-06-07T12:21:28Z | 8.10 km | `7E6180B8-1F2B-45ED-A597-672821021DA1` | 1/1 | 8100.4 m / 3247.5 s | 8100.8 m / 3250.2 s | 0.4 m / 2.7 s | 12.4 m / 12.2 s | 12.0 m / 9.5 s | -0.4 m / -2.7 s | likely guard/preserved by candidate, unverified | none |
| 2026-06 | 2026-06-08T12:21:28Z | 5 km | `A1865D94-BEF9-4630-86FE-F91B1DD115AE` | 1/1 | 5003.9 m / 1934.8 s | 5007.6 m / 1938.7 s | 3.7 m / 3.9 s | 61.4 m / 29.7 s | 57.6 m / 25.8 s | -3.8 m / -3.9 s | likely guard/preserved by candidate, unverified | none |
| 2026-06 | 2026-06-09T12:23:42Z | 5 km | `B353A7CC-708B-45FB-BD21-CBDD0989942A` | 1/1 | 5002.1 m / 1953.9 s | 5006.2 m / 1958.6 s | 4.1 m / 4.7 s | 37.8 m / 21.0 s | 33.6 m / 16.3 s | -4.2 m / -4.7 s | likely guard/preserved by candidate, unverified | none |
| 2026-06 | 2026-06-12T11:49:54Z | 5 km | `1A418F0B-05CB-4316-B1E1-33D34DC7F04B` | 1/1 | 5001.6 m / 1918.5 s | 5007.9 m / 1923.4 s | 6.3 m / 4.9 s | 43.2 m / 22.2 s | 36.9 m / 17.4 s | -6.3 m / -4.8 s | likely guard/preserved by candidate, unverified | none |

## Structured / Special Workout Table

| Month | Start | Classification | Workout ID | Activity/planned | Rows current/candidate | Material difference | Notes |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 2026-03 | 2026-03-03T13:39:37Z | structured interval workout | `A631421F-D5AA-4E86-8DB3-6167ED4B0FC7` | 18/18 | 18/18 | no | counts align; keep special |
| 2026-03 | 2026-03-05T14:37:43Z | warmup/work/cooldown special | `F43BA3E4-19FF-4071-B3AD-8631967A7BD3` | 3/3 | 3/3 | no | counts align; keep special |
| 2026-03 | 2026-03-10T13:49:08Z | structured interval workout | `BFD992B2-C866-4E2E-A5A9-FCFC0BF9F0BE` | 13/13 | 13/13 | no | counts align; keep special |
| 2026-03 | 2026-03-12T13:41:02Z | structured interval workout | `1A7502AE-CF69-4680-8D8C-CE636D70FAEA` | 8/8 | 8/8 | no | counts align; keep special |
| 2026-03 | 2026-03-17T12:29:37Z | structured interval workout | `5BFAB7FE-171E-43C0-9433-C8D39D2B6B7C` | 18/18 | 18/18 | no | counts align; keep special |
| 2026-03 | 2026-03-19T16:51:00Z | warmup/work/cooldown special | `A1C01AA7-2955-4759-93E3-289691D204A6` | 3/3 | 3/3 | no | counts align; keep special |
| 2026-03 | 2026-03-25T14:47:56Z | structured interval workout | `CFD67D1B-41E8-44F6-ABB3-80CE5793099F` | 14/14 | 14/14 | no | counts align; keep special |
| 2026-03 | 2026-03-27T12:59:26Z | structured interval workout | `1594F1C9-A897-4C5C-8B61-3013BFBE570B` | 8/8 | 8/8 | no | counts align; keep special |
| 2026-03 | 2026-03-31T15:26:28Z | structured interval workout | `EEF8B26E-093E-44D0-AFD7-FFEC318390F2` | 10/10 | 10/10 | no | counts align; keep special |
| 2026-04 | 2026-04-12T16:01:33Z | structured interval workout | `AE8AF4B2-FB7E-4D9C-92FD-D3BA9AE6E88F` | 2/2 | 3/3 | no | counts align; keep special |
| 2026-04 | 2026-04-22T11:39:58Z | structured interval workout | `0335DE40-44C5-48AC-9A05-F32314713DE1` | 12/12 | 12/12 | no | counts align; keep special |
| 2026-04 | 2026-04-24T12:02:30Z | warmup/work/cooldown special | `BE962B2D-5081-4AC1-888D-F5502B6CDBEA` | 3/3 | 3/3 | no | counts align; keep special |
| 2026-04 | 2026-04-29T11:49:02Z | structured interval workout | `9DF73D06-448A-4384-A27C-E3B34B2CD592` | 12/12 | 12/12 | no | counts align; keep special |
| 2026-05 | 2026-05-01T12:07:44Z | structured interval workout | `8BF85190-5583-47BF-A975-576D77980137` | 4/4 | 5/5 | no | counts align; keep special |
| 2026-05 | 2026-05-06T12:02:13Z | structured interval workout | `2941455F-F0BE-444B-80FB-2054CA20D8B4` | 14/14 | 14/14 | no | counts align; keep special |
| 2026-05 | 2026-05-08T11:55:07Z | structured interval workout | `C3CD1346-60D3-4F3A-9F7D-8A8ADBDBC68E` | 6/6 | 6/6 | no | counts align; keep special |
| 2026-05 | 2026-05-13T11:52:06Z | structured interval workout | `75C27BC6-E833-4BC4-B5A1-1DEDB1F0BC37` | 18/18 | 18/18 | no | counts align; keep special |
| 2026-05 | 2026-05-15T12:00:12Z | structured interval workout | `4947444A-1965-413A-ABC5-886041756F09` | 8/8 | 8/8 | no | counts align; keep special |
| 2026-05 | 2026-05-20T11:43:00Z | structured interval workout | `7F742555-48CB-403A-8916-58661DA98555` | 10/10 | 10/10 | no | counts align; keep special |
| 2026-05 | 2026-05-22T11:55:11Z | structured interval workout | `A10FBDC7-042C-4FF7-AB20-A6C2A82B1651` | 6/6 | 6/6 | no | counts align; keep special |
| 2026-05 | 2026-05-27T11:45:47Z | structured interval workout | `B0DB0318-7B7F-4F4F-B583-7684D660FC29` | 22/22 | 22/22 | no | counts align; keep special |
| 2026-05 | 2026-05-29T11:49:28Z | warmup/work/cooldown special | `5243F1B1-AF84-4A91-A647-9EE742E5A329` | 3/3 | 3/3 | no | counts align; keep special |
| 2026-06 | 2026-06-03T11:45:08Z | structured interval workout | `F6D47A51-9510-4C7A-9186-6BAFE3C128C9` | 8/8 | 8/8 | no | counts align; keep special |
| 2026-06 | 2026-06-05T11:53:53Z | warmup/work/cooldown special | `9C09006E-9850-435C-95F5-A0AA0BE42A33` | 3/3 | 4/4 | yes | open distance +13.5 |
| 2026-06 | 2026-06-10T11:27:51Z | structured interval workout | `EDD82D4A-5683-4C60-A561-CED12D24DF0A` | 10/10 | 11/11 | no | counts align; keep special |

## No-Plan / Duplicate / Excluded Workout Table

| Month | Start | Classification | Workout ID | Scoreable | Reason | Activity/planned |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-03 | 2026-03-01T18:38:01Z | no WorkoutKit plan | `54E08E28-1DE5-4FE2-848E-92F1A56925C4` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-03 | 2026-03-29T18:43:39Z | drift/guard candidate unknown | `6BB0DE2C-2E1E-48DC-B168-AE4BC9243D35` | yes | excluded from production scoring: unknown/open fixture | 1/1 |
| 2026-04 | 2026-04-11T11:21:32Z | duplicate/same-day extra run candidate | `88AB3093-C1DB-4823-A280-78C9A0F190A6` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-04 | 2026-04-11T12:25:39Z | duplicate/same-day extra run candidate | `D01EA29B-1C6C-4E1D-96A9-1365D5EE016D` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-04 | 2026-04-14T22:57:52Z | duplicate/same-day extra run candidate | `B716E266-7C7E-4F99-A283-E0FDA4FB88A9` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-04 | 2026-04-14T23:16:30Z | duplicate/same-day extra run candidate | `B9263EDD-B4E0-4B35-8923-B146A271DC14` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-04 | 2026-04-18T22:40:59Z | drift/guard candidate unknown | `F20D3C57-E1F4-47AA-B5A5-D8C981F4F680` | yes | excluded from production scoring: unknown/open fixture | 1/1 |
| 2026-04 | 2026-04-21T09:43:00Z | duplicate/same-day extra run candidate | `4E6FC89C-0873-4DD9-BDB0-A47F580D4F88` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-04 | 2026-04-21T10:22:35Z | duplicate/same-day extra run candidate | `0BF7209B-8ABD-4FB8-BBE2-E35CB3CA9793` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-05 | 2026-05-10T11:31:09Z | drift/guard candidate unknown | `C427D2ED-D3FD-4CBC-87D0-A3AB76CBCE14` | yes | excluded from production scoring: unknown/open fixture | 1/1 |
| 2026-05 | 2026-05-14T11:58:59Z | duplicate/same-day extra run candidate | `491EF7CB-9B78-46B6-8550-84B22EB84276` | no | WorkoutKit planned steps are missing. | 1/0 |
| 2026-06 | 2026-06-03T12:25:05Z | duplicate/same-day extra run candidate | `0DA6CAFE-C9A1-41CF-B576-1CDFF1190E73` | no | WorkoutKit planned steps are missing. | 1/0 |

## HKWorkoutActivity Scoreability Summary

- Scoreable records: 78
- Non-scoreable records: 9
- Non-scoreable reason: missing WorkoutKit planned steps. These are no-plan or duplicate/same-day extra runs and should stay excluded from production approval scoring unless manually matched to a planned fixture later.
- Simple Work + Open scoreable records: 50 of 50
- Structured/special scoreable records: 25 of 25
- Drift/guard unknown open-fixture records: 3; scoreable at the raw candidate level where a plan exists, but excluded from simple Work/Open production scoring.

## Candidate Boundary Risk Summary

- Simple candidates with no large candidate-vs-current shift: 40. These look guard-like or preserved by the candidate, but this is not proof without Apple Fitness/FIT references.
- Simple candidates with large candidate-vs-current shifts: 10. These are the priority reference-capture set because the monthly export alone cannot tell whether the shift fixes drift or breaks a guard.
- Structured/special workouts with material count/row/shift differences: 1. Keep these out of simple guard/drift scoring and review as special fixtures only.
- Non-scoreable no-plan / duplicate workouts: 9. They do not prove production safety because planned-step mapping is missing.

## Recommendation

- Production-safe now: no.
- Debug-only prototype only: yes.
- Collect more Apple/FIT references: yes, especially for simple Work/Open large-shift rows and selected no-shift guard-like rows.
- Production still blocked: yes.

The expanded March through June dataset supports broader offline scoring and candidate triage, but it does not prove that `HKWorkoutActivity` preserves guard cases and special fixtures. Production interval behavior, fixed-distance boundary logic, normal workout UI, FIT import, HealthFit dependency, and coaching/training features remain unchanged.
