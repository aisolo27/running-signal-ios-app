import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func intervalGoalTextPreservesAuthoredMilesWhilePaceFollowsPrimaryPolicy() throws {
    let start = Date(timeIntervalSince1970: 700_000)
    let interval = ReconstructedWorkoutInterval(
        index: 1,
        label: "Work 1",
        stepType: .work,
        plannedGoalType: .distance,
        plannedGoalValue: 1_609.344,
        plannedDistancePrescription: PlannedDistancePrescription(value: 1, unit: .miles),
        plannedGoalDisplayText: "1.61 km",
        plannedTargetDisplayText: nil,
        actualStartDate: start,
        actualEndDate: start.addingTimeInterval(400),
        actualDurationSeconds: 400,
        elapsedDurationSeconds: 400,
        pauseOverlapSeconds: 0,
        activeDurationSeconds: 400,
        durationDisplayRule: .elapsedRowWindow,
        actualDistanceMeters: 1_620,
        actualPaceSecondsPerKm: 400 / 1.62,
        averageHeartRateBpm: nil,
        maxHeartRateBpm: nil,
        averageCadence: nil,
        averagePower: nil,
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

    let kilometerItems = IntervalGoalMeasuredText.metricItems(for: interval, policy: .kilometersOnly)
    let mileItems = IntervalGoalMeasuredText.metricItems(for: interval, policy: .milesOnly)

    #expect(kilometerItems.map(\.value) == ["1 mi", "6:40", "4:09/km"])
    #expect(mileItems.map(\.value) == ["1 mi", "6:40", "6:40/mi"])
    #expect(try #require(WorkTargetEvaluator.evaluate(interval: interval)).measurement.paceSecondsPerKilometer == 400 / 1.609_344)
}
