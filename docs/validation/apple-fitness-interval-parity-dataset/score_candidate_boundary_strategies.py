#!/usr/bin/env python3
"""Score debug-only boundary strategies against the parity fixture set.

This tool is documentation/research only. It reads archived validation fixtures
and parity packets, writes deterministic scorecards, and does not change app
behavior.
"""

from __future__ import annotations

import json
from dataclasses import dataclass
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
FIXTURE_PATH = ROOT / "interval-parity-fixture.json"
MARKDOWN_REPORT = ROOT / "candidate-boundary-strategy-scorecard.md"
JSON_REPORT = ROOT / "candidate-boundary-strategy-scorecard.json"

STRATEGIES = [
    ("current_baseline", "v1", "current / baseline crossing sample end"),
    ("interpolated_crossing", "v1", "interpolated crossing"),
    ("previous_sample_end", "v1", "previous sample end"),
    ("next_sample_end", "v1", "next sample end"),
    ("final_distance_sample_anchored", "v1", "final distance sample anchored"),
    ("tail_shrink_to_expected_open", "v1", "tail shrink to expected Open"),
    ("pause_adjusted", "v1", "pause-adjusted boundary"),
]

APPROVAL_EXCLUDED_DATES = {"2026-04-28"}
DRIFT_DATES = {"2026-05-26", "2026-06-01", "2026-06-12"}
GUARD_DATES = {"2026-06-02", "2026-06-04"}
SPECIAL_DATES = {"2026-06-03", "2026-06-05"}


@dataclass
class PacketRow:
    date: str
    workout: dict[str, Any]
    interval: dict[str, Any]
    next_interval: dict[str, Any] | None


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text())


def packet_path(workout: dict[str, Any]) -> Path:
    return (
        ROOT
        / workout["folder"]
        / "exports"
        / "runsignal-diagnostics"
        / f"runsignal-parity-packet-{workout['date']}.json"
    )


def seconds_text(seconds: float | None) -> str:
    if seconds is None:
        return "n/a"
    rounded = int(round(seconds))
    return f"{rounded // 60}:{rounded % 60:02d}"


def number_text(value: float | None, suffix: str = "") -> str:
    if value is None:
        return "n/a"
    return f"{value:.1f}{suffix}"


def signed_text(value: float | None, suffix: str = "") -> str:
    if value is None:
        return "n/a"
    return f"{value:+.1f}{suffix}"


def status_for(row: dict[str, Any], distance: float | None, duration: float | None) -> str:
    required = [
        "expectedDistanceMeters",
        "expectedTimeSeconds",
        "preferredDistanceToleranceMeters",
        "preferredTimeToleranceSeconds",
        "temporaryDistanceToleranceMeters",
        "temporaryTimeToleranceSeconds",
    ]
    if distance is None or duration is None or any(key not in row for key in required):
        return "unavailable"

    distance_delta = abs(distance - float(row["expectedDistanceMeters"]))
    time_delta = abs(duration - float(row["expectedTimeSeconds"]))
    if (
        distance_delta <= float(row["preferredDistanceToleranceMeters"])
        and time_delta <= float(row["preferredTimeToleranceSeconds"])
    ):
        return "pass"
    if (
        distance_delta <= float(row["temporaryDistanceToleranceMeters"])
        and time_delta <= float(row["temporaryTimeToleranceSeconds"])
    ):
        return "temporary pass"
    return "fail"


def status_rank(status: str) -> int:
    return {
        "pass": 3,
        "temporary pass": 2,
        "fail": 1,
        "unavailable": 0,
        "not scoreable": 0,
    }.get(status, 0)


def error_score(row: dict[str, Any], distance: float | None, duration: float | None) -> float | None:
    if distance is None or duration is None:
        return None
    return abs(distance - float(row["expectedDistanceMeters"])) + abs(
        duration - float(row["expectedTimeSeconds"])
    )


