# Next Boundary Validation Plan

Status: validation evidence needed before changing June 1 boundary logic or promoting WorkoutKit Reconstructed Intervals into the normal workout detail UI.

## Current Status

| Date | Status | Current read |
|---|---|---|
| 2026-04-28 | blocked | Apple Fitness shows fixed-distance Work plus Open, but RunSignal evidence is unavailable: no WorkoutKit audit, no reconstructed intervals, no boundary diagnostics, and zero sample evidence counts. |
| 2026-05-26 | blocked | Fixed-distance Work ends about 4 seconds early in RunSignal, so Open / Extra becomes about 4 seconds too long. This repeats the same drift direction as June 1. |
| 2026-06-01 | blocked | Fixed-distance Work ends about 5.7 seconds early in RunSignal, so Open / Extra becomes about 5.7 seconds too long. Apple Fitness Open is real post-goal running and should not be hidden or merged into Work. |
| 2026-06-02 | pass | Simple fixed-distance Work plus Open tail parity holds. |
| 2026-06-03 | temporary pass | Planned open cooldown handling was fixed; keep as a regression fixture. |
| 2026-06-04 | pass | Simple fixed-distance Work plus Open tail parity holds. |
| 2026-06-05 | temporary pass | Warmup/cooldown boundaries remain close but not preferred. |
| Promotion into normal workout detail UI | blocked | Do not promote until June 1 boundary behavior is resolved or explicitly accepted. |

## Why Promotion Is Still Blocked

The architecture is validated directionally:

- WorkoutKit is the planned structure source.
- HealthKit samples are the measured stats source.
- Apple Fitness screenshots are the visual parity reference.
- Raw HealthKit Debug exports are the RunSignal evidence source.
- HealthKit Segment Markers remain raw/debug-only.

June 1 and May 26 show the same drift direction, but this is still not enough evidence to safely change distance-goal boundary behavior. RunSignal's exact crossing boundary is internally consistent, but it does not match Apple Fitness's visible Work boundary. Apple Fitness may be using custom workout step-transition timing, final distance sample timing, private workout-session timing, sensor-end behavior, smoothing, or display rules unavailable through current public WorkoutKit/HealthKit samples.

April 28 must be investigated separately because Apple Fitness shows intervals, but RunSignal cannot currently produce the evidence needed for a parity comparison.

Use `fixed-distance-boundary-strategy-research.md` and `analyze_fixed_distance_boundaries.py` for offline strategy comparison only. No candidate strategy is approved for production yet.

## Future Examples Needed

Collect fixed-distance Work plus real Open tail examples. Each future workout should have:

- Apple Fitness screenshots showing the Work and Open rows.
- RunSignal Raw HealthKit Debug export with boundary diagnostics.
- A planned Work goal that is distance-based.
- The Work goal completed.
- Brief continued running before stopping the workout.
- Apple Fitness showing both Work and Open.

Ideal examples:

- 5K Work plus short Open tail.
- 6K or 6.5K Work plus short Open tail.
- 2K Work plus short Open tail.
- 400 m or 800 m repeated Work steps with possible Open tail.
- Any workout where Apple Fitness and RunSignal differ by more than 2 seconds.

Also collect or regenerate evidence for April 28 if possible: a RunSignal export with WorkoutKit plan audit, reconstructed intervals, distance/time evidence, and boundary diagnostics.

## Decision Goal

Use the next examples to determine whether the June 1 and May 26 drift is repeatable Apple Fitness boundary behavior.

If the pattern repeats, find a deterministic rule that improves all fixed-distance Work plus real Open tail examples without regressing June 2, June 3, June 4, or June 5.

If the pattern does not repeat, keep the current reconstruction and document June 1 as a limitation rather than changing app logic.
