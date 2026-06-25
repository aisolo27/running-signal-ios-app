#!/usr/bin/env python3
"""Summarize whether a proof folder has the active paused repeat-tail evidence.

This is a reviewer aid only. It validates export consistency, then reports the
debug/export evidence needed for the current blocked row:

Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown >
inferred Open / Extra, with paired pause evidence.
"""

from __future__ import annotations

import argparse
import contextlib
import io
from pathlib import Path
import sys
from typing import Any

import validate_parity_export_consistency as parity_validator


TARGET_SHAPE = (
    "Warmup(2 km) > repeated Work/Recovery rows > fixed final Cooldown > "
    "inferred Open / Extra, with paired pause evidence"
)
TARGET_FIXED_EXHAUSTION = "fixed-rows-exhausted-before-tail"
TARGET_TAIL_STATUS = "open-extra-tail-present"
NOT_READY_EXIT_CODE = 3
EXIT_CODE_HELP = (
    "Exit codes: 0 target evidence present; 1 validation or read failure; "
    "2 command-line usage error; 3 valid proof folder but target evidence missing."
)


def payloads_in_path(path: Path) -> list[tuple[Path, dict[str, Any]]]:
    payloads: list[tuple[Path, dict[str, Any]]] = []
    for candidate in parity_validator.iter_paths([path]):
        try:
            if candidate.suffix == ".json":
                file_payloads = [parity_validator.load_json(candidate)]
            elif candidate.suffix in parity_validator.TEXT_EXPORT_SUFFIXES:
                file_payloads = parity_validator.markdown_payloads(
                    candidate,
                    allow_whole_file_json=True,
                )
            else:
                continue
        except (OSError, ValueError) as error:
            raise ValueError(f"{candidate}: {error}") from error

        for payload in file_payloads:
            if isinstance(payload, dict):
                payloads.append((candidate, payload))
    return payloads


def payload_identity(payload: dict[str, Any]) -> tuple[Any, ...]:
    workout = payload.get("workout")
    workout_id = None
    workout_start = None
    workout_end = None
    if isinstance(workout, dict):
        workout_id = workout.get("id") or workout.get("sourceID")
        workout_start = workout.get("startDate")
        workout_end = workout.get("endDate")

    candidate = payload.get(parity_validator.SUMMARY_KEY)
    comparison = payload.get(parity_validator.COMPARISON_KEY)
    candidate_signature: tuple[Any, ...] = ()
    comparison_signature: tuple[Any, ...] = ()
    if isinstance(candidate, dict):
        candidate_signature = (
            candidate.get("candidateRowCount"),
            candidate.get("plannedExpandedRowCount"),
            candidate.get("openTailRowCount"),
            candidate.get("pairedPauseCount"),
            candidate.get("fixedRowExhaustionStatus"),
            candidate.get("tailStatus"),
        )
    if isinstance(comparison, dict):
        comparison_signature = (
            comparison.get("status"),
            tuple(comparison.get("fallbackReasons") or []),
            comparison.get("rowCount"),
            comparison.get("tailAmbiguity"),
        )

    return (
        workout_id,
        workout_start,
        workout_end,
        candidate_signature,
        comparison_signature,
    )


def dedupe_payloads(payloads: list[tuple[Path, dict[str, Any]]]) -> list[tuple[Path, dict[str, Any]]]:
    # Validator counts every export payload; this reviewer summary counts distinct workouts.
    seen: set[tuple[Any, ...]] = set()
    deduped: list[tuple[Path, dict[str, Any]]] = []
    for path, payload in payloads:
        identity = payload_identity(payload)
        if identity in seen:
            continue
        seen.add(identity)
        deduped.append((path, payload))
    return deduped


def validator_result(path: Path, require_readable_fallback_labels: bool) -> tuple[bool, str]:
    buffer = io.StringIO()
    with contextlib.redirect_stdout(buffer), contextlib.redirect_stderr(buffer):
        try:
            code = parity_validator.main(
                [
                    "--require-readable-fallback-labels",
                    str(path),
                ]
                if require_readable_fallback_labels
                else [str(path)]
            )
        except SystemExit as error:
            code = int(error.code) if isinstance(error.code, int) else 1
    return code == 0, buffer.getvalue().strip()


def int_value(value: Any) -> int:
    if isinstance(value, bool):
        return int(value)
    if isinstance(value, int):
        return value
    if isinstance(value, float):
        return int(value)
    return 0


def bool_label(value: bool) -> str:
    return "yes" if value else "no"


def best_payload(
    payloads: list[tuple[Path, dict[str, Any]]],
) -> tuple[Path | None, dict[str, Any], dict[str, Any], dict[str, Any]]:
    best_path: Path | None = None
    best_payload_value: dict[str, Any] = {}
    best: dict[str, Any] = {}
    best_comparison: dict[str, Any] = {}
    best_score = -1

    for path, payload in payloads:
        summary = payload.get(parity_validator.SUMMARY_KEY)
        if not isinstance(summary, dict):
            continue
        comparison = payload.get(parity_validator.COMPARISON_KEY)
        if not isinstance(comparison, dict):
            comparison = {}

        score = 0
        score += int_value(summary.get("pairedPauseCount")) * 10
        score += int_value(summary.get("openTailRowCount")) * 5
        if summary.get("fixedRowExhaustionStatus") == TARGET_FIXED_EXHAUSTION:
            score += 3
        if summary.get("tailStatus") == TARGET_TAIL_STATUS:
            score += 2
        if int_value(summary.get("plannedExpandedRowCount")) >= 5:
            score += 1

        if score > best_score:
            best_score = score
            best_path = path
            best_payload_value = payload
            best = summary
            best_comparison = comparison

    return best_path, best_payload_value, best, best_comparison


