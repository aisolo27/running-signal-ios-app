import Foundation

public struct HealthKitAuditField: Identifiable, Equatable, Sendable {
    public var id: String { label }
    public var label: String
    public var value: String
    public var detail: String
    public var confidence: ConfidenceLevel

    public init(label: String, value: String, detail: String, confidence: ConfidenceLevel) {
        self.label = label
        self.value = value
        self.detail = detail
        self.confidence = confidence
    }
}

public struct HealthKitAuditRow: Identifiable, Equatable, Sendable {
    public var id: String { workout.id }
    public var workout: CanonicalWorkout
    public var fields: [HealthKitAuditField]
    public var caveats: [String]

    public init(workout: CanonicalWorkout, fields: [HealthKitAuditField], caveats: [String]) {
        self.workout = workout
        self.fields = fields
        self.caveats = caveats
    }
}

public enum HealthKitAudit {
    public static func rows(for workouts: [CanonicalWorkout]) -> [HealthKitAuditRow] {
        workouts
            .filter { !$0.isDuplicate }
            .sorted { $0.startDate > $1.startDate }
            .map(row)
    }

    public static func markdown(workouts: [CanonicalWorkout], generatedAt: Date = Date()) -> String {
        let rows = rows(for: workouts)
        let body = rows.map(markdownSection).joined(separator: "\n\n")

        return """
        # HealthKit Audit

        Generated: \(RunFormatters.date.string(from: generatedAt))
        Workouts audited: \(rows.count)

        \(body.isEmpty ? "No non-duplicate workouts are available for audit." : body)
        """
    }

    private static func row(for workout: CanonicalWorkout) -> HealthKitAuditRow {
        let fields = [
            summaryField(workout),
            routeField(workout),
            sampleField(
                label: "Heart rate samples",
                count: workout.heartRateSampleCount,
                summaryAvailable: workout.averageHeartRate != nil || workout.maxHeartRate != nil,
                summaryDetail: "avg \(RunFormatters.number(workout.averageHeartRate, suffix: " bpm")), max \(RunFormatters.number(workout.maxHeartRate, suffix: " bpm"))"
            ),
            speedDistanceField(workout),
            sampleField(
                label: "Active energy",
                count: workout.activeEnergySampleCount,
                summaryAvailable: workout.activeEnergyKilocalories != nil,
                summaryDetail: RunFormatters.calories(workout.activeEnergyKilocalories)
            ),
            sampleField(
                label: "Running power",
                count: workout.runningPowerSampleCount,
                summaryAvailable: workout.averagePower != nil,
                summaryDetail: RunFormatters.number(workout.averagePower, suffix: " W")
            ),
            cadenceStepsField(workout),
            sampleField(
                label: "Stride length",
                count: workout.strideLengthSampleCount,
                summaryAvailable: workout.strideLengthMeters != nil,
                summaryDetail: RunFormatters.number(workout.strideLengthMeters, suffix: " m", decimals: 2)
            ),
            sampleField(
                label: "Vertical oscillation",
                count: workout.verticalOscillationSampleCount,
                summaryAvailable: workout.verticalOscillationCentimeters != nil,
                summaryDetail: RunFormatters.number(workout.verticalOscillationCentimeters, suffix: " cm", decimals: 1)
            ),
            sampleField(
                label: "Ground contact time",
                count: workout.groundContactTimeSampleCount,
                summaryAvailable: workout.groundContactMilliseconds != nil,
                summaryDetail: RunFormatters.number(workout.groundContactMilliseconds, suffix: " ms")
            ),
            intervalsField(workout)
        ]

        return HealthKitAuditRow(workout: workout, fields: fields, caveats: caveats(for: workout))
    }

    private static func summaryField(_ workout: CanonicalWorkout) -> HealthKitAuditField {
        let found = workout.distanceMeters != nil && workout.durationSeconds > 0
        return HealthKitAuditField(
            label: "Workout summary",
            value: found ? "Found" : "Limited",
            detail: "\(RunFormatters.distance(workout.distanceMeters)) · \(RunFormatters.duration(workout.durationSeconds)) · \(workout.sourceName)",
            confidence: found ? .moderate : .limited
        )
    }

    private static func routeField(_ workout: CanonicalWorkout) -> HealthKitAuditField {
        if workout.routePointCount > 0 {
            return HealthKitAuditField(
                label: "Route points",
                value: "\(workout.routePointCount)",
                detail: "Associated HKWorkoutRoute locations found.",
                confidence: .moderate
            )
        }

        return HealthKitAuditField(
            label: "Route points",
            value: workout.routeAvailable ? "Route sample" : "Missing",
            detail: workout.routeAvailable ? "Route object was detected, but no location points were loaded." : "No associated route locations were found.",
            confidence: workout.routeAvailable ? .limited : .unavailable
        )
    }

