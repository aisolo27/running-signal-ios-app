import Foundation

public enum WorkoutEvidenceMetric: String, Codable, CaseIterable, Identifiable, Sendable {
    case heartRate
    case runningSpeed
    case distance
    case activeEnergy
    case basalEnergy
    case runningPower
    case cadence
    case stepCount
    case strideLength
    case verticalOscillation
    case groundContactTime

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .heartRate: "Heart rate"
        case .runningSpeed: "Running speed"
        case .distance: "Distance"
        case .activeEnergy: "Active energy"
        case .basalEnergy: "Basal energy"
        case .runningPower: "Power"
        case .cadence: "Cadence"
        case .stepCount: "Steps"
        case .strideLength: "Stride length"
        case .verticalOscillation: "Vertical oscillation"
        case .groundContactTime: "Ground contact time"
        }
    }
}

public struct WorkoutEvidencePoint: Codable, Equatable, Sendable {
    public var date: Date
    public var startDate: Date
    public var endDate: Date
    public var value: Double
    public var sampleSource: WorkoutEvidenceSampleSource
    public var sourceName: String?
    public var sourceVersion: String?
    public var deviceName: String?
    public var metadataKeys: [String]

    public init(
        date: Date,
        value: Double,
        startDate: Date? = nil,
        endDate: Date? = nil,
        sampleSource: WorkoutEvidenceSampleSource = .associatedWorkout,
        sourceName: String? = nil,
        sourceVersion: String? = nil,
        deviceName: String? = nil,
        metadataKeys: [String] = []
    ) {
        self.date = date
        self.startDate = startDate ?? date
        self.endDate = endDate ?? startDate ?? date
        self.value = value
        self.sampleSource = sampleSource
        self.sourceName = sourceName
        self.sourceVersion = sourceVersion
        self.deviceName = deviceName
        self.metadataKeys = metadataKeys
    }

    public init(date: Date, _ value: Double) {
        self.init(date: date, value: value)
    }

    private enum CodingKeys: String, CodingKey {
        case date
        case startDate
        case endDate
        case value
        case sampleSource
        case sourceName
        case sourceVersion
        case deviceName
        case metadataKeys
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        startDate = try container.decodeIfPresent(Date.self, forKey: .startDate) ?? date
        endDate = try container.decodeIfPresent(Date.self, forKey: .endDate) ?? startDate
        value = try container.decode(Double.self, forKey: .value)
        sampleSource = try container.decodeIfPresent(WorkoutEvidenceSampleSource.self, forKey: .sampleSource) ?? .associatedWorkout
        sourceName = try container.decodeIfPresent(String.self, forKey: .sourceName)
        sourceVersion = try container.decodeIfPresent(String.self, forKey: .sourceVersion)
        deviceName = try container.decodeIfPresent(String.self, forKey: .deviceName)
        metadataKeys = try container.decodeIfPresent([String].self, forKey: .metadataKeys) ?? []
    }
}

public enum WorkoutEvidenceSampleSource: String, Codable, Sendable {
    case associatedWorkout
    case sourceDateFallback
    case derived

    var label: String {
        switch self {
        case .associatedWorkout: "Associated workout"
        case .sourceDateFallback: "Source/date fallback"
        case .derived: "Derived"
        }
    }
}

public struct WorkoutRoutePoint: Codable, Equatable, Sendable {
    public var date: Date
    public var latitude: Double
    public var longitude: Double
    public var altitudeMeters: Double?
    public var speedMetersPerSecond: Double?

    public init(
        date: Date,
        latitude: Double,
        longitude: Double,
        altitudeMeters: Double? = nil,
        speedMetersPerSecond: Double? = nil
    ) {
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.altitudeMeters = altitudeMeters
        self.speedMetersPerSecond = speedMetersPerSecond
    }
}

public struct WorkoutEvidenceEvent: Codable, Equatable, Sendable {
    public var startDate: Date
    public var endDate: Date
    public var type: String
    public var label: String?
    public var metadataKeys: [String]?

    public init(
        startDate: Date,
        endDate: Date,
        type: String,
        label: String? = nil,
        metadataKeys: [String]? = nil
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.label = label
        self.metadataKeys = metadataKeys
    }

    public var displayLabel: String {
        if let label, !label.isEmpty {
            return label
        }
        return Self.displayLabel(for: type)
    }

