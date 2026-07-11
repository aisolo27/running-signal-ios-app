# RunSignal Project Status

Last updated: 2026-07-11

This is the only current project-status and next-work authority. Historical plans, proof notes, and old test counts do not override it.

## Product Contract

RunSignal is a native iPhone SwiftUI app for evidence-grounded analysis of completed running workouts. V1 is HealthKit-only and read-only.

- HealthKit completed running workouts are runtime truth.
- WorkoutKit `HKWorkout.workoutPlan`, when available, supplies planned custom-workout structure.
- HealthKit workout summaries, samples, routes, events, and `HKWorkoutActivity` rows supply completed metrics and public boundary evidence.
- FIT, HealthFit, screenshots, and manual rows are offline validation evidence only, never app inputs.
- Segment/lap/marker events remain raw debug evidence and are not Apple Fitness interval rows.
- Whole-run analytics remain available when custom interval evidence is unavailable.
- Backend sync, AI coaching, file import/export, and HealthKit writes remain out of scope.

## Project Shape

- Open and build `RunningWorkoutAnalysis.xcworkspace` with the `RunningWorkoutAnalysis` scheme.
- The app target is a thin shell; implementation lives in `RunningWorkoutAnalysisPackage/Sources/RunningWorkoutAnalysisFeature/`.
- Package tests: `swift test --package-path RunningWorkoutAnalysisPackage`.
- `Package.swift` stays compatible with iOS 26 and macOS 14.

## Official Custom-Workout Resolver

One generalized evidence gate controls product interval rows. It is not a workout-shape whitelist.

Rows can publish when ordered expanded WorkoutKit planned rows map to complete contiguous HealthKit activity rows, or to a completed planned prefix for a stopped-early workout. Repeat context must be complete enough to prove the mapping. Pause windows must be paired, reliable, and contained within one row. Any post-plan tail must be deterministic.

- Planned open cooldown remains `Cooldown` through workout end.
- `Open / Extra` is inferred only after every mapped fixed planned row is complete and continued activity remains above the tail threshold.
- Stopped-early workouts show only the completed prefix and never invent unfinished rows or a tail.
- Paused rows display active/timer duration; elapsed duration and pause overlap remain available for detail and diagnostics.
- Shortened or manually skipped distance work uses measured HealthKit distance and pause-adjusted active time. It never chases the unfinished planned distance.
- Runner-facing fixed-distance rows may show prescribed distance, while measured HealthKit values remain the validation and aggregate truth.
- Completion status and target-pace status are separate.
- Official row analytics consume only resolved product rows. `DerivedAnalyticsEngine.intervalCandidates` stays debug-only.

## Supported Behavior

The generalized gate covers:

- Normal custom Work/Recovery/Cooldown sequences and repeat blocks.
- Clean and pause-aware repeats.
- Planned open cooldowns.
- Fixed cooldown followed by deterministic `Open / Extra`.
- Recovery-containing rows when every planned row maps cleanly.
- Single-row and multi-row stopped-early completed prefixes.
- Dynamic distance/time goals and typed pace-range target evaluation.
- Unstructured or no-plan runs as `Other`, with whole-run analytics and normal splits but no custom interval analysis.

Representative real-device cases and their exact regression tests are cataloged in `docs/project-state/regression-cases.md`.

## Blocked And Fallback Behavior

Custom interval rows must remain unavailable when evidence contains:

- Missing WorkoutKit plan.
- Missing, incomplete, non-contiguous, or excess HealthKit activity rows.
- Incomplete or non-prefix repeat context.
- Duplicate, dangling, unpaired, ambiguous, or cross-row pauses.
- Ambiguous Warmup/Recovery/Cooldown or post-plan tail mapping.
- Material boundary drift or stale summary-only evidence.

These conditions produce whole-run detail plus a clear unavailable/review reason. Older plan/sample reconstruction and raw event markers must never silently replace product rows.

## Current Product State

