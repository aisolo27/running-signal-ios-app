#!/usr/bin/env python3
"""Audit March-June 2026 custom workout shape coverage.

This is docs-only/offline validation. It reads generated diagnostics and
scorecards. It does not change app behavior and does not use FIT at runtime.
"""

from __future__ import annotations

import json
from collections import Counter, defaultdict
from datetime import datetime, timezone
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
FIT_ROLLUP = ROOT / "fit-reference-rollup-2026-03-to-2026-06.json"
MONTHLY_ROLLUP = ROOT / "monthly-diagnostics-rollup-2026-03-to-2026-06.json"
GATE_B_ROW_LEVEL = ROOT / "gate-b-row-level-fit-boundary-scorecard-2026-03-to-2026-06.json"
TIMER_DRIFT = ROOT / "gate-b-timer-drift-evidence-2026-03-to-2026-06.json"
OUTPUT_JSON = ROOT / "custom-workout-shape-coverage-audit-2026-03-to-2026-06.json"
OUTPUT_MD = ROOT / "custom-workout-shape-coverage-audit-2026-03-to-2026-06.md"

MONTHLY_EXPORT_FOLDER = Path(
    "/Users/adrielsolorzano/Documents/Personal OS/00_Inbox_To_Sort/RunSignal testing"
)

PROGRAM_START = "2026-04-20T00:00:00Z"


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def generated_at() -> str:
    return datetime.now(timezone.utc).isoformat().replace("+00:00", "Z")


def parse_start(value: str) -> datetime:
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def day_of_week(value: str) -> str:
    return parse_start(value).strftime("%A")


def date_key(value: str) -> str:
    return parse_start(value).strftime("%Y-%m-%d")


def is_program_period(value: str) -> bool:
    return value >= PROGRAM_START


def md_table(rows: list[list[Any]]) -> str:
    return "\n".join("| " + " | ".join(str(cell) for cell in row) + " |" for row in rows)


def monthly_records() -> dict[str, dict[str, Any]]:
    rollup = load_json(MONTHLY_ROLLUP)
    records: dict[str, dict[str, Any]] = {}
    for item in rollup.get("matchedFiles", {}).values():
        path = MONTHLY_EXPORT_FOLDER / item["json"]
        data = load_json(path)
        for record in data.get("records", []):
            start = record.get("startDate")
            if start:
                records[start] = record
    return records


def pause_event_kind(event: dict[str, Any]) -> str | None:
    event_type = event.get("type") or ""
    if "rawValue: 1" in event_type:
        return "pause"
    if "rawValue: 2" in event_type:
        return "resume"
    label = (event.get("label") or event.get("displayLabel") or "").lower()
    if "pause" in label:
        return "pause"
    if "resume" in label:
        return "resume"
    return None


def raw_events(record: dict[str, Any] | None) -> list[dict[str, Any]]:
    if not record:
        return []
    packet = record.get("parityPacket") or {}
    return packet.get("rawWorkoutEvents") or record.get("rawWorkoutEvents") or []


def pause_event_counts(record: dict[str, Any] | None) -> dict[str, int]:
    events = sorted(
        [event for event in raw_events(record) if pause_event_kind(event)],
        key=lambda event: event.get("startDate") or "",
    )
    pending_pauses = 0
    paired_intervals = 0
    unpaired_resumes = 0
    for event in events:
        kind = pause_event_kind(event)
        if kind == "pause":
            pending_pauses += 1
        elif pending_pauses:
            pending_pauses -= 1
            paired_intervals += 1
        else:
            unpaired_resumes += 1
    return {
        "markerCount": len(events),
        "pairedIntervalCount": paired_intervals,
        "unpairedPauseCount": pending_pauses,
        "unpairedResumeCount": unpaired_resumes,
    }


def shape_from_gate_b(workout: dict[str, Any] | None) -> str | None:
    if not workout:
        return None
    parts = []
    for row in workout.get("workoutKitPlannedRows", []):
        label = row.get("label") or "Unknown"
        goal = row.get("goal") or "Unavailable"
        parts.append(f"{label}({goal})")
    return " > ".join(parts) if parts else None


