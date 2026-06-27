import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func personalBestEffortsFindFastestRollingSegmentAwayFromStart() throws {
    let start = Date(timeIntervalSince1970: 100)
    var workout = personalBestWorkout(id: "rolling", start: start, distanceMeters: 2_000, durationSeconds: 300, routeAvailable: true)
    workout.evidence = personalBestEvidence(
        workout: workout,
        distancePoints: [
            (30, 200),
            (60, 200),
            (90, 200),
            (105, 250),
            (120, 250),
            (150, 200),
            (180, 200),
            (210, 200),
            (240, 200),
            (270, 100)
        ],
        routeAvailable: true
    )

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .oneKilometer })

    #expect(record.method == .exactSegment)
    #expect(record.confidence == .exact)
    #expect(abs((record.durationSeconds ?? 0) - 105) < 0.001)
    #expect((record.segmentStartDate ?? start) > start)
}

@Test func personalBestEffortsEstimateSummaryOnlyRunsPlainly() throws {
    let start = Date(timeIntervalSince1970: 200)
    let workout = personalBestWorkout(id: "summary-only", start: start, distanceMeters: 5_000, durationSeconds: 1_500)

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .fiveKilometer })

    #expect(record.method == .wholeRunEstimate)
    #expect(record.confidence == .estimated)
    #expect(record.caveats.contains(.summaryOnlyEstimate))
    #expect(record.durationSeconds == 1_500)
}

@Test func personalBestEffortsKeepElapsedTimeAndCaveatPauseOverlap() throws {
    let start = Date(timeIntervalSince1970: 300)
    var workout = personalBestWorkout(id: "paused", start: start, distanceMeters: 1_200, durationSeconds: 240, routeAvailable: true)
    workout.evidence = personalBestEvidence(
        workout: workout,
        distancePoints: [
            (30, 250),
            (60, 250),
            (90, 250),
            (120, 250),
            (150, 200)
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(45), endDate: start.addingTimeInterval(45), type: "HKWorkoutEventTypePause", label: "Pause"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(75), endDate: start.addingTimeInterval(75), type: "HKWorkoutEventTypeResume", label: "Resume")
        ],
        routeAvailable: true
    )

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .oneKilometer })

    #expect(record.method == .exactSegment)
    #expect(record.confidence == .exact)
    #expect(record.durationSeconds == 120)
    #expect(record.caveats.contains(.pauseOverlap))
}

@Test func personalBestEffortsAllowIndoorExactWithDeviceDerivedCaveat() throws {
    let start = Date(timeIntervalSince1970: 400)
    var workout = personalBestWorkout(
        id: "treadmill",
        start: start,
        environment: .indoor,
        distanceMeters: 1_200,
        durationSeconds: 300
    )
    workout.evidence = personalBestEvidence(
        workout: workout,
        distancePoints: [
            (30, 250),
            (60, 250),
            (90, 250),
            (120, 250),
            (150, 200)
        ]
    )

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .oneKilometer })

    #expect(record.method == .exactSegment)
    #expect(record.confidence == .exact)
    #expect(record.caveats.contains(.indoorDeviceDerivedDistance))
    #expect(!record.caveats.contains(.routeMissing))
}

@Test func personalBestEffortsCaveatOutdoorDistanceSeriesWithoutRoute() throws {
    let start = Date(timeIntervalSince1970: 450)
    var workout = personalBestWorkout(
        id: "route-missing",
        start: start,
        distanceMeters: 1_200,
        durationSeconds: 300,
        routeAvailable: false
    )
    workout.evidence = personalBestEvidence(
        workout: workout,
        distancePoints: [
            (30, 250),
            (60, 250),
            (90, 250),
            (120, 250),
            (150, 200)
        ],
        routeAvailable: false
    )

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .oneKilometer })

    #expect(record.method == .exactSegment)
    #expect(record.caveats.contains(.routeMissing))
    #expect(!record.caveats.contains(.indoorDeviceDerivedDistance))
}

@Test func personalBestEffortsOmitBucketsThatWorkoutIsTooShortFor() {
    let start = Date(timeIntervalSince1970: 500)
    let workout = personalBestWorkout(id: "short", start: start, distanceMeters: 3_000, durationSeconds: 1_200)

    let records = PersonalBestEffortEngine.records(for: workout)

    #expect(records.contains { $0.bucket == .twoMile } == false)
    #expect(records.contains { $0.confidence == .unavailable } == false)
}

@Test func personalBestEffortsFallbackAfterSampleGapCarriesBothCaveats() throws {
    let start = Date(timeIntervalSince1970: 600)
    var workout = personalBestWorkout(id: "dropout", start: start, distanceMeters: 1_200, durationSeconds: 240, routeAvailable: true)
    workout.evidence = personalBestEvidence(
        workout: workout,
        distancePoints: [
            (10, 100),
            (20, 100),
            (80, 800),
            (90, 100),
            (100, 100)
        ],
        routeAvailable: true
    )

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .oneKilometer })

    #expect(record.method == .wholeRunEstimate)
    #expect(record.confidence == .estimated)
    #expect(record.caveats.contains(.distanceSeriesUnusable))
    #expect(record.caveats.contains(.sampleGap))
}

