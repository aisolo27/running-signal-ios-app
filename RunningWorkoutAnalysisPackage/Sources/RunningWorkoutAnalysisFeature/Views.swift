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

    private var allTimeBestEfforts: [PersonalBestEffortRecord] {
        store.personalBestEffortSummary.allTime
    }

    private var workoutsByID: [String: CanonicalWorkout] {
        Dictionary(uniqueKeysWithValues: store.workouts.map { ($0.id, $0) })
    }

    private var wholeRunSummary: WholeRunHealthKitSummary {
        WholeRunHealthKitSummary.make(
            workouts: store.workouts,
            authorizationState: store.authorizationState,
            usesSampleData: store.usesSampleData
        )
    }

    private var appReadinessSummary: AppReadinessUXSummary {
        AppReadinessUXSummary.make(
            workouts: store.workouts,
            authorizationState: store.authorizationState,
            usesSampleData: store.usesSampleData,
            isLoading: store.isLoading,
            evidenceQueueSummary: store.evidenceQueueSummary,
            bestEfforts: allTimeBestEfforts,
            refreshJobs: store.evidenceRefreshJobSummaries
        )
    }

    var body: some View {
        List {
            Section {
                if store.usesSampleData {
                    NoticeCard(title: "Using Sample Data", message: "These workouts are placeholders. Load HealthKit from Settings to replace them with your completed running workouts.")
                }

                WholeRunStatusCard(summary: wholeRunSummary, loadedRunCount: store.usesSampleData ? nil : runs.count)

                AppReadinessCard(summary: appReadinessSummary)
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

            Section {
                if allTimeBestEfforts.isEmpty {
                    EmptyStateView(title: "No exact best efforts", message: "Need detailed HealthKit distance samples before official segment bests can be calculated.")
                } else {
                    ForEach(allTimeBestEfforts, id: \.bucket) { effort in
                        if let workout = workoutsByID[effort.workoutID] {
                            NavigationLink {
                                WorkoutDetailView(store: store, workoutID: workout.id)
                            } label: {
                                PersonalBestEffortRow(effort: effort, titleFont: .headline)
                            }
                        } else {
                            PersonalBestEffortRow(effort: effort, titleFont: .headline)
                        }
                    }
                }
            } header: {
                ListSectionTitle("All-Time Best Efforts")
            }

            Section {
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
            } header: {
                ListSectionTitle("Completed Runs")
            }
        }
        .navigationTitle("Runs")
        .refreshable {
            await store.refreshRunsListFromHealthKit()
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
                    if let importSummary = store.healthKitImportJobSummary {
                        LabeledContent(importSummary.statusTitle, value: importSummary.detailText)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
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
                .foregroundStyle(.primary)
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
                    .foregroundStyle(.primary)
            }
            Text("\(RunFormatters.distance(workout.distanceMeters)) · \(RunFormatters.duration(workout.durationSeconds)) · \(RunFormatters.pace(workout.paceSecondsPerKm))")
                .font(.caption)
                .foregroundStyle(.primary)
            Text("Avg HR \(RunFormatters.number(workout.averageHeartRate, suffix: " bpm")) · \(workout.sourceName)")
                .font(.caption2)
                .foregroundStyle(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct PersonalBestEffortRow: View {
    let effort: PersonalBestEffortRecord
    let titleFont: Font

    var body: some View {
        let trust = BestEffortUXSummary.make(effort: effort)

        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(effort.bucket.label)
                    .font(titleFont)
                Text("\(RunFormatters.shortDate.string(from: effort.date)) · \(trust.detail)")
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .lineLimit(3)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 3) {
                Text(primaryValue)
                    .font(titleFont.monospacedDigit())
                Text(RunFormatters.pace(effort.paceSecondsPerKm))
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                ConfidencePill(text: trust.title, confidence: trust.confidence)
            }
        }
        .padding(10)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var primaryValue: String {
        if effort.bucket == .longestRun {
            return RunFormatters.compactDistance(effort.distanceMeters)
        }
        return RunFormatters.duration(effort.durationSeconds)
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
                        message: "This screen reports what HealthKit returned for each workout. The queue enriches bounded batches and skips workouts already cached with detailed evidence.",
                        systemImage: "checkmark.shield",
                        tint: .blue
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
            .padding(.bottom, 180)
        }
        .navigationTitle("HealthKit Audit")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
        }
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
                    let supportedIntervals = workout.evidence.flatMap {
                        CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: $0)
                    }
                    let intervalBlockedReasons = workout.evidence.map {
                        CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: $0)
                    } ?? ["Detailed HealthKit evidence is missing."]
                    let queueItem = store.evidenceQueueItem(for: workout.id)
                    let isProcessing = store.analyzingWorkoutIDs.contains(workout.id)
                    let readiness = EvidenceReadinessSummary.make(
                        workout: workout,
                        queueItem: queueItem,
                        isProcessing: isProcessing,
                        supportedIntervals: supportedIntervals,
                        blockedReasons: intervalBlockedReasons
                    )

                    WorkoutReviewCard(
                        summary: WorkoutReviewUXSummary.make(
                            workout: workout,
                            supportedIntervals: supportedIntervals,
                            blockedReasons: intervalBlockedReasons
                        )
                    )

                    EvidenceReadinessCard(
                        summary: readiness,
                        queueItem: queueItem,
                        isProcessing: isProcessing,
                        isDisabled: store.isEnrichingAudit,
                        loadAction: {
                            Task {
                                await store.loadFullAnalysisForWorkout(workoutID: workout.id)
                            }
                        },
                        technicalDestination: {
                            RawHealthKitWorkoutDebugView(store: store, workout: workout)
                        }
                    )

                    WorkoutSummaryCard(workout: workout)

                    FitnessWorkoutMetrics(workout: workout)

                    RouteAndSeriesPanel(workout: workout)

                    WorkoutChartsPanel(workout: workout)

                    SplitsAndEventsPanel(
                        store: store,
                        workout: workout,
                        segments: RunWorkoutSegments(workout: workout, analysis: store.derivedAnalysis(for: workout.id))
                    )

                } else {
                    EmptyStateView(title: "Workout missing", message: "The selected workout is no longer in local state.")
                }
            }
            .padding()
            .padding(.bottom, 220)
        }
        .navigationTitle("Workout")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 112)
        }
        .task(id: workoutID) {
            store.hydrateCachedEvidenceIfAvailable(for: workoutID)
        }
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
                message: routeMessage,
                systemImage: routeIcon,
                tint: routeTint
            )
        }
    }

    private var routeTitle: String {
        if coordinateCount >= 2 { return "Route loaded" }
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

    private var routeIcon: String {
        coordinateCount >= 2 ? "checkmark.circle" : "map"
    }

    private var routeTint: Color {
        coordinateCount >= 2 ? .green : .orange
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
            SectionHeader("Evidence")
            MetricGrid(items: evidenceItems)
            SectionHeader("Charts")
            WorkoutChartDeck(workout: workout)
        }
    }

    private var evidenceItems: [MetricItem] {
        [
            MetricItem(title: "Heart rate", value: sampleValue(workout.heartRateSampleCount), detail: "Samples loaded"),
            MetricItem(title: "Pace", value: sampleValue(workout.runningSpeedSampleCount + workout.distanceSampleCount), detail: "Speed/distance"),
            MetricItem(title: "Power", value: sampleValue(workout.runningPowerSampleCount), detail: "Running power"),
            MetricItem(title: "Cadence", value: sampleValue(workout.cadenceSampleCount + workout.stepCountSampleCount), detail: "Cadence/steps")
        ]
    }

    private func sampleValue(_ count: Int) -> String {
        count > 0 ? "\(count)" : "Unavailable"
    }
}

