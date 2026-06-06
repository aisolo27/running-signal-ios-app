# HealthKit Codex Reference Pack

Generated: 2026-06-06

Purpose: give Codex a structured, implementation-focused reference for iOS apps that read Apple HealthKit and Apple Watch workout data.

This pack is not a replacement for Apple's official documentation. It is a Codex-friendly companion that summarizes patterns, organizes common HealthKit concepts, and links back to Apple documentation for verification.

Primary Apple source:
- https://developer.apple.com/documentation/healthkit/about-the-healthkit-framework

Recommended usage:
1. Start with `00-START-HERE-CODEX.md`.
2. Read `13-codex-rules-for-healthkit.md` before changing HealthKit logic.
3. Read only the task-specific numbered file(s), not the full folder.
4. Use Apple documentation links in `references/apple-healthkit-links.md` as source-of-truth when making HealthKit decisions.
5. Use `references/claude-drive-folder-index.md` only as supplemental reference for the Claude Google Drive pack.

Directory map:
- `00-healthkit-overview.md` explains what HealthKit is responsible for.
- `00-START-HERE-CODEX.md` is the token-saving router for future Codex sessions.
- `01-privacy-permissions-entitlements.md` covers authorization, entitlements, and privacy.
- `02-health-store-setup.md` covers `HKHealthStore`.
- `03-reading-data-queries.md` covers sample queries, anchored queries, statistics queries, and observers.
- `04-healthkit-data-model-types.md` covers object, sample, quantity, category, workout, source, and metadata concepts.
- `05-workouts-hkworkout.md` covers workout-level records.
- `06-workout-events-intervals-laps.md` covers intervals, pauses, resumes, laps, and event interpretation.
- `07-workout-routes-location-elevation.md` covers route points, elevation, and map data.
- `08-running-metrics-hr-power-cadence-form.md` covers running metrics relevant to Apple Watch.
- `09-statistics-splits-pace.md` covers pace, splits, summaries, and derived metrics.
- `10-background-delivery-incremental-sync.md` covers ongoing sync and background delivery.
- `11-data-quality-source-reconciliation.md` covers source quality, duplicate handling, and conflict resolution.
- `12-running-app-implementation-patterns.md` gives app-specific architecture.
- `13-codex-rules-for-healthkit.md` gives strict rules for Codex.
- `references/claude-drive-folder-index.md` maps the supplemental Claude Google Drive pack.
