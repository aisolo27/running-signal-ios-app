import Foundation

public enum MetricSourceKind: String, Codable, Sendable {
    case healthKitWorkoutSummary
    case workoutScopedHealthKitSample
    case broadHealthKitContext
    case derived
    case inferred
    case unavailable
}

public struct MetricProvenance: Codable, Equatable, Sendable {
    public var source: MetricSourceKind
    public var healthKitType: String
    public var calculationMethod: String
    public var confidence: ConfidenceLevel
    public var warning: String?

    public init(
        source: MetricSourceKind,
        healthKitType: String,
        calculationMethod: String,
        confidence: ConfidenceLevel,
        warning: String? = nil
    ) {
        self.source = source
        self.healthKitType = healthKitType
        self.calculationMethod = calculationMethod
        self.confidence = confidence
        self.warning = warning
    }
}

public struct NormalizedRunDataQuality: Codable, Equatable, Sendable {
    public var dataSource: String
    public var summaryConfidence: ConfidenceLevel
    public var warnings: [String]

    public init(dataSource: String, summaryConfidence: ConfidenceLevel, warnings: [String]) {
        self.dataSource = dataSource
        self.summaryConfidence = summaryConfidence
        self.warnings = warnings
    }
}

public struct NormalizedRun: Identifiable, Codable, Equatable, Sendable {
    public var id: String
    public var sourceName: String
    public var deviceName: String?
    public var startDate: Date
    public var endDate: Date
    public var durationSeconds: Double
    public var elapsedSeconds: Double
    public var activityType: String
    public var isIndoor: Bool?
    public var distanceMeters: Double?
    public var activeEnergyKcal: Double?
    public var totalEnergyKcal: Double?
    public var averagePaceSecondsPerKm: Double?
    public var averageHeartRateBpm: Double?
    public var maxHeartRateBpm: Double?
    public var averagePowerWatts: Double?
    public var averageSpeedMetersPerSecond: Double?
    public var averageCadenceSpm: Double?
    public var averageStrideLengthMeters: Double?
    public var averageVerticalOscillationMeters: Double?
    public var averageGroundContactTimeMilliseconds: Double?
    public var elevationGainMeters: Double?
    public var heartRateSeries: [WorkoutEvidencePoint]
    public var distanceSeries: [WorkoutEvidencePoint]
    public var speedSeries: [WorkoutEvidencePoint]
    public var powerSeries: [WorkoutEvidencePoint]
    public var cadenceSeries: [WorkoutEvidencePoint]
    public var strideLengthSeries: [WorkoutEvidencePoint]
    public var verticalOscillationSeries: [WorkoutEvidencePoint]
    public var groundContactTimeSeries: [WorkoutEvidencePoint]
    public var routePoints: [WorkoutRoutePoint]
    public var events: [WorkoutEvidenceEvent]
    public var dataQualityReport: NormalizedRunDataQuality
    public var calculationNotes: [String]
    public var metricProvenance: [String: MetricProvenance]

    public static func from(_ workout: CanonicalWorkout) -> NormalizedRun {
        let evidence = workout.evidence
        let warnings = warnings(for: workout)
        let summaryConfidence: ConfidenceLevel
        if workout.distanceMeters != nil && workout.durationSeconds > 0 && evidence?.seriesSampleCount ?? 0 > 0 {
            summaryConfidence = .moderate
        } else if workout.distanceMeters != nil && workout.durationSeconds > 0 {
            summaryConfidence = .limited
        } else {
            summaryConfidence = .blocked
        }

        return NormalizedRun(
            id: workout.id,
            sourceName: workout.sourceName,
            deviceName: workout.deviceName,
            startDate: workout.startDate,
            endDate: workout.endDate,
            durationSeconds: workout.durationSeconds,
            elapsedSeconds: workout.elapsedSeconds,
            activityType: "running",
            isIndoor: workout.environment == .unknown ? nil : workout.environment == .indoor,
            distanceMeters: workout.distanceMeters,
            activeEnergyKcal: workout.activeEnergyKilocalories,
            totalEnergyKcal: workout.totalEnergyKilocalories,
            averagePaceSecondsPerKm: workout.paceSecondsPerKm,
            averageHeartRateBpm: workout.averageHeartRate,
            maxHeartRateBpm: workout.maxHeartRate,
            averagePowerWatts: workout.averagePower,
            averageSpeedMetersPerSecond: evidence?.average(.runningSpeed),
            averageCadenceSpm: workout.fullStepCadence,
            averageStrideLengthMeters: workout.strideLengthMeters,
            averageVerticalOscillationMeters: workout.verticalOscillationCentimeters.map { $0 / 100 },
            averageGroundContactTimeMilliseconds: workout.groundContactMilliseconds,
            elevationGainMeters: workout.elevationGainMeters,
            heartRateSeries: evidence?.series[.heartRate]?.points ?? [],
            distanceSeries: evidence?.series[.distance]?.points ?? [],
            speedSeries: evidence?.series[.runningSpeed]?.points ?? [],
            powerSeries: evidence?.series[.runningPower]?.points ?? [],
            cadenceSeries: evidence?.series[.cadence]?.points ?? [],
            strideLengthSeries: evidence?.series[.strideLength]?.points ?? [],
            verticalOscillationSeries: evidence?.series[.verticalOscillation]?.points ?? [],
            groundContactTimeSeries: evidence?.series[.groundContactTime]?.points ?? [],
            routePoints: evidence?.route ?? [],
            events: evidence?.events ?? [],
            dataQualityReport: NormalizedRunDataQuality(
                dataSource: workout.dataSourceLabel,
                summaryConfidence: summaryConfidence,
                warnings: warnings
            ),
            calculationNotes: calculationNotes(for: workout),
            metricProvenance: provenance(for: workout)
        )
    }