@Test func personalBestEffortsRequireShortBucketDensity() throws {
    let start = Date(timeIntervalSince1970: 700)
    var workout = personalBestWorkout(id: "short-density", start: start, distanceMeters: 500, durationSeconds: 100, routeAvailable: true)
    workout.evidence = personalBestEvidence(
        workout: workout,
        distancePoints: [
            (20, 200),
            (40, 200),
            (60, 100)
        ],
        routeAvailable: true
    )

    let record = try #require(PersonalBestEffortEngine.records(for: workout).first { $0.bucket == .fourHundredMeters })

    #expect(record.method == .wholeRunEstimate)
    #expect(record.caveats.contains(.shortBucketDensityLimited))
    #expect(record.caveats.contains(.distanceSeriesUnusable))
}

@Test func personalBestEffortsOfficialBestPrefersExactOverFasterEstimate() throws {
    let start = Date(timeIntervalSince1970: 800)
    var exact = personalBestWorkout(id: "exact", start: start, distanceMeters: 1_000, durationSeconds: 300, routeAvailable: true)
    exact.evidence = personalBestEvidence(
        workout: exact,
        distancePoints: [
            (30, 250),
            (60, 250),
            (90, 250),
            (120, 250)
        ],
        routeAvailable: true
    )
    let estimated = personalBestWorkout(
        id: "faster-estimate",
        start: start.addingTimeInterval(1_000),
        distanceMeters: 1_000,
        durationSeconds: 180
    )

    let summary = PersonalBestEffortEngine.summarize(
        workouts: [exact, estimated],
        now: start.addingTimeInterval(2_000)
    )
    let official = try #require(summary.allTime.first { $0.bucket == .oneKilometer })
    let fastestEstimated = try #require(summary.fastestEstimated.first { $0.bucket == .oneKilometer })

    #expect(official.workoutID == "exact")
    #expect(official.confidence == .exact)
    #expect(fastestEstimated.workoutID == "faster-estimate")
}

@Test func personalBestEffortsSeparateAllTimeAndNinetyDayRecent() throws {
    let now = Date(timeIntervalSince1970: 10_000_000)
    let oldStart = now.addingTimeInterval(-120 * 24 * 60 * 60)
    let recentStart = now.addingTimeInterval(-20 * 24 * 60 * 60)
    let old = personalBestWorkout(id: "old", start: oldStart, distanceMeters: 5_000, durationSeconds: 1_200)
    let recent = personalBestWorkout(id: "recent", start: recentStart, distanceMeters: 5_000, durationSeconds: 1_500)

    let summary = PersonalBestEffortEngine.summarize(workouts: [old, recent], now: now)
    let allTime = try #require(summary.allTime.first { $0.bucket == .fiveKilometer })
    let recentBest = try #require(summary.recent.first { $0.bucket == .fiveKilometer })

    #expect(summary.recentWindowDays == 90)
    #expect(allTime.workoutID == "old")
    #expect(recentBest.workoutID == "recent")
}

@Test func personalBestEffortsLongestRunUsesTotalDistanceAndCarriesSourceCaveat() throws {
    let start = Date(timeIntervalSince1970: 900)
    var indoor = personalBestWorkout(
        id: "indoor-long",
        start: start,
        environment: .indoor,
        distanceMeters: 12_000,
        durationSeconds: 4_200
    )
    indoor.evidence = personalBestEvidence(
        workout: indoor,
        distancePoints: [
            (60, 500),
            (120, 500)
        ]
    )
    let outdoor = personalBestWorkout(
        id: "outdoor-shorter",
        start: start.addingTimeInterval(1_000),
        distanceMeters: 10_000,
        durationSeconds: 3_600
    )

    let summary = PersonalBestEffortEngine.summarize(
        workouts: [indoor, outdoor],
        now: start.addingTimeInterval(2_000)
    )
    let longest = try #require(summary.allTime.first { $0.bucket == .longestRun })

    #expect(longest.workoutID == "indoor-long")
    #expect(longest.method == .totalDistance)
    #expect(longest.confidence == .exactTotal)
    #expect(longest.distanceMeters == 12_000)
    #expect(longest.caveats.contains(.indoorDeviceDerivedDistance))
}

private func personalBestWorkout(
    id: String,
    start: Date,
    environment: RunEnvironment = .outdoor,
    distanceMeters: Double?,
    durationSeconds: TimeInterval,
    routeAvailable: Bool = false,
    isDuplicate: Bool = false
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(durationSeconds),
        environment: environment,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds,
        routeAvailable: routeAvailable,
        inferredRunType: .easy,
        isDuplicate: isDuplicate
    )
}

private func personalBestEvidence(
    workout: CanonicalWorkout,
    distancePoints: [(TimeInterval, Double)],
    events: [WorkoutEvidenceEvent] = [],
    routeAvailable: Bool = false
) -> WorkoutEvidence {
    WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: workout.startDate,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: distancePoints.map { offset, distance in
                    WorkoutEvidencePoint(date: workout.startDate.addingTimeInterval(offset), value: distance)
                }
            )
        ],
        route: routeAvailable ? [
            WorkoutRoutePoint(date: workout.startDate, latitude: 25.0, longitude: -80.0),
            WorkoutRoutePoint(date: workout.endDate, latitude: 25.01, longitude: -80.01)
        ] : [],
        events: events
    )
}
