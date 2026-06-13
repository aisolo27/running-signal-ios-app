# Custom Workout Shape Coverage Audit: March-June 2026

Generated: 2026-06-13T17:33:17.539123Z

## Executive summary

The current Gate B analysis is not missing the user's newer easy-run volume; those runs are mostly classified outside Gate B as Gate A simple fixed-distance Work + Open candidates. Gate B is focused on multi-step custom workouts, so the narrow warmup/work/open-cooldown candidate scorecard found only 4 exact rows by design.

The April 20/22 program start does explain the shape distribution. After 2026-04-20, the pattern is clear: easy fixed-goal Work/Open runs on easy days, structured interval workouts on Wednesdays, and Friday tempo-like workouts that split across several shapes rather than one exact narrow shape.

Pauses are not bad data. They appear in hard workouts and should be treated as first-class product evidence. Clean fixtures can separate pause-free and paused cases, but future custom-workout support needs explicit elapsed-vs-timer and pause handling. The raw HealthKit packets also include a single unpaired pause marker on most workouts, so this audit treats paired pause/resume intervals as the stronger pause evidence and preserves unpaired marker counts separately.

## Why the current narrow candidate found only 4 exact rows

The narrow candidate requires exactly `Warmup(2 km) > one fixed Work step > Cooldown(Open)`, exactly 3 rows across current/candidate/FIT/plan/FIT-step evidence, no recovery rows, and no fixed-cooldown tail. That excludes:

- 50 simple Work/Open easy fixed-goal workouts, because they are Gate A rather than Gate B.
- 17 repeat-block Gate B rows, because repeat expansion rules are still blocked.
- 4 Open/Extra tail rows, because fixed-step exhaustion and tail classification are still blocked.
- 7 timer-drift rows, because pause/timer semantics are real product requirements but not approved as a prototype shortcut.
- 12 excluded/no-plan/duplicate/unknown rows, because evidence is missing or not scoreable.

## Program-period timeline, especially after 2026-04-20

| Metric | Count |
| --- | ---: |
| All matched running workouts | 87 |
| After 2026-04-20 | 48 |
| Simple Work/Open easy fixed-goal | 50 |
| Gate B structured/special | 25 |
| Excluded/no-plan/duplicate/unknown | 12 |
| Paired pause/resume intervals present | 13 |
| Raw pause/resume markers present | 87 |
| Timer-drift evidence present | 7 |

After the program start, the weekday pattern aligns with the user's description: Monday/Tuesday are mostly simple fixed-goal easy runs, Wednesdays are structured interval workouts, and Fridays are tempo-like but not always the exact no-tail three-row shape.

| Day type after 2026-04-20 | Count |
| --- | ---: |
| easy fixed-goal run | 28 |
| structured interval | 8 |
| tempo | 7 |
| unknown/custom other | 5 |

## Shape inventory table

