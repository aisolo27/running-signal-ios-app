import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func appReadinessSummaryKeepsSampleDataOutOfProofLane() {
    let summary = AppReadinessUXSummary.make(
        workouts: SampleData.workouts,
        authorizationState: .authorized,
        usesSampleData: true,
        isLoading: false,
        evidenceQueueSummary: .empty,
        bestEfforts: [],
        refreshJobs: []
    )

    #expect(summary.title == "Sample Data Mode")
    #expect(summary.confidence == .limited)
    #expect(summary.detail.contains("Load read-only HealthKit"))
    #expect(summary.signals.contains { $0.title == "Best Efforts" && $0.confidence == .limited })
}

@Test func bestEffortTrustSummaryDistinguishesExactFromEstimate() {
    let start = Date(timeIntervalSinceReferenceDate: 1_000)
    let exact = personalBestEffort(confidence: .exact, caveats: [])
    let estimated = personalBestEffort(
        confidence: .estimated,
        caveats: [.summaryOnlyEstimate, .distanceSeriesUnusable],
        start: start.addingTimeInterval(60)
    )

    let exactSummary = BestEffortUXSummary.make(effort: exact)
    let estimatedSummary = BestEffortUXSummary.make(effort: estimated)

    #expect(exactSummary.title == "Official exact")
    #expect(exactSummary.confidence == .strong)
    #expect(exactSummary.detail.contains("distance samples"))
    #expect(estimatedSummary.title == "Estimate")
    #expect(estimatedSummary.confidence == .limited)
    #expect(estimatedSummary.detail.contains("whole-run pace"))
    #expect(estimatedSummary.detail.contains("distance series unusable"))
}

@Test func workoutReviewSummaryLeadsWithOfficialStructuredRowsWhenAvailable() {
    let start = Date(timeIntervalSinceReferenceDate: 2_000)
    let run = workout(id: "official-workout", start: start, distance: 1_000, duration: 400, type: .interval)
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
                activeDuration: 100,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 300,
                pace: 333,
                heartRate: 156,
                maxHeartRate: 162,
                power: 300,
                cadence: 182
            )
        ]
    )

    let summary = WorkoutReviewUXSummary.make(workout: run, supportedIntervals: result, blockedReasons: [])

    #expect(summary.title == "Structured Workout Official")
    #expect(summary.confidence == .strong)
    #expect(summary.signals.contains { $0.title == "Intervals" && $0.value == "1" && $0.confidence == .strong })
}

@Test func workoutReviewSummaryKeepsSampleWorkoutOutOfHealthKitProofLane() throws {
    let sample = try #require(SampleData.workouts.first)

    let summary = WorkoutReviewUXSummary.make(
        workout: sample,
        supportedIntervals: nil,
        blockedReasons: ["Detailed HealthKit evidence is missing."]
    )

    #expect(summary.title == "Sample Workout Review")
    #expect(summary.confidence == .limited)
    #expect(summary.detail.contains("not HealthKit proof"))
    #expect(summary.signals.contains { $0.title == "Source" && $0.value == "Sample" && $0.confidence == .limited })
}

@Test func intervalExecutionSummaryHighlightsWorkRepsFadeAndPauses() {
    let start = Date(timeIntervalSinceReferenceDate: 3_000)
    let run = workout(id: "repeats", start: start, distance: 900, duration: 400, type: .interval)
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
                elapsedDuration: 105,
                activeDuration: 90,
                pauseOverlap: 15,
                displayRule: .activeTimer,
                distance: 300,
                pace: 300,
                heartRate: 152,
                maxHeartRate: 158,
                power: 305,
                cadence: 184
            ),
            reconstructedInterval(
                index: 2,
                label: "Recovery 1",
                stepType: .recovery,
                start: start.addingTimeInterval(105),
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
                index: 3,
                label: "Work 2",
                stepType: .work,
                start: start.addingTimeInterval(225),
                duration: 95,
                elapsedDuration: 95,
                activeDuration: 95,
                pauseOverlap: 0,
                displayRule: .elapsedRowWindow,
                distance: 300,
                pace: 315,
                heartRate: 158,
                maxHeartRate: 164,
                power: 300,
                cadence: 182
            )
        ]
    )
    let intervalSummary = IntervalAnalysisSummary(workout: run, result: result)

    let summary = IntervalExecutionUXSummary.make(summary: intervalSummary)

    #expect(summary.title == "2 work reps official")
    #expect(summary.signals.contains { $0.title == "Work" && $0.value == "2" })
    #expect(summary.signals.contains { $0.title == "Fade" && $0.value == "+15s/km" })
    #expect(summary.signals.contains { $0.title == "Pauses" && $0.value == "1" })
}

private func personalBestEffort(
    confidence: PersonalBestEffortConfidence,
    caveats: [PersonalBestEffortCaveat],
    start: Date = Date(timeIntervalSinceReferenceDate: 0)
) -> PersonalBestEffortRecord {
    PersonalBestEffortRecord(
        bucket: .oneKilometer,
        workoutID: "best-\(confidence.rawValue)",
        date: start,
        distanceMeters: 1_000,
        durationSeconds: 240,
        paceSecondsPerKm: 240,
        method: confidence == .estimated ? .wholeRunEstimate : .exactSegment,
        confidence: confidence,
        caveats: caveats,
        segmentStartDate: confidence == .estimated ? nil : start,
        segmentEndDate: confidence == .estimated ? nil : start.addingTimeInterval(240),
        sourceWorkoutDistanceMeters: 5_000
    )
}

private func workout(
    id: String,
    start: Date,
    distance: Double,
    duration: Double,
    type: RunType,
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
        evidence: evidence
    )
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