    public static func displayLabel(for type: String) -> String {
        let normalized = type
            .replacingOccurrences(of: "HKWorkoutEventType", with: "")
            .replacingOccurrences(of: "WorkoutEventType", with: "")
            .replacingOccurrences(of: ".", with: "")
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        if normalized.contains("pauseorresumerequest") { return "Pause/resume request" }
        if normalized.contains("motionpaused") { return "Motion paused" }
        if normalized.contains("motionresumed") { return "Motion resumed" }
        if normalized.contains("pause") { return "Pause" }
        if normalized.contains("resume") { return "Resume" }
        if normalized.contains("lap") { return "Lap" }
        if normalized.contains("segment") { return "Segment" }
        if normalized.contains("marker") { return "Marker" }
        if normalized.contains("rawvalue: 1") { return "Pause" }
        if normalized.contains("rawvalue: 2") { return "Resume" }
        if normalized.contains("rawvalue: 3") { return "Lap" }
        if normalized.contains("rawvalue: 4") { return "Marker" }
        if normalized.contains("rawvalue: 5") { return "Motion paused" }
        if normalized.contains("rawvalue: 6") { return "Motion resumed" }
        if normalized.contains("rawvalue: 7") { return "Segment" }
        if normalized.contains("rawvalue: 8") { return "Pause/resume request" }
        return "Workout event"
    }
}

public struct WorkoutEvidenceActivityStatistic: Codable, Equatable, Sendable {
    public var quantityType: String
    public var unit: String?
    public var startDate: Date
    public var endDate: Date
    public var sourceCount: Int
    public var sum: Double?
    public var average: Double?
    public var minimum: Double?
    public var maximum: Double?
    public var durationSeconds: Double?

    public init(
        quantityType: String,
        unit: String? = nil,
        startDate: Date,
        endDate: Date,
        sourceCount: Int = 0,
        sum: Double? = nil,
        average: Double? = nil,
        minimum: Double? = nil,
        maximum: Double? = nil,
        durationSeconds: Double? = nil
    ) {
        self.quantityType = quantityType
        self.unit = unit
        self.startDate = startDate
        self.endDate = endDate
        self.sourceCount = sourceCount
        self.sum = sum
        self.average = average
        self.minimum = minimum
        self.maximum = maximum
        self.durationSeconds = durationSeconds
    }
}

public struct WorkoutEvidenceActivity: Codable, Equatable, Sendable {
    public var id: String
    public var activityType: String
    public var locationType: String?
    public var startDate: Date
    public var endDate: Date?
    public var durationSeconds: Double
    public var metadataKeys: [String]?
    public var events: [WorkoutEvidenceEvent]
    public var statistics: [WorkoutEvidenceActivityStatistic]

    public init(
        id: String,
        activityType: String,
        locationType: String? = nil,
        startDate: Date,
        endDate: Date? = nil,
        durationSeconds: Double,
        metadataKeys: [String]? = nil,
        events: [WorkoutEvidenceEvent] = [],
        statistics: [WorkoutEvidenceActivityStatistic] = []
    ) {
        self.id = id
        self.activityType = activityType
        self.locationType = locationType
        self.startDate = startDate
        self.endDate = endDate
        self.durationSeconds = durationSeconds
        self.metadataKeys = metadataKeys
        self.events = events.sorted { $0.startDate < $1.startDate }
        self.statistics = statistics.sorted { $0.quantityType < $1.quantityType }
    }
}

public enum WorkoutPlanAuditStatus: String, Codable, Equatable, Sendable {
    case available
    case unavailable
    case failed
    case unsupported

    public var label: String {
        switch self {
        case .available: "Available"
        case .unavailable: "Unavailable"
        case .failed: "Failed"
        case .unsupported: "Unsupported"
        }
    }
}

public struct WorkoutPlanAudit: Codable, Equatable, Sendable {
    public var status: WorkoutPlanAuditStatus
    public var planID: String?
    public var planType: String?
    public var displayName: String?
    public var summaryLines: [String]
    public var plannedSteps: [PlannedWorkoutStep]
    public var errorMessage: String?

    public init(
        status: WorkoutPlanAuditStatus,
        planID: String? = nil,
        planType: String? = nil,
        displayName: String? = nil,
        summaryLines: [String] = [],
        plannedSteps: [PlannedWorkoutStep] = [],
        errorMessage: String? = nil
    ) {
        self.status = status
        self.planID = planID
        self.planType = planType
        self.displayName = displayName
        self.summaryLines = summaryLines
        self.plannedSteps = plannedSteps
        self.errorMessage = errorMessage
    }
}

public struct WorkoutMetricSeries: Codable, Equatable, Sendable {
    public var metric: WorkoutEvidenceMetric
    public var unit: String
    public var points: [WorkoutEvidencePoint]

    public init(metric: WorkoutEvidenceMetric, unit: String, points: [WorkoutEvidencePoint]) {
        self.metric = metric
        self.unit = unit
        self.points = points.sorted { $0.date < $1.date }
    }

    public var sampleCount: Int { points.count }

    public var average: Double? {
        guard !points.isEmpty else { return nil }
        return points.map(\.value).reduce(0, +) / Double(points.count)
    }