    private static func speedDistanceField(_ workout: CanonicalWorkout) -> HealthKitAuditField {
        let count = workout.runningSpeedSampleCount + workout.distanceSampleCount
        if count > 0 {
            return HealthKitAuditField(
                label: "Speed/distance samples",
                value: "\(count)",
                detail: "Speed \(workout.runningSpeedSampleCount), distance \(workout.distanceSampleCount).",
                confidence: .moderate
            )
        }

        return HealthKitAuditField(
            label: "Speed/distance samples",
            value: workout.distanceMeters == nil ? "Missing" : "Summary only",
            detail: workout.distanceMeters == nil ? "No workout distance or associated speed/distance samples were found." : "Workout distance exists, but associated speed/distance samples were not found.",
            confidence: workout.distanceMeters == nil ? .unavailable : .limited
        )
    }

    private static func cadenceStepsField(_ workout: CanonicalWorkout) -> HealthKitAuditField {
        let count = workout.cadenceSampleCount + workout.stepCountSampleCount
        if count > 0 {
            return HealthKitAuditField(
                label: "Cadence/steps",
                value: "\(count)",
                detail: "Cadence \(workout.cadenceSampleCount), steps \(workout.stepCountSampleCount).",
                confidence: .moderate
            )
        }

        return HealthKitAuditField(
            label: "Cadence/steps",
            value: workout.averageCadence == nil ? "Missing" : "Summary only",
            detail: workout.averageCadence == nil ? "No cadence or step samples were found." : RunFormatters.number(workout.averageCadence, suffix: " spm"),
            confidence: workout.averageCadence == nil ? .unavailable : .limited
        )
    }

    private static func intervalsField(_ workout: CanonicalWorkout) -> HealthKitAuditField {
        HealthKitAuditField(
            label: "Events/intervals",
            value: workout.intervalCount > 0 ? "\(workout.intervalCount)" : "Missing",
            detail: workout.intervalLabelsSummary ?? "No lap or segment event labels were found.",
            confidence: workout.intervalCount > 0 ? .limited : .unavailable
        )
    }

    private static func sampleField(
        label: String,
        count: Int,
        summaryAvailable: Bool,
        summaryDetail: String
    ) -> HealthKitAuditField {
        if count > 0 {
            return HealthKitAuditField(
                label: label,
                value: "\(count)",
                detail: "Associated HealthKit samples found.",
                confidence: .moderate
            )
        }

        return HealthKitAuditField(
            label: label,
            value: summaryAvailable ? "Summary only" : "Missing",
            detail: summaryAvailable ? summaryDetail : "No associated samples or workout statistic were found.",
            confidence: summaryAvailable ? .limited : .unavailable
        )
    }

    private static func caveats(for workout: CanonicalWorkout) -> [String] {
        var caveats: [String] = []
        if workout.heartRateSampleCount == 0 {
            caveats.append("Heart-rate series is missing or summary-only, so drift and zone claims stay limited.")
        }
        if workout.runningSpeedSampleCount == 0 && workout.distanceSampleCount == 0 {
            caveats.append("Speed/distance samples are missing, so split-shape and pacing-shape claims stay limited.")
        }
        if workout.routePointCount == 0 {
            caveats.append("Route points are missing, so map, elevation, and GPS-quality checks stay limited.")
        }
        if workout.runningPowerSampleCount == 0 {
            caveats.append("Running power is optional and was not found as a sample series.")
        }
        if workout.strideLengthSampleCount == 0
            && workout.verticalOscillationSampleCount == 0
            && workout.groundContactTimeSampleCount == 0 {
            caveats.append("Running dynamics are missing, so form insights stay hidden.")
        }
        if workout.intervalCount == 0 {
            caveats.append("Workout lap or segment events were not found; interval labels may require real-device records or WorkoutKit metadata later.")
        }
        return caveats
    }

    private static func markdownSection(_ row: HealthKitAuditRow) -> String {
        let workout = row.workout
        let fields = row.fields
            .map { "- \($0.label): \($0.value) (\($0.detail))" }
            .joined(separator: "\n")
        let caveats = row.caveats.isEmpty ? "- None" : row.caveats.map { "- \($0)" }.joined(separator: "\n")

        return """
        ## \(RunFormatters.date.string(from: workout.startDate)) · \(workout.effectiveRunType.label)
        - Workout ID: \(workout.id)
        - Source: \(workout.sourceName)
        - Distance: \(RunFormatters.distance(workout.distanceMeters))
        - Duration: \(RunFormatters.duration(workout.durationSeconds))

        ### Fields Found
        \(fields)

        ### Caveats
        \(caveats)
        """
    }
}