def effect_for(
    row: dict[str, Any],
    candidate_distance: float | None,
    candidate_duration: float | None,
) -> str:
    current_distance = float(row["observedDistanceMeters"])
    current_duration = float(row["observedTimeSeconds"])
    current_status = status_for(row, current_distance, current_duration)
    candidate_status = status_for(row, candidate_distance, candidate_duration)

    if candidate_status == "not scoreable" or candidate_status == "unavailable":
        return "not scoreable"
    if status_rank(candidate_status) > status_rank(current_status):
        return "improves"
    if status_rank(candidate_status) < status_rank(current_status):
        return "regresses"

    current_score = error_score(row, current_distance, current_duration)
    candidate_score = error_score(row, candidate_distance, candidate_duration)
    if current_score is None or candidate_score is None:
        return "preserves"
    if candidate_score < current_score - 0.25:
        return "improves"
    if candidate_score > current_score + 0.25:
        return "regresses"
    return "preserves"


def planned_goal(row: dict[str, Any], interval: dict[str, Any] | None) -> str:
    if interval:
        display = interval.get("plannedGoalDisplayText")
        if display:
            return str(display)
        target = interval.get("boundaryDiagnostics", {}).get("targetDistanceMeters")
        if target is not None:
            return f"{float(target) / 1000:.2f} km"
    expected = row.get("expectedDistanceMeters")
    if row.get("expectedLabel") == "Open":
        return "Open"
    if expected is not None:
        return f"{float(expected) / 1000:.2f} km reference"
    return "n/a"


def boundary_prediction(
    strategy_id: str,
    row: dict[str, Any],
    packet_row: PacketRow | None,
) -> tuple[float | None, float | None, str | None]:
    if strategy_id == "current_baseline":
        return (
            float(row["observedDistanceMeters"]),
            float(row["observedTimeSeconds"]),
            None,
        )

    if strategy_id == "pause_adjusted":
        return None, None, "packet data does not include pause intervals or pause-adjusted boundary diagnostics"

    if not packet_row:
        return None, None, "archived parity packet is missing"

    interval = packet_row.interval
    boundary = interval.get("boundaryDiagnostics")
    if not boundary:
        return None, None, "row has no boundary diagnostics in the packet"

    row_start_offset = float(interval.get("startOffsetSeconds", 0))
    cumulative_start = float(boundary.get("cumulativeDistanceAtStartMeters", 0))

    if strategy_id == "interpolated_crossing":
        crossing = boundary.get("crossingSample")
        fraction = boundary.get("interpolationFraction")
        if not crossing or fraction is None:
            return None, None, "crossing sample or interpolation fraction is missing"
        start_offset = float(crossing["startOffsetSeconds"])
        end_offset = float(crossing["endOffsetSeconds"])
        offset = start_offset + float(fraction) * (end_offset - start_offset)
        # targetDistanceMeters is the planned row goal, not the workout-global
        # cumulative distance value.
        distance = float(boundary["targetDistanceMeters"])
        return distance, offset - row_start_offset, None

    sample_key_by_strategy = {
        "previous_sample_end": "previousSample",
        "next_sample_end": "nextSample",
    }
    if strategy_id in sample_key_by_strategy:
        sample = boundary.get(sample_key_by_strategy[strategy_id])
        if not sample:
            return None, None, f"{sample_key_by_strategy[strategy_id]} is missing"
        distance = float(sample["endCumulativeDistanceMeters"]) - cumulative_start
        duration = float(sample["endOffsetSeconds"]) - row_start_offset
        return distance, duration, None

    if strategy_id == "final_distance_sample_anchored":
        next_interval = packet_row.next_interval
        if not next_interval or "tailDiagnostics" not in next_interval:
            return None, None, "requires a following Open / Extra row with tail diagnostics"
        tail = next_interval["tailDiagnostics"]
        offset = tail.get("finalDistanceSampleOffsetSeconds")
        cumulative = tail.get("finalDistanceSampleCumulativeDistanceMeters")
        if offset is None or cumulative is None:
            return None, None, "tail diagnostics do not include final distance sample timing"
        distance = float(cumulative) - cumulative_start
        duration = float(offset) - row_start_offset
        return distance, duration, None

    if strategy_id == "tail_shrink_to_expected_open":
        next_interval = packet_row.next_interval
        if not next_interval or "tailDiagnostics" not in next_interval:
            return None, None, "requires a following Open / Extra row with tail diagnostics"
        tail = next_interval["tailDiagnostics"]
        workout_end = tail.get("workoutEndOffsetSeconds")
        final_distance = tail.get("finalDistanceSampleCumulativeDistanceMeters")
        if workout_end is None or final_distance is None:
            return None, None, "tail diagnostics do not include workout end and final distance"
        expected_open_time = expected_following_open_time(packet_row.workout, row)
        expected_open_distance = expected_following_open_distance(packet_row.workout, row)
        if expected_open_time is None or expected_open_distance is None:
            return None, None, "requires a following Apple Fitness Open reference row"
        distance = float(final_distance) - expected_open_distance - cumulative_start
        duration = float(workout_end) - expected_open_time - row_start_offset
        return distance, duration, None

    return None, None, "unknown strategy"


