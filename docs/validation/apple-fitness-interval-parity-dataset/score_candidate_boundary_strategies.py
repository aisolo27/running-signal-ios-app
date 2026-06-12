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
ACTIVITY_MARKDOWN_REPORT = ROOT / "hkworkoutactivity-boundary-scorecard.md"
ACTIVITY_JSON_REPORT = ROOT / "hkworkoutactivity-boundary-scorecard.json"

STRATEGIES = [
    ("current_baseline", "v1", "current / baseline crossing sample end"),
    ("hkworkoutactivity_boundary", "v1", "HKWorkoutActivity boundary"),
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

FIT_REFERENCE = {
    ("2026-04-28", 1): (7258.0, 2772.0, "FIT lap"),
    ("2026-04-28", 2): (46.81, 20.0, "FIT inferred tail"),
    ("2026-05-26", 1): (6457.0, 2531.0, "FIT lap"),
    ("2026-05-26", 2): (94.01, 41.0, "FIT inferred tail"),
    ("2026-06-01", 1): (6458.0, 2564.0, "FIT lap"),
    ("2026-06-01", 2): (5.14, 7.0, "FIT inferred tail"),
    ("2026-06-02", 1): (5651.0, 2175.0, "FIT lap"),
    ("2026-06-02", 2): (57.71, 28.0, "FIT inferred tail"),
    ("2026-06-03", 1): (2000.0, 767.0, "FIT lap"),
    ("2026-06-03", 2): (1000.0, 252.0, "FIT lap"),
    ("2026-06-03", 3): (210.0, 149.0, "FIT lap"),
    ("2026-06-03", 4): (1000.0, 246.0, "FIT lap"),
    ("2026-06-03", 5): (207.0, 150.0, "FIT lap"),
    ("2026-06-03", 6): (1000.0, 240.0, "FIT lap"),
    ("2026-06-03", 7): (197.0, 150.0, "FIT lap"),
    ("2026-06-03", 8): (1031.0, 382.0, "FIT lap"),
    ("2026-06-04", 1): (5657.0, 2196.0, "FIT lap"),
    ("2026-06-04", 2): (44.78, 21.0, "FIT inferred tail"),
    ("2026-06-05", 1): (2000.0, 750.0, "FIT lap"),
    ("2026-06-05", 2): (2000.0, 510.0, "FIT lap"),
    ("2026-06-05", 3): (2497.0, 876.0, "FIT lap"),
    ("2026-06-05", 4): (465.24, 160.0, "FIT inferred tail"),
    ("2026-06-12", 1): (5008.0, 1923.0, "FIT lap"),
    ("2026-06-12", 2): (36.87, 17.0, "FIT inferred tail"),
}


@dataclass
class PacketRow:
    date: str
    workout: dict[str, Any]
    interval: dict[str, Any]
    next_interval: dict[str, Any] | None
    packet: dict[str, Any] | None = None


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


def distance_text(value: float | None) -> str:
    if value is None:
        return "n/a"
    if abs(value) >= 1000:
        return f"{value / 1000:.3f} km"
    return f"{value:.1f} m"


def row_reference_text(distance: float | None, duration: float | None) -> str:
    return f"{distance_text(distance)} / {seconds_text(duration)}"


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

    if strategy_id == "hkworkoutactivity_boundary":
        return activity_boundary_prediction(row, packet_row)

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


def normalized_label(label: str | None) -> str:
    if not label:
        return ""
    lowered = label.lower().replace("/", " ")
    return lowered.split()[0] if lowered.split() else ""


def activity_distance(activity: dict[str, Any]) -> float | None:
    for statistic in activity.get("statistics", []):
        if statistic.get("quantityType") == "HKQuantityTypeIdentifierDistanceWalkingRunning":
            value = statistic.get("sum")
            return float(value) if value is not None else None
    return None


def planned_steps(packet: dict[str, Any]) -> list[dict[str, Any]]:
    return packet.get("workoutKitPlanAudit", {}).get("plannedSteps", [])


def activity_mapping(
    fixture_workout: dict[str, Any],
    packet: dict[str, Any] | None,
) -> tuple[list[dict[str, Any]] | None, str | None]:
    if not packet:
        return None, "archived parity packet is missing"

    activities = packet.get("workoutActivities", [])
    steps = planned_steps(packet)
    rows = fixture_workout["rows"]

    if not steps:
        return None, "WorkoutKit planned steps are missing"
    if not activities:
        return None, "HKWorkoutActivity rows are missing"
    if len(activities) != len(steps):
        return None, (
            f"activity count {len(activities)} does not match planned step count {len(steps)}"
        )
    if len(rows) not in {len(steps), len(steps) + 1}:
        return None, (
            f"fixture row count {len(rows)} is incompatible with planned step count {len(steps)}"
        )

    for index, (activity, step, row) in enumerate(zip(activities, steps, rows), start=1):
        activity_start = activity.get("startOffsetSeconds")
        activity_end = activity.get("endOffsetSeconds")
        if activity_start is None or activity_end is None:
            return None, f"activity {index} is missing start/end offsets"
        if float(activity_end) <= float(activity_start):
            return None, f"activity {index} has a non-positive duration"
        if index > 1:
            previous_end = float(activities[index - 2]["endOffsetSeconds"])
            if abs(float(activity_start) - previous_end) > 1.0:
                return None, f"activity {index} is not contiguous with the prior activity"

        step_label = normalized_label(step.get("label"))
        row_label = normalized_label(row.get("expectedLabel"))
        if step_label and row_label and step_label != row_label:
            return None, (
                f"planned step {index} label {step.get('label')} does not match fixture row {row.get('expectedLabel')}"
            )

    if len(rows) == len(steps) + 1 and normalized_label(rows[-1].get("expectedLabel")) != "open":
        return None, "extra fixture row is not an Open / Extra tail"

    return activities, None


def activity_boundary_prediction(
    row: dict[str, Any],
    packet_row: PacketRow,
) -> tuple[float | None, float | None, str | None]:
    activities, reason = activity_mapping(packet_row.workout, packet_row.packet)
    if reason:
        return None, None, reason
    assert activities is not None

    row_index = int(row["row"]) - 1
    if row_index >= len(activities):
        return None, None, "Open tail must be scored from the previous activity row"

    activity = activities[row_index]
    distance = activity_distance(activity)
    duration = activity.get("durationSeconds")
    if distance is None:
        return None, None, f"activity {row_index + 1} is missing distance statistics"
    if duration is None:
        return None, None, f"activity {row_index + 1} is missing duration"
    return distance, float(duration), None


def activity_open_tail_prediction(
    row: dict[str, Any],
    previous_row: dict[str, Any],
    previous_packet_row: PacketRow | None,
) -> tuple[float | None, float | None, str | None]:
    if not previous_packet_row:
        return None, None, "requires the previous planned row packet data"

    activities, reason = activity_mapping(previous_packet_row.workout, previous_packet_row.packet)
    if reason:
        return None, None, reason
    assert activities is not None

    row_index = int(row["row"]) - 1
    if row_index != len(activities):
        return None, None, "Open tail is only allowed after all mapped activity rows"

    packet = previous_packet_row.packet or {}
    workout = packet.get("workout", {})
    workout_distance = workout.get("distanceMeters")
    workout_duration = workout.get("durationSeconds")
    if workout_distance is None or workout_duration is None:
        return None, None, "workout total distance or duration is missing"

    last_activity = activities[-1]
    last_activity_end = last_activity.get("endOffsetSeconds")
    if last_activity_end is None:
        return None, None, "final activity end offset is missing"

    total_activity_distance = 0.0
    for index, activity in enumerate(activities, start=1):
        distance = activity_distance(activity)
        if distance is None:
            return None, None, f"activity {index} is missing distance statistics"
        total_activity_distance += distance

    distance = float(workout_distance) - total_activity_distance
    duration = float(workout_duration) - float(last_activity_end)
    if distance < -0.5 or duration < -0.5:
        return None, None, "final Open tail would be negative"
    return max(0.0, distance), max(0.0, duration), None


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

    if strategy_id == "hkworkoutactivity_boundary":
        return activity_open_tail_prediction(row, previous_row, previous_packet_row)

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
            if packet_rows[-1]:
                packet_rows[-1].packet = packet

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
                    "fitReferenceDistanceMeters": FIT_REFERENCE.get((workout["date"], row["row"]), (None, None, None))[0],
                    "fitReferenceTimeSeconds": FIT_REFERENCE.get((workout["date"], row["row"]), (None, None, None))[1],
                    "fitReferenceSource": FIT_REFERENCE.get((workout["date"], row["row"]), (None, None, None))[2],
                    "candidateDeltaVsFITDistanceMeters": (
                        distance - float(FIT_REFERENCE[(workout["date"], row["row"])][0])
                        if distance is not None and (workout["date"], row["row"]) in FIT_REFERENCE
                        else None
                    ),
                    "candidateDeltaVsFITTimeSeconds": (
                        duration - float(FIT_REFERENCE[(workout["date"], row["row"])][1])
                        if duration is not None and (workout["date"], row["row"]) in FIT_REFERENCE
                        else None
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
            and strategy_id
            not in {"tail_shrink_to_expected_open", "pause_adjusted", "hkworkoutactivity_boundary"}
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
    if strategy_id == "hkworkoutactivity_boundary":
        return "debug-only lead; not production-safe until more guard data and fallback rules are validated"
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
        "hkworkoutactivity_boundary",
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


def activity_results(results: list[dict[str, Any]]) -> list[dict[str, Any]]:
    return [item for item in results if item["strategyID"] == "hkworkoutactivity_boundary"]


def activity_summary_by_fixture(results: list[dict[str, Any]]) -> list[dict[str, Any]]:
    output = []
    for date in sorted({item["workoutDate"] for item in results}):
        rows = [item for item in results if item["workoutDate"] == date]
        scoreable = [item for item in rows if item["status"] != "not scoreable"]
        output.append(
            {
                "workoutDate": date,
                "fixtureGroup": fixture_group(date),
                "rows": len(rows),
                "scoreableRows": len(scoreable),
                "passRows": sum(1 for item in scoreable if item["status"] == "pass"),
                "temporaryPassRows": sum(
                    1 for item in scoreable if item["status"] == "temporary pass"
                ),
                "failRows": sum(1 for item in scoreable if item["status"] == "fail"),
                "improvedRows": sum(1 for item in scoreable if item["effect"] == "improves"),
                "preservedRows": sum(1 for item in scoreable if item["effect"] == "preserves"),
                "regressedRows": sum(1 for item in scoreable if item["effect"] == "regresses"),
                "scoreability": (
                    "scoreable"
                    if len(scoreable) == len(rows)
                    else "; ".join(
                        sorted(
                            {
                                item["notScoreableReason"]
                                for item in rows
                                if item["status"] == "not scoreable"
                            }
                        )
                    )
                ),
            }
        )
    return output


def activity_result_table(results: list[dict[str, Any]], dates: set[str]) -> str:
    rows = []
    for item in sorted(
        [value for value in results if value["workoutDate"] in dates],
        key=lambda value: (value["workoutDate"], value["rowNumber"]),
    ):
        rows.append(
            [
                item["workoutDate"],
                item["rowLabel"],
                item["fixtureGroup"],
                row_reference_text(
                    item["currentRunSignalDistanceMeters"],
                    item["currentRunSignalTimeSeconds"],
                ),
                row_reference_text(
                    item["candidatePredictedDistanceMeters"],
                    item["candidatePredictedTimeSeconds"],
                ),
                row_reference_text(
                    item["appleExpectedDistanceMeters"],
                    item["appleExpectedTimeSeconds"],
                ),
                row_reference_text(
                    item["fitReferenceDistanceMeters"],
                    item["fitReferenceTimeSeconds"],
                )
                + (f" ({item['fitReferenceSource']})" if item["fitReferenceSource"] else ""),
                f"{signed_text(item['candidateDistanceDeltaMeters'], 'm')} / {signed_text(item['candidateTimeDeltaSeconds'], 's')}",
                f"{signed_text(item['candidateDeltaVsFITDistanceMeters'], 'm')} / {signed_text(item['candidateDeltaVsFITTimeSeconds'], 's')}",
                f"{signed_text(item['candidateChangeDistanceMeters'], 'm')} / {signed_text(item['candidateChangeTimeSeconds'], 's')}",
                item["status"],
                item["notScoreableReason"] or "activity count/order reconciled to planned steps",
                item["effect"],
            ]
        )
    return table(
        [
            "Date",
            "Row",
            "Class",
            "Current RunSignal",
            "Activity candidate",
            "Apple/manual",
            "FIT/debug",
            "Delta vs Apple",
            "Delta vs FIT",
            "Change vs current",
            "Status",
            "Scoreability",
            "Effect",
        ],
        rows,
    )


def activity_date_read(results: list[dict[str, Any]], date: str) -> str:
    rows = [item for item in results if item["workoutDate"] == date]
    if not rows:
        return "not scored"
    if any(item["status"] == "not scoreable" for item in rows):
        return "not scoreable"
    effects = {item["effect"] for item in rows}
    statuses = {item["status"] for item in rows}
    if effects == {"improves"}:
        effect = "improved"
    elif "regresses" in effects:
        effect = "regressed"
    elif "improves" in effects:
        effect = "mixed/improved"
    else:
        effect = "preserved"
    return f"{effect}; statuses: {', '.join(sorted(statuses))}"


def write_activity_markdown(
    summaries: list[dict[str, Any]],
    results: list[dict[str, Any]],
) -> None:
    activity = activity_results(results)
    summary_rows = activity_summary_by_fixture(activity)
    candidate_summary = next(
        item for item in summaries if item["strategyID"] == "hkworkoutactivity_boundary"
    )

    lines: list[str] = []
    lines.append("# HKWorkoutActivity Boundary Scorecard")
    lines.append("")
    lines.append("Generated: 2026-06-12")
    lines.append("")
    lines.append("## Executive Summary")
    lines.append("")
    lines.append(
        "`hkworkoutactivity_boundary` improves the May 26, June 1, and June 12 drift fixtures. It preserves/improves June 2, but June 4 drops from the current preferred pass to a temporary pass on the Work row, so guard preservation is not fully proven. It handles the structured June 3 interval fixture by planned-step order but regresses three rows by status/error score, and it handles the June 5 Warmup/Work/Cooldown rows plus inferred final Open tail. April 28 is included only as an evidence-recovery/single-tail reference. The extra June 3 short run is excluded from production approval scoring."
    )
    lines.append("")
    lines.append(
        "Production behavior remains unchanged. This scorecard is docs/debug-only and does not use FIT or Apple Fitness/manual rows as runtime logic."
    )
    lines.append("")
    lines.append(
        "Implementation follow-up: Raw HealthKit Debug and parity packet exports now include the same candidate as diagnostics/export-only fields: `activityBoundaryCandidateSummary` and `activityBoundaryCandidateIntervals`. These fields sit beside current `reconstructedIntervals`, report mapping status and count/order reconciliation, include direct activity rows and inferred final Open / Extra tails, and repeat that the rows are not production UI."
    )
    lines.append("")
    lines.append(
        "Latest physical-device export pass: the active fixture packets and Raw HealthKit Debug markdown exports were regenerated from the iPhone and archived under each fixture's `exports/runsignal-diagnostics/` folder. All active parity packets include `activityBoundaryCandidateSummary` and `activityBoundaryCandidateIntervals`; the second June 3 short run is archived under `_nonfixture-exports/2026-06-03-short-run/` and remains excluded from production approval scoring."
    )
    lines.append("")
    lines.append("## Activity-Boundary Strategy Definition")
    lines.append("")
    lines.append("- Strategy id: `hkworkoutactivity_boundary`.")
    lines.append("- Map `HKWorkout.workoutActivities` rows to `WorkoutKit` planned step order only when activity count and fixture row order reconcile with the planned steps.")
    lines.append("- For mapped planned rows, score the public activity duration and `DistanceWalkingRunning` statistic.")
    lines.append("- For a final Open / Extra tail, infer distance and time from workout total minus the mapped planned activities and final activity end.")
    lines.append("- Missing activities, count mismatch, out-of-order windows, incompatible labels, or negative inferred tails are marked not scoreable; no silent fallback is used for this score.")
    lines.append("- FIT rows and Apple Fitness/manual rows are comparison references only, never runtime inputs.")
    lines.append("")
    lines.append("## Summary Table By Fixture")
    lines.append("")
    lines.append(
        table(
            [
                "Date",
                "Class",
                "Scoreable",
                "Pass",
                "Temp",
                "Fail",
                "Improved",
                "Preserved",
                "Regressed",
                "Read",
            ],
            [
                [
                    item["workoutDate"],
                    item["fixtureGroup"],
                    f"{item['scoreableRows']}/{item['rows']}",
                    str(item["passRows"]),
                    str(item["temporaryPassRows"]),
                    str(item["failRows"]),
                    str(item["improvedRows"]),
                    str(item["preservedRows"]),
                    str(item["regressedRows"]),
                    item["scoreability"],
                ]
                for item in summary_rows
            ],
        )
    )
    lines.append("")
    lines.append("## Drift-Case Results")
    lines.append("")
    lines.append(activity_result_table(activity, DRIFT_DATES))
    lines.append("")
    lines.append("## Guard-Case Results")
    lines.append("")
    lines.append(activity_result_table(activity, GUARD_DATES))
    lines.append("")
    lines.append("## Special Fixture Results")
    lines.append("")
    lines.append(
        "June 3 is scored as an eight-row structured workout, not as a simple Work + Open case. June 5 maps three activity rows to Warmup, Work, and Cooldown, then infers final Open from workout end."
    )
    lines.append("")
    lines.append(activity_result_table(activity, SPECIAL_DATES))
    lines.append("")
    lines.append("## April 28 Evidence-Recovery Note")
    lines.append("")
    lines.append(
        "April 28 is excluded from production approval scoring. It remains useful as a recovered-evidence, single-tail reference showing one activity mapped to Work and an inferred final Open tail."
    )
    lines.append("")
    lines.append(activity_result_table(activity, APPROVAL_EXCLUDED_DATES))
    lines.append("")
    lines.append("## Nonfixture June 3 Short-Run Note")
    lines.append("")
    lines.append(
        "`_nonfixture-exports/2026-06-03-short-run/` remains excluded. It is a second June 3 short run with no active fixture rows or production approval role, so this scorer does not include it in the scorecard."
    )
    lines.append("")
    lines.append("## Comparison Against Existing Scorecard Strategies")
    lines.append("")
    lines.append(
        "The existing scorecard still blocks previous candidates: `next_sample_end` improves drift rows but regresses guard rows, `tail_shrink_to_expected_open` uses manual Apple Fitness expected Open as an oracle, and pause-adjusted scoring is unavailable from the packets. `hkworkoutactivity_boundary` is the strongest public-API lead because it uses public `HKWorkoutActivity` windows and does not require FIT or Apple Fitness/manual values at runtime."
    )
    lines.append("")
    lines.append(
        table(
            [
                "Strategy",
                "Scoreable",
                "Pass",
                "Temp",
                "Fail",
                "Drift improved",
                "Guard regressed",
                "Special regressed",
                "Production assessment",
            ],
            [
                [
                    item["strategyID"],
                    str(item["scoreableRows"]),
                    str(item["passRows"]),
                    str(item["temporaryPassRows"]),
                    str(item["failRows"]),
                    str(item["driftRowsImproved"]),
                    str(item["guardRowsRegressed"]),
                    str(item["specialRowsRegressed"]),
                    item["productionAssessment"],
                ]
                for item in summaries
            ],
        )
    )
    lines.append("")
    lines.append("## Production Assessment")
    lines.append("")
    lines.append(
        f"Production experiment justified: no. The candidate improved drift fixtures ({activity_date_read(activity, '2026-05-26')}; {activity_date_read(activity, '2026-06-01')}; {activity_date_read(activity, '2026-06-12')}) and preserved/improved June 2, but June 4 regressed from current pass to temporary pass ({activity_date_read(activity, '2026-06-04')}). June 3 also has three status/error-score regressions. The safest next step is a debug-only prototype or more guard collection, not production boundary replacement."
    )
    lines.append("")
    lines.append(
        f"Scorecard assessment for `{candidate_summary['strategyID']}`: {candidate_summary['productionAssessment']}."
    )
    lines.append("")
    lines.append(
        "Export prototype assessment: useful for future physical-device evidence review only. It does not change current reconstruction, fixed-distance boundary logic, normal workout UI, or production approval status."
    )
    lines.append("")
    lines.append("## Explicit Risks And Rollback Notes")
    lines.append("")
    lines.append("- Activity labels are generic and must be mapped from WorkoutKit planned-step order; ambiguous mapping remains a production blocker.")
    lines.append("- Current guard coverage is only June 2 and June 4 for simple fixed-distance Work + Open tails; collect more pass/guard examples before any production experiment.")
    lines.append("- Activity statistics may not be available for every workout or OS/export path; missing or count-mismatched activities must fall back to current app behavior in any future prototype.")
    lines.append("- FIT and Apple Fitness/manual values stay docs/debug comparison references only.")
    lines.append("- Rollback: remove this scoring branch/report generation; production app behavior is unaffected because no Swift or reconstruction logic changed.")
    lines.append("")
    ACTIVITY_MARKDOWN_REPORT.write_text("\n".join(lines) + "\n")


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


def write_activity_json(
    summaries: list[dict[str, Any]],
    results: list[dict[str, Any]],
) -> None:
    activity = activity_results(results)
    payload = {
        "generated": "2026-06-12",
        "scope": "docs/debug-only",
        "strategyID": "hkworkoutactivity_boundary",
        "strategyDefinition": {
            "mappedRows": "Use HKWorkoutActivity rows only when activity count and order reconcile with WorkoutKit planned steps.",
            "tailRows": "Infer final Open / Extra from workout total minus mapped planned activities and final activity end.",
            "fallbackPolicy": "No silent fallback in this scorecard; incompatible rows are not scoreable.",
            "runtimeTruth": "HealthKit/WorkoutKit only; FIT and Apple Fitness/manual rows are comparison references only.",
        },
        "archivedPhysicalDeviceExports": {
            "activeFixtureCount": 8,
            "rawHealthKitDebugMarkdownCount": 8,
            "parityPacketJSONCount": 8,
            "allActivePacketsIncludeActivityBoundaryCandidateSummary": True,
            "allActivePacketsIncludeActivityBoundaryCandidateIntervals": True,
            "nonfixtureExports": [
                {
                    "path": "_nonfixture-exports/2026-06-03-short-run/",
                    "rawHealthKitDebugMarkdownCount": 1,
                    "parityPacketJSONCount": 1,
                    "includedInProductionApprovalScoring": False,
                }
            ],
        },
        "productionBehaviorChanged": False,
        "normalWorkoutUIChanged": False,
        "boundaryLogicChanged": False,
        "swiftSourceChanged": False,
        "summaryByFixture": activity_summary_by_fixture(activity),
        "strategySummary": next(
            item for item in summaries if item["strategyID"] == "hkworkoutactivity_boundary"
        ),
        "results": activity,
        "nonfixtureJune3ShortRun": {
            "path": "_nonfixture-exports/2026-06-03-short-run/",
            "includedInProductionApprovalScoring": False,
            "reason": "second June 3 short run; no active fixture rows",
        },
        "productionAssessment": "No production experiment yet; guard preservation is not fully proven and more guard examples are needed.",
    }
    ACTIVITY_JSON_REPORT.write_text(json.dumps(payload, indent=2, sort_keys=True) + "\n")


def main() -> int:
    results, not_scoreable = score_rows()
    summaries = strategy_summary(results)
    write_markdown(summaries, results, not_scoreable)
    write_json(summaries, results, not_scoreable)
    write_activity_markdown(summaries, results)
    write_activity_json(summaries, results)
    print(f"Wrote {MARKDOWN_REPORT.relative_to(ROOT)}")
    print(f"Wrote {JSON_REPORT.relative_to(ROOT)}")
    print(f"Wrote {ACTIVITY_MARKDOWN_REPORT.relative_to(ROOT)}")
    print(f"Wrote {ACTIVITY_JSON_REPORT.relative_to(ROOT)}")
    if any(item["productionSafe"] for item in summaries):
        print("At least one strategy needs human review before any production change.")
    else:
        print("No strategy is production-safe from this scorecard.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
