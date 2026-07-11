import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func targetEvaluationSupportsDynamicDistanceGoals() throws {
    let target = paceTarget(fastest: 240, slowest: 260)
    for distance in [100.0, 400, 1_000, 2_000] {
        let row = productInterval(
            index: Int(distance),
            goalType: .distance,
            goalValue: distance,
            measuredDistance: distance,
            activeDuration: distance / 1_000 * 250
        )
        let evaluation = try #require(WorkTargetEvaluator.evaluate(interval: row, plannedTargets: [target]))
        #expect(evaluation.completionStatus == .completed)
        #expect(evaluation.result == .onTarget)
        #expect(evaluation.measurement.paceSecondsPerKilometer == 250)
        #expect(evaluation.measurement.basis == .completedPlannedDistance)
    }
}

@Test func targetEvaluationIncludesRangeBoundariesAndClassifiesFastSlow() throws {
    let target = paceTarget(fastest: 240, slowest: 260)
    let expected: [(Double, WorkTargetResult)] = [
        (240, .onTarget), (260, .onTarget), (239, .fast), (261, .slow)
    ]
    for (pace, result) in expected {
        let row = productInterval(
            goalType: .distance,
            goalValue: 1_000,
            measuredDistance: 1_000,
            activeDuration: pace
        )
        #expect(WorkTargetEvaluator.evaluate(interval: row, plannedTargets: [target])?.result == result)
    }
}

@Test func oneSidedPaceThresholdIsNotPresentedAsAnExactRange() throws {
    let threshold = PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 250,
        upperBound: 250,
        unit: "s/km",
        displayText: "pace threshold",
        semantics: .threshold
    )
    let row = productInterval(
        goalType: .distance,
        goalValue: 1_000,
        measuredDistance: 1_000,
        activeDuration: 250
    )

    let evaluation = try #require(WorkTargetEvaluator.evaluate(interval: row, plannedTargets: [threshold]))
    #expect(evaluation.result == .noTarget)
    #expect(evaluation.targetRange == nil)
    #expect(evaluation.exactTargetSecondsPerKilometer == 250)
    #expect(WorkTargetPresentation.exactTargetDeltaText(evaluation) == "Matches exact target")
}

@Test func exactPaceThresholdReportsDifferenceWithoutInventingTargetRange() throws {
    let threshold = PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 230,
        upperBound: 230,
        unit: "s/km",
        displayText: "pace 3:50 /km",
        semantics: .threshold
    )
    let row = productInterval(
        goalType: .distance,
        goalValue: 400,
        measuredDistance: 400,
        activeDuration: 97.2
    )

    let evaluation = try #require(WorkTargetEvaluator.evaluate(interval: row, plannedTargets: [threshold]))

    #expect(evaluation.targetRange == nil)
    #expect(evaluation.result == .noTarget)
    #expect(evaluation.exactTargetSecondsPerKilometer == 230)
    #expect(WorkTargetPresentation.exactTargetDeltaText(evaluation) == "13s/km slower")
}

@Test func targetEvaluationIsPauseAwareAndSeparatesShortenedRows() throws {
    let target = paceTarget(fastest: 240, slowest: 260)
    let paused = productInterval(
        goalType: .distance,
        goalValue: 400,
        measuredDistance: 405,
        activeDuration: 100,
        elapsedDuration: 130,
        pauseOverlap: 30
    )
    let pausedEvaluation = try #require(WorkTargetEvaluator.evaluate(interval: paused, plannedTargets: [target]))
    #expect(pausedEvaluation.measurement.paceSecondsPerKilometer == 250)
    #expect(pausedEvaluation.measurement.basis == .completedPlannedDistance)

    let shortened = productInterval(
        goalType: .distance,
        goalValue: 400,
        measuredDistance: 200,
        activeDuration: 50
    )
    let shortenedEvaluation = try #require(WorkTargetEvaluator.evaluate(interval: shortened, plannedTargets: [target]))
    #expect(shortenedEvaluation.completionStatus == .shortened)
    #expect(shortenedEvaluation.measurement.basis == .shortenedMeasured)
    #expect(shortenedEvaluation.measurement.paceSecondsPerKilometer == 250)
}

