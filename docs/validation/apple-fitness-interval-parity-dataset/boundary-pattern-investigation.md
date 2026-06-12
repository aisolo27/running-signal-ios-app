# Boundary Pattern Investigation

Generated: 2026-06-12

This report is debug-only research. It compares archived parity packet features, fixture rows, and the candidate boundary scorecard. It does not change production interval reconstruction, fixed-distance boundary logic, or normal workout UI.

## Executive Summary

May 26, June 1, and June 12 benefit from later boundary strategies because their current RunSignal Work rows end 3.5-5.7 seconds earlier than Apple Fitness, and their Open / Extra rows are longer by roughly the same amount. Moving the Work boundary later naturally reduces that visible split error.

June 2 and June 4 regress under the same later-boundary strategies because their current Work/Open split is already close to Apple Fitness. Moving these guard rows later pushes Work distance/time and Open distance/time away from the visible reference.

No public-API observable feature in the archived packets cleanly separates the drift cases from the guard cases. The strongest apparent separator is the Apple Fitness/manual delta itself: drift cases have larger current Work/Open time errors, while guard cases are already close. That is useful for offline validation, but it is not a production runtime rule because the app does not have Apple Fitness/manual expected rows.

Conclusion: no production-safe boundary rule is recommended. Production boundary behavior should remain unchanged.

## Drift Vs Guard Comparison

| Date | Group | Target | Current Work delta | Current Open delta | Open / Extra | Interp fraction | Overshoot | Adjustment | Prev gap | Next gap | Tail final sample | Public separator? |
|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
| 2026-05-26 | Drift | 6.45 km | -3.5 s | +4.2 s | 97.2 m / 0:45 | 0.427 | 4.2 m | +1.5 s | 3.2 m / 2.6 s | 10.8 m / 2.6 s | 42:46 | No |
| 2026-06-01 | Drift | 6.45 km | -5.7 s | +5.7 s | 12.3 m / 0:13 | 0.904 | 0.6 m | +0.2 s | 6.0 m / 2.6 s | 7.7 m / 2.6 s | 42:43 | No |
| 2026-06-12 | Drift | 5.00 km | -4.5 s | +5.2 s | 43.2 m / 0:22 | 0.764 | 1.6 m | +0.6 s | 5.1 m / 2.6 s | 8.8 m / 2.6 s | 32:14 | No |
| 2026-06-02 | Guard | 5.65 km | -2.4 s | +2.1 s | 57.0 m / 0:30 | 0.661 | 1.9 m | +0.9 s | 3.6 m / 2.6 s | 9.1 m / 2.6 s | 36:36 | No |
| 2026-06-04 | Guard | 5.65 km | -1.7 s | +1.2 s | 42.0 m / 0:22 | 0.503 | 2.9 m | +1.3 s | 3.0 m / 2.6 s | 10.9 m / 2.6 s | 36:50 | No |

Reading: `Prev gap` and `Next gap` are the distance/time gaps from the target cumulative distance to the previous or next distance sample end. These values overlap between drift and guard groups.

## Per-Workout Public-API Features

| Date | Pair | Previous sample distance / offset | Crossing sample distance / offset | Next sample distance / offset | Tail remaining | Meaningful Open? |
|---|---|---|---|---|---:|---|
| 2026-04-28 | Work -> Open | 7241.7-7248.9 m / 46:04-46:06 | 7248.9-7256.3 m / 46:06-46:09 | 7256.3-7263.2 m / 46:09-46:11 | 48.3 m / 23.0 s | Yes |
| 2026-05-26 | Work -> Open | 6441.0-6446.8 m / 42:02-42:05 | 6446.8-6454.2 m / 42:05-42:07 | 6454.2-6460.8 m / 42:07-42:10 | 97.2 m / 45.2 s | Yes |
| 2026-06-01 | Work -> Open | 6438.0-6444.0 m / 42:33-42:36 | 6444.0-6450.6 m / 42:36-42:38 | 6450.6-6457.7 m / 42:38-42:41 | 12.3 m / 12.7 s | Yes |
| 2026-06-12 | Work -> Open | 4987.6-4994.9 m / 31:53-31:56 | 4994.9-5001.6 m / 31:56-31:59 | 5001.6-5008.8 m / 31:59-32:01 | 43.2 m / 22.2 s | Yes |
| 2026-06-02 | Work -> Open | 5639.8-5646.4 m / 36:07-36:10 | 5646.4-5651.9 m / 36:10-36:13 | 5651.9-5659.1 m / 36:13-36:15 | 57.0 m / 30.1 s | Yes |
| 2026-06-04 | Work -> Open | 5648.2-5654.3 m / 36:29-36:32 | 5654.3-5660.2 m / 36:32-36:34 | 5660.2-5668.1 m / 36:34-36:37 | 42.0 m / 22.2 s | Yes |
| 2026-06-05 | Cooldown -> Open | 6506.5-6513.9 m / 35:33-35:36 | 6513.9-6521.8 m / 35:36-35:38 | 6521.8-6529.8 m / 35:38-35:41 | 440.0 m / 157.8 s | Yes |

