#!/usr/bin/env python3
"""Validate Raw HealthKit Debug/parity packet export summary consistency.

This is offline proof-folder validation only. It checks that debug/export-only
custom workout summary counts agree with the exported row arrays.
"""

from __future__ import annotations

import argparse
import json
import re
import sys
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent
JSON_FENCE_RE = re.compile(r"```json\s*\n(.*?)\n```", re.DOTALL)
LOWER_CAMEL_RE = re.compile(r"^[a-z]+(?:[A-Z][A-Za-z0-9]*)+$")
SUMMARY_KEY = "customWorkoutCandidateRuleSummary"
ROWS_KEY = "customWorkoutCandidateRuleRows"
COMPARISON_KEY = "customWorkoutComparisonSummary"
FALLBACK_REASONS_KEY = "fallbackReasons"
FALLBACK_REASON_LABELS_KEY = "fallbackReasonLabels"
RELEVANT_KEYS = (SUMMARY_KEY, ROWS_KEY, COMPARISON_KEY)
TEXT_EXPORT_SUFFIXES = {".md", ".txt"}
VALID_ROW_CONFIDENCES = {
    "supported",
    "equivalent",
    "inconclusive",
    "needsRule",
    "missingEvidence",
}


def load_json(path: Path) -> Any:
    with path.open("r", encoding="utf-8") as handle:
        return json.load(handle)


def markdown_payloads(path: Path, allow_whole_file_json: bool = False) -> list[Any]:
    text = path.read_text(encoding="utf-8")
    payloads: list[Any] = []
    for match in JSON_FENCE_RE.finditer(text):
        raw = match.group(1)
        if not any(key in raw for key in RELEVANT_KEYS):
            continue
        try:
            payloads.append(json.loads(raw))
        except json.JSONDecodeError as error:
            raise ValueError(f"invalid JSON fence containing parity export fields: {error}") from error
    if payloads or not allow_whole_file_json or not any(key in text for key in RELEVANT_KEYS):
        return payloads
    if not text.lstrip().startswith(("{", "[")):
        return payloads
    try:
        payloads.append(json.loads(text))
    except json.JSONDecodeError as error:
        raise ValueError(
            f"text contains parity export fields but is not fenced JSON or whole-file JSON: {error}"
        ) from error
    return payloads


def candidate_row_count(payload: dict[str, Any]) -> int | None:
    summary = payload.get(SUMMARY_KEY)
    if summary is None:
        return None
    if not isinstance(summary, dict):
        raise ValueError(f"{SUMMARY_KEY} must be an object")

    rows = payload.get(ROWS_KEY)
    if not isinstance(rows, list):
        raise ValueError(f"{ROWS_KEY} must be an array when {SUMMARY_KEY} is present")
    for index, row in enumerate(rows):
        if not isinstance(row, dict):
            raise ValueError(f"{ROWS_KEY}[{index}] must be an object")
        is_open_tail = row.get("isOpenTail")
        if not isinstance(is_open_tail, bool):
            raise ValueError(f"{ROWS_KEY}[{index}].isOpenTail must be a boolean")
        if "index" in row and not isinstance(row["index"], int):
            raise ValueError(f"{ROWS_KEY}[{index}].index must be an integer")
        if "label" in row and not isinstance(row["label"], str):
            raise ValueError(f"{ROWS_KEY}[{index}].label must be a string")
        if "stepType" in row and not isinstance(row["stepType"], str):
            raise ValueError(f"{ROWS_KEY}[{index}].stepType must be a string")

    expected = summary.get("candidateRowCount")
    if expected != len(rows):
        raise ValueError(
            f"candidateRowCount is {expected}, but {ROWS_KEY} has {len(rows)} rows"
        )

    open_tail_count = sum(1 for row in rows if row.get("isOpenTail") is True)
    expected_open_tail_count = summary.get("openTailRowCount")
    if expected_open_tail_count != open_tail_count:
        raise ValueError(
            f"openTailRowCount is {expected_open_tail_count}, but {open_tail_count} rows have isOpenTail=true"
        )

    return len(rows)


def validate_fallback_reason_labels(
    summary: dict[str, Any],
    require_readable_fallback_labels: bool,
) -> None:
    reasons = summary.get(FALLBACK_REASONS_KEY)
    labels = summary.get(FALLBACK_REASON_LABELS_KEY)

    if reasons is None:
        if labels is not None:
            raise ValueError(
                f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY} is present without "
                f"{FALLBACK_REASONS_KEY}"
            )
        return
    if not isinstance(reasons, list):
        raise ValueError(f"{COMPARISON_KEY}.{FALLBACK_REASONS_KEY} must be an array")

    if labels is None:
        if require_readable_fallback_labels and reasons:
            raise ValueError(
                f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY} is required when "
                f"{FALLBACK_REASONS_KEY} is non-empty"
            )
        return
    if not isinstance(labels, list):
        raise ValueError(f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY} must be an array")
    if len(labels) != len(reasons):
        raise ValueError(
            f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY} has {len(labels)} labels, "
            f"but {FALLBACK_REASONS_KEY} has {len(reasons)} reasons"
        )

    for index, label in enumerate(labels):
        if not isinstance(label, str) or not label.strip():
            raise ValueError(
                f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY}[{index}] must be a non-empty string"
            )
        reason = reasons[index]
        if isinstance(reason, str) and label == reason:
            raise ValueError(
                f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY}[{index}] repeats raw "
                f"fallback reason {reason!r}"
            )
        if LOWER_CAMEL_RE.fullmatch(label):
            raise ValueError(
                f"{COMPARISON_KEY}.{FALLBACK_REASON_LABELS_KEY}[{index}] looks like a raw "
                f"fallback enum value: {label!r}"
            )


