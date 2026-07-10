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

public enum WorkoutCapabilityConfidence: String, Codable, Sendable {
    case strong
    case moderate
    case limited
}

public enum WorkoutCapabilityMetric: String, Codable, CaseIterable, Identifiable, Sendable {
    case route
    case distanceSeries
    case runningSpeed
    case heartRate
    case power
    case cadence
    case runningDynamics
    case elevation

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .route: "Route"
        case .distanceSeries: "Distance samples"
        case .runningSpeed: "Running speed"
        case .heartRate: "Heart rate"
        case .power: "Power"
        case .cadence: "Cadence"
        case .runningDynamics: "Running dynamics"
        case .elevation: "Elevation"
        }
    }
}

public struct WorkoutCapabilityProfile: Equatable, Sendable {
    public var environment: RunEnvironment
    public var environmentConfidence: WorkoutCapabilityConfidence
    public var environmentEvidence: [String]
    public var expectedMetrics: Set<WorkoutCapabilityMetric>
    public var availableMetrics: Set<WorkoutCapabilityMetric>
    public var missingExpectedMetrics: Set<WorkoutCapabilityMetric>
    public var expectedMissingReasons: [WorkoutCapabilityMetric: String]

    public var summary: String {
        switch environment {
        case .indoor:
            "Indoor run: route and GPS elevation are not expected."
        case .outdoor:
            missingExpectedMetrics.isEmpty
                ? "Outdoor run: expected route and running evidence are available."
                : "Outdoor run: some expected GPS or sample evidence is missing."
        case .unknown:
            "Run environment is unknown; route and elevation expectations stay limited."
        }
    }

    public static func make(for workout: CanonicalWorkout) -> WorkoutCapabilityProfile {
        let hasRoute = workout.routeAvailable || workout.routePointCount > 0
        let hasDistanceSeries = workout.distanceSampleCount > 0
        let hasSpeed = workout.runningSpeedSampleCount > 0
        let hasHeartRate = workout.heartRateSampleCount > 0 || workout.averageHeartRate != nil
        let hasPower = workout.runningPowerSampleCount > 0 || workout.averagePower != nil
        let hasCadence = workout.cadenceSampleCount > 0 || workout.stepCountSampleCount > 0 || workout.averageCadence != nil
        let hasDynamics = workout.strideLengthSampleCount > 0
            || workout.verticalOscillationSampleCount > 0
            || workout.groundContactTimeSampleCount > 0
        let hasElevation = (workout.elevationGainMeters ?? 0) > 0

        var available = Set<WorkoutCapabilityMetric>()
        if hasRoute { available.insert(.route) }
        if hasDistanceSeries { available.insert(.distanceSeries) }
        if hasSpeed { available.insert(.runningSpeed) }
        if hasHeartRate { available.insert(.heartRate) }
        if hasPower { available.insert(.power) }
        if hasCadence { available.insert(.cadence) }
        if hasDynamics { available.insert(.runningDynamics) }
        if hasElevation { available.insert(.elevation) }

        let expected: Set<WorkoutCapabilityMetric>
        switch workout.environment {
        case .indoor:
            expected = [.distanceSeries, .heartRate, .cadence]
        case .outdoor:
            expected = [.route, .distanceSeries, .runningSpeed, .heartRate, .elevation]
        case .unknown:
            expected = [.distanceSeries, .heartRate]
        }

        let missing = expected.subtracting(available)
        var reasons: [WorkoutCapabilityMetric: String] = [:]
        for metric in missing {
            reasons[metric] = missingReason(metric: metric, environment: workout.environment)
        }

        let confidence: WorkoutCapabilityConfidence
        switch workout.environment {
        case .indoor:
            confidence = hasRoute ? .moderate : .strong
        case .outdoor:
            confidence = hasRoute ? .strong : .moderate
        case .unknown:
            confidence = .limited
        }

        var evidence = ["Environment: \(workout.environment.label)"]
        evidence.append(hasRoute ? "Route evidence present" : "No route evidence")
        if workout.routePointCount > 0 {
            evidence.append("\(workout.routePointCount) route points")
        }
        if workout.distanceSampleCount > 0 {
            evidence.append("\(workout.distanceSampleCount) distance samples")
        }

        return WorkoutCapabilityProfile(
            environment: workout.environment,
            environmentConfidence: confidence,
            environmentEvidence: evidence,
            expectedMetrics: expected,
            availableMetrics: available,
            missingExpectedMetrics: missing,
            expectedMissingReasons: reasons
        )
    }

