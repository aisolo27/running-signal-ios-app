# Candidate Boundary Strategy Scorecard

Generated: 2026-06-12

This is a docs/debug-only research scorecard. It reads the Apple Fitness parity fixture and archived RunSignal parity packets. It does not change production interval reconstruction, boundary logic, or normal workout UI.

## Summary By Strategy

| Strategy                       | Scoreable | Not scoreable | Pass | Temp | Fail | Drift improved | Guard regressed | Production assessment                                                                       |
| ------------------------------ | --------- | ------------- | ---- | ---- | ---- | -------------- | --------------- | ------------------------------------------------------------------------------------------- |
| current_baseline               | 24        | 0             | 8    | 10   | 6    | 0              | 0               | not production-safe from this scorecard                                                     |
| hkworkoutactivity_boundary     | 24        | 0             | 15   | 9    | 0    | 6              | 1               | debug-only lead; not production-safe until more guard data and fallback rules are validated |
| interpolated_crossing          | 20        | 4             | 6    | 4    | 10   | 3              | 3               | not production-safe from this scorecard                                                     |
| previous_sample_end            | 20        | 4             | 3    | 5    | 12   | 0              | 4               | not production-safe from this scorecard                                                     |
| next_sample_end                | 20        | 4             | 3    | 11   | 6    | 6              | 3               | not production-safe from this scorecard                                                     |
| final_distance_sample_anchored | 14        | 10            | 1    | 1    | 12   | 2              | 4               | not production-safe from this scorecard                                                     |
| tail_shrink_to_expected_open   | 14        | 10            | 10   | 4    | 0    | 6              | 0               | not production-safe because it uses Apple Fitness/manual expected Open as an oracle         |
| pause_adjusted                 | 0         | 24            | 0    | 0    | 0    | 0              | 0               | not scoreable from current packet data                                                      |

No candidate is approved for production from this scorecard. The scorer is intentionally conservative: a strategy must improve drift cases without regressing guard fixtures, and Apple Fitness/manual-oracle strategies are not production-safe.

## Drift Cases

May 26, June 1, and June 12 are the fixed-distance Work plus real Open / Extra drift cases. April 28 is excluded from approval scoring.

