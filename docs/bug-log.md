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
- After deleting and reinstalling a development build, iOS may require `Apple Development: aisolorzano98@hotmail.com` to be trusted again under Settings > General > VPN & Device Management before launch succeeds. Treat the trust gate separately from build/install proof.

## HealthKit And WorkoutKit

- Production bootstrap must never create or persist sample workouts. First launch stays empty until the user connects Apple Health; legacy sample rows are removed from the production cache.
- HealthKit authorization completion does not prove every read type was granted. Use successful queries and data availability for user-facing state.
- Background observer/delivery registration is not the HealthKit readiness authority. A registration failure must not downgrade valid readiness established by cached workouts or successful queries, and user copy should state that foreground refresh remains available.
- Full summary import must not cap history at 250 workouts. Keep expensive detailed evidence bounded separately.
- Start the history-import elapsed budget only after authorization and window setup. An elapsed slice should yield and continue with a fresh budget; Low Power Mode, thermal state, and cancellation remain genuine pause conditions.
- Associated-workout samples are stronger than source/date fallback; persist provenance.
- `HKWorkoutRouteQuery` callbacks may be concurrent. Collect route points through thread-safe state.
- HealthKit distance samples are interval contributions with start/end windows, not cumulative odometer values.
- Credit each distance contribution across its actual sample start/end window. Using the sample start as the cumulative crossing date can turn a sparse legacy five-minute distance bucket into an impossible two- or three-second kilometer.
- Older open runs can contain interleaved kilometer and mile `segment` chains. Normal split timing may use only a contiguous chain that spans the distance evidence, matches the expected kilometer-plus-partial row count, and distance-validates every full row; these events still must not become custom-workout interval rows.
- Normal split boundary time is elapsed, but Apple Fitness can display pause-adjusted active split duration. Select only the pause-event family whose total reconciles to workout elapsed-minus-active time; do not blindly combine explicit and motion pause pairs.
- Before publishing normal splits, sort/deduplicate detailed distance, reject material overlaps, and reconcile its total to the workout summary. Summary-only evidence must not become repeated average-based kilometer rows.
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
- Keep full workout analysis bounded to its recent/on-demand queue. Historical Best Efforts uses a separate resumable distance-only checkpoint so exact records can cover every run without loading routes, charts, mechanics, and plans for the entire history.
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
- Best Efforts reject impossible pace windows and summary-only estimates at compute, merge, cache-restore, and display boundaries. Do not label the section `All-Time Records` until summary import and distance-sample verification are complete for every eligible run.
- Cadence is full steps per minute. Elevation gain filters poor-accuracy points and spikes.
- Apple Fitness may differ slightly because of private smoothing and rounding; do not hard-fit isolated screenshots.
- Priority 5 manual skip and all retained behavior cases live in `docs/project-state/regression-cases.md`.

## SwiftUI

- `PHPhotoLibrary.performChanges` executes its change block on PhotoKit's queue. Do not create that block inside an `@MainActor`-isolated saver or Swift concurrency will trap on `com.apple.PHPhotoLibrary.changes` during a real-device save. Keep preview/render state on the main actor, but make the PhotoKit transaction helper nonisolated and physically test both one-page and multi-page saves.
- Keep launch work cheap: explicit branded launch screen plus a lightweight startup view until bootstrap completes.
- Foreground HealthKit checks must use the persisted last-sync date as well as the in-memory throttle. Background/foreground anchored checks stay quiet; only an explicit user refresh should present the loading banner.
- Scroll-heavy screens need a bottom safe-area inset so the floating tab bar does not cover content.
- Avoid expensive analytics in SwiftUI body paths; compute/cache through the store.
- Visible history-row and detail hydration must not silently reclassify a workout. Row hydration may recover a cached plan name; classification belongs to import, analysis, or explicit review workflows.
- Large history surfaces need search and direct year/type navigation. Do not place the complete run corpus inline in both Runs and All-Time Analytics.
- Keep normal workout review runner-facing. Raw HealthKit events, evidence gates, parity packets, and audit wording belong behind Developer Mode.
- Dark-mode secondary metadata needs explicit readable contrast. Metric labels, supporting captions, and parenthetical secondary units must use shared semantic colors; subordinate hierarchy should come from typography and placement, not near-background gray.
- When interval UI changes, compare prescribed, measured, elapsed, pause, active/timer, distance, pace basis, Raw Debug, and product rows for the same case.
