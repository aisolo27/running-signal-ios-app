import Foundation

public enum GoldenValidationStatus: String, Codable, Sendable {
    case pass
    case warning
    case fail
    case unavailable

    var label: String {
        switch self {
        case .pass: "Pass"
        case .warning: "Warning"
        case .fail: "Fail"
        case .unavailable: "Unavailable"
        }
    }
}

public struct GoldenAppleFitnessExpectedWorkout: Codable, Equatable, Identifiable, Sendable {
    public var workoutId: String
    public var date: String
    public var appleFitnessTitle: String?
    public var expectedDistanceKm: Double?
    public var expectedWorkoutDurationSeconds: Double?
    public var expectedElapsedTimeSeconds: Double?
    public var expectedAveragePaceSecPerKm: Double?
    public var expectedActiveCaloriesKcal: Double?
    public var expectedTotalCaloriesKcal: Double?
    public var expectedAverageHeartRateBpm: Double?
    public var expectedMaxHeartRateBpm: Double?
    public var expectedElevationGainMeters: Double?
    public var expectedAverageCadenceSpm: Double?
    public var expectedAveragePowerWatts: Double?
    public var expectedRouteAvailable: Bool?
    public var expectedSplitCount: Int?
    public var notes: String?

    public var id: String { workoutId }

    public init(
        workoutId: String,
        date: String,
        appleFitnessTitle: String? = nil,
        expectedDistanceKm: Double? = nil,
        expectedWorkoutDurationSeconds: Double? = nil,
        expectedElapsedTimeSeconds: Double? = nil,
        expectedAveragePaceSecPerKm: Double? = nil,
        expectedActiveCaloriesKcal: Double? = nil,
        expectedTotalCaloriesKcal: Double? = nil,
        expectedAverageHeartRateBpm: Double? = nil,
        expectedMaxHeartRateBpm: Double? = nil,
        expectedElevationGainMeters: Double? = nil,
        expectedAverageCadenceSpm: Double? = nil,
        expectedAveragePowerWatts: Double? = nil,
        expectedRouteAvailable: Bool? = nil,
        expectedSplitCount: Int? = nil,
        notes: String? = nil
    ) {
        self.workoutId = workoutId
        self.date = date
        self.appleFitnessTitle = appleFitnessTitle
        self.expectedDistanceKm = expectedDistanceKm
        self.expectedWorkoutDurationSeconds = expectedWorkoutDurationSeconds
        self.expectedElapsedTimeSeconds = expectedElapsedTimeSeconds
        self.expectedAveragePaceSecPerKm = expectedAveragePaceSecPerKm
        self.expectedActiveCaloriesKcal = expectedActiveCaloriesKcal
        self.expectedTotalCaloriesKcal = expectedTotalCaloriesKcal
        self.expectedAverageHeartRateBpm = expectedAverageHeartRateBpm
        self.expectedMaxHeartRateBpm = expectedMaxHeartRateBpm
        self.expectedElevationGainMeters = expectedElevationGainMeters
        self.expectedAverageCadenceSpm = expectedAverageCadenceSpm
        self.expectedAveragePowerWatts = expectedAveragePowerWatts
        self.expectedRouteAvailable = expectedRouteAvailable
        self.expectedSplitCount = expectedSplitCount
        self.notes = notes
    }
}

public struct GoldenAppleFitnessFieldResult: Identifiable, Equatable, Sendable {
    public var id: String { field }
    public var field: String
    public var appValue: String
    public var expectedValue: String
    public var status: GoldenValidationStatus
    public var detail: String

    public init(field: String, appValue: String, expectedValue: String, status: GoldenValidationStatus, detail: String) {
        self.field = field
        self.appValue = appValue
        self.expectedValue = expectedValue
        self.status = status
        self.detail = detail
    }
}

public struct GoldenAppleFitnessWorkoutResult: Identifiable, Equatable, Sendable {
    public var id: String { workout.id }
    public var workout: CanonicalWorkout
    public var expected: GoldenAppleFitnessExpectedWorkout?
    public var fieldResults: [GoldenAppleFitnessFieldResult]

    public var status: GoldenValidationStatus {
        if fieldResults.contains(where: { $0.status == .fail }) { return .fail }
        if fieldResults.contains(where: { $0.status == .warning }) { return .warning }
        if fieldResults.contains(where: { $0.status == .pass }) { return .pass }
        return .unavailable
    }

    public var needsManualValues: Bool {
        expected == nil || fieldResults.allSatisfy { $0.status == .unavailable }
    }
}

public struct GoldenAppleFitnessSummary: Equatable, Sendable {
    public var selectedCount: Int
    public var needsManualValuesCount: Int
    public var passCount: Int
    public var warningCount: Int
    public var failCount: Int
    public var unavailableCount: Int
}

public enum GoldenAppleFitnessValidation {
    public static let confidenceLabel = "High-confidence Apple Fitness parity validation"

