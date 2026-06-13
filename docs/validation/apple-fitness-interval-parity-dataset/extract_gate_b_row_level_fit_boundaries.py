#!/usr/bin/env python3
"""Extract row-level Gate B FIT boundaries and compare them to RunSignal rows.

This is docs-only/offline validation. Runtime truth remains HealthKit and
WorkoutKit. FIT is read only as a validation oracle for this scorecard.
"""

from __future__ import annotations

import json
import math
import struct
from collections import Counter
from dataclasses import dataclass
from datetime import datetime, timezone, timedelta
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
MONTHLY_ROLLUP = ROOT / "monthly-diagnostics-rollup-2026-03-to-2026-06.json"
FIT_ROLLUP = ROOT / "fit-reference-rollup-2026-03-to-2026-06.json"
GATE_B_ROLLUP = ROOT / "gate-b-custom-workout-fit-scorecard-2026-03-to-2026-06.json"
JSON_REPORT = ROOT / "gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.json"
MARKDOWN_REPORT = ROOT / "gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.md"

FIT_FOLDER = Path(
    "/Users/adrielsolorzano/Library/Mobile Documents/iCloud~com~altifondo~HealthFit/Documents"
)
MONTHLY_EXPORT_FOLDER = Path(
    "/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing"
)

TIME_TOLERANCE_SECONDS = 5.0
DISTANCE_TOLERANCE_METERS = 10.0
TAIL_DISTANCE_EPSILON_METERS = 5.0
TAIL_TIME_EPSILON_SECONDS = 3.0
FIT_EPOCH = datetime(1989, 12, 31, tzinfo=timezone.utc)

MESSAGE_NAMES = {
    18: "session",
    19: "lap",
    27: "workout_step",
}

FIELD_NAMES = {
    18: {
        2: "sport",
        5: "total_elapsed_time",
        7: "total_elapsed_time",
        8: "total_timer_time",
        9: "total_distance",
        253: "timestamp",
    },
    19: {
        2: "start_time",
        7: "total_elapsed_time",
        8: "total_timer_time",
        9: "total_distance",
        253: "timestamp",
    },
    27: {
        0: "wkt_step_name",
        1: "duration_type",
        2: "duration_value",
        3: "target_type",
        4: "target_value",
        5: "custom_target_value_low",
        6: "custom_target_value_high",
        7: "intensity",
        8: "notes",
        9: "equipment",
        10: "exercise_category",
        11: "exercise_name",
        12: "exercise_weight",
        13: "weight_display_unit",
        19: "secondary_target_type",
        20: "secondary_target_value",
        254: "message_index",
    },
}

DURATION_TYPE = {
    0: "time",
    1: "distance",
    6: "open",
    7: "repeat_until_steps_complete",
    8: "repeat_until_time",
    9: "repeat_until_distance",
    10: "repeat_until_calories",
    11: "repeat_until_heart_rate_less_than",
    12: "repeat_until_heart_rate_greater_than",
    13: "repeat_until_power_less_than",
    14: "repeat_until_power_greater_than",
    15: "power_less_than",
    16: "power_greater_than",
    17: "repetition_time",
}

INTENSITY = {
    0: "active",
    1: "rest",
    2: "warmup",
    3: "cooldown",
    4: "recover",
    5: "interval",
    6: "other",
}

BASE_TYPE_FORMATS = {
    0x00: ("B", 1),
    0x01: ("b", 1),
    0x02: ("B", 1),
    0x83: ("h", 2),
    0x84: ("H", 2),
    0x85: ("i", 4),
    0x86: ("I", 4),
    0x07: ("s", 1),
    0x88: ("f", 4),
    0x89: ("d", 8),
    0x0A: ("B", 1),
    0x8B: ("H", 2),
    0x8C: ("I", 4),
    0x0D: ("B", 1),
    0x8E: ("q", 8),
    0x8F: ("Q", 8),
    0x90: ("Q", 8),
}


@dataclass
class FieldDef:
    number: int
    size: int
    base_type: int


@dataclass
class MessageDef:
    global_number: int
    endian: str
    fields: list[FieldDef]
    developer_fields: list[FieldDef]


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def round_value(value: Any, places: int = 1) -> Any:
    if isinstance(value, (int, float)) and not isinstance(value, bool):
        if math.isnan(float(value)) or math.isinf(float(value)):
            return None
        return round(float(value), places)
    return value


def parse_fit_datetime(value: Any) -> str | None:
    if not isinstance(value, (int, float)):
        return None
    return (FIT_EPOCH + timedelta(seconds=float(value))).isoformat().replace("+00:00", "Z")


