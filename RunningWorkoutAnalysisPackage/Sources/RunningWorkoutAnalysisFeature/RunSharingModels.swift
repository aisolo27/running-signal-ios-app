import Foundation

enum RunShareTemplate: String, CaseIterable, Identifiable, Sendable {
    case summary
    case splits
    case workoutReps

    var id: String { rawValue }

    var title: String {
        switch self {
        case .summary: "Summary"
        case .splits: "Splits"
        case .workoutReps: "Workout Reps"
        }
    }

    var systemImage: String {
        switch self {
        case .summary: "figure.run"
        case .splits: "chart.bar.fill"
        case .workoutReps: "target"
        }
    }
}

enum RunShareCanvas: String, CaseIterable, Identifiable, Sendable {
    case story
    case post

    var id: String { rawValue }

    var title: String {
        switch self {
        case .story: "Story"
        case .post: "Post"
        }
    }

    var pointSize: CGSize {
        switch self {
        case .story: CGSize(width: 360, height: 640)
        case .post: CGSize(width: 360, height: 450)
        }
    }

    var pixelSize: CGSize {
        CGSize(width: pointSize.width * 3, height: pointSize.height * 3)
    }

    func rowCapacity(for template: RunShareTemplate) -> Int {
        switch (self, template) {
        case (.story, .splits): 11
        case (.post, .splits): 7
        case (.story, .workoutReps): 9
        case (.post, .workoutReps): 6
        case (_, .summary): 1
        }
    }
}

enum RunShareAppearance: String, CaseIterable, Identifiable, Sendable {
    case darkCard
    case transparentOverlay

    var id: String { rawValue }

    var title: String {
        switch self {
        case .darkCard: "Dark Card"
        case .transparentOverlay: "Overlay"
        }
    }
}

enum RunShareRouteStyle: String, CaseIterable, Identifiable, Sendable {
    case routeShape
    case map
    case none

    var id: String { rawValue }

    var title: String {
        switch self {
        case .routeShape: "Route Shape"
        case .map: "Map"
        case .none: "No Route"
        }
    }
}

enum RunShareAccent: String, Equatable, Sendable {
    case green
    case orange
    case cyan
    case purple
    case pink
    case gray
}

struct RunShareRoutePoint: Equatable, Sendable {
    var x: Double
    var y: Double
}

struct RunShareSplitRow: Identifiable, Equatable, Sendable {
    var id: Int
    var label: String
    var distance: String?
    var pace: String
    var heartRate: String?
    var normalizedPace: Double
    var normalizedAveragePace: Double
}

enum RunShareWorkStatus: String, Equatable, Sendable {
    case onTarget
    case fast
    case slow
    case shortened
    case exactTarget
    case noTarget

    var title: String {
        switch self {
        case .onTarget: "On Target"
        case .fast: "Fast"
        case .slow: "Slow"
        case .shortened: "Shortened"
        case .exactTarget: "Exact Target"
        case .noTarget: "Completed"
        }
    }

    var symbol: String {
        switch self {
        case .onTarget: "checkmark.circle.fill"
        case .fast: "arrow.up.circle.fill"
        case .slow: "arrow.down.circle.fill"
        case .shortened: "exclamationmark.circle.fill"
        case .exactTarget: "arrow.left.and.right.circle.fill"
        case .noTarget: "checkmark.circle"
        }
    }
}

struct RunShareWorkRow: Identifiable, Equatable, Sendable {
    var id: Int
    var label: String
    var goal: String
    var pace: String
    var heartRate: String?
    var status: RunShareWorkStatus
    var statusText: String
    var normalizedPace: Double
    var targetStart: Double?
    var targetEnd: Double?
}

struct RunShareModel: Equatable, Sendable {
    var workoutID: String
    var title: String
    var date: String
    var runType: String
    var environment: String?
    var accent: RunShareAccent
    var distance: String
    var secondaryDistance: String?
    var duration: String
    var pace: String
    var secondaryPace: String?
    var averageHeartRate: String?
    var weather: String?
    var city: String?
    var routePoints: [RunShareRoutePoint]
    var splitUnitTitle: String
    var splitRows: [RunShareSplitRow]
    var workoutPrescription: String?
    var workoutResultSummary: String?
    var averageWorkPace: String?
    var workRows: [RunShareWorkRow]

    var availableTemplates: [RunShareTemplate] {
        var templates: [RunShareTemplate] = [.summary]
        if !splitRows.isEmpty { templates.append(.splits) }
        if !workRows.isEmpty { templates.append(.workoutReps) }
        return templates
    }