@Test func completedDistanceTargetUsesActivityRowTimerWhenGoalWindowDiffers() throws {
    let target = paceTarget(fastest: 230, slowest: 240)
    var interval = productInterval(
        goalType: .distance,
        goalValue: 400,
        measuredDistance: 410,
        activeDuration: 95
    )
    let start = interval.actualStartDate
    interval.plannedDistanceMetricWindow = PlannedDistanceMetricWindow(
        startDate: start,
        endDate: start.addingTimeInterval(92),
        distanceMeters: 400,
        averageHeartRateBpm: 161,
        maxHeartRateBpm: 168,
        averageCadence: 199,
        averagePower: 307
    )

    let evaluation = try #require(WorkTargetEvaluator.evaluate(interval: interval, plannedTargets: [target]))
    #expect(evaluation.completionStatus == .completed)
    #expect(evaluation.measurement.basis == .completedPlannedDistance)
    #expect(evaluation.measurement.paceSecondsPerKilometer == 237.5)
    #expect(evaluation.result == .onTarget)
}

@Test func archivedSkippedTwoKilometerWorkUsesMeasuredDistanceAndActiveTime() throws {
    let target = paceTarget(fastest: 360, slowest: 390)
    let skipped = productInterval(
        goalType: .distance,
        goalValue: 2_000,
        measuredDistance: 1_210,
        activeDuration: 460.5,
        elapsedDuration: 568.7,
        pauseOverlap: 108.2
    )

    let evaluation = try #require(WorkTargetEvaluator.evaluate(interval: skipped, plannedTargets: [target]))
    #expect(evaluation.completionStatus == .shortened)
    #expect(evaluation.measurement.basis == .shortenedMeasured)
    #expect(abs((evaluation.measurement.paceSecondsPerKilometer ?? 0) - 380.58) < 0.1)
    #expect(evaluation.result == .onTarget)
}

@Test func shortenedOnTargetPresentationKeepsCompletionVisible() throws {
    let target = paceTarget(fastest: 360, slowest: 390)
    let skipped = productInterval(
        goalType: .distance,
        goalValue: 2_000,
        measuredDistance: 1_210,
        activeDuration: 460.5,
        elapsedDuration: 568.7,
        pauseOverlap: 108.2
    )
    let evaluation = try #require(WorkTargetEvaluator.evaluate(interval: skipped, plannedTargets: [target]))

    #expect(WorkTargetPresentation.badgeLabel(for: evaluation) == "On Target · Shortened")
    #expect(WorkTargetPresentation.summaryText([evaluation]) == "1 of 1 on target · 0 fast · 0 slow · 1 shortened")
}

@Test func intervalLibraryMergePrefersLoadedEvidenceForDuplicateWorkoutID() throws {
    let date = Date(timeIntervalSince1970: 10_000)
    let persisted = intervalWorkout(
        id: "duplicate-workout",
        date: date,
        workGoal: (.distance, 400),
        recoveryGoal: (.time, 60),
        repeats: 4
    )
    let loaded = intervalWorkout(
        id: "duplicate-workout",
        date: date.addingTimeInterval(1),
        workGoal: (.distance, 800),
        recoveryGoal: (.time, 90),
        repeats: 3
    )

    let merged = OfficialIntervalWorkoutMerger.merged(
        persisted: [persisted],
        loaded: [loaded]
    )

    #expect(merged.count == 1)
    #expect(merged[0] == loaded)
}

@Test func targetEvaluationUsesMeasuredBasisForTimeAndOpenGoals() throws {
    let target = paceTarget(fastest: 240, slowest: 260)
    let time = productInterval(
        goalType: .time,
        goalValue: 120,
        measuredDistance: 480,
        activeDuration: 120,
        elapsedDuration: 150,
        pauseOverlap: 30
    )
    let timeEvaluation = try #require(WorkTargetEvaluator.evaluate(interval: time, plannedTargets: [target]))
    #expect(timeEvaluation.completionStatus == .completed)
    #expect(timeEvaluation.measurement.basis == .measured)
    #expect(timeEvaluation.measurement.paceSecondsPerKilometer == 250)

    let open = productInterval(
        goalType: .open,
        measuredDistance: 800,
        activeDuration: 200
    )
    let openEvaluation = try #require(WorkTargetEvaluator.evaluate(interval: open, plannedTargets: [target]))
    #expect(openEvaluation.completionStatus == .openEnded)
    #expect(openEvaluation.measurement.basis == .measured)
    #expect(openEvaluation.measurement.paceSecondsPerKilometer == 250)
    #expect(WorkTargetEvaluator.evaluate(interval: open)?.result == .noTarget)
}

