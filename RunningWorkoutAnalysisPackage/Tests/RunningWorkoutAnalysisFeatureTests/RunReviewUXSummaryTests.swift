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
    #expect(summary.signals.contains { $0.title == "Evidence" && $0.value == "0" && $0.detail == "Complete" })
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

@Test func workoutCapabilityProfileTreatsIndoorRouteAsNotExpected() throws {
    let start = Date(timeIntervalSinceReferenceDate: 1_500)
    let run = workout(
        id: "indoor",
        start: start,
        distance: 5_000,
        duration: 1_800,
        type: .easy,
        environment: .indoor,
        distanceSampleCount: 20,
        heartRateSampleCount: 20,
        cadenceSampleCount: 20
    )

    let profile = run.capabilityProfile

    #expect(profile.environment == .indoor)
    #expect(!profile.expectedMetrics.contains(.route))
    #expect(!profile.missingExpectedMetrics.contains(.route))
    #expect(profile.summary.contains("route and GPS elevation are not expected"))
}

@Test func workoutReviewSummarySurfacesExpectedDataSignal() throws {
    let start = Date(timeIntervalSinceReferenceDate: 1_600)
    let run = workout(
        id: "outdoor-limited",
        start: start,
        distance: 5_000,
        duration: 1_800,
        type: .easy,
        environment: .outdoor,
        distanceSampleCount: 20,
        heartRateSampleCount: 20
    )

    let summary = WorkoutReviewUXSummary.make(workout: run, supportedIntervals: nil, blockedReasons: [])
    let expectedData = try #require(summary.signals.first { $0.title == "Expected Data" })

    #expect(expectedData.value == "Outdoor")
    #expect(expectedData.detail.contains("missing"))
    #expect(expectedData.confidence == .moderate)
}

@Test func resolvedRowsPreferNativeActivityDurationAndStatistics() throws {
    let start = Date(timeIntervalSinceReferenceDate: 1_700)
    let workout = workout(id: "native-activity", start: start, distance: 400, duration: 120, type: .interval)
    let activity = workoutActivity(
        start: start,
        end: start.addingTimeInterval(120),
        duration: 100,
        distance: 400,
        averageHeartRate: 150,
        maxHeartRate: 166,
        averagePower: 310
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .heartRate: WorkoutMetricSeries(metric: .heartRate, unit: "bpm", points: [
                WorkoutEvidencePoint(date: start.addingTimeInterval(30), value: 99)
            ]),
            .runningPower: WorkoutMetricSeries(metric: .runningPower, unit: "W", points: [
                WorkoutEvidencePoint(date: start.addingTimeInterval(30), value: 100)
            ])
        ],
        activities: [activity],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            plannedSteps: [
                PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m")
            ]
        )
    )

    let result = try #require(CustomWorkoutResolvedIntervalRows.resolve(workout: workout, evidence: evidence))
    let row = try #require(result.intervals.first)

    #expect(row.durationDisplayRule == .activeTimer)
    #expect(abs(row.elapsedRowWindowDurationSeconds - 120) <= 0.001)
    #expect(abs(row.activeTimerDurationSeconds - 100) <= 0.001)
    #expect(abs((row.pauseOverlapSeconds ?? 0) - 20) <= 0.001)
    #expect(row.averageHeartRateBpm == 150)
    #expect(row.maxHeartRateBpm == 166)
    #expect(row.averagePower == 310)
}

@Test func resolvedRowsAddShortenedDistanceDiagnosticWithoutBlocking() throws {
    let start = Date(timeIntervalSinceReferenceDate: 1_800)
    let workout = workout(id: "manual-skip", start: start, distance: 1_210, duration: 460, type: .interval)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        activities: [
            workoutActivity(start: start, end: start.addingTimeInterval(460), duration: 460, distance: 1_210)
        ],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            plannedSteps: [
                PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km")
            ]
        )
    )

    let result = try #require(CustomWorkoutResolvedIntervalRows.resolve(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Work 1"])
    #expect(result.notes.contains { $0.contains("shortened/skipped HealthKit activity evidence") })
}

@Test func workoutEvidencePointPreservesSampleWindowAndProvenance() {
    let start = Date(timeIntervalSinceReferenceDate: 1_900)
    let point = WorkoutEvidencePoint(
        date: start,
        value: 12,
        startDate: start,
        endDate: start.addingTimeInterval(5),
        sampleSource: .sourceDateFallback,
        sourceName: "Apple Watch",
        sourceVersion: "26.0",
        deviceName: "Watch",
        metadataKeys: ["Key"]
    )

    #expect(point.startDate == start)
    #expect(point.endDate == start.addingTimeInterval(5))
    #expect(point.sampleSource == .sourceDateFallback)
    #expect(point.sourceName == "Apple Watch")
    #expect(point.metadataKeys == ["Key"])
}

@Test func plannedWorkoutStepKeepsTypedTargetsBesideDisplayText() {
    let target = PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 240,
        upperBound: 250,
        unit: "s/km",
        displayText: "pace range 4:00-4:10 /km"
    )
    let step = PlannedWorkoutStep(
        index: 1,
        label: "Work 1",
        stepType: .work,
        plannedGoalType: .distance,
        plannedGoalValue: 400,
        plannedGoalDisplayText: "400 m",
        plannedTargetDisplayText: target.displayText,
        plannedTargets: [target]
    )

    #expect(step.plannedTargetDisplayText == "pace range 4:00-4:10 /km")
    #expect(step.plannedTargets?.first?.kind == .pace)
    #expect(step.plannedTargets?.first?.lowerBound == 240)
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

