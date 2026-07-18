import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func lifetimeRankingIsExactOnlyDeduplicatedAndLimitedToBronze() throws {
    let start = Date(timeIntervalSince1970: 1_000)
    let records = [
        rankedTestRecord(id: "fourth", date: start, duration: 260),
        rankedTestRecord(id: "silver", date: start.addingTimeInterval(20), duration: 240),
        rankedTestRecord(id: "gold", date: start.addingTimeInterval(30), duration: 230),
        rankedTestRecord(id: "bronze", date: start.addingTimeInterval(10), duration: 250),
        rankedTestRecord(id: "bronze", date: start.addingTimeInterval(10), duration: 255),
        rankedTestRecord(
            id: "estimate",
            date: start,
            duration: 100,
            method: .wholeRunEstimate,
            confidence: .estimated
        ),
        rankedTestRecord(
            id: "longest",
            date: start,
            duration: 3_600,
            bucket: .longestRun,
            method: .totalDistance,
            confidence: .exactTotal,
            distanceMeters: 12_000
        )
    ]

    let summary = PersonalBestEffortEngine.summary(from: records)
    let kilometerRanks = summary.rankedAllTime.filter { $0.record.bucket == .oneKilometer }

    #expect(kilometerRanks.map { $0.record.workoutID } == ["gold", "silver", "bronze"])
    #expect(kilometerRanks.map(\.lifetimeRank) == [1, 2, 3])
    #expect(summary.allTime.first { $0.bucket == .oneKilometer }?.workoutID == "gold")
    #expect(summary.allTime.first { $0.bucket == .longestRun }?.workoutID == "longest")
    #expect(!summary.rankedAllTime.contains { $0.record.bucket == .longestRun })
    #expect(!summary.rankedAllTime.contains { $0.record.workoutID == "estimate" })
    #expect(!summary.rankedAllTime.contains { $0.record.workoutID == "fourth" })
}

@Test func lifetimeRankingBreaksTiesDeterministically() {
    let start = Date(timeIntervalSince1970: 2_000)
    let summary = PersonalBestEffortEngine.summary(from: [
        rankedTestRecord(id: "z-older", date: start, duration: 240),
        rankedTestRecord(id: "z-newer", date: start.addingTimeInterval(1), duration: 240),
        rankedTestRecord(id: "a-newer", date: start.addingTimeInterval(1), duration: 240)
    ])

    #expect(summary.rankedAllTime.map { $0.record.workoutID } == [
        "a-newer",
        "z-newer",
        "z-older"
    ])
}

@Test func rankedSummaryDecodesLegacyWinnerOnlyPayload() throws {
    let exact = rankedTestRecord(
        id: "legacy-exact",
        date: Date(timeIntervalSince1970: 3_000),
        duration: 245
    )
    let estimate = rankedTestRecord(
        id: "legacy-estimate",
        date: Date(timeIntervalSince1970: 3_100),
        duration: 200,
        method: .wholeRunEstimate,
        confidence: .estimated
    )
    let legacy = LegacyPersonalBestSummary(allTime: [exact, estimate])

    let decoded = try JSONDecoder().decode(
        PersonalBestEffortSummary.self,
        from: JSONEncoder().encode(legacy)
    )

    #expect(decoded.allTime == [exact, estimate])
    #expect(decoded.rankedAllTime == [
        PersonalBestEffortRankedRecord(record: exact, lifetimeRank: 1)
    ])
}

@Test func rankedBatchMergeRetainsGlobalTopThreeAcrossRelaunch() throws {
    let start = Date(timeIntervalSince1970: 4_000)
    let firstBatch = PersonalBestEffortEngine.summary(from: [
        rankedTestRecord(id: "a", date: start, duration: 300),
        rankedTestRecord(id: "b", date: start, duration: 310),
        rankedTestRecord(id: "c", date: start, duration: 320),
        rankedTestRecord(id: "discarded-first-batch", date: start, duration: 330)
    ])
    let relaunched = try JSONDecoder().decode(
        PersonalBestEffortSummary.self,
        from: JSONEncoder().encode(firstBatch)
    )
    let secondBatch = PersonalBestEffortEngine.summary(from: [
        rankedTestRecord(id: "new-gold", date: start, duration: 290),
        rankedTestRecord(id: "new-silver", date: start, duration: 305),
        rankedTestRecord(id: "discarded-second-1", date: start, duration: 340),
        rankedTestRecord(id: "discarded-second-2", date: start, duration: 350)
    ])

    let merged = PersonalBestEffortEngine.merging(
        cached: relaunched,
        computed: secondBatch
    )

    #expect(merged.rankedAllTime.map { $0.record.workoutID } == [
        "new-gold",
        "a",
        "new-silver"
    ])
}

@Test func currentWorkoutComputationReplacesItsStaleCachedRecord() {
    let start = Date(timeIntervalSince1970: 5_000)
    let cached = PersonalBestEffortEngine.summary(from: [
        rankedTestRecord(id: "same-workout", date: start, duration: 250),
        rankedTestRecord(id: "other", date: start, duration: 260)
    ])
    let current = PersonalBestEffortEngine.summary(from: [
        rankedTestRecord(id: "same-workout", date: start, duration: 245)
    ])

    let merged = PersonalBestEffortEngine.merging(
        cached: cached,
        computed: current,
        replacingWorkoutIDs: ["same-workout"]
    )

    #expect(merged.rankedAllTime.first?.record.durationSeconds == 245)
    #expect(merged.rankedAllTime.filter { $0.record.workoutID == "same-workout" }.count == 1)
}

private struct LegacyPersonalBestSummary: Encodable {
    var allTime: [PersonalBestEffortRecord]
}

private func rankedTestRecord(
    id: String,
    date: Date,
    duration: Double,
    bucket: PersonalBestEffortBucket = .oneKilometer,
    method: PersonalBestEffortMethod = .exactSegment,
    confidence: PersonalBestEffortConfidence = .exact,
    distanceMeters: Double = 1_000
) -> PersonalBestEffortRecord {
    PersonalBestEffortRecord(
        bucket: bucket,
        workoutID: id,
        date: date,
        distanceMeters: distanceMeters,
        durationSeconds: duration,
        paceSecondsPerKm: duration / (distanceMeters / 1_000),
        method: method,
        confidence: confidence,
        caveats: [],
        segmentStartDate: method == .exactSegment ? date : nil,
        segmentEndDate: method == .exactSegment ? date.addingTimeInterval(duration) : nil,
        sourceWorkoutDistanceMeters: distanceMeters
    )
}