@Test func intervalLibraryGroupsAnyWorkGoalAndSeparatesRecoveryPrescriptions() {
    let date = Date(timeIntervalSince1970: 10_000)
    let workouts = [
        intervalWorkout(id: "400-60-a", date: date, workGoal: (.distance, 400), recoveryGoal: (.time, 60), repeats: 4),
        intervalWorkout(id: "400-60-b", date: date.addingTimeInterval(86_400), workGoal: (.distance, 400), recoveryGoal: (.time, 60), repeats: 4),
        intervalWorkout(id: "400-90", date: date, workGoal: (.distance, 400), recoveryGoal: (.time, 90), repeats: 4),
        intervalWorkout(id: "1000-60", date: date, workGoal: (.distance, 1_000), recoveryGoal: (.time, 60), repeats: 4),
        intervalWorkout(id: "time-60", date: date, workGoal: (.time, 180), recoveryGoal: (.time, 60), repeats: 4),
        intervalWorkout(id: "2000-60", date: date, workGoal: (.distance, 2_000), recoveryGoal: (.time, 60), repeats: 3)
    ]

    let groups = IntervalLibraryBuilder.groups(from: workouts)
    #expect(groups.count == 5)
    #expect(groups.first { $0.workouts.map(\.workoutID).contains("400-60-a") }?.workouts.count == 2)
    #expect(groups.first { $0.workouts.map(\.workoutID).contains("400-90") }?.signature.recoveryGoals.first?.value == 90)
    #expect(groups.first { $0.workouts.map(\.workoutID).contains("time-60") }?.signature.workGoals.first?.type == .time)
    #expect(groups.first { $0.workouts.map(\.workoutID).contains("2000-60") }?.signature.workCount == 3)
}

@Test func intervalLibraryExcludesNoPlanAndNoWorkRows() {
    let start = Date(timeIntervalSince1970: 20_000)
    var noPlan = productInterval(goalType: .distance, goalValue: 400, measuredDistance: 400, activeDuration: 100)
    noPlan.planSource = .unavailable
    let openOnly = productInterval(stepType: .open, goalType: .open, measuredDistance: 1_000, activeDuration: 300)
    let groups = IntervalLibraryBuilder.groups(from: [
        OfficialIntervalWorkout(workoutID: "no-plan", startDate: start, rows: [noPlan]),
        OfficialIntervalWorkout(workoutID: "open", startDate: start, rows: [openOnly])
    ])
    #expect(groups.isEmpty)
}

@Test func intervalTrendsUseAggregatePaceAndDurationWeightedMetrics() throws {
    let start = Date(timeIntervalSince1970: 30_000)
    let target = paceTarget(fastest: 240, slowest: 260)
    let first = productInterval(index: 1, goalType: .distance, goalValue: 400, measuredDistance: 400, activeDuration: 96, heartRate: 150, power: 300)
    let second = productInterval(index: 2, goalType: .distance, goalValue: 400, measuredDistance: 400, activeDuration: 104, heartRate: 170, power: 340)
    let shortened = productInterval(index: 3, goalType: .distance, goalValue: 400, measuredDistance: 200, activeDuration: 52, heartRate: 180, power: 360)
    let workout = OfficialIntervalWorkout(
        workoutID: "trend",
        startDate: start,
        rows: [first, second, shortened],
        plannedTargetsByRow: [1: [target], 2: [target], 3: [target]]
    )
    let point = IntervalLibraryBuilder.trendPoint(for: workout)

    #expect(point.workCount == 3)
    #expect(point.aggregatePaceSecondsPerKilometer == 252 / 1.0)
    #expect(point.onTargetCount == 3)
    #expect(point.shortenedCount == 1)
    #expect((point.fadePercent ?? 0) > 8)
    #expect((point.consistencyCoefficientOfVariationPercent ?? 0) > 3)
    #expect(abs((point.durationWeightedHeartRate ?? 0) - ((150 * 96 + 170 * 104 + 180 * 52) / 252)) < 0.001)
    #expect(abs((point.durationWeightedPower ?? 0) - ((300 * 96 + 340 * 104 + 360 * 52) / 252)) < 0.001)
}

@Test func runClassifierRequiresOfficialStructuredRowsForInterval() {
    let ordinary = productWorkout(id: "ordinary", distance: 5_000, duration: 1_500)
    let open = productInterval(stepType: .open, goalType: .open, measuredDistance: 5_000, activeDuration: 1_500)
    let work = productInterval(index: 1, goalType: .distance, goalValue: 400, measuredDistance: 400, activeDuration: 100)
    let recovery = productInterval(index: 2, stepType: .recovery, goalType: .time, goalValue: 60, measuredDistance: 100, activeDuration: 60)

    #expect(RunClassifier.inferRunType(for: ordinary, officialIntervalRows: []) == .unknown)
    #expect(RunClassifier.inferRunType(for: ordinary, officialIntervalRows: [open]) == .unknown)
    #expect(RunClassifier.inferRunType(for: ordinary, officialIntervalRows: [work, recovery]) == .interval)
}