    public static func selectedWorkouts(from workouts: [CanonicalWorkout], limit: Int = 12) -> [CanonicalWorkout] {
        let included = workouts
            .filter { !$0.isDuplicate }
            .sorted { $0.startDate > $1.startDate }
            .prefix(max(8, limit))

        return Array(included)
            .sorted {
                if $0.environment == .outdoor && $1.environment != .outdoor { return true }
                if $0.environment != .outdoor && $1.environment == .outdoor { return false }
                return $0.startDate > $1.startDate
            }
            .prefix(limit)
            .map { $0 }
            .sorted { $0.startDate > $1.startDate }
    }

    public static func fixtureTemplate(workouts: [CanonicalWorkout]) -> String {
        let expected = selectedWorkouts(from: workouts).map { workout in
            GoldenAppleFitnessExpectedWorkout(
                workoutId: workout.id,
                date: RunFormatters.date.string(from: workout.startDate),
                notes: "Fill this row from Apple Fitness for the same completed workout."
            )
        }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data = (try? encoder.encode(expected)) ?? Data("[]".utf8)
        return String(decoding: data, as: UTF8.self)
    }

    public static func csvTemplate(workouts: [CanonicalWorkout]) -> String {
        let header = [
            "workoutId",
            "date",
            "appleFitnessTitle",
            "expectedDistanceKm",
            "expectedWorkoutDurationSeconds",
            "expectedElapsedTimeSeconds",
            "expectedAveragePaceSecPerKm",
            "expectedActiveCaloriesKcal",
            "expectedTotalCaloriesKcal",
            "expectedAverageHeartRateBpm",
            "expectedMaxHeartRateBpm",
            "expectedElevationGainMeters",
            "expectedAverageCadenceSpm",
            "expectedAveragePowerWatts",
            "expectedRouteAvailable",
            "expectedSplitCount",
            "notes"
        ]
        let rows = selectedWorkouts(from: workouts).map { workout in
            [
                workout.id,
                RunFormatters.date.string(from: workout.startDate),
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "",
                "Fill this row from Apple Fitness for the same completed workout."
            ]
        }
        return ([header] + rows)
            .map { row in row.map(csvEscape).joined(separator: ",") }
            .joined(separator: "\n")
    }

    public static func checklistMarkdown(workouts: [CanonicalWorkout], generatedAt: Date = Date()) -> String {
        let rows = selectedWorkouts(from: workouts).map { workout in
            """
            ## \(RunFormatters.date.string(from: workout.startDate)) · \(RunFormatters.distance(workout.distanceMeters))
            - Workout ID: \(workout.id)
            - Source: \(workout.sourceName)\(workout.deviceName.map { " · \($0)" } ?? "")
            - Copy from Apple Fitness: distance, workout time, elapsed time, average pace, active calories, total calories, average heart rate, max heart rate if visible, elevation gain, cadence, power, route available yes/no, splits if validating splits.
            - App values now: distance \(RunFormatters.distance(workout.distanceMeters)), duration \(RunFormatters.duration(workout.durationSeconds)), elapsed \(RunFormatters.duration(workout.elapsedSeconds)), pace \(RunFormatters.pace(workout.paceSecondsPerKm)), active calories \(RunFormatters.calories(workout.activeEnergyKilocalories)), total calories \(RunFormatters.calories(workout.totalEnergyKilocalories)), cadence \(RunFormatters.number(workout.averageCadence, suffix: " spm")), power \(RunFormatters.number(workout.averagePower, suffix: " W")).
            - Notes:
            """
        }.joined(separator: "\n\n")

        return """
        # Golden Apple Fitness Validation Checklist

        Generated: \(RunFormatters.date.string(from: generatedAt))
        Confidence label: \(confidenceLabel)

        Apple Fitness is the visual/user-facing validation reference. HealthKit remains RunSignal's source data. Do not compare these rows against FIT files or the old web dashboard.

        \(rows.isEmpty ? "No non-duplicate workouts are available for validation." : rows)
        """
    }

    public static func results(
        workouts: [CanonicalWorkout],
        expected: [GoldenAppleFitnessExpectedWorkout] = []
    ) -> [GoldenAppleFitnessWorkoutResult] {
        let expectedByID = Dictionary(uniqueKeysWithValues: expected.map { ($0.workoutId, $0) })
        return selectedWorkouts(from: workouts).map { workout in
            let normalized = NormalizedRun.from(workout)
            let expected = expectedByID[workout.id]
            return GoldenAppleFitnessWorkoutResult(
                workout: workout,
                expected: expected,
                fieldResults: compare(normalized: normalized, expected: expected)
            )
        }
    }

    public static func summary(results: [GoldenAppleFitnessWorkoutResult]) -> GoldenAppleFitnessSummary {
        GoldenAppleFitnessSummary(
            selectedCount: results.count,
            needsManualValuesCount: results.filter(\.needsManualValues).count,
            passCount: results.filter { $0.status == .pass }.count,
            warningCount: results.filter { $0.status == .warning }.count,
            failCount: results.filter { $0.status == .fail }.count,
            unavailableCount: results.filter { $0.status == .unavailable }.count
        )
    }

