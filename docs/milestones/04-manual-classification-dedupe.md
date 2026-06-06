# Milestone 4: Manual Classification And Dedupe

## Goal
Allow local run labels and notes while scaffolding duplicate detection.

## Affected Areas
- Run type model
- Workout detail edit surface
- Duplicate detector
- Analytics filters

## Exact Tasks
- Add run types: easy, recovery, long run, tempo, threshold, interval, race, progression, hills, unknown.
- Show inferred vs manual labels.
- Save manual labels and notes locally.
- Mark likely duplicates by start time, duration, and distance.

## Acceptance Criteria
- Manual labels override inferred labels.
- Duplicate candidates are excluded from totals.
- Data tab shows duplicate count.

## Test Commands
- Unit tests for manual precedence and duplicate detection.
- XcodeBuildMCP build/run.

## Simulator Checks
- Change a workout label.
- Confirm UI shows Manual pill.

## Known Risks
- Dedupe is conservative until future import sources exist.

## Completion Notes
- Completed. Manual labels/notes, inferred/manual display, conservative duplicate detection, duplicate exclusion from analytics, and tests are implemented. A note-save path was exercised in Simulator.
- Added a web run-type review bridge. Reviewed categories can be imported from JSON/CSV, reconciled against HealthKit workouts by local date, optional start time, distance, and duration, then applied only for confident non-conflicting matches. Weak matches, conflicts, web-only runs, and iPhone-only runs stay visible for review in the Data tab.
