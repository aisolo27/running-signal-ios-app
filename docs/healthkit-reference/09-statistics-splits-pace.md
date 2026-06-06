# 09. Statistics, Splits, and Pace

## Apple source
- https://developer.apple.com/documentation/healthkit/hkstatisticsquery
- https://developer.apple.com/documentation/healthkit/hkstatisticscollectionquery
- https://developer.apple.com/documentation/healthkit/hkquantitysample

## Pace
Pace is usually derived from distance and elapsed or moving time.

Recommended internal representation:
- Pace as seconds per kilometer.
- Display as `m:ss /km`.
- Store whether pace uses elapsed time or moving time.

## Splits
Splits can be calculated from:
- Distance samples
- Route points
- Speed samples
- Workout event/lap data
- App-defined interval definitions

For 1 km splits:
- Use cumulative distance when available.
- Interpolate crossing time when the split boundary falls between samples.
- Keep splits independent from rounded display values.

## Average values
For averages:
- Distance-weighted and time-weighted averages are not always the same.
- Heart rate average is usually time-based over samples.
- Pace average should come from total distance and time, not average of split paces.
- Power average should be time-based over valid power samples.

## Drift
For heart rate drift or pace fade:
- Define the comparison window clearly.
- Use first half vs second half, or matched segments.
- Avoid comparing warmup to work intervals unless intentionally analyzing workout execution.

## Codex rules
- Never average pace strings.
- Never calculate splits from rounded UI values.
- Keep elapsed pace and moving pace separate.
- Store calculation method with derived metrics.
