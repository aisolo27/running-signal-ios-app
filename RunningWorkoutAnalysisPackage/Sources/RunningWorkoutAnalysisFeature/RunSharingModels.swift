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

enum RunShareCanvas: Equatable, Sendable {
    case story
    case fullList

    static func defaultCanvas(for template: RunShareTemplate) -> RunShareCanvas {
        switch template {
        case .summary:
            return .story
        case .splits, .workoutReps:
            return .fullList
        }
    }

    var pointSize: CGSize {
        switch self {
        case .story: CGSize(width: 360, height: 640)
        case .fullList: CGSize(
            width: RunShareLayout.fullListWidthPoints,
            height: RunShareLayout.fullListMaximumHeightPoints
        )
        }
    }

    var pixelSize: CGSize {
        CGSize(width: pointSize.width * 3, height: pointSize.height * 3)
    }

    func rowCapacity(for template: RunShareTemplate) -> Int {
        switch (self, template) {
        case (.fullList, .splits), (.fullList, .workoutReps):
            RunShareLayout.fullListRowCapacity(for: template)
        case (.story, .workoutReps): 7
        case (.fullList, .summary): 1
        case (.story, .summary), (.story, .splits): 1
        }
    }
}

enum RunShareLayout {
    static let exportScale: CGFloat = 3
    static let fullListExportWidthPixels: CGFloat = 1_080
    static let fullListMaximumHeightPixels: CGFloat = 12_000
    static let fullListMaximumRowsPerImage = 200
    static let fullListSplitRowHeightPoints: CGFloat = 38
    static let fullListSplitFixedHeightPoints: CGFloat = 112
    static let fullListWorkoutRowHeightPoints: CGFloat = 44
    static let fullListWorkoutFixedHeightPoints: CGFloat = 148

    static let fullListWidthPoints = fullListExportWidthPixels / exportScale
    static let fullListMaximumHeightPoints = fullListMaximumHeightPixels / exportScale

    static func fullListRowHeightPoints(for template: RunShareTemplate) -> CGFloat {
        switch template {
        case .splits: fullListSplitRowHeightPoints
        case .workoutReps: fullListWorkoutRowHeightPoints
        case .summary: 0
        }
    }

    static func fullListFixedHeightPoints(for template: RunShareTemplate) -> CGFloat {
        switch template {
        case .splits: fullListSplitFixedHeightPoints
        case .workoutReps: fullListWorkoutFixedHeightPoints
        case .summary: fullListMaximumHeightPoints
        }
    }

    static func fullListPixelLimitedRowCapacity(for template: RunShareTemplate) -> Int {
        let rowHeight = fullListRowHeightPoints(for: template)
        guard rowHeight > 0 else { return 1 }
        return max(
            1,
            Int(
                (fullListMaximumHeightPoints - fullListFixedHeightPoints(for: template))
                    / rowHeight
            )
        )
    }

    static func fullListRowCapacity(for template: RunShareTemplate) -> Int {
        min(
            fullListMaximumRowsPerImage,
            fullListPixelLimitedRowCapacity(for: template)
        )
    }

