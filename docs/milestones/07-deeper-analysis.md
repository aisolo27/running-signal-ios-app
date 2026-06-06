# Milestone 7: Deeper Analysis

## Goal
Add richer detail, run type analysis, trends, and mechanics gates where data supports them.

## Affected Areas
- Workout detail
- History filters
- Data coverage panel
- Mechanics fields

## Exact Tasks
- Show HR, cadence, power, and mechanics when available.
- Keep route/series work detail-scoped.
- Add run type filters.
- Gate mechanics by coverage and sample size.

## Acceptance Criteria
- No dense table UI on iPhone.
- Mechanics are visibly limited when coverage is weak.
- Detail screens disclose missing series/route data.

## Test Commands
- Unit tests for data quality gates.
- XcodeBuildMCP build/run.

## Simulator Checks
- Open multiple workout details.
- Confirm labels, notes, and metrics do not overlap.

## Known Risks
- Full route visualization is intentionally deferred.

## Completion Notes
- Completed for v1 depth. Workout detail, run type filters, HR/cadence/power/mechanics fields, and data coverage gates are implemented. Full route visualization remains intentionally deferred.
- Added a first web-app parity readiness pass on the Data tab. The app now explains which surfaces are usable, limited, or blocked across Data Quality, Run Type Analysis, Workout Analyzer, Trends, Mechanics, and Training Plan Brief. Today no longer promotes broad all-time HealthKit average HR or active-energy totals as coach metrics; those stay in Data with a broad-context caveat.
