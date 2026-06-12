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
- Visible mismatch: Work is 42:44 in Apple Fitness vs 42:38 in RunSignal; Open is 0:07 in Apple Fitness vs 0:13 in RunSignal.
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

The new export provides the missing boundary evidence. RunSignal's current Work boundary is the correct 6.45 km crossing sample end, but Apple Fitness's displayed Work/Open split appears closer to the final distance sample and workout end. Treat this as blocked pending more examples, not as a safe one-workout boundary rule.

Do not change June 1 boundary logic unless the same pattern appears across more fixed-distance Work + tiny Open tails and the rule does not regress June 2, June 3, June 4, or June 5.
