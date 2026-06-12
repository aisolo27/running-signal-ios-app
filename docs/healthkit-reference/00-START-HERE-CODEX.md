# HealthKit Codex Start Here

Use this folder as the canonical local HealthKit reference pack for the running iOS app.

## Token-Saving Rule

Do not read the whole folder by default. Do not open the archived combined pack at `docs/archive/old-research/COMBINED-HEALTHKIT-CODEX-REFERENCE.md` unless the user explicitly asks for the full combined reference.

Default flow:
1. Read `13-codex-rules-for-healthkit.md`.
2. Read only the task-specific file(s) listed below.
3. Verify uncertain API behavior through `references/apple-healthkit-links.md` and Apple documentation.

## Source Priority

1. Apple Developer Documentation is the source of truth for HealthKit API behavior.
2. This local pack is the working Codex guide for the running app.
3. The Claude Google Drive pack is supplemental reference for broad examples, checklists, and snippets.
4. Existing app code and `docs/bug-log.md` decide how patterns should be applied in this repo.

## Task Router

| Task | Read These Files |
| --- | --- |
| Authorization, entitlements, privacy strings | `01-privacy-permissions-entitlements.md`, `02-health-store-setup.md`, `references/apple-healthkit-links.md` |
| HealthKit service setup | `02-health-store-setup.md`, `03-reading-data-queries.md`, `12-running-app-implementation-patterns.md` |
| Reading workouts | `05-workouts-hkworkout.md`, `03-reading-data-queries.md`, `04-healthkit-data-model-types.md` |
| Workout events, pauses, laps, intervals | `06-workout-events-intervals-laps.md`, `09-statistics-splits-pace.md` |
| Routes, elevation, maps | `07-workout-routes-location-elevation.md`, `03-reading-data-queries.md` |
| Running metrics such as heart rate, power, cadence, stride, vertical oscillation, ground contact time | `08-running-metrics-hr-power-cadence-form.md`, `11-data-quality-source-reconciliation.md` |
| Pace, splits, statistics, unit conversion | `09-statistics-splits-pace.md`, `11-data-quality-source-reconciliation.md` |
| Incremental sync or background delivery | `10-background-delivery-incremental-sync.md`, `03-reading-data-queries.md` |
| Data quality, duplicate handling, source reconciliation | `11-data-quality-source-reconciliation.md`, `12-running-app-implementation-patterns.md` |
| Architecture or import pipeline | `12-running-app-implementation-patterns.md`, `04-healthkit-data-model-types.md` |
| Symbol lookup | `references/api-symbol-index.md`, then `references/apple-healthkit-links.md` |
| Supplemental examples from Claude Drive pack | `references/claude-drive-folder-index.md` |

## Running App Guardrails

- HealthKit v1 is read-only for this app.
- Keep Simulator fallback sample data; real permission and workout availability must be verified on a physical iPhone.
- Preserve raw HealthKit identity: UUID, source, source revision, date range, metadata, device when available.
- Keep raw imported data separate from derived metrics.
- Use explicit missing states; never treat zero as unknown.
- Treat running power, cadence, stride length, vertical oscillation, ground contact time, route, elevation, and heart-rate detail as optional.
- Gate threshold, interval, drift, and form claims on evidence coverage.
- Keep HealthKit access in service/client layers, not SwiftUI views.