@Test func distancePaceChartUsesIncrementalSampleContributions() throws {
    let start = Date(timeIntervalSince1970: 40_000)
    let evidence = WorkoutEvidence(
        workoutID: "distance-chart",
        series: [
            .distance: WorkoutMetricSeries(metric: .distance, unit: "m", points: [
                WorkoutEvidencePoint(
                    date: start.addingTimeInterval(10),
                    value: 40,
                    startDate: start,
                    endDate: start.addingTimeInterval(10)
                ),
                WorkoutEvidencePoint(
                    date: start.addingTimeInterval(20),
                    value: 40,
                    startDate: start.addingTimeInterval(10),
                    endDate: start.addingTimeInterval(20)
                )
            ])
        ]
    )
    let workout = productWorkout(id: "distance-chart", distance: 80, duration: 20, evidence: evidence)
    let series = WorkoutChartSeriesBuilder.series(metric: .pace, workout: workout)
    #expect(series.points.map(\.value) == [250, 250])
}

private func paceTarget(fastest: Double, slowest: Double) -> PlannedWorkoutTarget {
    PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 1_000 / slowest,
        upperBound: 1_000 / fastest,
        unit: "m/s",
        displayText: "pace target"
    )
}

private func intervalWorkout(
    id: String,
    date: Date,
    workGoal: (PlannedWorkoutGoalType, Double),
    recoveryGoal: (PlannedWorkoutGoalType, Double),
    repeats: Int
) -> OfficialIntervalWorkout {
    var rows: [ReconstructedWorkoutInterval] = []
    var targets: [Int: [PlannedWorkoutTarget]] = [:]
    for repeatIndex in 0..<repeats {
        let workIndex = repeatIndex * 2 + 1
        rows.append(productInterval(
            index: workIndex,
            goalType: workGoal.0,
            goalValue: workGoal.1,
            measuredDistance: workGoal.0 == .distance ? workGoal.1 : 720,
            activeDuration: workGoal.0 == .time ? workGoal.1 : workGoal.1 / 4
        ))
        targets[workIndex] = [paceTarget(fastest: 240, slowest: 260)]
        rows.append(productInterval(
            index: workIndex + 1,
            stepType: .recovery,
            goalType: recoveryGoal.0,
            goalValue: recoveryGoal.1,
            measuredDistance: 100,
            activeDuration: recoveryGoal.1
        ))
    }
    return OfficialIntervalWorkout(workoutID: id, startDate: date, rows: rows, plannedTargetsByRow: targets)
}

private func productInterval(
    index: Int = 1,
    stepType: DerivedIntervalLabel = .work,
    goalType: PlannedWorkoutGoalType,
    goalValue: Double? = nil,
    measuredDistance: Double?,
    activeDuration: Double,
    elapsedDuration: Double? = nil,
    pauseOverlap: Double = 0,
    heartRate: Double? = nil,
    power: Double? = nil
) -> ReconstructedWorkoutInterval {
    let start = Date(timeIntervalSince1970: 50_000 + Double(index) * 1_000)
    let elapsed = elapsedDuration ?? activeDuration + pauseOverlap
    return ReconstructedWorkoutInterval(
        index: index,
        label: "\(stepType.displayName) \(index)",
        stepType: stepType,
        plannedGoalType: goalType,
        plannedGoalValue: goalValue,
        plannedGoalDisplayText: "goal",
        plannedTargetDisplayText: nil,
        actualStartDate: start,
        actualEndDate: start.addingTimeInterval(elapsed),
        actualDurationSeconds: pauseOverlap > 0 ? activeDuration : elapsed,
        elapsedDurationSeconds: elapsed,
        pauseOverlapSeconds: pauseOverlap,
        activeDurationSeconds: activeDuration,
        durationDisplayRule: pauseOverlap > 0 ? .activeTimer : .elapsedRowWindow,
        actualDistanceMeters: measuredDistance,
        actualPaceSecondsPerKm: measuredDistance.map { activeDuration / ($0 / 1_000) },
        averageHeartRateBpm: heartRate,
        maxHeartRateBpm: heartRate,
        averageCadence: nil,
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

private func productWorkout(
    id: String,
    distance: Double,
    duration: Double,
    evidence: WorkoutEvidence? = nil
) -> CanonicalWorkout {
    let start = Date(timeIntervalSince1970: 60_000)
    return CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "test",
        startDate: start,
        endDate: start.addingTimeInterval(duration),
        environment: .outdoor,
        distanceMeters: distance,
        durationSeconds: duration,
        evidence: evidence
    )
}
