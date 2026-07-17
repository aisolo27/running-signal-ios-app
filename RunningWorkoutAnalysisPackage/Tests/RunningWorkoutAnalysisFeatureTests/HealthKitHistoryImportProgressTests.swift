import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func healthKitHistoryImportProgressRetainsTransientWindowContext() {
    let start = Date(timeIntervalSince1970: 1_700_000_000)
    let end = start.addingTimeInterval(60 * 60 * 24 * 365)
    let progress = HealthKitHistoryImportProgress(
        completedDateWindowCount: 3,
        totalDateWindowCount: 8,
        currentWindowStartDate: start,
        currentWindowEndDate: end,
        importedWorkoutCount: 648
    )

    #expect(progress.currentWindowStartDate == start)
    #expect(progress.currentWindowEndDate == end)
    #expect(progress.importedWorkoutCount == 648)
    #expect(progress.fractionComplete == 0.375)
    #expect(progress.progressText == "3 of 8 history ranges checked")
}

@Test func healthKitHistoryImportProgressClampsFractionAndDisplayedCount() {
    let overComplete = HealthKitHistoryImportProgress(
        completedDateWindowCount: 12,
        totalDateWindowCount: 8,
        importedWorkoutCount: 648
    )
    let negative = HealthKitHistoryImportProgress(
        completedDateWindowCount: -2,
        totalDateWindowCount: 8,
        importedWorkoutCount: 0
    )

    #expect(overComplete.fractionComplete == 1)
    #expect(overComplete.progressText == "8 of 8 history ranges checked")
    #expect(negative.fractionComplete == 0)
    #expect(negative.progressText == "0 of 8 history ranges checked")
}

@Test func healthKitHistoryImportProgressHandlesUnknownAndSingleWindowTotals() {
    let unknown = HealthKitHistoryImportProgress(
        completedDateWindowCount: 4,
        totalDateWindowCount: 0,
        importedWorkoutCount: 0
    )
    let single = HealthKitHistoryImportProgress(
        completedDateWindowCount: 1,
        totalDateWindowCount: 1,
        importedWorkoutCount: 12
    )

    #expect(unknown.fractionComplete == 0)
    #expect(unknown.progressText == "0 of 0 history ranges checked")
    #expect(single.fractionComplete == 1)
    #expect(single.progressText == "1 of 1 history range checked")
}