    func pageCount(template: RunShareTemplate, canvas: RunShareCanvas) -> Int {
        let count: Int
        switch template {
        case .summary: count = 1
        case .splits: count = splitRows.count
        case .workoutReps: count = workRows.count
        }
        return max(1, Int(ceil(Double(count) / Double(canvas.rowCapacity(for: template)))))
    }

    func splitRows(page: Int, canvas: RunShareCanvas) -> [RunShareSplitRow] {
        pageSlice(splitRows, page: page, capacity: canvas.rowCapacity(for: .splits))
    }

    func workRows(page: Int, canvas: RunShareCanvas) -> [RunShareWorkRow] {
        pageSlice(workRows, page: page, capacity: canvas.rowCapacity(for: .workoutReps))
    }

    private func pageSlice<Element>(_ values: [Element], page: Int, capacity: Int) -> [Element] {
        guard !values.isEmpty, capacity > 0 else { return [] }
        let clampedPage = max(0, min(page, Int(ceil(Double(values.count) / Double(capacity))) - 1))
        let start = clampedPage * capacity
        let end = min(values.count, start + capacity)
        return Array(values[start..<end])
    }
}

enum RunShareModelBuilder {
    static func make(
        workout: CanonicalWorkout,
        presentation: WorkoutDetailPresentation,
        policy: RunDisplayPolicy,
        temperaturePreference: TemperatureUnitPreference = .system
    ) -> RunShareModel {
        let splitEstimates = presentation.segments.splits(for: policy.primaryUnit)
        let splitRows = makeSplitRows(
            estimates: splitEstimates,
            workout: workout,
            policy: policy
        )
        let workContent = makeWorkContent(
            workout: workout,
            result: presentation.supportedIntervals,
            policy: policy
        )
        let weather = weatherText(
            workout.evidence?.weather,
            preference: temperaturePreference
        )

        return RunShareModel(
            workoutID: workout.id,
            title: RunWorkout(workout: workout).runnerFacingTitle,
            date: RunFormatters.workoutFullDate.string(from: workout.startDate),
            runType: workout.effectiveRunType.visibleCategory.label,
            environment: workout.environment == .unknown ? nil : workout.environment.label,
            accent: shareAccent(for: workout.effectiveRunType),
            distance: RunFormatters.distance(workout.distanceMeters, policy: policy),
            secondaryDistance: RunFormatters.secondaryDistance(workout.distanceMeters, policy: policy),
            duration: RunFormatters.duration(workout.durationSeconds),
            pace: RunFormatters.pace(workout.paceSecondsPerKm, policy: policy),
            secondaryPace: RunFormatters.secondaryPace(workout.paceSecondsPerKm, policy: policy),
            averageHeartRate: workout.averageHeartRate.map { RunFormatters.number($0, suffix: " bpm") },
            weather: weather,
            city: workout.evidence?.cityName,
            routePoints: normalizedRoute(workout.evidence?.route ?? []),
            splitUnitTitle: policy.primaryUnit.normalSplitTitle,
            splitRows: splitRows,
            workoutPrescription: workContent.prescription,
            workoutResultSummary: workContent.resultSummary,
            averageWorkPace: workContent.averagePace,
            workRows: workContent.rows
        )
    }

    private static func makeSplitRows(
        estimates: [DerivedSplitEstimate],
        workout: CanonicalWorkout,
        policy: RunDisplayPolicy
    ) -> [RunShareSplitRow] {
        guard !estimates.isEmpty else { return [] }
        let paces = estimates.map(\.paceSecondsPerKmEstimate)
        let scale = PaceScale(paces: paces + [workout.paceSecondsPerKm].compactMap { $0 })
        let averagePosition = workout.paceSecondsPerKm.map(scale.position) ?? 0.5

        return estimates.enumerated().map { index, split in
            RunShareSplitRow(
                id: index,
                label: split.label,
                distance: split.label == "Final"
                    ? RunFormatters.compactDistance(split.distanceMeters, policy: policy)
                    : nil,
                pace: RunFormatters.pace(split.paceSecondsPerKmEstimate, policy: policy),
                heartRate: splitHeartRate(
                    split,
                    preceding: Array(estimates.prefix(index)),
                    workout: workout
                ),
                normalizedPace: scale.position(split.paceSecondsPerKmEstimate),
                normalizedAveragePace: averagePosition
            )
        }
    }