    public var maximum: Double? {
        points.map(\.value).max()
    }
}

public struct WorkoutEvidence: Codable, Equatable, Sendable {
    public var workoutID: String
    public var loadedAt: Date
    public var series: [WorkoutEvidenceMetric: WorkoutMetricSeries]
    public var route: [WorkoutRoutePoint]
    public var events: [WorkoutEvidenceEvent]
    public var activities: [WorkoutEvidenceActivity]
    public var workoutPlanAudit: WorkoutPlanAudit?
    public var diagnostics: WorkoutEvidenceDiagnostics?

    private enum CodingKeys: String, CodingKey {
        case workoutID
        case loadedAt
        case series
        case route
        case events
        case activities
        case workoutPlanAudit
        case diagnostics
    }

    public init(
        workoutID: String,
        loadedAt: Date = Date(),
        series: [WorkoutEvidenceMetric: WorkoutMetricSeries] = [:],
        route: [WorkoutRoutePoint] = [],
        events: [WorkoutEvidenceEvent] = [],
        activities: [WorkoutEvidenceActivity] = [],
        workoutPlanAudit: WorkoutPlanAudit? = nil,
        diagnostics: WorkoutEvidenceDiagnostics? = nil
    ) {
        self.workoutID = workoutID
        self.loadedAt = loadedAt
        self.series = series
        self.route = route
        self.events = events.sorted { $0.startDate < $1.startDate }
        self.activities = activities.sorted { $0.startDate < $1.startDate }
        self.workoutPlanAudit = workoutPlanAudit
        self.diagnostics = diagnostics
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        workoutID = try container.decode(String.self, forKey: .workoutID)
        loadedAt = try container.decode(Date.self, forKey: .loadedAt)
        series = try container.decode([WorkoutEvidenceMetric: WorkoutMetricSeries].self, forKey: .series)
        route = try container.decode([WorkoutRoutePoint].self, forKey: .route)
        events = try container.decode([WorkoutEvidenceEvent].self, forKey: .events).sorted { $0.startDate < $1.startDate }
        activities = try container.decodeIfPresent([WorkoutEvidenceActivity].self, forKey: .activities)?.sorted { $0.startDate < $1.startDate } ?? []
        workoutPlanAudit = try container.decodeIfPresent(WorkoutPlanAudit.self, forKey: .workoutPlanAudit)
        diagnostics = try container.decodeIfPresent(WorkoutEvidenceDiagnostics.self, forKey: .diagnostics)
    }

    public func hasSeries(_ metric: WorkoutEvidenceMetric) -> Bool {
        (series[metric]?.sampleCount ?? 0) > 0
    }

    public func sampleCount(_ metric: WorkoutEvidenceMetric) -> Int {
        series[metric]?.sampleCount ?? 0
    }

    public var seriesSampleCount: Int {
        series.values.map(\.sampleCount).reduce(0, +)
    }

    public var elevationGainMeters: Double? {
        let altitudes = route.compactMap(\.altitudeMeters)
        guard altitudes.count >= 2 else { return nil }

        let gain = zip(altitudes, altitudes.dropFirst())
            .map { current, next in max(0, next - current) }
            .reduce(0, +)

        return gain > 0 ? gain : nil
    }

    public func average(_ metric: WorkoutEvidenceMetric) -> Double? {
        series[metric]?.average
    }

    public func maximum(_ metric: WorkoutEvidenceMetric) -> Double? {
        series[metric]?.maximum
    }

    public func sum(_ metric: WorkoutEvidenceMetric) -> Double? {
        guard let points = series[metric]?.points, !points.isEmpty else { return nil }
        return points.map(\.value).reduce(0, +)
    }
}

public struct WorkoutEvidenceDiagnostics: Codable, Equatable, Sendable {
    public var queryDiagnostics: [WorkoutEvidenceQueryDiagnostic]

    public init(queryDiagnostics: [WorkoutEvidenceQueryDiagnostic] = []) {
        self.queryDiagnostics = queryDiagnostics
    }

    public var warnings: [String] {
        queryDiagnostics.compactMap { diagnostic in
            guard diagnostic.status != .loaded else { return nil }
            if let message = diagnostic.message, !message.isEmpty {
                return "\(diagnostic.name): \(message)"
            }
            return "\(diagnostic.name): \(diagnostic.status.rawValue)"
        }
    }
}

public struct WorkoutEvidenceQueryDiagnostic: Codable, Equatable, Sendable {
    public var name: String
    public var status: WorkoutEvidenceQueryStatus
    public var count: Int
    public var message: String?

    public init(name: String, status: WorkoutEvidenceQueryStatus, count: Int, message: String? = nil) {
        self.name = name
        self.status = status
        self.count = count
        self.message = message
    }
}

