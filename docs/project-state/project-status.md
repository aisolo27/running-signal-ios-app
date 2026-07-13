# RunSignal Project Status

Last updated: 2026-07-13

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
- Runs now places searchable, year-grouped history directly after Most Recent, supports direct year and run-type filtering, and uses the stored category as a useful historical fallback title when no WorkoutKit name exists. Best Efforts lives in Analytics instead of blocking access to history.
- Workout charts now keep Pace, Heart Rate, and Cadence primary, place Power under More Metrics, use visible line presentation with adaptive median smoothing for cadence/power, and label selection clearing plainly. Whole-run interval shading is limited to Work blocks.
- Structured interval detail now leads with one runner-facing results card, clearly separates prescribed work distance/pace from measured Apple Health distance, defaults comparison charts to Work reps, offers an optional Work + Recovery scope, and keeps paired repeat detail without the duplicate resolved-row summary.
- HealthKit workout weather metadata is stored per run and displayed as temperature and humidity. Temperature follows the system by default with explicit Fahrenheit and Celsius settings. City resolution uses a representative route point and now presents the resolved city in a prominent full-width row instead of relying on a caching caption.
- Run-type suggestions are deterministic and explainable: explicit plan titles and Work/Recovery structure lead, then a 42-day personal duration/distance baseline and heart-rate context. Weak evidence falls back to Other without erasing an existing stronger stored category.
- Strong plan-based run types now surface as auto-classified as soon as cached plan metadata becomes visible, while manual and imported reviewed labels remain authoritative. Visible Runs and Analytics rows lazily refresh only their cached plan metadata instead of hydrating the full history.
- Analytics now includes a year-grouped jump menu for Week and Month plus direct Year selection, runner-facing detailed-data wording, no meaningless All-Time comparison panel, and persistent tap/drag distance inspection.
- One-kilometer splits no longer stop at ten. RunSignal publishes every completed kilometer from the HealthKit distance series and a clearly labeled Final partial row when at least 10 meters and 5 seconds remain; fallback splits follow the same no-cap and partial-row rules.
- Persisted split analyses now carry a new calculation version, and workout-detail hydration rebuilds an outdated cached row from its stored raw evidence before presenting it. This closes the case where a correct no-cap algorithm still displayed the previous ten-split cache on the phone.
- Heart-rate zones support Automatic HRR, percentage of maximum HR, and manual limits. Automatic HRR uses the latest Apple Health resting HR plus a six-month completed-running maximum and supports a confirmed maximum override. Manual mode uses tappable Zone 1–5 rows with Apple-style lower/upper editors and automatically contiguous adjacent limits. Settings explicitly distinguishes an active profile from proposed unsaved zones, labels current versus earlier history, and offers `Apply Current Profile to All Workouts` only when multiple profiles exist. The warned destructive action can deliberately replace history with the current profile. Workout heart-rate detail shows zone-colored samples and estimated pause-aware time in Zones 1–5.
- Foreground HealthKit checks use a persisted 15-minute throttle and run without the blocking update banner. Explicit pull-to-refresh and `Load HealthKit Runs` remain available and retain visible progress.
- All-years Run History sections can collapse independently, selected year/type filters expose one Clear Filters action, Power is hidden from runner-facing charts, and interval review uses a plainly explained Work Rep Comparison across Pace, HR, and Cadence while Repeat Details retains every Work/Recovery row.
- Year and All-Time Analytics now keep their charts and purpose mix compact, then link to a separate run/category manager instead of embedding hundreds of rows. Previous-period comparison uses one compact card, and zero-detailed-data periods explicitly say they contain summary metrics only.
- HealthKit import and sync recompute Best Efforts from an immutable snapshot off the main actor. The Best Effort engine reuses one distance timeline per workout and uses indexed gap queries instead of repeatedly filtering the full sample series for every candidate window.
- Settings now has one navigation title, one compact HealthKit/import card, a visible Display section, collapsed data diagnostics, and a separate Advanced section.
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
- Re-verify the July 12 recording cases on the physical iPhone: the 11.03 km and 27.21 km cached runs rebuild to every full split plus a truthful final partial, Hialeah appears as the location value, manual zone edits/save/history behavior match the Simulator path, foreground app switching stays quiet and responsive, and the six-month HRR inputs/time-in-zone detail agree with real HealthKit samples.
- Visually verify the July 11 Runs-list and interval redesign on a booted Simulator, then repeat the interaction check on the physical iPhone with real HealthKit evidence.
- Continue tightening explicit fallback reasons without expanding into guessed interval rows.

## Known Limitations

- Some historical workouts are summary-only because detailed HealthKit series may be unavailable.
- WorkoutKit plan data is optional and can be unavailable or fail to load.
- Simulator sample data cannot prove HealthKit permissions, real workout availability, background delivery, thermal behavior, battery impact, or physical launch performance.
- Apple Fitness can use private smoothing, rounding, and presentation rules not exposed by public APIs.
- Weather appears only when the completed HealthKit workout includes weather metadata. City display requires a usable route and successful Apple reverse geocoding before the city is cached.
- Apple Watch manual heart-rate-zone settings are not assumed readable through public HealthKit. RunSignal manual profiles must be entered in the app, and historical workouts predating the first RunSignal profile are explicitly treated as backfilled by that first profile.

## Latest Verification

