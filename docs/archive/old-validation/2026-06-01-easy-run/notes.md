# Notes

## Screenshot Filenames Added

- Apple Fitness: `IMG_6968.PNG`, `IMG_6969.PNG`
- RunSignal workout detail: `text-56E8A332BF32-1.txt`
- RunSignal diagnostics export: `exports/runsignal-diagnostics/text-56E8A332BF32-1.txt`
- New RunSignal diagnostics export with boundary diagnostics: `exports/runsignal-diagnostics/new text-795E821D968D-1.txt`
- RunSignal Raw HealthKit Debug:

## Validation Notes

- Apple Fitness showed intervals or only splits: custom interval rows, Work and Open.
- WorkoutKit plan available in RunSignal: yes, `Monday easy 6.45km`.
- Reconstructed intervals appeared: yes.
- Raw HealthKit Segment Markers appeared: yes; debug source says they are not used as Apple Fitness interval rows.
- Human context: this was a custom Apple Watch workout named `Monday easy 6.45km`; the planned Work goal was 6.45 km.
- Human context: after the 6.45 km Work goal completed, the runner kept running briefly before stopping the watch.
- Apple Fitness Open is real post-goal running. It should not be hidden, merged into Work, or treated as a reconstruction artifact.
- Open / Extra after a fixed-distance Work goal is not automatically wrong.
- Visible mismatch: Work is 42:44 in Apple Fitness vs 42:38 in RunSignal; Open is 0:07 in Apple Fitness vs 0:13 in RunSignal.
- Apple Fitness total summary: 42:50 workout time, 6.46 km, 6:38/km average pace.
- Pause, GPS weirdness, treadmill/manual edit, or extra tail behavior: Open tail exists in both; RunSignal tail is about 6 seconds longer.

## Placement Note

The RunSignal export was originally misplaced in `screenshots/runsignal-workout-detail/`. It has been copied to `exports/runsignal-diagnostics/text-56E8A332BF32-1.txt` for consistency. The original remains in place because earlier notes and screenshots referenced it.

## Boundary Investigation

- Planned Work goal: 6.45 km.
- Apple Fitness Work/Open: 42:44 + 0:07.
- RunSignal Work/Open Extra: 42:38.318 + 12.654 s.
- Boundary strategy: crossing sample end.
- Boundary adjustment: +0.248 s.
- Overshoot: 0.635 m.
- Distance sample count: 997.
- Previous distance sample before boundary: 42:33-42:36, 6438.0 m to 6444.0 m cumulative.
- Crossing distance sample: 42:36-42:38, 6444.0 m to 6450.6 m cumulative.
- Next distance sample after boundary: 42:38-42:41, 6450.6 m to 6457.7 m cumulative.
- Final distance sample timing: 42:43.464, 6463.0 m cumulative.
- Last HR sample: 42:46.725.
- Last power/cadence sample: 42:48.609.

The new export provides the missing boundary evidence. RunSignal's current Work boundary is the exact HealthKit cumulative-distance crossing sample end for 6.45 km and is internally consistent, but Apple Fitness's displayed Work/Open split appears closer to the final distance sample and workout end. The parity issue is Work boundary timing, not the existence of Open.

Apple Fitness may be using custom workout step-transition timing, final distance sample timing, private workout-session timing, sensor-end behavior, smoothing, or display rules that are unavailable through the current public WorkoutKit/HealthKit evidence. Treat this as blocked pending more examples, not as a safe one-workout boundary rule.

Do not change June 1 boundary logic unless the same pattern appears across more fixed-distance Work + real Open tails and the rule does not regress June 2, June 3, June 4, or June 5.

## Distance-goal Boundary Drift Research

Status: blocked. June 1 needs more fixed-distance Work + real Open tail examples before RunSignal should add or change a deterministic boundary rule.

The exact diagnostics are:

- 6.45 km Work boundary: 42:38.318.
- Boundary strategy: crossing sample end.
- Boundary adjustment: +0.248 s from interpolated crossing.
- Boundary overshoot: 0.635 m.
- Final distance sample: 42:43.464, 6463.0 m cumulative.
- Workout end: 42:50.972.

RunSignal's interpolation/crossing logic appears internally valid because the 6.45 km target falls inside the crossing distance sample and the chosen crossing sample end overshoots by less than 1 m. This does not look like a simple crossing bug.

Apple Fitness may be using final distance sample timing, private workout-session timing, sensor-end behavior, smoothing, or display rules that are not exposed in the public WorkoutKit/HealthKit evidence. Its visible Work/Open timing aligns more closely with the final distance sample and workout end than with the exact 6.45 km crossing.

Do not tune from this single workout. A June 1-specific final-sample or tail-shrink rule could regress June 2 and June 4, which are the simple fixed-distance Work + Open tail guard workouts.

Future examples needed:

- Fixed-distance Work step.
- Visible Apple Fitness Work row.
- Visible Apple Fitness Open row.
- RunSignal Raw HealthKit Debug export with boundary diagnostics.
- Preferably multiple distances, such as 5K Work, 6.45K Work, 2K Work, or 400 m / 800 m reps with an Open tail.

## Physical-Device Parity Packet

- Packet: `exports/runsignal-diagnostics/runsignal-parity-packet-2026-06-01.json`
- Raw debug markdown export: not included in this batch.
- Packet source: freshQuery.
- Force re-enrich returned workout: true.
- Diagnostics warnings: none.
- Event count split: top-level evidence events 13, force-result segment/lap events 12. This matches the known diagnostics counting split documented for April 28.
- Classification: drift case, fixed-distance Work plus real Open / Extra tail.
- Current packet rows: Work 1 6450.635445654858 m / 2558.318410396576 s; Open / Extra 12.345910287927836 m / 12.6536306142807 s.
