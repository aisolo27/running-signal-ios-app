import Foundation

struct NormalSplitMetricAverages: Equatable, Sendable {
    var heartRate: Double?
    var cadence: Double?
    var power: Double?

    static let unavailable = NormalSplitMetricAverages(
        heartRate: nil,
        cadence: nil,
        power: nil
    )
}

enum NormalSplitPresentation {
    static func compactLabel(_ label: String, unit: RunningDistanceUnit) -> String {
        guard label != "Final" else { return label }
        let prefix = "\(unit.normalSplitRowPrefix) "
        guard label.hasPrefix(prefix) else { return label }
        return String(label.dropFirst(prefix.count))
    }

    static func supportingText(
        for split: DerivedSplitEstimate,
        policy: RunDisplayPolicy
    ) -> String? {
        var parts: [String] = []
        if split.label == "Final" {
            parts.append(RunFormatters.distance(split.distanceMeters, policy: policy))
            parts.append(RunFormatters.duration(split.durationSecondsEstimate))
        }
        if let pauseOverlap = split.pauseOverlapSeconds, pauseOverlap >= 0.5 {
            parts.append("\(RunFormatters.duration(pauseOverlap)) pause excluded")
        }
        return parts.isEmpty ? nil : parts.joined(separator: " · ")
    }

    static func runnerFacingSourceNote(_ source: DerivedSplitSource) -> String? {
        switch source {
        case .validatedLapEvents, .validatedSegmentEvents, .unavailable:
            nil
        case .distanceSampleWindows:
            "Estimated from available run data"
        case .workoutAverageFallback:
            "Estimated from the workout average"
        }
    }

    static func metricAverages(
        at index: Int,
        splits: [DerivedSplitEstimate],
        workoutStartDate: Date,
        evidence: WorkoutEvidence?
    ) -> NormalSplitMetricAverages {
        guard let evidence, splits.indices.contains(index) else { return .unavailable }
        let split = splits[index]
        let fallbackStartOffset = splits[..<index]
            .map(\.durationSecondsEstimate)
            .reduce(0, +)
        let startOffset = split.elapsedStartOffsetSeconds ?? fallbackStartOffset
        let endOffset = split.elapsedEndOffsetSeconds ?? (startOffset + split.durationSecondsEstimate)
        let start = workoutStartDate.addingTimeInterval(startOffset)
        let end = workoutStartDate.addingTimeInterval(endOffset)

        func average(_ metric: WorkoutEvidenceMetric) -> Double? {
            guard let points = evidence.series[metric]?.points else { return nil }
            let values = points
                .filter { $0.date >= start && $0.date < end }
                .map(\.value)
                .filter { $0.isFinite && $0 > 0 }
            guard !values.isEmpty else { return nil }
            return values.reduce(0, +) / Double(values.count)
        }

        return NormalSplitMetricAverages(
            heartRate: average(.heartRate),
            cadence: average(.cadence),
            power: average(.runningPower)
        )
    }
}
