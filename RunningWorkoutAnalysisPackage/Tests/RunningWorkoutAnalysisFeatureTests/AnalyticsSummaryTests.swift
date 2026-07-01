import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func weeklyAnalyticsUsesMondayWeekBoundary() throws {
    let calendar = testCalendar
    let date = try makeDate(year: 2026, month: 7, day: 1, hour: 12)
    let weekStart = WeeklyAnalyticsSummary.weekStart(containing: date, calendar: calendar)
    let expected = try makeDate(year: 2026, month: 6, day: 29)

    #expect(weekStart == expected)
}

@Test func weeklyAnalyticsAggregatesRunsAndExcludesDuplicates() throws {
    let calendar = testCalendar
    let monday = try makeDate(year: 2026, month: 6, day: 29)
    let runs = [
        workout(id: "easy", start: monday.addingTimeInterval(8 * 3_600), distance: 7_000, duration: 2_800, type: .easy),
        workout(id: "interval", start: monday.addingTimeInterval(2 * 86_400), distance: 5_000, duration: 1_500, type: .interval),
        workout(id: "duplicate", start: monday.addingTimeInterval(3 * 86_400), distance: 12_000, duration: 4_800, type: .longRun, isDuplicate: true),
        workout(id: "older", start: monday.addingTimeInterval(-86_400), distance: 4_000, duration: 1_700, type: .recovery)
    ]

    let summary = WeeklyAnalyticsSummary.make(workouts: runs, weekStart: monday, calendar: calendar)

    #expect(summary.runCount == 2)
    #expect(summary.totalDistanceMeters == 12_000)
    #expect(summary.totalDurationSeconds == 4_300)
    #expect(summary.averagePaceSecondsPerKm == 4_300 / 12.0)
    #expect(summary.dailyDistances[0].distanceMeters == 7_000)
    #expect(summary.dailyDistances[2].distanceMeters == 5_000)
    #expect(summary.categoryTotals.first { $0.category == .easy }?.runCount == 1)
    #expect(summary.categoryTotals.first { $0.category == .interval }?.runCount == 1)
    #expect(summary.categoryTotals.first { $0.category == .longRun }?.runCount == 0)
}

@Test func weeklyCategoryMappingUsesRunSignalCategories() {
    #expect(WeeklyRunCategory.make(from: workout(id: "easy", type: .easy)) == .easy)
    #expect(WeeklyRunCategory.make(from: workout(id: "interval", type: .interval)) == .interval)
    #expect(WeeklyRunCategory.make(from: workout(id: "tempo", type: .tempo)) == .threshold)
    #expect(WeeklyRunCategory.make(from: workout(id: "threshold", type: .threshold)) == .threshold)
    #expect(WeeklyRunCategory.make(from: workout(id: "long", type: .longRun)) == .longRun)
    #expect(WeeklyRunCategory.make(from: workout(id: "recovery", type: .recovery)) == .warmupCooldown)
    #expect(WeeklyRunCategory.make(from: workout(id: "race", type: .race)) == .race)
    #expect(WeeklyRunCategory.make(from: workout(id: "hills", type: .hills)) == .other)
}

@Test func workoutChartSeriesBuildsCoreMetricsAndConvertsSpeedToPace() throws {
    let start = try makeDate(year: 2026, month: 6, day: 30)
    let run = workout(
        id: "chart",
        start: start,
        distance: 1_000,
        duration: 240,
        type: .interval,
        evidence: WorkoutEvidence(
            workoutID: "chart",
            series: [
                .runningSpeed: WorkoutMetricSeries(metric: .runningSpeed, unit: "m/s", points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(10), value: 4),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(20), value: 5)
                ]),
                .heartRate: WorkoutMetricSeries(metric: .heartRate, unit: "bpm", points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(10), value: 140),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(20), value: 150)
                ]),
                .runningPower: WorkoutMetricSeries(metric: .runningPower, unit: "W", points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(10), value: 280),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(20), value: 300)
                ]),
                .cadence: WorkoutMetricSeries(metric: .cadence, unit: "spm", points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(10), value: 170),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(20), value: 176)
                ])
            ]
        )
    )

    let series = WorkoutChartSeriesBuilder.coreSeries(for: run)

    #expect(series.map(\.metric) == [.pace, .heartRate, .power, .cadence])
    #expect(series.allSatisfy { $0.isRenderable })
    #expect(series.first { $0.metric == .pace }?.points.map(\.value) == [250, 200])
}

@Test func workoutChartSeriesDoesNotRenderMissingMetrics() {
    let run = workout(id: "missing", type: .easy)
    let series = WorkoutChartSeriesBuilder.coreSeries(for: run)

    #expect(series.map(\.metric) == [.pace, .heartRate, .power, .cadence])
    #expect(series.allSatisfy { !$0.isRenderable })
}

@Test func intervalDrilldownExcludesRawDebugCandidatesWhenOfficialRowsAreBlocked() throws {
    let start = try makeDate(year: 2026, month: 6, day: 30)
    let run = workout(id: "raw-segment", start: start, distance: 1_000, duration: 300, type: .interval)
    let evidence = WorkoutEvidence(
        workoutID: run.id,
        series: [
            .distance: WorkoutMetricSeries(metric: .distance, unit: "m", points: [
                WorkoutEvidencePoint(date: start, value: 0),
                WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 1_000)
            ])
        ],
        events: [
            WorkoutEvidenceEvent(
                startDate: start,
                endDate: start.addingTimeInterval(300),
                type: "HKWorkoutEventTypeSegment",
                label: "Work"
            )
        ]
    )

    #expect(!DerivedAnalyticsEngine.intervalCandidates(workout: run, evidence: evidence).isEmpty)
    #expect(IntervalDrillDownEligibility.officialRows(workout: run, evidence: evidence).isEmpty)
}

private var testCalendar: Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    calendar.firstWeekday = 2
    calendar.minimumDaysInFirstWeek = 4
    return calendar
}

private func makeDate(year: Int, month: Int, day: Int, hour: Int = 0) throws -> Date {
    let date = testCalendar.date(from: DateComponents(timeZone: TimeZone(secondsFromGMT: 0), year: year, month: month, day: day, hour: hour))
    return try #require(date)
}

private func workout(
    id: String,
    start: Date = Date(timeIntervalSince1970: 1_798_000_000),
    distance: Double = 5_000,
    duration: Double = 1_800,
    type: RunType,
    isDuplicate: Bool = false,
    evidence: WorkoutEvidence? = nil
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
        seriesAvailable: evidence != nil,
        seriesSampleCount: evidence?.series.values.map(\.sampleCount).reduce(0, +) ?? 0,
        inferredRunType: type,
        isDuplicate: isDuplicate,
        evidence: evidence
    )
}