def expected_following_open_time(workout: dict[str, Any], row: dict[str, Any]) -> float | None:
    rows = workout["rows"]
    index = rows.index(row)
    if index + 1 >= len(rows):
        return None
    next_row = rows[index + 1]
    if next_row.get("expectedLabel") != "Open":
        return None
    return float(next_row["expectedTimeSeconds"])


def expected_following_open_distance(workout: dict[str, Any], row: dict[str, Any]) -> float | None:
    rows = workout["rows"]
    index = rows.index(row)
    if index + 1 >= len(rows):
        return None
    next_row = rows[index + 1]
    if next_row.get("expectedLabel") != "Open":
        return None
    return float(next_row["expectedDistanceMeters"])


def open_tail_prediction(
    strategy_id: str,
    row: dict[str, Any],
    previous_row: dict[str, Any],
    previous_packet_row: PacketRow | None,
) -> tuple[float | None, float | None, str | None]:
    if strategy_id == "current_baseline":
        return (
            float(row["observedDistanceMeters"]),
            float(row["observedTimeSeconds"]),
            None,
        )

    if strategy_id == "pause_adjusted":
        return None, None, "packet data does not include pause intervals or pause-adjusted boundary diagnostics"

    if not previous_packet_row:
        return None, None, "requires the previous planned row packet data"
    next_interval = previous_packet_row.next_interval
    if not next_interval or "tailDiagnostics" not in next_interval:
        return None, None, "requires Open / Extra tail diagnostics"
    tail = next_interval["tailDiagnostics"]
    workout_end = tail.get("workoutEndOffsetSeconds")
    final_distance = tail.get("finalDistanceSampleCumulativeDistanceMeters")
    if workout_end is None or final_distance is None:
        return None, None, "tail diagnostics do not include workout end and final distance"

    boundary_distance, boundary_duration, reason = boundary_prediction(
        strategy_id,
        previous_row,
        previous_packet_row,
    )
    if reason:
        return None, None, reason

    previous_interval = previous_packet_row.interval
    boundary = previous_interval.get("boundaryDiagnostics", {})
    cumulative_start = float(boundary.get("cumulativeDistanceAtStartMeters", 0))
    row_start_offset = float(previous_interval.get("startOffsetSeconds", 0))
    boundary_offset = row_start_offset + float(boundary_duration)
    boundary_cumulative = cumulative_start + float(boundary_distance)

    distance = float(final_distance) - boundary_cumulative
    duration = float(workout_end) - boundary_offset
    return distance, duration, None


def fixture_group(date: str) -> str:
    if date in DRIFT_DATES:
        return "drift"
    if date in GUARD_DATES:
        return "guard"
    if date in SPECIAL_DATES:
        return "special"
    if date in APPROVAL_EXCLUDED_DATES:
        return "evidence recovery"
    return "other"


