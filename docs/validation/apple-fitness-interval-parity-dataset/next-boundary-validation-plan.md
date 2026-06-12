# Next Boundary Validation Plan

Status: validation evidence needed before changing June 1 boundary logic or promoting WorkoutKit Reconstructed Intervals into the normal workout detail UI.

Physical-device parity packet status: archived for April 28, May 26, June 1, June 2, June 3, June 4, June 5, and June 12. The latest regenerated archive includes both parity packet JSON and matching Raw HealthKit Debug markdown exports for the active fixture set.

Next export status: regenerated packet-backed fixture exports are archived after the raw HKWorkoutEvent, HKWorkoutActivity boundary source, and activity-boundary candidate enhancements. Raw HealthKit Debug and parity packet JSON now include a diagnostics/export-only activity-boundary candidate beside current reconstructed intervals, and the latest physical-device pass confirms those fields are present on-device. The activity-boundary scorer has been run against the current fixture set; it improves drift cases but does not prove guard/special-fixture safety.

## Current Status

| Date | Status | Current read |
|---|---|---|
| 2026-04-28 | temporary pass | Physical-device force re-enrich recovered rich HealthKit evidence, WorkoutKit plan data, reconstructed Work/Open rows, and boundary diagnostics. Keep as evidence-recovery fixture, not a main boundary-tuning fixture. |
| 2026-05-26 | blocked | Fixed-distance Work ends about 4 seconds early in RunSignal, so Open / Extra becomes about 4 seconds too long. This repeats the same drift direction as June 1. |
| 2026-06-01 | blocked | Fixed-distance Work ends about 5.7 seconds early in RunSignal, so Open / Extra becomes about 5.7 seconds too long. Apple Fitness Open is real post-goal running and should not be hidden or merged into Work. |
| 2026-06-12 | blocked | Fixed-distance Work ends about 4 seconds early in RunSignal, so Open / Extra becomes about 5 seconds too long. This repeats the same drift direction across a 5.00 km goal. |
| 2026-06-02 | temporary pass | Simple fixed-distance Work plus Open tail parity is close; exact packet Work time is 2.4 seconds from Apple Fitness, outside preferred tolerance and inside temporary tolerance. |
| 2026-06-03 | temporary pass | Planned open cooldown handling was fixed; keep as a regression fixture. |
| 2026-06-04 | pass | Simple fixed-distance Work plus Open tail parity holds under current reconstruction; activity-boundary scoring regresses the Work row from preferred pass to temporary pass. |
| 2026-06-05 | temporary pass | Warmup/cooldown boundaries remain close but not preferred. |
| Promotion into normal workout detail UI | blocked | Do not promote until June 1 boundary behavior is resolved or explicitly accepted. |

## Why Promotion Is Still Blocked

The architecture is validated directionally:

- WorkoutKit is the planned structure source.
- HealthKit samples are the measured stats source.
- Apple Fitness screenshots are the visual parity reference.
- Raw HealthKit Debug exports are the RunSignal evidence source.
- HealthKit Segment Markers remain raw/debug-only.

June 1, May 26, and June 12 show the same drift direction across 6.45 km and 5.00 km goals, but this is still not enough evidence to safely change distance-goal boundary behavior. RunSignal's exact crossing boundary is internally consistent, but it does not match Apple Fitness's visible Work boundary. Apple Fitness may be using custom workout step-transition timing, final distance sample timing, private workout-session timing, sensor-end behavior, smoothing, or display rules unavailable through current public WorkoutKit/HealthKit samples.

April 28 is now an evidence-recovery fixture: the physical-device fresh query path retrieves the evidence needed for comparison. It should still stay separate from production boundary tuning because it validates cache invalidation/fresh-query coverage more than it validates a repeated boundary strategy.

Use `fixed-distance-boundary-strategy-research.md`, `analyze_fixed_distance_boundaries.py`, and `score_candidate_boundary_strategies.py` for offline strategy comparison only. No candidate strategy is approved for production yet.

The debug-only candidate scorecards compare strategies side by side against the complete packet-backed fixture set without changing production interval behavior. The `hkworkoutactivity_boundary` scorecard improves May 26, June 1, and June 12, but it regresses June 4 from pass to temporary pass and has three June 3 special-fixture regressions. Its current result does not approve any production boundary strategy. The app now exports the same activity-boundary idea as debug-only packet fields for future evidence review, not as production reconstruction.

