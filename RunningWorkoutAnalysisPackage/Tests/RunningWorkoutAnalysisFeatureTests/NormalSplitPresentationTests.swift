import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func normalSplitCompactLabelsFollowTheSelectedUnit() {
    #expect(NormalSplitPresentation.compactLabel("KM 4", unit: .kilometers) == "4")
    #expect(NormalSplitPresentation.compactLabel("Mile 3", unit: .miles) == "3")
    #expect(NormalSplitPresentation.compactLabel("Final", unit: .kilometers) == "Final")
}

@Test func normalSplitSupportingTextKeepsFinalTimeAndPauseContext() {
    let final = DerivedSplitEstimate(
        label: "Final",
        distanceMeters: 30,
        durationSecondsEstimate: 15,
        paceSecondsPerKmEstimate: 500,
        confidence: .strong,
        pauseOverlapSeconds: 5
    )

    #expect(
        NormalSplitPresentation.supportingText(for: final, policy: .kilometersOnly)
            == "0.03 km · 0:15 · 0:05 pause excluded"
    )
    #expect(
        NormalSplitPresentation.supportingText(for: final, policy: .milesOnly)
            == "0.02 mi · 0:15 · 0:05 pause excluded"
    )
}

@Test func normalSplitSourceNoteStaysQuietForValidatedRows() {
    #expect(NormalSplitPresentation.runnerFacingSourceNote(.validatedLapEvents) == nil)
    #expect(NormalSplitPresentation.runnerFacingSourceNote(.validatedSegmentEvents) == nil)
    #expect(
        NormalSplitPresentation.runnerFacingSourceNote(.distanceSampleWindows)
            == "Estimated from available run data"
    )
    #expect(
        NormalSplitPresentation.runnerFacingSourceNote(.workoutAverageFallback)
            == "Estimated from the workout average"
    )
}

@Test func normalSplitMetricAveragesUseOnlyTheSplitWindow() throws {
    let start = Date(timeIntervalSinceReferenceDate: 10_000)
    let splits = [
        DerivedSplitEstimate(
            label: "KM 1",
            distanceMeters: 1_000,
            durationSecondsEstimate: 60,
            paceSecondsPerKmEstimate: 60,
            confidence: .strong,
            elapsedStartOffsetSeconds: 0,
            elapsedEndOffsetSeconds: 60
        ),
        DerivedSplitEstimate(
            label: "KM 2",
            distanceMeters: 1_000,
            durationSecondsEstimate: 60,
            paceSecondsPerKmEstimate: 60,
            confidence: .strong,
            elapsedStartOffsetSeconds: 60,
            elapsedEndOffsetSeconds: 120
        ),
    ]
    let evidence = WorkoutEvidence(
        workoutID: "split-metrics",
        series: [
            .heartRate: WorkoutMetricSeries(metric: .heartRate, unit: "bpm", points: [
                WorkoutEvidencePoint(date: start.addingTimeInterval(10), value: 110),
                WorkoutEvidencePoint(date: start.addingTimeInterval(30), value: 130),
                WorkoutEvidencePoint(date: start.addingTimeInterval(60), value: 190),
            ]),
            .cadence: WorkoutMetricSeries(metric: .cadence, unit: "spm", points: [
                WorkoutEvidencePoint(date: start.addingTimeInterval(20), value: 170),
                WorkoutEvidencePoint(date: start.addingTimeInterval(40), value: 174),
            ]),
            .runningPower: WorkoutMetricSeries(metric: .runningPower, unit: "W", points: [
                WorkoutEvidencePoint(date: start.addingTimeInterval(25), value: 200),
                WorkoutEvidencePoint(date: start.addingTimeInterval(45), value: 220),
            ]),
        ]
    )

    let metrics = NormalSplitPresentation.metricAverages(
        at: 0,
        splits: splits,
        workoutStartDate: start,
        evidence: evidence
    )

    #expect(try #require(metrics.heartRate) == 120)
    #expect(try #require(metrics.cadence) == 172)
    #expect(try #require(metrics.power) == 210)
}
