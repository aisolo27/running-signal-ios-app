import Foundation
import SwiftData

public enum RunEnvironment: String, Codable, CaseIterable, Identifiable, Sendable {
    case indoor
    case outdoor
    case unknown

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .indoor: "Indoor"
        case .outdoor: "Outdoor"
        case .unknown: "Unknown"
        }
    }
}

public enum RunType: String, Codable, CaseIterable, Identifiable, Sendable {
    case easy
    case recovery
    case longRun
    case tempo
    case threshold
    case interval
    case race
    case progression
    case hills
    case unknown

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .easy: "Easy"
        case .recovery: "Recovery"
        case .longRun: "Long Run"
        case .tempo: "Tempo"
        case .threshold: "Threshold"
        case .interval: "Interval"
        case .race: "Race"
        case .progression: "Progression"
        case .hills: "Hills"
        case .unknown: "Unknown"
        }
    }
}

public enum ConfidenceLevel: String, Codable, CaseIterable, Sendable {
    case strong
    case moderate
    case limited
    case unavailable

    var label: String {
        switch self {
        case .strong: "Strong"
        case .moderate: "Moderate"
        case .limited: "Limited"
        case .unavailable: "Unavailable"
        }
    }
}

public enum AuthorizationState: String, Sendable {
    case notDetermined
    case unavailable
    case requesting
    case authorized
    case denied
    case partial
    case error

    var label: String {
        switch self {
        case .notDetermined: "Not Requested"
        case .unavailable: "Unavailable"
        case .requesting: "Requesting"
        case .authorized: "Authorized"
        case .denied: "Denied"
        case .partial: "Partial"
        case .error: "Error"
        }
    }
}

public struct RunningGoal: Sendable {
    public let title: String
    public let raceDate: Date
    public let targetDistanceMeters: Double
    public let targetSeconds: TimeInterval
    public let targetPaceSecondsPerKm: Double

    public static let sub20FiveK = RunningGoal(
        title: "Sub-20 5K",
        raceDate: Calendar(identifier: .gregorian).date(from: DateComponents(year: 2026, month: 10, day: 17)) ?? Date(),
        targetDistanceMeters: 5_000,
        targetSeconds: 20 * 60,
        targetPaceSecondsPerKm: 239
    )
}

public struct HealthContext: Equatable, Sendable {
    public var vo2Max: Double?
    public var restingHeartRate: Double?
    public var averageHeartRate: Double?
    public var maxHeartRate: Double?
    public var activeEnergyKilocaloriesTotal: Double?

    public init(
        vo2Max: Double? = nil,
        restingHeartRate: Double? = nil,
        averageHeartRate: Double? = nil,
        maxHeartRate: Double? = nil,
        activeEnergyKilocaloriesTotal: Double? = nil
    ) {
        self.vo2Max = vo2Max
        self.restingHeartRate = restingHeartRate
        self.averageHeartRate = averageHeartRate
        self.maxHeartRate = maxHeartRate
        self.activeEnergyKilocaloriesTotal = activeEnergyKilocaloriesTotal
    }
}

public struct CanonicalWorkout: Identifiable, Equatable, Sendable {
    public var id: String
    public var sourceID: String
    public var sourceName: String
    public var startDate: Date
    public var endDate: Date
    public var environment: RunEnvironment
    public var distanceMeters: Double?
    public var durationSeconds: TimeInterval
    public var averageHeartRate: Double?
    public var maxHeartRate: Double?
    public var averageCadence: Double?
    public var averagePower: Double?
    public var strideLengthMeters: Double?
    public var verticalOscillationCentimeters: Double?
    public var groundContactMilliseconds: Double?
    public var routeAvailable: Bool
    public var seriesAvailable: Bool
    public var inferredRunType: RunType
    public var manualRunType: RunType?
    public var notes: String
    public var isDuplicate: Bool
    public var duplicateOfID: String?