On 2026-07-10, all 293 package tests passed for the current implementation. Simulator build/install/launch passed without build warnings on iPhone 17. In sample-data mode, the revised workout header rendered, the detail screen accepted repeated scrolling, no permanent automatic-analysis state appeared for sample workouts, the temperature setting was visibly labeled, and Developer Mode hid then revealed raw audit tools. The same current build then built, installed, and launched on `AIS17PM` running iOS 26.5.2. iPhone Mirroring visibly confirmed the July 10 Easy 6 km workout now renders runner-facing `Work` and `Open` cards with HealthKit activity values, and a direct switch to Analytics responded immediately. A previously analyzed workout does not prove fresh automatic-queue duration, weather/location availability, thermal behavior, or battery impact; those require the next new physical workout.

On 2026-07-11, all 298 package tests passed after the Runs-list, chart, and interval-presentation redesign. The feature branch then built, installed, and launched on the iPhone 17 Simulator. Sample-data smoke verified Runs-list weekday dates and category tags, completed-list scrolling, workout-detail navigation, and full-date rendering without visible overlap. Sample data has no detailed WorkoutKit evidence, so it did not prove the redesigned interval-results screen or real HealthKit behavior. The same branch then built, installed, and launched successfully on `AIS17PM` running iOS 26.5.2. Physical-device UI, chart interaction, and real HealthKit values remain for user testing.

On 2026-07-11, all 301 package tests passed after the recording-feedback follow-up. The iPhone 17 Simulator build/install/launch passed without build warnings. Sample-data smoke verified the clearer Analytics header and detailed-data card, Week jump menu grouped under literal year `2026`, All-Time without the comparison panel, and the persistent-distance-chart prompt with no visible overlap. Simulator sample data cannot prove cached real-workout title/classification hydration, exact-threshold interval deltas, physical chart feel, HealthKit behavior, battery, or thermal impact; those remain physical-iPhone checks.

The same recording-feedback build then built, installed, and launched successfully on `AIS17PM` with no device-build warnings. This proves the physical-device install/run path only; the revised classification, Analytics, chart interaction, exact-threshold interval copy, battery, thermal behavior, and fresh HealthKit processing still require user-visible testing on the phone.

On 2026-07-11, all 302 package tests passed after the HealthKit-refresh performance and navigation reorganization. The current feature branch built, installed, and launched cleanly on the iPhone 17 Simulator; visual smoke covered searchable Runs history, category-based fallback titles, the dedicated Best Efforts screen, compact Year run access, consolidated Settings, and inline workout-detail navigation titles. The same working tree built, installed, and launched on `AIS17PM`. With 644 real runs loaded, direct year selection reached 2020 in 0.67 seconds, the 2020/type empty state rendered correctly, and a 20-action history scroll stress pass completed in 2.5 seconds. The original Settings -> Load HealthKit Runs -> immediate Runs-tab switch completed in 1.58 seconds while showing a nonblocking update banner; detail scrolling and Analytics navigation remained responsive during the refresh. The resumed import completed with 647 imported and Up to date. A follow-up Instruments capture could not attach because `xctrace` twice timed out waiting for the connected device, so responsiveness is physically interaction-proven but the post-fix call tree is not captured.

On 2026-07-12, all 308 package tests passed after removing the split cap, adding final partial rows, revising cadence/power presentation, clarifying city display, and adding effective-dated heart-rate zones. The feature branch built, installed, and launched on the iPhone 17 Simulator. Sample-data smoke verified the Runs screen, `Heart Rate Zones · Automatic HRR` in Settings, the six-month lookback with 48 bpm resting and 194 bpm maximum inputs, and successful zone-profile saving. The same working tree then built, installed, and launched successfully on `AIS17PM` running iOS 26.5.2. Real HealthKit split, chart, city, and time-in-zone values plus physical-device interaction remain for user testing.

On 2026-07-12, all 313 package tests passed after the follow-up recording fixes. Regression coverage now reproduces and rebuilds an outdated ten-split cache, verifies contiguous Apple-style manual-zone limit edits, preserves the current profile during an explicit history reset, throttles foreground sync across relaunches, and keeps quiet sync from presenting blocking loading state. The iPhone 17 Simulator built, installed, and launched successfully. Visible smoke verified a 12.40 km workout renders KM 11, KM 12, and a 0.40 km Final row; all-years sections collapse/expand; Clear Filters works; a Zone 2 upper-limit change automatically moves Zone 3's lower limit; manual drafts survive editor navigation; Save Changes is not intercepted by the floating tab bar; and reset history presents the destructive historical-impact warning. Simulator sample data cannot render the real structured interval comparison or prove real HealthKit cache values. The same working tree then built and installed on `AIS17PM` running iOS 26.5.2 and launched successfully as process 3713. The real 11.03 km/27.21 km cached rebuild, physical chart/interval interaction, quiet app switching, city, and time-in-zone values remain for Adriel's phone test.

On 2026-07-13, the release gate was repeated before promoting this feature branch to `main`: all 313 package tests passed, the iPhone 17 Simulator built/installed/launched and visibly rendered the Runs screen with sample data, and the same build installed and launched on `AIS17PM` as process 5378. This proves the package, Simulator launch/UI smoke, and physical-device install/run channels separately. Real HealthKit values and the remaining physical interaction checks above still require Adriel's phone testing.

On 2026-07-13, all 315 package tests passed after clarifying heart-rate-zone profile state and history actions. The iPhone 17 Simulator built, installed, and launched successfully. Visible interaction smoke verified the active Manual state has no preview wording or meaningless one-profile history action; changing to Automatic HRR presents proposed-zone copy and Save Changes; saving labels Automatic HRR as active and Manual as earlier workouts; and `Apply Current Profile to All Workouts` stays above the floating tab bar and opens the destructive historical-results warning. The same build installed and launched successfully on `AIS17PM` running iOS 26.5.2 as process 5432. This proves physical-device build/install/run only; the revised copy and real HealthKit values still require user-visible phone interaction.