    private static func splitHeartRate(
        _ split: DerivedSplitEstimate,
        preceding: [DerivedSplitEstimate],
        workout: CanonicalWorkout
    ) -> String? {
        guard let points = workout.evidence?.series[.heartRate]?.points, !points.isEmpty else { return nil }
        let fallbackStart = preceding.map(\.durationSecondsEstimate).reduce(0, +)
        let startOffset = split.elapsedStartOffsetSeconds ?? fallbackStart
        let endOffset = split.elapsedEndOffsetSeconds ?? (startOffset + split.durationSecondsEstimate)
        let start = workout.startDate.addingTimeInterval(startOffset)
        let end = workout.startDate.addingTimeInterval(endOffset)
        let values = points
            .filter { $0.date >= start && $0.date < end && $0.value.isFinite && $0.value > 0 }
            .map(\.value)
        guard !values.isEmpty else { return nil }
        return "\(Int((values.reduce(0, +) / Double(values.count)).rounded())) bpm"
    }

    private static func makeWorkContent(
        workout: CanonicalWorkout,
        result: WorkoutIntervalReconstructionResult?,
        policy: RunDisplayPolicy
    ) -> (prescription: String?, resultSummary: String?, averagePace: String?, rows: [RunShareWorkRow]) {
        guard let result else { return (nil, nil, nil, []) }
        let summary = IntervalAnalysisSummary(workout: workout, result: result)
        let workRows = summary.rows.filter { $0.stepType == .work }
        guard !workRows.isEmpty else { return (nil, nil, nil, []) }
        let workIndexes = Set(workRows.map(\.index))
        let evaluationsByIndex = Dictionary(
            uniqueKeysWithValues: result.intervals.filter { workIndexes.contains($0.index) }.compactMap { interval in
                WorkTargetEvaluator.evaluate(interval: interval).map { ($0.rowIndex, $0) }
            }
        )
        let measuredPaces = workRows.compactMap(\.paceSecondsPerKm)
        let targetPaces = evaluationsByIndex.values.flatMap { evaluation -> [Double] in
            if let range = evaluation.targetRange {
                return [range.fastestSecondsPerKilometer, range.slowestSecondsPerKilometer]
            }
            return [evaluation.exactTargetSecondsPerKilometer].compactMap { $0 }
        }
        let scale = PaceScale(paces: measuredPaces + targetPaces)
        let rows = workRows.enumerated().map { ordinal, row in
            let evaluation = evaluationsByIndex[row.index]
            return RunShareWorkRow(
                id: row.index,
                label: "W\(ordinal + 1)",
                goal: row.plannedDistancePrescription?.displayText ?? row.plannedGoalDisplayText,
                pace: RunFormatters.pace(row.paceSecondsPerKm, policy: policy),
                heartRate: row.averageHeartRateBpm.map { "\(Int($0.rounded())) bpm" },
                status: shareStatus(evaluation),
                statusText: evaluation.map { WorkTargetPresentation.badgeLabel(for: $0, policy: policy) } ?? "Completed",
                normalizedPace: row.paceSecondsPerKm.map(scale.position) ?? 0,
                targetStart: evaluation?.targetRange.map { scale.position($0.slowestSecondsPerKilometer) }
                    ?? evaluation?.exactTargetSecondsPerKilometer.map(scale.position),
                targetEnd: evaluation?.targetRange.map { scale.position($0.fastestSecondsPerKilometer) }
                    ?? evaluation?.exactTargetSecondsPerKilometer.map(scale.position)
            )
        }
        let evaluations = Array(evaluationsByIndex.values).sorted { $0.rowIndex < $1.rowIndex }
        let targeted = evaluations.filter { $0.result != .noTarget }
        let resultSummary: String
        if !targeted.isEmpty {
            resultSummary = WorkTargetPresentation.summaryText(evaluations)
        } else if evaluations.contains(where: { $0.exactTargetSecondsPerKilometer != nil }) {
            resultSummary = "\(workRows.count) completed Work reps · exact targets compared"
        } else {
            resultSummary = "\(workRows.count) completed Work reps"
        }
        let averagePace = summary.workRepeatSummary?.primaryPaceSecondsPerKm.map {
            RunFormatters.pace($0, policy: policy)
        }

        return (
            prescriptionTitle(rows: workRows, policy: policy),
            resultSummary,
            averagePace,
            rows
        )
    }