def comparison_summaries(payloads: list[tuple[Path, dict[str, Any]]]) -> list[dict[str, Any]]:
    summaries: list[dict[str, Any]] = []
    for _, payload in payloads:
        summary = payload.get(parity_validator.COMPARISON_KEY)
        if isinstance(summary, dict):
            summaries.append(summary)
    return summaries


def missing_readable_label_fields(comparisons: list[dict[str, Any]]) -> bool:
    return any(
        summary.get("fallbackReasons") and "fallbackReasonLabels" not in summary
        for summary in comparisons
    )


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Summarize active paused repeat-tail proof evidence in a folder.",
        epilog=EXIT_CODE_HELP,
    )
    parser.add_argument("proof_folder", type=Path)
    parser.add_argument(
        "--require-readable-fallback-labels",
        action="store_true",
        default=True,
        help="Require readable fallback labels in fresh proof exports. Enabled by default.",
    )
    parser.add_argument(
        "--allow-missing-readable-fallback-labels",
        action="store_false",
        dest="require_readable_fallback_labels",
        help="Allow older archived exports that predate readable fallback labels.",
    )
    args = parser.parse_args(argv)

    folder = args.proof_folder.resolve()
    validator_ok, validator_output = validator_result(
        folder,
        args.require_readable_fallback_labels,
    )

    try:
        raw_payloads = payloads_in_path(folder)
    except ValueError as error:
        print(f"FAIL: {error}", file=sys.stderr)
        return 1

    payloads = dedupe_payloads(raw_payloads)
    candidate_path, selected_payload, candidate, selected_comparison = best_payload(payloads)
    comparisons = comparison_summaries(payloads)
    missing_readable_fields = missing_readable_label_fields(comparisons)

    paired_pause_count = int_value(candidate.get("pairedPauseCount"))
    open_tail_count = int_value(candidate.get("openTailRowCount"))
    fixed_exhausted = candidate.get("fixedRowExhaustionStatus") == TARGET_FIXED_EXHAUSTION
    tail_present = candidate.get("tailStatus") == TARGET_TAIL_STATUS
    comparison_status = selected_comparison.get("status")
    comparison_fallbacks = selected_comparison.get("fallbackReasons")
    comparison_row_count = int_value(selected_comparison.get("rowCount"))
    comparison_supported = (
        comparison_status == "supported"
        and isinstance(comparison_fallbacks, list)
        and len(comparison_fallbacks) == 0
        and comparison_row_count > 0
    )
    readable_labels = all(
        not summary.get("fallbackReasons")
        or isinstance(summary.get("fallbackReasonLabels"), list)
        and len(summary.get("fallbackReasonLabels", [])) == len(summary.get("fallbackReasons", []))
        for summary in comparisons
    )

    missing: list[str] = []
    if not candidate:
        missing.append("candidate rule summary")
    if not selected_payload:
        missing.append("selected payload")
    if not selected_comparison:
        missing.append("same-payload custom workout comparison")
    elif not comparison_supported:
        missing.append("supported same-payload custom workout comparison")
    if paired_pause_count <= 0:
        missing.append("paired pause/resume evidence")
    if open_tail_count <= 0:
        missing.append("Open / Extra tail row")
    if not fixed_exhausted:
        missing.append("fixed final cooldown exhaustion")
    if not tail_present:
        missing.append("tail status open-extra-tail-present")
    if args.require_readable_fallback_labels and not readable_labels:
        missing.append("readable fallback labels")

    print(f"Proof folder: {folder}")
    print(f"Target shape: {TARGET_SHAPE}")
    print(f"Validator: {'PASS' if validator_ok else 'FAIL'}")
    if validator_output:
        print(f"Validator output: {validator_output}")
    if args.require_readable_fallback_labels and missing_readable_fields:
        print(
            "Compatibility warning: fallbackReasons are present without "
            "fallbackReasonLabels. If this is an older archive, rerun with "
            "--allow-missing-readable-fallback-labels; if this is fresh proof, "
            "re-export from the current app build."
        )
    print(f"Parsed payloads: {len(raw_payloads)}")
    print(f"Unique payloads: {len(payloads)}")
    print(f"Best candidate source: {candidate_path or 'none'}")
    print(f"Candidate row count: {candidate.get('candidateRowCount', 'unavailable')}")
    print(f"Planned expanded row count: {candidate.get('plannedExpandedRowCount', 'unavailable')}")
    print(f"Open tail row count: {open_tail_count}")
    print(f"Paired pause count: {paired_pause_count}")
    print(f"Fixed cooldown exhausted before tail: {bool_label(fixed_exhausted)}")
    print(f"Tail present: {bool_label(tail_present)}")
    print(f"Comparison status: {comparison_status or 'unavailable'}")
    print(
        "Readable fallback labels: "
        f"{bool_label(readable_labels)}"
    )

    if not validator_ok:
        print("Result: FAIL")
        return 1

    if missing:
        print("Result: NOT READY")
        print(f"Missing: {', '.join(missing)}")
        return NOT_READY_EXIT_CODE

    print("Result: TARGET EVIDENCE PRESENT")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
