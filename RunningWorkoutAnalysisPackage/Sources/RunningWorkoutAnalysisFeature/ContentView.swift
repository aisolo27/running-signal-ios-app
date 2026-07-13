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
    @AppStorage("RunSignal.HealthKitOnboardingCompleted.v1") private var didCompleteHealthKitOnboarding = false
    @State private var store = RunningAnalysisStore()
    @State private var selectedTab = AppTab.runs
    @State private var didScheduleStartupMaintenance = false
    @State private var didSkipInitialActiveSync = false
    @State private var didFinishBootstrap = false

    public init() {}

    public var body: some View {
        ZStack {
            if didFinishBootstrap && !shouldPresentHealthKitOnboarding {
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
            }

            if !didFinishBootstrap {
                RunSignalStartupView()
                    .transition(.opacity)
                    .zIndex(2)
            } else if shouldPresentHealthKitOnboarding {
                HealthKitOnboardingView(
                    message: store.message,
                    connect: connectFromOnboarding,
                    skip: {
                        didCompleteHealthKitOnboarding = true
                    }
                )
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .task {
            Self.startupLogger.notice("Bootstrap started")
            await store.bootstrap(modelContext: modelContext)
            Self.startupLogger.notice("Bootstrap finished")
            withAnimation(.easeOut(duration: 0.18)) {
                didFinishBootstrap = true
            }
            store.startAutomaticEvidenceEnrichment()
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

    private var shouldPresentHealthKitOnboarding: Bool {
        FirstRunOnboardingPolicy.shouldPresent(
            onboardingCompleted: didCompleteHealthKitOnboarding,
            hasWorkouts: !store.workouts.isEmpty,
            authorizationState: store.authorizationState
        )
    }

    private func connectFromOnboarding() async -> Bool {
        let connected = await store.requestHealthKitAccess()
        guard connected else { return false }
        didCompleteHealthKitOnboarding = true
        await store.refreshFromHealthKit()
        Task { await store.analyzeBestEffortHistory() }
        return true
    }

    private func scheduleStartupMaintenance() {
        guard !didScheduleStartupMaintenance else { return }
        didScheduleStartupMaintenance = true

        Task {
            Self.startupLogger.notice("Startup maintenance started")
            await store.startHealthKitBackgroundDelivery()
            await Task.yield()
            await store.syncHealthKitChangesOnForeground()
            await store.analyzeBestEffortHistory()
            Self.startupLogger.notice("Startup maintenance finished")
        }
    }
}

private struct HealthKitOnboardingView: View {
    let message: String
    let connect: () async -> Bool
    let skip: () -> Void

    @State private var isConnecting = false
    @State private var connectionFailed = false

    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.027, blue: 0.039)
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .fill(Color(red: 0.10, green: 0.22, blue: 0.38))
                            Image(systemName: "figure.run")
                                .font(.system(size: 36, weight: .semibold))
                                .foregroundStyle(.white)
                        }
                        .frame(width: 82, height: 82)

                        Text("Your Apple Health runs, analyzed")
                            .font(.largeTitle.bold())
                            .foregroundStyle(.white)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("RunSignal reads completed running workouts to build your history, splits, trends, and verified best efforts.")
                            .font(.title3)
                            .foregroundStyle(.white.opacity(0.78))
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(alignment: .leading, spacing: 16) {
                        OnboardingBenefitRow(
                            systemImage: "checkmark.shield",
                            title: "Read-only",
                            detail: "RunSignal never changes or writes Apple Health data."
                        )
                        OnboardingBenefitRow(
                            systemImage: "iphone",
                            title: "Processed on this iPhone",
                            detail: "Version 1 has no backend sync or AI calls."
                        )
                        OnboardingBenefitRow(
                            systemImage: "hand.raised",
                            title: "You stay in control",
                            detail: "Choose the Health data you are comfortable sharing."
                        )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What RunSignal asks for")
                            .font(.headline)
                            .foregroundStyle(.white)
                        Text("Workouts and running distance power the core experience. Heart rate, routes, cadence, power, mechanics, calories, resting heart rate, and VO₂ max add detail when available.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.72))
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding()
                    .background(.white.opacity(0.08))
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                    if connectionFailed {
                        Label(message, systemImage: "exclamationmark.triangle")
                            .font(.subheadline)
                            .foregroundStyle(.orange)
                            .fixedSize(horizontal: false, vertical: true)
                    }

                    VStack(spacing: 12) {
                        Button {
                            Task {
                                isConnecting = true
                                connectionFailed = !(await connect())
                                isConnecting = false
                            }
                        } label: {
                            Group {
                                if isConnecting {
                                    Label("Connecting Apple Health", systemImage: "hourglass")
                                } else {
                                    Label("Connect Apple Health", systemImage: "heart.text.square")
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .disabled(isConnecting)
                        .accessibilityIdentifier("onboarding-connect-health")

                        Button("Not Now", action: skip)
                            .buttonStyle(.plain)
                            .foregroundStyle(.white.opacity(0.72))
                            .disabled(isConnecting)
                            .accessibilityIdentifier("onboarding-not-now")
                    }
                }
                .frame(maxWidth: 560, alignment: .leading)
                .padding(.horizontal, 24)
                .padding(.top, 52)
                .padding(.bottom, 36)
                .frame(maxWidth: .infinity)
            }
        }
        .accessibilityIdentifier("healthkit-onboarding")
    }
}

private struct OnboardingBenefitRow: View {
    let systemImage: String
    let title: String
    let detail: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            Image(systemName: systemImage)
                .font(.title3)
                .foregroundStyle(.blue)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.white)
                Text(detail)
                    .font(.subheadline)
                    .foregroundStyle(.white.opacity(0.72))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

private struct RunSignalStartupView: View {
    var body: some View {
        ZStack {
            Color(red: 0.02, green: 0.027, blue: 0.039)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .fill(Color(red: 0.10, green: 0.22, blue: 0.38))

                    Image(systemName: "figure.run")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 82, height: 82)

                VStack(spacing: 6) {
                    Text("RunSignal")
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)

                    Text("Loading runs")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                ProgressView()
                    .controlSize(.regular)
                    .tint(.white.opacity(0.9))
                    .padding(.top, 4)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("RunSignal loading runs")
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
