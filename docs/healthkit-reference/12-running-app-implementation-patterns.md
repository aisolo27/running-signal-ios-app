# 12. Running App Implementation Patterns

## Apple source
- https://developer.apple.com/documentation/healthkit
- https://developer.apple.com/documentation/healthkit/hkworkout
- https://developer.apple.com/documentation/healthkit/hkworkoutroute
- https://developer.apple.com/documentation/healthkit/hkquantitysample

## Recommended architecture

### HealthKitClient
Responsible for:
- Authorization
- Query execution
- Anchored sync
- Observer registration
- Raw HealthKit object mapping

### WorkoutRepository
Responsible for:
- Local persistence
- Dedupe
- Updating imported workouts
- Querying app models

### MetricsEngine
Responsible for:
- Pace
- Splits
- Heart rate summaries
- Power summaries
- Drift
- Running dynamics summaries
- Data quality flags

### Presentation layer
Responsible for:
- UI formatting
- Missing-data messaging
- Charts
- Human-readable labels

## Import pipeline
1. Fetch workouts.
2. Upsert workout shell by HealthKit UUID.
3. Fetch related samples by type and timeframe.
4. Fetch route if available.
5. Store raw samples.
6. Run metrics engine.
7. Save derived metrics with calculation version.
8. Display workout summary.

## Calculation versioning
Every derived metric should include:
- Calculation version
- Inputs used
- Date calculated
- Confidence or quality flags where relevant

This allows the app to improve calculations later without losing raw data.

## Codex rules
- Build raw import first, derived calculations second.
- Make calculations repeatable.
- Keep UI separate from HealthKit.
- Add tests for pace, split, and interval calculations.
