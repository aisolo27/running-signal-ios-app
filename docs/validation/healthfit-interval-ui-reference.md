# HealthFit Interval UI Reference

Status: local UI reference only. This recording is not runtime data, not an app input, and not evidence for changing RunSignal's HealthKit/WorkoutKit source rules.

## Local Media

- Original file: `/Users/adrielsolorzano/Downloads/HealthFit.MP4`
- Local archive copy: `docs/validation/_local-reference-media/healthfit-interval-ui/HealthFit.MP4`
- Git status: the `_local-reference-media` folder is intentionally ignored because the video is large.

## File Metadata

- Duration: 420.4719 seconds
- Size: 497,280,550 bytes
- Dimensions: 1320 x 2868
- Codecs: HEVC video, MPEG-4 AAC audio
- Video bit rate: 9447 kbit/s

## UI Reference Notes

- HealthFit uses one focused interval or split chart at a time, with a selected row/value shown prominently above the plot.
- Interval rows are labeled by index and role, such as `W` and `R`, directly under the bars.
- Work/recovery repeats are grouped as repeat sets, such as `1 of 10`, `2 of 10`, with Work and Recovery rows underneath.
- The useful RunSignal takeaway is interaction and organization: a touch-first scrub chart, core work-repeat totals, and grouped official rows.
- RunSignal should not copy HealthFit as a data source. Product rows remain official resolved HealthKit activity-boundary rows plus WorkoutKit planned structure when the evidence gate passes.