| Start | Day | Type | Shape | Features | Current classification | Consider for |
| --- | --- | --- | --- | --- | --- | --- |
| 2026-03-01T18:38:01Z | Sun | unknown/custom other | no WorkoutKit plan | paired pause/resume | missing evidence | exclusion |
| 2026-03-02T15:26:06Z | Mon | easy fixed-goal run | Work(6 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-03T13:39:37Z | Tue | structured interval | Warmup(2 km) > Work 1(60 s) > Recovery 1(60 s) > Work 2(60 s) > Recovery 2(60 s) > Work 3... | repeat, recovery, open cooldown, unpaired pause marker | repeat-rule blocked | future repeat-block interval subclass |
| 2026-03-04T15:45:46Z | Wed | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-05T14:37:43Z | Thu | tempo | Warmup(2 km) > Work 1(900 s) > Cooldown(Open) | repeat, open cooldown, unpaired pause marker | supported candidate | future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-03-06T13:11:15Z | Fri | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-08T20:35:44Z | Sun | easy fixed-goal run | Work(10 km) > Open | paired pause/resume | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-09T14:16:32Z | Mon | easy fixed-goal run | Work(8 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-10T13:49:08Z | Tue | structured interval | Warmup(2 km) > Recovery 1(60 s) > Work 1(1 km) > Recovery 1(120 s) > Work 2(1 km) > Recov... | repeat, recovery, open cooldown, Open/Extra tail, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future repeat-block interval subclass |
| 2026-03-11T13:40:15Z | Wed | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-12T13:41:02Z | Thu | structured interval | Warmup(2 km) > Work 1(600 s) > Recovery 1(120 s) > Work 2(600 s) > Recovery 2(120 s) > Wo... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass |
| 2026-03-13T15:20:25Z | Fri | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-15T17:57:35Z | Sun | easy fixed-goal run | Work(13 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-16T12:43:24Z | Mon | easy fixed-goal run | Work(9 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-17T12:29:37Z | Tue | structured interval | Warmup(2 km) > Work 1(400 m) > Recovery 1(120 s) > Work 2(400 m) > Recovery 2(120 s) > Wo... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass |
| 2026-03-18T14:50:46Z | Wed | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-19T16:51:00Z | Thu | tempo | Warmup(2 km) > Work 1(1500 s) > Cooldown(Open) | repeat, open cooldown, unpaired pause marker | distance-drift excluded | exclusion, future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-03-21T22:59:01Z | Sat | easy fixed-goal run | Work(6 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-22T18:19:44Z | Sun | easy fixed-goal run | Work(21.10 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-23T21:59:36Z | Mon | easy fixed-goal run | Work(7 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-25T14:47:56Z | Wed | structured interval | Warmup(2 km) > Work 1(600 m) > Recovery 1(150 s) > Work 2(600 m) > Recovery 2(150 s) > Wo... | repeat, recovery, open cooldown, Open/Extra tail, unpaired pause marker | repeat-rule blocked | future repeat-block interval subclass |
| 2026-03-26T14:15:48Z | Thu | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-27T12:59:26Z | Fri | tempo | Warmup(2 km) > Work 1(1 km) > Recovery 1(150 s) > Work 2(1 km) > Recovery 2(150 s) > Work... | repeat, recovery, open cooldown, Open/Extra tail, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-03-29T18:43:39Z | Sun | unknown/custom other | Work(Open) | unpaired pause marker | not currently in Gate B: drift/guard candidate unknown | exclusion |
| 2026-03-29T18:45:45Z | Sun | easy fixed-goal run | Work(12 km) > Open | paired pause/resume | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-30T23:19:25Z | Mon | easy fixed-goal run | Work(6 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-03-31T15:26:28Z | Tue | structured interval | Warmup(2 km) > Work 1(400 m) > Recovery 1(90 s) > Work 2(400 m) > Recovery 2(90 s) > Work... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass |
| 2026-04-05T21:18:47Z | Sun | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-07T14:21:02Z | Tue | easy fixed-goal run | Work(6 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-08T15:08:23Z | Wed | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-10T11:47:35Z | Fri | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-11T11:21:32Z | Sat | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-04-11T12:25:39Z | Sat | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-04-12T16:01:33Z | Sun | structured interval | Work 1(2.50 km) > Work 1(2.50 km) | repeat, Open/Extra tail, unpaired pause marker | tail-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-04-14T22:57:52Z | Tue | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-04-14T23:16:30Z | Tue | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-04-16T11:29:41Z | Thu | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-17T11:33:34Z | Fri | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-18T22:40:59Z | Sat | unknown/custom other | Work(Open) | unpaired pause marker | not currently in Gate B: drift/guard candidate unknown | exclusion |
| 2026-04-20T13:17:53Z | Mon | easy fixed-goal run | Work(8 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-21T09:43:00Z | Tue | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-04-21T10:22:35Z | Tue | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-04-22T11:39:58Z | Wed | structured interval | Warmup(2 km) > Work 1(800 m) > Recovery 1(120 s) > Work 2(800 m) > Recovery 2(120 s) > Wo... | repeat, recovery, open cooldown, Open/Extra tail, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future repeat-block interval subclass |
| 2026-04-23T12:03:24Z | Thu | easy fixed-goal run | Work(6.50 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-24T12:02:30Z | Fri | tempo | Warmup(2 km) > Work 1(4 km) > Cooldown(Open) | repeat, open cooldown, unpaired pause marker | supported candidate | future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-04-26T11:38:35Z | Sun | easy fixed-goal run | Work(14.50 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-27T12:16:21Z | Mon | easy fixed-goal run | Work(8.10 km) > Open | paired pause/resume | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-28T11:44:52Z | Tue | easy fixed-goal run | Work(7.25 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-04-29T11:49:02Z | Wed | structured interval | Warmup(2 km) > Work 1(800 m) > Recovery 1(120 s) > Work 2(800 m) > Recovery 2(120 s) > Wo... | repeat, recovery, open cooldown, Open/Extra tail, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future repeat-block interval subclass |
| 2026-04-30T11:52:29Z | Thu | easy fixed-goal run | Work(6.50 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-01T12:07:44Z | Fri | tempo | Warmup(2 km) > Recovery 1(120 s) > Work 1(5 km) > Cooldown(2 km) | repeat, recovery, fixed cooldown, Open/Extra tail, paired pause/resume | tail-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-03T12:06:10Z | Sun | easy fixed-goal run | Work(15.30 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-04T12:40:42Z | Mon | easy fixed-goal run | Work(8.10 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-05T12:05:06Z | Tue | easy fixed-goal run | Work(7.25 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-06T12:02:13Z | Wed | structured interval | Warmup(2 km) > Work 1(1 km) > Recovery 1(165 s) > Work 2(1 km) > Recovery 2(165 s) > Work... | repeat, recovery, open cooldown, Open/Extra tail, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future repeat-block interval subclass |
| 2026-05-07T11:43:57Z | Thu | easy fixed-goal run | Work(6.45 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-08T11:55:07Z | Fri | tempo | Warmup(2 km) > Work 1(2 km) > Recovery 1(150 s) > Work 2(2 km) > Recovery 2(150 s) > Cool... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-10T11:31:09Z | Sun | unknown/custom other | Work(Open) | unpaired pause marker | not currently in Gate B: drift/guard candidate unknown | exclusion |
| 2026-05-11T12:10:09Z | Mon | easy fixed-goal run | Work(8.10 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-13T11:52:06Z | Wed | structured interval | Warmup(2 km) > Work 1(400 m) > Recovery 1(120 s) > Work 2(400 m) > Recovery 2(120 s) > Wo... | repeat, recovery, open cooldown, Open/Extra tail, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future repeat-block interval subclass |
| 2026-05-14T11:58:59Z | Thu | easy fixed-goal run | Work(6.45 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-14T11:58:59Z | Thu | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-05-15T12:00:12Z | Fri | tempo | Warmup(2 km) > Work 1(1.60 km) > Recovery 1(120 s) > Work 2(1.60 km) > Recovery 2(120 s) ... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-17T11:47:35Z | Sun | easy fixed-goal run | Work(13 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-18T12:00:04Z | Mon | easy fixed-goal run | Work(8.10 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-19T12:14:02Z | Tue | easy fixed-goal run | Work(7.25 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-20T11:43:00Z | Wed | structured interval | Warmup(2 km) > Work 1(1 km) > Recovery 1(150 s) > Work 2(1 km) > Recovery 2(150 s) > Work... | repeat, recovery, open cooldown, Open/Extra tail, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass |
| 2026-05-21T11:51:00Z | Thu | easy fixed-goal run | Work(6.45 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-22T11:55:11Z | Fri | tempo | Warmup(2 km) > Work 1(2.50 km) > Recovery 1(150 s) > Work 2(2.50 km) > Recovery 2(150 s) ... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-24T11:54:20Z | Sun | easy fixed-goal run | Work(12.10 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-25T11:52:27Z | Mon | easy fixed-goal run | Work(7.25 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-26T11:36:21Z | Tue | easy fixed-goal run | Work(6.45 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-27T11:45:47Z | Wed | structured interval | Warmup(2 km) > Work 1(400 m) > Recovery 1(90 s) > Work 2(400 m) > Recovery 2(90 s) > Work... | repeat, recovery, open cooldown, Open/Extra tail, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future repeat-block interval subclass |
| 2026-05-28T11:48:47Z | Thu | easy fixed-goal run | Work(6.45 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-05-29T11:49:28Z | Fri | tempo | Warmup(2 km) > Work 1(3 km) > Cooldown(Open) | repeat, open cooldown, paired pause/resume, timer drift | timer-drift excluded | exclusion, future pause/timer handling rules, future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-05-31T12:19:37Z | Sun | easy fixed-goal run | Work(10 km) > Open | paired pause/resume | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-01T11:51:29Z | Mon | easy fixed-goal run | Work(6.45 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-02T11:51:50Z | Tue | easy fixed-goal run | Work(5.65 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-03T11:45:08Z | Wed | structured interval | Warmup(2 km) > Work 1(1 km) > Recovery 1(150 s) > Work 2(1 km) > Recovery 2(150 s) > Work... | repeat, recovery, open cooldown, unpaired pause marker | close but repeat-rule blocked | future repeat-block interval subclass |
| 2026-06-03T12:25:05Z | Wed | unknown/custom other | duplicate/same-day extra run candidate | unpaired pause marker | missing evidence | exclusion |
| 2026-06-04T11:47:06Z | Thu | easy fixed-goal run | Work(5.65 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-05T11:53:53Z | Fri | tempo | Warmup(2 km) > Work 1(2 km) > Cooldown(2.50 km) | repeat, fixed cooldown, Open/Extra tail, unpaired pause marker | tail-rule blocked | future tempo subclass |
| 2026-06-07T12:21:28Z | Sun | easy fixed-goal run | Work(8.10 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-08T12:21:28Z | Mon | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-09T12:23:42Z | Tue | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |
| 2026-06-10T11:27:51Z | Wed | structured interval | Warmup(2 km) > Work 1(400 m) > Recovery 1(105 s) > Work 2(400 m) > Recovery 2(105 s) > Wo... | repeat, recovery, fixed cooldown, Open/Extra tail, unpaired pause marker | tail-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-06-12T11:49:54Z | Fri | easy fixed-goal run | Work(5 km) > Open | unpaired pause marker | not currently in Gate B: Gate A simple Work/Open | future easy fixed-goal subclass |

## Easy run shapes

There are 50 simple fixed-distance Work/Open workouts. These are not overlooked by Gate B; they are Gate A. They are the main home for easy fixed-goal program days, including the post-2026-04-20 Monday/Tuesday examples such as `Work(8 km) > Open`, `Work(8.10 km) > Open`, `Work(7.25 km) > Open`, `Work(6.45 km) > Open`, and `Work(5 km) > Open`.

These should be considered for a future easy fixed-goal subclass, separate from Gate B structured intervals and separate from the narrow warmup/work/open-cooldown candidate.

## Tempo run shapes

There are 10 tempo-like rows by shape/day context. The narrow scorecard only sees the exact no-tail warmup/work/open-cooldown subset, so it understates Friday tempo coverage.

| Start | Day | Shape | Current classification | Consider for |
| --- | --- | --- | --- | --- |
| 2026-03-05T14:37:43Z | Thu | Warmup(2 km) > Work 1(900 s) > Cooldown(Open) | supported candidate | future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-03-19T16:51:00Z | Thu | Warmup(2 km) > Work 1(1500 s) > Cooldown(Open) | distance-drift excluded | exclusion, future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-03-27T12:59:26Z | Fri | Warmup(2 km) > Work 1(1 km) > Recovery 1(150 s) > Work 2(1 km) > Recovery 2(150 s) > Work... | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-04-24T12:02:30Z | Fri | Warmup(2 km) > Work 1(4 km) > Cooldown(Open) | supported candidate | future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-05-01T12:07:44Z | Fri | Warmup(2 km) > Recovery 1(120 s) > Work 1(5 km) > Cooldown(2 km) | tail-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-08T11:55:07Z | Fri | Warmup(2 km) > Work 1(2 km) > Recovery 1(150 s) > Work 2(2 km) > Recovery 2(150 s) > Cool... | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-15T12:00:12Z | Fri | Warmup(2 km) > Work 1(1.60 km) > Recovery 1(120 s) > Work 2(1.60 km) > Recovery 2(120 s) ... | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-22T11:55:11Z | Fri | Warmup(2 km) > Work 1(2.50 km) > Recovery 1(150 s) > Work 2(2.50 km) > Recovery 2(150 s) ... | close but repeat-rule blocked | future repeat-block interval subclass, future tempo subclass |
| 2026-05-29T11:49:28Z | Fri | Warmup(2 km) > Work 1(3 km) > Cooldown(Open) | timer-drift excluded | exclusion, future pause/timer handling rules, future tempo subclass, narrow no-tail warmup/work/open-cooldown candidate |
| 2026-06-05T11:53:53Z | Fri | Warmup(2 km) > Work 1(2 km) > Cooldown(2.50 km) | tail-rule blocked | future tempo subclass |

## Structured interval shapes

There are 15 structured interval rows by program-day context. Most Wednesday rows after 2026-04-20 are represented, but they stay blocked by repeat rules and, when present, pause/timer evidence.

| Start | Day | Shape | Current classification | Pause/timer |
| --- | --- | --- | --- | --- |
| 2026-03-03T13:39:37Z | Tue | Warmup(2 km) > Work 1(60 s) > Recovery 1(60 s) > Work 2(60 s) > Recovery 2(60 s) > Work 3... | repeat-rule blocked | no |
| 2026-03-10T13:49:08Z | Tue | Warmup(2 km) > Recovery 1(60 s) > Work 1(1 km) > Recovery 1(120 s) > Work 2(1 km) > Recov... | timer-drift excluded | yes |
| 2026-03-12T13:41:02Z | Thu | Warmup(2 km) > Work 1(600 s) > Recovery 1(120 s) > Work 2(600 s) > Recovery 2(120 s) > Wo... | close but repeat-rule blocked | no |
| 2026-03-17T12:29:37Z | Tue | Warmup(2 km) > Work 1(400 m) > Recovery 1(120 s) > Work 2(400 m) > Recovery 2(120 s) > Wo... | close but repeat-rule blocked | no |
| 2026-03-25T14:47:56Z | Wed | Warmup(2 km) > Work 1(600 m) > Recovery 1(150 s) > Work 2(600 m) > Recovery 2(150 s) > Wo... | repeat-rule blocked | no |
| 2026-03-31T15:26:28Z | Tue | Warmup(2 km) > Work 1(400 m) > Recovery 1(90 s) > Work 2(400 m) > Recovery 2(90 s) > Work... | close but repeat-rule blocked | no |
| 2026-04-12T16:01:33Z | Sun | Work 1(2.50 km) > Work 1(2.50 km) | tail-rule blocked | no |
| 2026-04-22T11:39:58Z | Wed | Warmup(2 km) > Work 1(800 m) > Recovery 1(120 s) > Work 2(800 m) > Recovery 2(120 s) > Wo... | timer-drift excluded | yes |
| 2026-04-29T11:49:02Z | Wed | Warmup(2 km) > Work 1(800 m) > Recovery 1(120 s) > Work 2(800 m) > Recovery 2(120 s) > Wo... | timer-drift excluded | yes |
| 2026-05-06T12:02:13Z | Wed | Warmup(2 km) > Work 1(1 km) > Recovery 1(165 s) > Work 2(1 km) > Recovery 2(165 s) > Work... | timer-drift excluded | yes |
| 2026-05-13T11:52:06Z | Wed | Warmup(2 km) > Work 1(400 m) > Recovery 1(120 s) > Work 2(400 m) > Recovery 2(120 s) > Wo... | timer-drift excluded | yes |
| 2026-05-20T11:43:00Z | Wed | Warmup(2 km) > Work 1(1 km) > Recovery 1(150 s) > Work 2(1 km) > Recovery 2(150 s) > Work... | close but repeat-rule blocked | no |
| 2026-05-27T11:45:47Z | Wed | Warmup(2 km) > Work 1(400 m) > Recovery 1(90 s) > Work 2(400 m) > Recovery 2(90 s) > Work... | timer-drift excluded | yes |
| 2026-06-03T11:45:08Z | Wed | Warmup(2 km) > Work 1(1 km) > Recovery 1(150 s) > Work 2(1 km) > Recovery 2(150 s) > Work... | close but repeat-rule blocked | no |
| 2026-06-10T11:27:51Z | Wed | Warmup(2 km) > Work 1(400 m) > Recovery 1(105 s) > Work 2(400 m) > Recovery 2(105 s) > Wo... | tail-rule blocked | no |

## Pause/timer evidence summary

Paired pause/resume evidence is concentrated in hard workouts and is real product evidence, not abnormal data. Seven primary outliers have timer-drift evidence: candidate row duration matches FIT elapsed duration, while FIT timer duration subtracts pause intervals exposed by HealthKit debug event packets. Most workouts also carry one unpaired raw pause marker near workout end; that marker is useful diagnostic context but is not enough on its own to classify a workout as a paused case. Timer-drift rows should stay excluded from clean prototype fixtures but should be preserved as a required future capability.

## Workouts not currently represented in Gate B and why

- 50 simple Work/Open rows are Gate A, not Gate B.
- 12 rows are excluded/no-plan/duplicate/unknown. Nine have no planned steps in the rollup; three have one `Open` planned step and are drift/guard unknowns.
- Duplicate/no-plan rows should remain excluded from prototype scoring unless new physical-device exports prove usable WorkoutKit plan evidence.

## What appears overlooked, if anything

The analysis was overlooking coverage communication, not the raw workouts. Easy fixed-goal custom workouts are numerous but live in Gate A. Friday tempo-like workouts are more varied than the exact narrow candidate shape: some are clean no-tail warmup/work/open-cooldown, some have fixed cooldown plus tail, some include recovery/repeat rows, and some include pause/timer drift.

## Revised evidence collection recommendation

Collect a balanced validation set instead of only more narrow warmup/work/open-cooldown examples:

- Easy fixed-goal: 3-5 Work/Open runs across common goals such as 5 km, 6.45 km, 7.25 km, 8 km, and long-run distances.
- Tempo no-tail: 3-5 `Warmup(2 km) > one fixed Work > Cooldown(Open)` rows without pauses.
- Tempo tail: 2-4 fixed-cooldown plus Open/Extra tail rows.
- Intervals: 5-8 repeat-block workouts covering short reps, long reps, and mixed-distance blocks.
- Pause/timer: 3-5 intentionally preserved paused workouts, including one tempo and multiple interval examples.

For each new example, collect the Raw HealthKit Debug export, parity packet JSON, FIT export availability, and if possible a short note saying whether the run was paused and approximately when.

## Revised Phase 3 strategy recommendation

Do not start Phase 3 yet. If later approved, split Phase 3 into debug-only subclasses instead of one custom-workout prototype:

1. Gate A easy fixed-goal Work/Open remains separate and parked.
2. Narrow no-tail warmup/work/open-cooldown can be the first Gate B discussion candidate.
3. Tempo fixed-cooldown tail needs its own tail rule.
4. Repeat-block intervals need an explicit expanded-plan-to-FIT-lap rule.
5. Pause/timer handling must be a first-class cross-cutting rule, not an exclusion forever.

## Questions answered

1. Are there more tempo-like custom workouts than the narrow scorecard suggests? Yes. The exact narrow shape has 4 rows, but Friday tempo-like coverage includes fixed cooldown tails and repeat/recovery variants.
2. Are easy fixed-goal custom workouts being excluded because they are Gate A or another class? Yes. Most easy fixed-goal runs are Gate A simple Work/Open, not Gate B.
3. Are some workouts outside Gate B due to duplicate/no-plan/summary-only filters? Yes. The excluded group includes duplicate/same-day extras, no-plan rows, and drift/guard unknown rows.
4. Does the April 20/22 program start date explain the shape distribution? Yes. After that date the weekly pattern lines up with easy fixed-goal days, Wednesday intervals, and Friday tempo-like workouts.
5. Should we collect more narrow examples or a balanced set? Collect a balanced set. More narrow examples help, but they would not cover the actual easy, interval, tail, and pause/timer workload.
6. What exact evidence should the user collect next? For each target run, export Raw HealthKit Debug/parity packet, preserve FIT availability, note pause timing, and include at least one clean and one paused example per major shape.

## Explicit no-production-change statement

This audit is docs/debug validation only. It does not change production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, Phase 3 implementation status, or custom workout reconstruction behavior.
