#!/usr/bin/env python3
from __future__ import annotations

import contextlib
import io
import json
from pathlib import Path
import sys
import tempfile
import unittest


SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR))

import summarize_parity_proof_folder as summarizer  # noqa: E402


def proof_payload(workout_id: str = "workout-1", paired_pause_count: int = 0) -> dict:
    return {
        "generatedAt": "2026-06-25T16:33:46Z",
        "workout": {
            "id": workout_id,
            "startDate": "2026-06-25T11:49:53Z",
            "endDate": "2026-06-25T12:26:40Z",
        },
        "customWorkoutCandidateRuleSummary": {
            "candidateRowCount": 1,
            "plannedExpandedRowCount": 5,
            "openTailRowCount": 1,
            "pairedPauseCount": paired_pause_count,
            "fixedRowExhaustionStatus": "fixed-rows-exhausted-before-tail",
            "tailStatus": "open-extra-tail-present",
        },
        "customWorkoutCandidateRuleRows": [
            {"index": 1, "label": "Open / Extra", "isOpenTail": True},
        ],
        "customWorkoutComparisonSummary": {
            "status": "open-tail-needs-rule",
            "fallbackReasons": [],
            "fallbackReasonLabels": [],
            "rowCount": 1,
            "rowConfidences": ["needsRule"],
            "tailAmbiguity": "fixedCooldownFollowedByPossibleOpenExtraTail",
        },
    }


def mark_payload_supported(payload: dict) -> dict:
    comparison = payload["customWorkoutComparisonSummary"]
    comparison["status"] = "supported"
    comparison["fallbackReasons"] = []
    comparison["fallbackReasonLabels"] = []
    comparison["rowConfidences"] = ["supported"]
    return payload


