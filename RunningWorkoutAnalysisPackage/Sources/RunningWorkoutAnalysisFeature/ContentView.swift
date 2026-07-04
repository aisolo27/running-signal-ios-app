import SwiftData
import SwiftUI

public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) private var scenePhase
    @State private var store = RunningAnalysisStore()
    @State private var selectedTab = AppTab.runs

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
            await store.bootstrap(modelContext: modelContext)
            await store.startHealthKitBackgroundDelivery()
            await store.syncHealthKitChangesOnForeground()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task {
                await store.syncHealthKitChangesOnForeground()
            }
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
