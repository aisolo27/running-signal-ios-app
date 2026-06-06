import SwiftUI
import UniformTypeIdentifiers

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
                    MetricItem(title: "Confidence", value: store.snapshot.dataQuality.confidence.label, detail: "Current data gate")
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
        case .limited: "exclamationmark.triangle"
        case .unavailable: "xmark.circle"
        }
    }

    private var color: Color {
        switch insight.confidence {
        case .strong: .green
        case .moderate: .blue
        case .limited: .orange
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

    @State private var selectedType: RunType?
    @State private var notes = ""
    @State private var didLoad = false

    private var workout: CanonicalWorkout? {
        store.workouts.first { $0.id == workoutID }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                if let workout {
                    WorkoutSummaryCard(workout: workout)

                    VStack(alignment: .leading, spacing: 12) {
                        Text("Manual label")
                            .font(.headline)
                        Picker("Manual label", selection: $selectedType) {
                            Text("Use inferred: \(workout.inferredRunType.label)").tag(nil as RunType?)
                            ForEach(RunType.allCases) { type in
                                Text(type.label).tag(type as RunType?)
                            }
                        }
                        .pickerStyle(.menu)

                        Text("Notes")
                            .font(.headline)
                        TextEditor(text: $notes)
                            .frame(minHeight: 110)
                            .padding(8)
                            .background(.thinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                        Button {
                            store.update(workoutID: workoutID, manualRunType: selectedType, notes: notes)
                        } label: {
                            Label("Save label and notes", systemImage: "checkmark.circle")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))

                    MetricGrid(items: [
                        MetricItem(title: "Heart rate", value: RunFormatters.number(workout.averageHeartRate, suffix: " bpm"), detail: "Average"),
                        MetricItem(title: "Cadence", value: RunFormatters.number(workout.averageCadence, suffix: " spm"), detail: "Average"),
                        MetricItem(title: "Power", value: RunFormatters.number(workout.averagePower, suffix: " W"), detail: "Average"),
                        MetricItem(title: "Ground contact", value: RunFormatters.number(workout.groundContactMilliseconds, suffix: " ms"), detail: "Mechanics gate")
                    ])

                    NoticeCard(
                        title: workout.seriesAvailable ? "Series available" : "Series not loaded",
                        message: workout.seriesAvailable ? "Detailed split and route work belongs behind this detail surface." : "This run can still be summarized, but detailed execution confidence stays limited."
                    )
                } else {
                    EmptyStateView(title: "Workout missing", message: "The selected workout is no longer in local state.")
                }
            }
            .padding()
        }
        .navigationTitle("Workout")
        .onAppear {
            guard !didLoad, let workout else { return }
            selectedType = workout.manualRunType
            notes = workout.notes
            didLoad = true
        }
    }
}

struct WorkoutSummaryCard: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(workout.effectiveRunType.label)
                        .font(.title2.bold())
                    Text(RunFormatters.date.string(from: workout.startDate))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                ConfidencePill(text: workout.manualRunType == nil ? "Inferred" : "Manual", confidence: workout.manualRunType == nil ? .limited : .moderate)
            }

            MetricGrid(items: [
                MetricItem(title: "Distance", value: RunFormatters.distance(workout.distanceMeters), detail: workout.environment.label),
                MetricItem(title: "Duration", value: RunFormatters.duration(workout.durationSeconds), detail: workout.sourceName),
                MetricItem(title: "Pace", value: RunFormatters.pace(workout.paceSecondsPerKm), detail: "Canonical sec/km"),
                MetricItem(title: "Route", value: workout.routeAvailable ? "Available" : "Missing", detail: workout.seriesAvailable ? "Series candidate" : "Summary only")
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
            ConfidencePill(text: confidence.label, confidence: confidence)
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
        case .limited: .orange
        case .unavailable: .secondary
        }
    }
}

#Preview {
    ContentView()
}