def score_rows() -> tuple[list[dict[str, Any]], list[dict[str, Any]]]:
    fixture = load_json(FIXTURE_PATH)
    results: list[dict[str, Any]] = []
    not_scoreable: list[dict[str, Any]] = []

    for workout in fixture["workouts"]:
        path = packet_path(workout)
        packet = load_json(path) if path.exists() else None
        intervals = packet.get("reconstructedIntervals", []) if packet else []
        packet_rows: list[PacketRow | None] = []
        for index, _row in enumerate(workout["rows"]):
            interval = intervals[index] if index < len(intervals) else None
            next_interval = intervals[index + 1] if index + 1 < len(intervals) else None
            packet_rows.append(
                PacketRow(workout["date"], workout, interval, next_interval)
                if packet and interval
                else None
            )

        for index, row in enumerate(workout["rows"]):
            packet_row = packet_rows[index]
            previous_packet_row = packet_rows[index - 1] if index > 0 else None
            previous_row = workout["rows"][index - 1] if index > 0 else None

            for strategy_id, strategy_version, strategy_name in STRATEGIES:
                if row.get("expectedLabel") == "Open" and previous_row:
                    distance, duration, reason = open_tail_prediction(
                        strategy_id,
                        row,
                        previous_row,
                        previous_packet_row,
                    )
                else:
                    distance, duration, reason = boundary_prediction(strategy_id, row, packet_row)

                if reason:
                    result_status = "not scoreable"
                    effect = "not scoreable"
                    not_scoreable.append(
                        {
                            "strategyID": strategy_id,
                            "workoutDate": workout["date"],
                            "rowLabel": row["expectedLabel"],
                            "reason": reason,
                        }
                    )
                else:
                    result_status = status_for(row, distance, duration)
                    effect = effect_for(row, distance, duration)

                result = {
                    "strategyID": strategy_id,
                    "strategyVersion": strategy_version,
                    "strategyName": strategy_name,
                    "workoutDate": workout["date"],
                    "fixtureClassification": workout["expectedStatus"],
                    "fixtureGroup": fixture_group(workout["date"]),
                    "rowNumber": row["row"],
                    "rowLabel": row["expectedLabel"],
                    "plannedGoal": planned_goal(row, packet_row.interval if packet_row else None),
                    "appleExpectedDistanceMeters": row.get("expectedDistanceMeters"),
                    "appleExpectedTimeSeconds": row.get("expectedTimeSeconds"),
                    "currentRunSignalDistanceMeters": row.get("observedDistanceMeters"),
                    "currentRunSignalTimeSeconds": row.get("observedTimeSeconds"),
                    "candidatePredictedDistanceMeters": distance,
                    "candidatePredictedTimeSeconds": duration,
                    "candidateDistanceDeltaMeters": (
                        distance - float(row["expectedDistanceMeters"]) if distance is not None else None
                    ),
                    "candidateTimeDeltaSeconds": (
                        duration - float(row["expectedTimeSeconds"]) if duration is not None else None
                    ),
                    "candidateChangeDistanceMeters": (
                        distance - float(row["observedDistanceMeters"]) if distance is not None else None
                    ),
                    "candidateChangeTimeSeconds": (
                        duration - float(row["observedTimeSeconds"]) if duration is not None else None
                    ),
                    "status": result_status,
                    "effect": effect,
                    "notScoreableReason": reason,
                    "approvalExcluded": workout["date"] in APPROVAL_EXCLUDED_DATES,
                }
                results.append(result)

    return results, collapse_not_scoreable(not_scoreable)


def collapse_not_scoreable(items: list[dict[str, Any]]) -> list[dict[str, Any]]:
    grouped: dict[tuple[str, str], set[str]] = {}
    for item in items:
        key = (item["strategyID"], item["reason"])
        grouped.setdefault(key, set()).add(f"{item['workoutDate']} {item['rowLabel']}")
    return [
        {
            "strategyID": strategy_id,
            "reason": reason,
            "examples": sorted(examples)[:8],
            "count": len(examples),
        }
        for (strategy_id, reason), examples in sorted(grouped.items())
    ]


def strategy_summary(results: list[dict[str, Any]]) -> list[dict[str, Any]]:
    summaries = []
    for strategy_id, version, name in STRATEGIES:
        rows = [item for item in results if item["strategyID"] == strategy_id]
        scoreable = [item for item in rows if item["status"] != "not scoreable"]
        non_excluded = [item for item in scoreable if not item["approvalExcluded"]]
        drift = [item for item in non_excluded if item["fixtureGroup"] == "drift"]
        guards = [item for item in non_excluded if item["fixtureGroup"] == "guard"]
        special = [item for item in non_excluded if item["fixtureGroup"] == "special"]
        guard_regressions = [item for item in guards if item["effect"] == "regresses"]
        drift_improvements = [item for item in drift if item["effect"] == "improves"]
        drift_regressions = [item for item in drift if item["effect"] == "regresses"]
        production_safe = (
            bool(drift)
            and len(drift_improvements) == len(drift)
            and not guard_regressions
            and not drift_regressions
            and strategy_id not in {"tail_shrink_to_expected_open", "pause_adjusted"}
        )
        summaries.append(
            {
                "strategyID": strategy_id,
                "strategyVersion": version,
                "strategyName": name,
                "scoreableRows": len(scoreable),
                "notScoreableRows": len(rows) - len(scoreable),
                "passRows": sum(1 for item in scoreable if item["status"] == "pass"),
                "temporaryPassRows": sum(
                    1 for item in scoreable if item["status"] == "temporary pass"
                ),
                "failRows": sum(1 for item in scoreable if item["status"] == "fail"),
                "driftRowsImproved": len(drift_improvements),
                "driftRowsRegressed": len(drift_regressions),
                "guardRowsRegressed": len(guard_regressions),
                "specialRowsRegressed": sum(1 for item in special if item["effect"] == "regresses"),
                "productionSafe": production_safe,
                "productionAssessment": production_assessment(strategy_id, production_safe),
            }
        )
    return summaries