struct SplitsAndEventsPanel: View {
    let store: RunningAnalysisStore
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
                    ForEach(segments.kilometerSplits, id: \.label) { split in
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

            SectionHeader("Workout Intervals")
            if let supportedIntervals {
                IntervalAnalysisEntryCard(workout: workout, result: supportedIntervals)
            } else {
                VStack(alignment: .leading, spacing: 10) {
                    NoticeCard(
                        title: "Intervals under review",
                        message: intervalMessage,
                        systemImage: "clock.badge.questionmark",
                        tint: .blue
                    )
                    NavigationLink {
                        RawHealthKitWorkoutDebugView(store: store, workout: workout)
                    } label: {
                        Label("View Interval Evidence", systemImage: "doc.text.magnifyingglass")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }

    private var normalDetailCustomWorkoutIntervals: WorkoutIntervalReconstructionResult? {
        guard let evidence = workout.evidence else { return nil }
        let intervals = IntervalDrillDownEligibility.officialRows(workout: workout, evidence: evidence)
        guard !intervals.isEmpty else { return nil }
        return CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)
    }

    private var intervalMessage: String {
        guard let evidence = workout.evidence else {
            return "Whole-run stats are ready. Reload HealthKit evidence on the physical iPhone to review custom interval rows."
        }

        if let reviewSummary = intervalReviewSummary(evidence: evidence) {
            return reviewSummary
        }

        let reasons = CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: evidence)
        guard !reasons.isEmpty else {
            return "Whole-run stats are ready. RunSignal is still reviewing interval evidence for this workout."
        }
        return "Whole-run stats are ready. \(reasons[0])"
    }

    private func intervalReviewSummary(evidence: WorkoutEvidence) -> String? {
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        guard let audit = evidence.workoutPlanAudit,
              !audit.plannedSteps.isEmpty,
              let lastActivityEnd = activities.last?.endDate else {
            return nil
        }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let hasFixedCooldownTail = plannedSteps.last?.stepType == .cooldown
            && plannedSteps.last?.plannedGoalType != .open
            && workout.endDate.timeIntervalSince(lastActivityEnd) > 0.5
        guard hasFixedCooldownTail else { return nil }

        return "RunSignal found \(activities.count + 1) resolved boundary rows, but the Open / Extra tail rule is still under review. Whole-run stats are ready."
    }
}

enum IntervalRowTimingText {
    static func displayPaceDetail(for interval: ReconstructedWorkoutInterval) -> String {
        IntervalGoalMeasuredText.measuredPaceDetail(for: interval)
    }

