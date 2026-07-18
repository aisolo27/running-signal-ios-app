import Foundation

public struct DerivedAnalyticsInputSummary: Codable, Equatable, Sendable {
    public var workoutID: String
    public var evidenceLoadedAt: Date
    public var seriesSampleCounts: [String: Int]
    public var seriesValueSums: [String: Double]
    public var seriesFirstSampleAt: [String: Date]
    public var seriesLastSampleAt: [String: Date]
    public var routePointCount: Int
    public var routeSignature: String
    public var eventCount: Int
    public var eventSignature: String
    public var distanceMeters: Double?
    public var durationSeconds: Double

    public init(workout: CanonicalWorkout, evidence: WorkoutEvidence) {
        workoutID = workout.id
        evidenceLoadedAt = evidence.loadedAt
        seriesSampleCounts = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.map { ($0.rawValue, evidence.sampleCount($0)) }
        )
        seriesValueSums = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.map { metric in
                (metric.rawValue, evidence.series[metric]?.points.map(\.value).reduce(0, +) ?? 0)
            }
        )
        seriesFirstSampleAt = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.compactMap { metric in
                guard let date = evidence.series[metric]?.points.first?.date else { return nil }
                return (metric.rawValue, date)
            }
        )
        seriesLastSampleAt = Dictionary(
            uniqueKeysWithValues: WorkoutEvidenceMetric.allCases.compactMap { metric in
                guard let date = evidence.series[metric]?.points.last?.date else { return nil }
                return (metric.rawValue, date)
            }
        )
        routePointCount = evidence.route.count
        routeSignature = Self.routeSignature(evidence.route)
        eventCount = evidence.events.count
        eventSignature = Self.eventSignature(evidence.events)
        distanceMeters = workout.distanceMeters
        durationSeconds = workout.durationSeconds
    }

    private static func routeSignature(_ route: [WorkoutRoutePoint]) -> String {
        guard let first = route.first, let last = route.last else { return "none" }
        return [
            "\(first.date.ISO8601Format())@\(first.latitude),\(first.longitude)",
            "\(last.date.ISO8601Format())@\(last.latitude),\(last.longitude)"
        ].joined(separator: "...")
    }

    private static func eventSignature(_ events: [WorkoutEvidenceEvent]) -> String {
        guard !events.isEmpty else { return "none" }
        return events.map { event in
            [
                event.startDate.ISO8601Format(),
                event.endDate.ISO8601Format(),
                event.type,
                event.label ?? ""
            ].joined(separator: ":")
        }.joined(separator: "|")
    }
}

public struct DerivedBestEffortEstimate: Codable, Equatable, Sendable {
    public var label: String
    public var distanceMeters: Double
    public var durationSecondsEstimate: Double
    public var paceSecondsPerKmEstimate: Double
    public var confidence: ConfidenceLevel
    public var source: String
}

public struct DerivedSplitEstimate: Codable, Equatable, Sendable {
    public var label: String
    public var distanceMeters: Double
    public var durationSecondsEstimate: Double
    public var paceSecondsPerKmEstimate: Double
    public var confidence: ConfidenceLevel
    public var elapsedStartOffsetSeconds: Double?
    public var elapsedEndOffsetSeconds: Double?
    public var pauseOverlapSeconds: Double?

    public init(
        label: String,
        distanceMeters: Double,
        durationSecondsEstimate: Double,
        paceSecondsPerKmEstimate: Double,
        confidence: ConfidenceLevel,
        elapsedStartOffsetSeconds: Double? = nil,
        elapsedEndOffsetSeconds: Double? = nil,
        pauseOverlapSeconds: Double? = nil
    ) {
        self.label = label
        self.distanceMeters = distanceMeters
        self.durationSecondsEstimate = durationSecondsEstimate
        self.paceSecondsPerKmEstimate = paceSecondsPerKmEstimate
        self.confidence = confidence
        self.elapsedStartOffsetSeconds = elapsedStartOffsetSeconds
        self.elapsedEndOffsetSeconds = elapsedEndOffsetSeconds
        self.pauseOverlapSeconds = pauseOverlapSeconds
    }
}

public enum DerivedSplitSource: String, Codable, Equatable, Sendable {
    case validatedLapEvents
    case validatedSegmentEvents
    case distanceSampleWindows
    case workoutAverageFallback
    case unavailable

    public var label: String {
        switch self {
        case .validatedLapEvents:
            "Recorded Apple Health lap boundaries"
        case .validatedSegmentEvents:
            "Validated Apple Health split boundaries"
        case .distanceSampleWindows:
            "Estimated across Apple Health distance windows"
        case .workoutAverageFallback:
            "Estimated from the whole-workout average"
        case .unavailable:
            "Unavailable"
        }
    }
}

public struct DerivedSplitDiagnostics: Codable, Equatable, Sendable {
    public var unit: RunningDistanceUnit? = nil
    public var targetDistanceMeters: Double? = nil
    public var rowPrefix: String? = nil
    public var source: DerivedSplitSource
    public var sourceLabel: String
    public var totalDistanceMeters: Double?
    public var distanceSampleCount: Int
    public var lapEventCount: Int
    public var eligibleLapEventCount: Int
    public var selectedLapEventCount: Int
    public var segmentEventCount: Int
    public var eligibleSegmentEventCount: Int
    public var expectedFullKilometerCount: Int
    public var expectedFullUnitCount: Int? = nil
    public var expectedRowCount: Int
    public var completeSegmentChainCount: Int
    public var terminalSegmentChainCount: Int
    public var distanceValidatedSegmentChainCount: Int
    public var selectedSegmentEventCount: Int
    public var terminalEvidenceOffsetSeconds: Double?
    public var workoutSummaryDistanceMeters: Double?
    public var distanceReconciliationDeltaMeters: Double?
    public var maximumDistanceSampleWindowSeconds: Double?
    public var uncoveredDistanceWindowSeconds: Double?
    public var pauseAdjustmentSeconds: Double?
    public var fallbackReason: String?
    public var validationNotes: [String]
    public var splitEstimates: [DerivedSplitEstimate]
}

public struct DerivedExecutionSegment: Codable, Equatable, Sendable {
    public var label: String
    public var heartRateAverage: Double?
    public var heartRateConfidence: ConfidenceLevel
    public var paceSecondsPerKmEstimate: Double?
    public var paceConfidence: ConfidenceLevel
}

public enum DerivedIntervalLabel: String, Codable, Sendable {
    case warmup
    case work
    case recovery
    case cooldown
    case open
    case unknown

    public var displayName: String {
        switch self {
        case .warmup: "Warmup"
        case .work: "Work"
        case .recovery: "Recovery"
        case .cooldown: "Cooldown"
        case .open: "Open"
        case .unknown: "Unknown"
        }
    }
}

public enum DerivedIntervalSource: String, Codable, Sendable {
    case resolvedCustomWorkoutRow
    case healthKitLabeledEvent
    case healthKitSegmentPattern
    case inferredPattern
    case manual

    public var displayName: String {
        switch self {
        case .resolvedCustomWorkoutRow: "Resolved custom workout row"
        case .healthKitLabeledEvent: "HealthKit labeled event"
        case .healthKitSegmentPattern: "HealthKit segment pattern"
        case .inferredPattern: "Inferred pattern"
        case .manual: "Manual"
        }
    }
}

public enum DerivedIntervalMarkerKind: String, Codable, Sendable {
    case resolvedActivityBoundaryRow
    case appleFitnessIntervalCandidate
    case splitMarker
    case overlappingSegmentMarker
    case rawSegmentMarker

    public var displayName: String {
        switch self {
        case .resolvedActivityBoundaryRow: "Resolved activity-boundary row"
        case .appleFitnessIntervalCandidate: "Interval candidate"
        case .splitMarker: "Split marker"
        case .overlappingSegmentMarker: "Overlapping segment marker"
        case .rawSegmentMarker: "Raw segment marker"
        }
    }
}

public struct DerivedWorkoutInterval: Codable, Equatable, Sendable {
    public var index: Int
    public var label: DerivedIntervalLabel
    public var startDate: Date
    public var endDate: Date
    public var startOffsetSeconds: Double
    public var endOffsetSeconds: Double
    public var durationSeconds: Double
    public var distanceMeters: Double?
    public var paceSecondsPerKm: Double?
    public var averageHeartRateBpm: Double?
    public var source: DerivedIntervalSource
    public var markerKind: DerivedIntervalMarkerKind
    public var confidence: ConfidenceLevel
    public var caveats: [String]
}

public struct DerivedWorkoutAnalysis: Codable, Equatable, Sendable {
    public static let currentVersion = "derived-workout-v7"