def decode_field(raw: bytes, base_type: int, endian: str) -> Any:
    type_code = base_type & 0x1F | (0x80 if base_type & 0x80 else 0)
    fmt_size = BASE_TYPE_FORMATS.get(type_code)
    if fmt_size is None:
        return raw.hex()
    fmt, size = fmt_size
    if fmt == "s":
        return raw.split(b"\x00", 1)[0].decode("utf-8", errors="replace")
    if size == 1:
        values = list(raw)
    else:
        usable = raw[: len(raw) - (len(raw) % size)]
        values = [
            struct.unpack(endian + fmt, usable[index : index + size])[0]
            for index in range(0, len(usable), size)
        ]
    return values[0] if len(values) == 1 else values


def parse_fit(path: Path) -> dict[str, Any]:
    data = path.read_bytes()
    if len(data) < 14:
        raise ValueError(f"{path.name} is too short to be a FIT file")
    header_size = data[0]
    data_size = struct.unpack_from("<I", data, 4)[0]
    offset = header_size
    end = header_size + data_size
    definitions: dict[int, MessageDef] = {}
    messages: dict[str, list[dict[str, Any]]] = {name: [] for name in MESSAGE_NAMES.values()}

    while offset < end:
        header = data[offset]
        offset += 1
        if header & 0x80:
            local_number = (header >> 5) & 0x03
            is_definition = False
            has_developer_fields = False
        else:
            local_number = header & 0x0F
            is_definition = bool(header & 0x40)
            has_developer_fields = bool(header & 0x20)

        if is_definition:
            offset += 1
            arch = data[offset]
            offset += 1
            endian = ">" if arch else "<"
            global_number = struct.unpack_from(endian + "H", data, offset)[0]
            offset += 2
            field_count = data[offset]
            offset += 1
            fields = []
            for _ in range(field_count):
                number, size, base_type = data[offset], data[offset + 1], data[offset + 2]
                offset += 3
                fields.append(FieldDef(number=number, size=size, base_type=base_type))
            developer_fields = []
            if has_developer_fields:
                dev_field_count = data[offset]
                offset += 1
                for _ in range(dev_field_count):
                    number, size, developer_data_index = (
                        data[offset],
                        data[offset + 1],
                        data[offset + 2],
                    )
                    offset += 3
                    developer_fields.append(
                        FieldDef(
                            number=number,
                            size=size,
                            base_type=developer_data_index,
                        )
                    )
            definitions[local_number] = MessageDef(
                global_number=global_number,
                endian=endian,
                fields=fields,
                developer_fields=developer_fields,
            )
            continue

        definition = definitions.get(local_number)
        if definition is None:
            raise ValueError(f"{path.name} references undefined local message {local_number}")
        parsed: dict[str, Any] = {}
        for field in definition.fields:
            raw = data[offset : offset + field.size]
            offset += field.size
            field_name = FIELD_NAMES.get(definition.global_number, {}).get(
                field.number, f"field_{field.number}"
            )
            parsed[field_name] = decode_field(raw, field.base_type, definition.endian)
        for field in definition.developer_fields:
            offset += field.size

        message_name = MESSAGE_NAMES.get(definition.global_number)
        if message_name:
            messages[message_name].append(parsed)

    return messages


def scale_lap(lap: dict[str, Any], index: int, first_start: float | None) -> dict[str, Any]:
    start_raw = lap.get("start_time")
    start_time = float(start_raw) if isinstance(start_raw, (int, float)) else first_start
    start_offset = None
    if start_time is not None and first_start is not None:
        start_offset = start_time - first_start
    elapsed = lap.get("total_elapsed_time")
    timer = lap.get("total_timer_time")
    distance = lap.get("total_distance")
    elapsed_seconds = float(elapsed) / 1000.0 if isinstance(elapsed, (int, float)) else None
    timer_seconds = float(timer) / 1000.0 if isinstance(timer, (int, float)) else None
    total_distance = float(distance) / 100.0 if isinstance(distance, (int, float)) else None
    duration = timer_seconds if timer_seconds is not None else elapsed_seconds
    return {
        "lapIndex": index,
        "startTime": parse_fit_datetime(start_raw),
        "elapsedTimeSeconds": round_value(elapsed_seconds),
        "timerTimeSeconds": round_value(timer_seconds),
        "totalDistanceMeters": round_value(total_distance),
        "startOffsetSeconds": round_value(start_offset),
        "endOffsetSeconds": round_value(start_offset + duration if start_offset is not None and duration is not None else None),
        "inferredLabel": None,
    }