def production_assessment(strategy_id: str, production_safe: bool) -> str:
    if production_safe:
        return "research candidate only; still requires human review before any app change"
    if strategy_id == "tail_shrink_to_expected_open":
        return "not production-safe because it uses Apple Fitness/manual expected Open as an oracle"
    if strategy_id == "pause_adjusted":
        return "not scoreable from current packet data"
    return "not production-safe from this scorecard"


def table(headers: list[str], rows: list[list[str]]) -> str:
    widths = [len(header) for header in headers]
    for row in rows:
        for index, cell in enumerate(row):
            widths[index] = max(widths[index], len(cell))
    lines = [
        "| " + " | ".join(header.ljust(widths[index]) for index, header in enumerate(headers)) + " |",
        "| " + " | ".join("-" * widths[index] for index in range(len(headers))) + " |",
    ]
    for row in rows:
        lines.append(
            "| " + " | ".join(cell.ljust(widths[index]) for index, cell in enumerate(row)) + " |"
        )
    return "\n".join(lines)


def compact_result_rows(results: list[dict[str, Any]], dates: set[str]) -> list[dict[str, Any]]:
    wanted = [
        "current_baseline",
        "interpolated_crossing",
        "previous_sample_end",
        "next_sample_end",
        "final_distance_sample_anchored",
        "tail_shrink_to_expected_open",
    ]
    return [
        item
        for item in results
        if item["workoutDate"] in dates
        and item["strategyID"] in wanted
        and item["status"] != "not scoreable"
    ]


def result_table(results: list[dict[str, Any]]) -> str:
    rows = []
    for item in sorted(
        results,
        key=lambda value: (
            value["workoutDate"],
            value["rowNumber"],
            value["strategyID"],
        ),
    ):
        rows.append(
            [
                item["workoutDate"],
                item["rowLabel"],
                item["strategyID"],
                number_text(item["candidatePredictedDistanceMeters"], "m"),
                seconds_text(item["candidatePredictedTimeSeconds"]),
                signed_text(item["candidateDistanceDeltaMeters"], "m"),
                signed_text(item["candidateTimeDeltaSeconds"], "s"),
                signed_text(item["candidateChangeDistanceMeters"], "m"),
                signed_text(item["candidateChangeTimeSeconds"], "s"),
                item["status"],
                item["effect"],
            ]
        )
    return table(
        [
            "Date",
            "Row",
            "Strategy",
            "Pred distance",
            "Pred time",
            "Dist delta",
            "Time delta",
            "Dist change",
            "Time change",
            "Status",
            "Effect",
        ],
        rows,
    )