    public init(
        id: String,
        sourceID: String,
        sourceName: String,
        startDate: Date,
        endDate: Date,
        environment: RunEnvironment,
        distanceMeters: Double?,
        durationSeconds: TimeInterval,
        averageHeartRate: Double? = nil,
        maxHeartRate: Double? = nil,
        averageCadence: Double? = nil,
        averagePower: Double? = nil,
        strideLengthMeters: Double? = nil,
        verticalOscillationCentimeters: Double? = nil,
        groundContactMilliseconds: Double? = nil,
        routeAvailable: Bool = false,
        seriesAvailable: Bool = false,
        inferredRunType: RunType = .unknown,
        manualRunType: RunType? = nil,
        notes: String = "",
        isDuplicate: Bool = false,
        duplicateOfID: String? = nil
    ) {
        self.id = id
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.startDate = startDate
        self.endDate = endDate
        self.environment = environment
        self.distanceMeters = distanceMeters
        self.durationSeconds = durationSeconds
        self.averageHeartRate = averageHeartRate
        self.maxHeartRate = maxHeartRate
        self.averageCadence = averageCadence
        self.averagePower = averagePower
        self.strideLengthMeters = strideLengthMeters
        self.verticalOscillationCentimeters = verticalOscillationCentimeters
        self.groundContactMilliseconds = groundContactMilliseconds
        self.routeAvailable = routeAvailable
        self.seriesAvailable = seriesAvailable
        self.inferredRunType = inferredRunType
        self.manualRunType = manualRunType
        self.notes = notes
        self.isDuplicate = isDuplicate
        self.duplicateOfID = duplicateOfID
    }

    public var effectiveRunType: RunType {
        manualRunType ?? inferredRunType
    }

    public var paceSecondsPerKm: Double? {
        PaceMath.paceSecondsPerKm(distanceMeters: distanceMeters, durationSeconds: durationSeconds)
    }

    public var distanceKilometers: Double? {
        guard let distanceMeters else { return nil }
        return distanceMeters / 1_000
    }
}

@Model
public final class PersistedWorkout {
    @Attribute(.unique) public var id: String
    public var sourceID: String
    public var sourceName: String
    public var startDate: Date
    public var endDate: Date
    public var environmentRaw: String
    public var distanceMeters: Double?
    public var durationSeconds: Double
    public var averageHeartRate: Double?
    public var maxHeartRate: Double?
    public var averageCadence: Double?
    public var averagePower: Double?
    public var strideLengthMeters: Double?
    public var verticalOscillationCentimeters: Double?
    public var groundContactMilliseconds: Double?
    public var routeAvailable: Bool
    public var seriesAvailable: Bool
    public var inferredRunTypeRaw: String
    public var manualRunTypeRaw: String?
    public var notes: String
    public var isDuplicate: Bool
    public var duplicateOfID: String?
    public var updatedAt: Date

    public init(workout: CanonicalWorkout) {
        id = workout.id
        sourceID = workout.sourceID
        sourceName = workout.sourceName
        startDate = workout.startDate
        endDate = workout.endDate
        environmentRaw = workout.environment.rawValue
        distanceMeters = workout.distanceMeters
        durationSeconds = workout.durationSeconds
        averageHeartRate = workout.averageHeartRate
        maxHeartRate = workout.maxHeartRate
        averageCadence = workout.averageCadence
        averagePower = workout.averagePower
        strideLengthMeters = workout.strideLengthMeters
        verticalOscillationCentimeters = workout.verticalOscillationCentimeters
        groundContactMilliseconds = workout.groundContactMilliseconds
        routeAvailable = workout.routeAvailable
        seriesAvailable = workout.seriesAvailable
        inferredRunTypeRaw = workout.inferredRunType.rawValue
        manualRunTypeRaw = workout.manualRunType?.rawValue
        notes = workout.notes
        isDuplicate = workout.isDuplicate
        duplicateOfID = workout.duplicateOfID
        updatedAt = Date()
    }

