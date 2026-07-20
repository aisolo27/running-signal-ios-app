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
    private static let persistenceLogger = Logger(
        subsystem: "com.adrielsolorzano.runninganalysis",
        category: "Persistence"
    )
    @State private var persistenceState: PersistenceStartupState

    init() {
        do {
            _persistenceState = State(
                initialValue: .ready(try RunSignalPersistenceContainer.make())
            )
        } catch {
            Self.persistenceLogger.error(
                "Unable to initialize the RunSignal data store: \(String(describing: error), privacy: .public)"
            )
            _persistenceState = State(initialValue: .failed)
        }
    }

    var body: some Scene {
        WindowGroup {
            Group {
                switch persistenceState {
                case .ready(let modelContainer):
                    ContentView()
                        .modelContainer(modelContainer)
                case .failed:
                    PersistenceStartupFailureView {
                        retryPersistenceStartup()
                    }
                }
            }
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didReceiveMemoryWarningNotification)) { _ in
                    Self.lifecycleLogger.warning("Received iOS memory warning")
                }
        }
    }

    private func retryPersistenceStartup() {
        do {
            persistenceState = .ready(try RunSignalPersistenceContainer.make())
        } catch {
            Self.persistenceLogger.error(
                "RunSignal data store retry failed: \(String(describing: error), privacy: .public)"
            )
            persistenceState = .failed
        }
    }
}

private enum PersistenceStartupState {
    case ready(ModelContainer)
    case failed
}

private struct PersistenceStartupFailureView: View {
    var retry: () -> Void

    var body: some View {
        VStack(spacing: 18) {
            Image(systemName: "externaldrive.badge.exclamationmark")
                .font(.system(size: 44, weight: .semibold))
                .foregroundStyle(.orange)

            VStack(spacing: 8) {
                Text("Saved Run History Unavailable")
                    .font(.title2.bold())
                    .multilineTextAlignment(.center)

                Text("RunSignal could not open its saved on-device data. Your Apple Health workouts were not changed. Retry without deleting the app so the saved data remains available for recovery.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: retry) {
                Label("Retry Saved Runs", systemImage: "arrow.clockwise")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding(24)
        .frame(maxWidth: 520)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemBackground))
    }
}