The boundary pattern investigation compares packet-visible drift and guard features. It did not find a production-safe public-API separator; current Work/Open error versus Apple Fitness/manual reference separates the groups offline, but cannot be used as runtime logic.

Use `guard-case-collection-plan.md` for the next bounded collection round. The target is 5-10 additional simple fixed-distance Work + real Open / Extra tail examples, prioritizing guard cases that current RunSignal already matches closely.

Use `fit-comparison-research-plan.md` only as a docs/debug cross-check against the existing packet-backed running fixtures. HealthFit FIT exports may help inspect laps, splits, events, totals, or transformed evidence, but they do not approve a production boundary strategy and do not replace Apple Fitness as the visual parity reference.

The completed FIT pilot is summarized in `fit-comparison-summary.md`. Its current read is that FIT session totals match RunSignal totals, while FIT lap rows and inferred Open tails often match Apple Fitness/manual row timing more closely than RunSignal's public distance-sample crossing boundaries. This is useful research evidence, but it still does not identify a production-safe public API separator or approve boundary logic changes.

The FIT lap boundary source investigation justified debug-only export enhancements, not a runtime strategy. Regenerated exports show raw HKWorkoutEvent windows and segment marker candidates, but they still do not provide a clean public boundary source that explains FIT/Apple row endings across drift and guard cases. The newer HKWorkoutActivity inventory is the strongest public-API lead so far, but its first scorecard still leaves production blocked.

## Future Examples Needed

Collect more fixed-distance Work plus real Open tail examples and pass-case boundary diagnostics as new workouts become available. Each future workout should have:

- Apple Fitness screenshots showing the Work and Open rows.
- RunSignal Raw HealthKit Debug export with boundary diagnostics, raw event inventory, and HKWorkoutActivity inventory.
- RunSignal parity packet JSON after force re-enrich, with raw event inventory, HKWorkoutActivity inventory, and planned-step boundary comparison fields.
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
- Additional guard examples where current RunSignal already matches Apple Fitness, with parity packets that include boundary diagnostics.

April 28 evidence and the May 26 through June 12 parity packets have been regenerated and saved with HKWorkoutActivity inventory plus `activityBoundaryCandidateSummary` and `activityBoundaryCandidateIntervals`. Use the complete packet-backed fixture set and current scorecards for research, not for immediate production boundary changes.

After 5-10 new simple Work + Open examples, rerun the scorer. If no public-API separator emerges, keep the current public reconstruction and document Apple Fitness exact-boundary matching as a limitation for this phase.

## Older Evidence Reload Track

April 28 and similar older runs with zero detailed evidence should stay separate from boundary tuning. The April 28 physical-device force re-enrich recovered evidence, but stale cache is not proven because `cacheWasPresent` was false. For any remaining zero-evidence workouts, use the targeted `Force re-enrich this workout` action and save a parity packet before diagnosing old-data availability or query coverage.

Implemented diagnostic-only path: Raw HealthKit Debug can invalidate cached evidence for one selected workout, rerun HealthKit sample/event/WorkoutKit plan queries, and export a parity packet with explicit evidence counts and failure reasons when available. The export now also records raw HKWorkoutEvent inventory, HKWorkoutActivity inventory, activity-boundary candidate rows, and planned-step boundary source comparisons. This does not change production interval behavior.

## Decision Goal

Use the expanded examples to determine whether the June 1, May 26, and June 12 drift is repeatable Apple Fitness boundary behavior.

If the pattern repeats, find a deterministic rule that improves all fixed-distance Work plus real Open tail examples without regressing June 2, June 3, June 4, or June 5.

If the pattern does not repeat, keep the current reconstruction and document June 1 as a limitation rather than changing app logic.

FIT findings can inform this decision only as research evidence. If FIT agrees with RunSignal while Apple Fitness differs, treat that as support for public-API reconstruction and possible Apple Fitness presentation/private logic. If FIT agrees with Apple Fitness while RunSignal differs, investigate RunSignal math or evidence handling. If FIT disagrees with both, classify it as a HealthFit/FIT export transformation or inconclusive unless more evidence proves otherwise.
