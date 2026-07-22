import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func performanceTimelineKeepsMissingMetricBucketsAndSharedDistanceSelectionTruthful() {
    let start = Date(timeIntervalSince1970: 10_000)
    let workout = timelineWorkout(
        start: start,
        duration: 60,
        series: [
            .heartRate: WorkoutMetricSeries(
                metric: .heartRate,
                unit: "bpm",
                points: [
                    WorkoutEvidencePoint(
                        date: start.addingTimeInterval(10),
                        value: 150,
                        startDate: start,
                        endDate: start.addingTimeInterval(10)
                    )
                ]
            ),
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(
                        date: start.addingTimeInterval(30),
                        value: 300,
                        startDate: start,
                        endDate: start.addingTimeInterval(30)
                    ),
                    WorkoutEvidencePoint(
                        date: start.addingTimeInterval(60),
                        value: 300,
                        startDate: start.addingTimeInterval(30),
                        endDate: start.addingTimeInterval(60)
                    )
                ]
            )
        ]
    )

    let timeline = WorkoutPerformanceTimelineBuilder.make(workout: workout)
    let lateSelection = timeline?.selection(at: 8)

    #expect(timeline?.bucketSeconds == 5)
    #expect(timeline?.series(for: .heartRate)?.bucket(at: 8) == nil)
    #expect(lateSelection?.offsetSeconds == 42.5)
    #expect(abs((lateSelection?.distanceMeters ?? 0) - 425) < 0.001)
}

@Test func performanceTimelinePaceDomainDoesNotLetOneSlowPointFlattenTheRun() {
    let ordinaryPaces = (0..<30).map { 360 + Double($0 % 5) * 3 }
    let domain = WorkoutPerformanceTimelineBuilder.robustDomain(
        metric: .pace,
        values: ordinaryPaces + [1_250]
    )

    #expect(domain.upperBound < 500)
    #expect(domain.contains(ordinaryPaces[10]))
    #expect(!domain.contains(1_250))
}

@Test func performanceTimelineCreditsReconciledOverlappingDistanceWindowsWithoutFallingBackToTotal() {
    let start = Date(timeIntervalSince1970: 15_000)
    let workout = timelineWorkout(
        start: start,
        duration: 60,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(
                        date: start,
                        value: 300,
                        startDate: start,
                        endDate: start.addingTimeInterval(40)
                    ),
                    WorkoutEvidencePoint(
                        date: start.addingTimeInterval(20),
                        value: 300,
                        startDate: start.addingTimeInterval(20),
                        endDate: start.addingTimeInterval(60)
                    )
                ]
            )
        ]
    )

    let timeline = WorkoutPerformanceTimelineBuilder.make(workout: workout)
    let selection = timeline?.selection(at: 6)

    #expect(selection?.offsetSeconds == 32.5)
    #expect(abs((selection?.distanceMeters ?? 0) - 337.5) < 0.001)
    #expect(selection?.distanceMeters != workout.distanceMeters)
}

@Test func performanceTimelineLeavesSelectedDistanceUnavailableWhenSamplesDoNotReconcile() {
    let start = Date(timeIntervalSince1970: 17_500)
    let workout = timelineWorkout(
        start: start,
        duration: 60,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(
                        date: start,
                        value: 200,
                        startDate: start,
                        endDate: start.addingTimeInterval(60)
                    )
                ]
            )
        ]
    )

    let timeline = WorkoutPerformanceTimelineBuilder.make(workout: workout)

    #expect(timeline?.selection(at: 6)?.distanceMeters == nil)
}

@Test func performanceTimelineScrubbingRequiresHorizontalIntent() {
    #expect(WorkoutTimelineInteractionPolicy.shouldScrub(horizontalTranslation: 30, verticalTranslation: 4))
    #expect(!WorkoutTimelineInteractionPolicy.shouldScrub(horizontalTranslation: 4, verticalTranslation: 30))
    #expect(!WorkoutTimelineInteractionPolicy.shouldScrub(horizontalTranslation: 10, verticalTranslation: 10))
}

@Test func performanceTimelineWithholdsSparseCadenceInsteadOfDrawingAFalseFlatLine() {
    let start = Date(timeIntervalSince1970: 20_000)
    let workout = timelineWorkout(
        start: start,
        duration: 60,
        series: [
            .cadence: WorkoutMetricSeries(
                metric: .cadence,
                unit: "spm",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(5), value: 171),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(40), value: 175)
                ]
            )
        ]
    )

    let timeline = WorkoutPerformanceTimelineBuilder.make(workout: workout)

    #expect(timeline?.cadenceWasWithheld == true)
    #expect(timeline?.visibleSeries.contains { $0.metric == .cadence } == false)
}

@Test func performanceTimelineShowsCadenceWhenSamplesCoverEnoughOfTheRun() {
    let start = Date(timeIntervalSince1970: 30_000)
    let points = stride(from: 5, through: 55, by: 10).map { second in
        WorkoutEvidencePoint(date: start.addingTimeInterval(Double(second)), value: 170 + Double(second % 4))
    }
    let workout = timelineWorkout(
        start: start,
        duration: 60,
        series: [
            .cadence: WorkoutMetricSeries(metric: .cadence, unit: "spm", points: points)
        ]
    )

    let timeline = WorkoutPerformanceTimelineBuilder.make(workout: workout)

    #expect(timeline?.cadenceWasWithheld == false)
    #expect(timeline?.visibleSeries.contains { $0.metric == .cadence } == true)
}

@Test func performanceTimelineConvertsStepCountsToStepsPerMinuteBeforeChartingCadence() {
    let start = Date(timeIntervalSince1970: 40_000)
    let points = stride(from: 0, to: 60, by: 10).map { second in
        WorkoutEvidencePoint(
            date: start.addingTimeInterval(Double(second + 10)),
            value: 30,
            startDate: start.addingTimeInterval(Double(second)),
            endDate: start.addingTimeInterval(Double(second + 10))
        )
    }
    let workout = timelineWorkout(
        start: start,
        duration: 60,
        series: [
            .stepCount: WorkoutMetricSeries(metric: .stepCount, unit: "steps", points: points)
        ]
    )

    let cadence = WorkoutPerformanceTimelineBuilder.make(workout: workout)?.series(for: .cadence)

    #expect(cadence?.buckets.allSatisfy { abs($0.median - 180) < 0.001 } == true)
    #expect(cadence?.isCadenceDetailTrustworthy == true)
}

private func timelineWorkout(
    start: Date,
    duration: Double,
    series: [WorkoutEvidenceMetric: WorkoutMetricSeries]
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: "timeline-test-\(start.timeIntervalSince1970)",
        sourceID: "timeline-source",
        sourceName: "Tests",
        startDate: start,
        endDate: start.addingTimeInterval(duration),
        environment: .outdoor,
        distanceMeters: 600,
        durationSeconds: duration,
        averageHeartRate: series[.heartRate]?.average,
        averageCadence: series[.cadence]?.average,
        routeAvailable: false,
        seriesAvailable: true,
        inferredRunType: .easy,
        evidence: WorkoutEvidence(
            workoutID: "timeline-test-\(start.timeIntervalSince1970)",
            loadedAt: start,
            series: series
        )
    )
}
