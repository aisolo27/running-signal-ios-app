import Foundation

public enum SampleData {
    public static let healthContext = HealthContext(
        vo2Max: 48.6,
        restingHeartRate: 48,
        averageHeartRate: 143,
        maxHeartRate: 188,
        activeEnergyKilocaloriesTotal: 248_500
    )

    public static let workouts: [CanonicalWorkout] = {
        let calendar = Calendar(identifier: .gregorian)
        let base = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1, hour: 7)) ?? Date()

        func daysAgo(_ days: Int, hour: Int = 7) -> Date {
            calendar.date(byAdding: .day, value: -days, to: calendar.date(bySettingHour: hour, minute: 0, second: 0, of: base) ?? base) ?? base
        }

        func workout(
            id: String,
            daysAgo days: Int,
            distanceKm: Double,
            seconds: Double,
            type: RunType,
            heartRate: Double?,
            cadence: Double? = nil,
            power: Double? = nil,
            environment: RunEnvironment = .outdoor,
            route: Bool = true,
            notes: String = ""
        ) -> CanonicalWorkout {
            let start = daysAgo(days)
            return CanonicalWorkout(
                id: id,
                sourceID: id,
                sourceName: "Sample Apple Watch",
                startDate: start,
                endDate: start.addingTimeInterval(seconds),
                environment: environment,
                distanceMeters: distanceKm * 1_000,
                durationSeconds: seconds,
                activeEnergyKilocalories: distanceKm * 62,
                elevationGainMeters: route ? max(2, distanceKm * 1.4) : nil,
                averageHeartRate: heartRate,
                maxHeartRate: heartRate.map { $0 + 18 },
                averageCadence: cadence,
                averagePower: power,
                strideLengthMeters: cadence == nil ? nil : 1.12,
                verticalOscillationCentimeters: cadence == nil ? nil : 8.6,
                groundContactMilliseconds: cadence == nil ? nil : 245,
                routeAvailable: route,
                seriesAvailable: route,
                routePointCount: route ? Int(distanceKm * 160) : 0,
                seriesSampleCount: route ? Int(seconds / 5) : 0,
                heartRateSampleCount: heartRate == nil ? 0 : Int(seconds / 5),
                runningSpeedSampleCount: route ? Int(seconds / 5) : 0,
                distanceSampleCount: route ? Int(seconds / 30) : 0,
                activeEnergySampleCount: Int(seconds / 60),
                runningPowerSampleCount: power == nil ? 0 : Int(seconds / 5),
                cadenceSampleCount: cadence == nil ? 0 : Int(seconds / 10),
                stepCountSampleCount: cadence == nil ? 0 : Int(seconds / 60),
                strideLengthSampleCount: cadence == nil ? 0 : Int(seconds / 30),
                verticalOscillationSampleCount: cadence == nil ? 0 : Int(seconds / 30),
                groundContactTimeSampleCount: cadence == nil ? 0 : Int(seconds / 30),
                intervalCount: type == .interval || type == .threshold ? 4 : 0,
                intervalLabelsSummary: type == .interval || type == .threshold ? "Warmup, Work, Cooldown, Open" : nil,
                inferredRunType: type,
                notes: notes
            )
        }

        return DuplicateDetector.markDuplicates([
            workout(id: "sample-001", daysAgo: 1, distanceKm: 7.2, seconds: 2_760, type: .easy, heartRate: 142, cadence: 82, power: 245),
            workout(id: "sample-002", daysAgo: 3, distanceKm: 5.1, seconds: 1_345, type: .threshold, heartRate: 168, cadence: 88, power: 310),
            workout(id: "sample-003", daysAgo: 5, distanceKm: 4.8, seconds: 1_980, type: .recovery, heartRate: 132, cadence: 80, power: 220),
            workout(id: "sample-004", daysAgo: 8, distanceKm: 12.4, seconds: 4_980, type: .longRun, heartRate: 148, cadence: 81, power: 238),
            workout(id: "sample-005", daysAgo: 10, distanceKm: 6.0, seconds: 2_220, type: .interval, heartRate: 162, cadence: 90, power: 330),
            workout(id: "sample-006", daysAgo: 13, distanceKm: 7.0, seconds: 2_870, type: .easy, heartRate: 144, cadence: nil, power: nil),
            workout(id: "sample-007", daysAgo: 16, distanceKm: 3.2, seconds: 1_520, type: .recovery, heartRate: 135, environment: .indoor, route: false),
            workout(id: "sample-008", daysAgo: 20, distanceKm: 5.0, seconds: 1_275, type: .race, heartRate: 176, cadence: 91, power: 342),
            workout(id: "sample-009", daysAgo: 23, distanceKm: 9.2, seconds: 3_560, type: .easy, heartRate: 146, cadence: 82, power: 242),
            workout(id: "sample-010", daysAgo: 27, distanceKm: 4.2, seconds: 1_610, type: .tempo, heartRate: 160, cadence: 86, power: 292)
        ])
    }()
}