class SummarizeParityProofFolderTests(unittest.TestCase):
    def test_dedupes_same_payload_across_json_and_text_exports(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = proof_payload()
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")
            (folder / "proof.txt").write_text(json.dumps(payload), encoding="utf-8")

            raw_payloads = summarizer.payloads_in_path(folder)
            deduped = summarizer.dedupe_payloads(raw_payloads)

            self.assertEqual(len(raw_payloads), 2)
            self.assertEqual(len(deduped), 1)

    def test_not_ready_uses_exit_code_three_not_argparse_usage_code(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            (folder / "proof.json").write_text(json.dumps(proof_payload()), encoding="utf-8")

            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = summarizer.main([str(folder)])

            self.assertEqual(code, summarizer.NOT_READY_EXIT_CODE)
            self.assertIn("Result: NOT READY", output.getvalue())
            self.assertIn("paired pause/resume evidence", output.getvalue())

    def test_target_evidence_present_requires_supported_same_payload_comparison(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = mark_payload_supported(proof_payload(paired_pause_count=1))
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")

            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = summarizer.main([str(folder)])

            self.assertEqual(code, 0)
            self.assertIn("Comparison status: supported", output.getvalue())
            self.assertIn("Result: TARGET EVIDENCE PRESENT", output.getvalue())

    def test_blocked_comparison_is_not_ready_even_with_candidate_counters(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = proof_payload(paired_pause_count=1)
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")

            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = summarizer.main([str(folder)])

            self.assertEqual(code, summarizer.NOT_READY_EXIT_CODE)
            self.assertIn("Comparison status: open-tail-needs-rule", output.getvalue())
            self.assertIn("Missing: supported same-payload custom workout comparison", output.getvalue())

    def test_missing_comparison_is_not_ready_even_with_candidate_counters(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = proof_payload(paired_pause_count=1)
            payload.pop("customWorkoutComparisonSummary")
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")

            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = summarizer.main([str(folder)])

            self.assertEqual(code, summarizer.NOT_READY_EXIT_CODE)
            self.assertIn("Comparison status: unavailable", output.getvalue())
            self.assertIn("Missing: same-payload custom workout comparison", output.getvalue())

    def test_allow_missing_readable_fallback_labels_does_not_block_old_exports(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = proof_payload(paired_pause_count=1)
            comparison = payload["customWorkoutComparisonSummary"]
            comparison["fallbackReasons"] = ["openExtraTailAmbiguous"]
            comparison.pop("fallbackReasonLabels")
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")

            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = summarizer.main([
                    "--allow-missing-readable-fallback-labels",
                    str(folder),
                ])

            self.assertEqual(code, summarizer.NOT_READY_EXIT_CODE)
            self.assertIn("Readable fallback labels: no", output.getvalue())
            self.assertNotIn("Missing: readable fallback labels", output.getvalue())

    def test_strict_mode_warns_when_old_exports_are_missing_label_fields(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = proof_payload(paired_pause_count=1)
            comparison = payload["customWorkoutComparisonSummary"]
            comparison["fallbackReasons"] = ["openExtraTailAmbiguous"]
            comparison.pop("fallbackReasonLabels")
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")

            output = io.StringIO()
            with contextlib.redirect_stdout(output):
                code = summarizer.main([str(folder)])

            self.assertEqual(code, 1)
            self.assertIn("Compatibility warning", output.getvalue())
            self.assertIn("--allow-missing-readable-fallback-labels", output.getvalue())
            self.assertIn("Result: FAIL", output.getvalue())

    def test_validator_accepts_whole_file_markdown_json_payload(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "proof.md"
            path.write_text(json.dumps(proof_payload()), encoding="utf-8")

            checked, failures = summarizer.parity_validator.validate_path(path, True)

            self.assertEqual(checked, 1)
            self.assertEqual(failures, [])

    def test_validator_skips_markdown_prose_that_mentions_parity_keys(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "README.md"
            path.write_text(
                "This folder includes customWorkoutComparisonSummary exports.",
                encoding="utf-8",
            )

            checked, failures = summarizer.parity_validator.validate_path(path, True)

            self.assertEqual(checked, 0)
            self.assertEqual(failures, [])

    def test_validator_rejects_non_object_candidate_rows(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "proof.json"
            payload = proof_payload()
            payload["customWorkoutCandidateRuleRows"] = [None]
            path.write_text(json.dumps(payload), encoding="utf-8")

            checked, failures = summarizer.parity_validator.validate_path(path, True)

            self.assertEqual(checked, 0)
            self.assertEqual(len(failures), 1)
            self.assertIn("customWorkoutCandidateRuleRows[0] must be an object", failures[0])

    def test_validator_rejects_unknown_row_confidences(self) -> None:
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "proof.json"
            payload = proof_payload()
            payload["customWorkoutComparisonSummary"]["rowConfidences"] = ["maybe"]
            path.write_text(json.dumps(payload), encoding="utf-8")

            checked, failures = summarizer.parity_validator.validate_path(path, True)

            self.assertEqual(checked, 0)
            self.assertEqual(len(failures), 1)
            self.assertIn("customWorkoutComparisonSummary.rowConfidences[0] must be one of", failures[0])

    def test_validator_result_handles_system_exit_defensively(self) -> None:
        original_main = summarizer.parity_validator.main

        def raises_system_exit(argv: list[str] | None = None) -> int:
            raise SystemExit(1)

        summarizer.parity_validator.main = raises_system_exit
        try:
            ok, _ = summarizer.validator_result(Path("."), True)
        finally:
            summarizer.parity_validator.main = original_main

        self.assertFalse(ok)

    def test_main_returns_validation_failure_code_when_validator_fails(self) -> None:
        original_main = summarizer.parity_validator.main

        def fails_validation(argv: list[str] | None = None) -> int:
            return 1

        with tempfile.TemporaryDirectory() as directory:
            folder = Path(directory)
            payload = mark_payload_supported(proof_payload(paired_pause_count=1))
            (folder / "proof.json").write_text(json.dumps(payload), encoding="utf-8")

            summarizer.parity_validator.main = fails_validation
            try:
                output = io.StringIO()
                with contextlib.redirect_stdout(output):
                    code = summarizer.main([str(folder)])
            finally:
                summarizer.parity_validator.main = original_main

        self.assertEqual(code, 1)
        self.assertIn("Validator: FAIL", output.getvalue())
        self.assertIn("Result: FAIL", output.getvalue())


if __name__ == "__main__":
    unittest.main()
