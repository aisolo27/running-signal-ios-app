# Apple Fitness Interval Parity Dataset

This dataset is for Apple Fitness parity validation before promoting WorkoutKit Reconstructed Intervals into the normal RunSignal workout detail UI.

Apple Fitness screenshots are the visual reference. Screenshots alone are not enough, so each workout folder also includes a manually typed expected Apple Fitness interval table. Type only values that are visible in Apple Fitness. Do not infer hidden data from screenshots.

RunSignal should use WorkoutKit for planned custom workout structure when available, and HealthKit samples for measured stats. HealthKit Segment Markers must remain raw/debug-only and should not be promoted as Apple Fitness interval rows.

Apple documentation defines the WorkoutKit and HealthKit model, but it does not document the exact Apple Fitness interval-row rendering algorithm. See `apple-docs-research.md` for the current documentation-informed evidence contract and tail-labeling policy.

Goal type determines tail interpretation. A final planned `Cooldown` with an `open` WorkoutKit goal can extend to workout end and remain `Cooldown`. A planned `Cooldown` with a fixed distance/time goal completes at that boundary; if the runner keeps going afterward, the continued activity should remain `Open / Extra`. Open / Extra after Cooldown is not automatically wrong, and Cooldown after an open planned cooldown is not automatically wrong.

The purpose is to compare Apple Fitness against RunSignal across multiple real workouts before promoting the interval section into the normal workout detail UI.

## Validation Set

| Date | Workout folder | Intended type | Current status |
|---|---|---|---|
| 2026-04-28 | `2026-04-28-easy-run/` | Easy run evidence recovery | temporary pass |
| 2026-05-26 | `2026-05-26-easy-run/` | Easy run boundary research | blocked |
| 2026-06-01 | `2026-06-01-easy-run/` | Easy run | blocked |
| 2026-06-02 | `2026-06-02-easy-run/` | Easy run | temporary pass |
| 2026-06-03 | `2026-06-03-interval-workout/` | Interval workout | temporary pass |
| 2026-06-04 | `2026-06-04-easy-recovery-run/` | Easy, recovery, or zone 2 run | pass |
| 2026-06-05 | `2026-06-05-tempo-threshold-run/` | Tempo or threshold run | temporary pass |
| 2026-06-12 | `2026-06-12-easy-run/` | Easy run boundary research | blocked |

May 26 and June 12 repeat the same boundary drift direction as June 1: RunSignal's fixed-distance Work boundary ends a few seconds earlier than Apple Fitness, and Open / Extra becomes longer by roughly the same amount.

June 1, May 26, and June 12 remain blocked because the boundary diagnostics are internally consistent but do not match Apple Fitness timing. The Open rows are real post-goal running, so the issue is boundary timing, not Open existence.

April 28 is no longer evidence unavailable. A physical-device force re-enrich on 2026-06-12 recovered rich HealthKit evidence, route data, a WorkoutKit plan, reconstructed Work/Open rows, and boundary diagnostics. Keep April 28 as an evidence-recovery and fresh-query/cache-invalidation validation fixture; do not use it as a main repeated-interval boundary tuning fixture.

Physical-device parity packets are now archived for the full active fixture set: April 28, May 26, June 1, June 2, June 3, June 4, June 5, and June 12. The May 26 through June 12 batch contains parity packet JSON only; no matching raw debug markdown exports were included in that batch.

Debug-only candidate boundary scoring is available in `score_candidate_boundary_strategies.py`. It writes `candidate-boundary-strategy-scorecard.md` and `candidate-boundary-strategy-scorecard.json`; neither file changes app behavior or approves production boundary logic.

`boundary-pattern-investigation.md` compares drift and guard packet features. Its current conclusion is that no public-API observable feature cleanly separates drift cases from guard cases, so production boundary behavior should remain unchanged.

`guard-case-collection-plan.md` defines the next physical-iPhone collection target: 5-10 more simple fixed-distance Work + real Open / Extra tail examples, with priority on guard/pass cases and a clear stopping point before any production boundary experiment.

`fit-comparison-research-plan.md` defines a docs/debug-only HealthFit FIT comparison pilot for the same packet-backed running fixtures. FIT exports can be used as a research cross-check, but not as production truth, a HealthFit dependency, or a replacement for Apple Fitness visual parity.

`fit-comparison-summary.md` archives the completed pilot result. FIT session totals match RunSignal parity packet totals to rounding, while FIT planned-step lap rows and inferred Open tails often align more closely with Apple Fitness/manual row timing. Treat this as research evidence only; it does not approve a boundary strategy or production FIT path.

`fit-lap-boundary-source-investigation.md` checks whether FIT lap boundaries can be traced to public HealthKit/WorkoutKit evidence. Current read: FIT laps map to planned step order, but not cleanly to exported HealthKit segment marker windows or parity packet distance diagnostics; the source remains inconclusive and production behavior stays unchanged.

Raw HealthKit Debug and parity packet exports now include debug-only boundary source fields: raw HKWorkoutEvent inventory rows, event metadata keys when available, segment-marker rendering use/exclusion reasons, planned-step boundary comparisons, nearest raw event and segment marker endings, distance sample boundary references, warnings, and a manual placeholder for later FIT lap end offsets. Regenerated exports for the full active fixture set are archived. These fields are for investigation only and must not be used as production interval truth.