def write_markdown(
    summaries: list[dict[str, Any]],
    results: list[dict[str, Any]],
    not_scoreable: list[dict[str, Any]],
) -> None:
    lines: list[str] = []
    lines.append("# Candidate Boundary Strategy Scorecard")
    lines.append("")
    lines.append("Generated: 2026-06-12")
    lines.append("")
    lines.append(
        "This is a docs/debug-only research scorecard. It reads the Apple Fitness parity fixture and archived RunSignal parity packets. It does not change production interval reconstruction, boundary logic, or normal workout UI."
    )
    lines.append("")
    lines.append("## Summary By Strategy")
    lines.append("")
    lines.append(
        table(
            [
                "Strategy",
                "Scoreable",
                "Not scoreable",
                "Pass",
                "Temp",
                "Fail",
                "Drift improved",
                "Guard regressed",
                "Production assessment",
            ],
            [
                [
                    item["strategyID"],
                    str(item["scoreableRows"]),
                    str(item["notScoreableRows"]),
                    str(item["passRows"]),
                    str(item["temporaryPassRows"]),
                    str(item["failRows"]),
                    str(item["driftRowsImproved"]),
                    str(item["guardRowsRegressed"]),
                    item["productionAssessment"],
                ]
                for item in summaries
            ],
        )
    )
    lines.append("")
    lines.append("No candidate is approved for production from this scorecard. The scorer is intentionally conservative: a strategy must improve drift cases without regressing guard fixtures, and Apple Fitness/manual-oracle strategies are not production-safe.")
    lines.append("")
    lines.append("## Drift Cases")
    lines.append("")
    lines.append("May 26, June 1, and June 12 are the fixed-distance Work plus real Open / Extra drift cases. April 28 is excluded from approval scoring.")
    lines.append("")
    lines.append(result_table(compact_result_rows(results, DRIFT_DATES)))
    lines.append("")
    lines.append("## Pass-Case Guards")
    lines.append("")
    lines.append("June 2 and June 4 are simple Work + Open guard fixtures. June 2 is a temporary pass with exact packet values; June 4 is a pass.")
    lines.append("")
    lines.append(result_table(compact_result_rows(results, GUARD_DATES)))
    lines.append("")
    lines.append("## Special Fixtures")
    lines.append("")
    lines.append("June 3 is a planned open cooldown regression fixture with repeated intervals. June 5 has warmup/cooldown distance-time caveats. These rows are scored for visibility, but they are not simple Work + Open drift approval cases.")
    lines.append("")
    lines.append(result_table(compact_result_rows(results, SPECIAL_DATES)))
    lines.append("")
    lines.append("## Evidence Recovery")
    lines.append("")
    lines.append("April 28 is included as an evidence-recovery / single-tail summary and excluded from production approval scoring. It confirms fresh physical-device evidence recovery, not a repeated boundary tuning rule.")
    lines.append("")
    lines.append(result_table(compact_result_rows(results, APPROVAL_EXCLUDED_DATES)))
    lines.append("")
    lines.append("## Not Scoreable")
    lines.append("")
    lines.append(
        table(
            ["Strategy", "Reason", "Rows", "Examples"],
            [
                [
                    item["strategyID"],
                    item["reason"],
                    str(item["count"]),
                    "; ".join(item["examples"]),
                ]
                for item in not_scoreable
            ],
        )
    )
    lines.append("")
    lines.append("## Recommendation")
    lines.append("")
    lines.append("- Do not change production boundary behavior yet.")
    lines.append("- Do not promote WorkoutKit reconstructed intervals into normal workout UI from this scorecard alone.")
    lines.append("- Use the scorecard to decide which candidate, if any, deserves a later debug-only implementation experiment with explicit guard preservation.")
    lines.append("- Rollback note: remove this scorer and generated scorecard files to revert the research tooling; app behavior is unaffected.")
    lines.append("")
    MARKDOWN_REPORT.write_text("\n".join(lines) + "\n")


def write_json(
    summaries: list[dict[str, Any]],
    results: list[dict[str, Any]],
    not_scoreable: list[dict[str, Any]],
) -> None:
    payload = {
        "generated": "2026-06-12",
        "scope": "docs/debug-only",
        "productionBehaviorChanged": False,
        "normalWorkoutUIChanged": False,
        "boundaryLogicChanged": False,
        "strategies": summaries,
        "results": results,
        "notScoreable": not_scoreable,
        "recommendation": "No production boundary behavior changes yet.",
    }
    JSON_REPORT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def main() -> int:
    results, not_scoreable = score_rows()
    summaries = strategy_summary(results)
    write_markdown(summaries, results, not_scoreable)
    write_json(summaries, results, not_scoreable)
    print(f"Wrote {MARKDOWN_REPORT.relative_to(ROOT)}")
    print(f"Wrote {JSON_REPORT.relative_to(ROOT)}")
    if any(item["productionSafe"] for item in summaries):
        print("At least one strategy needs human review before any production change.")
    else:
        print("No strategy is production-safe from this scorecard.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
