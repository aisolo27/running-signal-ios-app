# Jun 10, 2026 Apple Fitness Parity Check

Validation date: Jun 11, 2026

Reference workout:

- Workout ID: `EDD82D4A-5683-4C60-A561-CED12D24DF0A`
- Apple Fitness date: Jun 10, 2026
- Apple Fitness title: `Wednesday Interval (6kmm)`
- Source in RunSignal: `Adriel's Apple Watch`

Apple Fitness reference values from screenshots:

- Distance: 6.78 km
- Workout time: 40:39
- Average pace: 5:59 /km
- Active calories: 432 kcal
- Total calories: 491 kcal
- Average heart rate: 146 bpm
- Max heart rate: 179 bpm
- Average cadence: 165 spm
- Average power: 198 W
- Route available: yes

Apple Fitness custom workout definition from the workout setup screenshot:

| Step | Target | Goal |
| --- | --- | --- |
| Warmup | 2 km | Pace 6:00-6:30 /km |
| Repeat | 4 rounds | Work + recovery |
| Work | 400 m | Pace 3:40-3:50 /km |
| Recovery | 1:45 | Time-based recovery |
| Cooldown | 2.5 km | Pace 6:00-6:30 /km |

WorkoutKit plan audit from the physical iPhone on Jun 11, 2026:

- Status: available
- Plan type: custom workout
- Display name: `Wednesday Interval (6kmm)`
- Plan ID: `77EBFFFA-254C-4E57-B567-DF975A19415A`
- Public WorkoutKit structure matches the Apple Fitness setup: 2 km warmup, one 4x work/recovery block, 400 m work step, 105 second recovery step, and 2.50 km cooldown.

Apple Fitness interval rows from the completed workout:

| Row | Distance | Time | Pace | Heart rate |
| --- | ---: | ---: | ---: | ---: |
| Warmup | 2.00 km | 12:30 | 6:15 /km | 129 bpm |
| Work | 400 m | 1:30 | 3:46 /km | 164 bpm |
| Recovery | 160 m | 1:45 | 10:55 /km | 147 bpm |
| Work | 400 m | 1:31 | 3:46 /km | 163 bpm |
| Recovery | 164 m | 1:45 | 10:40 /km | 150 bpm |
| Work | 400 m | 1:28 | 3:40 /km | 166 bpm |
| Recovery | 147 m | 1:45 | 11:51 /km | 152 bpm |
| Work | 400 m | 1:27 | 3:37 /km | 166 bpm |
| Recovery | 167 m | 1:45 | 10:27 /km | 154 bpm |
| Cooldown | 2.50 km | 15:11 | 6:04 /km | 150 bpm |
| Open | 5 m | 0:06 | 17:56 /km | 154 bpm |

RunSignal checklist values:

- Distance: 6.79 km
- Duration: 40:40
- Elapsed: 40:40
- Pace: 5:59 /km
- Active calories: 432 kcal
- Total calories: unavailable
- Cadence: 166 spm
- Power: 199 W

Split comparison:

| Split | Apple Fitness | RunSignal | Delta | Status |
| --- | ---: | ---: | ---: | --- |
| KM 1 | 6:16 | 6:13 | 3 sec | Pass within tolerance |
| KM 2 | 6:12 | 6:12 | 0 sec | Pass |
| KM 3 | 4:52 | 4:52 | 0 sec | Pass |
| KM 4 | 5:57 | 5:57 | 0 sec | Pass |
| KM 5 | 6:33 | 6:33 | 0 sec | Pass |

Physical-iPhone Raw HealthKit Debug screenshot check on Jun 11, 2026:

| Marker row | Kind | Offset window | Duration | Distance | Matches Apple Fitness split? |
| --- | --- | ---: | ---: | ---: | --- |
| 1 | Split marker | 0:00 -> 6:16 | 6:16 | 1.01 km | Yes, split 1 |
| 3 | Overlapping segment marker | 6:16 -> 12:27 | 6:12 | 1.00 km | Yes, split 2 |
| 5 | Overlapping segment marker | 12:27 -> 17:19 | 4:52 | 1.00 km | Yes, split 3 |
| 6 | Split marker | 17:19 -> 23:16 | 5:57 | 1.00 km | Yes, split 4 |
| 8 | Overlapping segment marker | 23:16 -> 29:49 | 6:33 | 0.99 km | Yes, split 5 |
| 10 | Overlapping segment marker | 29:49 -> 35:51 | 6:02 | 1.00 km | Yes, split 6 |
| 11 | Raw segment marker | 35:51 -> 40:37 | 4:46 | 0.78 km | Yes, final partial split |

The physical screenshot label is `HealthKit Segment Markers`, not `Derived Interval Candidates`. The visible marker rows expose no Apple Fitness interval labels; each row is still `Unknown`.

Result:

- Top-level parity is strong for distance, workout time, average pace, active calories, cadence, and power.
- The first 1 km split differs by 3 seconds. This is acceptable for HealthKit-derived split interpolation because Apple Fitness can apply private smoothing, route/distance presentation, and rounding that are not exposed as public HealthKit fields.
- Total calories were unavailable in RunSignal at validation time even though Apple Fitness showed 491 kcal. The follow-up implementation should fill this only from HealthKit active plus basal energy evidence, not by inference.
- Apple Fitness interval rows are true custom-workout step rows. WorkoutKit exposes the planned custom-workout structure for this completed workout, while raw `HKWorkoutEvent` segment markers in RunSignal remain unlabeled and align with split windows. Keep the main interval UI gated until a resolver can pair WorkoutKit plan steps with actual HealthKit sample windows.
- Revised physical-iPhone screenshots after the WorkoutKit boundary refinement validate the reconstructed interval approach for this workout within tolerance. Warmup is 12:26 / 2.01 km versus Apple Fitness 12:30 / 2.00 km; Open / Extra is 0:08 / 0.01 km versus about 0:06 / 5 m; cooldown is 15:12 / 2.51 km versus 15:11 / 2.50 km. Work rows remain close, recoveries remain exactly 1:45, and the debug source continues to state that HealthKit segment markers are not used.