## Next Validation Phase

- Do not tune June 1 from one workout.
- June 1's Open row is real post-goal running and should not be hidden or merged into Work.
- May 26 and June 12 show the same drift direction as June 1, across 6.45 km and 5.00 km goals.
- Use the archived parity packets and candidate scorecard before changing app logic.
- April 28 now proves the physical-device fresh query path can recover the previously missing evidence, but it does not approve a boundary-rule change.
- June 2 remains a simple fixed-distance Work plus Open / Extra guard, but exact packet values put it in the existing temporary-pass band because the Work time is 2.4 seconds from Apple Fitness.
- Current scorecard result: next-sample-end improves drift rows but regresses guard rows; tail-shrink-to-expected-Open uses Apple Fitness/manual expected values as an oracle, so it is not production-safe.
- Current pattern result: packet-visible features such as target distance, tail size, interpolation fraction, overshoot, boundary adjustment, and sample gaps overlap across drift and guard cases.
- Current collection target: add 5-10 simple Work + Open examples, then rerun the scorer. If no public-API separator emerges, keep current public reconstruction and document the limitation.
- Normal interval UI promotion remains blocked until this is resolved or explicitly accepted.

## How To Collect Screenshots

1. Open Apple Fitness.
2. Open the workout for the date.
3. Screenshot the interval or split section fully.
4. Open RunSignal.
5. Open the same workout.
6. Screenshot the normal workout detail.
7. Open Raw HealthKit Debug.
8. Screenshot WorkoutKit Plan Audit, WorkoutKit Reconstructed Intervals, and HealthKit Segment Markers.
9. Save Raw HealthKit Debug markdown into `exports/runsignal-diagnostics/`, including Raw HKWorkoutEvent Inventory, Planned Step Boundary Comparison, Boundary Source Warnings, and the JSON payload.
10. Manually fill `expected_apple_fitness_intervals.md` from Apple Fitness.

## File Roles

- `expected_apple_fitness_intervals.md`: manually typed Apple Fitness interval or split rows.
- `runsignal_observed_intervals.md`: observed RunSignal reconstructed rows from workout detail or Raw HealthKit Debug.
- `comparison.md`: row-by-row Apple Fitness versus RunSignal deltas and tolerance checklist.
- `notes.md`: screenshot filenames, source availability, mismatches, pauses, GPS issues, and extra tail behavior.
- `screenshots/apple-fitness/`: Apple Fitness reference screenshots.
- `screenshots/runsignal-workout-detail/`: RunSignal normal workout detail screenshots.
- `screenshots/runsignal-raw-healthkit-debug/`: RunSignal Raw HealthKit Debug screenshots.
- `exports/runsignal-diagnostics/`: RunSignal diagnostics exports for this workout.
- `exports/healthfit-fit/`: optional HealthFit FIT exports for docs/debug comparison only. Include only running workouts, such as `Outdoor Running` or `Indoor Running`, and exclude `Strength Training`.
- `runsignal-parity-packet-YYYY-MM-DD.json`: physical-device force re-enrich parity packet when available.
- Raw boundary source export fields: debug-only raw HKWorkoutEvent inventory and planned-step comparison data used to compare public event/sample evidence against FIT/Apple boundary timing.
- `interval-parity-fixture.json`: cross-workout visible Apple Fitness and RunSignal observed values used by the lightweight validator.
- `validate_interval_parity.py`: docs-level harness for checking current pass/temporary/blocker status without parsing screenshots.
- `next-boundary-validation-plan.md`: evidence plan for fixed-distance Work plus real Open tail boundary validation.
- `fixed-distance-boundary-strategy-research.md`: research-only comparison of candidate boundary strategies.
- `analyze_fixed_distance_boundaries.py`: offline docs-level harness for comparing candidate boundary timings from fixture values and Raw HealthKit Debug exports.
- `fit-comparison-research-plan.md`: docs-only pilot plan for comparing RunSignal parity packets, Apple Fitness/manual rows, and HealthFit FIT exports.
- `fit-comparison-summary.md`: docs/debug pilot summary of archived HealthFit FIT files, matched/unmatched files, FIT lap evidence, and research-only interpretation.
- `fit-lap-boundary-source-investigation.md`: docs/debug investigation of whether FIT lap boundary timing maps to public HealthKit/WorkoutKit evidence.
- `_future-fixed-distance-open-tail-template/`: reusable drop folder for future fixed-distance Work plus real Open tail examples.

## Do Not Implement Yet

- Do not promote WorkoutKit Reconstructed Intervals into the normal workout detail UI until this validation set is populated and reviewed.
- Do not change distance-goal boundary logic from the June 1 case alone.
- Do not build production FIT import, add a HealthFit dependency, or use FIT as runtime interval truth.
- Do not add coaching, readiness, VDOT, training load, recovery, race prediction, workout recommendations, or auto-categorization.
- This remains v1 Apple Fitness parity validation only.