| Date       | Row  | Strategy                       | Pred distance | Pred time | Dist delta | Time delta | Dist change | Time change | Status         | Effect    |
| ---------- | ---- | ------------------------------ | ------------- | --------- | ---------- | ---------- | ----------- | ----------- | -------------- | --------- |
| 2026-05-26 | Work | current_baseline               | 6454.2m       | 42:07     | +4.2m      | -3.5s      | +0.0m       | +0.0s       | fail           | preserves |
| 2026-05-26 | Work | final_distance_sample_anchored | 6551.5m       | 42:46     | +101.5m    | +35.1s     | +97.2m      | +38.6s      | fail           | regresses |
| 2026-05-26 | Work | hkworkoutactivity_boundary     | 6457.4m       | 42:11     | +7.4m      | +0.3s      | +3.2m       | +3.8s       | temporary pass | improves  |
| 2026-05-26 | Work | interpolated_crossing          | 6450.0m       | 42:06     | +0.0m      | -5.0s      | -4.2m       | -1.5s       | fail           | improves  |
| 2026-05-26 | Work | next_sample_end                | 6460.8m       | 42:10     | +10.8m     | -1.0s      | +6.6m       | +2.6s       | temporary pass | improves  |
| 2026-05-26 | Work | previous_sample_end            | 6446.8m       | 42:05     | -3.2m      | -6.1s      | -7.4m       | -2.6s       | fail           | regresses |
| 2026-05-26 | Work | tail_shrink_to_expected_open   | 6457.5m       | 42:12     | +7.5m      | +0.7s      | +3.2m       | +4.2s       | temporary pass | improves  |
| 2026-05-26 | Open | current_baseline               | 97.2m         | 0:45      | +3.2m      | +4.2s      | +0.0m       | +0.0s       | fail           | preserves |
| 2026-05-26 | Open | final_distance_sample_anchored | 0.0m          | 0:07      | -94.0m     | -34.4s     | -97.2m      | -38.6s      | fail           | regresses |
| 2026-05-26 | Open | hkworkoutactivity_boundary     | 94.0m         | 0:41      | +0.0m      | +0.4s      | -3.2m       | -3.8s       | pass           | improves  |
| 2026-05-26 | Open | interpolated_crossing          | 101.5m        | 0:47      | +7.5m      | +5.7s      | +4.2m       | +1.5s       | fail           | regresses |
| 2026-05-26 | Open | next_sample_end                | 90.6m         | 0:43      | -3.4m      | +1.6s      | -6.6m       | -2.6s       | pass           | improves  |
| 2026-05-26 | Open | previous_sample_end            | 104.6m        | 0:48      | +10.6m     | +6.8s      | +7.4m       | +2.6s       | fail           | regresses |
| 2026-05-26 | Open | tail_shrink_to_expected_open   | 94.0m         | 0:41      | +0.0m      | +0.0s      | -3.2m       | -4.2s       | pass           | improves  |
| 2026-06-01 | Work | current_baseline               | 6450.6m       | 42:38     | +0.6m      | -5.7s      | +0.0m       | +0.0s       | fail           | preserves |
| 2026-06-01 | Work | final_distance_sample_anchored | 6463.0m       | 42:43     | +13.0m     | -0.5s      | +12.3m      | +5.1s       | temporary pass | improves  |
| 2026-06-01 | Work | hkworkoutactivity_boundary     | 6457.8m       | 42:44     | +7.8m      | -0.5s      | +7.2m       | +5.2s       | temporary pass | improves  |
| 2026-06-01 | Work | interpolated_crossing          | 6450.0m       | 42:38     | +0.0m      | -5.9s      | -0.6m       | -0.2s       | fail           | improves  |
| 2026-06-01 | Work | next_sample_end                | 6457.7m       | 42:41     | +7.7m      | -3.1s      | +7.0m       | +2.6s       | temporary pass | improves  |
| 2026-06-01 | Work | previous_sample_end            | 6444.0m       | 42:36     | -6.0m      | -8.3s      | -6.6m       | -2.6s       | fail           | regresses |
| 2026-06-01 | Work | tail_shrink_to_expected_open   | 6458.0m       | 42:44     | +8.0m      | -0.0s      | +7.3m       | +5.7s       | temporary pass | improves  |
| 2026-06-01 | Open | current_baseline               | 12.3m         | 0:13      | +7.3m      | +5.7s      | +0.0m       | +0.0s       | fail           | preserves |
| 2026-06-01 | Open | final_distance_sample_anchored | 0.0m          | 0:08      | -5.0m      | +0.5s      | -12.3m      | -5.1s       | pass           | improves  |
| 2026-06-01 | Open | hkworkoutactivity_boundary     | 5.1m          | 0:07      | +0.1m      | +0.4s      | -7.2m       | -5.2s       | pass           | improves  |
| 2026-06-01 | Open | interpolated_crossing          | 13.0m         | 0:13      | +8.0m      | +5.9s      | +0.6m       | +0.2s       | fail           | regresses |
| 2026-06-01 | Open | next_sample_end                | 5.3m          | 0:10      | +0.3m      | +3.1s      | -7.0m       | -2.6s       | temporary pass | improves  |
| 2026-06-01 | Open | previous_sample_end            | 18.9m         | 0:15      | +13.9m     | +8.2s      | +6.6m       | +2.6s       | fail           | regresses |
| 2026-06-01 | Open | tail_shrink_to_expected_open   | 5.0m          | 0:07      | +0.0m      | +0.0s      | -7.3m       | -5.7s       | pass           | improves  |
| 2026-06-12 | Work | current_baseline               | 5001.6m       | 31:59     | +1.6m      | -4.5s      | +0.0m       | +0.0s       | fail           | preserves |
| 2026-06-12 | Work | final_distance_sample_anchored | 5044.8m       | 32:14     | +44.8m     | +11.0s     | +43.2m      | +15.4s      | fail           | regresses |
| 2026-06-12 | Work | hkworkoutactivity_boundary     | 5007.9m       | 32:03     | +7.9m      | +0.4s      | +6.4m       | +4.8s       | temporary pass | improves  |
| 2026-06-12 | Work | interpolated_crossing          | 5000.0m       | 31:58     | +0.0m      | -5.1s      | -1.6m       | -0.6s       | fail           | improves  |
| 2026-06-12 | Work | next_sample_end                | 5008.8m       | 32:01     | +8.8m      | -1.9s      | +7.2m       | +2.6s       | temporary pass | improves  |
| 2026-06-12 | Work | previous_sample_end            | 4994.9m       | 31:56     | -5.1m      | -7.0s      | -6.7m       | -2.6s       | fail           | regresses |
| 2026-06-12 | Work | tail_shrink_to_expected_open   | 5008.8m       | 32:04     | +8.8m      | +0.8s      | +7.2m       | +5.2s       | temporary pass | improves  |
| 2026-06-12 | Open | current_baseline               | 43.2m         | 0:22      | +7.2m      | +5.2s      | +0.0m       | +0.0s       | fail           | preserves |
| 2026-06-12 | Open | final_distance_sample_anchored | 0.0m          | 0:07      | -36.0m     | -10.2s     | -43.2m      | -15.4s      | fail           | regresses |
| 2026-06-12 | Open | hkworkoutactivity_boundary     | 36.9m         | 0:17      | +0.9m      | +0.4s      | -6.4m       | -4.8s       | pass           | improves  |
| 2026-06-12 | Open | interpolated_crossing          | 44.8m         | 0:23      | +8.8m      | +5.8s      | +1.6m       | +0.6s       | fail           | regresses |
| 2026-06-12 | Open | next_sample_end                | 36.0m         | 0:20      | +0.0m      | +2.6s      | -7.2m       | -2.6s       | temporary pass | improves  |
| 2026-06-12 | Open | previous_sample_end            | 50.0m         | 0:25      | +14.0m     | +7.8s      | +6.7m       | +2.6s       | fail           | regresses |
| 2026-06-12 | Open | tail_shrink_to_expected_open   | 36.0m         | 0:17      | +0.0m      | +0.0s      | -7.2m       | -5.2s       | pass           | improves  |