    private static func missingReason(metric: WorkoutCapabilityMetric, environment: RunEnvironment) -> String {
        switch (metric, environment) {
        case (.route, .indoor), (.elevation, .indoor):
            "Not expected for indoor/treadmill runs."
        case (.route, .outdoor):
            "Outdoor runs usually expose a HealthKit route when location permission and route data are available."
        case (.route, .unknown):
            "Run environment is unknown, so route expectations stay limited."
        case (.elevation, .outdoor):
            "Outdoor elevation needs route altitude coverage or HealthKit elevation metadata."
        case (.elevation, .unknown):
            "Run environment is unknown, so elevation expectations stay limited."
        case (.distanceSeries, _):
            "Detailed distance samples have not been loaded for this workout."
        case (.runningSpeed, _):
            "Running speed samples are unavailable for this workout."
        case (.heartRate, _):
            "Heart-rate samples are unavailable for this workout."
        case (.power, _):
            "Running power is optional and depends on device/OS support."
        case (.cadence, _):
            "Cadence needs cadence samples or usable step-count samples."
        case (.runningDynamics, _):
            "Running dynamics are optional and depend on device/OS support."
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

    public static let visibleCases: [RunType] = [
        .easy, .longRun, .interval, .threshold, .race, .unknown
    ]

    public var visibleCategory: RunType {
        switch self {
        case .easy, .recovery: .easy
        case .longRun: .longRun
        case .tempo, .threshold: .threshold
        case .interval: .interval
        case .race: .race
        case .progression, .hills, .unknown: .unknown
        }
    }

    var label: String {
        switch self {
        case .easy: "Easy"
        case .recovery: "Easy"
        case .longRun: "Long Run"
        case .tempo: "Threshold"
        case .threshold: "Threshold"
        case .interval: "Interval"
        case .race: "Race"
        case .progression: "Other"
        case .hills: "Other"
        case .unknown: "Other"
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
        case .authorized: "Data Available"
        case .denied: "Denied"
        case .partial: "Access Requested"
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

public struct HealthContextVerification: Equatable, Sendable {
    public var title: String
    public var status: ConfidenceLevel
    public var detail: String
    public var hasVO2Max: Bool
    public var hasRestingHeartRate: Bool

    public init(context: HealthContext) {
        hasVO2Max = context.vo2Max != nil
        hasRestingHeartRate = context.restingHeartRate != nil

        switch (hasVO2Max, hasRestingHeartRate) {
        case (true, true):
            title = "Health Context Verified"
            status = .moderate
            detail = "VO2 Max and Resting HR are available from read-only Apple Health context."
        case (true, false):
            title = "VO2 Max Available"
            status = .limited
            detail = "VO2 Max is available. Resting HR still needs a physical-iPhone Apple Health check or may simply be unavailable."
        case (false, true):
            title = "Resting HR Available"
            status = .limited
            detail = "Resting HR is available. VO2 Max still needs a physical-iPhone Apple Health check or may simply be unavailable."
        case (false, false):
            title = "Physical iPhone Check Needed"
            status = .unavailable
            detail = "VO2 Max and Resting HR are unavailable here. Verify on the physical iPhone after granting Apple Health read access."
        }
    }
}

public struct WholeRunHealthKitSummary: Equatable, Sendable {
    public var title: String
    public var status: ConfidenceLevel
    public var detail: String

    public static func make(
        workouts: [CanonicalWorkout],
        authorizationState: AuthorizationState,
        usesSampleData: Bool
    ) -> WholeRunHealthKitSummary {
        let completedCount = V1WorkoutFilters.completedRuns(from: workouts).count

        if usesSampleData {
            return WholeRunHealthKitSummary(
                title: "Sample Data",
                status: .limited,
                detail: "Placeholder runs keep the app usable, but they are not HealthKit proof and should not be compared with Apple Fitness."
            )
        }

        guard authorizationState == .authorized || authorizationState == .partial else {
            return WholeRunHealthKitSummary(
                title: "HealthKit Not Loaded",
                status: .unavailable,
                detail: "Grant read-only Apple Health access to load completed running workouts."
            )
        }

        if completedCount == 0 {
            return WholeRunHealthKitSummary(
                title: "No Completed Runs",
                status: .limited,
                detail: "HealthKit is reachable, but no completed running workouts are available for the current filters."
            )
        }

        return WholeRunHealthKitSummary(
            title: "Whole-Run Review Ready",
            status: .moderate,
            detail: "\(completedCount) completed runs can show distance, duration, pace, route, splits, and safe whole-run stats even when custom interval rows are blocked."
        )
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

    public var capabilityProfile: WorkoutCapabilityProfile {
        WorkoutCapabilityProfile.make(for: self)
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

    public init(
        workoutID: String,
        loadedAt: Date,
        sourceSummary: String,
        seriesSampleCount: Int,
        routePointCount: Int,
        eventCount: Int,
        evidenceData: Data
    ) {
        self.workoutID = workoutID
        self.loadedAt = loadedAt
        self.sourceSummary = sourceSummary
        self.seriesSampleCount = seriesSampleCount
        self.routePointCount = routePointCount
        self.eventCount = eventCount
        self.evidenceData = evidenceData
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

    public func update(
        loadedAt: Date,
        sourceSummary: String,
        seriesSampleCount: Int,
        routePointCount: Int,
        eventCount: Int,
        evidenceData: Data
    ) {
        self.loadedAt = loadedAt
        self.sourceSummary = sourceSummary
        self.seriesSampleCount = seriesSampleCount
        self.routePointCount = routePointCount
        self.eventCount = eventCount
        self.evidenceData = evidenceData
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

public enum EvidenceRefreshKind: String, Codable, CaseIterable, Sendable {
    case monthlyEvidenceRefresh
    case bestEffortBackfill
    case latestRunRefresh
}

public enum EvidenceRefreshScopeType: String, Codable, CaseIterable, Sendable {
    case month
    case workout
    case candidateSet
}

public enum EvidenceRefreshJobStatus: String, Codable, CaseIterable, Sendable {
    case queued
    case running
    case paused
    case completed
    case failed
    case blocked
}

public enum EvidenceRefreshJobItemStatus: String, Codable, CaseIterable, Sendable {
    case pending
    case running
    case success
    case failed
    case skipped
}

public enum HealthKitImportJobStatus: String, Codable, CaseIterable, Sendable {
    case queued
    case running
    case paused
    case completed
    case failed
    case blocked
}

@Model
public final class PersistedEvidenceRefreshJob {
    @Attribute(.unique) public var jobID: String
    public var dedupKey: String
    public var refreshKindRaw: String
    public var scopeTypeRaw: String
    public var scopeKey: String
    public var statusRaw: String
    public var priority: Int
    public var createdAt: Date
    public var startedAt: Date?
    public var updatedAt: Date
    public var completedAt: Date?
    public var attemptCount: Int
    public var lastError: String?
    public var totalCount: Int
    public var completedCount: Int
    public var failedCount: Int
    public var skippedCount: Int
    public var interruptionCount: Int
    public var lastInterruptedAt: Date?

    public init(
        jobID: String = UUID().uuidString,
        refreshKind: EvidenceRefreshKind,
        scopeType: EvidenceRefreshScopeType,
        scopeKey: String,
        status: EvidenceRefreshJobStatus = .queued,
        priority: Int = 0,
        createdAt: Date = Date(),
        totalCount: Int = 0
    ) {
        self.jobID = jobID
        self.refreshKindRaw = refreshKind.rawValue
        self.scopeTypeRaw = scopeType.rawValue
        self.scopeKey = scopeKey
        self.dedupKey = Self.makeDedupKey(refreshKind: refreshKind, scopeType: scopeType, scopeKey: scopeKey)
        self.statusRaw = status.rawValue
        self.priority = priority
        self.createdAt = createdAt
        self.startedAt = nil
        self.updatedAt = createdAt
        self.completedAt = nil
        self.attemptCount = 0
        self.lastError = nil
        self.totalCount = totalCount
        self.completedCount = 0
        self.failedCount = 0
        self.skippedCount = 0
        self.interruptionCount = 0
        self.lastInterruptedAt = nil
    }

    public var refreshKind: EvidenceRefreshKind {
        EvidenceRefreshKind(rawValue: refreshKindRaw) ?? .monthlyEvidenceRefresh
    }

    public var scopeType: EvidenceRefreshScopeType {
        EvidenceRefreshScopeType(rawValue: scopeTypeRaw) ?? .month
    }

    public var status: EvidenceRefreshJobStatus {
        EvidenceRefreshJobStatus(rawValue: statusRaw) ?? .queued
    }

    public func markRunning(at date: Date = Date()) {
        statusRaw = EvidenceRefreshJobStatus.running.rawValue
        startedAt = startedAt ?? date
        updatedAt = date
        completedAt = nil
        attemptCount += 1
        lastError = nil
    }

    public func markPaused(at date: Date = Date(), message: String? = nil) {
        statusRaw = EvidenceRefreshJobStatus.paused.rawValue
        updatedAt = date
        lastError = message
        if message == "Paused after app relaunch before completion." {
            interruptionCount += 1
            lastInterruptedAt = date
        }
    }

    public func updateCounts(completed: Int, failed: Int, skipped: Int, at date: Date = Date()) {
        completedCount = completed
        failedCount = failed
        skippedCount = skipped
        updatedAt = date
    }

    public func finish(status: EvidenceRefreshJobStatus, message: String? = nil, at date: Date = Date()) {
        statusRaw = status.rawValue
        completedAt = date
        updatedAt = date
        lastError = message
    }

    public static func makeDedupKey(
        refreshKind: EvidenceRefreshKind,
        scopeType: EvidenceRefreshScopeType,
        scopeKey: String
    ) -> String {
        "\(refreshKind.rawValue):\(scopeType.rawValue):\(scopeKey)"
    }
}

@Model
public final class PersistedEvidenceRefreshJobItem {
    @Attribute(.unique) public var itemID: String
    public var jobID: String
    public var workoutID: String
    public var statusRaw: String
    public var attemptCount: Int
    public var lastError: String?
    public var startedAt: Date?
    public var completedAt: Date?
    public var oldEvidencePreserved: Bool
    public var newEvidenceCommitted: Bool
    public var updatedAt: Date

    public init(
        jobID: String,
        workoutID: String,
        status: EvidenceRefreshJobItemStatus = .pending,
        createdAt: Date = Date()
    ) {
        self.jobID = jobID
        self.workoutID = workoutID
        self.itemID = Self.makeItemID(jobID: jobID, workoutID: workoutID)
        self.statusRaw = status.rawValue
        self.attemptCount = 0
        self.lastError = nil
        self.startedAt = nil
        self.completedAt = nil
        self.oldEvidencePreserved = false
        self.newEvidenceCommitted = false
        self.updatedAt = createdAt
    }

    public var status: EvidenceRefreshJobItemStatus {
        EvidenceRefreshJobItemStatus(rawValue: statusRaw) ?? .pending
    }

    public func markRunning(at date: Date = Date()) {
        statusRaw = EvidenceRefreshJobItemStatus.running.rawValue
        startedAt = date
        updatedAt = date
        completedAt = nil
        attemptCount += 1
        lastError = nil
    }

    public func finish(
        status: EvidenceRefreshJobItemStatus,
        message: String? = nil,
        oldEvidencePreserved: Bool,
        newEvidenceCommitted: Bool,
        at date: Date = Date()
    ) {
        statusRaw = status.rawValue
        completedAt = date
        updatedAt = date
        lastError = message
        self.oldEvidencePreserved = oldEvidencePreserved
        self.newEvidenceCommitted = newEvidenceCommitted
    }

    public static func makeItemID(jobID: String, workoutID: String) -> String {
        "\(jobID):\(workoutID)"
    }
}

@Model
public final class PersistedHealthKitImportJob {
    @Attribute(.unique) public var jobID: String
    public var statusRaw: String
    public var createdAt: Date
    public var startedAt: Date?
    public var updatedAt: Date
    public var completedAt: Date?
    public var importedCount: Int
    public var failedCount: Int
    public var skippedCount: Int
    public var currentWindowStart: Date?
    public var currentWindowEnd: Date?
    public var lastError: String?
    public var pauseReasonRaw: String?

    public init(
        jobID: String = "initial-healthkit-import",
        status: HealthKitImportJobStatus = .queued,
        createdAt: Date = Date()
    ) {
        self.jobID = jobID
        self.statusRaw = status.rawValue
        self.createdAt = createdAt
        self.startedAt = nil
        self.updatedAt = createdAt
        self.completedAt = nil
        self.importedCount = 0
        self.failedCount = 0
        self.skippedCount = 0
        self.currentWindowStart = nil
        self.currentWindowEnd = nil
        self.lastError = nil
        self.pauseReasonRaw = nil
    }

    public var status: HealthKitImportJobStatus {
        HealthKitImportJobStatus(rawValue: statusRaw) ?? .queued
    }

    public var pauseReason: IngestionPauseReason? {
        pauseReasonRaw.flatMap(IngestionPauseReason.init(rawValue:))
    }

    public func markRunning(windowStart: Date?, windowEnd: Date?, at date: Date = Date()) {
        statusRaw = HealthKitImportJobStatus.running.rawValue
        startedAt = startedAt ?? date
        updatedAt = date
        completedAt = nil
        currentWindowStart = windowStart
        currentWindowEnd = windowEnd
        lastError = nil
        pauseReasonRaw = nil
    }

    public func markProgress(imported: Int, windowStart: Date?, windowEnd: Date?, at date: Date = Date()) {
        importedCount += imported
        currentWindowStart = windowStart
        currentWindowEnd = windowEnd
        updatedAt = date
    }

    public func markPaused(reason: IngestionPauseReason, at date: Date = Date()) {
        statusRaw = HealthKitImportJobStatus.paused.rawValue
        updatedAt = date
        lastError = reason.message
        pauseReasonRaw = reason.rawValue
    }

    public func markFinished(status: HealthKitImportJobStatus, message: String? = nil, at date: Date = Date()) {
        statusRaw = status.rawValue
        completedAt = date
        updatedAt = date
        lastError = message
        pauseReasonRaw = nil
        if status == .completed {
            currentWindowStart = nil
            currentWindowEnd = nil
        }
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

    public init(analysis: DerivedWorkoutAnalysis, analysisData: Data) {
        workoutID = analysis.workoutID
        calculationVersion = analysis.calculationVersion
        inputSignature = Self.signature(for: analysis.inputSummary)
        self.analysisData = analysisData
        updatedAt = Date()
    }

    public func update(analysis: DerivedWorkoutAnalysis) {
        calculationVersion = analysis.calculationVersion
        inputSignature = Self.signature(for: analysis.inputSummary)
        analysisData = (try? JSONEncoder().encode(analysis)) ?? Data()
        updatedAt = Date()
    }

    public func update(analysis: DerivedWorkoutAnalysis, analysisData: Data) {
        calculationVersion = analysis.calculationVersion
        inputSignature = Self.signature(for: analysis.inputSummary)
        self.analysisData = analysisData
        updatedAt = Date()
    }

    public var analysis: DerivedWorkoutAnalysis? {
        try? JSONDecoder().decode(DerivedWorkoutAnalysis.self, from: analysisData)
    }

    public static func signature(for input: DerivedAnalyticsInputSummary) -> String {
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

@Model
public final class PersistedTrainingPeriodSummary {
    @Attribute(.unique) public var cacheKey: String
    public var periodRaw: String
    public var periodStart: Date
    public var calculationVersion: String
    public var inputSignature: String
    public var summaryData: Data
    public var updatedAt: Date

    public init(summary: CachedTrainingPeriodSummary) {
        cacheKey = summary.cacheKey
        periodRaw = summary.period.rawValue
        periodStart = summary.periodStart
        calculationVersion = summary.calculationVersion
        inputSignature = summary.inputSignature
        summaryData = (try? JSONEncoder().encode(summary)) ?? Data()
        updatedAt = summary.computedAt
    }

    public func update(summary: CachedTrainingPeriodSummary) {
        periodRaw = summary.period.rawValue
        periodStart = summary.periodStart
        calculationVersion = summary.calculationVersion
        inputSignature = summary.inputSignature
        summaryData = (try? JSONEncoder().encode(summary)) ?? Data()
        updatedAt = summary.computedAt
    }

    public var cachedSummary: CachedTrainingPeriodSummary? {
        try? JSONDecoder().decode(CachedTrainingPeriodSummary.self, from: summaryData)
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