def shape_from_rollup(row: dict[str, Any]) -> str:
    group = row.get("_group")
    if group == "simpleWorkOpenCandidates":
        return f"Work({row.get('goal') or 'Open'}) > Open"
    if row.get("plannedStepCount", 0) == 1:
        return f"Work({row.get('goal') or 'Open'})"
    return row.get("classification") or "Unknown"


def goal_family(goal: Any) -> str:
    if not goal:
        return "no-goal"
    return str(goal)


def has_recovery(shape: str) -> bool:
    return "Recovery" in shape


def has_repeat_blocks(row: dict[str, Any], gate_b: dict[str, Any] | None, shape: str) -> bool:
    if gate_b:
        return any(item.get("cameFromRepeatBlock") for item in gate_b.get("workoutKitPlannedRows", []))
    return False


def cooldown_type(gate_b: dict[str, Any] | None, shape: str) -> tuple[bool, bool]:
    if not gate_b:
        return False, False
    rows = gate_b.get("workoutKitPlannedRows", [])
    cooldowns = [row for row in rows if row.get("stepType") == "cooldown"]
    fixed = any(row.get("goalType") in {"time", "distance"} for row in cooldowns)
    open_ = any(row.get("goalType") == "open" for row in cooldowns)
    return fixed, open_


def open_tail(gate_b: dict[str, Any] | None, row: dict[str, Any]) -> bool:
    if not gate_b:
        return False
    scores = gate_b["scores"]
    if scores.get("classification") == "open_tail_needs_rule":
        return True
    tail = scores["openExtraTailHandling"].get("fitInferredTail") or {}
    return (tail.get("durationSeconds") or 0) > 5.0 or (tail.get("distanceMeters") or 0) > 25.0


def likely_program_day_type(row: dict[str, Any], gate_b: dict[str, Any] | None, shape: str) -> str:
    group = row.get("_group")
    day = day_of_week(row["startDate"])
    classification = row.get("classification")
    if group == "simpleWorkOpenCandidates":
        return "easy fixed-goal run"
    if classification == "warmup/work/cooldown special":
        return "tempo"
    if classification == "structured interval workout":
        if day == "Friday":
            return "tempo"
        return "structured interval"
    if group == "excludedWorkouts":
        return "unknown/custom other"
    return "unknown/custom other"


def gate_b_current_classification(
    row: dict[str, Any],
    gate_b: dict[str, Any] | None,
    timer: dict[str, Any] | None,
) -> str:
    if timer:
        return "timer-drift excluded"
    if not gate_b:
        group = row.get("_group")
        if group == "simpleWorkOpenCandidates":
            return "not currently in Gate B: Gate A simple Work/Open"
        if row.get("plannedStepCount", 0) == 0:
            return "missing evidence"
        return f"not currently in Gate B: {row.get('classification')}"
    decision = gate_b["scores"]["classification"]
    if decision == "candidate_row_level_supported":
        return "supported candidate"
    if decision == "repeat_block_needs_rule":
        return "close but repeat-rule blocked" if candidate_within_tolerance(gate_b) else "repeat-rule blocked"
    if decision == "open_tail_needs_rule":
        return "tail-rule blocked"
    if decision == "row_level_inconclusive":
        return "distance-drift excluded"
    return decision


def candidate_within_tolerance(gate_b: dict[str, Any]) -> bool:
    scores = gate_b["scores"]
    return (
        (scores.get("maxCandidateTimingErrorVsFITLapsSeconds") or 0) <= 5.0
        and (scores.get("maxCandidateDistanceErrorVsFITLapsMeters") or 0) <= 10.0
        and scores["labelMappingCorrectness"].get("candidateMismatches") == 0
    )