## Pass-Case Guards

June 2 and June 4 are simple Work + Open guard fixtures. June 2 is a temporary pass with exact packet values; June 4 is a pass.

| Date       | Row  | Strategy                       | Pred distance | Pred time | Dist delta | Time delta | Dist change | Time change | Status         | Effect    |
| ---------- | ---- | ------------------------------ | ------------- | --------- | ---------- | ---------- | ----------- | ----------- | -------------- | --------- |
| 2026-06-02 | Work | current_baseline               | 5651.9m       | 36:13     | +1.9m      | -2.4s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-02 | Work | final_distance_sample_anchored | 5708.9m       | 36:36     | +58.9m     | +20.7s     | +57.0m      | +23.2s      | fail           | regresses |
| 2026-06-02 | Work | hkworkoutactivity_boundary     | 5651.2m       | 36:15     | +1.2m      | -0.2s      | -0.7m       | +2.2s       | pass           | improves  |
| 2026-06-02 | Work | interpolated_crossing          | 5650.0m       | 36:12     | +0.0m      | -3.3s      | -1.9m       | -0.9s       | temporary pass | improves  |
| 2026-06-02 | Work | next_sample_end                | 5659.1m       | 36:15     | +9.1m      | +0.2s      | +7.3m       | +2.6s       | temporary pass | regresses |
| 2026-06-02 | Work | previous_sample_end            | 5646.4m       | 36:10     | -3.6m      | -5.0s      | -5.5m       | -2.6s       | temporary pass | regresses |
| 2026-06-02 | Work | tail_shrink_to_expected_open   | 5651.9m       | 36:15     | +1.9m      | -0.3s      | +0.0m       | +2.1s       | pass           | improves  |
| 2026-06-02 | Open | current_baseline               | 57.0m         | 0:30      | +0.0m      | +2.1s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-02 | Open | final_distance_sample_anchored | 0.0m          | 0:07      | -57.0m     | -21.1s     | -57.0m      | -23.2s      | fail           | regresses |
| 2026-06-02 | Open | hkworkoutactivity_boundary     | 57.7m         | 0:28      | +0.7m      | -0.2s      | +0.7m       | -2.2s       | pass           | improves  |
| 2026-06-02 | Open | interpolated_crossing          | 58.9m         | 0:31      | +1.9m      | +3.0s      | +1.9m       | +0.9s       | temporary pass | regresses |
| 2026-06-02 | Open | next_sample_end                | 49.7m         | 0:28      | -7.3m      | -0.5s      | -7.3m       | -2.6s       | pass           | improves  |
| 2026-06-02 | Open | previous_sample_end            | 62.5m         | 0:33      | +5.5m      | +4.7s      | +5.5m       | +2.6s       | temporary pass | regresses |
| 2026-06-02 | Open | tail_shrink_to_expected_open   | 57.0m         | 0:28      | +0.0m      | +0.0s      | -0.0m       | -2.1s       | pass           | improves  |
| 2026-06-04 | Work | current_baseline               | 5652.9m       | 36:34     | +2.9m      | -1.7s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-04 | Work | final_distance_sample_anchored | 5694.9m       | 36:50     | +44.9m     | +13.7s     | +42.0m      | +15.4s      | fail           | regresses |
| 2026-06-04 | Work | hkworkoutactivity_boundary     | 5657.2m       | 36:36     | +7.2m      | -0.4s      | +4.3m       | +1.3s       | temporary pass | regresses |
| 2026-06-04 | Work | interpolated_crossing          | 5650.0m       | 36:33     | +0.0m      | -3.0s      | -2.9m       | -1.3s       | temporary pass | regresses |
| 2026-06-04 | Work | next_sample_end                | 5660.9m       | 36:37     | +10.9m     | +0.9s      | +8.0m       | +2.6s       | temporary pass | regresses |
| 2026-06-04 | Work | previous_sample_end            | 5647.0m       | 36:32     | -3.0m      | -4.3s      | -5.9m       | -2.6s       | temporary pass | regresses |
| 2026-06-04 | Work | tail_shrink_to_expected_open   | 5650.9m       | 36:36     | +0.9m      | -0.5s      | -2.0m       | +1.2s       | pass           | improves  |
| 2026-06-04 | Open | current_baseline               | 42.0m         | 0:22      | -2.0m      | +1.2s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-04 | Open | final_distance_sample_anchored | 0.0m          | 0:07      | -44.0m     | -14.2s     | -42.0m      | -15.4s      | fail           | regresses |
| 2026-06-04 | Open | hkworkoutactivity_boundary     | 44.8m         | 0:21      | +0.8m      | -0.1s      | +2.8m       | -1.3s       | pass           | improves  |
| 2026-06-04 | Open | interpolated_crossing          | 44.9m         | 0:24      | +0.9m      | +2.5s      | +2.9m       | +1.3s       | temporary pass | regresses |
| 2026-06-04 | Open | next_sample_end                | 34.0m         | 0:20      | -10.0m     | -1.3s      | -8.0m       | -2.6s       | temporary pass | regresses |
| 2026-06-04 | Open | previous_sample_end            | 47.8m         | 0:25      | +3.8m      | +3.8s      | +5.9m       | +2.6s       | temporary pass | regresses |
| 2026-06-04 | Open | tail_shrink_to_expected_open   | 44.0m         | 0:21      | +0.0m      | +0.0s      | +2.0m       | -1.2s       | pass           | improves  |