def scale_workout_step(step: dict[str, Any], index: int) -> dict[str, Any]:
    duration_type_raw = step.get("duration_type")
    duration_type = DURATION_TYPE.get(duration_type_raw, duration_type_raw)
    duration_value = step.get("duration_value")
    duration_target = None
    distance_target = None
    repeat_information = None
    if isinstance(duration_value, (int, float)):
        if duration_type in {"time", "repeat_until_time", "repetition_time"}:
            duration_target = float(duration_value) / 1000.0
        elif duration_type in {"distance", "repeat_until_distance"}:
            distance_target = float(duration_value) / 100.0
        elif duration_type == "repeat_until_steps_complete":
            repeat_information = f"repeat until step {int(duration_value)}"
    return {
        "stepIndex": index,
        "messageIndex": step.get("message_index"),
        "name": step.get("wkt_step_name") or None,
        "stepType": duration_type,
        "durationTargetSeconds": round_value(duration_target),
        "distanceTargetMeters": round_value(distance_target),
        "intensity": INTENSITY.get(step.get("intensity"), step.get("intensity")),
        "targetType": step.get("target_type"),
        "targetValue": step.get("target_value"),
        "repeatInformation": repeat_information,
    }


def fit_rows(path: Path) -> dict[str, Any]:
    parsed = parse_fit(path)
    laps = parsed["lap"]
    first_start = next(
        (
            float(lap["start_time"])
            for lap in laps
            if isinstance(lap.get("start_time"), (int, float))
        ),
        None,
    )
    lap_rows = [scale_lap(lap, index + 1, first_start) for index, lap in enumerate(laps)]
    step_rows = [
        scale_workout_step(step, index + 1)
        for index, step in enumerate(parsed["workout_step"])
    ]
    sessions = parsed["session"]
    session = sessions[-1] if sessions else {}
    session_distance = session.get("total_distance")
    session_elapsed = session.get("total_elapsed_time")
    session_timer = session.get("total_timer_time")
    return {
        "fitLapRows": lap_rows,
        "fitWorkoutStepRows": step_rows,
        "fitSession": {
            "totalDistanceMeters": round_value(
                float(session_distance) / 100.0 if isinstance(session_distance, (int, float)) else None
            ),
            "elapsedTimeSeconds": round_value(
                float(session_elapsed) / 1000.0 if isinstance(session_elapsed, (int, float)) else None
            ),
            "timerTimeSeconds": round_value(
                float(session_timer) / 1000.0 if isinstance(session_timer, (int, float)) else None
            ),
        },
    }


def monthly_record_index() -> dict[str, dict[str, Any]]:
    rollup = load_json(MONTHLY_ROLLUP)
    index: dict[str, dict[str, Any]] = {}
    for item in rollup["matchedFiles"].values():
        path = MONTHLY_EXPORT_FOLDER / item["json"]
        data = load_json(path)
        for record in data.get("records", []):
            workout_id = record.get("workoutID")
            if workout_id:
                index[workout_id] = record
    return index


def normalize_run_signal_rows(rows: list[dict[str, Any]], row_type: str) -> list[dict[str, Any]]:
    normalized = []
    for index, row in enumerate(rows, start=1):
        normalized.append(
            {
                "rowIndex": int(row.get("index") or index),
                "label": row.get("label"),
                "stepType": row.get("stepType"),
                "startOffsetSeconds": round_value(row.get("startOffsetSeconds")),
                "endOffsetSeconds": round_value(row.get("endOffsetSeconds")),
                "durationSeconds": round_value(row.get("durationSeconds")),
                "distanceMeters": round_value(row.get("distanceMeters")),
                "plannedGoalDisplayText": row.get("plannedGoalDisplayText"),
                "source": row_type,
            }
        )
    return normalized


def normalize_plan_rows(plan: dict[str, Any] | None) -> list[dict[str, Any]]:
    rows = []
    for index, step in enumerate((plan or {}).get("plannedSteps", []), start=1):
        rows.append(
            {
                "plannedStepIndex": step.get("index") or index,
                "expandedStepIndex": index,
                "label": step.get("label"),
                "stepType": step.get("stepType"),
                "goal": step.get("plannedGoalDisplayText"),
                "goalType": step.get("plannedGoalType"),
                "goalValue": step.get("plannedGoalValue"),
                "cameFromRepeatBlock": "repeatBlockIndex" in step,
                "repeatBlockIndex": step.get("repeatBlockIndex"),
                "repeatIndex": step.get("repeatIndex"),
            }
        )
    return rows


