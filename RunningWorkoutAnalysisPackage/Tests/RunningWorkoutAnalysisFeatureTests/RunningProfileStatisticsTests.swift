import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func runningProfileStatisticsUseTrailingTwentyEightDaysAndDivideByFour() throws {
    let calendar = profileStatisticsCalendar
    let asOf = try profileStatisticsDate(2026, 7, 16, 12)
    let trailingBoundary = try profileStatisticsDate(2026, 6, 18, 12)
    let justBeforeBoundary = trailingBoundary.addingTimeInterval(-1)
    let workouts = [
        profileStatisticsWorkout(
            id: "boundary",
            start: trailingBoundary,
            duration: 2_400,
            distance: 8_000,
            elevation: 80
        ),
        profileStatisticsWorkout(
            id: "recent",
            start: try profileStatisticsDate(2026, 7, 10),
            duration: 1_800,
            distance: 6_000,
            elevation: 40
        ),
        profileStatisticsWorkout(
            id: "before-window",
            start: justBeforeBoundary,
            duration: 3_000,
            distance: 10_000,
            elevation: 100
        ),
        profileStatisticsWorkout(
            id: "duplicate",
            start: try profileStatisticsDate(2026, 7, 12),
            duration: 1_200,
            distance: 4_000,
            elevation: 20,
            isDuplicate: true
        ),
        profileStatisticsWorkout(
            id: "future",
            start: asOf.addingTimeInterval(1),
            duration: 900,
            distance: 3_000,
            elevation: 10
        )
    ]

    let statistics = RunningProfileStatistics.make(
        workouts: workouts,
        asOf: asOf,
        calendar: calendar
    )

    #expect(statistics.trailingFourWeekTotals.runCount == 2)
    #expect(statistics.trailingFourWeekTotals.durationSeconds == 4_200)
    #expect(statistics.trailingFourWeekTotals.distanceMeters == 14_000)
    #expect(statistics.trailingFourWeekTotals.elevationGainMeters == 120)
    #expect(statistics.averagePerWeek.runs == 0.5)
    #expect(statistics.averagePerWeek.durationSeconds == 1_050)
    #expect(statistics.averagePerWeek.distanceMeters == 3_500)
}

@Test func runningProfileStatisticsSeparateCalendarYearFromAllTime() throws {
    let calendar = profileStatisticsCalendar
    let asOf = try profileStatisticsDate(2026, 7, 16, 12)
    let workouts = [
        profileStatisticsWorkout(
            id: "prior-year",
            start: try profileStatisticsDate(2025, 12, 31, 23),
            duration: 3_600,
            distance: 12_000,
            elevation: 120
        ),
        profileStatisticsWorkout(
            id: "year-start",
            start: try profileStatisticsDate(2026, 1, 1),
            duration: 1_500,
            distance: 5_000,
            elevation: 30
        ),
        profileStatisticsWorkout(
            id: "year-current",
            start: try profileStatisticsDate(2026, 6, 1),
            duration: 2_100,
            distance: 7_000,
            elevation: nil
        ),
        profileStatisticsWorkout(
            id: "duplicate",
            start: try profileStatisticsDate(2025, 1, 1),
            duration: 900,
            distance: 3_000,
            elevation: 15,
            isDuplicate: true
        )
    ]

    let statistics = RunningProfileStatistics.make(
        workouts: workouts,
        asOf: asOf,
        calendar: calendar
    )

    #expect(statistics.yearToDate.runCount == 2)
    #expect(statistics.yearToDate.durationSeconds == 3_600)
    #expect(statistics.yearToDate.distanceMeters == 12_000)
    #expect(statistics.yearToDate.elevationGainMeters == 30)

    #expect(statistics.allTime.runCount == 3)
    #expect(statistics.allTime.durationSeconds == 7_200)
    #expect(statistics.allTime.distanceMeters == 24_000)
    #expect(statistics.allTime.elevationGainMeters == 150)
}

private var profileStatisticsCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar
}

private func profileStatisticsDate(
    _ year: Int,
    _ month: Int,
    _ day: Int,
    _ hour: Int = 0
) throws -> Date {
    try #require(
        profileStatisticsCalendar.date(
            from: DateComponents(
                timeZone: TimeZone(secondsFromGMT: 0),
                year: year,
                month: month,
                day: day,
                hour: hour
            )
        )
    )
}

private func profileStatisticsWorkout(
    id: String,
    start: Date,
    duration: TimeInterval,
    distance: Double?,
    elevation: Double?,
    isDuplicate: Bool = false
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(duration),
        environment: .outdoor,
        distanceMeters: distance,
        durationSeconds: duration,
        elevationGainMeters: elevation,
        inferredRunType: .easy,
        isDuplicate: isDuplicate
    )
}