    private static func prescriptionTitle(
        rows: [IntervalAnalysisRow],
        policy: RunDisplayPolicy
    ) -> String {
        guard let first = rows.first else { return "Completed workout" }
        let goalsMatch = rows.allSatisfy {
            $0.plannedGoalType == first.plannedGoalType
                && abs(($0.plannedGoalValue ?? 0) - (first.plannedGoalValue ?? 0)) < 0.5
                && $0.plannedDistancePrescription == first.plannedDistancePrescription
        }
        let goal = first.plannedDistancePrescription?.displayText ?? first.plannedGoalDisplayText
        var title = goalsMatch ? "\(rows.count) × \(goal)" : "\(rows.count) Work reps"
        if let target = PlannedWorkoutTargetPresentation.runnerText(first.plannedTargetDisplayText, policy: policy),
           rows.allSatisfy({ $0.plannedTargetDisplayText == first.plannedTargetDisplayText }) {
            title += " · \(target)"
        }
        return title
    }

    private static func shareStatus(_ evaluation: WorkTargetEvaluation?) -> RunShareWorkStatus {
        guard let evaluation else { return .noTarget }
        if evaluation.completionStatus == .shortened { return .shortened }
        if evaluation.exactTargetSecondsPerKilometer != nil { return .exactTarget }
        switch evaluation.result {
        case .onTarget: return RunShareWorkStatus.onTarget
        case .fast: return RunShareWorkStatus.fast
        case .slow: return RunShareWorkStatus.slow
        case .noTarget: return RunShareWorkStatus.noTarget
        }
    }

    private static func weatherText(
        _ weather: WorkoutWeather?,
        preference: TemperatureUnitPreference
    ) -> String? {
        guard let weather else { return nil }
        return [
            weather.temperatureCelsius.map { RunFormatters.temperature($0, preference: preference) },
            weather.humidityPercent.map { "\(RunFormatters.humidity($0)) humidity" }
        ]
        .compactMap { $0 }
        .joined(separator: " · ")
        .nilIfEmpty
    }

    private static func shareAccent(for runType: RunType) -> RunShareAccent {
        switch runType.visibleCategory.runSignalAccent {
        case .green: .green
        case .orange: .orange
        case .cyan: .cyan
        case .purple: .purple
        case .pink: .pink
        case .gray: .gray
        }
    }

    static func normalizedRoute(_ route: [WorkoutRoutePoint]) -> [RunShareRoutePoint] {
        let valid = route.filter {
            $0.latitude.isFinite && $0.longitude.isFinite
                && abs($0.latitude) <= 90 && abs($0.longitude) <= 180
        }
        guard valid.count >= 2 else { return [] }
        let maximumPoints = 600
        let stride = max(1, Int(ceil(Double(valid.count) / Double(maximumPoints))))
        var sampled = valid.enumerated().compactMap { index, point in
            index.isMultiple(of: stride) ? point : nil
        }
        if sampled.last != valid.last, let last = valid.last { sampled.append(last) }

        let meanLatitude = sampled.map(\.latitude).reduce(0, +) / Double(sampled.count)
        let longitudeScale = max(0.1, cos(meanLatitude * .pi / 180))
        let projected = sampled.map { point in
            (x: point.longitude * longitudeScale, y: point.latitude)
        }
        guard let minX = projected.map(\.x).min(),
              let maxX = projected.map(\.x).max(),
              let minY = projected.map(\.y).min(),
              let maxY = projected.map(\.y).max() else { return [] }
        let width = max(maxX - minX, 0.000_001)
        let height = max(maxY - minY, 0.000_001)
        let scale = max(width, height)
        let xPadding = (scale - width) / (2 * scale)
        let yPadding = (scale - height) / (2 * scale)

        return projected.map { point in
            RunShareRoutePoint(
                x: xPadding + (point.x - minX) / scale,
                y: 1 - (yPadding + (point.y - minY) / scale)
            )
        }
    }
}

private struct PaceScale {
    var minimumSpeed: Double
    var maximumSpeed: Double

    init(paces: [Double]) {
        let speeds = paces
            .filter { $0.isFinite && $0 > 0 }
            .map { 3_600 / $0 }
        let minimum = speeds.min() ?? 1
        let maximum = speeds.max() ?? minimum
        let padding = max((maximum - minimum) * 0.12, maximum * 0.02)
        minimumSpeed = max(0, minimum - padding)
        maximumSpeed = maximum + padding
    }

    func position(_ paceSecondsPerKm: Double) -> Double {
        guard paceSecondsPerKm.isFinite, paceSecondsPerKm > 0 else { return 0 }
        let speed = 3_600 / paceSecondsPerKm
        guard maximumSpeed > minimumSpeed else { return 0.5 }
        return min(1, max(0, (speed - minimumSpeed) / (maximumSpeed - minimumSpeed)))
    }
}

private extension String {
    var nilIfEmpty: String? { isEmpty ? nil : self }
}