def comparison_row_count(
    payload: dict[str, Any],
    require_readable_fallback_labels: bool,
) -> int | None:
    summary = payload.get(COMPARISON_KEY)
    if summary is None:
        return None
    if not isinstance(summary, dict):
        raise ValueError(f"{COMPARISON_KEY} must be an object")

    row_confidences = summary.get("rowConfidences")
    if not isinstance(row_confidences, list):
        raise ValueError(f"{COMPARISON_KEY}.rowConfidences must be an array")
    for index, confidence in enumerate(row_confidences):
        if not isinstance(confidence, str) or confidence not in VALID_ROW_CONFIDENCES:
            raise ValueError(
                f"{COMPARISON_KEY}.rowConfidences[{index}] must be one of "
                f"{', '.join(sorted(VALID_ROW_CONFIDENCES))}"
            )

    expected = summary.get("rowCount")
    if expected != len(row_confidences):
        raise ValueError(
            f"comparison rowCount is {expected}, but rowConfidences has {len(row_confidences)} rows"
        )

    validate_fallback_reason_labels(summary, require_readable_fallback_labels)
    return len(row_confidences)


def validate_payload(payload: Any, require_readable_fallback_labels: bool) -> bool:
    if not isinstance(payload, dict):
        return False
    if not any(key in payload for key in RELEVANT_KEYS):
        return False

    if ROWS_KEY in payload and SUMMARY_KEY not in payload:
        raise ValueError(f"{ROWS_KEY} is present without {SUMMARY_KEY}")

    candidate_row_count(payload)
    comparison_row_count(payload, require_readable_fallback_labels)
    return True


def iter_paths(roots: list[Path]) -> list[Path]:
    paths: list[Path] = []
    for root in roots:
        if root.is_file():
            paths.append(root)
            continue
        for suffix in ("*.json", "*.md", "*.txt"):
            paths.extend(root.rglob(suffix))
    return sorted(set(paths))


def validate_path(path: Path, require_readable_fallback_labels: bool) -> tuple[int, list[str]]:
    payloads: list[Any]
    try:
        if path.suffix == ".json":
            payloads = [load_json(path)]
        elif path.suffix in TEXT_EXPORT_SUFFIXES:
            payloads = markdown_payloads(path, allow_whole_file_json=True)
        else:
            return 0, []
    except (OSError, json.JSONDecodeError, ValueError) as error:
        return 0, [f"{path}: {error}"]

    checked = 0
    failures: list[str] = []
    for index, payload in enumerate(payloads, start=1):
        try:
            if validate_payload(payload, require_readable_fallback_labels):
                checked += 1
        except ValueError as error:
            suffix = f" JSON fence #{index}" if path.suffix in TEXT_EXPORT_SUFFIXES else ""
            failures.append(f"{path}{suffix}: {error}")
    return checked, failures


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        description="Validate debug-only custom workout row counts in proof-folder JSON and text exports."
    )
    parser.add_argument(
        "paths",
        nargs="*",
        type=Path,
        default=[ROOT],
        help="Files or folders to scan. Defaults to the parity dataset folder.",
    )
    parser.add_argument(
        "--require-readable-fallback-labels",
        action="store_true",
        help=(
            "Require customWorkoutComparisonSummary fallbackReasonLabels when "
            "fallbackReasons is non-empty. Use this for fresh proof folders exported "
            "by builds that include readable fallback labels; older archived exports "
            "can still be scanned without this flag."
        ),
    )
    args = parser.parse_args(argv)

    paths = iter_paths([path.resolve() for path in args.paths])
    checked_payloads = 0
    checked_files = 0
    failures: list[str] = []

    for path in paths:
        checked, path_failures = validate_path(path, args.require_readable_fallback_labels)
        if checked:
            checked_files += 1
            checked_payloads += checked
        failures.extend(path_failures)

    if failures:
        for failure in failures:
            print(f"FAIL: {failure}", file=sys.stderr)
        return 1

    skipped_files = len(paths) - checked_files
    print(
        f"Validated {checked_payloads} parity export payload(s) in {checked_files} file(s); "
        f"skipped {skipped_files} JSON/text file(s) without debug parity fields."
    )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
