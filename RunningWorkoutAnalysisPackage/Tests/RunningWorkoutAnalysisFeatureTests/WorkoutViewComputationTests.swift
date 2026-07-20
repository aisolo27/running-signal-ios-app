import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func workoutViewChartComputationPreservesExistingPresentationOutput() async throws {
    let workout = viewComputationWorkout()

    let result = try await WorkoutViewComputation.chartDeck(
        workout: workout,
        interval: nil
    )

    #expect(result.series == WorkoutChartSeriesBuilder.presentationSeries(for: workout))
    #expect(result.officialIntervals.isEmpty)
}

@Test func workoutViewComputationObservesParentTaskCancellation() async {
    let workout = viewComputationWorkout()
    let gate = WorkoutViewComputationCancellationGate()
    let task = Task {
        await gate.pause()
        return try await WorkoutViewComputation.detailPresentation(
            workout: workout,
            analysis: nil
        )
    }

    await gate.waitUntilPaused()
    task.cancel()
    await gate.resume()

    await #expect(throws: CancellationError.self) {
        try await task.value
    }
}

private func viewComputationWorkout() -> CanonicalWorkout {
    let start = Date(timeIntervalSince1970: 1_800_000_000)
    return CanonicalWorkout(
        id: "view-computation",
        sourceID: "view-computation",
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(1_800),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_800,
        inferredRunType: .easy
    )
}

private actor WorkoutViewComputationCancellationGate {
    private var paused = false
    private var pauseContinuation: CheckedContinuation<Void, Never>?
    private var startContinuations: [CheckedContinuation<Void, Never>] = []

    func pause() async {
        await withCheckedContinuation { continuation in
            pauseContinuation = continuation
            paused = true
            let continuations = startContinuations
            startContinuations.removeAll()
            continuations.forEach { $0.resume() }
        }
    }

    func waitUntilPaused() async {
        guard !paused else { return }
        await withCheckedContinuation { continuation in
            startContinuations.append(continuation)
        }
    }

    func resume() {
        pauseContinuation?.resume()
        pauseContinuation = nil
        paused = false
    }
}