    static func fullListHeightPoints(rowCount: Int, template: RunShareTemplate) -> CGFloat {
        let boundedRows = min(max(0, rowCount), fullListRowCapacity(for: template))
        return min(
            fullListMaximumHeightPoints,
            fullListFixedHeightPoints(for: template)
                + CGFloat(boundedRows) * fullListRowHeightPoints(for: template)
        )
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

enum RunShareRouteLayout {
    static func fittedPoints(
        _ points: [RunShareRoutePoint],
        in size: CGSize,
        inset: CGFloat = 0
    ) -> [CGPoint] {
        guard !points.isEmpty, size.width > 0, size.height > 0 else { return [] }

        let minimumX = points.map(\.x).min() ?? 0
        let maximumX = points.map(\.x).max() ?? minimumX
        let minimumY = points.map(\.y).min() ?? 0
        let maximumY = points.map(\.y).max() ?? minimumY
        let spanX = maximumX - minimumX
        let spanY = maximumY - minimumY
        let availableWidth = max(0, size.width - inset * 2)
        let availableHeight = max(0, size.height - inset * 2)
        let epsilon = 0.000_000_1

        let horizontalScale = spanX > epsilon
            ? Double(availableWidth) / spanX
            : .greatestFiniteMagnitude
        let verticalScale = spanY > epsilon
            ? Double(availableHeight) / spanY
            : .greatestFiniteMagnitude
        let scale: Double
        if spanX <= epsilon, spanY <= epsilon {
            scale = 0
        } else {
            scale = min(horizontalScale, verticalScale)
        }

        let drawnWidth = CGFloat(spanX * scale)
        let drawnHeight = CGFloat(spanY * scale)
        let originX = inset + (availableWidth - drawnWidth) / 2
        let originY = inset + (availableHeight - drawnHeight) / 2

        return points.map { point in
            CGPoint(
                x: originX + CGFloat((point.x - minimumX) * scale),
                y: originY + CGFloat((point.y - minimumY) * scale)
            )
        }
    }
}

struct RunShareSplitRow: Identifiable, Equatable, Sendable {
    var id: Int
    var label: String
    var distance: String?
    var pace: String
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
    var status: RunShareWorkStatus
    var statusText: String
}

struct RunShareModel: Equatable, Sendable {
    var accent: RunShareAccent
    var distance: String
    var duration: String
    var pace: String
    var routePoints: [RunShareRoutePoint]
    var splitUnitTitle: String
    var splitRows: [RunShareSplitRow]
    var workoutPrescription: String?
    var workoutTarget: String?
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
        return max(1, pageRanges(count: count, capacity: canvas.rowCapacity(for: template)).count)
    }

    func splitRows(page: Int, canvas: RunShareCanvas) -> [RunShareSplitRow] {
        pageSlice(splitRows, page: page, capacity: canvas.rowCapacity(for: .splits))
    }

    func workRows(page: Int, canvas: RunShareCanvas) -> [RunShareWorkRow] {
        pageSlice(workRows, page: page, capacity: canvas.rowCapacity(for: .workoutReps))
    }

    func pointSize(template: RunShareTemplate, canvas: RunShareCanvas, page: Int) -> CGSize {
        guard canvas == .fullList else { return canvas.pointSize }
        let rowCount: Int
        switch template {
        case .summary: return canvas.pointSize
        case .splits: rowCount = splitRows(page: page, canvas: canvas).count
        case .workoutReps: rowCount = workRows(page: page, canvas: canvas).count
        }
        return CGSize(
            width: RunShareLayout.fullListWidthPoints,
            height: RunShareLayout.fullListHeightPoints(
                rowCount: rowCount,
                template: template
            )
        )
    }

    private func pageSlice<Element>(_ values: [Element], page: Int, capacity: Int) -> [Element] {
        guard !values.isEmpty, capacity > 0 else { return [] }
        let ranges = pageRanges(count: values.count, capacity: capacity)
        let clampedPage = max(0, min(page, ranges.count - 1))
        return Array(values[ranges[clampedPage]])
    }

    private func pageRanges(count: Int, capacity: Int) -> [Range<Int>] {
        guard count > 0, capacity > 0 else { return [] }
        let pageCount = Int(ceil(Double(count) / Double(capacity)))
        let baseSize = count / pageCount
        let remainder = count % pageCount
        var start = 0
        return (0..<pageCount).map { page in
            let size = baseSize + (page < remainder ? 1 : 0)
            defer { start += size }
            return start..<(start + size)
        }
    }
}

enum RunShareModelBuilder {
    static func make(
        workout: CanonicalWorkout,
        presentation: WorkoutDetailPresentation,
        policy: RunDisplayPolicy
    ) -> RunShareModel {
        let splitEstimates = presentation.segments.splits(for: policy.primaryUnit)
        let splitRows = makeSplitRows(
            estimates: splitEstimates,
            policy: policy
        )
        let workContent = makeWorkContent(
            workout: workout,
            result: presentation.supportedIntervals,
            policy: policy
        )
        return RunShareModel(
            accent: shareAccent(for: workout.effectiveRunType),
            distance: RunFormatters.distance(workout.distanceMeters, policy: policy),
            duration: RunFormatters.duration(workout.durationSeconds),
            pace: RunFormatters.pace(workout.paceSecondsPerKm, policy: policy),
            routePoints: normalizedRoute(workout.evidence?.route ?? []),
            splitUnitTitle: policy.primaryUnit.normalSplitTitle,
            splitRows: splitRows,
            workoutPrescription: workContent.prescription,
            workoutTarget: workContent.target,
            workoutResultSummary: workContent.resultSummary,
            averageWorkPace: workContent.averagePace,
            workRows: workContent.rows
        )
    }