    public func update(from workout: CanonicalWorkout, preservingManualFields: Bool = true) {
        sourceID = workout.sourceID
        sourceName = workout.sourceName
        startDate = workout.startDate
        endDate = workout.endDate
        environmentRaw = workout.environment.rawValue
        distanceMeters = workout.distanceMeters
        durationSeconds = workout.durationSeconds
        averageHeartRate = workout.averageHeartRate
        maxHeartRate = workout.maxHeartRate
        averageCadence = workout.averageCadence
        averagePower = workout.averagePower
        strideLengthMeters = workout.strideLengthMeters
        verticalOscillationCentimeters = workout.verticalOscillationCentimeters
        groundContactMilliseconds = workout.groundContactMilliseconds
        routeAvailable = workout.routeAvailable
        seriesAvailable = workout.seriesAvailable
        inferredRunTypeRaw = workout.inferredRunType.rawValue
        if !preservingManualFields {
            manualRunTypeRaw = workout.manualRunType?.rawValue
            notes = workout.notes
        }
        isDuplicate = workout.isDuplicate
        duplicateOfID = workout.duplicateOfID
        updatedAt = Date()
    }

    public var canonical: CanonicalWorkout {
        CanonicalWorkout(
            id: id,
            sourceID: sourceID,
            sourceName: sourceName,
            startDate: startDate,
            endDate: endDate,
            environment: RunEnvironment(rawValue: environmentRaw) ?? .unknown,
            distanceMeters: distanceMeters,
            durationSeconds: durationSeconds,
            averageHeartRate: averageHeartRate,
            maxHeartRate: maxHeartRate,
            averageCadence: averageCadence,
            averagePower: averagePower,
            strideLengthMeters: strideLengthMeters,
            verticalOscillationCentimeters: verticalOscillationCentimeters,
            groundContactMilliseconds: groundContactMilliseconds,
            routeAvailable: routeAvailable,
            seriesAvailable: seriesAvailable,
            inferredRunType: RunType(rawValue: inferredRunTypeRaw) ?? .unknown,
            manualRunType: manualRunTypeRaw.flatMap(RunType.init(rawValue:)),
            notes: notes,
            isDuplicate: isDuplicate,
            duplicateOfID: duplicateOfID
        )
    }
}

public struct DataQualityReport: Sendable {
    public var workoutCount: Int
    public var includedWorkoutCount: Int
    public var duplicateCount: Int
    public var heartRateCoverage: Double
    public var cadenceCoverage: Double
    public var powerCoverage: Double
    public var mechanicsCoverage: Double
    public var routeCoverage: Double
    public var seriesCoverage: Double
    public var confidence: ConfidenceLevel
    public var caveats: [String]
}

public struct ReadinessSummary: Sendable {
    public var status: ConfidenceLevel
    public var title: String
    public var summary: String
    public var paceGapSecondsPerKm: Double?
    public var bestFiveKSeconds: Double?
    public var nextFocus: String
    public var evidence: [Insight]
}

public struct Insight: Identifiable, Sendable {
    public var id = UUID()
    public var title: String
    public var value: String
    public var detail: String
    public var confidence: ConfidenceLevel
}

public struct AnalysisSnapshot: Sendable {
    public var weeklyVolumeKm: Double
    public var previousWeeklyVolumeKm: Double
    public var trainingLoadConfidence: ConfidenceLevel
    public var easyPercent: Double
    public var qualityPercent: Double
    public var longRunPercent: Double
    public var fitnessTrend: Insight
    public var bestEfforts: [BestEffort]
    public var readiness: ReadinessSummary
    public var dataQuality: DataQualityReport
}

public struct BestEffort: Identifiable, Sendable {
    public var id: String { label }
    public var label: String
    public var distanceMeters: Double
    public var workoutID: String
    public var date: Date
    public var durationSeconds: Double
    public var paceSecondsPerKm: Double
}