## Special Fixtures

June 3 is a planned open cooldown regression fixture with repeated intervals. June 5 has warmup/cooldown distance-time caveats. These rows are scored for visibility, but they are not simple Work + Open drift approval cases.

| Date       | Row      | Strategy                       | Pred distance | Pred time | Dist delta | Time delta | Dist change | Time change | Status         | Effect    |
| ---------- | -------- | ------------------------------ | ------------- | --------- | ---------- | ---------- | ----------- | ----------- | -------------- | --------- |
| 2026-06-03 | Warmup   | current_baseline               | 2001.5m       | 12:42     | +1.5m      | -4.6s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-03 | Warmup   | hkworkoutactivity_boundary     | 2008.6m       | 12:47     | +8.6m      | +0.3s      | +7.1m       | +4.9s       | temporary pass | regresses |
| 2026-06-03 | Warmup   | interpolated_crossing          | 2000.0m       | 12:42     | +0.0m      | -5.3s      | -1.5m       | -0.6s       | fail           | regresses |
| 2026-06-03 | Warmup   | next_sample_end                | 2009.2m       | 12:45     | +9.2m      | -2.1s      | +7.8m       | +2.6s       | temporary pass | regresses |
| 2026-06-03 | Warmup   | previous_sample_end            | 1995.6m       | 12:40     | -4.4m      | -7.2s      | -5.9m       | -2.6s       | fail           | regresses |
| 2026-06-03 | Work     | current_baseline               | 1001.9m       | 4:12      | +1.9m      | +0.1s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-03 | Work     | hkworkoutactivity_boundary     | 1005.1m       | 4:12      | +5.1m      | -0.2s      | +3.2m       | -0.3s       | temporary pass | regresses |
| 2026-06-03 | Work     | interpolated_crossing          | 1000.0m       | 4:12      | +0.0m      | -0.4s      | -1.9m       | -0.5s       | pass           | improves  |
| 2026-06-03 | Work     | next_sample_end                | 1014.6m       | 4:15      | +14.6m     | +2.7s      | +12.7m      | +2.6s       | fail           | regresses |
| 2026-06-03 | Work     | previous_sample_end            | 992.7m        | 4:10      | -7.3m      | -2.5s      | -9.3m       | -2.6s       | fail           | regresses |
| 2026-06-03 | Recovery | current_baseline               | 218.1m        | 2:30      | +9.1m      | +0.0s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-03 | Recovery | hkworkoutactivity_boundary     | 209.5m        | 2:29      | +0.5m      | -1.0s      | -8.5m       | -1.0s       | pass           | improves  |
| 2026-06-03 | Work     | current_baseline               | 1001.7m       | 4:06      | +1.7m      | +0.2s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-03 | Work     | hkworkoutactivity_boundary     | 1005.2m       | 4:06      | +5.2m      | +0.2s      | +3.6m       | +0.0s       | temporary pass | regresses |
| 2026-06-03 | Work     | interpolated_crossing          | 1000.0m       | 4:06      | +0.0m      | -0.2s      | -1.7m       | -0.4s       | pass           | improves  |
| 2026-06-03 | Work     | next_sample_end                | 1013.7m       | 4:09      | +13.7m     | +2.7s      | +12.1m      | +2.6s       | fail           | regresses |
| 2026-06-03 | Work     | previous_sample_end            | 991.1m        | 4:04      | -8.9m      | -2.4s      | -10.6m      | -2.6s       | fail           | regresses |
| 2026-06-03 | Recovery | current_baseline               | 210.2m        | 2:30      | +3.2m      | +0.0s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-03 | Recovery | hkworkoutactivity_boundary     | 207.3m        | 2:30      | +0.3m      | -0.1s      | -2.8m       | -0.1s       | pass           | improves  |
| 2026-06-03 | Work     | current_baseline               | 1004.0m       | 4:01      | +4.0m      | +1.0s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-03 | Work     | hkworkoutactivity_boundary     | 1003.9m       | 4:00      | +3.9m      | +0.5s      | -0.1m       | -0.5s       | pass           | improves  |
| 2026-06-03 | Work     | interpolated_crossing          | 1000.0m       | 4:00      | +0.0m      | +0.1s      | -4.0m       | -0.9s       | pass           | improves  |
| 2026-06-03 | Work     | next_sample_end                | 1016.2m       | 4:04      | +16.2m     | +3.6s      | +12.2m      | +2.6s       | fail           | regresses |
| 2026-06-03 | Work     | previous_sample_end            | 993.0m        | 3:58      | -7.0m      | -1.5s      | -11.0m      | -2.6s       | temporary pass | regresses |
| 2026-06-03 | Recovery | current_baseline               | 199.1m        | 2:30      | +2.1m      | +0.0s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-03 | Recovery | hkworkoutactivity_boundary     | 197.1m        | 2:30      | +0.1m      | -0.2s      | -2.0m       | -0.2s       | pass           | improves  |
| 2026-06-03 | Cooldown | current_baseline               | 1031.7m       | 6:25      | +1.7m      | +3.0s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-03 | Cooldown | hkworkoutactivity_boundary     | 1031.2m       | 6:22      | +1.2m      | +0.1s      | -0.5m       | -2.9s       | pass           | improves  |
| 2026-06-05 | Warmup   | current_baseline               | 2005.5m       | 12:27     | +5.5m      | -3.4s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-05 | Warmup   | hkworkoutactivity_boundary     | 2006.6m       | 12:30     | +6.6m      | +0.1s      | +1.0m       | +3.5s       | temporary pass | improves  |
| 2026-06-05 | Warmup   | interpolated_crossing          | 2000.0m       | 12:24     | +0.0m      | -5.9s      | -5.5m       | -2.5s       | fail           | regresses |
| 2026-06-05 | Warmup   | next_sample_end                | 2008.5m       | 12:29     | +8.5m      | -0.8s      | +3.0m       | +2.6s       | temporary pass | regresses |
| 2026-06-05 | Warmup   | previous_sample_end            | 1999.8m       | 12:24     | -0.2m      | -6.0s      | -5.7m       | -2.6s       | fail           | regresses |
| 2026-06-05 | Work     | current_baseline               | 2008.6m       | 8:32      | +8.6m      | +1.9s      | +0.0m       | +0.0s       | pass           | preserves |
| 2026-06-05 | Work     | hkworkoutactivity_boundary     | 2005.1m       | 8:30      | +5.1m      | +0.5s      | -3.4m       | -1.5s       | pass           | improves  |
| 2026-06-05 | Work     | interpolated_crossing          | 2000.0m       | 8:30      | +0.0m      | -0.2s      | -8.6m       | -2.1s       | pass           | improves  |
| 2026-06-05 | Work     | next_sample_end                | 2018.9m       | 8:35      | +18.9m     | +4.5s      | +10.3m      | +2.6s       | fail           | regresses |
| 2026-06-05 | Work     | previous_sample_end            | 1998.0m       | 8:29      | -2.0m      | -0.6s      | -10.5m      | -2.6s       | pass           | improves  |
| 2026-06-05 | Cooldown | current_baseline               | 2507.7m       | 14:40     | +17.7m     | +3.8s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-05 | Cooldown | final_distance_sample_anchored | 2947.7m       | 17:14     | +457.7m    | +158.2s    | +440.0m     | +154.4s     | fail           | regresses |
| 2026-06-05 | Cooldown | hkworkoutactivity_boundary     | 2496.6m       | 14:36     | +6.6m      | -0.1s      | -11.1m      | -3.9s       | pass           | improves  |
| 2026-06-05 | Cooldown | interpolated_crossing          | 2500.0m       | 14:37     | +10.0m     | +1.3s      | -7.7m       | -2.5s       | pass           | improves  |
| 2026-06-05 | Cooldown | next_sample_end                | 2515.7m       | 14:42     | +25.7m     | +6.4s      | +8.1m       | +2.6s       | fail           | regresses |
| 2026-06-05 | Cooldown | previous_sample_end            | 2499.8m       | 14:37     | +9.8m      | +1.3s      | -7.9m       | -2.6s       | pass           | improves  |
| 2026-06-05 | Cooldown | tail_shrink_to_expected_open   | 2494.7m       | 14:38     | +4.7m      | +1.6s      | -13.0m      | -2.2s       | pass           | improves  |
| 2026-06-05 | Open     | current_baseline               | 440.0m        | 2:38      | -13.0m     | -2.2s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-06-05 | Open     | final_distance_sample_anchored | 0.0m          | 0:03      | -453.0m    | -156.6s    | -440.0m     | -154.4s     | fail           | regresses |
| 2026-06-05 | Open     | hkworkoutactivity_boundary     | 453.5m        | 2:40      | +0.5m      | -0.3s      | +13.5m      | +2.0s       | pass           | improves  |
| 2026-06-05 | Open     | interpolated_crossing          | 447.7m        | 2:40      | -5.3m      | +0.3s      | +7.7m       | +2.5s       | pass           | improves  |
| 2026-06-05 | Open     | next_sample_end                | 432.0m        | 2:35      | -21.0m     | -4.8s      | -8.1m       | -2.6s       | fail           | regresses |
| 2026-06-05 | Open     | previous_sample_end            | 447.9m        | 2:40      | -5.1m      | +0.3s      | +7.9m       | +2.6s       | pass           | improves  |
| 2026-06-05 | Open     | tail_shrink_to_expected_open   | 453.0m        | 2:40      | +0.0m      | +0.0s      | +13.0m      | +2.2s       | pass           | improves  |

