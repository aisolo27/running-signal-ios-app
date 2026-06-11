# Milestone 9 Step 6: Physical iPhone Verification

Status: Completed
Generated: June 6, 2026

## Current Device State

- Target device: `AIS17PM`
- Expected OS from prior evidence: iOS `26.5.1`
- Current XcodeBuildMCP device state on June 6, 2026: `connected`
- Current build/install state on June 6, 2026: package tests passed, Simulator smoke launch passed, and XcodeBuildMCP `build_run_device` installed and launched `com.adrielsolorzano.runninganalysis` on `AIS17PM`.
- Result: physical install/launch, HealthKit authorization, diagnostics, audit export, and representative-run verification were captured from the on-phone Data tab flow.

Simulator launches remain useful for UI checks only. They are not counted as HealthKit data proof for this step.

## Existing Physical Evidence Snapshot

The Step 1 contract already used a prior physical-iPhone HealthKit evidence snapshot:

- Historical range to preserve: `Jan 3, 2019` through `Jun 5, 2026`
- Loaded local records: `620`
- Duplicate candidates: `3`
- Audited non-duplicate workouts: `617`
- Heart-rate sample rows: `278`
- Speed/distance sample rows: `282`
- Running dynamics rows: `140`
- Route points loaded: `398,503`
- Series samples loaded: `770,069`
- Detailed enrichment currently reaches roughly `Oct 17, 2022`; older runs can remain summary-only unless their own audit row proves detailed samples.

This aggregate snapshot proves real HealthKit data exists and that the current evidence contract should stay confidence-gated. It does not yet satisfy the representative-run review below because the local workspace does not include row-level notes for each required run archetype.

## Representative Run Checklist

| Required run | Current proof status | Fields exposed | Direct samples | Fallback queries | Route | Events/laps/segments | Mechanics | Overmatching risk |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| Easy outdoor run | Verified: `Jun 4, 2026 Easy` | Summary plus associated series | HR `443`, speed `860`, distance `860`, active energy `860` | No fallback required for listed samples | `2,217` points | `10` events; labels unavailable | Power `859`, cadence/steps `1,724`, stride `411`, vertical oscillation `412`, ground contact `411` | Run type is suggested; review source/date risk before stronger purpose claims |
| Treadmill run | Verified, limited: `Feb 2, 2026 Easy` | Summary and workout events | HR `0`, speed `0`, distance `0`, active energy `0` | Detailed analyzer would need fallback or unavailable-state handling | Missing | `13` events; labels unavailable | None exposed | Run type is suggested; indoor row needs review before stronger purpose claims |
| Interval or structured workout | Verified: `Jun 5, 2026 Tempo` | Summary plus associated series | HR `461`, speed `892`, distance `892`, active energy `892` | No fallback required for listed samples | `2,296` points | `12` events; labels unavailable | Power `889`, cadence/steps `1,784`, stride `424`, vertical oscillation `426`, ground contact `424` | Lower; source is Apple Watch and associated samples are present, but event labels are unavailable |
| Long run | Verified: `May 31, 2026 Easy` | Summary plus associated series | HR `826`, speed `1,603`, distance `1,603`, active energy `1,608` | No fallback required for listed samples | `4,138` points | `18` events; labels unavailable | Power `1,604`, cadence/steps `3,212`, stride `753`, vertical oscillation `756`, ground contact `750` | Run type is suggested; review before stronger long-run purpose claims |
| Race or time trial | Verified, limited: `May 10, 2026 Race` | Summary and workout events | HR `0`, speed `0`, distance `0`, active energy `0` | Detailed analyzer would need fallback or unavailable-state handling | Route object without points | `9` events; labels unavailable | None exposed | Limited because direct series are absent |
| Older historical run | Verified, limited: `Jan 3, 2019 Unknown` | Summary and workout events | HR `0`, speed `0`, distance `0`, active energy `0` | Detailed analyzer would need fallback or unavailable-state handling | Route object without points | `10` events; labels unavailable | None exposed | Limited because direct series are absent and type is unknown |

## Surface Decisions From Current Evidence

| Surface | Decision | Reason |
| --- | --- | --- |
| Latest Run | Limited, with recent detailed analysis allowed | Recent outdoor and structured rows expose HR, speed/distance, route, events, and mechanics samples; summary-only rows still need caveats. |
| Workout Analyzer | Limited, with gated detail cards allowed | Cached detailed evidence and derived analytics exist for recent enriched rows, but treadmill, race, and older historical representatives remain summary/event-only. |
| Trends | Limited | Duplicate-excluded summary trends are allowed; purpose, intensity, and mechanics trends remain gated by reviewed labels and field coverage. |
| Mechanics | Blocked for strong claims | Running dynamics rows exist in aggregate, but representative availability and source consistency are not proven. |
| Run Type Analysis | Limited | The trust model separates suggested, imported, user-reviewed, needs-review, and conflict states; structured-workout labels still need row-level evidence or user review. |
| Training Plan Brief | Limited | It can summarize existing summary history with caveats; stronger workout-type prescriptions remain gated. |
| Data Quality / Audit | Ready | Diagnostics show HealthKit authorized, `620` workouts loaded, `617` included, `3` duplicates, `0` pending evidence, and audit exports expose missing/summary-only states. |

## Required Live Verification Procedure

When `AIS17PM` is connected:

1. Install and run the app on the physical iPhone. Completed on June 6, 2026 via XcodeBuildMCP `build_run_device`.
2. Authorize read-only HealthKit access. Completed; diagnostics exported `Authorization: Authorized`.
3. Load HealthKit workouts, then run controlled audit enrichment. Completed; diagnostics exported `620` workouts, `617` included, `3` duplicates, and `0` evidence pending.
4. Export HealthKit audit/diagnostics from the Data tab. Completed.
5. Choose one representative non-duplicate workout for each checklist row above. Completed by `Share physical verification`.
6. Record field availability, direct associated samples, fallback-query notes, route point count, event/lap/segment availability, mechanics coverage, and any source/date fallback overmatching risk. Completed in the representative checklist above.
7. Update this file and `09-healthkit-evidence-contract.md`; only then mark Step 6 completed. Completed.

## Known Issues During Verification

- Duplicate diagnostics wording can be confusing. Do not read the audited-workout count as the duplicate-excluded count unless the row explicitly says so.

## Resolved Issues During Verification

- Diagnostics authorization/message staleness was fixed on June 6, 2026. Diagnostics now export the last HealthKit action status from a single `HealthKitActionStatus` value, so later non-HealthKit UI messages do not overwrite the HealthKit authorization/message pair.
