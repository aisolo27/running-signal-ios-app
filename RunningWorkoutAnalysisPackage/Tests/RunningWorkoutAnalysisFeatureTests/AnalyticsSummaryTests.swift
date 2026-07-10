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
    #expect(WeeklyRunCategory.make(from: workout(id: "recovery", type: .recovery)) == .easy)
    #expect(WeeklyRunCategory.make(from: workout(id: "race", type: .race)) == .race)
    #expect(WeeklyRunCategory.make(from: workout(id: "hills", type: .hills)) == .other)
}

@Test func visibleRunTaxonomyIsExactlyTheApprovedSixAndFoldsLegacyValues() {
    #expect(RunType.visibleCases.map(\.label) == ["Easy", "Long Run", "Interval", "Threshold", "Race", "Other"])
    #expect(RunType.recovery.visibleCategory == .easy)
    #expect(RunType.tempo.visibleCategory == .threshold)
    #expect(RunType.progression.visibleCategory == .unknown)
    #expect(RunType.hills.visibleCategory == .unknown)
}

@Test func periodAnalyticsComparesCurrentWeekToSameElapsedDaysLastWeek() throws {
    let calendar = testCalendar
    let currentMonday = try makeDate(year: 2026, month: 6, day: 29)
    let now = try makeDate(year: 2026, month: 7, day: 2, hour: 12)
    let previousMonday = currentMonday.addingTimeInterval(-7 * 86_400)
    let runs = [
        workout(id: "current-monday", start: currentMonday.addingTimeInterval(8 * 3_600), distance: 5_000, duration: 1_500, type: .easy),
        workout(id: "current-thursday", start: currentMonday.addingTimeInterval(3 * 86_400), distance: 4_000, duration: 1_200, type: .easy),
        workout(id: "previous-monday", start: previousMonday.addingTimeInterval(8 * 3_600), distance: 3_000, duration: 900, type: .easy),
        workout(id: "previous-thursday", start: previousMonday.addingTimeInterval(3 * 86_400), distance: 4_000, duration: 1_200, type: .easy),
        workout(id: "previous-saturday", start: previousMonday.addingTimeInterval(5 * 86_400), distance: 20_000, duration: 7_200, type: .longRun)
    ]

    let summary = TrainingPeriodAnalyticsSummary.make(workouts: runs, period: .week, containing: now, now: now, calendar: calendar)

    #expect(summary.isPeriodToDate)
    #expect(summary.elapsedDayCount == 4)
    #expect(summary.totalDistanceMeters == 9_000)
    #expect(summary.comparison?.elapsedDayCount == 4)
    #expect(summary.comparison?.totalDistanceMeters == 7_000)
    #expect(summary.distanceDeltaMeters == 2_000)
}

@Test func periodAnalyticsComparesCurrentMonthToSameElapsedDaysLastMonth() throws {
    let calendar = testCalendar
    let now = try makeDate(year: 2026, month: 7, day: 10, hour: 12)
    let runs = [
        workout(id: "current-july-2", start: try makeDate(year: 2026, month: 7, day: 2, hour: 7), distance: 6_000, duration: 1_800, type: .easy),
        workout(id: "current-july-10", start: try makeDate(year: 2026, month: 7, day: 10, hour: 7), distance: 5_000, duration: 1_500, type: .easy),
        workout(id: "previous-june-5", start: try makeDate(year: 2026, month: 6, day: 5, hour: 7), distance: 8_000, duration: 2_400, type: .easy),
        workout(id: "previous-june-15", start: try makeDate(year: 2026, month: 6, day: 15, hour: 7), distance: 12_000, duration: 3_600, type: .longRun)
    ]

    let summary = TrainingPeriodAnalyticsSummary.make(workouts: runs, period: .month, containing: now, now: now, calendar: calendar)

    #expect(summary.isPeriodToDate)
    #expect(summary.elapsedDayCount == 10)
    #expect(summary.totalDistanceMeters == 11_000)
    #expect(summary.comparison?.totalDistanceMeters == 8_000)
    #expect(summary.distanceBuckets.count == 10)
}