    static func displayPaceSecondsPerKm(for interval: ReconstructedWorkoutInterval) -> Double? {
        IntervalGoalMeasuredText.measuredPaceSecondsPerKm(for: interval)
    }

    static func pausedTimingItems(for interval: ReconstructedWorkoutInterval) -> [MetricItem]? {
        guard let pauseOverlap = interval.pauseOverlapSeconds, pauseOverlap > 0 else { return nil }
        return [
            MetricItem(title: "Elapsed", value: RunFormatters.duration(interval.elapsedRowWindowDurationSeconds), detail: "Row window"),
            MetricItem(title: "Pause", value: RunFormatters.duration(pauseOverlap), detail: "Paired overlap"),
            MetricItem(title: "Active", value: RunFormatters.duration(interval.activeTimerDurationSeconds), detail: "Timer duration"),
            MetricItem(title: "Display", value: RunFormatters.duration(interval.displayDurationSeconds), detail: interval.durationDisplayRule == .activeTimer ? "Active timer" : "Elapsed window")
        ]
    }

    static func pausedTimingDetail(for interval: ReconstructedWorkoutInterval) -> String? {
        guard let pauseOverlap = interval.pauseOverlapSeconds, pauseOverlap > 0 else { return nil }
        return "Active \(RunFormatters.duration(interval.activeTimerDurationSeconds)) · elapsed \(RunFormatters.duration(interval.elapsedRowWindowDurationSeconds)) · paused \(RunFormatters.duration(pauseOverlap))"
    }
}

struct RawHealthKitWorkoutDebugView: View {
    static let unavailableCustomIntervalsMessage = "Not promoted yet. Whole-run stats are still safe to review until RunSignal sees a supported public WorkoutKit and HealthKit evidence pattern."
    static let reviewPacketScopeMessage = "Use this review packet to share Raw HealthKit Debug, the parity packet, WorkoutKit plan audit, HealthKit activity rows, resolved activity-boundary rows, fallback labels, pause/tail diagnostics, and source metadata. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat them as app input. Resolved rows are the normal-detail source only when the evidence gate passes."

    var store: RunningAnalysisStore
    let workout: CanonicalWorkout
    @State private var selectedDiagnosticsMonth = Date()
    @State private var showingMonthlyExportSheet = false
    @State private var developerToolsExpanded = false