- Run taxonomy is exactly Easy, Long, Interval, Threshold, Race, and Other. Tempo is folded into Threshold.
- Manual category edits persist and update Analytics without hydrating all detailed evidence.
- A single manual category edit refreshes only the affected Week, Month, Year, and All-Time caches; unrelated historical period caches remain untouched.
- Analytics supports Week, Month, Year, and All-Time views, purpose mix, charts, Best Efforts, interval prescriptions, target evaluation, interval library grouping, and like-for-like trends.
- Analytics merges persisted and currently loaded official interval workouts by workout ID, with current loaded evidence winning, before building the interval library.
- Structured workouts show their WorkoutKit plan and official interval rows when the resolver passes.
- Work rows support hit/too-fast/too-slow pace-target evaluation, visibly distinct shortened-work status, and pause-aware measured math. A shortened target row can say `On Target · Shortened` so pace result never hides completion state.
- Completed fixed-distance rows show prescribed distance with HealthKit activity-row time, heart rate, cadence, and power. Their displayed pace and target evaluation use that same activity-row timer plus prescribed-distance basis; shortened rows continue to use measured distance and active time.
- HealthKit history import, anchored foreground sync, deletion handling, background observer registration, resumable summary backfill, compact derived caches, and Low Power/thermal budgets are implemented.
- New HealthKit runs automatically enter a sequential analysis queue. Automatic scope is the newest 20 non-duplicate workouts within the previous 30 days; older runs remain available on demand. The queue uses one shared elapsed/Low Power/thermal budget and prepares derived analytics off the main actor.
- Workout detail now leads with the full date, WorkoutKit title when available, time range, city-level cached location, concise metrics, conditions, map, charts, splits, and runner-facing `Work`/`Recovery`/`Open` cards. Raw HealthKit audit terminology and parity tools are behind Developer Mode.
- The Runs tab now shows weekday-inclusive dates, persisted WorkoutKit names with indoor/outdoor context, and visible run-type tags. Historical cached rows hydrate only the small plan-name field as they become visible instead of attaching full evidence blobs.
- Workout charts now use one visible metric selector, persistent tap/drag selection, linear pace/heart-rate lines, and ten-second median bars for power and cadence. Whole-run interval shading is limited to Work blocks.
- Structured interval detail now leads with one runner-facing results card, clearly separates prescribed work distance/pace from measured Apple Health distance, defaults comparison charts to Work reps, offers an optional Work + Recovery scope, and keeps paired repeat detail without the duplicate resolved-row summary.
- HealthKit workout weather metadata is stored per run and displayed as temperature and humidity. Temperature follows the system by default with explicit Fahrenheit and Celsius settings. City resolution uses a representative route point and stores only the resulting city context locally.
- Run-type suggestions are deterministic and explainable: explicit plan titles and Work/Recovery structure lead, then a 42-day personal duration/distance baseline and heart-rate context. Weak evidence falls back to Other without erasing an existing stronger stored category.
- Strong plan-based run types now surface as auto-classified as soon as cached plan metadata becomes visible, while manual and imported reviewed labels remain authoritative. Visible Runs and Analytics rows lazily refresh only their cached plan metadata instead of hydrating the full history.
- Analytics now includes a year-grouped jump menu for Week and Month plus direct Year selection, runner-facing detailed-data wording, no meaningless All-Time comparison panel, and persistent tap/drag distance inspection. Power and cadence use adaptive median bars and keep a selected bar highlighted instead of showing a floating point.
- Interval comparison scopes are labeled `Work Reps` and `Full Repeats` with plain-language explanations. Exact WorkoutKit pace thresholds show faster/slower deltas but never receive invented On Target/Fast/Slow range status.
- Normalized terminal zero-duration pause events now receive the same end-marker handling as legacy raw HealthKit pause strings, so a valid one-Work-plus-Open run is not blocked by representation format.
- Background-delivery registration failures report their own message without downgrading valid cached/query-based HealthKit readiness.
- Normal bootstrap avoids hydrating the full detailed-evidence table.

