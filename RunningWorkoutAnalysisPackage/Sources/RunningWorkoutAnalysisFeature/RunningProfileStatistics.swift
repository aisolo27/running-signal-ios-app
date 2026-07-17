import Foundation

public struct RunningProfileTotals: Equatable, Sendable {
    public var runCount: Int
    public var durationSeconds: TimeInterval
    public var distanceMeters: Double
    public var elevationGainMeters: Double

    public init(
        runCount: Int,
        durationSeconds: TimeInterval,
        distanceMeters: Double,
        elevationGainMeters: Double
    ) {
        self.runCount = runCount
        self.durationSeconds = durationSeconds
        self.distanceMeters = distanceMeters
        self.elevationGainMeters = elevationGainMeters
    }
}

public struct RunningProfileWeeklyAverages: Equatable, Sendable {
    public var runs: Double
    public var durationSeconds: TimeInterval
    public var distanceMeters: Double

    public init(
        runs: Double,
        durationSeconds: TimeInterval,
        distanceMeters: Double
    ) {
        self.runs = runs
        self.durationSeconds = durationSeconds
        self.distanceMeters = distanceMeters
    }
}

public struct RunningProfileStatistics: Equatable, Sendable {
    public var trailingFourWeekTotals: RunningProfileTotals
    public var averagePerWeek: RunningProfileWeeklyAverages
    public var yearToDate: RunningProfileTotals
    public var allTime: RunningProfileTotals

    public init(
        trailingFourWeekTotals: RunningProfileTotals,
        averagePerWeek: RunningProfileWeeklyAverages,
        yearToDate: RunningProfileTotals,
        allTime: RunningProfileTotals
    ) {
        self.trailingFourWeekTotals = trailingFourWeekTotals
        self.averagePerWeek = averagePerWeek
        self.yearToDate = yearToDate
        self.allTime = allTime
    }

    public static func make(
        workouts: [CanonicalWorkout],
        asOf date: Date = Date(),
        calendar: Calendar = .current
    ) -> RunningProfileStatistics {
        let completed = workouts.filter {
            !$0.isDuplicate && $0.durationSeconds > 0 && $0.startDate <= date
        }
        let trailingStart = calendar.date(byAdding: .day, value: -28, to: date)
            ?? date.addingTimeInterval(-28 * 86_400)
        let yearStart = calendar.dateInterval(of: .year, for: date)?.start
            ?? calendar.startOfDay(for: date)

        let trailingTotals = totals(
            for: completed.filter { $0.startDate >= trailingStart }
        )
        let yearToDateTotals = totals(
            for: completed.filter { $0.startDate >= yearStart }
        )
        let allTimeTotals = totals(for: completed)

        return RunningProfileStatistics(
            trailingFourWeekTotals: trailingTotals,
            averagePerWeek: RunningProfileWeeklyAverages(
                runs: Double(trailingTotals.runCount) / 4,
                durationSeconds: trailingTotals.durationSeconds / 4,
                distanceMeters: trailingTotals.distanceMeters / 4
            ),
            yearToDate: yearToDateTotals,
            allTime: allTimeTotals
        )
    }

    private static func totals(for workouts: [CanonicalWorkout]) -> RunningProfileTotals {
        RunningProfileTotals(
            runCount: workouts.count,
            durationSeconds: workouts.reduce(0) { $0 + $1.durationSeconds },
            distanceMeters: workouts.compactMap(\.distanceMeters).reduce(0, +),
            elevationGainMeters: workouts.compactMap(\.elevationGainMeters).reduce(0, +)
        )
    }
}