def considerations(row: dict[str, Any], gate_b: dict[str, Any] | None, current_class: str) -> list[str]:
    group = row.get("_group")
    classification = row.get("classification")
    day = day_of_week(row["startDate"])
    result: list[str] = []
    if group == "simpleWorkOpenCandidates":
        result.append("future easy fixed-goal subclass")
    if classification == "warmup/work/cooldown special":
        shape = shape_from_gate_b(gate_b) or ""
        if "Cooldown(Open)" in shape and "Recovery" not in shape and "tail" not in current_class:
            result.append("narrow no-tail warmup/work/open-cooldown candidate")
        result.append("future tempo subclass")
    if classification == "structured interval workout":
        if day == "Friday":
            result.append("future tempo subclass")
        result.append("future repeat-block interval subclass")
    if "timer-drift" in current_class:
        result.append("future pause/timer handling rules")
    if "tail-rule" in current_class:
        result.append("future tempo subclass")
    if group == "excludedWorkouts" or "excluded" in current_class or "missing evidence" in current_class:
        result.append("exclusion")
    return sorted(set(result)) or ["exclusion"]


def build_audit() -> dict[str, Any]:
    fit = load_json(FIT_ROLLUP)
    gate_b_scorecard = load_json(GATE_B_ROW_LEVEL)
    timer_scorecard = load_json(TIMER_DRIFT)
    records = monthly_records()
    gate_b_by_start = {workout["startDate"]: workout for workout in gate_b_scorecard["workouts"]}
    timer_by_start = {row["startDate"]: row for row in timer_scorecard["rows"]}

    rows = []
    for row in sorted(fit.get("matches", []), key=lambda item: item["startDate"]):
        start = row["startDate"]
        gate_b = gate_b_by_start.get(start)
        timer = timer_by_start.get(start)
        record = records.get(start)
        shape = shape_from_gate_b(gate_b) or shape_from_rollup(row)
        fixed_cooldown, open_cooldown = cooldown_type(gate_b, shape)
        pause_counts = pause_event_counts(record)
        current_class = gate_b_current_classification(row, gate_b, timer)
        inventory_row = {
            "startDate": start,
            "date": date_key(start),
            "dayOfWeek": day_of_week(start),
            "programPeriod": "after 2026-04-20 program start" if is_program_period(start) else "before 2026-04-20 program start",
            "likelyProgramDayType": likely_program_day_type(row, gate_b, shape),
            "rollupGroup": row.get("_group"),
            "rollupClassification": row.get("classification"),
            "plannedShape": shape,
            "plannedStepCount": row.get("plannedStepCount"),
            "activityCount": row.get("activityCount"),
            "fitLapCount": row.get("fitLapCount"),
            "fitWorkoutStepCount": row.get("fitWorkoutStepCount"),
            "hasRepeatBlocks": has_repeat_blocks(row, gate_b, shape),
            "hasRecoveryRows": has_recovery(shape),
            "hasFixedCooldown": fixed_cooldown,
            "hasOpenCooldown": open_cooldown,
            "hasOpenExtraTail": open_tail(gate_b, row),
            "hasPauseResumeEvidence": pause_counts["pairedIntervalCount"] > 0,
            "pauseResumeMarkerCount": pause_counts["markerCount"],
            "pairedPauseResumeIntervalCount": pause_counts["pairedIntervalCount"],
            "unpairedPauseMarkerCount": pause_counts["unpairedPauseCount"],
            "unpairedResumeMarkerCount": pause_counts["unpairedResumeCount"],
            "hasTimerVsElapsedDrift": bool(timer),
            "currentClassification": current_class,
            "notCurrentlyInGateBReason": not_gate_b_reason(row),
            "considerFor": considerations(row, gate_b, current_class),
            "workoutID": row.get("workoutID"),
            "fitFilename": row.get("fitFilename"),
        }
        rows.append(inventory_row)

    return {
        "generatedAt": generated_at(),
        "sources": {
            "fitReferenceRollup": FIT_ROLLUP.name,
            "monthlyDiagnosticsRollup": MONTHLY_ROLLUP.name,
            "gateBRowLevelScorecard": GATE_B_ROW_LEVEL.name,
            "timerDriftEvidence": TIMER_DRIFT.name,
        },
        "runtimeSource": "HealthKit/WorkoutKit only",
        "validationOracle": "FIT offline reference only",
        "fitRuntimeUseAllowed": False,
        "productionBehaviorChanged": False,
        "normalWorkoutUIChanged": False,
        "hkWorkoutActivityPromoted": False,
        "phase3Implemented": False,
        "programStartDate": "2026-04-20",
        "summary": summary(rows),
        "rows": rows,
        "recommendation": {
            "evidenceCollection": "Collect a balanced set across easy fixed-goal, tempo, interval, and pause/timer cases instead of only more narrow warmup/work/open-cooldown examples.",
            "phase3Strategy": "Keep Phase 3 blocked. If later approved, split it into debug-only subclasses: Gate A easy fixed-goal first, narrow no-tail tempo second, repeat-block intervals third, and pause/timer semantics as a first-class cross-cutting requirement.",
        },
    }


