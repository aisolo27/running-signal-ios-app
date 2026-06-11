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
    case weak
    case blocked
    case unavailable

    var label: String {
        switch self {
        case .strong: "Strong"
        case .moderate: "Moderate"
        case .limited: "Limited"
        case .weak: "Weak"
        case .blocked: "Blocked"
        case .unavailable: "Unavailable"
        }
    }
}

public enum RunTypeTrustKind: String, Codable, CaseIterable, Sendable {
    case suggested
    case importedReview
    case userReviewed
    case needsReview
    case conflict

    public var label: String {
        switch self {
        case .suggested: "Suggested"
        case .importedReview: "Imported review"
        case .userReviewed: "User reviewed"
        case .needsReview: "Needs review"
        case .conflict: "Conflict"
        }
    }
}

public struct RunTypeTrustState: Equatable, Sendable {
    public var kind: RunTypeTrustKind
    public var runType: RunType?
    public var confidence: ConfidenceLevel
    public var detail: String

    public init(kind: RunTypeTrustKind, runType: RunType?, confidence: ConfidenceLevel, detail: String) {
        self.kind = kind
        self.runType = runType
        self.confidence = confidence
        self.detail = detail
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

public struct HealthKitActionStatus: Equatable, Sendable {
    public var authorizationState: AuthorizationState
    public var message: String
    public var updatedAt: Date?

    public init(
        authorizationState: AuthorizationState = .notDetermined,
        message: String = "Sample data is loaded until HealthKit returns workouts.",
        updatedAt: Date? = nil
    ) {
        self.authorizationState = authorizationState
        self.message = message
        self.updatedAt = updatedAt
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
    public var deviceName: String?
    public var startDate: Date
    public var endDate: Date
    public var environment: RunEnvironment
    public var distanceMeters: Double?
    public var durationSeconds: TimeInterval
    public var elapsedSeconds: TimeInterval
    public var activeEnergyKilocalories: Double?
    public var totalEnergyKilocalories: Double?
    public var elevationGainMeters: Double?
    public var averageHeartRate: Double?
    public var maxHeartRate: Double?
    public var averageCadence: Double?
    public var averagePower: Double?
    public var strideLengthMeters: Double?
    public var verticalOscillationCentimeters: Double?
    public var groundContactMilliseconds: Double?
    public var routeAvailable: Bool
    public var seriesAvailable: Bool
    public var routePointCount: Int = 0
    public var seriesSampleCount: Int = 0
    public var heartRateSampleCount: Int = 0
    public var runningSpeedSampleCount: Int = 0
    public var distanceSampleCount: Int = 0
    public var activeEnergySampleCount: Int = 0
    public var runningPowerSampleCount: Int = 0
    public var cadenceSampleCount: Int = 0
    public var stepCountSampleCount: Int = 0
    public var strideLengthSampleCount: Int = 0
    public var verticalOscillationSampleCount: Int = 0
    public var groundContactTimeSampleCount: Int = 0
    public var intervalCount: Int = 0
    public var intervalLabelsSummary: String?
    public var inferredRunType: RunType
    public var manualRunType: RunType?
    public var importedRunType: RunType?
    public var importedReviewID: String?
    public var notes: String
    public var isDuplicate: Bool
    public var duplicateOfID: String?
    public var evidence: WorkoutEvidence?

    public init(
        id: String,
        sourceID: String,
        sourceName: String,
        deviceName: String? = nil,
        startDate: Date,
        endDate: Date,
        environment: RunEnvironment,
        distanceMeters: Double?,
        durationSeconds: TimeInterval,
        elapsedSeconds: TimeInterval? = nil,
        activeEnergyKilocalories: Double? = nil,
        totalEnergyKilocalories: Double? = nil,
        elevationGainMeters: Double? = nil,
        averageHeartRate: Double? = nil,
        maxHeartRate: Double? = nil,
        averageCadence: Double? = nil,
        averagePower: Double? = nil,
        strideLengthMeters: Double? = nil,
        verticalOscillationCentimeters: Double? = nil,
        groundContactMilliseconds: Double? = nil,
        routeAvailable: Bool = false,
        seriesAvailable: Bool = false,
        routePointCount: Int = 0,
        seriesSampleCount: Int = 0,
        heartRateSampleCount: Int = 0,
        runningSpeedSampleCount: Int = 0,
        distanceSampleCount: Int = 0,
        activeEnergySampleCount: Int = 0,
        runningPowerSampleCount: Int = 0,
        cadenceSampleCount: Int = 0,
        stepCountSampleCount: Int = 0,
        strideLengthSampleCount: Int = 0,
        verticalOscillationSampleCount: Int = 0,
        groundContactTimeSampleCount: Int = 0,
        intervalCount: Int = 0,
        intervalLabelsSummary: String? = nil,
        inferredRunType: RunType = .unknown,
        manualRunType: RunType? = nil,
        importedRunType: RunType? = nil,
        importedReviewID: String? = nil,
        notes: String = "",
        isDuplicate: Bool = false,
        duplicateOfID: String? = nil,
        evidence: WorkoutEvidence? = nil
    ) {
        self.id = id
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.deviceName = deviceName
        self.startDate = startDate
        self.endDate = endDate
        self.environment = environment
        self.distanceMeters = distanceMeters
        self.durationSeconds = durationSeconds
        self.elapsedSeconds = elapsedSeconds ?? endDate.timeIntervalSince(startDate)
        self.activeEnergyKilocalories = activeEnergyKilocalories
        self.totalEnergyKilocalories = totalEnergyKilocalories
        self.elevationGainMeters = elevationGainMeters
        self.averageHeartRate = averageHeartRate
        self.maxHeartRate = maxHeartRate
        self.averageCadence = averageCadence
        self.averagePower = averagePower
        self.strideLengthMeters = strideLengthMeters
        self.verticalOscillationCentimeters = verticalOscillationCentimeters
        self.groundContactMilliseconds = groundContactMilliseconds
        self.routeAvailable = routeAvailable
        self.seriesAvailable = seriesAvailable
        self.routePointCount = routePointCount
        self.seriesSampleCount = seriesSampleCount
        self.heartRateSampleCount = heartRateSampleCount
        self.runningSpeedSampleCount = runningSpeedSampleCount
        self.distanceSampleCount = distanceSampleCount
        self.activeEnergySampleCount = activeEnergySampleCount
        self.runningPowerSampleCount = runningPowerSampleCount
        self.cadenceSampleCount = cadenceSampleCount
        self.stepCountSampleCount = stepCountSampleCount
        self.strideLengthSampleCount = strideLengthSampleCount
        self.verticalOscillationSampleCount = verticalOscillationSampleCount
        self.groundContactTimeSampleCount = groundContactTimeSampleCount
        self.intervalCount = intervalCount
        self.intervalLabelsSummary = intervalLabelsSummary
        self.inferredRunType = inferredRunType
        self.manualRunType = manualRunType
        self.importedRunType = importedRunType
        self.importedReviewID = importedReviewID
        self.notes = notes
        self.isDuplicate = isDuplicate
        self.duplicateOfID = duplicateOfID
        self.evidence = evidence
    }

    public var effectiveRunType: RunType {
        manualRunType ?? importedRunType ?? inferredRunType
    }

    public var runTypeTrust: RunTypeTrustState {
        if let manualRunType, let importedRunType, manualRunType != importedRunType {
            return RunTypeTrustState(
                kind: .conflict,
                runType: manualRunType,
                confidence: .limited,
                detail: "User-reviewed label differs from imported reviewed category."
            )
        }
        if let manualRunType {
            return RunTypeTrustState(
                kind: .userReviewed,
                runType: manualRunType,
                confidence: .strong,
                detail: "Explicitly chosen in the iPhone app."
            )
        }
        if let importedRunType {
            return RunTypeTrustState(
                kind: .importedReview,
                runType: importedRunType,
                confidence: .moderate,
                detail: importedReviewID.map { "Matched imported review \($0)." } ?? "Matched an imported reviewed web category."
            )
        }
        if inferredRunType == .unknown {
            return RunTypeTrustState(
                kind: .needsReview,
                runType: nil,
                confidence: .limited,
                detail: "HealthKit evidence is insufficient for a useful suggested run type."
            )
        }
        return RunTypeTrustState(
            kind: .suggested,
            runType: inferredRunType,
            confidence: .limited,
            detail: "Rule-based suggestion from HealthKit summary/evidence."
        )
    }

    public var trustedPurposeRunType: RunType? {
        switch runTypeTrust.kind {
        case .userReviewed, .importedReview:
            effectiveRunType
        case .conflict, .suggested, .needsReview:
            nil
        }
    }

    public var paceSecondsPerKm: Double? {
        PaceMath.paceSecondsPerKm(distanceMeters: distanceMeters, durationSeconds: durationSeconds)
    }

    public var fullStepCadence: Double? {
        guard let averageCadence else { return nil }
        if averageCadence > 0, averageCadence < 120 {
            return averageCadence * 2
        }
        return averageCadence
    }

    public var distanceKilometers: Double? {
        guard let distanceMeters else { return nil }
        return distanceMeters / 1_000
    }

    public var dataSourceLabel: String {
        id.hasPrefix("sample-") || sourceName == "Sample Apple Watch" ? "sample fallback" : "real HealthKit"
    }

    public var workoutScopeLabel: String {
        evidence == nil ? "HealthKit workout summary" : "workout-scoped HealthKit evidence"
    }
}

@Model
public final class PersistedWorkout {
    @Attribute(.unique) public var id: String
    public var sourceID: String
    public var sourceName: String
    public var deviceName: String?
    public var startDate: Date
    public var endDate: Date
    public var environmentRaw: String
    public var distanceMeters: Double?
    public var durationSeconds: Double
    public var elapsedSeconds: Double = 0
    public var activeEnergyKilocalories: Double?
    public var totalEnergyKilocalories: Double?
    public var elevationGainMeters: Double?
    public var averageHeartRate: Double?
    public var maxHeartRate: Double?
    public var averageCadence: Double?
    public var averagePower: Double?
    public var strideLengthMeters: Double?
    public var verticalOscillationCentimeters: Double?
    public var groundContactMilliseconds: Double?
    public var routeAvailable: Bool
    public var seriesAvailable: Bool
    public var routePointCount: Int = 0
    public var seriesSampleCount: Int = 0
    public var heartRateSampleCount: Int = 0
    public var runningSpeedSampleCount: Int = 0
    public var distanceSampleCount: Int = 0
    public var activeEnergySampleCount: Int = 0
    public var runningPowerSampleCount: Int = 0
    public var cadenceSampleCount: Int = 0
    public var stepCountSampleCount: Int = 0
    public var strideLengthSampleCount: Int = 0
    public var verticalOscillationSampleCount: Int = 0
    public var groundContactTimeSampleCount: Int = 0
    public var intervalCount: Int = 0
    public var intervalLabelsSummary: String?
    public var inferredRunTypeRaw: String
    public var manualRunTypeRaw: String?
    public var importedRunTypeRaw: String?
    public var importedReviewID: String?
    public var notes: String
    public var isDuplicate: Bool
    public var duplicateOfID: String?
    public var updatedAt: Date

    public init(workout: CanonicalWorkout) {
        id = workout.id
        sourceID = workout.sourceID
        sourceName = workout.sourceName
        deviceName = workout.deviceName
        startDate = workout.startDate
        endDate = workout.endDate
        environmentRaw = workout.environment.rawValue
        distanceMeters = workout.distanceMeters
        durationSeconds = workout.durationSeconds
        elapsedSeconds = workout.elapsedSeconds
        activeEnergyKilocalories = workout.activeEnergyKilocalories
        totalEnergyKilocalories = workout.totalEnergyKilocalories
        elevationGainMeters = workout.elevationGainMeters
        averageHeartRate = workout.averageHeartRate
        maxHeartRate = workout.maxHeartRate
        averageCadence = workout.averageCadence
        averagePower = workout.averagePower
        strideLengthMeters = workout.strideLengthMeters
        verticalOscillationCentimeters = workout.verticalOscillationCentimeters
        groundContactMilliseconds = workout.groundContactMilliseconds
        routeAvailable = workout.routeAvailable
        seriesAvailable = workout.seriesAvailable
        routePointCount = workout.routePointCount
        seriesSampleCount = workout.seriesSampleCount
        heartRateSampleCount = workout.heartRateSampleCount
        runningSpeedSampleCount = workout.runningSpeedSampleCount
        distanceSampleCount = workout.distanceSampleCount
        activeEnergySampleCount = workout.activeEnergySampleCount
        runningPowerSampleCount = workout.runningPowerSampleCount
        cadenceSampleCount = workout.cadenceSampleCount
        stepCountSampleCount = workout.stepCountSampleCount
        strideLengthSampleCount = workout.strideLengthSampleCount
        verticalOscillationSampleCount = workout.verticalOscillationSampleCount
        groundContactTimeSampleCount = workout.groundContactTimeSampleCount
        intervalCount = workout.intervalCount
        intervalLabelsSummary = workout.intervalLabelsSummary
        inferredRunTypeRaw = workout.inferredRunType.rawValue
        manualRunTypeRaw = workout.manualRunType?.rawValue
        importedRunTypeRaw = workout.importedRunType?.rawValue
        importedReviewID = workout.importedReviewID
        notes = workout.notes
        isDuplicate = workout.isDuplicate
        duplicateOfID = workout.duplicateOfID
        updatedAt = Date()
    }

    public func update(from workout: CanonicalWorkout, preservingManualFields: Bool = true) {
        sourceID = workout.sourceID
        sourceName = workout.sourceName
        deviceName = workout.deviceName
        startDate = workout.startDate
        endDate = workout.endDate
        environmentRaw = workout.environment.rawValue
        distanceMeters = workout.distanceMeters
        durationSeconds = workout.durationSeconds
        elapsedSeconds = workout.elapsedSeconds
        activeEnergyKilocalories = workout.activeEnergyKilocalories
        totalEnergyKilocalories = workout.totalEnergyKilocalories
        elevationGainMeters = workout.elevationGainMeters
        averageHeartRate = workout.averageHeartRate
        maxHeartRate = workout.maxHeartRate
        averageCadence = workout.averageCadence
        averagePower = workout.averagePower
        strideLengthMeters = workout.strideLengthMeters
        verticalOscillationCentimeters = workout.verticalOscillationCentimeters
        groundContactMilliseconds = workout.groundContactMilliseconds
        routeAvailable = workout.routeAvailable
        seriesAvailable = workout.seriesAvailable
        routePointCount = workout.routePointCount
        seriesSampleCount = workout.seriesSampleCount
        heartRateSampleCount = workout.heartRateSampleCount
        runningSpeedSampleCount = workout.runningSpeedSampleCount
        distanceSampleCount = workout.distanceSampleCount
        activeEnergySampleCount = workout.activeEnergySampleCount
        runningPowerSampleCount = workout.runningPowerSampleCount
        cadenceSampleCount = workout.cadenceSampleCount
        stepCountSampleCount = workout.stepCountSampleCount
        strideLengthSampleCount = workout.strideLengthSampleCount
        verticalOscillationSampleCount = workout.verticalOscillationSampleCount
        groundContactTimeSampleCount = workout.groundContactTimeSampleCount
        intervalCount = workout.intervalCount
        intervalLabelsSummary = workout.intervalLabelsSummary
        inferredRunTypeRaw = workout.inferredRunType.rawValue
        if !preservingManualFields {
            manualRunTypeRaw = workout.manualRunType?.rawValue
            importedRunTypeRaw = workout.importedRunType?.rawValue
            importedReviewID = workout.importedReviewID
            notes = workout.notes
        } else if workout.importedRunType != nil || workout.importedReviewID != nil {
            importedRunTypeRaw = workout.importedRunType?.rawValue
            importedReviewID = workout.importedReviewID
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
            deviceName: deviceName,
            startDate: startDate,
            endDate: endDate,
            environment: RunEnvironment(rawValue: environmentRaw) ?? .unknown,
            distanceMeters: distanceMeters,
            durationSeconds: durationSeconds,
            elapsedSeconds: elapsedSeconds > 0 ? elapsedSeconds : endDate.timeIntervalSince(startDate),
            activeEnergyKilocalories: activeEnergyKilocalories,
            totalEnergyKilocalories: totalEnergyKilocalories,
            elevationGainMeters: elevationGainMeters,
            averageHeartRate: averageHeartRate,
            maxHeartRate: maxHeartRate,
            averageCadence: averageCadence,
            averagePower: averagePower,
            strideLengthMeters: strideLengthMeters,
            verticalOscillationCentimeters: verticalOscillationCentimeters,
            groundContactMilliseconds: groundContactMilliseconds,
            routeAvailable: routeAvailable,
            seriesAvailable: seriesAvailable,
            routePointCount: routePointCount,
            seriesSampleCount: seriesSampleCount,
            heartRateSampleCount: heartRateSampleCount,
            runningSpeedSampleCount: runningSpeedSampleCount,
            distanceSampleCount: distanceSampleCount,
            activeEnergySampleCount: activeEnergySampleCount,
            runningPowerSampleCount: runningPowerSampleCount,
            cadenceSampleCount: cadenceSampleCount,
            stepCountSampleCount: stepCountSampleCount,
            strideLengthSampleCount: strideLengthSampleCount,
            verticalOscillationSampleCount: verticalOscillationSampleCount,
            groundContactTimeSampleCount: groundContactTimeSampleCount,
            intervalCount: intervalCount,
            intervalLabelsSummary: intervalLabelsSummary,
            inferredRunType: RunType(rawValue: inferredRunTypeRaw) ?? .unknown,
            manualRunType: manualRunTypeRaw.flatMap(RunType.init(rawValue:)),
            importedRunType: importedRunTypeRaw.flatMap(RunType.init(rawValue:)),
            importedReviewID: importedReviewID,
            notes: notes,
            isDuplicate: isDuplicate,
            duplicateOfID: duplicateOfID
        )
    }
}

@Model
public final class PersistedWorkoutEvidence {
    @Attribute(.unique) public var workoutID: String
    public var loadedAt: Date
    public var sourceSummary: String
    public var seriesSampleCount: Int
    public var routePointCount: Int
    public var eventCount: Int
    public var evidenceData: Data
    public var updatedAt: Date

    public init(workoutID: String, evidence: WorkoutEvidence, sourceSummary: String = "") {
        self.workoutID = workoutID
        self.loadedAt = evidence.loadedAt
        self.sourceSummary = sourceSummary
        self.seriesSampleCount = evidence.seriesSampleCount
        self.routePointCount = evidence.route.count
        self.eventCount = evidence.events.count
        self.evidenceData = (try? JSONEncoder().encode(evidence)) ?? Data()
        self.updatedAt = Date()
    }

    public func update(evidence: WorkoutEvidence, sourceSummary: String = "") {
        loadedAt = evidence.loadedAt
        self.sourceSummary = sourceSummary
        seriesSampleCount = evidence.seriesSampleCount
        routePointCount = evidence.route.count
        eventCount = evidence.events.count
        evidenceData = (try? JSONEncoder().encode(evidence)) ?? Data()
        updatedAt = Date()
    }

    public var evidence: WorkoutEvidence? {
        try? JSONDecoder().decode(WorkoutEvidence.self, from: evidenceData)
    }
}

@Model
public final class PersistedEvidenceEnrichmentState {
    @Attribute(.unique) public var workoutID: String
    public var statusRaw: String
    public var lastAttemptAt: Date?
    public var attemptCount: Int
    public var message: String?
    public var updatedAt: Date

    public init(
        workoutID: String,
        status: EvidenceEnrichmentStatus,
        lastAttemptAt: Date? = nil,
        attemptCount: Int = 0,
        message: String? = nil
    ) {
        self.workoutID = workoutID
        self.statusRaw = status.rawValue
        self.lastAttemptAt = lastAttemptAt
        self.attemptCount = attemptCount
        self.message = message
        self.updatedAt = Date()
    }

    public var status: EvidenceEnrichmentStatus {
        EvidenceEnrichmentStatus(rawValue: statusRaw) ?? .pending
    }

    public func markAttempt(status: EvidenceEnrichmentStatus, message: String?, at date: Date = Date()) {
        statusRaw = status.rawValue
        lastAttemptAt = date
        attemptCount += 1
        self.message = message
        updatedAt = Date()
    }
}

@Model
public final class PersistedDerivedWorkoutAnalysis {
    @Attribute(.unique) public var workoutID: String
    public var calculationVersion: String
    public var inputSignature: String
    public var analysisData: Data
    public var updatedAt: Date

    public init(analysis: DerivedWorkoutAnalysis) {
        workoutID = analysis.workoutID
        calculationVersion = analysis.calculationVersion
        inputSignature = Self.signature(for: analysis.inputSummary)
        analysisData = (try? JSONEncoder().encode(analysis)) ?? Data()
        updatedAt = Date()
    }

    public func update(analysis: DerivedWorkoutAnalysis) {
        calculationVersion = analysis.calculationVersion
        inputSignature = Self.signature(for: analysis.inputSummary)
        analysisData = (try? JSONEncoder().encode(analysis)) ?? Data()
        updatedAt = Date()
    }

    public var analysis: DerivedWorkoutAnalysis? {
        try? JSONDecoder().decode(DerivedWorkoutAnalysis.self, from: analysisData)
    }

    private static func signature(for input: DerivedAnalyticsInputSummary) -> String {
        let counts = input.seriesSampleCounts
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "|")
        let sums = input.seriesValueSums
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value)" }
            .joined(separator: "|")
        let firstSamples = input.seriesFirstSampleAt
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value.ISO8601Format())" }
            .joined(separator: "|")
        let lastSamples = input.seriesLastSampleAt
            .sorted { $0.key < $1.key }
            .map { "\($0.key)=\($0.value.ISO8601Format())" }
            .joined(separator: "|")
        return [
            input.workoutID,
            input.evidenceLoadedAt.ISO8601Format(),
            "route=\(input.routePointCount)",
            "routeSig=\(input.routeSignature)",
            "events=\(input.eventCount)",
            "eventSig=\(input.eventSignature)",
            "distance=\(input.distanceMeters ?? -1)",
            "duration=\(input.durationSeconds)",
            counts,
            sums,
            firstSamples,
            lastSamples
        ].joined(separator: "|")
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
