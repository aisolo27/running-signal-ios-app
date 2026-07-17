import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func personalBestEffortThreeKilometerBucketHasExpectedOrderLabelAndDistance() {
    let buckets = PersonalBestEffortBucket.allCases

    #expect(buckets.firstIndex(of: .oneMile)! < buckets.firstIndex(of: .threeKilometer)!)
    #expect(buckets.firstIndex(of: .threeKilometer)! < buckets.firstIndex(of: .twoMile)!)
    #expect(PersonalBestEffortBucket.threeKilometer.label == "3K")
    #expect(PersonalBestEffortBucket.threeKilometer.distanceMeters == 3_000)
}

@Test func personalBestEffortThreeKilometerBucketProducesVerifiedExactRecord() throws {
    let start = Date(timeIntervalSince1970: 1_000)
    var workout = CanonicalWorkout(
        id: "three-kilometer",
        sourceID: "three-kilometer",
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(300),
        environment: .outdoor,
        distanceMeters: 3_000,
        durationSeconds: 300,
        routeAvailable: true,
        seriesAvailable: true,
        inferredRunType: .race
    )
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: (1...30).map { index in
                    WorkoutEvidencePoint(
                        date: start.addingTimeInterval(Double(index) * 10),
                        value: 100
                    )
                }
            )
        ],
        route: [
            WorkoutRoutePoint(date: start, latitude: 25, longitude: -80),
            WorkoutRoutePoint(
                date: start.addingTimeInterval(300),
                latitude: 25.01,
                longitude: -80.01
            )
        ]
    )

    let record = try #require(
        PersonalBestEffortEngine.records(for: workout)
            .first { $0.bucket == .threeKilometer }
    )

    #expect(record.method == .exactSegment)
    #expect(record.confidence == .exact)
    #expect(record.distanceMeters == 3_000)
    #expect(record.durationSeconds == 300)
}
