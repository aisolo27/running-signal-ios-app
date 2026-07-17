import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func intervalLibraryClassifiesRepeatedComparablePrescriptionsAsPrimary() throws {
    let start = Date(timeIntervalSince1970: 100_000)
    let groups = IntervalLibraryBuilder.groups(from: [
        metricsWorkout(id: "repeat-a", date: start, workPaces: [250, 250]),
        metricsWorkout(id: "repeat-b", date: start.addingTimeInterval(86_400), workPaces: [245, 245])
    ])

    let group = try #require(groups.first)
    #expect(group.classification == .primaryComparison)
    #expect(IntervalLibrarySections(groups: groups).primaryComparisons == [group])
    #expect(IntervalLibrarySections(groups: groups).secondaryGroups.isEmpty)
}

@Test func intervalLibraryKeepsOneOffAndSustainedSingleWorkGroupsSecondary() throws {
    let start = Date(timeIntervalSince1970: 200_000)
    let oneOff = try #require(IntervalLibraryBuilder.groups(from: [
        metricsWorkout(id: "one-off", date: start, workPaces: [250, 250])
    ]).first)
    let sustainedSingleWork = try #require(IntervalLibraryBuilder.groups(from: [
        metricsWorkout(id: "single-a", date: start, workPaces: [250], includesRecovery: false),
        metricsWorkout(
            id: "single-b",
            date: start.addingTimeInterval(86_400),
            workPaces: [245],
            includesRecovery: false
        )
    ]).first)

    #expect(oneOff.classification == .secondary)
    #expect(sustainedSingleWork.classification == .secondary)
}

@Test func intervalLibraryGroupMetricsDistinguishWorkoutsRepsTargetsAndPaceChanges() throws {
    let start = Date(timeIntervalSince1970: 300_000)
    let group = try #require(IntervalLibraryBuilder.groups(from: [
        metricsWorkout(id: "oldest", date: start, workPaces: [250, 230]),
        metricsWorkout(id: "previous", date: start.addingTimeInterval(86_400), workPaces: [260, 270]),
        metricsWorkout(id: "latest", date: start.addingTimeInterval(172_800), workPaces: [240, 250])
    ]).first)

    #expect(group.totalWorkoutCount == 3)
    #expect(group.totalWorkRepCount == 6)
    #expect(group.targetableWorkRepCount == 6)
    #expect(group.onTargetWorkRepCount == 4)
    #expect(group.latestAverageWorkPaceSecondsPerKilometer == 245)
    #expect(group.bestAverageWorkPaceSecondsPerKilometer == 240)
    #expect(group.latestVersusPreviousAverageWorkPaceDeltaSecondsPerKilometer == -20)
}

@Test func intervalLibraryPaceChangeUsesTheTwoLatestWorkoutsAndRequiresBothPaces() throws {
    let start = Date(timeIntervalSince1970: 400_000)
    var group = try #require(IntervalLibraryBuilder.groups(from: [
        metricsWorkout(id: "latest", date: start.addingTimeInterval(86_400), workPaces: [240, 240]),
        metricsWorkout(id: "previous", date: start, workPaces: [250, 250])
    ]).first)

    group.trendPoints.reverse()
    #expect(group.latestAverageWorkPaceSecondsPerKilometer == 240)
    #expect(group.latestVersusPreviousAverageWorkPaceDeltaSecondsPerKilometer == -10)

    let previousIndex = try #require(group.trendPoints.firstIndex { $0.workoutID == "previous" })
    group.trendPoints[previousIndex].aggregatePaceSecondsPerKilometer = nil
    #expect(group.latestAverageWorkPaceSecondsPerKilometer == 240)
    #expect(group.latestVersusPreviousAverageWorkPaceDeltaSecondsPerKilometer == nil)
}

private func metricsWorkout(
    id: String,
    date: Date,
    workPaces: [Double],
    includesRecovery: Bool = true
) -> OfficialIntervalWorkout {
    var rows: [ReconstructedWorkoutInterval] = []
    var targets: [Int: [PlannedWorkoutTarget]] = [:]

    for (offset, pace) in workPaces.enumerated() {
        let workIndex = offset * 2 + 1
        rows.append(metricsInterval(
            index: workIndex,
            goalType: .distance,
            goalValue: 400,
            measuredDistance: 400,
            activeDuration: pace * 0.4
        ))
        targets[workIndex] = [metricsPaceTarget(fastest: 240, slowest: 260)]

        if includesRecovery {
            rows.append(metricsInterval(
                index: workIndex + 1,
                stepType: .recovery,
                goalType: .time,
                goalValue: 60,
                measuredDistance: 100,
                activeDuration: 60
            ))
        }
    }

    return OfficialIntervalWorkout(
        workoutID: id,
        startDate: date,
        rows: rows,
        plannedTargetsByRow: targets
    )
}

private func metricsPaceTarget(fastest: Double, slowest: Double) -> PlannedWorkoutTarget {
    PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 1_000 / slowest,
        upperBound: 1_000 / fastest,
        unit: "m/s",
        displayText: "pace target"
    )
}

private func metricsInterval(
    index: Int,
    stepType: DerivedIntervalLabel = .work,
    goalType: PlannedWorkoutGoalType,
    goalValue: Double?,
    measuredDistance: Double,
    activeDuration: Double
) -> ReconstructedWorkoutInterval {
    let start = Date(timeIntervalSince1970: 500_000 + Double(index) * 1_000)
    return ReconstructedWorkoutInterval(
        index: index,
        label: "\(stepType.displayName) \(index)",
        stepType: stepType,
        plannedGoalType: goalType,
        plannedGoalValue: goalValue,
        plannedGoalDisplayText: "goal",
        plannedTargetDisplayText: nil,
        actualStartDate: start,
        actualEndDate: start.addingTimeInterval(activeDuration),
        actualDurationSeconds: activeDuration,
        elapsedDurationSeconds: activeDuration,
        pauseOverlapSeconds: 0,
        activeDurationSeconds: activeDuration,
        durationDisplayRule: .elapsedRowWindow,
        actualDistanceMeters: measuredDistance,
        actualPaceSecondsPerKm: activeDuration / (measuredDistance / 1_000),
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
}