    var body: some View {
        let workout = currentWorkout
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(title: "Raw HealthKit Debug", subtitle: "Per-workout fields and evidence counts.")

                NoticeCard(
                    title: "Review packet scope",
                    message: Self.reviewPacketScopeMessage
                )

                DisclosureGroup(isExpanded: $developerToolsExpanded) {
                    VStack(alignment: .leading, spacing: 12) {
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
                            Label("Share review packet markdown", systemImage: "doc.text.magnifyingglass")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)

                        SectionHeader("Monthly Diagnostics")
                        DatePicker(
                            "Select date in month",
                            selection: $selectedDiagnosticsMonth,
                            displayedComponents: [.date]
                        )
                        .datePickerStyle(.compact)

                        if let summary = store.evidenceRefreshSummary(containing: selectedDiagnosticsMonth) {
                            EvidenceRefreshJobCard(
                                summary: summary,
                                derivedSummary: store.derivedAnalysisRefreshSummary,
                                isRefreshing: store.isEnrichingAudit
                            ) {
                                Task {
                                    await store.resumeEvidenceRefreshForMonth(containing: selectedDiagnosticsMonth)
                                }
                            }
                        }

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
                    }
                    .padding(.top, 8)
                } label: {
                    Label("Developer tools", systemImage: "wrench.and.screwdriver")
                        .font(.headline)
                }
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))

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

                SectionHeader("WorkoutKit Plan Audit")
                workoutPlanAuditView

            SectionHeader("Official Interval Rows")
                reconstructedIntervalsView

            SectionHeader("Resolved Row Evidence")
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
            .padding(.bottom, 240)
        }
        .navigationTitle("Debug")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
        }
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
        return CustomWorkoutNormalDetailGate.supportedIntervals(workout: currentWorkout, evidence: evidence)
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
            let candidateDebugRows = candidateDebugRowsForResolvedSection(result)
            let isUsingCandidateDebugRows = !candidateDebugRows.isEmpty
            VStack(alignment: .leading, spacing: 8) {
                MetricGrid(items: [
                    MetricItem(title: "Plan source", value: result.planSource.label, detail: "Structure"),
                    MetricItem(
                        title: "Window source",
                        value: result.windowSource.label,
                        detail: "Segment markers not used"
                    )
                ])
                NoticeCard(
                    title: "Resolved row source",
                    message: "These rows are resolved from WorkoutKit planned steps and HealthKit activity boundaries. The duration, distance, and pace tiles should use this same row basis."
                )

                if isUsingCandidateDebugRows {
                    ForEach(candidateDebugRows) { row in
                        candidateResolvedDebugRowView(row)
                    }
                } else {
                    ForEach(result.intervals, id: \.index) { interval in
                        officialResolvedIntervalRowView(interval)
                    }
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
                message: Self.unavailableCustomIntervalsMessage
            )
        }
    }

    private func candidateDebugRowsForResolvedSection(_ result: WorkoutIntervalReconstructionResult) -> [ParityLabCandidateRow] {
        guard result.windowSource != .healthKitActivityBoundaries else {
            return []
        }
        let candidateRows = parityLabCandidateRowsResult.rows
        guard !candidateRows.isEmpty else {
            return []
        }
        return candidateRows
    }

    @ViewBuilder
    private func officialResolvedIntervalRowView(_ interval: ReconstructedWorkoutInterval) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                if let pausedTimingItems = IntervalRowTimingText.pausedTimingItems(for: interval) {
                    MetricGrid(items: pausedTimingItems)
                }

                MetricGrid(items: IntervalGoalMeasuredText.metricItems(for: interval) + [
                    MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: "Window"),
                    MetricItem(title: "Max HR", value: RunFormatters.number(interval.maxHeartRateBpm, suffix: " bpm"), detail: "Window"),
                    MetricItem(title: "Power", value: RunFormatters.number(interval.averagePower, suffix: " W"), detail: "Avg"),
                    MetricItem(title: "Cadence", value: RunFormatters.number(interval.averageCadence, suffix: " spm"), detail: "Avg")
                ])

                Text("\(interval.confidence.label) · \(interval.sourceNote)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 8)
        } label: {
            RawIntervalCompactLabel(
                title: "\(interval.index). \(interval.label)",
                subtitle: "\(interval.plannedGoalDisplayText) · \(interval.plannedTargetDisplayText ?? "Target unavailable")",
                duration: RunFormatters.duration(interval.displayDurationSeconds),
                distance: RunFormatters.distance(interval.actualDistanceMeters),
                badge: "Official",
                badgeColor: .blue
            )
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    @ViewBuilder
    private func candidateResolvedDebugRowView(_ row: ParityLabCandidateRow) -> some View {
        let displayDuration = row.pauseOverlapSeconds > 0 ? row.activeDurationSeconds : row.elapsedDurationSeconds
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
                MetricGrid(items: [
                    MetricItem(title: "Elapsed", value: RunFormatters.duration(row.elapsedDurationSeconds), detail: "Activity row"),
                    MetricItem(title: "Pause", value: RunFormatters.duration(row.pauseOverlapSeconds), detail: "Paired overlap"),
                    MetricItem(title: "Active", value: RunFormatters.duration(row.activeDurationSeconds), detail: row.durationRule),
                    MetricItem(title: "Distance", value: RunFormatters.distance(row.distanceMeters), detail: row.mappingStatus),
                    candidateDebugPaceItem(for: row)
                ])

                Text("\(row.isOpenTail ? "Medium" : "High") · Resolved activity-boundary row")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 8)
        } label: {
            RawIntervalCompactLabel(
                title: "\(row.index). \(row.label)",
                subtitle: row.detail,
                duration: RunFormatters.duration(displayDuration),
                distance: RunFormatters.distance(row.distanceMeters),
                badge: row.isOpenTail ? "Open / Extra" : "Resolved",
                badgeColor: row.isOpenTail ? .orange : .blue
            )
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func candidateDebugPaceItem(for row: ParityLabCandidateRow) -> MetricItem {
        let displayDuration = row.pauseOverlapSeconds > 0 ? row.activeDurationSeconds : row.elapsedDurationSeconds
        guard let distanceMeters = row.distanceMeters, distanceMeters > 0, displayDuration > 0 else {
            return MetricItem(title: "Pace", value: "Unavailable", detail: row.pauseOverlapSeconds > 0 ? "Active timer" : "Elapsed row")
        }
        return MetricItem(
            title: "Pace",
            value: RunFormatters.pace(displayDuration / (distanceMeters / 1_000)),
            detail: row.pauseOverlapSeconds > 0 ? "Active timer" : "Elapsed row"
        )
    }

    private func parityTimingItems(for interval: ReconstructedWorkoutInterval) -> [MetricItem]? {
        guard (interval.pauseOverlapSeconds ?? 0) <= 0,
              let row = parityLabCandidateRowsResult.rows.first(where: { $0.index == interval.index }),
              row.pauseOverlapSeconds > 0 else {
            return nil
        }

        return [
            MetricItem(title: "Elapsed", value: RunFormatters.duration(row.elapsedDurationSeconds), detail: "Parity row"),
            MetricItem(title: "Pause", value: RunFormatters.duration(row.pauseOverlapSeconds), detail: "Paired overlap"),
            MetricItem(title: "Active", value: RunFormatters.duration(row.activeDurationSeconds), detail: row.durationRule),
            MetricItem(title: "Distance", value: RunFormatters.distance(row.distanceMeters), detail: "Activity row")
        ]
    }

    private func debugPaceItem(for interval: ReconstructedWorkoutInterval) -> MetricItem {
        if let row = parityLabCandidateRowsResult.rows.first(where: { $0.index == interval.index }),
           row.pauseOverlapSeconds > 0,
           let distanceMeters = row.distanceMeters,
           distanceMeters > 0,
           row.activeDurationSeconds > 0 {
            return MetricItem(
                title: "Pace",
                value: RunFormatters.pace(row.activeDurationSeconds / (distanceMeters / 1_000)),
                detail: "Parity active"
            )
        }
        return MetricItem(
            title: "Pace",
            value: RunFormatters.pace(IntervalRowTimingText.displayPaceSecondsPerKm(for: interval)),
            detail: IntervalRowTimingText.displayPaceDetail(for: interval)
        )
    }

    @ViewBuilder
    private var parityLabCandidateRowsView: some View {
        let result = parityLabCandidateRowsResult
            VStack(alignment: .leading, spacing: 10) {
                NoticeCard(
                    title: "Resolved boundary rows",
                    message: "These rows show the HealthKit activity-boundary source used by official custom workout intervals when evidence gates pass."
                )

            if let unavailableReason = result.unavailableReason {
                NoticeCard(title: "Unavailable", message: unavailableReason)
            } else {
                MetricGrid(items: [
                    MetricItem(title: "Status", value: result.structuredStatus, detail: "Structured gate"),
                    MetricItem(title: "Fallback", value: result.primaryFallbackReason ?? "None", detail: "Primary reason"),
                    MetricItem(title: "Rows", value: "\(result.rows.count)", detail: result.rowCountDetail),
                    MetricItem(title: "Open tails", value: "\(result.rows.filter(\.isOpenTail).count)", detail: "Inferred"),
                    MetricItem(title: "Accepted pauses", value: "\(result.pairedPauseCount)", detail: RunFormatters.duration(result.totalPairedPauseSeconds)),
                    MetricItem(
                        title: "Scope",
                        value: result.promotesProductionBehavior ? "Normal detail" : "Audit",
                        detail: result.promotesProductionBehavior ? "Official source" : "Fallback review"
                    ),
                    MetricItem(title: "Parity scope", value: "Evidence gated", detail: "Official when supported")
                ])

                if let stoppedEarlyMessage = result.stoppedEarlyMessage {
                    NoticeCard(title: "Workout stopped early", message: stoppedEarlyMessage)
                }

                ForEach(result.rows) { row in
                    resolvedEvidenceRowView(row)
                }
            }
        }
    }

    @ViewBuilder
    private func resolvedEvidenceRowView(_ row: ParityLabCandidateRow) -> some View {
        let displayDuration = row.pauseOverlapSeconds > 0 ? row.activeDurationSeconds : row.elapsedDurationSeconds
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 8) {
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
            .padding(.top, 8)
        } label: {
            RawIntervalCompactLabel(
                title: "\(row.index). \(row.label)",
                subtitle: row.detail,
                duration: RunFormatters.duration(displayDuration),
                distance: RunFormatters.distance(row.distanceMeters),
                badge: row.isOpenTail ? "Open / Extra" : "Planned",
                badgeColor: row.isOpenTail ? .orange : .secondary
            )
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var parityLabCandidateRowsResult: ParityLabCandidateRowsResult {
        guard let evidence = currentWorkout.evidence else {
            return ParityLabCandidateRowsResult(unavailableReason: "Reload HealthKit evidence on the physical iPhone before inspecting resolved boundary rows.")
        }
        guard let audit = evidence.workoutPlanAudit, !audit.plannedSteps.isEmpty else {
            return ParityLabCandidateRowsResult(unavailableReason: "WorkoutKit planned steps are missing for this workout.")
        }
        let plannedSteps = audit.plannedSteps.sorted { $0.index < $1.index }
        let activities = evidence.activities.sorted { $0.startDate < $1.startDate }
        guard !activities.isEmpty else {
            return ParityLabCandidateRowsResult(unavailableReason: "HealthKit workout activity rows are missing for this workout.")
        }
        guard activities.count <= plannedSteps.count else {
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
        let hasPauseOrResumeEvidence = evidence.events.contains { event in
            let label = event.displayLabel.lowercased()
            let type = event.type.lowercased()
            return label.contains("pause")
                || label.contains("resume")
                || type.contains("pause")
                || type.contains("resume")
        }
        let enablesPausedRepeatTailRule = !pauses.isEmpty
            && plannedSteps.contains { ($0.repeatIndex ?? 1) > 1 }
            && plannedSteps.contains { $0.stepType == .work && $0.repeatBlockIndex != nil }
            && plannedSteps.contains { $0.stepType == .recovery && $0.repeatBlockIndex != nil }
            && plannedSteps.last?.stepType == .cooldown
            && plannedSteps.last?.plannedGoalType != .open
        let pauseEvidenceState: CustomWorkoutPauseEvidenceState = if !pauses.isEmpty {
            .paired
        } else if hasPauseOrResumeEvidence {
            .unpaired
        } else {
            .none
        }
        let resolvedPlannedSteps = Array(plannedSteps.prefix(activities.count))
        let comparison = DebugCustomWorkoutComparisonBuilder.comparison(
            plannedSteps: resolvedPlannedSteps,
            activities: activities,
            workout: currentWorkout,
            simpleWorkOpenRuleApproved: true,
            pausedRepeatBlockRuleApproved: true,
            recoveryContainingOpenTailRuleApproved: true,
            repeatTailRuleApproved: !hasPauseOrResumeEvidence,
            pausedRepeatTailRuleApproved: enablesPausedRepeatTailRule,
            pairedPauseCount: pauses.count,
            pauseEvidenceState: pauseEvidenceState
        )
        var rows = zip(resolvedPlannedSteps, activities).enumerated().map { offset, pair in
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
                mappingStatus: plannedSteps.count > activities.count ? "Completed planned prefix row \(offset + 1) of \(plannedSteps.count)" : "Activity row \(offset + 1)",
                isOpenTail: false
            )
        }

        let mappedDistance = rows.compactMap(\.distanceMeters).reduce(0, +)
        if activities.count == plannedSteps.count,
           let lastEndDate = activities.last?.endDate {
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
            structuredStatus: comparison.status.normalDetailBlockedReasonLabel,
            fallbackReasons: comparison.fallbackReasons.map(\.normalDetailBlockedReasonLabel),
            promotesProductionBehavior: comparison.promotesProductionBehavior,
            pairedPauseCount: pauses.count,
            totalPairedPauseSeconds: pauses.map(\.durationSeconds).reduce(0, +),
            plannedRowCount: plannedSteps.count,
            completedRowCount: activities.count
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
        var structuredStatus: String = CustomWorkoutComparisonStatus.missingRequiredEvidence.normalDetailBlockedReasonLabel
        var fallbackReasons: [String] = []
        var promotesProductionBehavior = false
        var pairedPauseCount: Int = 0
        var totalPairedPauseSeconds: Double = 0
        var plannedRowCount: Int = 0
        var completedRowCount: Int = 0

        var primaryFallbackReason: String? {
            fallbackReasons.first
        }

        var rowCountDetail: String {
            guard plannedRowCount > 0, completedRowCount > 0 else {
                return "Resolved rows"
            }
            if completedRowCount < plannedRowCount {
                return "Completed prefix of \(plannedRowCount)"
            }
            return "Resolved rows"
        }

        var stoppedEarlyMessage: String? {
            guard plannedRowCount > 0, completedRowCount > 0, completedRowCount < plannedRowCount else {
                return nil
            }
            return "Showing \(completedRowCount) completed rows from \(plannedRowCount) planned rows."
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

private struct RawIntervalCompactLabel: View {
    let title: String
    let subtitle: String
    let duration: String
    let distance: String
    let badge: String
    let badgeColor: Color

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 6) {
                    Text(title)
                        .font(.subheadline.bold())
                    Text(badge)
                        .font(.caption2.bold())
                        .foregroundStyle(badgeColor)
                }
                Text(subtitle)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 3) {
                Text(duration)
                    .font(.subheadline.monospacedDigit().bold())
                Text(distance)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

struct WholeRunStatusCard: View {
    let summary: WholeRunHealthKitSummary
    var loadedRunCount: Int?

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: "figure.run.circle")
                .foregroundStyle(.blue)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(summary.title)
                        .font(.headline)
                    Spacer()
                    ConfidencePill(text: summary.status.label, confidence: summary.status)
                }
                Text(summary.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if let loadedRunCount {
                    Text("\(loadedRunCount) completed running workouts loaded. Duplicate-like workouts are hidden from this v1 list.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .padding()
        .background(.blue.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct AppReadinessCard: View {
    let summary: AppReadinessUXSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "checklist.checked")
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(summary.title)
                            .font(.headline)
                        Spacer()
                        ConfidencePill(text: summary.confidence.label, confidence: summary.confidence)
                    }
                    Text(summary.detail)
                        .font(.subheadline)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            ReviewSignalGrid(signals: summary.signals)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct WorkoutReviewCard: View {
    let summary: WorkoutReviewUXSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "waveform.path.ecg.rectangle")
                    .foregroundStyle(.blue)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(summary.title)
                            .font(.headline)
                        Spacer()
                        ConfidencePill(text: summary.confidence.label, confidence: summary.confidence)
                    }
                    Text(summary.detail)
                        .font(.subheadline)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            ReviewSignalGrid(signals: summary.signals)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct EvidenceReadinessCard<TechnicalDestination: View>: View {
    let summary: EvidenceReadinessSummary
    let queueItem: EvidenceEnrichmentQueueItem?
    let isProcessing: Bool
    let isDisabled: Bool
    let loadAction: () -> Void
    @ViewBuilder let technicalDestination: () -> TechnicalDestination

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: symbol)
                    .foregroundStyle(color)
                    .frame(width: 18)
                VStack(alignment: .leading, spacing: 4) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(summary.title)
                            .font(.headline)
                        Spacer()
                        ConfidencePill(text: summary.confidence.label, confidence: summary.confidence)
                    }
                    Text(summary.detail)
                        .font(.subheadline)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            if isProcessing {
                HStack(spacing: 8) {
                    ProgressView()
                    Text("Analyzing HealthKit evidence")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }
            }

            if let technicalDetail = summary.technicalDetail {
                Text(technicalDetail)
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.tertiary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            if let queueItem {
                HStack(spacing: 8) {
                    Label(queueItem.status.label, systemImage: "list.bullet.clipboard")
                    Text(queueItem.priority.label)
                }
                .font(.caption)
                .foregroundStyle(RunSignalTextStyle.tertiary)
            }

            HStack(spacing: 10) {
                if let actionTitle = summary.action.title {
                    Button(actionTitle, action: loadAction)
                        .buttonStyle(.borderedProminent)
                        .disabled(isDisabled || isProcessing)
                }

                NavigationLink {
                    technicalDestination()
                } label: {
                    Label("View technical details", systemImage: "stethoscope")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var symbol: String {
        switch summary.action {
        case .load:
            isProcessing ? "hourglass" : "arrow.down.circle"
        case .refresh:
            isProcessing ? "hourglass" : "arrow.clockwise.circle"
        case .none:
            summary.confidence == .strong ? "checkmark.seal" : "info.circle"
        }
    }

    private var color: Color {
        switch summary.confidence {
        case .strong:
            .green
        case .moderate:
            .blue
        case .limited:
            .orange
        case .weak:
            .yellow
        case .blocked:
            .red
        case .unavailable:
            .red
        }
    }
}

struct HealthContextVerificationCard: View {
    let verification: HealthContextVerification

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: verification.status == .unavailable ? "iphone.gen3" : "heart.text.square")
                .foregroundStyle(verification.status == .unavailable ? .orange : .green)
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(verification.title)
                        .font(.headline)
                    Spacer()
                    ConfidencePill(text: verification.status.label, confidence: verification.status)
                }
                Text(verification.detail)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
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

struct ListSectionTitle: View {
    let title: String

    init(_ title: String) {
        self.title = title
    }

    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundStyle(RunSignalTextStyle.prominentSecondary)
            .textCase(nil)
            .padding(.top, 4)
    }
}

enum RunSignalTextStyle {
    static let prominentSecondary = Color.primary.opacity(0.86)
    static let secondary = Color.primary.opacity(0.74)
    static let tertiary = Color.primary.opacity(0.62)
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
    var systemImage = "exclamationmark.circle"
    var tint = Color.orange

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: systemImage)
                .foregroundStyle(tint)
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
        .background(tint.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct EvidenceRefreshJobCard: View {
    let summary: EvidenceRefreshJobSummary
    let derivedSummary: DerivedAnalysisRefreshSummary
    let isRefreshing: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: symbol)
                    .foregroundStyle(color)
                    .frame(width: 18)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Month evidence refresh")
                        .font(.subheadline.bold())
                    Text("\(summary.scopeKey) - \(summary.statusTitle) - \(summary.detailText)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer()
                if isRefreshing {
                    ProgressView()
                }
            }

            MetricGrid(items: [
                MetricItem(title: "Progress", value: summary.progressText, detail: "Processed"),
                MetricItem(title: "Failed", value: "\(summary.failedCount)", detail: "Retryable"),
                MetricItem(title: "Pending", value: "\(summary.pendingCount)", detail: "Not finished"),
                MetricItem(title: "Derived", value: "\(derivedSummary.refreshedCount)", detail: derivedSummary.statusTitle),
                MetricItem(title: "Interruptions", value: "\(summary.interruptionCount)", detail: interruptionProof.statusTitle),
                MetricItem(title: "Updated", value: RunFormatters.date.string(from: summary.updatedAt), detail: "Local job"),
                MetricItem(title: "Checked", value: derivedCheckedText, detail: "Derived analytics")
            ])

            if let lastError = summary.lastError, !lastError.isEmpty {
                Text(lastError)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Text(summary.recoveryProofText)
                .font(.caption)
                .foregroundStyle(summary.pausedAfterRelaunch ? .orange : .secondary)
                .fixedSize(horizontal: false, vertical: true)

            if summary.canRecover {
                Button(action: action) {
                    Label(summary.actionTitle, systemImage: "arrow.triangle.2.circlepath")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(isRefreshing)
            }

            Text("Retry and resume preserve existing cached evidence unless HealthKit returns usable replacement evidence.")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .fixedSize(horizontal: false, vertical: true)

            Text(derivedSummary.detailText)
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Physical proof: \(interruptionProof.detailText)")
                .font(.caption2)
                .foregroundStyle(.tertiary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var symbol: String {
        switch summary.status {
        case .completed:
            return "checkmark.circle"
        case .failed, .blocked:
            return "exclamationmark.triangle"
        case .paused:
            return "pause.circle"
        case .queued, .running:
            return "arrow.triangle.2.circlepath"
        }
    }

    private var color: Color {
        switch summary.status {
        case .completed:
            return .green
        case .failed, .blocked:
            return .orange
        case .paused:
            return .blue
        case .queued, .running:
            return .secondary
        }
    }

    private var derivedCheckedText: String {
        derivedSummary.checkedAt.map { RunFormatters.date.string(from: $0) } ?? "Not checked"
    }

    private var interruptionProof: RefreshInterruptionProofSummary {
        RefreshInterruptionProofSummary.make(from: summary)
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

struct ReviewSignalGrid: View {
    let signals: [ReviewSignal]

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 118), spacing: 8)], spacing: 8) {
            ForEach(signals) { signal in
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline, spacing: 5) {
                        Text(signal.title)
                            .font(.caption2.bold())
                            .foregroundStyle(RunSignalTextStyle.prominentSecondary)
                        Spacer(minLength: 4)
                        Circle()
                            .fill(signalTint(signal.confidence))
                            .frame(width: 7, height: 7)
                            .accessibilityHidden(true)
                    }
                    Text(signal.value)
                        .font(.subheadline.monospacedDigit().bold())
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                    Text(signal.detail)
                        .font(.caption2)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(9)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .accessibilityElement(children: .combine)
            }
        }
    }

    private func signalTint(_ confidence: ConfidenceLevel) -> Color {
        switch confidence {
        case .strong:
            .green
        case .moderate:
            .blue
        case .limited, .weak:
            .orange
        case .blocked, .unavailable:
            .red
        }
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
                        .foregroundStyle(.primary)
                    Text(item.value)
                        .font(.headline.monospacedDigit())
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                    Text(item.detail)
                        .font(.caption2)
                        .foregroundStyle(.primary)
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
            MetricItem(title: "VO2 max", value: RunFormatters.number(context.vo2Max, decimals: 1), detail: context.vo2Max == nil ? "Physical-iPhone check needed" : "Latest Apple Health value"),
            MetricItem(title: "Resting HR", value: RunFormatters.number(context.restingHeartRate, suffix: " bpm"), detail: context.restingHeartRate == nil ? "Physical-iPhone check needed" : "Latest Apple Health value")
        ]
    }

    static func dataItems(for context: HealthContext) -> [MetricItem] {
        [
            MetricItem(title: "VO2 max", value: RunFormatters.number(context.vo2Max, decimals: 1), detail: context.vo2Max == nil ? "Physical-iPhone check needed" : "Latest Apple Health value"),
            MetricItem(title: "Resting HR", value: RunFormatters.number(context.restingHeartRate, suffix: " bpm"), detail: context.restingHeartRate == nil ? "Physical-iPhone check needed" : "Latest Apple Health value"),
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