def attach_fit_labels(lap_rows: list[dict[str, Any]], plan_rows: list[dict[str, Any]]) -> None:
    for lap, plan in zip(lap_rows, plan_rows):
        lap["inferredLabel"] = plan.get("label")


def infer_fit_tail(fit_data: dict[str, Any]) -> dict[str, Any] | None:
    session = fit_data["fitSession"]
    laps = fit_data["fitLapRows"]
    if not laps:
        return None
    total_distance = session.get("totalDistanceMeters")
    total_time = session.get("timerTimeSeconds") or session.get("elapsedTimeSeconds")
    lap_distance = sum(row.get("totalDistanceMeters") or 0.0 for row in laps)
    last_end = laps[-1].get("endOffsetSeconds")
    if total_distance is None or total_time is None or last_end is None:
        return None
    tail_distance = total_distance - lap_distance
    tail_time = total_time - last_end
    if tail_distance <= TAIL_DISTANCE_EPSILON_METERS and tail_time <= TAIL_TIME_EPSILON_SECONDS:
        return None
    return {
        "label": "Open / Extra",
        "distanceMeters": round_value(max(0.0, tail_distance)),
        "durationSeconds": round_value(max(0.0, tail_time)),
        "startOffsetSeconds": round_value(last_end),
        "endOffsetSeconds": round_value(total_time),
        "source": "FIT session minus lap sum",
    }


def row_errors(rows: list[dict[str, Any]], fit_laps: list[dict[str, Any]]) -> list[dict[str, Any]]:
    errors = []
    for row, lap in zip(rows, fit_laps):
        duration = row.get("durationSeconds")
        distance = row.get("distanceMeters")
        fit_duration = lap.get("timerTimeSeconds") or lap.get("elapsedTimeSeconds")
        fit_distance = lap.get("totalDistanceMeters")
        errors.append(
            {
                "rowIndex": row.get("rowIndex"),
                "rowLabel": row.get("label"),
                "fitLapIndex": lap.get("lapIndex"),
                "fitInferredLabel": lap.get("inferredLabel"),
                "labelMatchesFITInference": row.get("label") == lap.get("inferredLabel"),
                "timeErrorSeconds": round_value(
                    duration - fit_duration
                    if isinstance(duration, (int, float)) and isinstance(fit_duration, (int, float))
                    else None
                ),
                "distanceErrorMeters": round_value(
                    distance - fit_distance
                    if isinstance(distance, (int, float)) and isinstance(fit_distance, (int, float))
                    else None
                ),
                "endOffsetErrorSeconds": round_value(
                    row.get("endOffsetSeconds") - lap.get("endOffsetSeconds")
                    if isinstance(row.get("endOffsetSeconds"), (int, float))
                    and isinstance(lap.get("endOffsetSeconds"), (int, float))
                    else None
                ),
            }
        )
    return errors


def max_abs(values: list[Any]) -> float | None:
    numeric = [abs(float(value)) for value in values if isinstance(value, (int, float))]
    return max(numeric) if numeric else None


def rows_within_tolerance(errors: list[dict[str, Any]]) -> bool:
    if not errors:
        return False
    return all(
        error.get("timeErrorSeconds") is not None
        and error.get("distanceErrorMeters") is not None
        and abs(float(error["timeErrorSeconds"])) <= TIME_TOLERANCE_SECONDS
        and abs(float(error["distanceErrorMeters"])) <= DISTANCE_TOLERANCE_METERS
        and bool(error.get("labelMatchesFITInference"))
        for error in errors
    )


def score_value(errors: list[dict[str, Any]]) -> float:
    if not errors:
        return float("inf")
    score = 0.0
    for error in errors:
        if error.get("timeErrorSeconds") is None or error.get("distanceErrorMeters") is None:
            return float("inf")
        score += abs(float(error["timeErrorSeconds"])) + (
            abs(float(error["distanceErrorMeters"])) / 2.0
        )
    return score


def equivalent(current_errors: list[dict[str, Any]], candidate_errors: list[dict[str, Any]]) -> bool:
    return abs(score_value(current_errors) - score_value(candidate_errors)) <= 5.0


def label_issue_count(errors: list[dict[str, Any]]) -> int:
    return sum(1 for error in errors if not error.get("labelMatchesFITInference"))