@Test func periodAnalyticsComparesCurrentYearToSameElapsedDaysLastYear() throws {
    let calendar = testCalendar
    let now = try makeDate(year: 2026, month: 3, day: 1, hour: 12)
    let runs = [
        workout(id: "current-jan", start: try makeDate(year: 2026, month: 1, day: 5, hour: 7), distance: 10_000, duration: 3_000, type: .easy),
        workout(id: "current-feb", start: try makeDate(year: 2026, month: 2, day: 20, hour: 7), distance: 8_000, duration: 2_400, type: .easy),
        workout(id: "previous-feb", start: try makeDate(year: 2025, month: 2, day: 15, hour: 7), distance: 12_000, duration: 3_600, type: .easy),
        workout(id: "previous-april", start: try makeDate(year: 2025, month: 4, day: 1, hour: 7), distance: 30_000, duration: 10_800, type: .longRun)
    ]

    let summary = TrainingPeriodAnalyticsSummary.make(workouts: runs, period: .year, containing: now, now: now, calendar: calendar)

    #expect(summary.isPeriodToDate)
    #expect(summary.totalDistanceMeters == 18_000)
    #expect(summary.comparison?.totalDistanceMeters == 12_000)
    #expect(summary.distanceBuckets.map(\.label) == ["Jan", "Feb", "Mar"])
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

@Test func intervalAnalysisSummaryUsesOfficialRowsAndActiveTimerPace() throws {
    let start = try makeDate(year: 2026, month: 6, day: 30)
    let run = workout(id: "official-intervals", start: start, distance: 450, duration: 220, type: .interval)
    let result = WorkoutIntervalReconstructionResult(
        planSource: .workoutKit,
        windowSource: .healthKitActivityBoundaries,
        intervals: [
            reconstructedInterval(
                index: 1,
                label: "Work 1",
                stepType: .work,
                start: start,
                duration: 100,
                elapsedDuration: 100,
                activeDuration: 90,
                pauseOverlap: 10,
                displayRule: .activeTimer,
                distance: 300,
                pace: 100 / 0.3,
                heartRate: 152,
                maxHeartRate: 158,
                power: 310,
                cadence: 184
            ),
            reconstructedInterval(
                index: 2,
                label: "Recovery 1",
                stepType: .recovery,
                start: start.addingTimeInterval(100),
                duration: 120,
                elapsedDuration: 120,
                activeDuration: 120,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 150,
                pace: 800,
                heartRate: 134,
                maxHeartRate: 141,
                power: 150,
                cadence: 166
            )
        ]
    )

    let summary = IntervalAnalysisSummary(workout: run, result: result)
    let work = try #require(summary.rows.first { $0.index == 1 })

    #expect(summary.rows.map(\.label) == ["Work 1", "Recovery 1"])
    #expect(summary.aggregateRows.map(\.index) == [1])
    #expect(work.displayBasisLabel == "Active timer")
    #expect(work.value(for: .pace)?.displayValue == 300)
    #expect(work.value(for: .pace)?.chartValue == 12)
    #expect(summary.aggregateValue(for: .duration)?.displayValue == 90)
    #expect(summary.aggregateValue(for: .distance)?.displayValue == 300)
    #expect(summary.aggregateValue(for: .power)?.displayValue == 310)
    #expect(summary.workRepeatSummary?.repeatCount == 1)
    #expect(summary.workRepeatSummary?.totalActiveDurationSeconds == 90)
    #expect(summary.workRepeatSummary?.totalDistanceMeters == 300)
    #expect(summary.workRepeatSummary?.aggregatePaceSecondsPerKm == 300)
    #expect(summary.repeatGroups.isEmpty)
    #expect(summary.availableMetrics == IntervalAnalysisMetric.allCases)
}

@Test func intervalAnalysisSummaryGroupsOfficialWorkRecoveryRepeats() throws {
    let start = try makeDate(year: 2026, month: 6, day: 30)
    let run = workout(id: "repeat-intervals", start: start, distance: 1_400, duration: 720, type: .interval)
    let result = WorkoutIntervalReconstructionResult(
        planSource: .workoutKit,
        windowSource: .healthKitActivityBoundaries,
        intervals: [
            reconstructedInterval(
                index: 1,
                label: "Warmup",
                stepType: .warmup,
                start: start,
                duration: 120,
                elapsedDuration: 120,
                activeDuration: 120,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 500,
                pace: 360,
                heartRate: 128,
                maxHeartRate: 136,
                power: 220,
                cadence: 172
            ),
            reconstructedInterval(
                index: 2,
                label: "Work 1",
                stepType: .work,
                start: start.addingTimeInterval(120),
                duration: 90,
                elapsedDuration: 100,
                activeDuration: 90,
                pauseOverlap: 10,
                displayRule: .activeTimer,
                distance: 300,
                pace: 100 / 0.3,
                heartRate: 152,
                maxHeartRate: 158,
                power: 310,
                cadence: 184
            ),
            reconstructedInterval(
                index: 3,
                label: "Recovery 1",
                stepType: .recovery,
                start: start.addingTimeInterval(220),
                duration: 120,
                elapsedDuration: 120,
                activeDuration: 120,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 150,
                pace: 800,
                heartRate: 134,
                maxHeartRate: 141,
                power: 150,
                cadence: 166
            ),
            reconstructedInterval(
                index: 4,
                label: "Work 2",
                stepType: .work,
                start: start.addingTimeInterval(340),
                duration: 95,
                elapsedDuration: 95,
                activeDuration: 95,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 300,
                pace: 95 / 0.3,
                heartRate: 154,
                maxHeartRate: 162,
                power: 315,
                cadence: 186
            ),
            reconstructedInterval(
                index: 5,
                label: "Recovery 2",
                stepType: .recovery,
                start: start.addingTimeInterval(435),
                duration: 120,
                elapsedDuration: 120,
                activeDuration: 120,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 150,
                pace: 800,
                heartRate: 136,
                maxHeartRate: 143,
                power: 155,
                cadence: 168
            ),
            reconstructedInterval(
                index: 6,
                label: "Cooldown",
                stepType: .cooldown,
                start: start.addingTimeInterval(555),
                duration: 165,
                elapsedDuration: 165,
                activeDuration: 165,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 0,
                pace: 0,
                heartRate: 126,
                maxHeartRate: 132,
                power: 180,
                cadence: 170
            )
        ]
    )

    let summary = IntervalAnalysisSummary(workout: run, result: result)

    #expect(summary.workRepeatSummary?.repeatCount == 2)
    #expect(summary.workRepeatSummary?.totalActiveDurationSeconds == 185)
    #expect(summary.workRepeatSummary?.totalDistanceMeters == 600)
    #expect(summary.workRepeatSummary?.aggregatePaceSecondsPerKm == 185 / 0.6)
    #expect(summary.repeatGroups.map(\.repeatNumber) == [1, 2])
    #expect(summary.repeatGroups.map { $0.rows.map(\.index) } == [[2, 3], [4, 5]])
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

@Test func intervalAnalysisRowUsesPlannedDistancePaceAndGoalWindowMetrics() {
    let start = Date(timeIntervalSince1970: 1_000)
    var interval = reconstructedInterval(
        index: 1,
        label: "Work 1",
        stepType: .work,
        start: start,
        duration: 95,
        elapsedDuration: 95,
        activeDuration: 95,
        pauseOverlap: 0,
        displayRule: .elapsedRowWindow,
        distance: 410,
        pace: 95 / 0.410,
        heartRate: 150,
        maxHeartRate: 158,
        power: 280,
        cadence: 180
    )
    interval.plannedGoalValue = 400
    interval.plannedGoalDisplayText = "400 m"
    interval.plannedDistanceMetricWindow = PlannedDistanceMetricWindow(
        startDate: start,
        endDate: start.addingTimeInterval(92),
        distanceMeters: 400,
        averageHeartRateBpm: 161,
        maxHeartRateBpm: 168,
        averageCadence: 199,
        averagePower: 307
    )

    let row = IntervalAnalysisRow(interval: interval, workoutStart: start)

    #expect(row.distanceMeters == 400)
    #expect(row.displayDurationSeconds == 95)
    #expect(row.paceSecondsPerKm == 230)
    #expect(row.averageHeartRateBpm == 161)
    #expect(row.averageCadence == 199)
    #expect(row.averagePower == 307)
    #expect(row.endOffsetSeconds == 95)
}

private func reconstructedInterval(
    index: Int,
    label: String,
    stepType: DerivedIntervalLabel,
    start: Date,
    duration: Double,
    elapsedDuration: Double,
    activeDuration: Double,
    pauseOverlap: Double,
    displayRule: ReconstructedIntervalDurationDisplayRule,
    distance: Double,
    pace: Double,
    heartRate: Double,
    maxHeartRate: Double,
    power: Double,
    cadence: Double
) -> ReconstructedWorkoutInterval {
    ReconstructedWorkoutInterval(
        index: index,
        label: label,
        stepType: stepType,
        plannedGoalType: .distance,
        plannedGoalValue: distance,
        plannedGoalDisplayText: RunFormatters.compactDistance(distance),
        plannedTargetDisplayText: "Target",
        actualStartDate: start,
        actualEndDate: start.addingTimeInterval(duration),
        actualDurationSeconds: duration,
        elapsedDurationSeconds: elapsedDuration,
        pauseOverlapSeconds: pauseOverlap,
        activeDurationSeconds: activeDuration,
        durationDisplayRule: displayRule,
        actualDistanceMeters: distance,
        actualPaceSecondsPerKm: pace,
        averageHeartRateBpm: heartRate,
        maxHeartRateBpm: maxHeartRate,
        averageCadence: cadence,
        averagePower: power,
        planSource: .workoutKit,
        windowSource: .healthKitActivityBoundaries,
        boundaryStrategy: nil,
        boundaryAdjustmentSeconds: nil,
        boundaryOvershootMeters: nil,
        boundaryDiagnostics: nil,
        tailDiagnostics: nil,
        sourceNote: "test",
        confidence: .high
    )
}