    public var workoutID: String
    public var calculationVersion: String
    public var inputSummary: DerivedAnalyticsInputSummary
    public var paceSecondsPerKmEstimate: Double?
    public var paceConfidence: ConfidenceLevel
    public var pacingShape: String?
    public var pacingShapeConfidence: ConfidenceLevel
    public var heartRateDriftPercent: Double?
    public var heartRateDriftConfidence: ConfidenceLevel
    public var cadenceAverage: Double?
    public var powerAverage: Double?
    public var strideLengthAverage: Double?
    public var verticalOscillationAverage: Double?
    public var groundContactAverage: Double?
    public var mechanicsConfidence: ConfidenceLevel
    public var bestEffortEstimates: [DerivedBestEffortEstimate]
    public var personalBestEffortRecords: [PersonalBestEffortRecord]? = nil
    public var splitEstimates: [DerivedSplitEstimate]?
    public var splitSource: DerivedSplitSource? = nil
    public var splitUnavailableReason: String? = nil
    public var mileSplitEstimates: [DerivedSplitEstimate]? = nil
    public var mileSplitSource: DerivedSplitSource? = nil
    public var mileSplitUnavailableReason: String? = nil
    public var executionSegments: [DerivedExecutionSegment]?
    public var intervalCandidates: [DerivedWorkoutInterval]?
    public var officialIntervalWorkout: OfficialIntervalWorkout? = nil
    public var intervalCount: Int
    public var intervalConfidence: ConfidenceLevel
    public var readinessConfidence: ConfidenceLevel
    public var dataQualityConfidence: ConfidenceLevel
    public var caveats: [String]
}

public enum DerivedAnalyticsEngine {
    private struct IndexedSegmentEvent {
        var index: Int
        var event: WorkoutEvidenceEvent
    }

    private struct SegmentSplitEvaluation {
        var splits: [DerivedSplitEstimate]?
        var segmentEventCount: Int
        var eligibleSegmentEventCount: Int
        var completeChainCount: Int
        var terminalChainCount: Int
        var validatedChainCount: Int
        var terminalEvidenceDate: Date?
        var fallbackReason: String?
        var validationNotes: [String]
    }

    private struct LapSplitEvaluation {
        var splits: [DerivedSplitEstimate]?
        var lapEventCount: Int
        var eligibleLapEventCount: Int
        var completeChainCount: Int
        var terminalChainCount: Int
        var validatedChainCount: Int
        var fallbackReason: String?
        var validationNotes: [String]
    }

    private struct DistanceSeriesAssessment {
        var series: WorkoutMetricSeries?
        var totalDistanceMeters: Double?
        var reconciliationDeltaMeters: Double?
        var maximumWindowSeconds: Double?
        var uncoveredWindowSeconds: Double?
        var terminalEvidenceDate: Date?
        var rejectionReason: String?
        var validationNotes: [String]
    }

    private struct NormalSplitPauseTimeline {
        var intervals: [DateInterval]
        var expectedPausedSeconds: Double
        var sourceLabel: String?

        var totalPausedSeconds: Double {
            intervals.map(\.duration).reduce(0, +)
        }

        func overlapSeconds(start: Date, end: Date) -> Double {
            guard end > start else { return 0 }
            return intervals.reduce(0) { total, interval in
                let overlapStart = max(start, interval.start)
                let overlapEnd = min(end, interval.end)
                guard overlapEnd > overlapStart else { return total }
                return total + overlapEnd.timeIntervalSince(overlapStart)
            }
        }

        func activeDuration(start: Date, end: Date) -> Double {
            max(0, end.timeIntervalSince(start) - overlapSeconds(start: start, end: end))
        }

        func dateAdvancingActiveTime(from start: Date, seconds: Double, noLaterThan end: Date) -> Date {
            guard seconds > 0 else { return start }
            var cursor = start
            var remaining = seconds
            for interval in intervals where interval.end > cursor && interval.start < end {
                let activeEnd = min(interval.start, end)
                let available = max(0, activeEnd.timeIntervalSince(cursor))
                if remaining <= available {
                    return cursor.addingTimeInterval(remaining)
                }
                remaining -= available
                cursor = max(cursor, interval.end)
                if cursor >= end { return end }
            }
            return min(cursor.addingTimeInterval(remaining), end)
        }
    }

    private struct NormalSplitPauseAssessment {
        var timeline: NormalSplitPauseTimeline?
        var rejectionReason: String?
        var validationNotes: [String]
    }