    private static func makeSplitRows(
        estimates: [DerivedSplitEstimate],
        policy: RunDisplayPolicy
    ) -> [RunShareSplitRow] {
        guard !estimates.isEmpty else { return [] }

        return estimates.enumerated().map { index, split in
            RunShareSplitRow(
                id: index,
                label: split.label,
                distance: split.label == "Final"
                    ? RunFormatters.compactDistance(split.distanceMeters, policy: policy)
                    : nil,
                pace: RunFormatters.pace(split.paceSecondsPerKmEstimate, policy: policy)
            )
        }
    }

    private static func makeWorkContent(
        workout: CanonicalWorkout,
        result: WorkoutIntervalReconstructionResult?,
        policy: RunDisplayPolicy
    ) -> (
        prescription: String?,
        target: String?,
        resultSummary: String?,
        averagePace: String?,
        rows: [RunShareWorkRow]
    ) {
        guard let result else { return (nil, nil, nil, nil, []) }
        let summary = IntervalAnalysisSummary(workout: workout, result: result)
        let workRows = summary.rows.filter { $0.stepType == .work }
        guard !workRows.isEmpty else { return (nil, nil, nil, nil, []) }
        let workIndexes = Set(workRows.map(\.index))
        let evaluationsByIndex = Dictionary(
            uniqueKeysWithValues: result.intervals.filter { workIndexes.contains($0.index) }.compactMap { interval in
                WorkTargetEvaluator.evaluate(interval: interval).map { ($0.rowIndex, $0) }
            }
        )
        let rows = workRows.enumerated().map { ordinal, row in
            let evaluation = evaluationsByIndex[row.index]
            return RunShareWorkRow(
                id: row.index,
                label: "W\(ordinal + 1)",
                goal: row.plannedDistancePrescription?.displayText ?? row.plannedGoalDisplayText,
                pace: RunFormatters.pace(row.paceSecondsPerKm, policy: policy),
                status: shareStatus(evaluation),
                statusText: evaluation.map { WorkTargetPresentation.badgeLabel(for: $0, policy: policy) } ?? "Completed"
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

        let prescription = prescriptionContent(rows: workRows, policy: policy)
        return (
            prescription.title,
            prescription.target,
            resultSummary,
            averagePace,
            rows
        )
    }

    private static func prescriptionContent(
        rows: [IntervalAnalysisRow],
        policy: RunDisplayPolicy
    ) -> (title: String, target: String?) {
        guard let first = rows.first else { return ("Completed workout", nil) }
        let goalsMatch = rows.allSatisfy {
            $0.plannedGoalType == first.plannedGoalType
                && abs(($0.plannedGoalValue ?? 0) - (first.plannedGoalValue ?? 0)) < 0.5
                && $0.plannedDistancePrescription == first.plannedDistancePrescription
        }
        let goal = first.plannedDistancePrescription?.displayText ?? first.plannedGoalDisplayText
        let title = goalsMatch ? "\(rows.count) × \(goal)" : "\(rows.count) Work reps"
        if let target = PlannedWorkoutTargetPresentation.runnerText(first.plannedTargetDisplayText, policy: policy),
           rows.allSatisfy({ $0.plannedTargetDisplayText == first.plannedTargetDisplayText }) {
            return (title, target)
        }
        return (title, nil)
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
