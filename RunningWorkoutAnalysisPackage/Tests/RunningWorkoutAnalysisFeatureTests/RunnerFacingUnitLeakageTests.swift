import Foundation
import Testing

private let runnerFacingUnitAuditFiles = [
    "Views.swift",
    "AnalyticsViews.swift",
    "RunReviewUXSummary.swift",
    "IntervalGoalMeasuredText.swift",
]

private let intentionalUnitAuditMarkers = [
    "runner-unit-audit: allow-authored-prescription",
    "runner-unit-audit: allow-developer-debug",
    "runner-unit-audit: allow-stable-split-identifier",
]

@Test func runnerFacingSourcesDoNotHardCodeKilometerDisplayLabels() throws {
    let sourceDirectory = URL(fileURLWithPath: #filePath)
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .deletingLastPathComponent()
        .appending(path: "Sources/RunningWorkoutAnalysisFeature", directoryHint: .isDirectory)
    let fixedKilometerToken = try NSRegularExpression(pattern: #"(?i)(/km|\bkm\b)"#)
    var violations: [String] = []

    for filename in runnerFacingUnitAuditFiles {
        let sourceURL = sourceDirectory.appending(path: filename)
        let source = try String(contentsOf: sourceURL, encoding: .utf8)

        for (offset, line) in source.split(separator: "\n", omittingEmptySubsequences: false).enumerated() {
            let sourceLine = String(line)
            let range = NSRange(sourceLine.startIndex..<sourceLine.endIndex, in: sourceLine)
            guard fixedKilometerToken.firstMatch(in: sourceLine, range: range) != nil else { continue }
            guard containsStringLiteralWithFixedKilometerToken(sourceLine, regex: fixedKilometerToken) else { continue }
            guard !intentionalUnitAuditMarkers.contains(where: sourceLine.contains) else { continue }

            violations.append("\(filename):\(offset + 1): \(sourceLine.trimmingCharacters(in: .whitespaces))")
        }
    }

    #expect(
        violations.isEmpty,
        "Hard-coded runner-facing kilometer labels must use RunDisplayPolicy/RunFormatters. Intentional authored prescriptions, developer debug text, or stable split identifiers require one exact runner-unit-audit allow marker.\n\(violations.joined(separator: "\n"))"
    )
}

@Test func runnerFacingUnitLeakDetectorTargetsLabelsWithoutFlaggingCanonicalIdentifiers() throws {
    let fixedKilometerToken = try NSRegularExpression(pattern: #"(?i)(/km|\bkm\b)"#)

    #expect(containsStringLiteralWithFixedKilometerToken(#"Text("1 km Splits")"#, regex: fixedKilometerToken))
    #expect(containsStringLiteralWithFixedKilometerToken(#"return "\(seconds)s/km slower""#, regex: fixedKilometerToken))
    #expect(containsStringLiteralWithFixedKilometerToken(#".chartYAxisLabel("km")"#, regex: fixedKilometerToken))
    #expect(!containsStringLiteralWithFixedKilometerToken("let paceSecondsPerKm = 422", regex: fixedKilometerToken))
    #expect(!containsStringLiteralWithFixedKilometerToken(#"Text("kilometer splits")"#, regex: fixedKilometerToken))
    #expect(!containsStringLiteralWithFixedKilometerToken(#"Text("11:19/mi")"#, regex: fixedKilometerToken))
}

private func containsStringLiteralWithFixedKilometerToken(
    _ line: String,
    regex: NSRegularExpression
) -> Bool {
    var insideString = false
    var isEscaped = false
    var literal = ""

    for character in line {
        if insideString {
            if isEscaped {
                literal.append(character)
                isEscaped = false
                continue
            }
            if character == "\\" {
                literal.append(character)
                isEscaped = true
                continue
            }
            if character == "\"" {
                let range = NSRange(literal.startIndex..<literal.endIndex, in: literal)
                if regex.firstMatch(in: literal, range: range) != nil {
                    return true
                }
                literal = ""
                insideString = false
                continue
            }
            literal.append(character)
        } else if character == "\"" {
            insideString = true
        }
    }

    if insideString {
        let range = NSRange(literal.startIndex..<literal.endIndex, in: literal)
        return regex.firstMatch(in: literal, range: range) != nil
    }
    return false
}