def not_gate_b_reason(row: dict[str, Any]) -> str | None:
    group = row.get("_group")
    if group == "simpleWorkOpenCandidates":
        return "Gate A simple fixed-distance Work + Open, not Gate B multi-step custom workout."
    if group == "excludedWorkouts":
        if row.get("plannedStepCount", 0) == 0:
            return row.get("notScoreableReason") or "No WorkoutKit planned steps."
        return row.get("boundaryClass") or row.get("classification")
    return None


def summary(rows: list[dict[str, Any]]) -> dict[str, Any]:
    program_rows = [row for row in rows if row["programPeriod"].startswith("after")]
    return {
        "totalMatchedRunningWorkouts": len(rows),
        "afterProgramStart": len(program_rows),
        "byRollupGroup": dict(Counter(row["rollupGroup"] for row in rows)),
        "afterProgramStartByDayType": dict(Counter(row["likelyProgramDayType"] for row in program_rows)),
        "afterProgramStartByDayOfWeek": dict(Counter(row["dayOfWeek"] for row in program_rows)),
        "byCurrentClassification": dict(Counter(row["currentClassification"] for row in rows)),
        "afterProgramStartByCurrentClassification": dict(Counter(row["currentClassification"] for row in program_rows)),
        "pauseResumeEvidenceCount": sum(1 for row in rows if row["hasPauseResumeEvidence"]),
        "pauseMarkerEvidenceCount": sum(1 for row in rows if row["pauseResumeMarkerCount"] > 0),
        "timerDriftEvidenceCount": sum(1 for row in rows if row["hasTimerVsElapsedDrift"]),
        "simpleWorkOpenCount": sum(1 for row in rows if row["rollupGroup"] == "simpleWorkOpenCandidates"),
        "gateBCount": sum(1 for row in rows if row["rollupGroup"] == "structuredAndSpecialWorkouts"),
        "excludedCount": sum(1 for row in rows if row["rollupGroup"] == "excludedWorkouts"),
    }


def compact_shape(shape: str, limit: int = 92) -> str:
    return shape if len(shape) <= limit else shape[: limit - 3] + "..."


def rows_by(rows: list[dict[str, Any]], key: str, value: Any) -> list[dict[str, Any]]:
    return [row for row in rows if row.get(key) == value]