    private static func compare(
        normalized: NormalizedRun,
        expected: GoldenAppleFitnessExpectedWorkout?
    ) -> [GoldenAppleFitnessFieldResult] {
        guard let expected else {
            return [GoldenAppleFitnessFieldResult(
                field: "Manual Apple Fitness values",
                appValue: "Ready",
                expectedValue: "Missing",
                status: .unavailable,
                detail: "Fill the generated fixture from Apple Fitness before parity can be scored."
            )]
        }

        return [
            compareNumber("Distance", app: normalized.distanceMeters, expected: expected.expectedDistanceKm.map { $0 * 1_000 }, tolerance: distanceTolerance(expectedMeters: expected.expectedDistanceKm.map { $0 * 1_000 })),
            compareNumber("Workout duration", app: normalized.durationSeconds, expected: expected.expectedWorkoutDurationSeconds, tolerance: 2),
            compareNumber("Elapsed time", app: normalized.elapsedSeconds, expected: expected.expectedElapsedTimeSeconds, tolerance: 2),
            compareNumber("Average pace", app: normalized.averagePaceSecondsPerKm, expected: expected.expectedAveragePaceSecPerKm, tolerance: 3),
            comparePercent("Active calories", app: normalized.activeEnergyKcal, expected: expected.expectedActiveCaloriesKcal, percent: 0.03),
            comparePercent("Total calories", app: normalized.totalEnergyKcal, expected: expected.expectedTotalCaloriesKcal, percent: 0.03),
            compareNumber("Average HR", app: normalized.averageHeartRateBpm, expected: expected.expectedAverageHeartRateBpm, tolerance: 2),
            compareNumber("Max HR", app: normalized.maxHeartRateBpm, expected: expected.expectedMaxHeartRateBpm, tolerance: 2),
            compareNumber("Elevation gain", app: normalized.elevationGainMeters, expected: expected.expectedElevationGainMeters, tolerance: elevationTolerance(expectedMeters: expected.expectedElevationGainMeters)),
            compareNumber("Cadence", app: normalized.averageCadenceSpm, expected: expected.expectedAverageCadenceSpm, tolerance: 2),
            compareNumber("Power", app: normalized.averagePowerWatts, expected: expected.expectedAveragePowerWatts, tolerance: powerTolerance(expectedWatts: expected.expectedAveragePowerWatts)),
            compareBool("Route available", app: !normalized.routePoints.isEmpty, expected: expected.expectedRouteAvailable)
        ]
    }

    private static func compareNumber(_ field: String, app: Double?, expected: Double?, tolerance: Double?) -> GoldenAppleFitnessFieldResult {
        guard let expected else {
            return GoldenAppleFitnessFieldResult(field: field, appValue: display(app), expectedValue: "Blank", status: .unavailable, detail: "Manual Apple Fitness value not entered.")
        }
        guard let app else {
            return GoldenAppleFitnessFieldResult(field: field, appValue: "Missing", expectedValue: display(expected), status: .unavailable, detail: "RunSignal has no HealthKit evidence for this field.")
        }
        let tolerance = tolerance ?? 0
        let delta = abs(app - expected)
        let status: GoldenValidationStatus = delta <= tolerance ? .pass : (delta <= tolerance * 2 ? .warning : .fail)
        return GoldenAppleFitnessFieldResult(field: field, appValue: display(app), expectedValue: display(expected), status: status, detail: "Delta \(display(delta)); tolerance \(display(tolerance)).")
    }

    private static func comparePercent(_ field: String, app: Double?, expected: Double?, percent: Double) -> GoldenAppleFitnessFieldResult {
        let tolerance = expected.map { max(1, abs($0) * percent) }
        return compareNumber(field, app: app, expected: expected, tolerance: tolerance)
    }

    private static func compareBool(_ field: String, app: Bool, expected: Bool?) -> GoldenAppleFitnessFieldResult {
        guard let expected else {
            return GoldenAppleFitnessFieldResult(field: field, appValue: app ? "Yes" : "No", expectedValue: "Blank", status: .unavailable, detail: "Manual Apple Fitness value not entered.")
        }
        let status: GoldenValidationStatus = app == expected ? .pass : .warning
        return GoldenAppleFitnessFieldResult(field: field, appValue: app ? "Yes" : "No", expectedValue: expected ? "Yes" : "No", status: status, detail: app == expected ? "Route availability matches." : "Route availability differs; check route permissions and HealthKit route evidence.")
    }

    private static func distanceTolerance(expectedMeters: Double?) -> Double? {
        expectedMeters.map { max(20, $0 * 0.005) }
    }

    private static func elevationTolerance(expectedMeters: Double?) -> Double? {
        expectedMeters.map { max(5, abs($0) * 0.10) }
    }

    private static func powerTolerance(expectedWatts: Double?) -> Double? {
        expectedWatts.map { max(5, abs($0) * 0.03) }
    }

    private static func display(_ value: Double?) -> String {
        guard let value else { return "Missing" }
        return String(format: "%.1f", value)
    }

    private static func csvEscape(_ value: String) -> String {
        guard value.contains(",") || value.contains("\"") || value.contains("\n") else {
            return value
        }
        return "\"\(value.replacingOccurrences(of: "\"", with: "\"\""))\""
    }
}
