import SwiftData
import SwiftUI

public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
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
                SettingsView(store: store)
            }
            .tabItem { Label(AppTab.settings.title, systemImage: AppTab.settings.symbol) }
            .tag(AppTab.settings)
        }
        .task {
            await store.bootstrap(modelContext: modelContext)
        }
    }
}

private enum AppTab: String {
    case runs
    case settings

    var title: String {
        switch self {
        case .runs: "Runs"
        case .settings: "Settings"
        }
    }

    var symbol: String {
        switch self {
        case .runs: "figure.run"
        case .settings: "gearshape"
        }
    }
}