All Work/Open and Cooldown/Open tails listed here are meaningful by visible duration or distance. The Open / Extra row should not be hidden as a tiny artifact.

## Candidate Strategy Behavior

The scorecard result explains the tension:

- `current_baseline`: preserves the current guard behavior but leaves drift cases blocked.
- `interpolated_crossing`: improves some drift Work rows but regresses guard rows and Open tails.
- `previous_sample_end`: generally moves earlier and regresses both drift and guard behavior.
- `next_sample_end`: improves all drift Work/Open rows, but regresses June 2 and June 4 guard rows.
- `final_distance_sample_anchored`: helps part of June 1, but badly regresses guard rows and does not generalize to May 26 or June 12.
- `tail_shrink_to_expected_open`: improves rows only because it uses Apple Fitness/manual expected Open as an oracle. It is not production-safe.
- `pause_adjusted`: not scoreable because current packets do not include pause intervals or pause-adjusted boundary diagnostics.

## Features That Might Separate Drift From Guard Cases

The only clear separator is reference-dependent:

- Current Work/Open time error versus Apple Fitness/manual reference is larger in drift cases: Work is early by 3.5-5.7 seconds and Open is long by 4.2-5.7 seconds.
- Guard cases are already closer: Work is early by 1.7-2.4 seconds and Open is long by 1.2-2.1 seconds.

This is not a production rule because RunSignal does not have Apple Fitness/manual interval rows at runtime.

## Features That Do Not Separate Them

The following packet-visible features do not cleanly divide drift from guard cases:

- Target distance: drift includes 6.45 km and 5.00 km; guards are 5.65 km, so distance alone is not enough.
- Open / Extra size: drift ranges from 12.3 m / 12.7 s to 97.2 m / 45.2 s, while guards are 42.0-57.0 m / 22.2-30.1 s.
- Crossing interpolation fraction: drift values 0.427, 0.764, and 0.904 overlap guard values 0.503 and 0.661.
- Overshoot meters: drift values 0.6-4.2 m overlap guard values 1.9-2.9 m.
- Boundary adjustment seconds: drift values 0.2-1.5 s overlap guard values 0.9-1.3 s.
- Previous sample gap: drift values 3.2-6.0 m / 2.6 s overlap guard values 3.0-3.6 m / 2.6 s.
- Next sample gap: drift values 7.7-10.8 m / 2.6 s overlap guard values 9.1-10.9 m / 2.6 s.
- Final distance sample timing: useful diagnostically, but it overfits some short-tail cases and regresses guards.

## Special Fixtures

June 3 is a planned open cooldown regression fixture with repeated intervals. It should not be treated as a simple Work + Open drift case. Its key validation purpose is preserving the planned open cooldown label and checking repeated Work/Recovery rows.

June 5 includes Warmup, Work, fixed-distance Cooldown, and a meaningful Open / Extra tail. It is useful as a special guard against broad strategy changes because cooldown and tail behavior can regress even when a candidate looks better on simple Work/Open drift cases.

## April 28 Evidence Recovery

April 28 is included as an evidence-recovery and single-tail summary. It confirms that physical-device fresh query can recover WorkoutKit plan data, HealthKit samples, reconstructed rows, route data, and boundary diagnostics. It is excluded from production approval scoring and should not drive repeated fixed-distance boundary tuning.

## Conclusion

No public-API observable rule is currently strong enough to recommend for production. The available packet features explain why later boundaries help the drift cases only when compared to Apple Fitness/manual references, but they do not provide a runtime-safe separator that preserves June 2 and June 4.

More evidence is needed before boundary behavior changes. The next evidence should focus on pass/guard Work + Open examples with boundary diagnostics and additional drift examples across target distances and tail sizes.

Production boundary behavior should remain unchanged.
