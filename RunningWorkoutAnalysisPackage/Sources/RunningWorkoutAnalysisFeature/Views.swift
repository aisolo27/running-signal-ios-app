import MapKit
import SwiftUI
import UniformTypeIdentifiers

struct RunsView: View {
    var store: RunningAnalysisStore

    private var runs: [CanonicalWorkout] {
        V1WorkoutFilters.completedRuns(from: store.workouts)
    }

    private var latestRun: CanonicalWorkout? {
        runs.first
    }

    var body: some View {
        List {
            Section {
                if store.usesSampleData {
                    NoticeCard(title: "Using Sample Data", message: "These workouts are placeholders. Load HealthKit from Settings to replace them with your completed running workouts.")
                } else {
                    NoticeCard(title: "HealthKit Loaded", message: "\(runs.count) completed running workouts are available. Duplicate-like workouts are hidden from this v1 list.")
                }
            }
            .listRowSeparator(.hidden)

            if let latestRun {
                Section("Most Recent") {
                    NavigationLink {
                        WorkoutDetailView(store: store, workoutID: latestRun.id)
                    } label: {
                        FeaturedRunRow(workout: latestRun)
                    }
                }
            }

            Section("Completed Runs") {
                if runs.isEmpty {
                    EmptyStateView(title: "No completed runs", message: "Load HealthKit to show completed running workouts.")
                } else {
                    ForEach(runs) { workout in
                        NavigationLink {
                            WorkoutDetailView(store: store, workoutID: workout.id)
                        } label: {
                            V1WorkoutRow(workout: workout)
                        }
                    }
                }
            }
        }
        .navigationTitle("Runs")
        .refreshable {
            await store.refreshFromHealthKit()
        }
    }
}

struct SettingsView: View {
    var store: RunningAnalysisStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Settings", subtitle: "HealthKit status, data coverage, and v1 debug tools.")

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(dataModeTitle, systemImage: store.usesSampleData ? "exclamationmark.triangle" : "heart.text.square")
                            .font(.headline)
                        Spacer()
                        if store.isLoading {
                            ProgressView()
                        }
                    }
                    Text(store.message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                    Button {
                        Task { await store.refreshFromHealthKit() }
                    } label: {
                        Label("Load HealthKit Runs", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.isLoading)
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                MetricGrid(items: [
                    MetricItem(title: "Authorization", value: store.authorizationState.label, detail: store.healthKitStatus.updatedAt.map { RunFormatters.date.string(from: $0) } ?? "Current status"),
                    MetricItem(title: "Data mode", value: store.usesSampleData ? "Sample" : "HealthKit", detail: store.usesSampleData ? "Clearly labeled" : "Real workouts"),
                    MetricItem(title: "Runs", value: "\(V1WorkoutFilters.completedRuns(from: store.workouts).count)", detail: "Non-duplicate"),
                    MetricItem(title: "Duplicates", value: "\(store.workouts.filter(\.isDuplicate).count)", detail: "Hidden from Runs"),
                    MetricItem(title: "Route points", value: "\(store.includedWorkouts.map(\.routePointCount).reduce(0, +))", detail: "Loaded evidence"),
                    MetricItem(title: "Samples", value: "\(store.includedWorkouts.map(\.seriesSampleCount).reduce(0, +))", detail: "Loaded evidence")
                ])

                VStack(alignment: .leading, spacing: 12) {
                    Label("Duplicate Handling", systemImage: "rectangle.2.swap")
                        .font(.headline)
                    Text("RunSignal keeps the preferred HealthKit/Apple Watch workout in the Runs tab and hides likely duplicate imports from the v1 viewer.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    MetricGrid(items: [
                        MetricItem(title: "Included", value: "\(store.includedWorkouts.count)", detail: "Visible runs"),
                        MetricItem(title: "Hidden", value: "\(store.workouts.filter(\.isDuplicate).count)", detail: "Duplicate-like")
                    ])
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                SectionHeader("Debug")
                NavigationLink {
                    HealthKitAuditView(store: store)
                } label: {
                    Label("Raw HealthKit Audit", systemImage: "list.clipboard")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    GoldenValidationView(store: store)
                } label: {
                    Label("Apple Fitness Parity Checklist", systemImage: "checkmark.seal")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    HealthKitPermissionReviewView(store: store)
                } label: {
                    Label("HealthKit Permissions", systemImage: "lock.shield")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Settings")
    }

    private var dataModeTitle: String {
        store.usesSampleData ? "Using Sample Data" : "HealthKit Loaded"
    }
}

struct FeaturedRunRow: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(RunWorkout(workout: workout).displayName)
                .font(.headline)
            Text(RunFormatters.date.string(from: workout.startDate))
                .font(.caption)
                .foregroundStyle(.secondary)
            MetricGrid(items: [
                MetricItem(title: "Distance", value: RunFormatters.distance(workout.distanceMeters), detail: workout.sourceName),
                MetricItem(title: "Time", value: RunFormatters.duration(workout.durationSeconds), detail: "Workout"),
                MetricItem(title: "Pace", value: RunFormatters.pace(workout.paceSecondsPerKm), detail: "Average"),
                MetricItem(title: "Avg HR", value: RunFormatters.number(workout.averageHeartRate, suffix: " bpm"), detail: "HealthKit")
            ])
        }
        .padding(.vertical, 6)
    }
}

struct V1WorkoutRow: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .firstTextBaseline) {
                Text(RunWorkout(workout: workout).displayName)
                    .font(.headline)
                Spacer()
                Text(RunFormatters.shortDate.string(from: workout.startDate))
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Text("\(RunFormatters.distance(workout.distanceMeters)) · \(RunFormatters.duration(workout.durationSeconds)) · \(RunFormatters.pace(workout.paceSecondsPerKm))")
                .font(.caption)
                .foregroundStyle(.secondary)
            Text("Avg HR \(RunFormatters.number(workout.averageHeartRate, suffix: " bpm")) · \(workout.sourceName)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
    }
}

struct TodayView: View {
    var store: RunningAnalysisStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Today", subtitle: "What to know before the next run.")

                CoachCard(
                    title: store.snapshot.readiness.title,
                    value: store.snapshot.readiness.status.label,
                    detail: store.snapshot.readiness.summary,
                    confidence: store.snapshot.readiness.status
                )

                MetricGrid(items: [
                    MetricItem(title: "7-day volume", value: String(format: "%.1f km", store.snapshot.weeklyVolumeKm), detail: "Previous: \(String(format: "%.1f km", store.snapshot.previousWeeklyVolumeKm))"),
                    MetricItem(title: "Easy balance", value: RunFormatters.percent(store.snapshot.easyPercent), detail: "Last 28 days"),
                    MetricItem(title: "Quality balance", value: RunFormatters.percent(store.snapshot.qualityPercent), detail: "Tempo, threshold, interval, race"),
                    MetricItem(title: "Long-run share", value: RunFormatters.percent(store.snapshot.longRunPercent), detail: "Last 28 days")
                ])

                MetricGrid(items: HealthContextMetrics.todayItems(for: store.healthContext))

                InsightCard(insight: store.snapshot.fitnessTrend)

                CoachCard(
                    title: "Next focus",
                    value: "One thing",
                    detail: store.snapshot.readiness.nextFocus,
                    confidence: store.snapshot.readiness.status
                )

                if store.usesSampleData {
                    NoticeCard(title: "Sample data active", message: store.message)
                }
            }
            .padding()
        }
        .navigationTitle("Today")
    }
}

struct LatestRunView: View {
    var store: RunningAnalysisStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Latest Run", subtitle: "Did the most recent outdoor run match its purpose?")

                if let latest = store.latestOutdoorRun {
                    WorkoutSummaryCard(workout: latest)

                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(AnalyticsEngine.latestRunReview(latest)) { insight in
                            InsightCard(insight: insight)
                        }
                    }

                    NavigationLink {
                        WorkoutDetailView(store: store, workoutID: latest.id)
                    } label: {
                        Label("Open detail and labels", systemImage: "slider.horizontal.3")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    EmptyStateView(title: "No latest outdoor run", message: "Load HealthKit or keep using sample data to review a recent run.")
                }
            }
            .padding()
        }
        .navigationTitle("Latest Run")
    }
}

struct RaceGoalView: View {
    var store: RunningAnalysisStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Sub-20 5K", subtitle: "Oct 17, 2026 at 3:59 /km.")

                CoachCard(
                    title: "Readiness",
                    value: store.snapshot.readiness.status.label,
                    detail: store.snapshot.readiness.summary,
                    confidence: store.snapshot.readiness.status
                )

                MetricGrid(items: [
                    MetricItem(title: "Race date", value: "Oct 17", detail: "2026"),
                    MetricItem(title: "Goal pace", value: RunFormatters.pace(RunningGoal.sub20FiveK.targetPaceSecondsPerKm), detail: "Sub-20 5K"),
                    MetricItem(title: "Best 5K", value: RunFormatters.duration(store.snapshot.readiness.bestFiveKSeconds), detail: "Available evidence"),
                    MetricItem(title: "Pace gap", value: paceGapText(store.snapshot.readiness.paceGapSecondsPerKm), detail: "Seconds per km")
                ])

                SectionHeader("Evidence")
                ForEach(store.snapshot.readiness.evidence) { insight in
                    InsightCard(insight: insight)
                }