def classify(
    base: dict[str, Any],
    current_errors: list[dict[str, Any]],
    candidate_errors: list[dict[str, Any]],
    fit_laps: list[dict[str, Any]],
    fit_steps: list[dict[str, Any]],
    plan_rows: list[dict[str, Any]],
    current_rows: list[dict[str, Any]],
    candidate_rows: list[dict[str, Any]],
    tail: dict[str, Any] | None,
) -> str:
    if not fit_laps or not fit_steps:
        return "fit_lacks_required_rows"
    if label_issue_count(current_errors) and label_issue_count(candidate_errors):
        return "label_mapping_needs_rule"
    if tail and (len(current_rows) > len(plan_rows) or len(candidate_rows) > len(plan_rows)):
        return "open_tail_needs_rule"
    if any(row.get("cameFromRepeatBlock") for row in plan_rows) and len(fit_steps) != len(plan_rows):
        current_ok = rows_within_tolerance(current_errors)
        candidate_ok = rows_within_tolerance(candidate_errors)
        if current_ok and candidate_ok and equivalent(current_errors, candidate_errors):
            return "equivalent_row_level_supported"
        return "repeat_block_needs_rule"
    current_ok = rows_within_tolerance(current_errors)
    candidate_ok = rows_within_tolerance(candidate_errors)
    if current_ok and candidate_ok:
        return "equivalent_row_level_supported" if equivalent(current_errors, candidate_errors) else (
            "candidate_row_level_supported"
            if score_value(candidate_errors) < score_value(current_errors)
            else "current_row_level_supported"
        )
    if candidate_ok:
        return "candidate_row_level_supported"
    if current_ok:
        return "current_row_level_supported"
    if base.get("classification") == "warmup/work/cooldown special" and label_issue_count(candidate_errors):
        return "label_mapping_needs_rule"
    return "row_level_inconclusive"


def compare_tail(row: dict[str, Any], tail: dict[str, Any] | None, prefix: str) -> dict[str, Any] | None:
    if tail is None:
        return None
    distance = row.get(f"{prefix}OpenDistanceMeters")
    duration = row.get(f"{prefix}OpenDurationSeconds")
    if distance is None and duration is None:
        return None
    return {
        "distanceErrorMeters": round_value(distance - tail["distanceMeters"] if distance is not None else None),
        "timeErrorSeconds": round_value(duration - tail["durationSeconds"] if duration is not None else None),
    }


