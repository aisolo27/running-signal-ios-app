import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func completedPartialAuthorizationWithNoRunsRequestsHealthAccessReview() {
    let presentation = HealthKitConnectionPresentation.make(
        authorizationState: .partial,
        importStatus: .completed,
        loadedRunCount: 0,
        isLoading: false
    )

    #expect(presentation.phase == .healthAccessReview)
    #expect(presentation.title == "Review Apple Health Access")
    #expect(!presentation.title.contains("Connected"))
    #expect(presentation.detailText.contains("no completed running workouts were returned"))
    #expect(presentation.detailText.contains("review RunSignal's Health access"))
    #expect(presentation.action == .refresh)
    #expect(presentation.showsPrimaryAction)
    #expect(!presentation.showsProgress)
    #expect(presentation.showsHealthAccessRecoveryGuidance)
}

@Test func completedPartialAuthorizationWithRunsRemainsConnected() {
    let presentation = HealthKitConnectionPresentation.make(
        authorizationState: .partial,
        importStatus: .completed,
        loadedRunCount: 648,
        isLoading: false
    )

    #expect(presentation.phase == .ready)
    #expect(presentation.title == "Apple Health Connected")
    #expect(presentation.action == .refresh)
    #expect(!presentation.showsHealthAccessRecoveryGuidance)
}

@Test func activeZeroRunImportDoesNotPrematurelyRequestHealthAccessReview() {
    let presentation = HealthKitConnectionPresentation.make(
        authorizationState: .partial,
        importStatus: .running,
        loadedRunCount: 0,
        isLoading: true
    )

    #expect(presentation.phase == .loadingHistory)
    #expect(presentation.title == "Finding Your Runs")
    #expect(presentation.showsProgress)
    #expect(!presentation.showsHealthAccessRecoveryGuidance)
}