                SectionHeader("Best efforts")
                if store.snapshot.bestEfforts.isEmpty {
                    EmptyStateView(title: "No best efforts", message: "Need workouts with distance and duration before best efforts can be estimated.")
                } else {
                    VStack(spacing: 10) {
                        ForEach(store.snapshot.bestEfforts) { effort in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(effort.label)
                                        .font(.headline)
                                    Text(RunFormatters.shortDate.string(from: effort.date))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text(RunFormatters.duration(effort.durationSeconds))
                                        .font(.headline.monospacedDigit())
                                    Text(RunFormatters.pace(effort.paceSecondsPerKm))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding()
                            .background(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Race Goal")
    }

    private func paceGapText(_ value: Double?) -> String {
        guard let value else { return "Missing" }
        if value <= 0 { return "At pace" }
        return "+\(Int(value.rounded()))"
    }
}

struct HistoryView: View {
    var store: RunningAnalysisStore
    @State private var searchText = ""
    @State private var selectedType: RunType?
    @State private var confidenceFilter: ConfidenceLevel?

    private var filtered: [CanonicalWorkout] {
        store.workouts.filter { workout in
            let textMatches = searchText.isEmpty
                || workout.effectiveRunType.label.localizedCaseInsensitiveContains(searchText)
                || workout.sourceName.localizedCaseInsensitiveContains(searchText)
                || RunFormatters.date.string(from: workout.startDate).localizedCaseInsensitiveContains(searchText)
            let typeMatches = selectedType == nil || workout.effectiveRunType == selectedType
            let confidenceMatches = confidenceFilter == nil || confidence(for: workout) == confidenceFilter
            return textMatches && typeMatches && confidenceMatches
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Run type", selection: $selectedType) {
                    Text("All").tag(nil as RunType?)
                    ForEach(RunType.allCases) { type in
                        Text(type.label).tag(type as RunType?)
                    }
                }
                Picker("Confidence", selection: $confidenceFilter) {
                    Text("All").tag(nil as ConfidenceLevel?)
                    ForEach(ConfidenceLevel.allCases, id: \.rawValue) { level in
                        Text(level.label).tag(level as ConfidenceLevel?)
                    }
                }
            }

            Section {
                ForEach(filtered) { workout in
                    NavigationLink {
                        WorkoutDetailView(store: store, workoutID: workout.id)
                    } label: {
                        WorkoutRow(workout: workout, confidence: confidence(for: workout))
                    }
                }
            }
        }
        .searchable(text: $searchText)
        .navigationTitle("History")
    }

    private func confidence(for workout: CanonicalWorkout) -> ConfidenceLevel {
        if workout.distanceMeters == nil || workout.durationSeconds <= 0 { return .unavailable }
        if workout.averageHeartRate != nil && workout.seriesAvailable { return .moderate }
        return .limited
    }
}

struct DataView: View {
    var store: RunningAnalysisStore
    @State private var isImportingReviewedRuns = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Data", subtitle: "Trust, permissions, coverage, and duplicate checks.")

                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Label(store.authorizationState.label, systemImage: "heart.text.square")
                            .font(.headline)
                        Spacer()
                        if store.isLoading {
                            ProgressView()
                        }
                    }
                    Text(store.message)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Button {
                        Task { await store.refreshFromHealthKit() }
                    } label: {
                        Label("Load HealthKit Runs", systemImage: "arrow.clockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.isLoading)
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                MetricGrid(items: [
                    MetricItem(title: "Workouts", value: "\(store.snapshot.dataQuality.workoutCount)", detail: "All local records"),
                    MetricItem(title: "Included", value: "\(store.snapshot.dataQuality.includedWorkoutCount)", detail: "Used in analysis"),
                    MetricItem(title: "Duplicates", value: "\(store.snapshot.dataQuality.duplicateCount)", detail: "Excluded candidates"),
                    MetricItem(title: "Confidence", value: store.snapshot.dataQuality.confidence.label, detail: "Current data gate"),
                    MetricItem(title: "Route points", value: "\(store.includedWorkouts.map(\.routePointCount).reduce(0, +))", detail: "Workout routes"),
                    MetricItem(title: "Samples", value: "\(store.includedWorkouts.map(\.seriesSampleCount).reduce(0, +))", detail: "Workout evidence"),
                    MetricItem(title: "Evidence queue", value: "\(store.evidenceQueueSummary.pendingCount)", detail: store.evidenceQueueSummary.nextPriority?.label ?? "No pending")
                ])

                ParityReadinessPanel(store: store)

                HealthKitSyncPanel(store: store)

                RunTypeBridgePanel(store: store, isImporting: $isImportingReviewedRuns)

                SectionHeader("Coverage")
                CoverageRow(label: "Heart rate", value: store.snapshot.dataQuality.heartRateCoverage)
                CoverageRow(label: "Cadence", value: store.snapshot.dataQuality.cadenceCoverage)
                CoverageRow(label: "Power", value: store.snapshot.dataQuality.powerCoverage)
                CoverageRow(label: "Mechanics", value: store.snapshot.dataQuality.mechanicsCoverage)
                CoverageRow(label: "Route", value: store.snapshot.dataQuality.routeCoverage)
                CoverageRow(label: "Series", value: store.snapshot.dataQuality.seriesCoverage)

                NoticeCard(
                    title: "HealthKit detail source",
                    message: "Full loads and syncs now read associated HealthKit samples for route, heart rate, speed, distance, active energy, power, cadence, stride length, vertical oscillation, ground contact time, and workout interval events where available."
                )

                NavigationLink {
                    HealthKitAuditView(store: store)
                } label: {
                    Label("Open HealthKit audit", systemImage: "list.clipboard")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                NavigationLink {
                    PhysicalVerificationView(store: store)
                } label: {
                    Label("Open physical verification", systemImage: "iphone.gen3")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    GoldenValidationView(store: store)
                } label: {
                    Label("Open Apple Fitness validation", systemImage: "checkmark.seal")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                NavigationLink {
                    HealthKitPermissionReviewView(store: store)
                } label: {
                    Label("Open permission review", systemImage: "lock.shield")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                SectionHeader("Health Context")
                MetricGrid(items: HealthContextMetrics.dataItems(for: store.healthContext))
                NoticeCard(
                    title: "Broad HealthKit context",
                    message: "Average HR, max HR, and active energy here come from available HealthKit samples, not workout-scoped analyzer evidence."
                )

                SectionHeader("Caveats")
                if store.snapshot.dataQuality.caveats.isEmpty {
                    NoticeCard(title: "No major caveats", message: "Current sample clears the visible gates.")
                } else {
                    ForEach(store.snapshot.dataQuality.caveats, id: \.self) { caveat in
                        NoticeCard(title: "Data gate", message: caveat)
                    }
                }

                ShareLink(item: store.exportMarkdown) {
                    Label("Share coaching brief", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: store.diagnosticsMarkdown) {
                    Label("Share diagnostics", systemImage: "doc.text.magnifyingglass")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: store.healthKitAuditMarkdown) {
                    Label("Share HealthKit audit", systemImage: "square.and.arrow.up.on.square")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: store.physicalVerificationMarkdown) {
                    Label("Share physical verification", systemImage: "iphone.gen3")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: store.goldenValidationChecklistMarkdown) {
                    Label("Share Apple Fitness checklist", systemImage: "checklist")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: store.goldenValidationFixtureJSON) {
                    Label("Share Apple Fitness JSON fixture", systemImage: "curlybraces")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: store.goldenValidationFixtureCSV) {
                    Label("Share Apple Fitness CSV fixture", systemImage: "tablecells")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .navigationTitle("Data")
        .fileImporter(
            isPresented: $isImportingReviewedRuns,
            allowedContentTypes: [.json, .commaSeparatedText, .plainText],
            allowsMultipleSelection: false
        ) { result in
            guard case let .success(urls) = result, let url = urls.first else { return }
            store.importReviewedRunTypes(from: url)
        }
    }
}

struct HealthKitPermissionReviewView: View {
    var store: RunningAnalysisStore

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Permission Review", subtitle: "RunSignal read-only HealthKit access.")

                NoticeCard(
                    title: "Before HealthKit asks",
                    message: HealthKitPermissionCatalog.permissionExplanation
                )

                MetricGrid(items: [
                    MetricItem(title: "Read types", value: "\(HealthKitPermissionCatalog.readItems.count)", detail: "Requested if SDK supports them"),
                    MetricItem(title: "Write types", value: "0", detail: "Read-only milestone"),
                    MetricItem(title: "Skipped", value: "\(HealthKitPermissionCatalog.intentionallySkipped.count)", detail: "Out of scope"),
                    MetricItem(title: "HR zones", value: "Unverified", detail: "Do not assume Apple zones")
                ])

                ForEach(HealthKitPermissionCatalog.readItems) { item in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(item.displayName)
                                .font(.headline)
                            Spacer()
                            Text(item.scope.rawValue)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Text(item.healthKitIdentifier)
                            .font(.caption.monospaced())
                            .foregroundStyle(.secondary)
                        Text(item.reason)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                ShareLink(item: store.healthKitPermissionReviewMarkdown) {
                    Label("Share permission review", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Permissions")
    }
}

struct GoldenValidationView: View {
    var store: RunningAnalysisStore

    private var results: [GoldenAppleFitnessWorkoutResult] {
        store.goldenValidationResults
    }

    private var summary: GoldenAppleFitnessSummary {
        GoldenAppleFitnessValidation.summary(results: results)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Apple Fitness Validation", subtitle: GoldenAppleFitnessValidation.confidenceLabel)

                NoticeCard(
                    title: "Validation source",
                    message: "Compare these selected HealthKit-derived runs to Apple Fitness display values. Do not use FIT files or the old web dashboard as the reference."
                )

                MetricGrid(items: [
                    MetricItem(title: "Selected", value: "\(summary.selectedCount)", detail: "Recent runs"),
                    MetricItem(title: "Need values", value: "\(summary.needsManualValuesCount)", detail: "Fill from Fitness"),
                    MetricItem(title: "Pass", value: "\(summary.passCount)", detail: "Within tolerance"),
                    MetricItem(title: "Warning", value: "\(summary.warningCount)", detail: "Review mismatch"),
                    MetricItem(title: "Fail", value: "\(summary.failCount)", detail: "Outside tolerance"),
                    MetricItem(title: "Unavailable", value: "\(summary.unavailableCount)", detail: "Missing expected")
                ])

                ShareLink(item: store.goldenValidationFixtureJSON) {
                    Label("Share JSON fixture", systemImage: "curlybraces")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                ShareLink(item: store.goldenValidationFixtureCSV) {
                    Label("Share CSV fixture", systemImage: "tablecells")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)

                ShareLink(item: store.goldenValidationChecklistMarkdown) {
                    Label("Share checklist", systemImage: "checklist")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ForEach(results) { result in
                    GoldenValidationCard(result: result)
                }
            }
            .padding()
        }
        .navigationTitle("Fitness Validation")
    }
}

struct GoldenValidationCard: View {
    let result: GoldenAppleFitnessWorkoutResult

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(RunFormatters.shortDate.string(from: result.workout.startDate))
                        .font(.headline)
                    Text("\(RunFormatters.distance(result.workout.distanceMeters)) · \(RunFormatters.duration(result.workout.durationSeconds)) · \(result.workout.sourceName)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(result.status.label)
                    .font(.caption.bold())
                    .foregroundStyle(color(for: result.status))
            }

            ForEach(result.fieldResults.prefix(6)) { field in
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(field.field)
                            .font(.caption.bold())
                        Text(field.detail)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(field.appValue)
                            .font(.caption.monospacedDigit())
                        Text(field.expectedValue)
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func color(for status: GoldenValidationStatus) -> Color {
        switch status {
        case .pass: .green
        case .warning: .orange
        case .fail: .red
        case .unavailable: .secondary
        }
    }
}

struct HealthKitAuditView: View {
    var store: RunningAnalysisStore

    private var rows: [HealthKitAuditRow] {
        HealthKitAudit.rows(for: store.workouts)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "HealthKit Audit", subtitle: "Per-run evidence found on device.")

                if rows.isEmpty {
                    EmptyStateView(title: "No workouts to audit", message: "Load HealthKit runs or keep sample data available before reviewing field coverage.")
                } else {
                    MetricGrid(items: [
                        MetricItem(title: "Runs", value: "\(rows.count)", detail: "Non-duplicate"),
                        MetricItem(title: "Routes", value: "\(rows.filter { $0.workout.routeAvailable }.count)", detail: "Objects or points"),
                        MetricItem(title: "HR data", value: "\(rows.filter { hasHeartRateData($0.workout) }.count)", detail: "Summary or series"),
                        MetricItem(title: "Dynamics", value: "\(rows.filter { hasRunningDynamics($0.workout) }.count)", detail: "Summary or series"),
                        MetricItem(title: "Pending", value: "\(store.evidenceQueueSummary.pendingCount)", detail: "Evidence queue"),
                        MetricItem(title: "Failed", value: "\(store.evidenceQueueSummary.failedCount)", detail: "Needs review")
                    ])

                    NoticeCard(
                        title: "Read-only audit",
                        message: "This screen reports what HealthKit returned for each workout. The queue enriches bounded batches and skips workouts already cached with detailed evidence."
                    )

                    Button {
                        Task { await store.enrichNextHealthKitAuditBatch() }
                    } label: {
                        if store.isEnrichingAudit {
                            Label("Enriching audit", systemImage: "hourglass")
                                .frame(maxWidth: .infinity)
                        } else {
                            Label("Enrich next pending runs", systemImage: "arrow.down.doc")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(store.isEnrichingAudit || store.isLoading)

                    ForEach(rows) { row in
                        HealthKitAuditCard(row: row)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("HealthKit Audit")
    }

    private func hasRunningDynamics(_ workout: CanonicalWorkout) -> Bool {
        workout.strideLengthSampleCount > 0
            || workout.verticalOscillationSampleCount > 0
            || workout.groundContactTimeSampleCount > 0
            || workout.strideLengthMeters != nil
            || workout.verticalOscillationCentimeters != nil
            || workout.groundContactMilliseconds != nil
    }

    private func hasHeartRateData(_ workout: CanonicalWorkout) -> Bool {
        workout.heartRateSampleCount > 0
            || workout.averageHeartRate != nil
            || workout.maxHeartRate != nil
    }
}

struct HealthKitAuditCard: View {
    let row: HealthKitAuditRow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(row.workout.effectiveRunType.label)
                        .font(.headline)
                    Text("\(RunFormatters.shortDate.string(from: row.workout.startDate)) · \(RunFormatters.distance(row.workout.distanceMeters)) · \(RunFormatters.duration(row.workout.durationSeconds))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ConfidencePill(text: auditStatus.label, confidence: auditStatus)
            }

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ForEach(row.fields) { field in
                    HealthKitAuditFieldTile(field: field)
                }
            }

            if !row.caveats.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Caveats")
                        .font(.caption.bold())
                    ForEach(row.caveats.prefix(3), id: \.self) { caveat in
                        Text(caveat)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var auditStatus: ConfidenceLevel {
        let foundCount = row.fields.filter { $0.confidence != .unavailable }.count
        if foundCount >= 9 { return .strong }
        if foundCount >= 6 { return .moderate }
        if foundCount > 0 { return .limited }
        return .unavailable
    }
}

struct HealthKitAuditFieldTile: View {
    let field: HealthKitAuditField

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack(spacing: 6) {
                Image(systemName: symbol)
                    .foregroundStyle(color)
                    .frame(width: 16)
                Text(field.label)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Text(field.value)
                .font(.subheadline.monospacedDigit().bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(field.detail)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 104, alignment: .topLeading)
        .padding(10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var symbol: String {
        switch field.confidence {
        case .strong, .moderate: "checkmark.circle"
        case .limited, .weak: "exclamationmark.triangle"
        case .blocked: "xmark.octagon"
        case .unavailable: "minus.circle"
        }
    }

    private var color: Color {
        switch field.confidence {
        case .strong: .green
        case .moderate: .blue
        case .limited, .weak: .orange
        case .blocked: .red
        case .unavailable: .secondary
        }
    }
}

struct PhysicalVerificationView: View {
    var store: RunningAnalysisStore

    private var rows: [PhysicalVerificationRow] {
        PhysicalVerificationReport.rows(for: store.workouts)
    }

    private var missingCount: Int {
        rows.filter { $0.workout == nil }.count
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(
                    title: "Physical Verification",
                    subtitle: "Step 6 representative HealthKit evidence checklist."
                )

                MetricGrid(items: [
                    MetricItem(title: "Slots", value: "\(rows.count)", detail: "Required archetypes"),
                    MetricItem(title: "Candidates", value: "\(rows.count - missingCount)", detail: "Loaded workouts"),
                    MetricItem(title: "Missing", value: "\(missingCount)", detail: "Need proof"),
                    MetricItem(title: "Device proof", value: store.authorizationState == .authorized || store.authorizationState == .partial ? "Loaded" : "Pending", detail: "Physical iPhone only")
                ])

                NoticeCard(
                    title: "Physical-device gate",
                    message: "Use this screen after running on the iPhone and loading HealthKit. Simulator sample data can preview layout but does not complete Step 6."
                )

                ForEach(rows) { row in
                    PhysicalVerificationCard(row: row)
                }

                ShareLink(item: store.physicalVerificationMarkdown) {
                    Label("Share physical verification", systemImage: "square.and.arrow.up")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .navigationTitle("Physical Verification")
    }
}

struct PhysicalVerificationCard: View {
    let row: PhysicalVerificationRow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(row.kind.title)
                        .font(.headline)
                    Text(candidateSummary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                ConfidencePill(text: row.decision.label, confidence: row.decision)
            }

            if let workout = row.workout {
                MetricGrid(items: [
                    MetricItem(title: "HR", value: "\(workout.heartRateSampleCount)", detail: "Samples"),
                    MetricItem(title: "Pace data", value: "\(workout.runningSpeedSampleCount + workout.distanceSampleCount)", detail: "Speed/distance"),
                    MetricItem(title: "Route", value: workout.routePointCount > 0 ? "\(workout.routePointCount)" : routeFallbackText(for: workout), detail: "Points"),
                    MetricItem(title: "Events", value: "\(workout.intervalCount)", detail: "Laps/segments"),
                    MetricItem(title: "Mechanics", value: "\(mechanicsCount(for: workout))", detail: "Sample rows"),
                    MetricItem(title: "Trust", value: workout.runTypeTrust.kind.label, detail: workout.effectiveRunType.label)
                ])
            }

            VStack(alignment: .leading, spacing: 5) {
                ForEach(row.notes.prefix(4), id: \.self) { note in
                    Text(note)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var candidateSummary: String {
        guard let workout = row.workout else {
            return "No loaded non-duplicate workout currently matches this required slot."
        }
        return "\(RunFormatters.shortDate.string(from: workout.startDate)) · \(RunFormatters.distance(workout.distanceMeters)) · \(RunFormatters.duration(workout.durationSeconds)) · \(workout.sourceName)"
    }

    private func mechanicsCount(for workout: CanonicalWorkout) -> Int {
        workout.runningPowerSampleCount
            + workout.cadenceSampleCount
            + workout.stepCountSampleCount
            + workout.strideLengthSampleCount
            + workout.verticalOscillationSampleCount
            + workout.groundContactTimeSampleCount
    }

    private func routeFallbackText(for workout: CanonicalWorkout) -> String {
        workout.routeAvailable ? "Object" : "Missing"
    }
}

struct HealthKitSyncPanel: View {
    var store: RunningAnalysisStore

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("HealthKit sync", systemImage: "arrow.triangle.2.circlepath")
                    .font(.headline)
                Spacer()
                ConfidencePill(text: store.syncState.lastSyncAt == nil ? "Not synced" : "Ready", confidence: store.syncState.lastSyncAt == nil ? .limited : .moderate)
            }

            MetricGrid(items: [
                MetricItem(title: "Last sync", value: lastSyncText, detail: "On-device anchor"),
                MetricItem(title: "Fetched", value: "\(store.syncState.lastFetchedCount)", detail: "Changed workouts"),
                MetricItem(title: "Inserted", value: "\(store.syncState.lastInsertedCount)", detail: "New local records"),
                MetricItem(title: "Updated", value: "\(store.syncState.lastUpdatedCount)", detail: "Existing records"),
                MetricItem(title: "Deleted", value: "\(store.syncState.lastDeletedCount)", detail: "Detected only"),
                MetricItem(title: "Evidence", value: "\(store.syncState.lastEvidencePendingCount)", detail: "Pending series")
            ])

            Button {
                Task { await store.syncHealthKitChanges() }
            } label: {
                Label("Sync HealthKit changes", systemImage: "arrow.triangle.2.circlepath")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .disabled(store.isLoading)

            NoticeCard(
                title: "Safe sync mode",
                message: "Deleted HealthKit records are reported here but not removed locally until physical-device behavior is verified."
            )
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var lastSyncText: String {
        guard let lastSyncAt = store.syncState.lastSyncAt else { return "Never" }
        return RunFormatters.date.string(from: lastSyncAt)
    }
}

struct ParityReadinessPanel: View {
    var store: RunningAnalysisStore

    private var insights: [Insight] {
        AnalyticsEngine.parityReadiness(
            dataQuality: store.snapshot.dataQuality,
            pendingSeriesCount: store.syncState.lastEvidencePendingCount,
            reviewedRunTypeCount: store.reviewedRunTypes.count
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Web app parity", systemImage: "checklist")
                    .font(.headline)
                Spacer()
                ConfidencePill(text: "Next build", confidence: .limited)
            }

            Text("This shows which web-dashboard surfaces are ready to trust natively and which still need evidence before they should be promoted.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            VStack(spacing: 8) {
                ForEach(insights) { insight in
                    QualityGateRow(insight: insight)
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct QualityGateRow: View {
    let insight: Insight

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol)
                .foregroundStyle(color)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(insight.title)
                    .font(.subheadline.bold())
                Text(insight.detail)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            ConfidencePill(text: insight.value, confidence: insight.confidence)
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var symbol: String {
        switch insight.confidence {
        case .strong: "checkmark.seal"
        case .moderate: "checkmark.circle"
        case .limited, .weak: "exclamationmark.triangle"
        case .blocked: "xmark.octagon"
        case .unavailable: "xmark.circle"
        }
    }

    private var color: Color {
        switch insight.confidence {
        case .strong: .green
        case .moderate: .blue
        case .limited, .weak: .orange
        case .blocked: .red
        case .unavailable: .secondary
        }
    }
}

struct RunTypeBridgePanel: View {
    var store: RunningAnalysisStore
    @Binding var isImporting: Bool

    private var summary: RunTypeReconciliationSummary {
        store.runTypeReconciliation
    }

    private var reviewRows: [RunTypeReconciliationRow] {
        summary.rows
            .filter { [.weak, .conflict, .webOnly].contains($0.status) }
            .prefix(4)
            .map { $0 }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Label("Web category bridge", systemImage: "arrow.left.arrow.right")
                    .font(.headline)
                Spacer()
                ConfidencePill(text: summary.matchedCount > 0 ? "Linked" : "Ready", confidence: summary.matchedCount > 0 ? .moderate : .limited)
            }

            Text("Import reviewed web-app run types, then match them to iPhone HealthKit workouts by date, time, distance, and duration.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)

            MetricGrid(items: [
                MetricItem(title: "Imported", value: "\(summary.importedCount)", detail: "Reviewed web runs"),
                MetricItem(title: "Matched", value: "\(summary.matchedCount)", detail: "Applied labels"),
                MetricItem(title: "Needs review", value: "\(summary.weakCount + summary.conflictCount)", detail: "Weak or conflicting"),
                MetricItem(title: "iPhone-only", value: "\(summary.phoneOnlyCount)", detail: "No web label")
            ])

            Button {
                isImporting = true
            } label: {
                Label("Import web run categories", systemImage: "square.and.arrow.down")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)

            if summary.importedCount == 0 {
                NoticeCard(
                    title: "No reviewed categories imported",
                    message: "Use a JSON or CSV export with date, optional start time, distance, duration, and category."
                )
            } else if reviewRows.isEmpty {
                NoticeCard(
                    title: "No category conflicts",
                    message: "All imported reviewed categories that could be matched were applied safely."
                )
            } else {
                VStack(spacing: 8) {
                    ForEach(reviewRows) { row in
                        ReconciliationRowView(row: row)
                    }
                }
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ReconciliationRowView: View {
    let row: RunTypeReconciliationRow

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: symbol)
                .foregroundStyle(color)
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.bold())
                Text(row.reason)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            if let runType = row.matchedRunType {
                ConfidencePill(text: runType.label, confidence: row.confidence)
            }
        }
        .padding()
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var title: String {
        switch row.status {
        case .matched: "Matched"
        case .weak: "Weak match"
        case .conflict: "Label conflict"
        case .webOnly: "Web-only run"
        case .phoneOnly: "iPhone-only run"
        }
    }

    private var symbol: String {
        switch row.status {
        case .matched: "checkmark.circle"
        case .weak: "questionmark.circle"
        case .conflict: "exclamationmark.triangle"
        case .webOnly: "globe"
        case .phoneOnly: "iphone"
        }
    }

    private var color: Color {
        switch row.status {
        case .matched: .green
        case .weak: .orange
        case .conflict: .red
        case .webOnly, .phoneOnly: .secondary
        }
    }
}

struct WorkoutDetailView: View {
    var store: RunningAnalysisStore
    let workoutID: String

    private var workout: CanonicalWorkout? {
        store.workouts.first { $0.id == workoutID }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let workout {
                    WorkoutSummaryCard(workout: workout)

                    FitnessWorkoutMetrics(workout: workout)

                    RouteAndSeriesPanel(workout: workout)

                    WorkoutChartsPanel(workout: workout)

                    SplitsAndEventsPanel(
                        workout: workout,
                        segments: RunWorkoutSegments(workout: workout, analysis: store.derivedAnalysis(for: workout.id))
                    )

                    NavigationLink {
                        RawHealthKitWorkoutDebugView(store: store, workout: workout)
                    } label: {
                        Label("Open Raw HealthKit Debug", systemImage: "stethoscope")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    EmptyStateView(title: "Workout missing", message: "The selected workout is no longer in local state.")
                }
            }
            .padding()
            .padding(.bottom, 120)
        }
        .navigationTitle("Workout")
    }
}

struct FitnessWorkoutMetrics: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Workout Details")
            MetricGrid(items: [
                MetricItem(title: "Workout time", value: RunFormatters.duration(workout.durationSeconds), detail: elapsedDetail),
                MetricItem(title: "Distance", value: RunFormatters.distance(workout.distanceMeters), detail: "HKWorkout"),
                MetricItem(title: "Active calories", value: RunFormatters.calories(workout.activeEnergyKilocalories), detail: "HealthKit"),
                MetricItem(title: "Total calories", value: totalCaloriesText, detail: totalCaloriesDetail),
                MetricItem(title: "Avg pace", value: RunFormatters.pace(workout.paceSecondsPerKm), detail: "Distance/time"),
                MetricItem(title: "Avg heart rate", value: RunFormatters.number(workout.averageHeartRate, suffix: " bpm"), detail: "Workout-scoped"),
                MetricItem(title: "Max heart rate", value: RunFormatters.number(workout.maxHeartRate, suffix: " bpm"), detail: "If available"),
                MetricItem(title: "Avg power", value: RunFormatters.number(workout.averagePower, suffix: " W"), detail: workout.runningPowerSampleCount > 0 ? "Series" : "Summary"),
                MetricItem(title: "Avg cadence", value: RunFormatters.number(workout.fullStepCadence, suffix: " spm"), detail: "Full steps/min"),
                MetricItem(title: "Elevation", value: RunFormatters.number(workout.elevationGainMeters, suffix: " m"), detail: workout.routePointCount > 0 ? "Route altitude" : "Unavailable")
            ])
        }
    }

    private var elapsedDetail: String {
        let elapsed = workout.elapsedSeconds > 0 ? workout.elapsedSeconds : workout.durationSeconds
        return abs(elapsed - workout.durationSeconds) <= 2
            ? "Elapsed matches"
            : "Elapsed \(RunFormatters.duration(elapsed))"
    }

    private var totalCaloriesText: String {
        workout.totalEnergyKilocalories.map { RunFormatters.calories($0) } ?? "Unavailable"
    }

    private var totalCaloriesDetail: String {
        workout.totalEnergyKilocalories == nil ? "Not shown without trustworthy evidence" : "HealthKit evidence"
    }
}

struct RouteAndSeriesPanel: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Route")
            if let route = workout.evidence?.route, route.count >= 2 {
                WorkoutRouteMap(route: route)
            }
            NoticeCard(
                title: routeTitle,
                message: routeMessage
            )
        }
    }

    private var routeTitle: String {
        if coordinateCount >= 2 { return "Route map available" }
        if workout.routePointCount > 0 { return "Route points loaded" }
        if workout.routeAvailable { return "Route object available" }
        return "Route unavailable"
    }

    private var routeMessage: String {
        if coordinateCount >= 2 {
            return "\(coordinateCount) route points loaded from HealthKit and rendered on the map."
        }
        if workout.routePointCount > 0 {
            return "\(workout.routePointCount) route points are recorded in the workout summary, but coordinate evidence is not attached to this view yet."
        }
        if workout.routeAvailable {
            return "HealthKit exposed a route object, but point locations have not been loaded yet."
        }
        return "No route was returned for this workout."
    }

    private var coordinateCount: Int {
        workout.evidence?.route.count ?? 0
    }
}

struct WorkoutRouteMap: View {
    let route: [WorkoutRoutePoint]

    private var coordinates: [CLLocationCoordinate2D] {
        route.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private var region: MKCoordinateRegion {
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)
        guard let minLatitude = latitudes.min(),
              let maxLatitude = latitudes.max(),
              let minLongitude = longitudes.min(),
              let maxLongitude = longitudes.max() else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }

        let latitudeDelta = max((maxLatitude - minLatitude) * 1.35, 0.005)
        let longitudeDelta = max((maxLongitude - minLongitude) * 1.35, 0.005)
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: (minLatitude + maxLatitude) / 2,
                longitude: (minLongitude + maxLongitude) / 2
            ),
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        )
    }

    var body: some View {
        Map(initialPosition: .region(region)) {
            MapPolyline(coordinates: coordinates)
                .stroke(.blue, lineWidth: 4)
            if let start = coordinates.first {
                Marker("Start", systemImage: "play.fill", coordinate: start)
            }
            if let finish = coordinates.last {
                Marker("Finish", systemImage: "flag.checkered", coordinate: finish)
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel("Workout route map")
    }
}

struct WorkoutChartsPanel: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Charts")
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                ChartAvailabilityTile(label: "Heart rate", count: workout.heartRateSampleCount)
                ChartAvailabilityTile(label: "Pace / speed", count: workout.runningSpeedSampleCount + workout.distanceSampleCount)
                ChartAvailabilityTile(label: "Power", count: workout.runningPowerSampleCount)
                ChartAvailabilityTile(label: "Cadence", count: workout.cadenceSampleCount + workout.stepCountSampleCount)
                ChartAvailabilityTile(label: "Vertical oscillation", count: workout.verticalOscillationSampleCount)
                ChartAvailabilityTile(label: "Ground contact", count: workout.groundContactTimeSampleCount)
                ChartAvailabilityTile(label: "Stride length", count: workout.strideLengthSampleCount)
                ChartAvailabilityTile(label: "Elevation", count: workout.routePointCount)
            }
        }
    }
}

struct ChartAvailabilityTile: View {
    let label: String
    let count: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: count > 0 ? "waveform.path.ecg" : "minus.circle")
                    .foregroundStyle(count > 0 ? .blue : .secondary)
                Spacer()
                Text(count > 0 ? "\(count)" : "Unavailable")
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            Text(label)
                .font(.subheadline.bold())
                .lineLimit(2)
            Text(count > 0 ? "HealthKit samples loaded" : "No samples returned")
                .font(.caption2)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .topLeading)
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct SplitsAndEventsPanel: View {
    let workout: CanonicalWorkout
    let segments: RunWorkoutSegments

    var body: some View {
        let supportedIntervals = normalDetailCustomWorkoutIntervals
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("1 km Splits")
            if segments.kilometerSplits.isEmpty {
                EmptyStateView(title: "Splits unavailable", message: "RunSignal needs distance samples or enough workout distance/time to estimate 1 km splits.")
            } else {
                VStack(spacing: 8) {
                    ForEach(segments.kilometerSplits.prefix(12), id: \.label) { split in
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text(split.label)
                                    .font(.subheadline.bold())
                                Text(split.confidence == .moderate ? "HealthKit distance series" : "Fallback estimate")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 3) {
                                Text(RunFormatters.duration(split.durationSecondsEstimate))
                                    .font(.subheadline.monospacedDigit().bold())
                                Text(RunFormatters.pace(split.paceSecondsPerKmEstimate))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(10)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }

            SectionHeader("Apple Fitness Intervals")
            if let supportedIntervals {
                VStack(spacing: 8) {
                    ForEach(supportedIntervals.intervals, id: \.index) { interval in
                        IntervalRowView(interval: interval)
                    }
                }
            } else {
                NoticeCard(
                    title: segments.eventSummary.hasEvents ? "Not comparable yet" : "Unavailable",
                    message: intervalMessage
                )
            }
        }
    }

    private var normalDetailCustomWorkoutIntervals: WorkoutIntervalReconstructionResult? {
        guard let evidence = workout.evidence else { return nil }
        return CustomWorkoutNormalDetailGate.supportedIntervals(
            workout: workout,
            evidence: evidence
        )
    }

    private var intervalMessage: String {
        if !segments.eventSummary.hasEvents {
            return "HealthKit did not return workout events for this run. RunSignal cannot show Apple Fitness-style Warmup, Work, Recovery, Cooldown, or Open rows yet."
        }
        return "HealthKit returned \(segments.eventSummary.healthKitSummary), but not the full Apple Fitness interval table with distance, time, pace, and heart rate. RunSignal hides those raw marker durations here because they are not the same as Apple Fitness Intervals. Use Raw HealthKit Debug if you need to inspect the raw events."
    }
}

private struct IntervalRowView: View {
    let interval: ReconstructedWorkoutInterval

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("\(interval.index). \(interval.label)")
                        .font(.subheadline.bold())
                    Text(interval.plannedGoalDisplayText)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing, spacing: 3) {
                    Text(RunFormatters.duration(interval.actualDurationSeconds))
                        .font(.subheadline.monospacedDigit().bold())
                    Text(RunFormatters.distance(interval.actualDistanceMeters))
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
            MetricGrid(items: [
                MetricItem(title: "Pace", value: RunFormatters.pace(interval.actualPaceSecondsPerKm), detail: "Derived"),
                MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: "Window"),
                MetricItem(title: "Power", value: RunFormatters.number(interval.averagePower, suffix: " W"), detail: "Avg")
            ])
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct RawHealthKitWorkoutDebugView: View {
    var store: RunningAnalysisStore
    let workout: CanonicalWorkout
    @State private var selectedDiagnosticsMonth = Date()
    @State private var showingMonthlyExportSheet = false

    var body: some View {
        let workout = currentWorkout
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Raw HealthKit Debug", subtitle: "Per-workout fields and evidence counts.")

                Button {
                    Task {
                        await store.forceReenrichEvidenceForParity(workoutID: workout.id)
                    }
                } label: {
                    Label("Force re-enrich selected workout", systemImage: "arrow.clockwise")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.isEnrichingAudit)

                if let result = store.parityForceReenrichResults[workout.id] {
                    NoticeCard(
                        title: "Last force re-enrich",
                        message: forceReenrichSummary(result)
                    )
                }

                ShareLink(item: parityPacketJSON) {
                    Label("Share parity packet JSON", systemImage: "shippingbox")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: rawDebugExportMarkdown) {
                    Label("Share raw debug export", systemImage: "doc.text.magnifyingglass")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                SectionHeader("Monthly Diagnostics")
                DatePicker(
                    "Select month",
                    selection: $selectedDiagnosticsMonth,
                    displayedComponents: [.date]
                )
                .datePickerStyle(.compact)

                Button {
                    Task {
                        await store.refreshEvidenceForMonth(containing: selectedDiagnosticsMonth)
                    }
                } label: {
                    Label("Refresh Month Evidence", systemImage: "arrow.triangle.2.circlepath")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(store.isEnrichingAudit)

                Button {
                    Task {
                        await store.refreshEvidenceForMonth(containing: selectedDiagnosticsMonth)
                        showingMonthlyExportSheet = true
                    }
                } label: {
                    Label("Refresh + Export Month", systemImage: "square.and.arrow.up.on.square")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(store.isEnrichingAudit)

                ShareLink(item: monthlyDiagnosticsJSON) {
                    Label("Export Monthly Diagnostics JSON", systemImage: "calendar.badge.clock")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                ShareLink(item: monthlyDiagnosticsMarkdown) {
                    Label("Export Monthly Diagnostics Summary", systemImage: "calendar")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)

                MetricGrid(items: [
                    MetricItem(title: "UUID", value: workout.id, detail: "HKWorkout"),
                    MetricItem(title: "Source", value: workout.sourceName, detail: workout.sourceID),
                    MetricItem(title: "Device", value: workout.deviceName ?? "Unavailable", detail: "HealthKit"),
                    MetricItem(title: "Start", value: RunFormatters.date.string(from: workout.startDate), detail: "HealthKit"),
                    MetricItem(title: "End", value: RunFormatters.date.string(from: workout.endDate), detail: "HealthKit"),
                    MetricItem(title: "Duration", value: RunFormatters.duration(workout.durationSeconds), detail: "Workout"),
                    MetricItem(title: "Distance", value: RunFormatters.distance(workout.distanceMeters), detail: "Summary"),
                    MetricItem(title: "Active energy", value: RunFormatters.calories(workout.activeEnergyKilocalories), detail: "Summary/samples"),
                    MetricItem(title: "Total energy", value: workout.totalEnergyKilocalories.map { RunFormatters.calories($0) } ?? "Unavailable", detail: "Trust gated")
                ])

                SectionHeader("Sample Counts")
                MetricGrid(items: [
                    MetricItem(title: "Heart rate", value: "\(workout.heartRateSampleCount)", detail: metricSourceText(summary: workout.averageHeartRate != nil, samples: workout.heartRateSampleCount)),
                    MetricItem(title: "Speed", value: "\(workout.runningSpeedSampleCount)", detail: metricSourceText(summary: false, samples: workout.runningSpeedSampleCount)),
                    MetricItem(title: "Power", value: "\(workout.runningPowerSampleCount)", detail: metricSourceText(summary: workout.averagePower != nil, samples: workout.runningPowerSampleCount)),
                    MetricItem(title: "Step count", value: "\(workout.stepCountSampleCount)", detail: metricSourceText(summary: false, samples: workout.stepCountSampleCount)),
                    MetricItem(title: "Cadence", value: "\(workout.cadenceSampleCount)", detail: metricSourceText(summary: workout.fullStepCadence != nil, samples: workout.cadenceSampleCount)),
                    MetricItem(title: "Vertical osc.", value: "\(workout.verticalOscillationSampleCount)", detail: metricSourceText(summary: workout.verticalOscillationCentimeters != nil, samples: workout.verticalOscillationSampleCount)),
                    MetricItem(title: "Ground contact", value: "\(workout.groundContactTimeSampleCount)", detail: metricSourceText(summary: workout.groundContactMilliseconds != nil, samples: workout.groundContactTimeSampleCount)),
                    MetricItem(title: "Stride length", value: "\(workout.strideLengthSampleCount)", detail: metricSourceText(summary: workout.strideLengthMeters != nil, samples: workout.strideLengthSampleCount)),
                    MetricItem(title: "Route points", value: "\(workout.routePointCount)", detail: workout.routeAvailable ? "Route available" : "Unavailable"),
                    MetricItem(title: "Events", value: "\(workout.intervalCount)", detail: intervalDetail)
                ])

                SectionHeader("Direct vs Calculated")
                VStack(alignment: .leading, spacing: 8) {
                    DebugMetricProvenanceRow(label: "Distance", value: workout.distanceMeters == nil ? "Unavailable" : "Direct HKWorkout summary")
                    DebugMetricProvenanceRow(label: "Avg pace", value: workout.paceSecondsPerKm == nil ? "Unavailable" : "Calculated by RunSignal from distance/time")
                    DebugMetricProvenanceRow(label: "Avg cadence", value: cadenceProvenance)
                    DebugMetricProvenanceRow(label: "Total calories", value: workout.totalEnergyKilocalories == nil ? "Unavailable; not inferred" : "Trust-gated HealthKit evidence")
                    DebugMetricProvenanceRow(label: "1 km splits", value: workout.distanceSampleCount > 1 ? "Calculated from distance series" : "Fallback distance/time estimate when shown")
                }

                SectionHeader("WorkoutKit Plan Audit")
                workoutPlanAuditView

                SectionHeader("WorkoutKit Reconstructed Intervals")
                reconstructedIntervalsView

                SectionHeader("Parity Lab Candidate Rows")
                parityLabCandidateRowsView

                SectionHeader("HealthKit Segment Markers")
                NoticeCard(
                    title: "Raw debug only",
                    message: "HealthKit segment markers are raw/debug-only and do not represent Apple Fitness custom workout interval rows for this workout."
                )
                if derivedIntervalCandidates.isEmpty {
                    NoticeCard(
                        title: "Unavailable",
                        message: "RunSignal did not find usable HealthKit event windows with enough evidence to inspect segment markers."
                    )
                } else {
                    VStack(spacing: 8) {
                        ForEach(derivedIntervalCandidates, id: \.index) { interval in
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
                                        Text("\(interval.index). \(interval.label.displayName)")
                                            .font(.subheadline.bold())
                                        Text("\(interval.markerKind.displayName) · \(interval.source.displayName) · \(interval.confidence.label)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(RunFormatters.duration(interval.durationSeconds))
                                            .font(.subheadline.monospacedDigit().bold())
                                        Text(RunFormatters.distance(interval.distanceMeters))
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                Text("\(RunFormatters.duration(interval.startOffsetSeconds)) -> \(RunFormatters.duration(interval.endOffsetSeconds)) from workout start")
                                    .font(.caption2.monospacedDigit())
                                    .foregroundStyle(.secondary)
                                MetricGrid(items: [
                                    MetricItem(title: "Pace", value: RunFormatters.pace(interval.paceSecondsPerKm), detail: "Derived"),
                                    MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: "Window")
                                ])
                                if !interval.caveats.isEmpty {
                                    Text(interval.caveats.joined(separator: " "))
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(10)
                            .background(.background)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Debug")
        .onAppear {
            selectedDiagnosticsMonth = currentWorkout.startDate
        }
        .sheet(isPresented: $showingMonthlyExportSheet) {
            NavigationStack {
                VStack(alignment: .leading, spacing: 14) {
                    HeaderBlock(title: "Export Monthly Diagnostics", subtitle: "Share the refreshed month bundle.")
                    ShareLink(item: monthlyDiagnosticsJSON) {
                        Label("Export Monthly Diagnostics JSON", systemImage: "calendar.badge.clock")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    ShareLink(item: monthlyDiagnosticsMarkdown) {
                        Label("Export Monthly Diagnostics Summary", systemImage: "calendar")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    Spacer()
                }
                .padding()
                .navigationTitle("Monthly Export")
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Done") {
                            showingMonthlyExportSheet = false
                        }
                    }
                }
            }
            .presentationDetents([.medium])
        }
    }

    private var derivedIntervalCandidates: [DerivedWorkoutInterval] {
        guard let evidence = currentWorkout.evidence else { return [] }
        return DerivedAnalyticsEngine.intervalCandidates(workout: currentWorkout, evidence: evidence)
    }

    private var reconstructedIntervals: WorkoutIntervalReconstructionResult? {
        guard let evidence = currentWorkout.evidence else { return nil }
        return WorkoutIntervalReconstructionEngine.reconstruct(workout: currentWorkout, evidence: evidence)
    }

    private var rawDebugExportMarkdown: String {
        DiagnosticsExport.rawHealthKitDebugMarkdown(workout: currentWorkout)
    }

    private var parityPacketJSON: String {
        store.parityPacketJSON(for: currentWorkout)
    }

    private var monthlyDiagnosticsJSON: String {
        store.monthlyDiagnosticsJSON(selectedMonth: selectedDiagnosticsMonth)
    }

    private var monthlyDiagnosticsMarkdown: String {
        store.monthlyDiagnosticsMarkdown(selectedMonth: selectedDiagnosticsMonth)
    }

    private var currentWorkout: CanonicalWorkout {
        store.workouts.first { $0.id == workout.id } ?? workout
    }

    private var intervalDetail: String {
        if let summary = currentWorkout.intervalLabelsSummary { return summary }
        if currentWorkout.intervalCount > 0 { return "Events found; labels unavailable" }
        return "Unavailable"
    }

    private var cadenceProvenance: String {
        if currentWorkout.cadenceSampleCount > 0 {
            return "Direct cadence samples; displayed as full steps/min"
        }
        if currentWorkout.stepCountSampleCount > 0 {
            return "Calculated from step samples as full steps/min"
        }
        if currentWorkout.fullStepCadence != nil {
            return "Summary value normalized to full steps/min"
        }
        return "Unavailable"
    }

    private func forceReenrichSummary(_ result: ParityForceReenrichResult) -> String {
        let status = result.freshQueryReturnedWorkout ? "Fresh HealthKit query returned this workout." : "Fresh HealthKit query did not return this workout."
        let counts = result.evidenceCounts.map {
            "Counts: distance \($0.distance), heart rate \($0.heartRate), route \($0.routePoints), events \($0.events)."
        } ?? "Counts unavailable."
        return [
            "Cache present before refresh: \(result.cacheWasPresent ? "yes" : "no").",
            "Cache invalidated: \(result.invalidatedCache ? "yes" : "no").",
            status,
            counts,
            result.message
        ].compactMap { $0 }.joined(separator: " ")
    }

    @ViewBuilder
    private var workoutPlanAuditView: some View {
        if let audit = currentWorkout.evidence?.workoutPlanAudit {
            VStack(alignment: .leading, spacing: 8) {
                MetricGrid(items: [
                    MetricItem(title: "Status", value: audit.status.label, detail: "WorkoutKit"),
                    MetricItem(title: "Plan type", value: audit.planType ?? "Unavailable", detail: audit.planID ?? "No plan ID")
                ])

                if let displayName = audit.displayName {
                    DebugMetricProvenanceRow(label: "Display name", value: displayName)
                }
                if let errorMessage = audit.errorMessage {
                    DebugMetricProvenanceRow(label: "Error", value: errorMessage)
                }
                if audit.summaryLines.isEmpty {
                    NoticeCard(title: "No public plan fields", message: "WorkoutKit did not return public custom-workout structure for this completed workout.")
                } else {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(Array(audit.summaryLines.enumerated()), id: \.offset) { _, line in
                            Text(line)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                    .padding(10)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        } else {
            NoticeCard(title: "Not audited", message: "Reload HealthKit evidence on the physical iPhone to check whether WorkoutKit exposes a completed workout plan.")
        }
    }

    @ViewBuilder
    private var reconstructedIntervalsView: some View {
        if let result = reconstructedIntervals {
            VStack(alignment: .leading, spacing: 8) {
                MetricGrid(items: [
                    MetricItem(title: "Plan source", value: result.planSource.label, detail: "Structure"),
                    MetricItem(title: "Window source", value: result.windowSource.label, detail: "Segment markers not used")
                ])

                ForEach(result.intervals, id: \.index) { interval in
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(interval.index). \(interval.label)")
                                    .font(.subheadline.bold())
                                Text("\(interval.plannedGoalDisplayText) · \(interval.plannedTargetDisplayText ?? "Target unavailable")")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 3) {
                                Text(RunFormatters.duration(interval.actualDurationSeconds))
                                    .font(.subheadline.monospacedDigit().bold())
                                Text(RunFormatters.distance(interval.actualDistanceMeters))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }

                        MetricGrid(items: [
                            MetricItem(title: "Pace", value: RunFormatters.pace(interval.actualPaceSecondsPerKm), detail: "Derived"),
                            MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: "Window"),
                            MetricItem(title: "Max HR", value: RunFormatters.number(interval.maxHeartRateBpm, suffix: " bpm"), detail: "Window"),
                            MetricItem(title: "Power", value: RunFormatters.number(interval.averagePower, suffix: " W"), detail: "Avg")
                        ])

                        Text("\(interval.confidence.label) · \(interval.sourceNote)")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .padding(10)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                if !result.notes.isEmpty {
                    Text(result.notes.joined(separator: " · "))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        } else {
            NoticeCard(
                title: "Unavailable",
                message: "RunSignal needs a WorkoutKit plan and HealthKit distance/time evidence before it can reconstruct custom workout intervals."
            )
        }
    }

    @ViewBuilder
    private var parityLabCandidateRowsView: some View {
        let result = parityLabCandidateRowsResult
        VStack(alignment: .leading, spacing: 10) {
            NoticeCard(
                title: "Debug-only",
                message: "Candidate rows are for Parity Lab inspection only. They do not replace the normal workout detail intervals."
            )

            if let unavailableReason = result.unavailableReason {
                NoticeCard(title: "Unavailable", message: unavailableReason)
            } else {
                MetricGrid(items: [
                    MetricItem(title: "Status", value: result.structuredStatus, detail: "Structured gate"),
                    MetricItem(title: "Fallback", value: result.primaryFallbackReason ?? "None", detail: "Primary reason"),
                    MetricItem(title: "Rows", value: "\(result.rows.count)", detail: "Candidate"),
                    MetricItem(title: "Open tails", value: "\(result.rows.filter(\.isOpenTail).count)", detail: "Inferred"),
                    MetricItem(title: "Pauses", value: "\(result.pairedPauseCount)", detail: RunFormatters.duration(result.totalPairedPauseSeconds)),
                    MetricItem(title: "Scope", value: "Debug", detail: "No production change")
                ])

                ForEach(result.rows) { row in
                    VStack(alignment: .leading, spacing: 9) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("\(row.index). \(row.label)")
                                    .font(.subheadline.bold())
                                Text(row.detail)
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text(row.isOpenTail ? "Open / Extra" : "Planned")
                                .font(.caption.bold())
                                .foregroundStyle(row.isOpenTail ? .orange : .secondary)
                        }

                        MetricGrid(items: [
                            MetricItem(title: "Elapsed", value: RunFormatters.duration(row.elapsedDurationSeconds), detail: "Wall-clock row"),
                            MetricItem(title: "Pause", value: RunFormatters.duration(row.pauseOverlapSeconds), detail: "Paired overlap"),
                            MetricItem(title: "Active", value: RunFormatters.duration(row.activeDurationSeconds), detail: row.durationRule),
                            MetricItem(title: "Distance", value: RunFormatters.distance(row.distanceMeters), detail: row.mappingStatus)
                        ])

                        Text("\(RunFormatters.duration(row.startOffsetSeconds)) -> \(RunFormatters.duration(row.endOffsetSeconds)) from workout start")
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(.secondary)
                    }
                    .padding(10)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }

    private var parityLabCandidateRowsResult: ParityLabCandidateRowsResult {
        guard let evidence = currentWorkout.evidence else {
            return ParityLabCandidateRowsResult(unavailableReason: "Reload HealthKit evidence on the physical iPhone before inspecting candidate rows.")
        }
        guard let audit = evidence.workoutPlanAudit, !audit.plannedSteps.isEmpty else {
            return ParityLabCandidateRowsResult(unavailableReason: "WorkoutKit planned steps are missing for this workout.")
        }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        guard !activities.isEmpty else {
            return ParityLabCandidateRowsResult(unavailableReason: "HealthKit workout activity rows are missing for this workout.")
        }
        guard activities.count == plannedSteps.count else {
            return ParityLabCandidateRowsResult(unavailableReason: "HealthKit activity row count does not match WorkoutKit planned step count.")
        }
        for index in activities.indices {
            let activity = activities[index]
            guard let endDate = activity.endDate, endDate > activity.startDate else {
                return ParityLabCandidateRowsResult(unavailableReason: "HealthKit activity row \(index + 1) is missing a completed end boundary.")
            }
            if index > 0, let previousEndDate = activities[index - 1].endDate {
                let gap = abs(activity.startDate.timeIntervalSince(previousEndDate))
                if gap > 1 {
                    return ParityLabCandidateRowsResult(unavailableReason: "HealthKit activity row \(index + 1) is not contiguous with the prior activity.")
                }
            }
        }

        let pauses = pairedPauseIntervals(in: evidence.events)
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: plannedSteps,
            activities: activities,
            workout: currentWorkout
        )
        var rows = zip(plannedSteps, activities).enumerated().map { offset, pair in
            let (step, activity) = pair
            let startOffset = activity.startDate.timeIntervalSince(currentWorkout.startDate)
            let endOffset = activity.endDate?.timeIntervalSince(currentWorkout.startDate)
            let elapsed = activity.endDate?.timeIntervalSince(activity.startDate) ?? activity.durationSeconds
            let pauseOverlap = pauseOverlapSeconds(startOffset: startOffset, endOffset: endOffset, pauses: pauses)
            return ParityLabCandidateRow(
                index: step.index,
                label: step.label,
                detail: "\(step.stepType.displayName) · \(step.plannedGoalDisplayText)",
                startOffsetSeconds: startOffset,
                endOffsetSeconds: endOffset,
                elapsedDurationSeconds: elapsed,
                pauseOverlapSeconds: pauseOverlap,
                activeDurationSeconds: max(0, elapsed - pauseOverlap),
                distanceMeters: activityDistanceMeters(activity),
                durationRule: "Active duration",
                mappingStatus: "Activity row \(offset + 1)",
                isOpenTail: false
            )
        }

        let mappedDistance = rows.compactMap(\.distanceMeters).reduce(0, +)
        if let lastEndDate = activities.last?.endDate {
            let remainingSeconds = currentWorkout.endDate.timeIntervalSince(lastEndDate)
            let remainingMeters = currentWorkout.distanceMeters.map { max(0, $0 - mappedDistance) }
            if remainingSeconds > 0.5 || (remainingMeters ?? 0) > 0.5 {
                let startOffset = lastEndDate.timeIntervalSince(currentWorkout.startDate)
                rows.append(
                    ParityLabCandidateRow(
                        index: rows.count + 1,
                        label: "Open / Extra",
                        detail: "Inferred after fixed planned rows",
                        startOffsetSeconds: startOffset,
                        endOffsetSeconds: currentWorkout.endDate.timeIntervalSince(currentWorkout.startDate),
                        elapsedDurationSeconds: remainingSeconds,
                        pauseOverlapSeconds: 0,
                        activeDurationSeconds: remainingSeconds,
                        distanceMeters: remainingMeters,
                        durationRule: "Measured tail",
                        mappingStatus: "Workout end tail",
                        isOpenTail: true
                    )
                )
            }
        }

        return ParityLabCandidateRowsResult(
            rows: rows,
            structuredStatus: comparison.status.rawValue,
            fallbackReasons: comparison.fallbackReasons.map(\.rawValue),
            pairedPauseCount: pauses.count,
            totalPairedPauseSeconds: pauses.map(\.durationSeconds).reduce(0, +)
        )
    }

    private func pairedPauseIntervals(in events: [WorkoutEvidenceEvent]) -> [ParityLabPauseInterval] {
        var pendingPause: Double?
        var intervals: [ParityLabPauseInterval] = []
        for event in events.sorted(by: { $0.startDate < $1.startDate }) {
            let label = event.displayLabel.lowercased()
            let offset = event.startDate.timeIntervalSince(currentWorkout.startDate)
            if label.contains("pause") && !label.contains("resume") {
                pendingPause = offset
            } else if label.contains("resume"), let start = pendingPause {
                intervals.append(
                    ParityLabPauseInterval(
                        startOffsetSeconds: start,
                        endOffsetSeconds: offset,
                        durationSeconds: max(0, offset - start)
                    )
                )
                pendingPause = nil
            }
        }
        return intervals
    }

    private func pauseOverlapSeconds(
        startOffset: Double,
        endOffset: Double?,
        pauses: [ParityLabPauseInterval]
    ) -> Double {
        guard let endOffset, endOffset > startOffset else { return 0 }
        return pauses.reduce(0) { total, pause in
            let overlapStart = max(startOffset, pause.startOffsetSeconds)
            let overlapEnd = min(endOffset, pause.endOffsetSeconds)
            return total + max(0, overlapEnd - overlapStart)
        }
    }

    private func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activity.statistics.first {
            $0.quantityType == "HKQuantityTypeIdentifierDistanceWalkingRunning"
        }?.sum
    }

    private func metricSourceText(summary: Bool, samples: Int) -> String {
        if samples > 0 { return "Direct samples" }
        if summary { return "Summary only" }
        return "Unavailable"
    }

    private struct ParityLabCandidateRowsResult {
        var rows: [ParityLabCandidateRow] = []
        var unavailableReason: String?
        var structuredStatus: String = CustomWorkoutComparisonStatus.missingRequiredEvidence.rawValue
        var fallbackReasons: [String] = []
        var pairedPauseCount: Int = 0
        var totalPairedPauseSeconds: Double = 0

        var primaryFallbackReason: String? {
            fallbackReasons.first
        }
    }

    private struct ParityLabCandidateRow: Identifiable {
        var id: Int { index }
        var index: Int
        var label: String
        var detail: String
        var startOffsetSeconds: Double
        var endOffsetSeconds: Double?
        var elapsedDurationSeconds: Double
        var pauseOverlapSeconds: Double
        var activeDurationSeconds: Double
        var distanceMeters: Double?
        var durationRule: String
        var mappingStatus: String
        var isOpenTail: Bool
    }

    private struct ParityLabPauseInterval {
        var startOffsetSeconds: Double
        var endOffsetSeconds: Double
        var durationSeconds: Double
    }
}

struct DebugMetricProvenanceRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack(alignment: .top) {
            Text(label)
                .font(.subheadline.bold())
            Spacer()
            Text(value)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ExecutionAnalysisCard: View {
    let workout: CanonicalWorkout
    let analysis: DerivedWorkoutAnalysis?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Execution Analysis")
                        .font(.headline)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                ConfidencePill(text: confidence.label, confidence: confidence)
            }

            if let analysis {
                MetricGrid(items: [
                    MetricItem(title: "Pace basis", value: RunFormatters.pace(analysis.paceSecondsPerKmEstimate), detail: analysis.paceConfidence.label),
                    MetricItem(title: "Pacing shape", value: analysis.pacingShape ?? "Missing", detail: analysis.pacingShapeConfidence.label),
                    MetricItem(title: "HR drift", value: driftText(analysis.heartRateDriftPercent), detail: analysis.heartRateDriftConfidence.label),
                    MetricItem(title: "Intervals", value: "\(analysis.intervalCount)", detail: analysis.intervalConfidence.label),
                    MetricItem(title: "Mechanics", value: mechanicsSummary(analysis), detail: analysis.mechanicsConfidence.label),
                    MetricItem(title: "Data quality", value: analysis.dataQualityConfidence.label, detail: analysis.calculationVersion)
                ])

                let segments = analysis.executionSegments ?? []
                if !segments.isEmpty {
                    SectionHeader("HR Drift / Pace Shape")
                    ExecutionShapeVisual(
                        segments: segments,
                        driftPercent: analysis.heartRateDriftPercent,
                        paceShape: analysis.pacingShape
                    )
                }

                if !analysis.bestEffortEstimates.isEmpty {
                    SectionHeader("Best Effort Estimates")
                    VStack(spacing: 8) {
                        ForEach(analysis.bestEffortEstimates.prefix(4), id: \.label) { effort in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(effort.label)
                                        .font(.subheadline.bold())
                                    Text(effort.source)
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(2)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text(RunFormatters.duration(effort.durationSecondsEstimate))
                                        .font(.subheadline.monospacedDigit().bold())
                                    Text(RunFormatters.pace(effort.paceSecondsPerKmEstimate))
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(10)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                let splitEstimates = analysis.splitEstimates ?? []
                if !splitEstimates.isEmpty {
                    SectionHeader("Split Review")
                    VStack(spacing: 8) {
                        ForEach(splitEstimates.prefix(5), id: \.label) { split in
                            HStack {
                                VStack(alignment: .leading, spacing: 3) {
                                    Text(split.label)
                                        .font(.subheadline.bold())
                                    Text("\(RunFormatters.distance(split.distanceMeters)) estimate")
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                VStack(alignment: .trailing, spacing: 3) {
                                    Text(RunFormatters.duration(split.durationSecondsEstimate))
                                        .font(.subheadline.monospacedDigit().bold())
                                    Text(RunFormatters.pace(split.paceSecondsPerKmEstimate))
                                        .font(.caption2)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            .padding(10)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        }
                    }
                }

                if !analysis.caveats.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        ForEach(analysis.caveats.prefix(3), id: \.self) { caveat in
                            Text(caveat)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                    }
                }
            } else {
                EmptyStateView(
                    title: "No cached analysis",
                    message: workout.seriesAvailable ? "Run the enrichment queue again if this workout should have derived execution details." : "This workout needs associated HealthKit samples before execution analysis can be shown."
                )
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var confidence: ConfidenceLevel {
        analysis?.dataQualityConfidence ?? .unavailable
    }

    private var subtitle: String {
        guard analysis != nil else {
            return "Gated until cached HealthKit evidence is available."
        }
        return "Built from persisted HealthKit evidence, not a new live query."
    }

    private func driftText(_ value: Double?) -> String {
        guard let value else { return "Missing" }
        return String(format: "%+.1f%%", value)
    }

    private func mechanicsSummary(_ analysis: DerivedWorkoutAnalysis) -> String {
        let values = [
            analysis.cadenceAverage.map { RunFormatters.number($0, suffix: " spm") },
            analysis.powerAverage.map { RunFormatters.number($0, suffix: " W") }
        ].compactMap { $0 }
        return values.isEmpty ? "Missing" : values.joined(separator: " / ")
    }
}

struct ExecutionShapeVisual: View {
    let segments: [DerivedExecutionSegment]
    let driftPercent: Double?
    let paceShape: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .top, spacing: 10) {
                    segmentCards
                }

                VStack(spacing: 8) {
                    segmentCards
                }
            }

            Text(summaryText)
                .font(.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var summaryText: String {
        let drift = driftPercent.map { String(format: "%+.1f%% HR drift", $0) } ?? "HR drift missing"
        return "\(drift). Pace shape: \(paceShape ?? "missing")."
    }

    private var heartRateRange: (lower: Double, upper: Double) {
        range(for: segments.compactMap(\.heartRateAverage), minimumSpread: 8)
    }

    private var paceRange: (lower: Double, upper: Double) {
        range(for: segments.compactMap(\.paceSecondsPerKmEstimate), minimumSpread: 20)
    }

    private func segmentConfidence(_ segment: DerivedExecutionSegment) -> ConfidenceLevel {
        if segment.heartRateConfidence == .unavailable {
            return segment.paceConfidence
        }
        if segment.paceConfidence == .unavailable {
            return segment.heartRateConfidence
        }
        return minConfidence(segment.heartRateConfidence, segment.paceConfidence)
    }

    @ViewBuilder
    private var segmentCards: some View {
        ForEach(segments.prefix(2), id: \.label) { segment in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(segment.label)
                        .font(.subheadline.bold())
                    Spacer()
                    ConfidencePill(text: segmentConfidence(segment).label, confidence: segmentConfidence(segment))
                }

                VStack(alignment: .leading, spacing: 6) {
                    ShapeMeter(
                        label: "HR",
                        value: RunFormatters.number(segment.heartRateAverage, suffix: " bpm"),
                        fill: fillRatio(
                            value: segment.heartRateAverage,
                            lower: heartRateRange.lower,
                            upper: heartRateRange.upper
                        ),
                        tint: .red
                    )
                    ShapeMeter(
                        label: "Pace",
                        value: RunFormatters.pace(segment.paceSecondsPerKmEstimate),
                        fill: inverseFillRatio(
                            value: segment.paceSecondsPerKmEstimate,
                            lower: paceRange.lower,
                            upper: paceRange.upper
                        ),
                        tint: .blue
                    )
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private func range(for values: [Double], minimumSpread: Double) -> (lower: Double, upper: Double) {
        guard let minValue = values.min(), let maxValue = values.max() else { return (0, 1) }
        let spread = max(maxValue - minValue, minimumSpread)
        let midpoint = (minValue + maxValue) / 2
        return (midpoint - spread / 2, midpoint + spread / 2)
    }

    private func fillRatio(value: Double?, lower: Double, upper: Double) -> Double {
        guard let value, upper > lower else { return 0 }
        return min(max((value - lower) / (upper - lower), 0.08), 1)
    }

    private func inverseFillRatio(value: Double?, lower: Double, upper: Double) -> Double {
        guard let value, upper > lower else { return 0 }
        return min(max((upper - value) / (upper - lower), 0.08), 1)
    }

    private func minConfidence(_ lhs: ConfidenceLevel, _ rhs: ConfidenceLevel) -> ConfidenceLevel {
        let order: [ConfidenceLevel: Int] = [.unavailable: 0, .blocked: 0, .weak: 1, .limited: 2, .moderate: 3, .strong: 4]
        return (order[lhs, default: 0] <= order[rhs, default: 0]) ? lhs : rhs
    }
}

struct ShapeMeter: View {
    let label: String
    let value: String
    let fill: Double
    let tint: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(label)
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(value)
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
            }

            GeometryReader { proxy in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(Color.secondary.opacity(0.16))
                    Capsule()
                        .fill(tint.opacity(fill == 0 ? 0.18 : 0.72))
                        .frame(width: proxy.size.width * fill)
                }
            }
            .frame(height: 7)
            .accessibilityHidden(true)
        }
    }
}

struct WorkoutSummaryCard: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(RunWorkout(workout: workout).displayName)
                        .font(.title2.bold())
                    Text(RunFormatters.date.string(from: workout.startDate))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ConfidencePill(text: workout.dataSourceLabel == "real HealthKit" ? "HealthKit" : "Sample", confidence: workout.dataSourceLabel == "real HealthKit" ? .moderate : .limited)
            }
            if workout.dataSourceLabel != "real HealthKit" {
                NoticeCard(title: "Using Sample Data", message: "This workout is sample fallback data and should not be compared against Apple Fitness.")
            }

            MetricGrid(items: [
                MetricItem(title: "Distance", value: RunFormatters.distance(workout.distanceMeters), detail: workout.environment.label),
                MetricItem(title: "Duration", value: RunFormatters.duration(workout.durationSeconds), detail: workout.sourceName),
                MetricItem(title: "Pace", value: RunFormatters.pace(workout.paceSecondsPerKm), detail: "Average"),
                MetricItem(title: "Route", value: workout.routeAvailable ? "Available" : "Missing", detail: workout.seriesAvailable ? "\(workout.seriesSampleCount) samples" : "Summary only"),
                MetricItem(title: "Active cal", value: RunFormatters.calories(workout.activeEnergyKilocalories), detail: "Workout scoped"),
                MetricItem(title: "Elevation", value: RunFormatters.number(workout.elevationGainMeters, suffix: " m"), detail: "Gain")
            ])

            if workout.isDuplicate {
                NoticeCard(title: "Duplicate candidate", message: "Excluded from totals and readiness calculations.")
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct WorkoutRow: View {
    let workout: CanonicalWorkout
    let confidence: ConfidenceLevel

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: workout.environment == .indoor ? "figure.run.treadmill" : "figure.run")
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 28)
            VStack(alignment: .leading, spacing: 3) {
                Text(workout.effectiveRunType.label)
                    .font(.headline)
                Text("\(RunFormatters.shortDate.string(from: workout.startDate)) · \(RunFormatters.distance(workout.distanceMeters)) · \(RunFormatters.pace(workout.paceSecondsPerKm))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            ConfidencePill(text: workout.runTypeTrust.kind.label, confidence: workout.runTypeTrust.confidence)
        }
        .padding(.vertical, 4)
    }
}

struct HeaderBlock: View {
    let title: String
    let subtitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.largeTitle.bold())
                .textCase(nil)
            Text(subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct SectionHeader: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.top, 8)
    }
}

struct CoachCard: View {
    let title: String
    let value: String
    let detail: String
    let confidence: ConfidenceLevel

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(title)
                    .font(.headline)
                Spacer()
                ConfidencePill(text: confidence.label, confidence: confidence)
            }
            Text(value)
                .font(.title2.bold())
            Text(detail)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct InsightCard: View {
    let insight: Insight

    var body: some View {
        CoachCard(title: insight.title, value: insight.value, detail: insight.detail, confidence: insight.confidence)
    }
}

struct NoticeCard: View {
    let title: String
    let message: String

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: "exclamationmark.circle")
                .foregroundStyle(.orange)
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.subheadline.bold())
                Text(message)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
        }
        .padding()
        .background(.orange.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct EmptyStateView: View {
    let title: String
    let message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "tray")
                .font(.largeTitle)
                .foregroundStyle(.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
}

struct MetricGrid: View {
    let items: [MetricItem]

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            ForEach(items) { item in
                VStack(alignment: .leading, spacing: 5) {
                    Text(item.title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(item.value)
                        .font(.headline.monospacedDigit())
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                    Text(item.detail)
                        .font(.caption2)
                        .foregroundStyle(.tertiary)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, minHeight: 82, alignment: .topLeading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }
}

struct MetricItem: Identifiable {
    let id = UUID()
    let title: String
    let value: String
    let detail: String
}

enum HealthContextMetrics {
    static func todayItems(for context: HealthContext) -> [MetricItem] {
        [
            MetricItem(title: "VO2 max", value: RunFormatters.number(context.vo2Max, decimals: 1), detail: "Latest available"),
            MetricItem(title: "Resting HR", value: RunFormatters.number(context.restingHeartRate, suffix: " bpm"), detail: "Latest available")
        ]
    }

    static func dataItems(for context: HealthContext) -> [MetricItem] {
        [
            MetricItem(title: "VO2 max", value: RunFormatters.number(context.vo2Max, decimals: 1), detail: "Latest available"),
            MetricItem(title: "Resting HR", value: RunFormatters.number(context.restingHeartRate, suffix: " bpm"), detail: "Latest available"),
            MetricItem(title: "Avg HR", value: RunFormatters.number(context.averageHeartRate, suffix: " bpm"), detail: "Broad HealthKit"),
            MetricItem(title: "Max HR", value: RunFormatters.number(context.maxHeartRate, suffix: " bpm"), detail: "Broad HealthKit"),
            MetricItem(title: "Active energy", value: RunFormatters.calories(context.activeEnergyKilocaloriesTotal), detail: "Broad HealthKit")
        ]
    }
}

struct CoverageRow: View {
    let label: String
    let value: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(label)
                    .font(.subheadline)
                Spacer()
                Text(RunFormatters.percent(value))
                    .font(.subheadline.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: value)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct ConfidencePill: View {
    let text: String
    let confidence: ConfidenceLevel

    var body: some View {
        Text(text)
            .font(.caption.bold())
            .lineLimit(1)
            .minimumScaleFactor(0.8)
            .padding(.horizontal, 8)
            .padding(.vertical, 5)
            .background(color.opacity(0.16))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }

    private var color: Color {
        switch confidence {
        case .strong: .green
        case .moderate: .blue
        case .limited, .weak: .orange
        case .blocked: .red
        case .unavailable: .secondary
        }
    }
}

#Preview {
    ContentView()
}