## Evidence Recovery

April 28 is included as an evidence-recovery / single-tail summary and excluded from production approval scoring. It confirms fresh physical-device evidence recovery, not a repeated boundary tuning rule.

| Date       | Row  | Strategy                       | Pred distance | Pred time | Dist delta | Time delta | Dist change | Time change | Status         | Effect    |
| ---------- | ---- | ------------------------------ | ------------- | --------- | ---------- | ---------- | ----------- | ----------- | -------------- | --------- |
| 2026-04-28 | Work | current_baseline               | 7256.3m       | 46:09     | +6.3m      | -3.2s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-04-28 | Work | final_distance_sample_anchored | 7304.6m       | 46:27     | +54.6m     | +14.8s     | +48.3m      | +18.0s      | fail           | regresses |
| 2026-04-28 | Work | hkworkoutactivity_boundary     | 7257.8m       | 46:12     | +7.8m      | -0.1s      | +1.5m       | +3.1s       | temporary pass | improves  |
| 2026-04-28 | Work | interpolated_crossing          | 7250.0m       | 46:07     | +0.0m      | -5.4s      | -6.3m       | -2.2s       | fail           | regresses |
| 2026-04-28 | Work | next_sample_end                | 7263.2m       | 46:11     | +13.2m     | -0.7s      | +6.9m       | +2.6s       | temporary pass | regresses |
| 2026-04-28 | Work | previous_sample_end            | 7248.9m       | 46:06     | -1.1m      | -5.8s      | -7.5m       | -2.6s       | fail           | regresses |
| 2026-04-28 | Work | tail_shrink_to_expected_open   | 7258.6m       | 46:12     | +8.6m      | -0.2s      | +2.3m       | +3.0s       | temporary pass | improves  |
| 2026-04-28 | Open | current_baseline               | 48.3m         | 0:23      | +2.3m      | +3.0s      | +0.0m       | +0.0s       | temporary pass | preserves |
| 2026-04-28 | Open | final_distance_sample_anchored | 0.0m          | 0:05      | -46.0m     | -15.0s     | -48.3m      | -18.0s      | fail           | regresses |
| 2026-04-28 | Open | hkworkoutactivity_boundary     | 46.8m         | 0:20      | +0.8m      | -0.1s      | -1.5m       | -3.1s       | pass           | improves  |
| 2026-04-28 | Open | interpolated_crossing          | 54.6m         | 0:25      | +8.6m      | +5.2s      | +6.3m       | +2.2s       | fail           | regresses |
| 2026-04-28 | Open | next_sample_end                | 41.4m         | 0:20      | -4.6m      | +0.4s      | -6.9m       | -2.6s       | pass           | improves  |
| 2026-04-28 | Open | previous_sample_end            | 55.7m         | 0:26      | +9.7m      | +5.6s      | +7.5m       | +2.6s       | fail           | regresses |
| 2026-04-28 | Open | tail_shrink_to_expected_open   | 46.0m         | 0:20      | +0.0m      | +0.0s      | -2.3m       | -3.0s       | pass           | improves  |

