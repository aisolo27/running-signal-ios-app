import SwiftData
import SwiftUI

public struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var store = RunningAnalysisStore()
    @State private var selectedTab = AppTab.today

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            NavigationStack {
                TodayView(store: store)
            }
            .tabItem { Label(AppTab.today.title, systemImage: AppTab.today.symbol) }
            .tag(AppTab.today)

            NavigationStack {
                LatestRunView(store: store)
            }
            .tabItem { Label(AppTab.latestRun.title, systemImage: AppTab.latestRun.symbol) }
            .tag(AppTab.latestRun)

            NavigationStack {
                RaceGoalView(store: store)
            }
            .tabItem { Label(AppTab.raceGoal.title, systemImage: AppTab.raceGoal.symbol) }
            .tag(AppTab.raceGoal)

            NavigationStack {
                HistoryView(store: store)
            }
            .tabItem { Label(AppTab.history.title, systemImage: AppTab.history.symbol) }
            .tag(AppTab.history)

            NavigationStack {
                DataView(store: store)
            }
            .tabItem { Label(AppTab.data.title, systemImage: AppTab.data.symbol) }
            .tag(AppTab.data)
        }
        .task {
            await store.bootstrap(modelContext: modelContext)
        }
    }
}

private enum AppTab: String {
    case today
    case latestRun
    case raceGoal
    case history
    case data

    var title: String {
        switch self {
        case .today: "Today"
        case .latestRun: "Latest Run"
        case .raceGoal: "Race Goal"
        case .history: "History"
        case .data: "Data"
        }
    }

    var symbol: String {
        switch self {
        case .today: "sun.max"
        case .latestRun: "figure.run"
        case .raceGoal: "flag.checkered"
        case .history: "list.bullet.rectangle"
        case .data: "shield.lefthalf.filled"
        }
    }
}