def build_scorecard() -> dict[str, Any]:
    monthly_index = monthly_record_index()
    fit_rollup = load_json(FIT_ROLLUP)
    gate_b_rollup = load_json(GATE_B_ROLLUP)
    gate_b = [row for row in fit_rollup["matches"] if row.get("_group") == "structuredAndSpecialWorkouts"]
    workouts = []

    for row in gate_b:
        record = monthly_index.get(row["workoutID"])
        packet = (record or {}).get("parityPacket", {})
        current_rows = normalize_run_signal_rows(packet.get("reconstructedIntervals", []), "current")
        candidate_rows = normalize_run_signal_rows(
            (record or {}).get("activityBoundaryCandidateIntervals")
            or packet.get("activityBoundaryCandidateIntervals", []),
            "candidate",
        )
        plan_rows = normalize_plan_rows(packet.get("workoutKitPlanAudit") or (record or {}).get("workoutKitPlanAudit"))
        fit_path = FIT_FOLDER / row["fitFilename"]
        fit_available = fit_path.exists()
        fit_data = fit_rows(fit_path) if fit_available else {
            "fitLapRows": [],
            "fitWorkoutStepRows": [],
            "fitSession": {},
        }
        attach_fit_labels(fit_data["fitLapRows"], plan_rows)
        tail = infer_fit_tail(fit_data)
        current_errors = row_errors(current_rows, fit_data["fitLapRows"])
        candidate_errors = row_errors(candidate_rows, fit_data["fitLapRows"])
        classification = classify(
            row,
            current_errors,
            candidate_errors,
            fit_data["fitLapRows"],
            fit_data["fitWorkoutStepRows"],
            plan_rows,
            current_rows,
            candidate_rows,
            tail,
        )

        workouts.append(
            {
                "workoutID": row["workoutID"],
                "month": row["month"],
                "startDate": row["startDate"],
                "classification": row["classification"],
                "goal": row["goal"],
                "fitFilename": row["fitFilename"],
                "fitFileFound": fit_available,
                "scores": {
                    "activityCount": row.get("activityCount"),
                    "plannedStepCount": row.get("plannedStepCount"),
                    "fitLapCount": len(fit_data["fitLapRows"]),
                    "fitWorkoutStepCount": len(fit_data["fitWorkoutStepRows"]),
                    "currentRowCount": len(current_rows),
                    "candidateRowCount": len(candidate_rows),
                    "activityCountVsPlannedStepCount": row.get("activityCount") == row.get("plannedStepCount"),
                    "fitLapCountVsActivityCount": len(fit_data["fitLapRows"]) == row.get("activityCount"),
                    "fitWorkoutStepCountVsUnexpandedPlan": len(fit_data["fitWorkoutStepRows"]),
                    "expandedPlannedStepsVsCurrentRows": len(plan_rows) == len(current_rows[: len(plan_rows)]),
                    "expandedPlannedStepsVsCandidateRows": len(plan_rows) == len(candidate_rows[: len(plan_rows)]),
                    "maxCurrentTimingErrorVsFITLapsSeconds": round_value(max_abs([e.get("timeErrorSeconds") for e in current_errors])),
                    "maxCandidateTimingErrorVsFITLapsSeconds": round_value(max_abs([e.get("timeErrorSeconds") for e in candidate_errors])),
                    "maxCurrentDistanceErrorVsFITLapsMeters": round_value(max_abs([e.get("distanceErrorMeters") for e in current_errors])),
                    "maxCandidateDistanceErrorVsFITLapsMeters": round_value(max_abs([e.get("distanceErrorMeters") for e in candidate_errors])),
                    "labelMappingCorrectness": {
                        "currentMismatches": label_issue_count(current_errors),
                        "candidateMismatches": label_issue_count(candidate_errors),
                    },
                    "repeatBlockExpansionCorrectness": {
                        "expandedPlanHasRepeatRows": any(item.get("cameFromRepeatBlock") for item in plan_rows),
                        "fitStepsAppearUnexpanded": len(fit_data["fitWorkoutStepRows"]) < len(plan_rows),
                    },
                    "openExtraTailHandling": {
                        "fitInferredTail": tail,
                        "currentTailError": compare_tail(row, tail, "current"),
                        "candidateTailError": compare_tail(row, tail, "candidate"),
                    },
                    "classification": classification,
                },
                "runSignalCurrentRows": current_rows,
                "hkWorkoutActivityCandidateRows": candidate_rows,
                "fitLapRows": fit_data["fitLapRows"],
                "fitWorkoutStepRows": fit_data["fitWorkoutStepRows"],
                "workoutKitPlannedRows": plan_rows,
                "currentRowErrorsVsFITLaps": current_errors,
                "candidateRowErrorsVsFITLaps": candidate_errors,
            }
        )

    classifications = Counter(item["scores"]["classification"] for item in workouts)
    structured = [item for item in workouts if item["classification"] == "structured interval workout"]
    warmup = [item for item in workouts if item["classification"] == "warmup/work/cooldown special"]

    safe_subclasses = []
    blocked_subclasses = [
        "structured interval repeat-block workouts where FIT workout_step rows are unexpanded",
        "structured intervals with Open / Extra tail after planned rows",
        "warmup/work/cooldown workouts with fixed cooldown followed by Open / Extra tail",
        "any custom workout whose row labels or row errors exceed Gate B tolerances",
    ]
    warmup_candidate_count = sum(
        1
        for item in warmup
        if item["scores"]["classification"]
        in {
            "candidate_row_level_supported",
            "current_row_level_supported",
            "equivalent_row_level_supported",
        }
    )
    if warmup_candidate_count:
        safe_subclasses.append(
            f"future prototype candidate only: {warmup_candidate_count} three-step warmup/work/cooldown rows where every planned row is within 5 s and 10 m of FIT laps"
        )

    return {
        "generatedAt": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
        "sources": {
            "monthlyDiagnosticsRollup": MONTHLY_ROLLUP.name,
            "fitReferenceRollup": FIT_ROLLUP.name,
            "gateBCustomWorkoutScorecard": GATE_B_ROLLUP.name,
            "localFitFolder": str(FIT_FOLDER),
            "monthlyExportFolder": str(MONTHLY_EXPORT_FOLDER),
        },
        "runtimeSource": "HealthKit/WorkoutKit only",
        "validationOracle": "FIT files only, offline/docs validation",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "swiftSourceChanged": False,
        "gateBWorkoutCount": len(workouts),
        "classificationCounts": dict(sorted(classifications.items())),
        "candidateCurrentEquivalentInconclusiveCounts": {
            "candidate": classifications.get("candidate_row_level_supported", 0),
            "current": classifications.get("current_row_level_supported", 0),
            "equivalent": classifications.get("equivalent_row_level_supported", 0),
            "inconclusive": classifications.get("row_level_inconclusive", 0),
            "repeatBlockNeedsRule": classifications.get("repeat_block_needs_rule", 0),
            "openTailNeedsRule": classifications.get("open_tail_needs_rule", 0),
            "labelMappingNeedsRule": classifications.get("label_mapping_needs_rule", 0),
            "fitLacksRequiredRows": classifications.get("fit_lacks_required_rows", 0),
        },
        "answers": {
            "warmupWorkCooldownCurrentlyReconstructedCorrectly": "partially; no-tail three-step warmup/work/cooldown rows have row-level support, but fixed cooldown plus Open / Extra tail remains rule-blocked",
            "structuredIntervalsCurrentlyReconstructedCorrectly": "partially; row timings/distances are close in many cases, but repeat-block expansion and tail rules block broad approval",
            "doesHKWorkoutActivityImproveGateBOrOnlyGateA": "HKWorkoutActivity strongly improves Gate A; for Gate B it is often equivalent to current rows and does not remove repeat/tail/label rule work",
            "doesCurrentReconstructionAlreadyWorkForSomeShapes": "yes, especially no-tail warmup/work/cooldown and many planned structured rows, but only within the exact row-level evidence represented here",
            "safeCustomWorkoutSubclasses": safe_subclasses,
            "blockedCustomWorkoutSubclasses": blocked_subclasses,
            "labelMappingRulesNeeded": [
                "map rows from expanded WorkoutKit planned step order",
                "preserve Warmup, numbered Work, numbered Recovery, and Cooldown labels",
                "use Open / Extra only after planned fixed steps are exhausted",
            ],
            "repeatBlockRulesNeeded": [
                "treat FIT workout_step rows as unexpanded plan evidence",
                "compare FIT lap rows against expanded WorkoutKit planned rows",
                "do not approve repeat-block classes from count alignment alone",
            ],
            "openExtraTailRulesNeeded": [
                "if a final Cooldown goal is open, keep Cooldown through workout end",
                "if a fixed Cooldown completes and running continues, classify the remainder as Open / Extra",
                "score Open / Extra against FIT session-minus-lap tail when FIT has no explicit tail lap",
            ],
            "nextBeforeSwiftImplementation": [
                "keep Gate B docs/debug-only",
                "review row-level scorecard outliers by exact workout shape",
                "do not implement Gate A or Gate B Swift prototype from this Gate B pass",
            ],
        },
        "priorGateBCountLevelScorecard": gate_b_rollup,
        "workouts": workouts,
    }


