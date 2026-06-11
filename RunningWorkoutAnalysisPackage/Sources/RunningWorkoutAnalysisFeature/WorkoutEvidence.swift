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
    public var value: Double

    public init(date: Date, value: Double) {
        self.date = date
        self.value = value
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

    public init(startDate: Date, endDate: Date, type: String, label: String? = nil) {
        self.startDate = startDate
        self.endDate = endDate
        self.type = type
        self.label = label
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

    public init(
        workoutID: String,
        loadedAt: Date = Date(),
        series: [WorkoutEvidenceMetric: WorkoutMetricSeries] = [:],
        route: [WorkoutRoutePoint] = [],
        events: [WorkoutEvidenceEvent] = []
    ) {
        self.workoutID = workoutID
        self.loadedAt = loadedAt
        self.series = series
        self.route = route
        self.events = events.sorted { $0.startDate < $1.startDate }
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

        ## Evidence Samples
        \(metricLines)

        ## Evidence Caveats
        \(coverage.caveats.isEmpty ? "- None" : coverage.caveats.map { "- \($0)" }.joined(separator: "\n"))
        """
    }
}
