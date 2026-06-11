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

Result:

- Top-level parity is strong for distance, workout time, average pace, active calories, cadence, and power.
- The first 1 km split differs by 3 seconds. This is acceptable for HealthKit-derived split interpolation because Apple Fitness can apply private smoothing, route/distance presentation, and rounding that are not exposed as public HealthKit fields.
- Total calories remain unavailable in RunSignal even though Apple Fitness shows 491 kcal. This should be treated as the next parity gap, not inferred from active calories.
- Apple Fitness interval rows remain not comparable to raw `HKWorkoutEvent` segment markers. Keep the explanatory unavailable state until a derived interval model can calculate distance, time, pace, and heart-rate fields.