## Not Scoreable

| Strategy                       | Reason                                                                              | Rows | Examples                                                                                                                               |
| ------------------------------ | ----------------------------------------------------------------------------------- | ---- | -------------------------------------------------------------------------------------------------------------------------------------- |
| final_distance_sample_anchored | requires a following Open / Extra row with tail diagnostics                         | 4    | 2026-06-03 Warmup; 2026-06-03 Work; 2026-06-05 Warmup; 2026-06-05 Work                                                                 |
| final_distance_sample_anchored | row has no boundary diagnostics in the packet                                       | 2    | 2026-06-03 Cooldown; 2026-06-03 Recovery                                                                                               |
| interpolated_crossing          | row has no boundary diagnostics in the packet                                       | 2    | 2026-06-03 Cooldown; 2026-06-03 Recovery                                                                                               |
| next_sample_end                | row has no boundary diagnostics in the packet                                       | 2    | 2026-06-03 Cooldown; 2026-06-03 Recovery                                                                                               |
| pause_adjusted                 | packet data does not include pause intervals or pause-adjusted boundary diagnostics | 20   | 2026-04-28 Open; 2026-04-28 Work; 2026-05-26 Open; 2026-05-26 Work; 2026-06-01 Open; 2026-06-01 Work; 2026-06-02 Open; 2026-06-02 Work |
| previous_sample_end            | row has no boundary diagnostics in the packet                                       | 2    | 2026-06-03 Cooldown; 2026-06-03 Recovery                                                                                               |
| tail_shrink_to_expected_open   | requires a following Open / Extra row with tail diagnostics                         | 4    | 2026-06-03 Warmup; 2026-06-03 Work; 2026-06-05 Warmup; 2026-06-05 Work                                                                 |
| tail_shrink_to_expected_open   | row has no boundary diagnostics in the packet                                       | 2    | 2026-06-03 Cooldown; 2026-06-03 Recovery                                                                                               |

## Recommendation

- Do not change production boundary behavior yet.
- Do not promote WorkoutKit reconstructed intervals into normal workout UI from this scorecard alone.
- Use the scorecard to decide which candidate, if any, deserves a later debug-only implementation experiment with explicit guard preservation.
- Rollback note: remove this scorer and generated scorecard files to revert the research tooling; app behavior is unaffected.

