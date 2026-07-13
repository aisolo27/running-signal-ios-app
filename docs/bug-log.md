# RunSignal Bug Log

Read only the section relevant to the task. Add entries only for recurring project-specific failures.

## Index

- Build and device proof
- HealthKit and WorkoutKit
- Persistence and performance
- Interval rows and analytics
- SwiftUI

## Build And Device Proof

- Before Xcode build/run/test, call XcodeBuildMCP `session_show_defaults`; use the iOS workspace/scheme and an iPhone destination, not macOS run tools.
- Keep one test-plan reference: `RunningWorkoutAnalysis/RunningWorkoutAnalysis.xctestplan`.
- `Package.swift` requires Swift tools 6.2 for iOS 26 and macOS 14 for local package tests.
- Simulator screenshots are not physical-iPhone proof. Real HealthKit and launch-performance claims need device evidence.
- A device build needs a current `deviceId` in session defaults; Simulator defaults alone are insufficient.

## HealthKit And WorkoutKit

- HealthKit authorization completion does not prove every read type was granted. Use successful queries and data availability for user-facing state.
- Background observer/delivery registration is not the HealthKit readiness authority. A registration failure may update its message, but it must not downgrade valid readiness already established by cached workouts or successful read queries.
- Full summary import must not cap history at 250 workouts. Keep expensive detailed evidence bounded separately.
- Associated-workout samples are stronger than source/date fallback; persist provenance.
- `HKWorkoutRouteQuery` callbacks may be concurrent. Collect route points through thread-safe state.
- HealthKit distance samples are interval contributions with start/end windows, not cumulative odometer values.
- Normalize workout-event types with an enum switch. Raw description strings are backward-compatible debug labels only.
- A terminal zero-duration pause marker at workout end is not paused elapsed time; earlier dangling or cross-row pauses remain blocked.
- Plain open Watch runs can contain activity rows or split laps without a WorkoutKit plan. They remain whole-run-only, not custom interval workouts.
- WorkoutKit one-step blocks may appear as `Block 1: 1x`; `repeatIndex > 1` indicates a real repeated iteration.

## Persistence And Performance

- HealthKit refresh must preserve manual fields such as category and notes.
- Save an anchored-sync cursor only after the corresponding local additions/deletions persist successfully.
- Merge every history window by workout ID; replacing the array can leave only the oldest window visible.
- App activation must stay lightweight and single-flight. Never start unbounded history, detailed hydration, or broad derived recomputation from the foreground hook.
- First render must not wait for background-delivery registration or HealthKit sync.
- Manual category writes and bulk actions must batch persistence and avoid full evidence hydration.
- A single manual category edit must refresh only the Week, Month, Year, and All-Time caches containing that workout. Preserve unrelated historical period caches instead of rebuilding every period.
- Do not decode the complete detailed-evidence table during normal launch. Use compact derived projections and targeted predicates.
- Do not clear working cached evidence until replacement HealthKit queries succeed.
- Apply the automatic-history cap before filtering out already analyzed workouts. Otherwise “newest 20” silently becomes 20 missing rows and drifts into older history.
- Automatic detailed analysis stays sequential and shares one elapsed/Low Power/thermal budget across the queue. Existing detailed evidence that lacks derived analytics must be prepared off the main actor rather than skipped or broadly recomputed.
- Best Efforts refresh must never run its full distance-series scan on the main actor. Build one distance timeline per workout, use indexed sample-gap queries, compute from a Sendable snapshot off actor, and publish only the finished summary.
- A derived-analytics behavior change must bump `DerivedWorkoutAnalysis.currentVersion`. When workout detail hydrates cached evidence, rebuild an outdated analysis row before presenting it; otherwise an old persisted result can survive a correct source-code fix.
- SwiftData schema changes require an explicit migration plan.

## Interval Rows And Analytics

- Product rows come only from the generalized WorkoutKit-plan plus complete contiguous HealthKit-activity resolver. Raw segment markers and legacy plan/sample reconstruction are debug-only.
- Persisted compact interval workouts and currently hydrated interval workouts can contain the same workout ID. Merge by ID before building Analytics collections, and let current loaded evidence replace the persisted projection.
- Missing plans/activities, non-contiguous or excess rows, incomplete repeat context, ambiguous tails, and malformed pauses must fall back to whole-run detail.
- Stopped-early workouts show the completed planned prefix only and never infer unfinished rows or `Open / Extra`.
- Planned open cooldown remains `Cooldown`; extra activity is allowed only after a completed fixed final row.
- Paused rows retain elapsed duration, pause overlap, active/timer duration, and the matching pace basis.
- A manual skip can leave measured Work shorter than its distance goal. Use measured distance and active time; never chase the planned distance into later rows.
- Prescribed distance and measured distance are distinct. Runner-facing planned values must not replace measured validation totals.
- Completion and pace-target status are independent. Shortened rows must keep `Shortened` visible even when their measured pace is on target; aggregate copy must also retain the shortened count. One-sided pace thresholds are not exact ranges.
- Completed fixed-distance primary rows use prescribed distance plus the mapped HealthKit activity-row timer and activity-row heart-rate/cadence/power metrics. Displayed pace and target evaluation must use that same basis. Planned-distance goal windows remain internal evidence and must not silently override the primary row; shortened rows use measured distance and active time.
- Pace is seconds per kilometer; aggregates use total duration over total distance.
- Best Efforts reject impossible pace windows and summary-only estimates as official records.
- Cadence is full steps per minute. Elevation gain filters poor-accuracy points and spikes.
- Apple Fitness may differ slightly because of private smoothing and rounding; do not hard-fit isolated screenshots.
- Priority 5 manual skip and all retained behavior cases live in `docs/project-state/regression-cases.md`.

## SwiftUI

- Keep launch work cheap: explicit branded launch screen plus a lightweight startup view until bootstrap completes.
- Foreground HealthKit checks must use the persisted last-sync date as well as the in-memory throttle. Background/foreground anchored checks stay quiet; only an explicit user refresh should present the loading banner.
- Scroll-heavy screens need a bottom safe-area inset so the floating tab bar does not cover content.
- Avoid expensive analytics in SwiftUI body paths; compute/cache through the store.
- Visible history-row and detail hydration must not silently reclassify a workout. Row hydration may recover a cached plan name; classification belongs to import, analysis, or explicit review workflows.
- Large history surfaces need search and direct year/type navigation. Do not place the complete run corpus inline in both Runs and All-Time Analytics.
- Keep normal workout review runner-facing. Raw HealthKit events, evidence gates, parity packets, and audit wording belong behind Developer Mode.
- Dark-mode secondary metadata needs explicit readable contrast.
- When interval UI changes, compare prescribed, measured, elapsed, pause, active/timer, distance, pace basis, Raw Debug, and product rows for the same case.