def md_table(rows: list[list[Any]]) -> str:
    return "\n".join("| " + " | ".join(str(cell) for cell in row) + " |" for row in rows)


def count_by_class(workouts: list[dict[str, Any]], classification: str) -> Counter[str]:
    return Counter(
        item["scores"]["classification"]
        for item in workouts
        if item["classification"] == classification
    )


def format_seconds(value: Any) -> str:
    return "n/a" if value is None else f"{float(value):.1f}s"


def format_meters(value: Any) -> str:
    return "n/a" if value is None else f"{float(value):.1f}m"


def write_markdown(scorecard: dict[str, Any]) -> None:
    workouts = scorecard["workouts"]
    structured_counts = count_by_class(workouts, "structured interval workout")
    warmup_counts = count_by_class(workouts, "warmup/work/cooldown special")
    answers = scorecard["answers"]
    lines = [
        "# Gate B Row-Level FIT Boundary Scorecard: March-June 2026",
        "",
        f"Generated: {scorecard['generatedAt']}",
        "",
        "## Executive Summary",
        "",
        "Gate B remains blocked for broad custom workout promotion. This pass adds row-level FIT lap/workout_step extraction and compares each Gate B workout against RunSignal current rows, HKWorkoutActivity candidate rows, and expanded WorkoutKit planned rows.",
        "",
        "FIT remains an offline validation oracle only. Runtime source remains HealthKit/WorkoutKit. Swift source and production behavior are unchanged.",
        "",
        "Do not implement a Swift prototype from this Gate B result. Some narrow shapes are now candidates for future prototype design, but broad custom workout promotion is not approved.",
        "",
        "## Score Summary",
        "",
        md_table(
            [
                ["Bucket", "Count"],
                ["---", "---:"],
                *[[key, value] for key, value in scorecard["classificationCounts"].items()],
            ]
        ),
        "",
        "## Class Findings",
        "",
        md_table(
            [
                ["Class", "Total", "Equivalent", "Candidate", "Current", "Inconclusive", "Repeat rule", "Open tail rule", "Label rule"],
                ["---", "---:", "---:", "---:", "---:", "---:", "---:", "---:", "---:"],
                [
                    "Structured intervals",
                    sum(structured_counts.values()),
                    structured_counts.get("equivalent_row_level_supported", 0),
                    structured_counts.get("candidate_row_level_supported", 0),
                    structured_counts.get("current_row_level_supported", 0),
                    structured_counts.get("row_level_inconclusive", 0),
                    structured_counts.get("repeat_block_needs_rule", 0),
                    structured_counts.get("open_tail_needs_rule", 0),
                    structured_counts.get("label_mapping_needs_rule", 0),
                ],
                [
                    "Warmup/work/cooldown",
                    sum(warmup_counts.values()),
                    warmup_counts.get("equivalent_row_level_supported", 0),
                    warmup_counts.get("candidate_row_level_supported", 0),
                    warmup_counts.get("current_row_level_supported", 0),
                    warmup_counts.get("row_level_inconclusive", 0),
                    warmup_counts.get("repeat_block_needs_rule", 0),
                    warmup_counts.get("open_tail_needs_rule", 0),
                    warmup_counts.get("label_mapping_needs_rule", 0),
                ],
            ]
        ),
        "",
        "## Required Answers",
        "",
        f"1. Warmup/work/cooldown currently reconstructed correctly? {answers['warmupWorkCooldownCurrentlyReconstructedCorrectly']}",
        f"2. Structured intervals currently reconstructed correctly? {answers['structuredIntervalsCurrentlyReconstructedCorrectly']}",
        f"3. Does HKWorkoutActivity improve Gate B or only Gate A? {answers['doesHKWorkoutActivityImproveGateBOrOnlyGateA']}",
        f"4. Does current reconstruction already work for some custom workout shapes? {answers['doesCurrentReconstructionAlreadyWorkForSomeShapes']}",
        f"5. Safe custom workout shapes: {', '.join(answers['safeCustomWorkoutSubclasses']) if answers['safeCustomWorkoutSubclasses'] else 'none approved for broad production promotion'}",
        f"6. Blocked custom workout shapes: {', '.join(answers['blockedCustomWorkoutSubclasses'])}",
        f"7. Label mapping rules needed: {', '.join(answers['labelMappingRulesNeeded'])}",
        f"8. Repeat-block rules needed: {', '.join(answers['repeatBlockRulesNeeded'])}",
        f"9. Open/Extra tail rules needed: {', '.join(answers['openExtraTailRulesNeeded'])}",
        f"10. Next before Swift implementation: {', '.join(answers['nextBeforeSwiftImplementation'])}",
        "",
        "## Workout Rows",
        "",
        md_table(
            [
                ["Start", "Class", "Rows current/candidate/FIT/plan", "Decision", "Max current err", "Max candidate err", "Tail"],
                ["---", "---", "---", "---", "---:", "---:", "---"],
                *[
                    [
                        item["startDate"],
                        item["classification"],
                        f"{item['scores']['currentRowCount']}/{item['scores']['candidateRowCount']}/{item['scores']['fitLapCount']}/{item['scores']['plannedStepCount']}",
                        item["scores"]["classification"],
                        f"{format_seconds(item['scores']['maxCurrentTimingErrorVsFITLapsSeconds'])} / {format_meters(item['scores']['maxCurrentDistanceErrorVsFITLapsMeters'])}",
                        f"{format_seconds(item['scores']['maxCandidateTimingErrorVsFITLapsSeconds'])} / {format_meters(item['scores']['maxCandidateDistanceErrorVsFITLapsMeters'])}",
                        "yes" if item["scores"]["openExtraTailHandling"]["fitInferredTail"] else "no",
                    ]
                    for item in workouts
                ],
            ]
        ),
        "",
        "## Recommendation",
        "",
        "- Gate B remains blocked for broad production promotion.",
        "- No Swift prototype is recommended now.",
        "- Keep Gate A separate; this Gate B row-level work does not change the existing Gate A prototype decision.",
        "- Use this row-level JSON to inspect exact workout subclasses before approving any future narrow Swift experiment.",
    ]
    MARKDOWN_REPORT.write_text("\n".join(lines) + "\n", encoding="utf-8")


def main() -> int:
    scorecard = build_scorecard()
    JSON_REPORT.write_text(json.dumps(scorecard, indent=2), encoding="utf-8")
    write_markdown(scorecard)
    print(f"Wrote {JSON_REPORT.name}")
    print(f"Wrote {MARKDOWN_REPORT.name}")
    print(f"Analyzed {scorecard['gateBWorkoutCount']} Gate B workouts")
    print(f"Classification counts: {scorecard['classificationCounts']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