public enum WorkoutEvidenceQueryStatus: String, Codable, Equatable, Sendable {
    case loaded
    case unavailable
    case failed
}

public struct WorkoutEvidenceCoverage: Equatable, Sendable {
    public var heartRate: Bool
    public var speedOrDistance: Bool
    public var route: Bool
    public var activeEnergy: Bool
    public var power: Bool
    public var cadenceOrSteps: Bool
    public var mechanics: Bool
    public var confidence: ConfidenceLevel
    public var caveats: [String]

    public init(
        heartRate: Bool,
        speedOrDistance: Bool,
        route: Bool,
        activeEnergy: Bool,
        power: Bool,
        cadenceOrSteps: Bool,
        mechanics: Bool,
        confidence: ConfidenceLevel,
        caveats: [String]
    ) {
        self.heartRate = heartRate
        self.speedOrDistance = speedOrDistance
        self.route = route
        self.activeEnergy = activeEnergy
        self.power = power
        self.cadenceOrSteps = cadenceOrSteps
        self.mechanics = mechanics
        self.confidence = confidence
        self.caveats = caveats
    }
}

public enum WorkoutEvidenceAnalyzer {
    public static func coverage(for evidence: WorkoutEvidence) -> WorkoutEvidenceCoverage {
        let heartRate = evidence.hasSeries(.heartRate)
        let speedOrDistance = evidence.hasSeries(.runningSpeed) || evidence.hasSeries(.distance)
        let route = !evidence.route.isEmpty
        let activeEnergy = evidence.hasSeries(.activeEnergy)
        let power = evidence.hasSeries(.runningPower)
        let cadenceOrSteps = evidence.hasSeries(.cadence) || evidence.hasSeries(.stepCount)
        let mechanics = evidence.hasSeries(.strideLength)
            || evidence.hasSeries(.verticalOscillation)
            || evidence.hasSeries(.groundContactTime)

        var score = 0
        [heartRate, speedOrDistance, route, power, cadenceOrSteps, mechanics].forEach {
            if $0 { score += 1 }
        }

        let confidence: ConfidenceLevel
        if score >= 5 {
            confidence = .strong
        } else if heartRate && speedOrDistance && score >= 3 {
            confidence = .moderate
        } else if score > 0 {
            confidence = .limited
        } else {
            confidence = .unavailable
        }

        var caveats: [String] = []
        if !heartRate {
            caveats.append("Heart-rate series is missing, so drift and intensity claims stay limited.")
        }
        if !speedOrDistance {
            caveats.append("Speed or distance series is missing, so pacing-shape claims stay limited.")
        }
        if !mechanics {
            caveats.append("Mechanics series is missing, so form claims stay hidden.")
        }
        if !route {
            caveats.append("Route points are unavailable for this workout.")
        }

        return WorkoutEvidenceCoverage(
            heartRate: heartRate,
            speedOrDistance: speedOrDistance,
            route: route,
            activeEnergy: activeEnergy,
            power: power,
            cadenceOrSteps: cadenceOrSteps,
            mechanics: mechanics,
            confidence: confidence,
            caveats: caveats
        )
    }

    public static func diagnostics(for evidence: WorkoutEvidence) -> String {
        let coverage = coverage(for: evidence)
        let metricLines = WorkoutEvidenceMetric.allCases.map { metric in
            "- \(metric.label): \(evidence.series[metric]?.sampleCount ?? 0)"
        }.joined(separator: "\n")

        return """
        ## Workout Evidence
        - Workout ID: \(evidence.workoutID)
        - Confidence: \(coverage.confidence.label)
        - Route points: \(evidence.route.count)
        - Events: \(evidence.events.count)
        - WorkoutKit plan: \(evidence.workoutPlanAudit?.status.label ?? "Not audited")

        ## Evidence Samples
        \(metricLines)

        ## WorkoutKit Plan Audit
        \(planAuditLines(evidence.workoutPlanAudit))

        ## Evidence Caveats
        \(coverage.caveats.isEmpty ? "- None" : coverage.caveats.map { "- \($0)" }.joined(separator: "\n"))
        """
    }

    private static func planAuditLines(_ audit: WorkoutPlanAudit?) -> String {
        guard let audit else { return "- Not audited" }
        var lines = ["- Status: \(audit.status.label)"]
        if let planID = audit.planID {
            lines.append("- Plan ID: \(planID)")
        }
        if let planType = audit.planType {
            lines.append("- Plan type: \(planType)")
        }
        if let displayName = audit.displayName {
            lines.append("- Display name: \(displayName)")
        }
        if let errorMessage = audit.errorMessage {
            lines.append("- Error: \(errorMessage)")
        }
        lines.append(contentsOf: audit.summaryLines.map { "- \($0)" })
        return lines.joined(separator: "\n")
    }
}
