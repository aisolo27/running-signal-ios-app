import OSLog
import SwiftUI
import SwiftData
import UIKit
import RunningWorkoutAnalysisFeature

@main
struct RunningWorkoutAnalysisApp: App {
    private static let lifecycleLogger = Logger(
        subsystem: "com.adrielsolorzano.runninganalysis",
        category: "Lifecycle"
    )

    var body: some Scene {
        WindowGroup {
            ContentView()
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
                    Self.lifecycleLogger.warning("Received iOS memory warning")
                }
        }
        .modelContainer(for: [
            PersistedWorkout.self,
            PersistedWorkoutEvidence.self,
            PersistedEvidenceEnrichmentState.self,
            PersistedEvidenceRefreshJob.self,
            PersistedEvidenceRefreshJobItem.self,
            PersistedHealthKitImportJob.self,
            PersistedDerivedWorkoutAnalysis.self
        ])
    }
}
