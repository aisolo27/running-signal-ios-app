# Next Work

Last updated: 2026-06-12

## Priority 1

- Review the debug-only candidate boundary scorecards and decide whether more evidence is needed before any boundary logic experiment.
- Use the boundary pattern investigation as the current evidence summary: no public-API separator is production-safe yet.
- Collect 5-10 additional simple fixed-distance Work + Open tail examples, prioritizing guard/pass cases similar to June 2 and June 4.
- Keep WorkoutKit reconstructed intervals gated from normal UI; the current scorecards do not approve a production boundary strategy.
- Use the completed docs-only HealthFit FIT comparison summary and lap-boundary source investigation as research evidence only. FIT lap rows are useful for investigation, but they do not approve production boundary logic or a FIT import path.
- Review `hkworkoutactivity-boundary-scorecard.md`: `HKWorkoutActivity` improves the three drift cases and June 2, but June 4 regresses from preferred pass to temporary pass and June 3 has three special-fixture regressions.
- Latest physical-device Raw HealthKit Debug markdown and parity packet JSON exports are archived for the active fixtures with `activityBoundaryCandidateSummary` and `activityBoundaryCandidateIntervals` beside current `reconstructedIntervals`; this is diagnostics/export-only and not production UI.
- Collect more guard/pass examples before any production experiment. Any activity-boundary prototype must remain debug-only, use `HKWorkoutActivity` only when activity count/order reconciles with WorkoutKit planned steps, infer final Open / Extra tails from workout end when needed, and fall back to current reconstruction for missing or incompatible activity evidence.

## Priority 2

- Collect pass-case boundary diagnostics before changing distance-goal boundary behavior.
- Collect more Work + Open examples that vary target distance, tail distance, and tail duration.
- Stop this phase after 5-10 new examples and rerun the scorer; if no separator emerges, keep current public reconstruction and document the limitation.
- Preserve the current production interval reconstruction behavior until packet-backed activity-boundary scoring/prototyping proves pass/regression safety across more guard examples.
- Archive completed date-specific validation evidence to `docs/archive/old-validation/` after it is no longer active.

## Priority 3

- Run physical-device validation only when the task needs real HealthKit proof.
- Capture and save additional parity packets only for new validation workouts or re-checks; also save Raw HealthKit Debug markdown so raw HKWorkoutEvent rows, HKWorkoutActivity inventory rows, and planned-step comparison tables are preserved.
- Current active fixture exports have been recaptured with activity-boundary candidate summary/rows; future captures should focus on new validation workouts or re-checks.

## Blocked

- Apple Fitness interval labeling and boundary behavior remain partly uncertain.
- April 28 is no longer blocked by unavailable evidence; it remains separate from production boundary tuning as an evidence-recovery fixture.
- Normal workout detail interval UI promotion is blocked until boundary evidence is resolved or accepted.
- Candidate boundary scoring is debug-only; no strategy is approved for production.

## Not In Scope

- Coaching expansion.
- VDOT.
- Training load expansion.
- Recovery scoring.
- Race prediction.
- FIT import, FIT backup, HealthFit export, or file-based workout ingestion.
- HealthFit as a production dependency or FIT as runtime truth.
