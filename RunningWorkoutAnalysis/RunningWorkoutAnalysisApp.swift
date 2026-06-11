import SwiftUI
import SwiftData
import RunningWorkoutAnalysisFeature

@main
struct RunningWorkoutAnalysisApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [
            PersistedWorkout.self,
            PersistedWorkoutEvidence.self,
            PersistedEvidenceEnrichmentState.self,
            PersistedDerivedWorkoutAnalysis.self
        ])
    }
}