def write_markdown(audit: dict[str, Any]) -> None:
    rows = audit["rows"]
    program_rows = [row for row in rows if row["programPeriod"].startswith("after")]
    simple_rows = rows_by(rows, "rollupGroup", "simpleWorkOpenCandidates")
    tempo_rows = [row for row in rows if row["likelyProgramDayType"] == "tempo"]
    interval_rows = [row for row in rows if row["likelyProgramDayType"] == "structured interval"]
    excluded_rows = rows_by(rows, "rollupGroup", "excludedWorkouts")

    lines = [
        "# Custom Workout Shape Coverage Audit: March-June 2026",
        "",
        f"Generated: {audit['generatedAt']}",
        "",
        "## Executive summary",
        "",
        "The current Gate B analysis is not missing the user's newer easy-run volume; those runs are mostly classified outside Gate B as Gate A simple fixed-distance Work + Open candidates. Gate B is focused on multi-step custom workouts, so the narrow warmup/work/open-cooldown candidate scorecard found only 4 exact rows by design.",
        "",
        "The April 20/22 program start does explain the shape distribution. After 2026-04-20, the pattern is clear: easy fixed-goal Work/Open runs on easy days, structured interval workouts on Wednesdays, and Friday tempo-like workouts that split across several shapes rather than one exact narrow shape.",
        "",
        "Pauses are not bad data. They appear in hard workouts and should be treated as first-class product evidence. Clean fixtures can separate pause-free and paused cases, but future custom-workout support needs explicit elapsed-vs-timer and pause handling. The raw HealthKit packets also include a single unpaired pause marker on most workouts, so this audit treats paired pause/resume intervals as the stronger pause evidence and preserves unpaired marker counts separately.",
        "",
        "## Why the current narrow candidate found only 4 exact rows",
        "",
        "The narrow candidate requires exactly `Warmup(2 km) > one fixed Work step > Cooldown(Open)`, exactly 3 rows across current/candidate/FIT/plan/FIT-step evidence, no recovery rows, and no fixed-cooldown tail. That excludes:",
        "",
        "- 50 simple Work/Open easy fixed-goal workouts, because they are Gate A rather than Gate B.",
        "- 17 repeat-block Gate B rows, because repeat expansion rules are still blocked.",
        "- 4 Open/Extra tail rows, because fixed-step exhaustion and tail classification are still blocked.",
        "- 7 timer-drift rows, because pause/timer semantics are real product requirements but not approved as a prototype shortcut.",
        "- 12 excluded/no-plan/duplicate/unknown rows, because evidence is missing or not scoreable.",
        "",
        "## Program-period timeline, especially after 2026-04-20",
        "",
        md_table(
            [
                ["Metric", "Count"],
                ["---", "---:"],
                ["All matched running workouts", audit["summary"]["totalMatchedRunningWorkouts"]],
                ["After 2026-04-20", audit["summary"]["afterProgramStart"]],
                ["Simple Work/Open easy fixed-goal", audit["summary"]["simpleWorkOpenCount"]],
                ["Gate B structured/special", audit["summary"]["gateBCount"]],
                ["Excluded/no-plan/duplicate/unknown", audit["summary"]["excludedCount"]],
                ["Paired pause/resume intervals present", audit["summary"]["pauseResumeEvidenceCount"]],
                ["Raw pause/resume markers present", audit["summary"]["pauseMarkerEvidenceCount"]],
                ["Timer-drift evidence present", audit["summary"]["timerDriftEvidenceCount"]],
            ]
        ),
        "",
        "After the program start, the weekday pattern aligns with the user's description: Monday/Tuesday are mostly simple fixed-goal easy runs, Wednesdays are structured interval workouts, and Fridays are tempo-like but not always the exact no-tail three-row shape.",
        "",
        md_table(
            [
                ["Day type after 2026-04-20", "Count"],
                ["---", "---:"],
                *[[key, value] for key, value in sorted(audit["summary"]["afterProgramStartByDayType"].items())],
            ]
        ),
        "",
        "## Shape inventory table",
        "",
        md_table(
            [
                ["Start", "Day", "Type", "Shape", "Features", "Current classification", "Consider for"],
                ["---", "---", "---", "---", "---", "---", "---"],
                *[
                    [
                        row["startDate"],
                        row["dayOfWeek"][:3],
                        row["likelyProgramDayType"],
                        compact_shape(row["plannedShape"]),
                        feature_summary(row),
                        row["currentClassification"],
                        ", ".join(row["considerFor"]),
                    ]
                    for row in rows
                ],
            ]
        ),
        "",
        "## Easy run shapes",
        "",
        f"There are {len(simple_rows)} simple fixed-distance Work/Open workouts. These are not overlooked by Gate B; they are Gate A. They are the main home for easy fixed-goal program days, including the post-2026-04-20 Monday/Tuesday examples such as `Work(8 km) > Open`, `Work(8.10 km) > Open`, `Work(7.25 km) > Open`, `Work(6.45 km) > Open`, and `Work(5 km) > Open`.",
        "",
        "These should be considered for a future easy fixed-goal subclass, separate from Gate B structured intervals and separate from the narrow warmup/work/open-cooldown candidate.",
        "",
        "## Tempo run shapes",
        "",
        f"There are {len(tempo_rows)} tempo-like rows by shape/day context. The narrow scorecard only sees the exact no-tail warmup/work/open-cooldown subset, so it understates Friday tempo coverage.",
        "",
        md_table(
            [
                ["Start", "Day", "Shape", "Current classification", "Consider for"],
                ["---", "---", "---", "---", "---"],
                *[
                    [
                        row["startDate"],
                        row["dayOfWeek"][:3],
                        compact_shape(row["plannedShape"]),
                        row["currentClassification"],
                        ", ".join(row["considerFor"]),
                    ]
                    for row in tempo_rows
                ],
            ]
        ),
        "",
        "## Structured interval shapes",
        "",
        f"There are {len(interval_rows)} structured interval rows by program-day context. Most Wednesday rows after 2026-04-20 are represented, but they stay blocked by repeat rules and, when present, pause/timer evidence.",
        "",
        md_table(
            [
                ["Start", "Day", "Shape", "Current classification", "Pause/timer"],
                ["---", "---", "---", "---", "---"],
                *[
                    [
                        row["startDate"],
                        row["dayOfWeek"][:3],
                        compact_shape(row["plannedShape"]),
                        row["currentClassification"],
                        "yes" if row["hasTimerVsElapsedDrift"] else ("pause markers" if row["hasPauseResumeEvidence"] else "no"),
                    ]
                    for row in interval_rows
                ],
            ]
        ),
        "",
        "## Pause/timer evidence summary",
        "",
        "Paired pause/resume evidence is concentrated in hard workouts and is real product evidence, not abnormal data. Seven primary outliers have timer-drift evidence: candidate row duration matches FIT elapsed duration, while FIT timer duration subtracts pause intervals exposed by HealthKit debug event packets. Most workouts also carry one unpaired raw pause marker near workout end; that marker is useful diagnostic context but is not enough on its own to classify a workout as a paused case. Timer-drift rows should stay excluded from clean prototype fixtures but should be preserved as a required future capability.",
        "",
        "## Workouts not currently represented in Gate B and why",
        "",
        f"- {len(simple_rows)} simple Work/Open rows are Gate A, not Gate B.",
        f"- {len(excluded_rows)} rows are excluded/no-plan/duplicate/unknown. Nine have no planned steps in the rollup; three have one `Open` planned step and are drift/guard unknowns.",
        "- Duplicate/no-plan rows should remain excluded from prototype scoring unless new physical-device exports prove usable WorkoutKit plan evidence.",
        "",
        "## What appears overlooked, if anything",
        "",
        "The analysis was overlooking coverage communication, not the raw workouts. Easy fixed-goal custom workouts are numerous but live in Gate A. Friday tempo-like workouts are more varied than the exact narrow candidate shape: some are clean no-tail warmup/work/open-cooldown, some have fixed cooldown plus tail, some include recovery/repeat rows, and some include pause/timer drift.",
        "",
        "## Revised evidence collection recommendation",
        "",
        "Collect a balanced validation set instead of only more narrow warmup/work/open-cooldown examples:",
        "",
        "- Easy fixed-goal: 3-5 Work/Open runs across common goals such as 5 km, 6.45 km, 7.25 km, 8 km, and long-run distances.",
        "- Tempo no-tail: 3-5 `Warmup(2 km) > one fixed Work > Cooldown(Open)` rows without pauses.",
        "- Tempo tail: 2-4 fixed-cooldown plus Open/Extra tail rows.",
        "- Intervals: 5-8 repeat-block workouts covering short reps, long reps, and mixed-distance blocks.",
        "- Pause/timer: 3-5 intentionally preserved paused workouts, including one tempo and multiple interval examples.",
        "",
        "For each new example, collect the Raw HealthKit Debug export, parity packet JSON, FIT export availability, and if possible a short note saying whether the run was paused and approximately when.",
        "",
        "## Revised Phase 3 strategy recommendation",
        "",
        "Do not start Phase 3 yet. If later approved, split Phase 3 into debug-only subclasses instead of one custom-workout prototype:",
        "",
        "1. Gate A easy fixed-goal Work/Open remains separate and parked.",
        "2. Narrow no-tail warmup/work/open-cooldown can be the first Gate B discussion candidate.",
        "3. Tempo fixed-cooldown tail needs its own tail rule.",
        "4. Repeat-block intervals need an explicit expanded-plan-to-FIT-lap rule.",
        "5. Pause/timer handling must be a first-class cross-cutting rule, not an exclusion forever.",
        "",
        "## Questions answered",
        "",
        "1. Are there more tempo-like custom workouts than the narrow scorecard suggests? Yes. The exact narrow shape has 4 rows, but Friday tempo-like coverage includes fixed cooldown tails and repeat/recovery variants.",
        "2. Are easy fixed-goal custom workouts being excluded because they are Gate A or another class? Yes. Most easy fixed-goal runs are Gate A simple Work/Open, not Gate B.",
        "3. Are some workouts outside Gate B due to duplicate/no-plan/summary-only filters? Yes. The excluded group includes duplicate/same-day extras, no-plan rows, and drift/guard unknown rows.",
        "4. Does the April 20/22 program start date explain the shape distribution? Yes. After that date the weekly pattern lines up with easy fixed-goal days, Wednesday intervals, and Friday tempo-like workouts.",
        "5. Should we collect more narrow examples or a balanced set? Collect a balanced set. More narrow examples help, but they would not cover the actual easy, interval, tail, and pause/timer workload.",
        "6. What exact evidence should the user collect next? For each target run, export Raw HealthKit Debug/parity packet, preserve FIT availability, note pause timing, and include at least one clean and one paused example per major shape.",
        "",
        "## Explicit no-production-change statement",
        "",
        "This audit is docs/debug validation only. It does not change production interval behavior, normal workout UI, `HKWorkoutActivity` promotion status, FIT import behavior, HealthFit dependency status, runtime FIT usage, Phase 3 implementation status, or custom workout reconstruction behavior.",
    ]
    OUTPUT_MD.write_text("\n".join(lines) + "\n", encoding="utf-8")


