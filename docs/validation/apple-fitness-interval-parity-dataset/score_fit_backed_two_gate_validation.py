#!/usr/bin/env python3
"""Score the FIT-backed two-gate validation plan.

This is a docs-only/offline gate. It reads RunSignal monthly diagnostics and
the FIT reference rollup. It does not read FIT files directly and does not
approve any runtime FIT dependency.
"""

from __future__ import annotations

import json
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
MONTHLY_PATH = ROOT / "monthly-diagnostics-rollup-2026-03-to-2026-06.json"
FIT_PATH = ROOT / "fit-reference-rollup-2026-03-to-2026-06.json"
GATE_PATH = ROOT / "fit-backed-two-gate-validation-plan-2026-03-to-2026-06.json"


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(path.read_text(encoding="utf-8"))


def fail(message: str, failures: list[str]) -> None:
    failures.append(message)


def is_candidate_supported(row: dict[str, Any]) -> bool:
    return row.get("fitSupport") == "HKWorkoutActivity candidate"


def is_current_supported(row: dict[str, Any]) -> bool:
    return row.get("fitSupport") == "current reconstruction"


def has_work_open_candidate_rows(row: dict[str, Any]) -> bool:
    return (
        row.get("candidateRowCount") == 2
        and row.get("candidateWorkDistanceMeters") is not None
        and row.get("candidateWorkDurationSeconds") is not None
        and row.get("candidateOpenDistanceMeters") is not None
        and row.get("candidateOpenDurationSeconds") is not None
    )


def score() -> tuple[dict[str, Any], list[str]]:
    monthly = load_json(MONTHLY_PATH)
    fit = load_json(FIT_PATH)
    gate = load_json(GATE_PATH)
    failures: list[str] = []

    matches = fit.get("matches", [])
    simple = [row for row in matches if row.get("_group") == "simpleWorkOpenCandidates"]
    structured_special = [
        row for row in matches if row.get("_group") == "structuredAndSpecialWorkouts"
    ]
    excluded = [row for row in matches if row.get("_group") == "excludedWorkouts"]
    large_shift = [row for row in simple if row.get("largeShiftFlags")]
    no_large_shift = [row for row in simple if not row.get("largeShiftFlags")]

    simple_candidate_supported = [row for row in simple if is_candidate_supported(row)]
    simple_current_supported = [row for row in simple if is_current_supported(row)]
    simple_inconclusive = [row for row in simple if not is_candidate_supported(row)]
    large_candidate_supported = [row for row in large_shift if is_candidate_supported(row)]
    large_current_supported = [row for row in large_shift if is_current_supported(row)]
    missing_work_open_rows = [
        row for row in simple if not has_work_open_candidate_rows(row)
    ]
    bad_simple_counts = [
        row
        for row in simple
        if row.get("activityCount") != 1 or row.get("plannedStepCount") != 1
    ]
    structured_accidentally_approved = [
        row for row in structured_special if is_candidate_supported(row)
    ]
    excluded_accidentally_approved = [
        row for row in excluded if is_candidate_supported(row)
    ]

    totals = monthly.get("crossMonthTotals", {})
    if totals.get("totalSimpleWorkOpenCandidates") != len(simple):
        fail("monthly simple Work/Open total does not match FIT rollup simple group", failures)
    if totals.get("totalStructuredIntervals", 0) + totals.get("totalSpecials", 0) != len(
        structured_special
    ):
        fail("monthly structured/special total does not match FIT rollup group", failures)
    if fit.get("summary", {}).get("unmatchedRunSignalWorkouts") != 0:
        fail("FIT rollup has unmatched RunSignal workouts", failures)
    if fit.get("summary", {}).get("unmatchedFitFiles") != 0:
        fail("FIT rollup has unmatched FIT files", failures)
    if len(large_current_supported) > 0:
        fail("a large-shift simple Work/Open case supports current reconstruction", failures)
    if len(large_candidate_supported) != len(large_shift):
        fail("not every large-shift simple Work/Open case supports the candidate", failures)
    if simple_inconclusive:
        fail("one or more simple Work/Open cases are not FIT-supported candidate cases", failures)
    if missing_work_open_rows:
        fail("one or more simple Work/Open candidates are missing Work/Open rows", failures)
    if bad_simple_counts:
        fail("one or more simple Work/Open candidates have unexpected activity/plan counts", failures)
    if excluded_accidentally_approved:
        fail("excluded/no-plan/duplicate cases are approved by the simple gate", failures)
    if structured_accidentally_approved:
        fail("structured/special cases are approved by the simple gate", failures)
    if gate.get("fitRuntimeUseAllowed") is not False:
        fail("gate JSON must keep FIT runtime use disabled", failures)
    if gate.get("healthFitDependencyAllowed") is not False:
        fail("gate JSON must keep HealthFit dependency disabled", failures)

    result = {
        "runtimeSource": gate.get("runtimeSource"),
        "validationOracle": gate.get("validationOracle"),
        "fitRuntimeUseAllowed": gate.get("fitRuntimeUseAllowed"),
        "appleFitnessScreenshotsRequired": gate.get("appleFitnessScreenshotsRequired"),
        "gateA_simple_work_open": {
            "simpleWorkOpenTotal": len(simple),
            "fitSupportedCandidateCount": len(simple_candidate_supported),
            "fitSupportedCurrentCount": len(simple_current_supported),
            "fitInconclusiveCount": len(simple_inconclusive),
            "largeShiftTotal": len(large_shift),
            "largeShiftCandidateSupportedCount": len(large_candidate_supported),
            "largeShiftCurrentSupportedCount": len(large_current_supported),
            "noLargeShiftGuardPassCount": len(no_large_shift),
            "missingWorkOpenCandidateRows": len(missing_work_open_rows),
            "unexpectedActivityOrPlanCount": len(bad_simple_counts),
            "decision": "pass_narrow_feature_flagged_prototype_only"
            if not failures
            else "blocked",
        },
        "gateB_custom_multi_step": {
            "structuredIntervalCount": totals.get("totalStructuredIntervals"),
            "warmupWorkCooldownSpecialCount": totals.get("totalSpecials"),
            "structuredSpecialMatchedCount": len(structured_special),
            "decision": "blocked_pending_separate_gate",
        },
        "excluded": {
            "excludedCount": len(excluded),
            "monthlyNoPlanNonfixtureCount": totals.get("totalNoPlanNonfixtureWorkouts"),
            "decision": "excluded_from_production_scoring",
        },
        "broadProductionPromotion": "not_supported",
        "failures": failures,
    }
    return result, failures


def main() -> int:
    result, failures = score()
    print(json.dumps(result, indent=2, sort_keys=True))
    return 1 if failures else 0


if __name__ == "__main__":
    sys.exit(main())