## Current Next Work

- Observe limited-history authorization, observer delivery, anchored deletions, backlog continuation, interruption/resume, Low Power Mode, thermal behavior, and battery impact on a physical iPhone.
- Use the next fresh HealthKit workout on the physical iPhone to verify automatic completion, responsive tab/scroll interaction during active analysis, temperature/humidity availability, city caching, thermal behavior, and battery impact.
- Profile the local training-period summary cache with a large real HealthKit history.
- Re-export the June 30 clean repeat/fixed-cooldown/`Open / Extra` case from a fresh current build and confirm visible/export status agreement.
- Re-verify the July 9 recording cases on a physical iPhone: loaded HealthKit readiness at launch, repeated run-detail-to-Analytics navigation, category-edit responsiveness with the real history, Priority 5 shortened-row copy, and activity-row pace/heart-rate/power/cadence parity against Apple Fitness.
- Visually verify the July 11 Runs-list and interval redesign on a booted Simulator, then repeat the interaction check on the physical iPhone with real HealthKit evidence.
- Continue tightening explicit fallback reasons without expanding into guessed interval rows.

## Known Limitations

- Some historical workouts are summary-only because detailed HealthKit series may be unavailable.
- WorkoutKit plan data is optional and can be unavailable or fail to load.
- Simulator sample data cannot prove HealthKit permissions, real workout availability, background delivery, thermal behavior, battery impact, or physical launch performance.
- Apple Fitness can use private smoothing, rounding, and presentation rules not exposed by public APIs.
- Weather appears only when the completed HealthKit workout includes weather metadata. City display requires a usable route and successful Apple reverse geocoding before the city is cached.

## Latest Verification

On 2026-07-10, all 293 package tests passed for the current implementation. Simulator build/install/launch passed without build warnings on iPhone 17. In sample-data mode, the revised workout header rendered, the detail screen accepted repeated scrolling, no permanent automatic-analysis state appeared for sample workouts, the temperature setting was visibly labeled, and Developer Mode hid then revealed raw audit tools. The same current build then built, installed, and launched on `AIS17PM` running iOS 26.5.2. iPhone Mirroring visibly confirmed the July 10 Easy 6 km workout now renders runner-facing `Work` and `Open` cards with HealthKit activity values, and a direct switch to Analytics responded immediately. A previously analyzed workout does not prove fresh automatic-queue duration, weather/location availability, thermal behavior, or battery impact; those require the next new physical workout.

On 2026-07-11, all 298 package tests passed after the Runs-list, chart, and interval-presentation redesign. The feature branch then built, installed, and launched on the iPhone 17 Simulator. Sample-data smoke verified Runs-list weekday dates and category tags, completed-list scrolling, workout-detail navigation, and full-date rendering without visible overlap. Sample data has no detailed WorkoutKit evidence, so it did not prove the redesigned interval-results screen or real HealthKit behavior. The same branch then built, installed, and launched successfully on `AIS17PM` running iOS 26.5.2. Physical-device UI, chart interaction, and real HealthKit values remain for user testing.

On 2026-07-11, all 301 package tests passed after the recording-feedback follow-up. The iPhone 17 Simulator build/install/launch passed without build warnings. Sample-data smoke verified the clearer Analytics header and detailed-data card, Week jump menu grouped under literal year `2026`, All-Time without the comparison panel, and the persistent-distance-chart prompt with no visible overlap. Simulator sample data cannot prove cached real-workout title/classification hydration, exact-threshold interval deltas, physical chart feel, HealthKit behavior, battery, or thermal impact; those remain physical-iPhone checks.

The same recording-feedback build then built, installed, and launched successfully on `AIS17PM` with no device-build warnings. This proves the physical-device install/run path only; the revised classification, Analytics, chart interaction, exact-threshold interval copy, battery, thermal behavior, and fresh HealthKit processing still require user-visible testing on the phone.