    public static func analyze(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> DerivedWorkoutAnalysis {
        let speedSeries = evidence.series[.runningSpeed]
        let distanceSeries = evidence.series[.distance]
        let heartRateSeries = evidence.series[.heartRate]
        let coverage = WorkoutEvidenceAnalyzer.coverage(for: evidence)
        let inputSummary = DerivedAnalyticsInputSummary(workout: workout, evidence: evidence)

        let pace = PaceMath.paceSecondsPerKm(
            distanceMeters: workout.distanceMeters ?? evidence.sum(.distance),
            durationSeconds: workout.durationSeconds
        )

        let hasRollingPaceEvidence = (speedSeries?.sampleCount ?? 0) > 1 || (distanceSeries?.sampleCount ?? 0) > 1
        let paceConfidence: ConfidenceLevel = hasRollingPaceEvidence ? .moderate : (pace == nil ? .unavailable : .limited)

        let pacingShape: String?
        let pacingShapeConfidence: ConfidenceLevel
        if let speedSeries, speedSeries.sampleCount >= 3 {
            pacingShape = paceShape(from: speedSeries.points.map(\.value))
            pacingShapeConfidence = .moderate
        } else if let distanceSeries, distanceSeries.sampleCount >= 3 {
            pacingShape = "Distance-series based"
            pacingShapeConfidence = .limited
        } else {
            pacingShape = nil
            pacingShapeConfidence = .unavailable
        }

        let heartRateDrift = heartRateSeries.flatMap { driftPercent(points: $0.points) }
        let heartRateDriftConfidence: ConfidenceLevel = heartRateDrift == nil ? .unavailable : .moderate
        let mechanicsConfidence: ConfidenceLevel = coverage.mechanics ? (coverage.speedOrDistance ? .moderate : .limited) : .unavailable

        var caveats = coverage.caveats
        if !hasRollingPaceEvidence {
            caveats.append("Whole-workout average pace is an estimate until rolling speed or distance evidence exists.")
        }
        if heartRateDrift == nil {
            caveats.append("Heart-rate drift is unavailable without enough heart-rate samples.")
        }
        let resolvedRows = resolvedIntervalRows(workout: workout, evidence: evidence)
        let officialIntervalWorkout = CustomWorkoutNormalDetailGate
            .supportedIntervals(workout: workout, evidence: evidence)
            .map {
                OfficialIntervalWorkout(
                    workoutID: workout.id,
                    startDate: workout.startDate,
                    rows: $0.intervals
                )
            }
        var evidenceWorkout = workout
        evidenceWorkout.evidence = evidence
        let personalBestEffortRecords = PersonalBestEffortEngine.records(for: evidenceWorkout)
        let splitDerivation = splitDiagnostics(workout: workout, evidence: evidence, unit: .kilometers)
        let mileSplitDerivation = splitDiagnostics(workout: workout, evidence: evidence, unit: .miles)

        return DerivedWorkoutAnalysis(
            workoutID: workout.id,
            calculationVersion: DerivedWorkoutAnalysis.currentVersion,
            inputSummary: inputSummary,
            paceSecondsPerKmEstimate: pace,
            paceConfidence: paceConfidence,
            pacingShape: pacingShape,
            pacingShapeConfidence: pacingShapeConfidence,
            heartRateDriftPercent: heartRateDrift,
            heartRateDriftConfidence: heartRateDriftConfidence,
            cadenceAverage: evidence.average(.cadence) ?? evidence.average(.stepCount),
            powerAverage: evidence.average(.runningPower),
            strideLengthAverage: evidence.average(.strideLength),
            verticalOscillationAverage: evidence.average(.verticalOscillation),
            groundContactAverage: evidence.average(.groundContactTime),
            mechanicsConfidence: mechanicsConfidence,
            bestEffortEstimates: bestEffortEstimates(
                workout: workout,
                evidence: evidence,
                paceEstimate: pace,
                paceConfidence: paceConfidence
            ),
            personalBestEffortRecords: personalBestEffortRecords,
            splitEstimates: splitDerivation.splitEstimates,
            splitSource: splitDerivation.source,
            splitUnavailableReason: splitDerivation.source == .unavailable ? splitDerivation.fallbackReason : nil,
            mileSplitEstimates: mileSplitDerivation.splitEstimates,
            mileSplitSource: mileSplitDerivation.source,
            mileSplitUnavailableReason: mileSplitDerivation.source == .unavailable ? mileSplitDerivation.fallbackReason : nil,
            executionSegments: executionSegments(heartRateSeries: heartRateSeries, speedSeries: speedSeries),
            intervalCandidates: resolvedRows.isEmpty ? nil : resolvedRows,
            officialIntervalWorkout: officialIntervalWorkout,
            intervalCount: evidence.events.count,
            intervalConfidence: resolvedRows.isEmpty ? .unavailable : .moderate,
            readinessConfidence: minConfidence(coverage.confidence, paceConfidence),
            dataQualityConfidence: coverage.confidence,
            caveats: orderedUnique(caveats)
        )
    }

    private static func paceShape(from values: [Double]) -> String {
        guard let first = values.first, let last = values.last, first > 0 else { return "Unknown" }
        let change = (last - first) / first
        if change >= 0.05 { return "Faster finish" }
        if change <= -0.05 { return "Fading finish" }
        return "Even"
    }

    private static func driftPercent(points: [WorkoutEvidencePoint]) -> Double? {
        let points = points.sorted { $0.date < $1.date }
        guard points.count >= 4,
              let start = points.first?.date,
              let end = points.last?.date,
              end > start else { return nil }
        let midpoint = start.addingTimeInterval(end.timeIntervalSince(start) / 2)
        let firstHalf = points.filter { $0.date <= midpoint }
        let secondHalf = points.filter { $0.date > midpoint }
        guard !firstHalf.isEmpty, !secondHalf.isEmpty else { return nil }
        let firstAverage = timeWeightedAverage(firstHalf, windowEnd: midpoint)
        guard firstAverage > 0 else { return nil }
        let secondAverage = timeWeightedAverage(secondHalf, windowEnd: end)
        return ((secondAverage - firstAverage) / firstAverage) * 100
    }

    private static func timeWeightedAverage(
        _ points: [WorkoutEvidencePoint],
        windowEnd: Date
    ) -> Double {
        let sorted = points.sorted { $0.date < $1.date }
        let totals = sorted.indices.reduce(into: (weighted: 0.0, duration: 0.0)) { partial, index in
            let point = sorted[index]
            let nextDate = index + 1 < sorted.count ? sorted[index + 1].date : windowEnd
            let duration = max(0, nextDate.timeIntervalSince(point.date))
            guard duration > 0 else { return }
            partial.weighted += point.value * duration
            partial.duration += duration
        }
        guard totals.duration > 0 else {
            return sorted.map(\.value).reduce(0, +) / Double(sorted.count)
        }
        return totals.weighted / totals.duration
    }

    private static func bestEffortEstimates(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        paceEstimate: Double?,
        paceConfidence: ConfidenceLevel
    ) -> [DerivedBestEffortEstimate] {
        guard let workoutDistance = workout.distanceMeters, workoutDistance > 0 else { return [] }
        let targets: [(String, Double)] = [
            ("400m", 400),
            ("1K", 1_000),
            ("Mile", 1_609.34),
            ("2-mile", 3_218.68),
            ("5K", 5_000),
            ("10K", 10_000)
        ]
        let distanceSeries = evidence.series[.distance]

        return targets.compactMap { label, target in
            guard workoutDistance >= target * 0.96 else { return nil }
            let rollingDuration = distanceSeries.flatMap {
                durationToCover(distanceMeters: target, from: $0, workoutStart: workout.startDate)
            }
            let duration = rollingDuration ?? paceEstimate.map {
                PaceMath.secondsForDistance(paceSecondsPerKm: $0, distanceMeters: target)
            }
            guard let duration, duration.isFinite, duration > 0 else { return nil }
            let confidence: ConfidenceLevel = rollingDuration == nil ? minConfidence(paceConfidence, .limited) : .moderate
            return DerivedBestEffortEstimate(
                label: label,
                distanceMeters: target,
                durationSecondsEstimate: duration,
                paceSecondsPerKmEstimate: duration / (target / 1_000),
                confidence: confidence,
                source: rollingDuration == nil ? "whole-workout pace estimate" : "rolling distance evidence"
            )
        }
    }

    public static func splitDiagnostics(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        unit: RunningDistanceUnit = .kilometers
    ) -> DerivedSplitDiagnostics {
        let targetMeters = unit.metersPerUnit
        let rowPrefix = unit.normalSplitRowPrefix
        let unitName = unit == .kilometers ? "kilometer" : "mile"
        let lapEventCount = evidence.events.filter(isLapEvent).count
        let segmentEventCount = evidence.events.filter(isSegmentEvent).count
        let distanceAssessment = assessDistanceSeries(workout: workout, evidence: evidence)
        let totalDistance = distanceAssessment.totalDistanceMeters ?? workout.distanceMeters
        let fullUnits = totalDistance.flatMap { $0.isFinite && $0 > 0 ? Int($0 / targetMeters) : nil } ?? 0
        let remainderDistance = (totalDistance ?? 0) - (Double(fullUnits) * targetMeters)
        let expectedRowCount = fullUnits + (remainderDistance >= 10 ? 1 : 0)
        let pauseAssessment = normalSplitPauseAssessment(workout: workout, events: evidence.events)

        let emptySegmentEvaluation = SegmentSplitEvaluation(
            splits: nil,
            segmentEventCount: segmentEventCount,
            eligibleSegmentEventCount: 0,
            completeChainCount: 0,
            terminalChainCount: 0,
            validatedChainCount: 0,
            terminalEvidenceDate: distanceAssessment.terminalEvidenceDate,
            fallbackReason: distanceAssessment.rejectionReason,
            validationNotes: []
        )
        let emptyLapEvaluation = LapSplitEvaluation(
            splits: nil,
            lapEventCount: lapEventCount,
            eligibleLapEventCount: 0,
            completeChainCount: 0,
            terminalChainCount: 0,
            validatedChainCount: 0,
            fallbackReason: lapEventCount == 0 ? "No lap events are available." : nil,
            validationNotes: []
        )

        func diagnostics(
            source: DerivedSplitSource,
            splits: [DerivedSplitEstimate],
            lapEvaluation: LapSplitEvaluation = emptyLapEvaluation,
            segmentEvaluation: SegmentSplitEvaluation = emptySegmentEvaluation,
            fallbackReason: String?,
            validationNotes: [String]
        ) -> DerivedSplitDiagnostics {
            DerivedSplitDiagnostics(
                unit: unit,
                targetDistanceMeters: targetMeters,
                rowPrefix: rowPrefix,
                source: source,
                sourceLabel: source.label,
                totalDistanceMeters: totalDistance,
                distanceSampleCount: evidence.series[.distance]?.points.count ?? 0,
                lapEventCount: lapEventCount,
                eligibleLapEventCount: lapEvaluation.eligibleLapEventCount,
                selectedLapEventCount: source == .validatedLapEvents ? splits.count : 0,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: segmentEvaluation.eligibleSegmentEventCount,
                expectedFullKilometerCount: totalDistance.flatMap {
                    $0.isFinite && $0 > 0 ? Int($0 / 1_000) : nil
                } ?? 0,
                expectedFullUnitCount: fullUnits,
                expectedRowCount: expectedRowCount,
                completeSegmentChainCount: source == .validatedLapEvents
                    ? lapEvaluation.completeChainCount
                    : segmentEvaluation.completeChainCount,
                terminalSegmentChainCount: source == .validatedLapEvents
                    ? lapEvaluation.terminalChainCount
                    : segmentEvaluation.terminalChainCount,
                distanceValidatedSegmentChainCount: source == .validatedLapEvents
                    ? lapEvaluation.validatedChainCount
                    : segmentEvaluation.validatedChainCount,
                selectedSegmentEventCount: source == .validatedSegmentEvents ? splits.count : 0,
                terminalEvidenceOffsetSeconds: distanceAssessment.terminalEvidenceDate?.timeIntervalSince(workout.startDate),
                workoutSummaryDistanceMeters: workout.distanceMeters,
                distanceReconciliationDeltaMeters: distanceAssessment.reconciliationDeltaMeters,
                maximumDistanceSampleWindowSeconds: distanceAssessment.maximumWindowSeconds,
                uncoveredDistanceWindowSeconds: distanceAssessment.uncoveredWindowSeconds,
                pauseAdjustmentSeconds: splits.compactMap(\.pauseOverlapSeconds).reduce(0, +),
                fallbackReason: fallbackReason,
                validationNotes: validationNotes,
                splitEstimates: splits
            )
        }

        let permitsFinalOnlyProjection = unit == .miles
            && fullUnits == 0
            && remainderDistance >= 10
        guard let totalDistance,
              totalDistance.isFinite,
              fullUnits > 0 || permitsFinalOnlyProjection else {
            return diagnostics(
                source: .unavailable,
                splits: [],
                fallbackReason: distanceAssessment.rejectionReason ?? "Apple Health did not retain enough distance evidence for \(unitName) splits.",
                validationNotes: distanceAssessment.validationNotes
            )
        }
        guard let pauseTimeline = pauseAssessment.timeline else {
            return diagnostics(
                source: .unavailable,
                splits: [],
                fallbackReason: pauseAssessment.rejectionReason,
                validationNotes: distanceAssessment.validationNotes + pauseAssessment.validationNotes
            )
        }

        let terminalEvidenceDate = distanceAssessment.terminalEvidenceDate ?? workout.endDate
        let lapEvaluation: LapSplitEvaluation
        if distanceAssessment.series != nil || (evidence.series[.distance]?.points.count ?? 0) < 2 {
            lapEvaluation = evaluateLapEventSplits(
                workout: workout,
                evidence: evidence,
                totalDistance: totalDistance,
                distanceSeries: distanceAssessment.series,
                terminalEvidenceDate: terminalEvidenceDate,
                pauseTimeline: pauseTimeline,
                targetMeters: targetMeters,
                rowPrefix: rowPrefix,
                unitName: unitName
            )
        } else {
            lapEvaluation = LapSplitEvaluation(
                splits: nil,
                lapEventCount: lapEventCount,
                eligibleLapEventCount: 0,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                fallbackReason: distanceAssessment.rejectionReason,
                validationNotes: ["Conflicting detailed distance blocks boundary-event promotion even when lap events are present."]
            )
        }
        if let lapSplits = lapEvaluation.splits {
            return diagnostics(
                source: .validatedLapEvents,
                splits: lapSplits,
                lapEvaluation: lapEvaluation,
                fallbackReason: nil,
                validationNotes: distanceAssessment.validationNotes + pauseAssessment.validationNotes + lapEvaluation.validationNotes
            )
        }

        let segmentEvaluation: SegmentSplitEvaluation
        if let distanceSeries = distanceAssessment.series {
            segmentEvaluation = evaluateSegmentEventSplits(
                workout: workout,
                evidence: evidence,
                distanceSeries: distanceSeries,
                pauseTimeline: pauseTimeline,
                targetMeters: targetMeters,
                rowPrefix: rowPrefix,
                unitName: unitName
            )
        } else {
            segmentEvaluation = emptySegmentEvaluation
        }
        if let segmentSplits = segmentEvaluation.splits {
            return diagnostics(
                source: .validatedSegmentEvents,
                splits: segmentSplits,
                lapEvaluation: lapEvaluation,
                segmentEvaluation: segmentEvaluation,
                fallbackReason: nil,
                validationNotes: distanceAssessment.validationNotes + pauseAssessment.validationNotes + lapEvaluation.validationNotes + segmentEvaluation.validationNotes
            )
        }

        guard let distanceSeries = distanceAssessment.series else {
            return diagnostics(
                source: .unavailable,
                splits: [],
                lapEvaluation: lapEvaluation,
                segmentEvaluation: segmentEvaluation,
                fallbackReason: distanceAssessment.rejectionReason ?? segmentEvaluation.fallbackReason ?? lapEvaluation.fallbackReason,
                validationNotes: distanceAssessment.validationNotes + pauseAssessment.validationNotes + lapEvaluation.validationNotes + segmentEvaluation.validationNotes
            )
        }

        let estimatedSplits = distanceSeriesSplitEstimates(
            workout: workout,
            distanceSeries: distanceSeries,
            pauseTimeline: pauseTimeline,
            targetMeters: targetMeters,
            rowPrefix: rowPrefix
        )
        return diagnostics(
            source: estimatedSplits.isEmpty ? .unavailable : .distanceSampleWindows,
            splits: estimatedSplits,
            lapEvaluation: lapEvaluation,
            segmentEvaluation: segmentEvaluation,
            fallbackReason: estimatedSplits.isEmpty
                ? "The reconciled distance windows could not produce chronological one-\(unitName) crossings."
                : segmentEvaluation.fallbackReason ?? lapEvaluation.fallbackReason,
            validationNotes: distanceAssessment.validationNotes
                + pauseAssessment.validationNotes
                + lapEvaluation.validationNotes
                + segmentEvaluation.validationNotes
                + ["Distance contributions were accrued across each sample's actual start/end window on the active-time clock."]
        )
    }

    private static func evaluateSegmentEventSplits(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        distanceSeries: WorkoutMetricSeries,
        pauseTimeline: NormalSplitPauseTimeline,
        targetMeters: Double,
        rowPrefix: String,
        unitName: String
    ) -> SegmentSplitEvaluation {
        let segmentEventCount = evidence.events.filter(isSegmentEvent).count
        let totalDistance = distanceSeries.points.map(\.value).reduce(0, +)
        guard totalDistance.isFinite, totalDistance >= 10 else {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: 0,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                terminalEvidenceDate: nil,
                fallbackReason: "The detailed distance total is below the final-partial threshold.",
                validationNotes: []
            )
        }

        let fullUnits = Int(totalDistance / targetMeters)
        let remainderDistance = totalDistance - (Double(fullUnits) * targetMeters)
        let includesFinalPartial = remainderDistance >= 10
        let expectedRowCount = fullUnits + (includesFinalPartial ? 1 : 0)
        guard expectedRowCount > 0 else {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: 0,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                terminalEvidenceDate: nil,
                fallbackReason: "No \(unitName) or final-partial rows are expected from the detailed distance total.",
                validationNotes: []
            )
        }

