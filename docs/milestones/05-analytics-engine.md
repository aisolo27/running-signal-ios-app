# Milestone 5: Analytics Engine

## Goal
Add conservative rule-based analytics for the native v1.

## Affected Areas
- Analytics engine
- Data quality report
- Race goal readiness
- Latest run review

## Exact Tasks
- Calculate weekly volume and previous-week comparison.
- Calculate intensity distribution.
- Estimate best efforts from workout-level pace and distance.
- Calculate simple fitness trend from pace and heart rate.
- Build sub-20 5K readiness evidence bands.

## Acceptance Criteria
- Analytics exclude duplicates.
- Confidence is shown for each major insight.
- Missing data lowers confidence instead of hiding the limitation.
- Calories are not used as a main decision input.

## Test Commands
- Unit tests for analytics calculations and readiness confidence.
- XcodeBuildMCP build/run.

## Simulator Checks
- Today and Race Goal tabs show analytics from sample data.
- Data tab shows coverage caveats.

## Known Risks
- Best efforts are conservative estimates until detailed route/series windows are implemented.

## Completion Notes
- Completed. Weekly volume, intensity distribution, best efforts, fitness trend, sub-20 readiness, latest-run review, data quality, confidence gating, and Markdown export are implemented and covered by focused tests.