    private static func warnings(for workout: CanonicalWorkout) -> [String] {
        var warnings: [String] = []
        if workout.distanceMeters == nil {
            warnings.append("Distance is missing; pace, splits, and best efforts are blocked.")
        }
        if workout.durationSeconds <= 0 {
            warnings.append("Workout duration is missing; pace and execution analysis are blocked.")
        }
        if workout.totalEnergyKilocalories == nil {
            warnings.append("Total calories are unavailable; active calories remain separate.")
        }
        if workout.averageCadence != nil && (workout.averageCadence ?? 0) < 120 {
            warnings.append("Cadence is below typical full-step SPM; verify source before comparing to Apple Fitness.")
        }
        return warnings
    }

    private static func calculationNotes(for workout: CanonicalWorkout) -> [String] {
        [
            "Pace is duration divided by distance; pace samples are not averaged.",
            "Duration uses HKWorkout.duration; elapsed time is endDate minus startDate.",
            workout.totalEnergyKilocalories == nil ? "Total calories are nil unless HealthKit provides enough evidence." : "Total calories are stored separately from active calories."
        ]
    }

    private static func provenance(for workout: CanonicalWorkout) -> [String: MetricProvenance] {
        [
            "distanceMeters": MetricProvenance(
                source: workout.distanceMeters == nil ? .unavailable : .healthKitWorkoutSummary,
                healthKitType: "HKWorkout.totalDistance / HKQuantityTypeIdentifierDistanceWalkingRunning",
                calculationMethod: "Prefer HKWorkout totalDistance, then workout statistics, then associated distance samples.",
                confidence: workout.distanceMeters == nil ? .blocked : .limited
            ),
            "durationSeconds": MetricProvenance(
                source: .healthKitWorkoutSummary,
                healthKitType: "HKWorkout.duration",
                calculationMethod: "Use HKWorkout.duration as workout time.",
                confidence: workout.durationSeconds > 0 ? .moderate : .blocked
            ),
            "elapsedSeconds": MetricProvenance(
                source: .derived,
                healthKitType: "HKWorkout.startDate/endDate",
                calculationMethod: "endDate minus startDate.",
                confidence: workout.elapsedSeconds > 0 ? .moderate : .blocked
            ),
            "averagePaceSecondsPerKm": MetricProvenance(
                source: workout.paceSecondsPerKm == nil ? .unavailable : .derived,
                healthKitType: "HKWorkout.duration + distance",
                calculationMethod: "Duration divided by distance.",
                confidence: workout.paceSecondsPerKm == nil ? .blocked : .limited
            ),
            "activeEnergyKcal": MetricProvenance(
                source: workout.activeEnergyKilocalories == nil ? .unavailable : .healthKitWorkoutSummary,
                healthKitType: "HKWorkout.totalEnergyBurned / HKQuantityTypeIdentifierActiveEnergyBurned",
                calculationMethod: "Prefer workout energy, then active-energy statistics/samples.",
                confidence: workout.activeEnergyKilocalories == nil ? .unavailable : .limited
            ),
            "totalEnergyKcal": MetricProvenance(
                source: workout.totalEnergyKilocalories == nil ? .unavailable : .derived,
                healthKitType: "HKQuantityTypeIdentifierActiveEnergyBurned + HKQuantityTypeIdentifierBasalEnergyBurned",
                calculationMethod: "Only set when enough HealthKit evidence exists; otherwise nil.",
                confidence: workout.totalEnergyKilocalories == nil ? .unavailable : .limited,
                warning: workout.totalEnergyKilocalories == nil ? "Total calories are not invented from active calories." : nil
            ),
            "averageCadenceSpm": MetricProvenance(
                source: workout.averageCadence == nil ? .unavailable : .workoutScopedHealthKitSample,
                healthKitType: "HKQuantityTypeIdentifierStepCount",
                calculationMethod: "Steps divided by sample duration in minutes; displayed as full steps per minute.",
                confidence: workout.averageCadence == nil ? .unavailable : .limited
            )
        ]
    }
}
