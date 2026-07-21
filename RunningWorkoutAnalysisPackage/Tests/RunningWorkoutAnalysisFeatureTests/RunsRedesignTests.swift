import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func allRunsHistoryGroupsMonthsAndSortsRunsNewestFirst() {
    let calendar = Calendar(identifier: .gregorian)
    let january = calendar.date(from: DateComponents(year: 2026, month: 1, day: 12))!
    let julyEarly = calendar.date(from: DateComponents(year: 2026, month: 7, day: 2))!
    let julyLate = calendar.date(from: DateComponents(year: 2026, month: 7, day: 21))!

    let sections = RunHistoryMonthGrouping.sections(
        from: [
            redesignWorkout(id: "january", start: january),
            redesignWorkout(id: "july-early", start: julyEarly),
            redesignWorkout(id: "july-late", start: julyLate)
        ],
        calendar: calendar
    )

    #expect(sections.count == 2)
    #expect(sections[0].workouts.map(\.id) == ["july-late", "july-early"])
    #expect(sections[1].workouts.map(\.id) == ["january"])
}

@Test func allRunsSearchAndCategoryFiltersPreserveWrittenRunTaxonomy() {
    let calendar = Calendar(identifier: .gregorian)
    let start = calendar.date(from: DateComponents(year: 2026, month: 7, day: 21))!
    var interval = redesignWorkout(id: "interval", start: start, runType: .interval)
    interval.workoutPlanName = "Tuesday Intervals"
    let longRun = redesignWorkout(
        id: "long",
        start: start.addingTimeInterval(-86_400),
        runType: .longRun
    )

    let filtered = RunHistoryFiltering.filtered(
        [interval, longRun],
        selectedYear: 2026,
        selectedCategory: .interval,
        selectedEnvironment: .outdoor,
        searchText: "Tuesday",
        calendar: calendar
    )

    #expect(filtered.map(\.id) == ["interval"])
    #expect(WeeklyRunCategory.make(from: filtered[0]).label == "Interval Run")
}

@Test func workoutDetailHidesRouteOnlyWhenTheRunIsIndoor() {
    #expect(!WorkoutDetailPresentationPolicy.showsRouteSection(for: .indoor))
    #expect(WorkoutDetailPresentationPolicy.showsRouteSection(for: .outdoor))
    #expect(WorkoutDetailPresentationPolicy.showsRouteSection(for: .unknown))
}

@Test func runsLandingUsesFiveRecentCardsAndTheSameFourFactualMetrics() {
    let start = Date(timeIntervalSinceReferenceDate: 10_000)
    var workout = redesignWorkout(id: "summary", start: start)
    workout.averageHeartRate = 155

    let metrics = RunSummaryMetricPresentation.items(for: workout, policy: .kilometersOnly)

    #expect(RunLandingPresentation.recentRunLimit == 5)
    #expect(metrics.map(\.title) == ["Distance", "Time", "Avg pace", "Avg HR"])
    #expect(metrics.map(\.value) == ["5.00 km", "30:00", "6:00/km", "155 bpm"])
}

private func redesignWorkout(
    id: String,
    start: Date,
    runType: RunType = .easy
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "Apple Health",
        startDate: start,
        endDate: start.addingTimeInterval(1_800),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_800,
        inferredRunType: runType
    )
}
