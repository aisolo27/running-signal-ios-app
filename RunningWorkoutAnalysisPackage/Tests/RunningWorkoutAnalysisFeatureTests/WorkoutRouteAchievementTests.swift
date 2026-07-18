import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func routeAchievementsInterpolateExactSegmentBoundariesAndMidpoint() throws {
    let start = Date(timeIntervalSince1970: 10_000)
    let route = stride(from: 0.0, through: 40.0, by: 10.0).map { offset in
        WorkoutRoutePoint(
            date: start.addingTimeInterval(offset),
            latitude: 25 + offset / 10_000,
            longitude: -80 + offset / 10_000
        )
    }
    let ranked = rankedRecord(
        bucket: .oneKilometer,
        workoutID: "current",
        rank: 1,
        start: start.addingTimeInterval(5),
        end: start.addingTimeInterval(35),
        duration: 30
    )

    let achievements = WorkoutRouteAchievementMapper.make(
        route: route,
        rankedRecords: [ranked],
        workoutID: "current"
    )
    let achievement = try #require(achievements.first)

    #expect(achievements.count == 1)
    #expect(achievement.title == "Fastest 1K · Lifetime")
    #expect(achievement.route.first?.date == start.addingTimeInterval(5))
    #expect(achievement.route.last?.date == start.addingTimeInterval(35))
    #expect(achievement.marker.date == start.addingTimeInterval(20))
    #expect(abs(achievement.marker.latitude - 25.002) < 0.000_001)
}

@Test func routeAchievementsRejectUntrustedOrUnmappableRecords() {
    let start = Date(timeIntervalSince1970: 20_000)
    let sparseRoute = [
        WorkoutRoutePoint(date: start, latitude: 25, longitude: -80),
        WorkoutRoutePoint(date: start.addingTimeInterval(120), latitude: 25.01, longitude: -79.99)
    ]
    let estimate = rankedRecord(
        bucket: .oneKilometer,
        workoutID: "current",
        rank: 1,
        start: start.addingTimeInterval(10),
        end: start.addingTimeInterval(50),
        duration: 40,
        method: .wholeRunEstimate,
        confidence: .estimated
    )
    let outsideRoute = rankedRecord(
        bucket: .fiveKilometer,
        workoutID: "current",
        rank: 2,
        start: start.addingTimeInterval(-10),
        end: start.addingTimeInterval(50),
        duration: 60
    )
    let wrongWorkout = rankedRecord(
        bucket: .oneMile,
        workoutID: "other",
        rank: 3,
        start: start,
        end: start.addingTimeInterval(120),
        duration: 120
    )
    let internallyGapped = rankedRecord(
        bucket: .tenKilometer,
        workoutID: "current",
        rank: 3,
        start: start,
        end: start.addingTimeInterval(120),
        duration: 120
    )

    let achievements = WorkoutRouteAchievementMapper.make(
        route: sparseRoute,
        rankedRecords: [estimate, outsideRoute, wrongWorkout, internallyGapped],
        workoutID: "current"
    )

    #expect(achievements.isEmpty)
}

@Test func routeAchievementsKeepOverlappingStandardDistancesInLifetimeRankOrder() {
    let start = Date(timeIntervalSince1970: 30_000)
    let route = stride(from: 0.0, through: 60.0, by: 10.0).map { offset in
        WorkoutRoutePoint(
            date: start.addingTimeInterval(offset),
            latitude: 25 + offset / 10_000,
            longitude: -80 + offset / 10_000
        )
    }
    let bronzeOneK = rankedRecord(
        bucket: .oneKilometer,
        workoutID: "current",
        rank: 3,
        start: start.addingTimeInterval(10),
        end: start.addingTimeInterval(40),
        duration: 30
    )
    let silverFiveK = rankedRecord(
        bucket: .fiveKilometer,
        workoutID: "current",
        rank: 2,
        start: start.addingTimeInterval(5),
        end: start.addingTimeInterval(55),
        duration: 50
    )

    let achievements = WorkoutRouteAchievementMapper.make(
        route: route,
        rankedRecords: [bronzeOneK, silverFiveK],
        workoutID: "current"
    )

    #expect(achievements.map(\.lifetimeRank) == [2, 3])
    #expect(achievements.map(\.bucket) == [.fiveKilometer, .oneKilometer])
    #expect(achievements.allSatisfy { !$0.route.isEmpty })
}

private func rankedRecord(
    bucket: PersonalBestEffortBucket,
    workoutID: String,
    rank: Int,
    start: Date,
    end: Date,
    duration: Double,
    method: PersonalBestEffortMethod = .exactSegment,
    confidence: PersonalBestEffortConfidence = .exact
) -> PersonalBestEffortRankedRecord {
    PersonalBestEffortRankedRecord(
        record: PersonalBestEffortRecord(
            bucket: bucket,
            workoutID: workoutID,
            date: start,
            distanceMeters: bucket.distanceMeters ?? 0,
            durationSeconds: duration,
            paceSecondsPerKm: bucket.distanceMeters.map { duration / ($0 / 1_000) },
            method: method,
            confidence: confidence,
            caveats: [],
            segmentStartDate: start,
            segmentEndDate: end,
            sourceWorkoutDistanceMeters: 10_000
        ),
        lifetimeRank: rank
    )
}