        let terminalEvidenceDate = distanceSeries.points.reduce(workout.startDate) { latest, point in
            max(latest, distanceSampleWindow(point, previousSampleEnd: nil, workoutStart: workout.startDate).end)
        }
        let indexedSegments = evidence.events.enumerated().compactMap { index, event -> IndexedSegmentEvent? in
            guard isSegmentEvent(event),
                  event.endDate > event.startDate,
                  event.startDate >= workout.startDate.addingTimeInterval(-1),
                  event.endDate <= terminalEvidenceDate.addingTimeInterval(1) else {
                return nil
            }
            return IndexedSegmentEvent(index: index, event: event)
        }
        guard indexedSegments.count >= expectedRowCount else {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: indexedSegments.count,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                terminalEvidenceDate: terminalEvidenceDate,
                fallbackReason: "Too few eligible segment events exist for the expected \(unitName)-plus-partial row count.",
                validationNotes: []
            )
        }

        let startCandidates = indexedSegments.filter {
            abs($0.event.startDate.timeIntervalSince(workout.startDate)) <= 1
        }
        let chains = startCandidates.flatMap {
            contiguousSegmentChains(
                startingWith: $0,
                segments: indexedSegments,
                expectedCount: expectedRowCount
            )
        }

        guard !chains.isEmpty else {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: indexedSegments.count,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                terminalEvidenceDate: terminalEvidenceDate,
                fallbackReason: startCandidates.isEmpty
                    ? "No eligible segment event starts with the workout."
                    : "No contiguous segment chain has the expected \(unitName)-plus-partial row count.",
                validationNotes: []
            )
        }

        let terminalChains = chains.filter { chain in
            guard let finalEvent = chain.last else { return false }
            return abs(finalEvent.endDate.timeIntervalSince(terminalEvidenceDate)) <= 1
        }

        guard !terminalChains.isEmpty else {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: indexedSegments.count,
                completeChainCount: chains.count,
                terminalChainCount: 0,
                validatedChainCount: 0,
                terminalEvidenceDate: terminalEvidenceDate,
                fallbackReason: "No complete segment chain ends with the final distance evidence.",
                validationNotes: []
            )
        }

        let scoredChains = terminalChains.compactMap { chain -> (events: [WorkoutEvidenceEvent], score: Double)? in
            var score = 0.0
            for event in chain.prefix(fullUnits) {
                guard let measuredDistance = intervalDistance(
                    start: event.startDate,
                    end: event.endDate,
                    series: distanceSeries,
                    workoutStart: workout.startDate
                ),
                    measuredDistance >= targetMeters * 0.75,
                    measuredDistance <= targetMeters * 1.25 else {
                    return nil
                }
                score += abs(measuredDistance - targetMeters) / targetMeters
            }

            if includesFinalPartial,
               let final = chain.last,
               pauseTimeline.activeDuration(start: final.startDate, end: final.endDate) < 5 {
                return nil
            }

            return (chain, score)
        }

        let rankedChains = scoredChains.sorted { $0.score < $1.score }
        guard let selected = rankedChains.first?.events else {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: indexedSegments.count,
                completeChainCount: chains.count,
                terminalChainCount: terminalChains.count,
                validatedChainCount: 0,
                terminalEvidenceDate: terminalEvidenceDate,
                fallbackReason: "Complete segment chains exist, but none distance-validate every full row as approximately one \(unitName).",
                validationNotes: ["Full \(unitName) rows must validate within 25 percent of \(String(format: "%.3f", targetMeters)) meters."]
            )
        }

        if rankedChains.count > 1,
           boundaryChainsDisagree(
                rankedChains[0].events,
                rankedChains[1].events,
                pauseTimeline: pauseTimeline
           ) {
            return SegmentSplitEvaluation(
                splits: nil,
                segmentEventCount: segmentEventCount,
                eligibleSegmentEventCount: indexedSegments.count,
                completeChainCount: chains.count,
                terminalChainCount: terminalChains.count,
                validatedChainCount: scoredChains.count,
                terminalEvidenceDate: terminalEvidenceDate,
                fallbackReason: "Multiple validated segment chains produce materially different displayed split times.",
                validationNotes: ["Ambiguous segment chains fall back instead of selecting the smallest numerical score."]
            )
        }

        let splits = selected.enumerated().map { index, event in
            let isFinal = includesFinalPartial && index == selected.count - 1
            let distance = isFinal ? remainderDistance : targetMeters
            let elapsedDuration = event.endDate.timeIntervalSince(event.startDate)
            let pauseOverlap = pauseTimeline.overlapSeconds(start: event.startDate, end: event.endDate)
            let duration = max(0, elapsedDuration - pauseOverlap)
            return DerivedSplitEstimate(
                label: isFinal ? "Final" : "\(rowPrefix) \(index + 1)",
                distanceMeters: distance,
                durationSecondsEstimate: duration,
                paceSecondsPerKmEstimate: duration / (distance / 1_000),
                confidence: .strong,
                elapsedStartOffsetSeconds: event.startDate.timeIntervalSince(workout.startDate),
                elapsedEndOffsetSeconds: event.endDate.timeIntervalSince(workout.startDate),
                pauseOverlapSeconds: pauseOverlap > 0 ? pauseOverlap : nil
            )
        }
        return SegmentSplitEvaluation(
            splits: splits,
            segmentEventCount: segmentEventCount,
            eligibleSegmentEventCount: indexedSegments.count,
            completeChainCount: chains.count,
            terminalChainCount: terminalChains.count,
            validatedChainCount: scoredChains.count,
            terminalEvidenceDate: terminalEvidenceDate,
            fallbackReason: nil,
            validationNotes: [
                "Full \(unitName) rows validated within 25 percent of \(String(format: "%.3f", targetMeters)) meters against the reconciled distance timeline.",
                "The selected segment chain was unique at displayed one-second precision.",
                pauseTimeline.totalPausedSeconds > 0
                    ? "Displayed split time subtracts the reliable pause timeline that reconciles to HealthKit workout duration."
                    : "No pause adjustment was required for displayed split time."
            ] + (pauseTimeline.sourceLabel.map { ["Pause basis: \($0)."] } ?? [])
        )
    }

    private static func contiguousSegmentChains(
        startingWith first: IndexedSegmentEvent,
        segments: [IndexedSegmentEvent],
        expectedCount: Int
    ) -> [[WorkoutEvidenceEvent]] {
        func extend(_ chain: [IndexedSegmentEvent]) -> [[IndexedSegmentEvent]] {
            guard chain.count < expectedCount, let last = chain.last else { return [chain] }
            let used = Set(chain.map(\.index))
            let next = segments.filter {
                !used.contains($0.index)
                    && abs($0.event.startDate.timeIntervalSince(last.event.endDate)) <= 0.5
                    && $0.event.endDate > last.event.endDate
            }
            guard !next.isEmpty else { return [chain] }
            return next.flatMap { extend(chain + [$0]) }
        }

        return extend([first])
            .filter { $0.count == expectedCount }
            .map { $0.map(\.event) }
    }

    private static func boundaryChainsDisagree(
        _ lhs: [WorkoutEvidenceEvent],
        _ rhs: [WorkoutEvidenceEvent],
        pauseTimeline: NormalSplitPauseTimeline
    ) -> Bool {
        guard lhs.count == rhs.count else { return true }
        return zip(lhs, rhs).contains { left, right in
            let leftDuration = pauseTimeline.activeDuration(start: left.startDate, end: left.endDate)
            let rightDuration = pauseTimeline.activeDuration(start: right.startDate, end: right.endDate)
            return abs(leftDuration - rightDuration) >= 1
        }
    }

    private static func evaluateLapEventSplits(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence,
        totalDistance: Double,
        distanceSeries: WorkoutMetricSeries?,
        terminalEvidenceDate: Date,
        pauseTimeline: NormalSplitPauseTimeline,
        targetMeters: Double,
        rowPrefix: String,
        unitName: String
    ) -> LapSplitEvaluation {
        let rawLapCount = evidence.events.filter(isLapEvent).count
        let normalizedLaps = normalizedLapEvents(
            evidence.events,
            workout: workout,
            terminalEvidenceDate: terminalEvidenceDate
        )
        guard !normalizedLaps.isEmpty else {
            return LapSplitEvaluation(
                splits: nil,
                lapEventCount: rawLapCount,
                eligibleLapEventCount: 0,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                fallbackReason: rawLapCount == 0
                    ? "No lap events are available."
                    : "Mixed or malformed lap event timing could not be normalized safely.",
                validationNotes: []
            )
        }

        if let distanceSeries {
            let syntheticEvents = normalizedLaps.map { lap in
                WorkoutEvidenceEvent(
                    startDate: lap.startDate,
                    endDate: lap.endDate,
                    type: "segment",
                    kind: .segment,
                    label: lap.label,
                    metadataKeys: lap.metadataKeys
                )
            }
            let syntheticEvidence = WorkoutEvidence(
                workoutID: evidence.workoutID,
                loadedAt: evidence.loadedAt,
                series: [.distance: distanceSeries],
                events: syntheticEvents
            )
            let evaluation = evaluateSegmentEventSplits(
                workout: workout,
                evidence: syntheticEvidence,
                distanceSeries: distanceSeries,
                pauseTimeline: pauseTimeline,
                targetMeters: targetMeters,
                rowPrefix: rowPrefix,
                unitName: unitName
            )
            return LapSplitEvaluation(
                splits: evaluation.splits,
                lapEventCount: rawLapCount,
                eligibleLapEventCount: evaluation.eligibleSegmentEventCount,
                completeChainCount: evaluation.completeChainCount,
                terminalChainCount: evaluation.terminalChainCount,
                validatedChainCount: evaluation.validatedChainCount,
                fallbackReason: evaluation.fallbackReason,
                validationNotes: evaluation.validationNotes.map {
                    $0.replacingOccurrences(of: "segment", with: "lap")
                } + (evaluation.splits == nil ? [] : [
                    "Apple documents lap events as equal-distance workout partitions."
                ])
            )
        }

        let fullUnits = Int(totalDistance / targetMeters)
        let remainder = totalDistance - (Double(fullUnits) * targetMeters)
        let expectedCount = fullUnits + (remainder >= 10 ? 1 : 0)
        guard normalizedLaps.count == expectedCount,
              let first = normalizedLaps.first,
              let last = normalizedLaps.last,
              abs(first.startDate.timeIntervalSince(workout.startDate)) <= 1,
              abs(last.endDate.timeIntervalSince(terminalEvidenceDate)) <= 1,
              zip(normalizedLaps, normalizedLaps.dropFirst()).allSatisfy({ pair in
                  abs(pair.0.endDate.timeIntervalSince(pair.1.startDate)) <= 0.5
              }) else {
            return LapSplitEvaluation(
                splits: nil,
                lapEventCount: rawLapCount,
                eligibleLapEventCount: normalizedLaps.count,
                completeChainCount: 0,
                terminalChainCount: 0,
                validatedChainCount: 0,
                fallbackReason: "Lap events do not form the expected complete \(unitName)-plus-partial workout chain.",
                validationNotes: []
            )
        }

        let splits = normalizedLaps.enumerated().compactMap { index, lap -> DerivedSplitEstimate? in
            let isFinal = remainder >= 10 && index == normalizedLaps.count - 1
            let distance = isFinal ? remainder : targetMeters
            let pauseOverlap = pauseTimeline.overlapSeconds(start: lap.startDate, end: lap.endDate)
            let duration = pauseTimeline.activeDuration(start: lap.startDate, end: lap.endDate)
            guard duration >= (isFinal ? 5 : 1) else { return nil }
            return DerivedSplitEstimate(
                label: isFinal ? "Final" : "\(rowPrefix) \(index + 1)",
                distanceMeters: distance,
                durationSecondsEstimate: duration,
                paceSecondsPerKmEstimate: duration / (distance / 1_000),
                confidence: .strong,
                elapsedStartOffsetSeconds: lap.startDate.timeIntervalSince(workout.startDate),
                elapsedEndOffsetSeconds: lap.endDate.timeIntervalSince(workout.startDate),
                pauseOverlapSeconds: pauseOverlap > 0 ? pauseOverlap : nil
            )
        }
        guard splits.count == expectedCount else {
            return LapSplitEvaluation(
                splits: nil,
                lapEventCount: rawLapCount,
                eligibleLapEventCount: normalizedLaps.count,
                completeChainCount: 1,
                terminalChainCount: 1,
                validatedChainCount: 0,
                fallbackReason: "The normalized lap chain contains a non-positive active-time row.",
                validationNotes: []
            )
        }
        return LapSplitEvaluation(
            splits: splits,
            lapEventCount: rawLapCount,
            eligibleLapEventCount: normalizedLaps.count,
            completeChainCount: 1,
            terminalChainCount: 1,
            validatedChainCount: 1,
            fallbackReason: nil,
            validationNotes: [
                "Apple Health lap semantics and full-workout topology supplied the recorded equal-distance boundaries.",
                "Legacy zero-duration lap events are expanded from the previous boundary as documented by Apple."
            ]
        )
    }

    private static func normalizedLapEvents(
        _ events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout,
        terminalEvidenceDate: Date
    ) -> [WorkoutEvidenceEvent] {
        let laps = events.filter(isLapEvent).sorted { $0.startDate < $1.startDate }
        guard !laps.isEmpty else { return [] }
        let zeroDurationLaps = laps.filter { $0.endDate <= $0.startDate }
        guard !zeroDurationLaps.isEmpty else { return laps }
        guard zeroDurationLaps.count == laps.count else { return [] }

        var previousBoundary = workout.startDate
        return zeroDurationLaps.compactMap { lap in
            let boundary = lap.startDate
            guard boundary > previousBoundary,
                  boundary <= terminalEvidenceDate.addingTimeInterval(1) else {
                return nil
            }
            let normalized = WorkoutEvidenceEvent(
                startDate: previousBoundary,
                endDate: boundary,
                type: lap.type,
                kind: .lap,
                label: lap.label,
                metadataKeys: lap.metadataKeys
            )
            previousBoundary = boundary
            return normalized
        }
    }

    private static func assessDistanceSeries(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence
    ) -> DistanceSeriesAssessment {
        guard let rawSeries = evidence.series[.distance] else {
            return DistanceSeriesAssessment(
                series: nil,
                totalDistanceMeters: workout.distanceMeters,
                reconciliationDeltaMeters: nil,
                maximumWindowSeconds: nil,
                uncoveredWindowSeconds: nil,
                terminalEvidenceDate: nil,
                rejectionReason: "Apple Health did not retain detailed distance samples for this workout.",
                validationNotes: []
            )
        }

        let sorted = rawSeries.points.sorted {
            if $0.startDate == $1.startDate { return $0.endDate < $1.endDate }
            return $0.startDate < $1.startDate
        }
        var points: [WorkoutEvidencePoint] = []
        for point in sorted {
            guard point.value.isFinite,
                  point.value >= 0,
                  point.endDate >= point.startDate,
                  point.startDate >= workout.startDate.addingTimeInterval(-5),
                  point.endDate <= workout.endDate.addingTimeInterval(5) else {
                return DistanceSeriesAssessment(
                    series: nil,
                    totalDistanceMeters: sorted.filter { $0.value.isFinite && $0.value >= 0 }.map(\.value).reduce(0, +),
                    reconciliationDeltaMeters: nil,
                    maximumWindowSeconds: nil,
                    uncoveredWindowSeconds: nil,
                    terminalEvidenceDate: nil,
                    rejectionReason: "Detailed distance contains an invalid or out-of-workout sample window.",
                    validationNotes: []
                )
            }
            if let previous = points.last,
               previous.startDate == point.startDate,
               previous.endDate == point.endDate,
               abs(previous.value - point.value) < 0.000_001 {
                continue
            }
            if let previous = points.last,
               previous.endDate > previous.startDate,
               point.endDate > point.startDate,
               point.startDate < previous.endDate.addingTimeInterval(-0.5) {
                return DistanceSeriesAssessment(
                    series: nil,
                    totalDistanceMeters: sorted.map(\.value).reduce(0, +),
                    reconciliationDeltaMeters: nil,
                    maximumWindowSeconds: nil,
                    uncoveredWindowSeconds: nil,
                    terminalEvidenceDate: nil,
                    rejectionReason: "Detailed distance sample windows overlap and could double-count movement.",
                    validationNotes: []
                )
            }
            points.append(point)
        }

        let totalDistance = points.map(\.value).reduce(0, +)
        let delta = workout.distanceMeters.map { abs($0 - totalDistance) }
        let reconciliationTolerance = max(50, (workout.distanceMeters ?? totalDistance) * 0.03)
        guard delta == nil || delta! <= reconciliationTolerance else {
            return DistanceSeriesAssessment(
                series: nil,
                totalDistanceMeters: totalDistance,
                reconciliationDeltaMeters: delta,
                maximumWindowSeconds: nil,
                uncoveredWindowSeconds: nil,
                terminalEvidenceDate: nil,
                rejectionReason: "Detailed distance does not reconcile to the HealthKit workout summary within three percent.",
                validationNotes: ["Detailed distance differs from the workout summary by \(String(format: "%.1f", delta ?? 0)) meters."]
            )
        }

        var previousEnd: Date?
        var maximumWindow = 0.0
        var uncovered = 0.0
        var terminalDate: Date?
        for point in points {
            let window = distanceSampleWindow(point, previousSampleEnd: previousEnd, workoutStart: workout.startDate)
            if let previousEnd, window.start > previousEnd {
                uncovered += window.start.timeIntervalSince(previousEnd)
            } else if previousEnd == nil, window.start > workout.startDate {
                uncovered += window.start.timeIntervalSince(workout.startDate)
            }
            maximumWindow = max(maximumWindow, window.end.timeIntervalSince(window.start))
            previousEnd = window.end
            terminalDate = max(terminalDate ?? window.end, window.end)
        }
        if let terminalDate, workout.endDate > terminalDate {
            uncovered += workout.endDate.timeIntervalSince(terminalDate)
        }

        let canonical = WorkoutMetricSeries(metric: .distance, unit: rawSeries.unit, points: points)
        var notes = ["Detailed distance reconciled to the HealthKit workout summary within \(String(format: "%.1f", reconciliationTolerance)) meters."]
        if points.contains(where: { $0.sampleSource == .sourceDateFallback }) {
            notes.append("One or more distance samples came from the weaker source/date fallback query.")
        }
        if points.count < 2 {
            return DistanceSeriesAssessment(
                series: nil,
                totalDistanceMeters: totalDistance,
                reconciliationDeltaMeters: delta,
                maximumWindowSeconds: maximumWindow,
                uncoveredWindowSeconds: uncovered,
                terminalEvidenceDate: terminalDate,
                rejectionReason: "Fewer than two usable Apple Health distance samples are available.",
                validationNotes: notes
            )
        }
        return DistanceSeriesAssessment(
            series: canonical,
            totalDistanceMeters: totalDistance,
            reconciliationDeltaMeters: delta,
            maximumWindowSeconds: maximumWindow,
            uncoveredWindowSeconds: uncovered,
            terminalEvidenceDate: terminalDate,
            rejectionReason: nil,
            validationNotes: notes
        )
    }

    private static func normalSplitPauseAssessment(
        workout: CanonicalWorkout,
        events: [WorkoutEvidenceEvent]
    ) -> NormalSplitPauseAssessment {
        let expectedPaused = max(0, workout.elapsedSeconds - workout.durationSeconds)
        guard expectedPaused > 1 else {
            return NormalSplitPauseAssessment(
                timeline: NormalSplitPauseTimeline(intervals: [], expectedPausedSeconds: expectedPaused, sourceLabel: nil),
                rejectionReason: nil,
                validationNotes: ["Workout elapsed time and active duration do not require a pause adjustment."]
            )
        }

        let candidates: [(String, [DateInterval]?)] = [
            ("explicit pause/resume events", pairedPauseIntervals(events, workout: workout, includeExplicit: true, includeMotion: false)),
            ("motion pause/resume events", pairedPauseIntervals(events, workout: workout, includeExplicit: false, includeMotion: true)),
            ("combined pause/resume events", pairedPauseIntervals(events, workout: workout, includeExplicit: true, includeMotion: true))
        ]
        let tolerance = max(2, expectedPaused * 0.02)
        let ranked = candidates.compactMap { label, intervals -> (String, [DateInterval], Double)? in
            guard let intervals, !intervals.isEmpty else { return nil }
            let total = intervals.map(\.duration).reduce(0, +)
            return (label, intervals, abs(total - expectedPaused))
        }.sorted { $0.2 < $1.2 }

        guard let selected = ranked.first, selected.2 <= tolerance else {
            return NormalSplitPauseAssessment(
                timeline: nil,
                rejectionReason: "Workout duration indicates paused time, but HealthKit pause events do not reconcile well enough to assign it safely to normal split rows.",
                validationNotes: ["Expected paused time: \(String(format: "%.1f", expectedPaused)) seconds."]
            )
        }
        return NormalSplitPauseAssessment(
            timeline: NormalSplitPauseTimeline(
                intervals: selected.1,
                expectedPausedSeconds: expectedPaused,
                sourceLabel: selected.0
            ),
            rejectionReason: nil,
            validationNotes: [
                "Pause events reconcile to workout elapsed-minus-active duration within \(String(format: "%.1f", tolerance)) seconds."
            ]
        )
    }

    private static func pairedPauseIntervals(
        _ events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout,
        includeExplicit: Bool,
        includeMotion: Bool
    ) -> [DateInterval]? {
        var pendingPause: Date?
        var intervals: [DateInterval] = []
        let selected = events.sorted { $0.startDate < $1.startDate }.compactMap { event -> (Date, Bool)? in
            let normalized = event.type.lowercased()
            let isExplicitPause = event.kind == .pause || normalized == "pause" || normalized.contains("rawvalue: 1")
            let isExplicitResume = event.kind == .resume || normalized == "resume" || normalized.contains("rawvalue: 2")
            let isMotionPause = event.kind == .motionPaused || normalized == "motionpaused" || normalized.contains("rawvalue: 5")
            let isMotionResume = event.kind == .motionResumed || normalized == "motionresumed" || normalized.contains("rawvalue: 6")
            if includeExplicit, isExplicitPause { return (event.startDate, true) }
            if includeExplicit, isExplicitResume { return (event.startDate, false) }
            if includeMotion, isMotionPause { return (event.startDate, true) }
            if includeMotion, isMotionResume { return (event.startDate, false) }
            return nil
        }
        for (date, isPause) in selected {
            if isPause {
                if pendingPause != nil { return nil }
                pendingPause = max(workout.startDate, date)
            } else {
                guard let start = pendingPause else { return nil }
                let end = min(workout.endDate, date)
                guard end > start else { return nil }
                intervals.append(DateInterval(start: start, end: end))
                pendingPause = nil
            }
        }
        if let pendingPause,
           pendingPause < workout.endDate.addingTimeInterval(-1) {
            return nil
        }
        return intervals
    }

    private static func isLapEvent(_ event: WorkoutEvidenceEvent) -> Bool {
        event.kind == .lap || event.displayLabel == "Lap"
    }

    private static func isSegmentEvent(_ event: WorkoutEvidenceEvent) -> Bool {
        event.kind == .segment || event.displayLabel == "Segment"
    }

    private static func distanceSeriesSplitEstimates(
        workout: CanonicalWorkout,
        distanceSeries: WorkoutMetricSeries,
        pauseTimeline: NormalSplitPauseTimeline,
        targetMeters: Double,
        rowPrefix: String
    ) -> [DerivedSplitEstimate] {
        var cumulativeDistance = 0.0
        var nextTarget = targetMeters
        var previousCrossingDate = workout.startDate
        var estimates: [DerivedSplitEstimate] = []

        var previousSampleEnd: Date?

        for point in distanceSeries.points {
            guard point.value.isFinite, point.value >= 0 else { return [] }
            let previousDistance = cumulativeDistance
            let sampleWindow = distanceSampleWindow(
                point,
                previousSampleEnd: previousSampleEnd,
                workoutStart: workout.startDate
            )
            cumulativeDistance += point.value

            while cumulativeDistance >= nextTarget {
                let distanceDelta = cumulativeDistance - previousDistance
                guard distanceDelta > 0 else { return [] }
                let crossingFraction = min(max((nextTarget - previousDistance) / distanceDelta, 0), 1)
                let activeWindowDuration = pauseTimeline.activeDuration(
                    start: sampleWindow.start,
                    end: sampleWindow.end
                )
                let crossingDate = pauseTimeline.dateAdvancingActiveTime(
                    from: sampleWindow.start,
                    seconds: activeWindowDuration * crossingFraction,
                    noLaterThan: sampleWindow.end
                )
                let pauseOverlap = pauseTimeline.overlapSeconds(start: previousCrossingDate, end: crossingDate)
                let splitDuration = pauseTimeline.activeDuration(start: previousCrossingDate, end: crossingDate)
                if splitDuration > 0 {
                    let splitNumber = estimates.count + 1
                    estimates.append(
                        DerivedSplitEstimate(
                            label: "\(rowPrefix) \(splitNumber)",
                            distanceMeters: targetMeters,
                            durationSecondsEstimate: splitDuration,
                            paceSecondsPerKmEstimate: splitDuration / (targetMeters / 1_000),
                            confidence: .moderate,
                            elapsedStartOffsetSeconds: previousCrossingDate.timeIntervalSince(workout.startDate),
                            elapsedEndOffsetSeconds: crossingDate.timeIntervalSince(workout.startDate),
                            pauseOverlapSeconds: pauseOverlap > 0 ? pauseOverlap : nil
                        )
                    )
                    previousCrossingDate = crossingDate
                }
                nextTarget += targetMeters
            }
            previousSampleEnd = sampleWindow.end
        }

        let completedUnits = floor(cumulativeDistance / targetMeters) * targetMeters
        let remainderDistance = cumulativeDistance - completedUnits
        let finalEvidenceDate = min(previousSampleEnd ?? workout.endDate, workout.endDate)
        let remainderPauseOverlap = pauseTimeline.overlapSeconds(start: previousCrossingDate, end: finalEvidenceDate)
        let remainderDuration = pauseTimeline.activeDuration(start: previousCrossingDate, end: finalEvidenceDate)
        if remainderDistance >= 10, remainderDuration >= 5 {
            estimates.append(
                DerivedSplitEstimate(
                    label: "Final",
                    distanceMeters: remainderDistance,
                    durationSecondsEstimate: remainderDuration,
                    paceSecondsPerKmEstimate: remainderDuration / (remainderDistance / 1_000),
                    confidence: .moderate,
                    elapsedStartOffsetSeconds: previousCrossingDate.timeIntervalSince(workout.startDate),
                    elapsedEndOffsetSeconds: finalEvidenceDate.timeIntervalSince(workout.startDate),
                    pauseOverlapSeconds: remainderPauseOverlap > 0 ? remainderPauseOverlap : nil
                )
            )
        }

        return estimates
    }

    private static func intervalDistance(
        start: Date,
        end: Date,
        series: WorkoutMetricSeries,
        workoutStart: Date
    ) -> Double? {
        guard let startDistance = cumulativeDistance(at: start, series: series, workoutStart: workoutStart),
              let endDistance = cumulativeDistance(at: end, series: series, workoutStart: workoutStart),
              endDistance >= startDistance else {
            return nil
        }
        return endDistance - startDistance
    }

    private static func cumulativeDistance(
        at date: Date,
        series: WorkoutMetricSeries,
        workoutStart: Date
    ) -> Double? {
        guard date >= workoutStart else { return nil }
        var cumulative = 0.0
        var previousSampleEnd: Date?

        for point in series.points {
            guard point.value.isFinite, point.value >= 0 else { return nil }
            let sampleWindow = distanceSampleWindow(
                point,
                previousSampleEnd: previousSampleEnd,
                workoutStart: workoutStart
            )
            if date <= sampleWindow.start {
                return cumulative
            }
            if date < sampleWindow.end {
                let duration = sampleWindow.end.timeIntervalSince(sampleWindow.start)
                guard duration > 0 else { return cumulative + point.value }
                let fraction = min(max(date.timeIntervalSince(sampleWindow.start) / duration, 0), 1)
                return cumulative + (point.value * fraction)
            }
            cumulative += point.value
            previousSampleEnd = sampleWindow.end
        }

        return cumulative
    }

    private static func distanceSampleWindow(
        _ point: WorkoutEvidencePoint,
        previousSampleEnd: Date?,
        workoutStart: Date
    ) -> (start: Date, end: Date) {
        if point.endDate > point.startDate {
            return (point.startDate, point.endDate)
        }
        return (previousSampleEnd ?? workoutStart, point.date)
    }

    private static func executionSegments(
        heartRateSeries: WorkoutMetricSeries?,
        speedSeries: WorkoutMetricSeries?
    ) -> [DerivedExecutionSegment] {
        let heartRateHalves = heartRateSeries.flatMap {
            halfAverages(from: $0.points.map(\.value), minimumCount: 4)
        }
        let speedHalves = speedSeries.flatMap {
            halfAverages(from: $0.points.map(\.value), minimumCount: 4)
        }

        guard heartRateHalves != nil || speedHalves != nil else { return [] }

        return [
            DerivedExecutionSegment(
                label: "Opening",
                heartRateAverage: heartRateHalves?.first,
                heartRateConfidence: heartRateHalves == nil ? .unavailable : .moderate,
                paceSecondsPerKmEstimate: speedHalves.flatMap { paceSecondsPerKm(fromMetersPerSecond: $0.first) },
                paceConfidence: speedHalves == nil ? .unavailable : .moderate
            ),
            DerivedExecutionSegment(
                label: "Finish",
                heartRateAverage: heartRateHalves?.second,
                heartRateConfidence: heartRateHalves == nil ? .unavailable : .moderate,
                paceSecondsPerKmEstimate: speedHalves.flatMap { paceSecondsPerKm(fromMetersPerSecond: $0.second) },
                paceConfidence: speedHalves == nil ? .unavailable : .moderate
            )
        ]
    }

    public static func intervalCandidates(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> [DerivedWorkoutInterval] {
        let events = evidence.events
            .filter { event in
                event.endDate > event.startDate
                    && event.startDate >= workout.startDate
                    && event.endDate <= workout.endDate.addingTimeInterval(1)
            }
            .prefix(20)
        guard !events.isEmpty else { return [] }

        return events.enumerated().map { offset, event in
            let previous = offset > 0 ? events[events.index(events.startIndex, offsetBy: offset - 1)] : nil
            let distance = intervalDistance(start: event.startDate, end: event.endDate, workout: workout, evidence: evidence)
            let duration = event.endDate.timeIntervalSince(event.startDate)
            let pace = distance.flatMap { distance -> Double? in
                guard distance > 0 else { return nil }
                return duration / (distance / 1_000)
            }
            let heartRate = averageHeartRate(start: event.startDate, end: event.endDate, evidence: evidence)
            let label = intervalLabel(for: event)
            let markerKind = markerKind(event: event, previous: previous, label: label, distanceMeters: distance)
            var caveats: [String] = []
            if label == .unknown {
                caveats.append("HealthKit did not expose an Apple Fitness interval label for this event.")
            }
            switch markerKind {
            case .resolvedActivityBoundaryRow:
                break
            case .splitMarker:
                caveats.append("This event window matches a split-like distance marker, not an Apple Fitness interval row.")
            case .overlappingSegmentMarker:
                caveats.append("This event overlaps another segment window, so it should stay raw/debug-only.")
            case .rawSegmentMarker:
                caveats.append("This event is a raw HealthKit marker until interval parity is proven.")
            case .appleFitnessIntervalCandidate:
                break
            }
            caveats.append("Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted.")
            if evidence.workoutPlanAudit?.plannedSteps.isEmpty == false {
                caveats.append("WorkoutKit planned rows are available, so this raw marker must not be used as custom-workout row analytics.")
            }
            if distance == nil {
                caveats.append("Distance series is unavailable for this event window.")
            }
            if heartRate == nil {
                caveats.append("Heart-rate samples are unavailable for this event window.")
            }

            let confidence: ConfidenceLevel
            if label != .unknown && distance != nil && heartRate != nil {
                confidence = .strong
            } else if label != .unknown && distance != nil {
                confidence = .moderate
            } else if distance != nil {
                confidence = .limited
            } else {
                confidence = .unavailable
            }

            return DerivedWorkoutInterval(
                index: offset + 1,
                label: label,
                startDate: event.startDate,
                endDate: event.endDate,
                startOffsetSeconds: event.startDate.timeIntervalSince(workout.startDate),
                endOffsetSeconds: event.endDate.timeIntervalSince(workout.startDate),
                durationSeconds: duration,
                distanceMeters: distance,
                paceSecondsPerKm: pace,
                averageHeartRateBpm: heartRate,
                source: label == .unknown ? .healthKitSegmentPattern : .healthKitLabeledEvent,
                markerKind: markerKind,
                confidence: confidence,
                caveats: orderedUnique(caveats)
            )
        }
    }

    public static func resolvedIntervalRows(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> [DerivedWorkoutInterval] {
        guard let resolved = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) else {
            return []
        }

        return resolved.intervals.map { interval in
            let duration = interval.displayDurationSeconds
            let distance = interval.actualDistanceMeters
            let pace = distance.flatMap { meters -> Double? in
                guard meters > 0 else { return nil }
                return duration / (meters / 1_000)
            }
            var caveats = [
                "Resolved from WorkoutKit planned rows and HealthKit activity boundaries.",
                "Segment markers were not used as interval analytics rows."
            ]
            if (interval.pauseOverlapSeconds ?? 0) > 0 {
                caveats.append("Duration and pace use the row display basis: \(interval.durationDisplayRule == .activeTimer ? "active timer" : "elapsed row window").")
            }

            return DerivedWorkoutInterval(
                index: interval.index,
                label: interval.stepType,
                startDate: interval.actualStartDate,
                endDate: interval.actualEndDate,
                startOffsetSeconds: interval.actualStartDate.timeIntervalSince(workout.startDate),
                endOffsetSeconds: interval.actualEndDate.timeIntervalSince(workout.startDate),
                durationSeconds: duration,
                distanceMeters: distance,
                paceSecondsPerKm: pace,
                averageHeartRateBpm: interval.averageHeartRateBpm,
                source: .resolvedCustomWorkoutRow,
                markerKind: .resolvedActivityBoundaryRow,
                confidence: interval.confidence.analyticsConfidence,
                caveats: orderedUnique(caveats)
            )
        }
    }

    private static func markerKind(
        event: WorkoutEvidenceEvent,
        previous: WorkoutEvidenceEvent?,
        label: DerivedIntervalLabel,
        distanceMeters: Double?
    ) -> DerivedIntervalMarkerKind {
        if label != .unknown {
            return .appleFitnessIntervalCandidate
        }
        if let previous, event.startDate < previous.endDate {
            return .overlappingSegmentMarker
        }
        if let distanceMeters, distanceMeters >= 950, distanceMeters <= 1_050 {
            return .splitMarker
        }
        return .rawSegmentMarker
    }

    private static func intervalDistance(start: Date, end: Date, workout: CanonicalWorkout, evidence: WorkoutEvidence) -> Double? {
        guard let distanceSeries = evidence.series[.distance], !distanceSeries.points.isEmpty,
              let startDistance = cumulativeDistance(at: start, workoutStart: workout.startDate, series: distanceSeries),
              let endDistance = cumulativeDistance(at: end, workoutStart: workout.startDate, series: distanceSeries),
              endDistance >= startDistance else {
            return nil
        }
        let distance = endDistance - startDistance
        return distance > 0 ? distance : nil
    }

    private static func cumulativeDistance(at date: Date, workoutStart: Date, series: WorkoutMetricSeries) -> Double? {
        cumulativeDistance(at: date, series: series, workoutStart: workoutStart)
    }

    private static func averageHeartRate(start: Date, end: Date, evidence: WorkoutEvidence) -> Double? {
        guard let points = evidence.series[.heartRate]?.points.filter({ $0.date >= start && $0.date <= end }),
              !points.isEmpty else {
            return nil
        }
        return points.map(\.value).reduce(0, +) / Double(points.count)
    }

    private static func intervalLabel(for event: WorkoutEvidenceEvent) -> DerivedIntervalLabel {
        let label = (event.label ?? event.displayLabel).lowercased()
        if label.contains("warm") { return .warmup }
        if label.contains("recover") { return .recovery }
        if label.contains("cool") { return .cooldown }
        if label.contains("open") { return .open }
        if label.contains("work") { return .work }
        return .unknown
    }

    private static func halfAverages(from values: [Double], minimumCount: Int) -> (first: Double, second: Double)? {
        guard values.count >= minimumCount else { return nil }
        let midpoint = values.count / 2
        let firstHalf = Array(values.prefix(midpoint))
        let secondHalf = Array(values.suffix(values.count - midpoint))
        guard !firstHalf.isEmpty, !secondHalf.isEmpty else { return nil }
        return (
            firstHalf.reduce(0, +) / Double(firstHalf.count),
            secondHalf.reduce(0, +) / Double(secondHalf.count)
        )
    }

    private static func paceSecondsPerKm(fromMetersPerSecond speed: Double) -> Double? {
        guard speed > 0 else { return nil }
        return 1_000 / speed
    }

    private static func durationToCover(
        distanceMeters target: Double,
        from series: WorkoutMetricSeries,
        workoutStart: Date
    ) -> Double? {
        guard series.points.count > 1 else { return nil }
        var total = 0.0
        var previousSampleEnd: Date?
        for point in series.points {
            guard point.value.isFinite, point.value >= 0 else { return nil }
            let previousTotal = total
            total += point.value
            if total >= target {
                let sampleWindow = distanceSampleWindow(
                    point,
                    previousSampleEnd: previousSampleEnd,
                    workoutStart: workoutStart
                )
                let crossingDate = interpolatedDate(
                    targetDistance: target,
                    previousDistance: previousTotal,
                    currentDistance: total,
                    previousDate: sampleWindow.start,
                    currentDate: sampleWindow.end
                )
                let duration = crossingDate.timeIntervalSince(workoutStart)
                return duration > 0 ? duration : nil
            }
            previousSampleEnd = distanceSampleWindow(
                point,
                previousSampleEnd: previousSampleEnd,
                workoutStart: workoutStart
            ).end
        }
        return nil
    }

    private static func interpolatedDate(
        targetDistance: Double,
        previousDistance: Double,
        currentDistance: Double,
        previousDate: Date,
        currentDate: Date
    ) -> Date {
        let distanceDelta = currentDistance - previousDistance
        guard distanceDelta > 0 else { return currentDate }
        let ratio = min(max((targetDistance - previousDistance) / distanceDelta, 0), 1)
        let timeDelta = currentDate.timeIntervalSince(previousDate)
        guard timeDelta > 0 else { return currentDate }
        return previousDate.addingTimeInterval(timeDelta * ratio)
    }

    private static func minConfidence(_ lhs: ConfidenceLevel, _ rhs: ConfidenceLevel) -> ConfidenceLevel {
        let order: [ConfidenceLevel: Int] = [.unavailable: 0, .blocked: 0, .weak: 1, .limited: 2, .moderate: 3, .strong: 4]
        return (order[lhs, default: 0] <= order[rhs, default: 0]) ? lhs : rhs
    }

    private static func orderedUnique(_ values: [String]) -> [String] {
        var seen: Set<String> = []
        return values.filter { seen.insert($0).inserted }
    }
}

private extension IntervalReconstructionConfidence {
    var analyticsConfidence: ConfidenceLevel {
        switch self {
        case .high:
            .strong
        case .medium:
            .moderate
        case .low:
            .limited
        case .unavailable:
            .unavailable
        }
    }
}
