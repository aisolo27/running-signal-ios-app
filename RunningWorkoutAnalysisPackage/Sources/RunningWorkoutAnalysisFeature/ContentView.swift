import OSLog
import SwiftData
import SwiftUI

public struct ContentView: View {
    private static let startupLogger = Logger(
        subsystem: "com.adrielsolorzano.runninganalysis",
        category: "Startup"
    )

    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var store = RunningAnalysisStore()
    @State private var selectedTab = AppTab.runs
    @State private var didScheduleStartupMaintenance = false
    @State private var didSkipInitialActiveSync = false

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                RunsView(store: store)
            }
            .tabItem { Label(AppTab.runs.title, systemImage: AppTab.runs.symbol) }
            .tag(AppTab.runs)

            NavigationStack {
                AnalyticsView(store: store)
            }
            .tabItem { Label(AppTab.analytics.title, systemImage: AppTab.analytics.symbol) }
            .tag(AppTab.analytics)

            NavigationStack {
                SettingsView(store: store)
            }
            .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.symbol) }
            .tag(AppTab.settings)
        }
        .task {
            Self.startupLogger.notice("Bootstrap started")
            await store.bootstrap(modelContext: modelContext)
            Self.startupLogger.notice("Bootstrap finished")
            scheduleStartupMaintenance()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            guard didSkipInitialActiveSync else {
                didSkipInitialActiveSync = true
                Self.startupLogger.notice("Initial active phase observed; startup maintenance owns first foreground sync")
                return
            }
            Task {
                Self.startupLogger.notice("Foreground sync requested after reactivation")
                await store.syncHealthKitChangesOnForeground()
            }
        }
    }

    private func scheduleStartupMaintenance() {
        guard !didScheduleStartupMaintenance else { return }
        didScheduleStartupMaintenance = true

        Task {
            Self.startupLogger.notice("Startup maintenance started")
            await store.startHealthKitBackgroundDelivery()
            await Task.yield()
            await store.syncHealthKitChangesOnForeground()
            Self.startupLogger.notice("Startup maintenance finished")
        }
    }
}

private enum AppTab: String {
    case runs
    case analytics
    case settings

    var title: String {
        switch self {
        case .runs: "Runs"
        case .analytics: "Analytics"
        case .settings: "Settings"
        }
    }

    var symbol: String {
        switch self {
        case .runs: "figure.run"
        case .analytics: "chart.bar.xaxis"
        case .settings: "gearshape"
        }
    }
}