@Test func evidenceReadinessSurfacesQueuedSummaryOnlyAnalysis() {
    let start = Date(timeIntervalSinceReferenceDate: 2_200)
    let run = workout(id: "queued", start: start, distance: 5_000, duration: 1_500, type: .easy)
    let queueItem = EvidenceEnrichmentQueueItem(
        workoutID: run.id,
        startDate: start,
        priority: .latestRun,
        status: .pending
    )

    let summary = EvidenceReadinessSummary.make(
        workout: run,
        queueItem: queueItem,
        isProcessing: false,
        supportedIntervals: nil,
        blockedReasons: ["Detailed HealthKit evidence is missing."]
    )

    #expect(summary.title == "Full analysis queued")
    #expect(summary.action == .load)
    #expect(summary.detail.contains("Detailed HealthKit evidence"))
}

@Test func evidenceReadinessSurfacesFailedRetryState() {
    let start = Date(timeIntervalSinceReferenceDate: 2_300)
    let run = workout(id: "failed", start: start, distance: 5_000, duration: 1_500, type: .easy)
    let queueItem = EvidenceEnrichmentQueueItem(
        workoutID: run.id,
        startDate: start,
        priority: .recentQuality,
        status: .failed,
        message: "WorkoutKit plan unavailable."
    )

    let summary = EvidenceReadinessSummary.make(
        workout: run,
        queueItem: queueItem,
        isProcessing: false,
        supportedIntervals: nil,
        blockedReasons: []
    )

    #expect(summary.title == "Analysis failed")
    #expect(summary.action == .refresh)
    #expect(summary.detail == "WorkoutKit plan unavailable.")
}

@Test func evidenceReadinessSurfacesReadyOfficialIntervals() {
    let start = Date(timeIntervalSinceReferenceDate: 2_400)
    let evidence = WorkoutEvidence(
        workoutID: "ready",
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(10), 100),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(20), 200)
                ]
            )
        ]
    )
    let run = workout(id: "ready", start: start, distance: 5_000, duration: 1_500, type: .interval, evidence: evidence)
    let intervals = WorkoutIntervalReconstructionResult(
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
                distance: 400,
                pace: 250,
                heartRate: 150,
                maxHeartRate: 160,
                power: 300,
                cadence: 180
            )
        ]
    )

    let summary = EvidenceReadinessSummary.make(
        workout: run,
        queueItem: nil,
        isProcessing: false,
        supportedIntervals: intervals,
        blockedReasons: []
    )

    #expect(summary.title == "Full analysis ready")
    #expect(summary.action == .refresh)
    #expect(summary.confidence == .strong)
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
    evidence: WorkoutEvidence? = nil,
    environment: RunEnvironment = .outdoor,
    routeAvailable: Bool = false,
    routePointCount: Int = 0,
    distanceSampleCount: Int = 0,
    heartRateSampleCount: Int = 0,
    runningSpeedSampleCount: Int = 0,
    cadenceSampleCount: Int = 0
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(duration),
        environment: environment,
        distanceMeters: distance,
        durationSeconds: duration,
        routeAvailable: routeAvailable,
        seriesAvailable: evidence != nil,
        routePointCount: routePointCount,
        seriesSampleCount: evidence?.series.values.map(\.sampleCount).reduce(0, +) ?? 0,
        heartRateSampleCount: heartRateSampleCount,
        runningSpeedSampleCount: runningSpeedSampleCount,
        distanceSampleCount: distanceSampleCount,
        cadenceSampleCount: cadenceSampleCount,
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

private func workoutActivity(
    start: Date,
    end: Date,
    duration: Double,
    distance: Double,
    averageHeartRate: Double? = nil,
    maxHeartRate: Double? = nil,
    averagePower: Double? = nil
) -> WorkoutEvidenceActivity {
    var statistics = [
        WorkoutEvidenceActivityStatistic(
            quantityType: "HKQuantityTypeIdentifierDistanceWalkingRunning",
            unit: "m",
            startDate: start,
            endDate: end,
            sourceCount: 1,
            sum: distance,
            durationSeconds: duration
        )
    ]
    if averageHeartRate != nil || maxHeartRate != nil {
        statistics.append(
            WorkoutEvidenceActivityStatistic(
                quantityType: "HKQuantityTypeIdentifierHeartRate",
                unit: "bpm",
                startDate: start,
                endDate: end,
                sourceCount: 1,
                average: averageHeartRate,
                maximum: maxHeartRate,
                durationSeconds: duration
            )
        )
    }
    if let averagePower {
        statistics.append(
            WorkoutEvidenceActivityStatistic(
                quantityType: "HKQuantityTypeIdentifierRunningPower",
                unit: "W",
                startDate: start,
                endDate: end,
                sourceCount: 1,
                average: averagePower,
                durationSeconds: duration
            )
        )
    }
    return WorkoutEvidenceActivity(
        id: UUID().uuidString,
        activityType: "running",
        locationType: "outdoor",
        startDate: start,
        endDate: end,
        durationSeconds: duration,
        statistics: statistics
    )
}