def feature_summary(row: dict[str, Any]) -> str:
    features = []
    if row["hasRepeatBlocks"]:
        features.append("repeat")
    if row["hasRecoveryRows"]:
        features.append("recovery")
    if row["hasFixedCooldown"]:
        features.append("fixed cooldown")
    if row["hasOpenCooldown"]:
        features.append("open cooldown")
    if row["hasOpenExtraTail"]:
        features.append("Open/Extra tail")
    if row["hasPauseResumeEvidence"]:
        features.append("paired pause/resume")
    elif row["pauseResumeMarkerCount"] > 0:
        features.append("unpaired pause marker")
    if row["hasTimerVsElapsedDrift"]:
        features.append("timer drift")
    return ", ".join(features) if features else "none"


def main() -> int:
    audit = build_audit()
    OUTPUT_JSON.write_text(json.dumps(audit, indent=2) + "\n", encoding="utf-8")
    write_markdown(audit)
    print(f"Wrote {OUTPUT_JSON.name}")
    print(f"Wrote {OUTPUT_MD.name}")
    print(f"Audited {audit['summary']['totalMatchedRunningWorkouts']} matched running workouts")
    print(f"After program start: {audit['summary']['afterProgramStart']}")
    print(f"By group: {audit['summary']['byRollupGroup']}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
