import MapKit
import SwiftUI
import UniformTypeIdentifiers

struct RunsView: View {
    var store: RunningAnalysisStore
    @State private var searchText = ""
    @State private var selectedYear: Int?
    @State private var selectedCategory: WeeklyRunCategory?
    @State private var selectedEnvironment: RunEnvironment?
    @State private var collapsedYears: Set<Int> = []

    private var runs: [CanonicalWorkout] {
        V1WorkoutFilters.completedRuns(from: store.workouts)
    }

    private var latestRun: CanonicalWorkout? {
        runs.first
    }

    private var years: [Int] {
        Array(Set(runs.map { Calendar.current.component(.year, from: $0.startDate) })).sorted(by: >)
    }

    private var filteredHistory: [CanonicalWorkout] {
        RunHistoryFiltering.filtered(
            Array(runs.dropFirst()),
            selectedYear: selectedYear,
            selectedCategory: selectedCategory,
            selectedEnvironment: selectedEnvironment,
            searchText: searchText
        )
    }

    private var historySections: [RunHistoryYearSection] {
        Dictionary(grouping: filteredHistory) {
            Calendar.current.component(.year, from: $0.startDate)
        }
        .map { RunHistoryYearSection(year: $0.key, workouts: $0.value.sorted { $0.startDate > $1.startDate }) }
        .sorted { $0.year > $1.year }
    }

    var body: some View {
        let healthPresentation = store.healthKitConnectionPresentation

        List {
            if healthPresentation.showsProgress, !runs.isEmpty {
                Section {
                    HealthKitImportProgressView(
                        presentation: healthPresentation,
                        progress: store.healthKitHistoryImportProgress
                    )
                }
            }

            if let latestRun {
                Section("Most Recent") {
                    NavigationLink {
                        WorkoutDetailView(store: store, workoutID: latestRun.id)
                    } label: {
                        FeaturedRunRow(workout: latestRun)
                    }
                    .task {
                        await store.hydrateCachedWorkoutPlanNameIfAvailable(for: latestRun.id)
                    }
                }
            }

            Section("Run History") {
                HStack(spacing: 10) {
                    Menu {
                        Button("All Years") { selectedYear = nil }
                        Divider()
                        ForEach(years, id: \.self) { year in
                            Button(String(year)) { selectedYear = year }
                        }
                    } label: {
                        Label(selectedYear.map(String.init) ?? "All Years", systemImage: "calendar")
                    }
                    .buttonStyle(.bordered)

                    Menu {
                        Button("All Types") { selectedCategory = nil }
                        Divider()
                        ForEach(WeeklyRunCategory.allCases) { category in
                            Button(category.label) { selectedCategory = category }
                        }
                    } label: {
                        Label(selectedCategory?.label ?? "All Types", systemImage: "line.3.horizontal.decrease.circle")
                    }
                    .buttonStyle(.bordered)
                }

                Menu {
                    Button("All Environments") { selectedEnvironment = nil }
                    Divider()
                    Button("Outdoor") { selectedEnvironment = .outdoor }
                    Button("Indoor") { selectedEnvironment = .indoor }
                } label: {
                    Label(selectedEnvironment?.label ?? "All Environments", systemImage: "figure.run")
                }
                .buttonStyle(.bordered)
                .accessibilityIdentifier("runs-environment-filter")

                if selectedYear != nil || selectedCategory != nil || selectedEnvironment != nil {
                    Button {
                        selectedYear = nil
                        selectedCategory = nil
                        selectedEnvironment = nil
                    } label: {
                        Label("Clear Filters", systemImage: "xmark.circle")
                    }
                    .buttonStyle(.bordered)
                }

                Text("\(filteredHistory.count) past \(filteredHistory.count == 1 ? "run" : "runs")")
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }

            if runs.isEmpty {
                Section {
                    EmptyStateView(
                        title: healthPresentation.phase == .disconnected
                            ? "No completed runs yet"
                            : healthPresentation.title,
                        message: healthPresentation.phase == .disconnected
                            ? "Connect Apple Health to load your completed running workouts. RunSignal does not place demo workouts in your history."
                            : healthPresentation.detailText
                    )
                    if healthPresentation.showsPrimaryAction {
                        Button {
                            Task { await store.performPrimaryHealthAction(healthPresentation.action) }
                        } label: {
                            Label(healthPresentation.action.title, systemImage: healthPresentation.action.systemImage)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    if healthPresentation.showsHealthAccessRecoveryGuidance {
                        HealthAccessRecoveryView()
                    }
                }
            } else if historySections.isEmpty {
                Section {
                    EmptyStateView(title: "No matching past runs", message: "Try another search, year, run type, or environment.")
                }
            } else {
                ForEach(historySections) { section in
                    Section {
                        if selectedYear != nil || !collapsedYears.contains(section.year) {
                            ForEach(section.workouts) { workout in
                                NavigationLink {
                                    WorkoutDetailView(store: store, workoutID: workout.id)
                                } label: {
                                    V1WorkoutRow(workout: workout)
                                }
                                .task {
                                    await store.hydrateCachedWorkoutPlanNameIfAvailable(for: workout.id)
                                }
                            }
                        }
                    } header: {
                        if selectedYear == nil {
                            Button {
                                if collapsedYears.contains(section.year) {
                                    collapsedYears.remove(section.year)
                                } else {
                                    collapsedYears.insert(section.year)
                                }
                            } label: {
                                HStack {
                                    Text(String(section.year))
                                    Spacer()
                                    Text("\(section.workouts.count) runs")
                                        .font(.caption)
                                        .foregroundStyle(RunSignalTextStyle.secondary)
                                    Image(systemName: collapsedYears.contains(section.year) ? "chevron.right" : "chevron.down")
                                }
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)
                            .textCase(nil)
                        } else {
                            Text(String(section.year))
                        }
                    }
                }
            }
        }
        .navigationTitle("Runs")
        .searchable(
            text: $searchText,
            prompt: "Search runs"
        )
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
        .refreshable {
            await store.refreshRunsListFromHealthKit()
        }
    }
}

struct HealthKitImportProgressView: View {
    let presentation: HealthKitConnectionPresentation
    var progress: HealthKitHistoryImportProgress? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                if progress == nil {
                    ProgressView()
                        .controlSize(.small)
                        .padding(.top, 2)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(presentation.title)
                        .font(.subheadline.weight(.semibold))
                    Text(presentation.detailText)
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            if let progress {
                ProgressView(value: progress.fractionComplete)
                    .progressViewStyle(.linear)
                HStack {
                    Text(progress.progressText)
                    Spacer()
                    Text("\(progress.importedWorkoutCount) runs available")
                }
                .font(.caption2)
                .foregroundStyle(RunSignalTextStyle.secondary)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("healthkit-import-progress")
    }
}

struct HealthAccessRecoveryView: View {
    var body: some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: 3) {
                Text("1. Open the Health app.")
                Text("2. Tap your profile picture.")
                Text("3. Open Privacy, then Apps, then RunSignal.")
                Text("4. Enable the running data you want RunSignal to read.")
                Text("5. Return to RunSignal and tap Refresh Apple Health.")
                Text("Apple protects read-permission privacy, so RunSignal cannot identify which individual Health data types were declined.")
                    .padding(.top, 4)
            }
            .font(.caption)
            .foregroundStyle(RunSignalTextStyle.secondary)
            .fixedSize(horizontal: false, vertical: true)
        } label: {
            Label("How to Review Health Access", systemImage: "checklist")
                .font(.subheadline.weight(.semibold))
        }
        .accessibilityIdentifier("health-access-recovery-guidance")
    }
}

private struct RunHistoryYearSection: Identifiable {
    let year: Int
    let workouts: [CanonicalWorkout]
    var id: Int { year }
}

enum RunHistoryFiltering {
    static func filtered(
        _ workouts: [CanonicalWorkout],
        selectedYear: Int?,
        selectedCategory: WeeklyRunCategory?,
        selectedEnvironment: RunEnvironment?,
        searchText: String,
        calendar: Calendar = .current
    ) -> [CanonicalWorkout] {
        workouts.filter { workout in
            if let selectedYear,
               calendar.component(.year, from: workout.startDate) != selectedYear {
                return false
            }
            if let selectedCategory,
               WeeklyRunCategory.make(from: workout) != selectedCategory {
                return false
            }
            if let selectedEnvironment,
               workout.environment != selectedEnvironment {
                return false
            }
            let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            guard !query.isEmpty else { return true }
            let searchableText = [
                RunWorkout(workout: workout).runnerFacingTitle,
                RunFormatters.weekdayDateWithYear.string(from: workout.startDate),
                workout.sourceName,
                workout.notes,
                RunWorkout(workout: workout).categoryLabel,
                workout.environment.label
            ].joined(separator: " ").lowercased()
            return searchableText.contains(query)
        }
    }
}

struct SettingsView: View {
    var store: RunningAnalysisStore
    @AppStorage("RunSignal.DeveloperModeEnabled") private var developerModeEnabled = false
    @AppStorage("RunSignal.TemperatureUnit") private var temperatureUnitRaw = TemperatureUnitPreference.system.rawValue
    @AppStorage("RunSignal.PrimaryDistanceUnit.v1") private var primaryDistanceUnitRaw = RunningDistanceUnit.initialDefault().rawValue
    @AppStorage("RunSignal.ShowSecondaryDistance.v1") private var showsSecondaryDistance = false

    var body: some View {
        let healthPresentation = store.healthKitConnectionPresentation

        Form {
            Section("Apple Health") {
                VStack(alignment: .leading, spacing: 10) {
                    if healthPresentation.showsProgress {
                        HealthKitImportProgressView(
                            presentation: healthPresentation,
                            progress: store.healthKitHistoryImportProgress
                        )
                    } else {
                        Label(healthPresentation.title, systemImage: "heart.text.square")
                            .font(.headline)
                        Text(healthPresentation.detailText)
                            .font(.subheadline)
                            .foregroundStyle(RunSignalTextStyle.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if healthPresentation.showsHealthAccessRecoveryGuidance {
                        HealthAccessRecoveryView()
                    }
                    if let importSummary = store.healthKitImportJobSummary {
                        LabeledContent(importSummary.statusTitle, value: importSummary.detailText)
                            .font(.caption)
                            .foregroundStyle(RunSignalTextStyle.secondary)
                    }
                    if healthPresentation.showsPrimaryAction {
                        Button {
                            Task { await store.performPrimaryHealthAction(healthPresentation.action) }
                        } label: {
                            Label(healthPresentation.action.title, systemImage: healthPresentation.action.systemImage)
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .accessibilityIdentifier("settings-healthkit-card")
            }

            Section("Display") {
                Picker("Primary distance & pace", selection: $primaryDistanceUnitRaw) {
                    Text("Miles").tag(RunningDistanceUnit.miles.rawValue)
                    Text("Kilometers").tag(RunningDistanceUnit.kilometers.rawValue)
                }

                Toggle("Show secondary distance & pace", isOn: $showsSecondaryDistance)

                Text("Your primary unit controls measured distance, pace, charts, and normal splits. Workout prescriptions and Best Effort names keep their original identity. When enabled, secondary distance appears smaller in parentheses on selected summary cards, and Workout Details also shows the opposite-unit pace beneath Avg pace.")
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Live Preview")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(RunSignalTextStyle.secondary)

                    LabeledContent("Distance") {
                        VStack(alignment: .trailing, spacing: 1) {
                            Text(previewPrimaryDistance)
                                .monospacedDigit()
                            if let previewSecondaryDistance {
                                Text("(\(previewSecondaryDistance))")
                                    .font(.caption2.monospacedDigit().weight(.medium))
                                    .foregroundStyle(RunSignalTextStyle.metricSupporting)
                            }
                        }
                    }
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel("Preview distance")
                    .accessibilityValue(previewAccessibilityDistance)
                    LabeledContent("Pace", value: RunFormatters.pace(300, policy: settingsDisplayPolicy))
                }

                Picker("Temperature", selection: $temperatureUnitRaw) {
                    ForEach(TemperatureUnitPreference.allCases) { preference in
                        Text(preference.label).tag(preference.rawValue)
                    }
                }
            }

            Section("Training") {
                NavigationLink {
                    HeartRateZoneSettingsView(store: store)
                } label: {
                    LabeledContent {
                        Text(store.currentHeartRateZoneProfile?.method.label
                             ?? (healthPresentation.showsProgress ? "Waiting for runs" : "Set Up"))
                            .foregroundStyle(RunSignalTextStyle.secondary)
                    } label: {
                        Label("Heart Rate Zones", systemImage: "heart.text.square")
                    }
                }
                Text("RunSignal keeps effective-dated zone profiles so changing zones does not rewrite older runs.")
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }

            Section("Data & Diagnostics") {
                DisclosureGroup {
                    LabeledContent("Runs", value: "\(V1WorkoutFilters.completedRuns(from: store.workouts).count)")
                    LabeledContent("Hidden duplicates", value: "\(store.workouts.filter(\.isDuplicate).count)")
                    LabeledContent("Route points", value: "\(store.includedWorkouts.map(\.routePointCount).reduce(0, +))")
                    LabeledContent("Samples", value: "\(store.includedWorkouts.map(\.seriesSampleCount).reduce(0, +))")
                    LabeledContent("Access request", value: store.authorizationState.label)
                    Text("RunSignal keeps the preferred Apple Watch or HealthKit workout visible and hides likely duplicates.")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                } label: {
                    Label("Data Details", systemImage: "chart.bar.doc.horizontal")
                }
            }

            Section("Advanced") {
                Toggle("Developer Mode", isOn: $developerModeEnabled)
                Text("Developer Mode reveals raw HealthKit evidence, audit exports, and parity tools.")
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)

                if developerModeEnabled {
                    NavigationLink {
                        HealthKitAuditView(store: store)
                    } label: {
                        Label("Raw HealthKit Audit", systemImage: "list.clipboard")
                    }

                    NavigationLink {
                        GoldenValidationView(store: store)
                    } label: {
                        Label("Apple Fitness Parity Checklist", systemImage: "checkmark.seal")
                    }

                    NavigationLink {
                        HealthKitPermissionReviewView(store: store)
                    } label: {
                        Label("HealthKit Permissions", systemImage: "lock.shield")
                    }
                }
            }
        }
        .navigationTitle("Settings")
    }

    private var settingsDisplayPolicy: RunDisplayPolicy {
        RunDisplayPolicy(
            primaryUnit: RunningDistanceUnit(rawValue: primaryDistanceUnitRaw) ?? RunningDistanceUnit.initialDefault(),
            showsSecondaryDistance: showsSecondaryDistance
        )
    }

    private var previewPrimaryDistance: String {
        RunFormatters.distance(5_000, policy: settingsDisplayPolicy)
    }

    private var previewSecondaryDistance: String? {
        RunFormatters.secondaryDistance(5_000, policy: settingsDisplayPolicy)
    }

    private var previewAccessibilityDistance: String {
        RunFormatters.accessibilityDistance(5_000, policy: settingsDisplayPolicy, includeSecondary: true)
    }
}

enum HeartRateZoneSettingsPresentation: Equatable {
    case active
    case draft
    case waitingForRunData
    case unavailable

    var statusTitle: String {
        switch self {
        case .active: "Active Profile"
        case .draft: "Save Changes"
        case .waitingForRunData: "Waiting for Run Data"
        case .unavailable: "Profile Unavailable"
        }
    }

    var supportingText: String {
        switch self {
        case .active:
            "These zones are active now. Each workout uses the profile that was active when the workout began."
        case .draft:
            "These are proposed zones. Save Changes to make them active for workouts starting from now on; nothing changes until you save."
        case .waitingForRunData:
            "RunSignal is still loading the heart-rate inputs needed for automatic zones. You can return here when run-history loading finishes."
        case .unavailable:
            "RunSignal needs valid heart-rate inputs before this profile can be saved."
        }
    }

    static func make(
        hasPreview: Bool,
        previewMatchesCurrentProfile: Bool,
        isLoadingRunData: Bool = false
    ) -> Self {
        guard hasPreview else { return isLoadingRunData ? .waitingForRunData : .unavailable }
        return previewMatchesCurrentProfile ? .active : .draft
    }

    static func shouldOfferApplyToAllWorkouts(profileCount: Int) -> Bool {
        profileCount > 1
    }
}

private struct HeartRateZoneSettingsView: View {
    var store: RunningAnalysisStore

    @State private var selectedMethod = HeartRateZoneMethod.automaticHeartRateReserve
    @State private var manualBounds = ManualHeartRateZoneBoundaries.defaultLowerBounds
    @State private var maximumHeartRateOverride = ""
    @State private var saveMessage: String?
    @State private var showingResetHistoryConfirmation = false
    @State private var didLoadInitialProfile = false

    private var automaticInputs: AutomaticHeartRateZoneInputs? {
        store.automaticHeartRateZoneInputs()
    }

    private var maximumInput: MaximumHeartRateLookbackResult? {
        store.maximumHeartRateLookback()
    }

    private var parsedManualBounds: [Int]? {
        let boundaries = ManualHeartRateZoneBoundaries(zoneLowerBounds: manualBounds)
        return boundaries.zoneLowerBounds == manualBounds ? manualBounds : nil
    }

    private var manualBoundaryBinding: Binding<ManualHeartRateZoneBoundaries> {
        Binding(
            get: { ManualHeartRateZoneBoundaries(zoneLowerBounds: manualBounds) },
            set: {
                manualBounds = $0.zoneLowerBounds
                saveMessage = nil
            }
        )
    }

    private var selectedAutomaticInputs: AutomaticHeartRateZoneInputs? {
        guard !maximumHeartRateOverride.isEmpty else { return automaticInputs }
        guard let maximum = Int(maximumHeartRateOverride),
              let restingValue = store.healthContext.restingHeartRate else { return nil }
        let resting = Int(restingValue.rounded())
        guard maximum >= 80, maximum <= 230, maximum >= resting + 20 else { return nil }
        return AutomaticHeartRateZoneInputs(
            restingHeartRate: resting,
            maximumHeartRate: maximum,
            maximumHeartRateDate: nil,
            lookbackMonths: HeartRateZoneProfileFactory.automaticLookbackMonths
        )
    }

    private var selectedMaximumInput: MaximumHeartRateLookbackResult? {
        guard !maximumHeartRateOverride.isEmpty else { return maximumInput }
        guard let maximum = Int(maximumHeartRateOverride), maximum >= 80, maximum <= 230 else { return nil }
        return MaximumHeartRateLookbackResult(
            maximumHeartRate: maximum,
            maximumHeartRateDate: nil,
            lookbackMonths: HeartRateZoneProfileFactory.automaticLookbackMonths
        )
    }

    private var previewProfile: HeartRateZoneProfile? {
        let now = Date()
        switch selectedMethod {
        case .automaticHeartRateReserve:
            return selectedAutomaticInputs.map {
                HeartRateZoneProfileFactory.automaticProfile(
                    inputs: $0,
                    effectiveDate: now,
                    createdAt: now,
                    maximumHeartRateIsUserOverride: !maximumHeartRateOverride.isEmpty
                )
            }
        case .percentMaximum:
            return selectedMaximumInput.map {
                HeartRateZoneProfileFactory.percentMaximumProfile(
                    maximumInput: $0,
                    effectiveDate: now,
                    createdAt: now,
                    maximumHeartRateIsUserOverride: !maximumHeartRateOverride.isEmpty
                )
            }
        case .manual:
            return parsedManualBounds.flatMap {
                HeartRateZoneProfileFactory.manualProfile(zoneLowerBounds: $0, effectiveDate: now, createdAt: now)
            }
        }
    }

    private var previewMatchesCurrentProfile: Bool {
        guard let previewProfile,
              let current = store.currentHeartRateZoneProfile else { return false }
        return current.method == previewProfile.method
            && current.restingHeartRate == previewProfile.restingHeartRate
            && current.maximumHeartRate == previewProfile.maximumHeartRate
            && current.maximumHeartRateIsUserOverride == previewProfile.maximumHeartRateIsUserOverride
            && current.zoneLowerBounds == previewProfile.zoneLowerBounds
    }

    private var presentation: HeartRateZoneSettingsPresentation {
        .make(
            hasPreview: previewProfile != nil,
            previewMatchesCurrentProfile: previewMatchesCurrentProfile,
            isLoadingRunData: store.healthKitConnectionPresentation.showsProgress
        )
    }

    var body: some View {
        Form {
            if presentation == .waitingForRunData {
                Section {
                    HealthKitImportProgressView(presentation: store.healthKitConnectionPresentation)
                }
            }

            Section("Method") {
                Picker("Calculation", selection: $selectedMethod) {
                    ForEach(HeartRateZoneMethod.allCases) { method in
                        Text(method.label).tag(method)
                    }
                }
                Text(selectedMethod.detail)
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }

            if selectedMethod != .manual {
                Section("Automatic Inputs") {
                    LabeledContent("Maximum HR lookback", value: "6 months")
                    if selectedMethod == .automaticHeartRateReserve {
                        LabeledContent(
                            "Resting heart rate",
                            value: automaticInputs.map { "\($0.restingHeartRate) bpm" } ?? "Unavailable"
                        )
                    }
                    LabeledContent(
                        "Maximum heart rate",
                        value: selectedMaximumInput.map { "\($0.maximumHeartRate) bpm" } ?? "Unavailable"
                    )
                    TextField("Confirmed maximum override (optional)", text: $maximumHeartRateOverride)
                    if let date = maximumInput?.maximumHeartRateDate, maximumHeartRateOverride.isEmpty {
                        LabeledContent("Maximum observed", value: RunFormatters.workoutFullDate.string(from: date))
                    }
                    Text("The maximum comes from credible completed running workouts in the previous six months. Automatic HRR uses the latest resting-heart-rate value available from Apple Health.")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }
            }

            Section(selectedMethod == .manual ? "Manual Zones" : "Calculated Zones") {
                if selectedMethod == .manual {
                    Text("Tap a zone to edit its lower or upper limit. Changing a limit automatically moves the touching limit in the adjacent zone, so there are no gaps or overlaps.")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)

                    ForEach(1...5, id: \.self) { zone in
                        NavigationLink {
                            ManualHeartRateZoneEditorView(
                                zone: zone,
                                boundaries: manualBoundaryBinding
                            )
                        } label: {
                            LabeledContent(
                                "Zone \(zone)",
                                value: ManualHeartRateZoneBoundaries(zoneLowerBounds: manualBounds)
                                    .ranges[zone - 1]
                                    .displayRange
                            )
                        }
                    }
                }

                if selectedMethod != .manual, let previewProfile {
                    ForEach(previewProfile.ranges) { range in
                        LabeledContent("Zone \(range.zone)", value: range.displayRange)
                    }
                } else if selectedMethod != .manual {
                    Text("RunSignal needs a recent running maximum and a resting heart rate from Apple Health before this method can be used.")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }
            }

            Section {
                if presentation == .active {
                    Label(presentation.statusTitle, systemImage: "checkmark.circle.fill")
                        .font(.headline)
                        .foregroundStyle(.green)
                        .frame(maxWidth: .infinity)
                } else if presentation == .waitingForRunData {
                    Label(presentation.statusTitle, systemImage: "hourglass")
                        .font(.headline)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .frame(maxWidth: .infinity)
                } else {
                    Button {
                        let saved = store.saveHeartRateZoneProfile(
                            method: selectedMethod,
                            manualLowerBounds: parsedManualBounds ?? [],
                            maximumHeartRateOverride: Int(maximumHeartRateOverride)
                        )
                        saveMessage = saved
                            ? "\(selectedMethod.label) is now active."
                            : "The profile could not be saved because required values are unavailable or invalid."
                    } label: {
                        Label(presentation.statusTitle, systemImage: "checkmark.circle")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(presentation == .unavailable)
                }

                Text(presentation.supportingText)
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)

                if let saveMessage {
                    Text(saveMessage)
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }

                Text("Saving creates a new effective-dated profile. Earlier workouts keep the profile that was active when they began, so a later lab test does not silently reclassify your history.")
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }

            if !store.heartRateZoneProfiles.isEmpty {
                Section("Profile History") {
                    if HeartRateZoneSettingsPresentation.shouldOfferApplyToAllWorkouts(
                        profileCount: store.heartRateZoneProfiles.count
                    ) {
                        Button("Apply Current Profile to All Workouts", role: .destructive) {
                            showingResetHistoryConfirmation = true
                        }
                    }

                    ForEach(store.heartRateZoneProfiles.sorted { $0.effectiveDate > $1.effectiveDate }) { profile in
                        VStack(alignment: .leading, spacing: 3) {
                            HStack {
                                Text(profile.method.label)
                                    .font(.subheadline.bold())
                                Spacer()
                                Text(effectiveDateText(profile))
                                    .font(.caption)
                                    .foregroundStyle(RunSignalTextStyle.secondary)
                            }
                            Text(profile.ranges.map { "Z\($0.zone) \($0.displayRange)" }.joined(separator: " · "))
                                .font(.caption2)
                                .foregroundStyle(RunSignalTextStyle.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Heart Rate Zones")
        .runSignalInlineNavigationTitle()
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
        .onAppear {
            guard !didLoadInitialProfile else { return }
            didLoadInitialProfile = true
            guard let current = store.currentHeartRateZoneProfile else { return }
            selectedMethod = current.method
            manualBounds = current.zoneLowerBounds
            maximumHeartRateOverride = current.maximumHeartRateIsUserOverride
                ? current.maximumHeartRate.map(String.init) ?? ""
                : ""
        }
        .onChange(of: selectedMethod) {
            saveMessage = nil
        }
        .onChange(of: maximumHeartRateOverride) {
            saveMessage = nil
        }
        .onChange(of: manualBounds) {
            saveMessage = nil
        }
        .confirmationDialog(
            "Apply current profile to all workouts?",
            isPresented: $showingResetHistoryConfirmation,
            titleVisibility: .visible
        ) {
            Button("Apply to All Workouts", role: .destructive) {
                if store.resetHeartRateZoneProfileHistoryToCurrent() {
                    let method = store.currentHeartRateZoneProfile?.method.label ?? "Current profile"
                    saveMessage = "\(method) now applies to all workouts. Earlier profile history was removed."
                }
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This removes earlier profiles and recalculates past workout time in zones using the current profile. This action changes historical results and cannot be undone.")
        }
    }

    private func effectiveDateText(_ profile: HeartRateZoneProfile) -> String {
        let isCurrent = profile.id == store.currentHeartRateZoneProfile?.id
        if isCurrent, profile.isHistoricalBackfill {
            return "Active · All workouts"
        }
        if isCurrent {
            return "Active since \(RunFormatters.shortDate.string(from: profile.effectiveDate))"
        }
        return profile.isHistoricalBackfill
            ? "Earlier workouts"
            : RunFormatters.shortDate.string(from: profile.effectiveDate)
    }
}

private struct ManualHeartRateZoneEditorView: View {
    let zone: Int
    @Binding var boundaries: ManualHeartRateZoneBoundaries

    var body: some View {
        Form {
            if zone > 1 {
                Section("Lower Limit") {
                    TextField("Beats per Minute", value: lowerLimitBinding, format: .number)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                }
            }

            if zone < 5 {
                Section("Upper Limit") {
                    TextField("Beats per Minute", value: upperLimitBinding, format: .number)
                        #if os(iOS)
                        .keyboardType(.numberPad)
                        #endif
                }
            }

            Section {
                Text("Zone \(zone) is currently \(boundaries.ranges[zone - 1].displayRange). Adjacent zone limits update automatically.")
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }
        }
        .navigationTitle("Zone \(zone)")
        .runSignalInlineNavigationTitle()
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
    }

    private var lowerLimitBinding: Binding<Int> {
        Binding(
            get: { boundaries.lowerLimit(for: zone) ?? 31 },
            set: { boundaries.setLowerLimit($0, for: zone) }
        )
    }

    private var upperLimitBinding: Binding<Int> {
        Binding(
            get: { boundaries.upperLimit(for: zone) ?? 229 },
            set: { boundaries.setUpperLimit($0, for: zone) }
        )
    }
}

struct FeaturedRunRow: View {
    let workout: CanonicalWorkout
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    private var run: RunWorkout {
        RunWorkout(workout: workout)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(run.runnerFacingTitle)
                .font(.headline)
                .fixedSize(horizontal: false, vertical: true)
            HStack {
                Text(RunFormatters.weekdayDateWithYear.string(from: workout.startDate))
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                Spacer()
                RunTypeTag(runType: workout.effectiveRunType)
            }
            MetricGrid(items: [
                MetricItem(
                    title: "Distance",
                    value: RunFormatters.distance(workout.distanceMeters, policy: runDisplayPolicy),
                    detail: workout.sourceName,
                    secondaryValue: RunFormatters.secondaryDistance(workout.distanceMeters, policy: runDisplayPolicy),
                    accessibilityValue: RunFormatters.accessibilityDistance(
                        workout.distanceMeters,
                        policy: runDisplayPolicy,
                        includeSecondary: true
                    )
                ),
                MetricItem(title: "Time", value: RunFormatters.duration(workout.durationSeconds), detail: "Workout"),
                MetricItem(title: "Pace", value: RunFormatters.pace(workout.paceSecondsPerKm, policy: runDisplayPolicy), detail: "Average"),
                MetricItem(title: "Avg HR", value: RunFormatters.number(workout.averageHeartRate, suffix: " bpm"), detail: "HealthKit")
            ])
        }
        .padding(.vertical, 6)
    }
}

struct V1WorkoutRow: View {
    let workout: CanonicalWorkout
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    private var run: RunWorkout {
        RunWorkout(workout: workout)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(run.runnerFacingTitle)
                .font(.headline)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            HStack(alignment: .center) {
                Text(RunFormatters.weekdayDateWithYear.string(from: workout.startDate))
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                Spacer()
                RunTypeTag(runType: workout.effectiveRunType)
            }
            Text("\(RunFormatters.distance(workout.distanceMeters, policy: runDisplayPolicy)) · \(RunFormatters.duration(workout.durationSeconds)) · \(RunFormatters.pace(workout.paceSecondsPerKm, policy: runDisplayPolicy))")
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
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

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
                Text(RunFormatters.pace(effort.paceSecondsPerKm, policy: runDisplayPolicy))
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
            return RunFormatters.compactDistance(effort.distanceMeters, policy: runDisplayPolicy)
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
                                .foregroundStyle(RunSignalTextStyle.secondary)
                        }
                        Text(item.healthKitIdentifier)
                            .font(.caption.monospaced())
                            .foregroundStyle(RunSignalTextStyle.secondary)
                        Text(item.reason)
                            .font(.caption)
                            .foregroundStyle(RunSignalTextStyle.secondary)
                        Label(item.visibleFeature, systemImage: "eye")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.blue)
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
                        .foregroundStyle(RunSignalTextStyle.secondary)
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
                            .foregroundStyle(RunSignalTextStyle.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    VStack(alignment: .trailing, spacing: 3) {
                        Text(field.appValue)
                            .font(.caption.monospacedDigit())
                        Text(field.expectedValue)
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(RunSignalTextStyle.secondary)
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
                    EmptyStateView(title: "No workouts to audit", message: "Connect Apple Health before reviewing field coverage.")
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
                        .foregroundStyle(RunSignalTextStyle.secondary)
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
                            .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .lineLimit(2)
            }
            Text(field.value)
                .font(.subheadline.monospacedDigit().bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(field.detail)
                .font(.caption2)
                .foregroundStyle(RunSignalTextStyle.tertiary)
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
                .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
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
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy
    @AppStorage("RunSignal.DeveloperModeEnabled") private var developerModeEnabled = false
    @State private var presentation: WorkoutDetailPresentation?
    @State private var routeAchievements: [WorkoutRouteAchievement] = []
    @State private var showingShareRun = false

    private var workout: CanonicalWorkout? {
        store.workouts.first { $0.id == workoutID }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 14) {
                if let workout {
                    WorkoutDetailHero(workout: workout)

                    WorkoutCategoryCard(store: store, workout: workout)

                    if let progress = store.analysisProgressByWorkoutID[workout.id], progress.stage != .ready {
                        WorkoutAnalysisProgressCard(progress: progress) {
                            Task { await store.loadFullAnalysisForWorkout(workoutID: workout.id) }
                        }
                    }

                    FitnessWorkoutMetrics(workout: workout)

                    WorkoutEnvironmentCard(workout: workout)

                    RouteAndSeriesPanel(
                        workout: workout,
                        achievements: routeAchievements,
                        lifetimeRankingsVerified: store.bestEffortCoverageSummary.isComplete,
                        isLoading: store.analyzingWorkoutIDs.contains(workout.id)
                    )

                    WorkoutChartsPanel(
                        store: store,
                        workout: workout,
                        isLoading: store.analyzingWorkoutIDs.contains(workout.id)
                    )

                    if let presentation {
                        SplitsAndEventsPanel(
                            workout: workout,
                            segments: presentation.segments,
                            supportedIntervals: presentation.supportedIntervals,
                            intervalUnavailableMessage: presentation.intervalUnavailableMessage
                        )
                    }

                    if developerModeEnabled {
                        NavigationLink {
                            RawHealthKitWorkoutDebugView(store: store, workout: workout)
                        } label: {
                            Label("Developer evidence", systemImage: "wrench.and.screwdriver")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }

                } else {
                    EmptyStateView(title: "Workout missing", message: "The selected workout is no longer in local state.")
                }
            }
            .padding()
            .padding(.bottom, 220)
        }
        .navigationTitle(workout.map { RunWorkout(workout: $0).runnerFacingTitle } ?? "Workout")
        .runSignalInlineNavigationTitle()
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 112)
        }
        .task(id: workoutID) {
            await store.hydrateCachedEvidenceIfAvailable(for: workoutID)
            store.prioritizeFullAnalysisForWorkout(workoutID: workoutID)
        }
        .task(id: workout?.evidence?.loadedAt) {
            guard let workout else {
                presentation = nil
                return
            }
            let analysis = store.derivedAnalysis(for: workout.id)
            do {
                let nextPresentation = try await WorkoutViewComputation.detailPresentation(
                    workout: workout,
                    analysis: analysis
                )
                try Task.checkCancellation()
                presentation = nextPresentation
            } catch is CancellationError {
                return
            } catch {
                assertionFailure("Unexpected workout presentation error: \(error)")
            }
        }
        .task(id: routeAchievementSignature) {
            guard let workout,
                  let route = workout.evidence?.route,
                  route.count >= 2
            else {
                routeAchievements = []
                return
            }
            let rankedRecords = store.lifetimeBestEffortAchievements(for: workout.id)
            do {
                let nextAchievements = try await WorkoutViewComputation.routeAchievements(
                    route: route,
                    rankedRecords: rankedRecords,
                    workoutID: workout.id
                )
                try Task.checkCancellation()
                routeAchievements = nextAchievements
            } catch is CancellationError {
                return
            } catch {
                assertionFailure("Unexpected route achievement error: \(error)")
            }
        }
        .modifier(
            WorkoutSharePresentationModifier(
                workout: workout,
                presentation: presentation,
                policy: runDisplayPolicy,
                isPresented: $showingShareRun
            )
        )
    }

    private var routeAchievementSignature: String {
        let coverage = store.bestEffortCoverageSummary.isComplete ? "complete" : "pending"
        let records = store.lifetimeBestEffortAchievements(for: workoutID)
            .map { ranked in
                let duration = ranked.record.durationSeconds ?? 0
                return "\(ranked.record.bucket.rawValue)-\(ranked.lifetimeRank)-\(duration)"
            }
            .joined(separator: "|")
        let loadedAt = workout?.evidence?.loadedAt.timeIntervalSinceReferenceDate ?? 0
        return "\(workoutID)-\(loadedAt)-\(coverage)-\(records)"
    }
}

private struct WorkoutSharePresentationModifier: ViewModifier {
    let workout: CanonicalWorkout?
    let presentation: WorkoutDetailPresentation?
    let policy: RunDisplayPolicy
    @Binding var isPresented: Bool

    @ViewBuilder
    func body(content: Content) -> some View {
        #if os(iOS)
        content
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPresented = true
                    } label: {
                        Label("Share Run", systemImage: "square.and.arrow.up")
                    }
                    .disabled(workout == nil || presentation == nil)
                    .accessibilityIdentifier("workout-share-run")
                }
            }
            .sheet(isPresented: $isPresented) {
                if let workout, let presentation {
                    RunShareSheet(
                        workout: workout,
                        presentation: presentation,
                        policy: policy
                    )
                }
            }
        #else
        content
        #endif
    }
}

extension View {
    @ViewBuilder
    func runSignalInlineNavigationTitle() -> some View {
        #if os(iOS)
        navigationBarTitleDisplayMode(.inline)
        #else
        self
        #endif
    }
}

private struct WorkoutDetailHero: View {
    let workout: CanonicalWorkout

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(RunFormatters.workoutFullDate.string(from: workout.startDate))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(RunSignalTextStyle.secondary)

            Text(RunWorkout(workout: workout).runnerFacingTitle)
                .font(.title2.bold())
                .fixedSize(horizontal: false, vertical: true)

            HStack(spacing: 8) {
                Label(timeRange, systemImage: "clock")
                if let cityName = workout.evidence?.cityName {
                    Label(cityName, systemImage: "location")
                } else {
                    Label(workout.sourceName, systemImage: "applewatch")
                }
            }
            .font(.caption)
            .foregroundStyle(RunSignalTextStyle.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityIdentifier("workout-detail-hero")
    }

    private var timeRange: String {
        "\(RunFormatters.workoutTime.string(from: workout.startDate))–\(RunFormatters.workoutTime.string(from: workout.endDate))"
    }
}

private struct WorkoutAnalysisProgressCard: View {
    let progress: WorkoutAnalysisProgress
    let retry: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            if progress.isActive {
                ProgressView()
                    .controlSize(.small)
            } else {
                Image(systemName: progress.stage == .failed ? "exclamationmark.triangle" : "pause.circle")
                    .foregroundStyle(progress.stage == .failed ? .red : .orange)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.subheadline.bold())
                Text(progress.message)
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if progress.stage == .failed || progress.stage == .paused {
                    Button("Try Again", action: retry)
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.blue.opacity(0.08))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .accessibilityIdentifier("workout-analysis-progress")
    }

    private var title: String {
        switch progress.stage {
        case .queued: "Analysis queued"
        case .readingHealthKit: "Loading workout details"
        case .processing: "Finishing analysis"
        case .ready: "Analysis ready"
        case .paused: "Analysis paused"
        case .failed: "Analysis needs another try"
        }
    }
}

private struct WorkoutEnvironmentCard: View {
    let workout: CanonicalWorkout
    @AppStorage("RunSignal.TemperatureUnit") private var temperatureUnitRaw = TemperatureUnitPreference.system.rawValue

    var body: some View {
        if workout.evidence?.cityName != nil || !items.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader("Conditions")
                if let cityName = workout.evidence?.cityName {
                    HStack(spacing: 12) {
                        Image(systemName: "location.fill")
                            .foregroundStyle(.blue)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(cityName)
                                .font(.headline)
                            Text("Approximate city based on this workout's route")
                                .font(.caption)
                                .foregroundStyle(RunSignalTextStyle.secondary)
                        }
                        Spacer()
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                MetricGrid(items: items)
            }
        }
    }

    private var items: [MetricItem] {
        var values: [MetricItem] = []
        if let temperature = workout.evidence?.weather?.temperatureCelsius {
            values.append(
                MetricItem(
                    title: "Temperature",
                    value: RunFormatters.temperature(temperature, preference: temperatureUnit),
                    detail: "Workout weather"
                )
            )
        }
        if let humidity = workout.evidence?.weather?.humidityPercent {
            values.append(MetricItem(title: "Humidity", value: RunFormatters.humidity(humidity), detail: "Workout weather"))
        }
        return values
    }

    private var temperatureUnit: TemperatureUnitPreference {
        TemperatureUnitPreference(rawValue: temperatureUnitRaw) ?? .system
    }
}

struct FitnessWorkoutMetrics: View {
    let workout: CanonicalWorkout
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Workout Details")
            MetricGrid(items: items)
        }
    }

    private var items: [MetricItem] {
        var values = [
            MetricItem(title: "Workout time", value: RunFormatters.duration(workout.durationSeconds), detail: elapsedDetail)
        ]
        if workout.distanceMeters != nil {
            values.append(
                MetricItem(
                    title: "Distance",
                    value: RunFormatters.distance(workout.distanceMeters, policy: runDisplayPolicy),
                    detail: "Apple Health",
                    secondaryValue: RunFormatters.secondaryDistance(workout.distanceMeters, policy: runDisplayPolicy),
                    accessibilityValue: RunFormatters.accessibilityDistance(
                        workout.distanceMeters,
                        policy: runDisplayPolicy,
                        includeSecondary: true
                    )
                )
            )
        }
        if workout.paceSecondsPerKm != nil {
            values.append(
                MetricItem(
                    title: "Avg pace",
                    value: RunFormatters.pace(workout.paceSecondsPerKm, policy: runDisplayPolicy),
                    detail: "Distance / time",
                    secondaryValue: RunFormatters.secondaryPace(workout.paceSecondsPerKm, policy: runDisplayPolicy),
                    accessibilityValue: RunFormatters.accessibilityPace(
                        workout.paceSecondsPerKm,
                        policy: runDisplayPolicy,
                        includeSecondary: true
                    )
                )
            )
        }
        if workout.averageHeartRate != nil {
            values.append(MetricItem(title: "Avg heart rate", value: RunFormatters.number(workout.averageHeartRate, suffix: " bpm"), detail: "Workout average"))
        }
        if workout.activeEnergyKilocalories != nil {
            values.append(MetricItem(title: "Active calories", value: RunFormatters.calories(workout.activeEnergyKilocalories), detail: "Apple Health"))
        }
        if workout.totalEnergyKilocalories != nil {
            values.append(MetricItem(title: "Total calories", value: totalCaloriesText, detail: totalCaloriesDetail))
        }
        if workout.maxHeartRate != nil {
            values.append(MetricItem(title: "Max heart rate", value: RunFormatters.number(workout.maxHeartRate, suffix: " bpm"), detail: "Workout maximum"))
        }
        if workout.averagePower != nil {
            values.append(MetricItem(title: "Avg power", value: RunFormatters.number(workout.averagePower, suffix: " W"), detail: workout.runningPowerSampleCount > 0 ? "Series" : "Summary"))
        }
        if workout.fullStepCadence != nil {
            values.append(MetricItem(title: "Avg cadence", value: RunFormatters.number(workout.fullStepCadence, suffix: " spm"), detail: "Full steps/min"))
        }
        if workout.elevationGainMeters != nil {
            values.append(MetricItem(title: "Elevation gain", value: RunFormatters.number(workout.elevationGainMeters, suffix: " m"), detail: "Route altitude"))
        }
        return values
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

private struct WorkoutCategoryCard: View {
    var store: RunningAnalysisStore
    let workout: CanonicalWorkout

    private var currentRunType: RunType {
        if workout.manualRunType == nil,
           workout.importedRunType == nil,
           let suggestion,
           suggestion.confidence == .strong,
           suggestion.runType != .unknown {
            return suggestion.runType.visibleCategory
        }
        return (workout.manualRunType ?? workout.effectiveRunType).visibleCategory
    }

    private var sourceLabel: String {
        if workout.manualRunType == nil,
           workout.importedRunType == nil,
           suggestion?.confidence == .strong,
           suggestion?.runType != .unknown {
            return "Auto-classified"
        }
        return workout.runTypeTrust.kind.label
    }

    private var suggestion: RunTypeSuggestion? {
        store.runTypeSuggestion(for: workout.id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Run Type")
                        .font(.subheadline.bold())
                    Text(sourceLabel)
                        .font(.caption2)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }

                Spacer()

                if store.pendingManualWorkoutIDs.contains(workout.id) {
                    ProgressView()
                        .controlSize(.small)
                        .accessibilityLabel("Saving run type")
                }
            }

            Menu {
                ForEach(RunType.visibleCases) { runType in
                    Button(runType.label) {
                        store.update(workoutID: workout.id, manualRunType: runType, notes: workout.notes)
                    }
                }

                if workout.manualRunType != nil {
                    Divider()
                    Button("Clear Review") {
                        store.update(workoutID: workout.id, manualRunType: nil, notes: workout.notes)
                    }
                }
            } label: {
                HStack {
                    Label(currentRunType.label, systemImage: "tag")
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.caption.bold())
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .accessibilityLabel("Set run type")

            if workout.manualRunType == nil,
               workout.importedRunType == nil,
               let suggestion {
                HStack(alignment: .top, spacing: 6) {
                    Image(systemName: "sparkles")
                        .foregroundStyle(.blue)
                    Text(suggestionText(suggestion))
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .accessibilityIdentifier("run-type-suggestion")
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func suggestionText(_ suggestion: RunTypeSuggestion) -> String {
        if suggestion.confidence == .strong, suggestion.runType != .unknown {
            return "Auto-classified as \(suggestion.runType.label): \(suggestion.detail). Change it above if this run had a different purpose."
        }
        return "Suggested \(suggestion.runType.label): \(suggestion.detail)"
    }
}

struct RouteAndSeriesPanel: View {
    let workout: CanonicalWorkout
    var achievements: [WorkoutRouteAchievement] = []
    var lifetimeRankingsVerified = true
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Route")
            if let route = workout.evidence?.route, route.count >= 2 {
                WorkoutRouteMap(route: route, achievements: achievements)
                if !lifetimeRankingsVerified {
                    Label(
                        "Lifetime markers appear after RunSignal finishes verifying Best Efforts across your eligible run history.",
                        systemImage: "hourglass"
                    )
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                }
            } else if isLoading {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.thinMaterial)
                    .frame(height: 220)
                    .overlay {
                        VStack(spacing: 8) {
                            ProgressView()
                            Text("Loading map")
                                .font(.caption)
                                .foregroundStyle(RunSignalTextStyle.secondary)
                        }
                    }
                    .accessibilityIdentifier("route-loading-placeholder")
            } else {
                NoticeCard(
                    title: "Map unavailable",
                    message: "Apple Health did not provide route coordinates for this workout.",
                    systemImage: routeIcon,
                    tint: routeTint
                )
            }
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
    var achievements: [WorkoutRouteAchievement] = []
    @State private var selectedAchievementID: String?

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

    private var selectedAchievement: WorkoutRouteAchievement? {
        achievements.first { $0.id == selectedAchievementID }
    }

    var body: some View {
        Map(initialPosition: .region(region), selection: $selectedAchievementID) {
            MapPolyline(coordinates: coordinates)
                .stroke(.blue, lineWidth: 4)
            if let selectedAchievement {
                MapPolyline(coordinates: selectedAchievement.route.map(\.coordinate))
                    .stroke(selectedAchievement.tint, lineWidth: 7)
            }
            if let start = coordinates.first {
                Marker("Start", systemImage: "play.fill", coordinate: start)
            }
            if let finish = coordinates.last {
                Marker("Finish", systemImage: "flag.checkered", coordinate: finish)
            }
            ForEach(achievements) { achievement in
                Marker(
                    achievement.title,
                    systemImage: "medal.fill",
                    coordinate: achievement.marker.coordinate
                )
                .tint(achievement.tint)
                .tag(achievement.id)
            }
        }
        .frame(height: 220)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel("Workout route map")
        .accessibilityValue(achievementAccessibilityValue)
        .accessibilityIdentifier("workout-route-map")
        .overlay(alignment: .bottom) {
            if let selectedAchievement {
                HStack(spacing: 8) {
                    Image(systemName: "medal.fill")
                        .foregroundStyle(selectedAchievement.tint)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(selectedAchievement.title)
                            .font(.caption.bold())
                        Text(RunFormatters.duration(selectedAchievement.durationSeconds))
                            .font(.caption2.monospacedDigit())
                            .foregroundStyle(RunSignalTextStyle.secondary)
                    }
                    Spacer(minLength: 0)
                }
                .padding(10)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(8)
                .allowsHitTesting(false)
                .accessibilityIdentifier("route-achievement-callout")
            }
        }
    }

    private var achievementAccessibilityValue: String {
        guard !achievements.isEmpty else { return "No lifetime achievements on this route" }
        return achievements.map(\.title).joined(separator: ", ")
    }
}

private extension WorkoutRoutePoint {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

private extension WorkoutRouteAchievement {
    var tint: Color {
        switch lifetimeRank {
        case 1: Color(red: 0.96, green: 0.74, blue: 0.12)
        case 2: Color(red: 0.72, green: 0.75, blue: 0.79)
        case 3: Color(red: 0.72, green: 0.42, blue: 0.20)
        default: .secondary
        }
    }
}

struct WorkoutChartsPanel: View {
    var store: RunningAnalysisStore
    let workout: CanonicalWorkout
    let isLoading: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Charts")
            if workout.evidence != nil {
                WorkoutChartDeck(
                    workout: workout,
                    heartRateZoneProfile: store.heartRateZoneProfile(for: workout.startDate)
                )
            } else if isLoading {
                VStack(spacing: 10) {
                    ForEach(0..<3, id: \.self) { _ in
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.thinMaterial)
                            .frame(height: 120)
                    }
                }
                .redacted(reason: .placeholder)
                .accessibilityIdentifier("charts-loading-placeholder")
            } else {
                NoticeCard(
                    title: "Charts unavailable",
                    message: "Detailed workout samples were not available from Apple Health.",
                    systemImage: "chart.xyaxis.line",
                    tint: .secondary
                )
            }
        }
    }
}

struct WorkoutPlanOverviewCard: View {
    let audit: WorkoutPlanAudit
    @State private var rowsExpanded = false
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    private var plannedRows: [PlannedWorkoutStep] {
        audit.plannedSteps.sorted { $0.index < $1.index }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Workout Plan")

            VStack(alignment: .leading, spacing: 10) {
                if let displayName = audit.displayName, !displayName.isEmpty {
                    Text(displayName)
                        .font(.headline)
                        .fixedSize(horizontal: false, vertical: true)
                }

                VStack(alignment: .leading, spacing: 6) {
                    ForEach(planSummaryRows) { row in
                        WorkoutPlanSummaryRow(row: row)
                    }
                }
                .padding(.vertical, 2)

                DisclosureGroup(isExpanded: $rowsExpanded) {
                    VStack(spacing: 8) {
                        ForEach(Array(plannedRows.enumerated()), id: \.offset) { _, step in
                            WorkoutPlanStepRow(step: step)
                        }
                    }
                    .padding(.top, 8)
                } label: {
                    Label(rowsExpanded ? "Hide plan rows" : "Show plan rows", systemImage: "list.bullet")
                        .font(.caption.bold())
                }
            }
            .padding(10)
            .background(.background)
            .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    private var planSummaryRows: [WorkoutPlanSummaryLine] {
        var rows: [WorkoutPlanSummaryLine] = []

        if let warmup = plannedRows.first(where: { $0.stepType == .warmup }) {
            rows.append(
                WorkoutPlanSummaryLine(text: "Warm-up: \(stepPrescription(warmup))", isIndented: false)
            )
        }

        let workRows = plannedRows.filter { $0.stepType == .work }
        if let firstWork = workRows.first {
            let workText = "\(workRows.count) x \(stepPrescription(firstWork))"
            rows.append(WorkoutPlanSummaryLine(text: workText, isIndented: false))
        }

        let recoveryRows = plannedRows.filter { $0.stepType == .recovery }
        if let firstRecovery = recoveryRows.first {
            rows.append(
                WorkoutPlanSummaryLine(text: "Recovery: \(stepPrescription(firstRecovery))", isIndented: true)
            )
        }

        if let cooldown = plannedRows.last(where: { $0.stepType == .cooldown }) {
            rows.append(
                WorkoutPlanSummaryLine(text: "Cool-down: \(stepPrescription(cooldown))", isIndented: false)
            )
        }

        return rows.isEmpty
            ? [WorkoutPlanSummaryLine(text: "Planned structure available.", isIndented: false)]
            : rows
    }

    private func targetSummary(_ step: PlannedWorkoutStep) -> String? {
        RunnerPlannedWorkoutTargetText.text(
            fallback: step.plannedTargetDisplayText,
            targets: step.plannedTargets,
            policy: runDisplayPolicy
        )
    }

    private func stepPrescription(_ step: PlannedWorkoutStep) -> String {
        let goalText: String
        switch step.plannedGoalType {
        case .time:
            goalText = step.plannedGoalValue.map(RunFormatters.duration) ?? step.plannedGoalDisplayText
        case .distance:
            goalText = step.plannedDistancePrescription?.displayText ?? step.plannedGoalDisplayText
        default:
            goalText = step.plannedGoalDisplayText
        }
        guard let target = targetSummary(step) else { return goalText }
        return "\(goalText) @ \(target)"
    }
}

private struct WorkoutPlanSummaryLine: Identifiable {
    var id: String { text }
    var text: String
    var isIndented: Bool
}

private struct WorkoutPlanSummaryRow: View {
    let row: WorkoutPlanSummaryLine

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            if row.isIndented {
                RoundedRectangle(cornerRadius: 1)
                    .fill(RunSignalTextStyle.secondary.opacity(0.35))
                    .frame(width: 2, height: 18)
            }

            Text(row.text)
                .font(.subheadline)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.leading, row.isIndented ? 28 : 0)
    }
}

private struct WorkoutPlanStepRow: View {
    let step: PlannedWorkoutStep
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: iconName)
                .font(.caption.bold())
                .foregroundStyle(tint)
                .frame(width: 22, height: 22)
                .background(tint.opacity(0.16))
                .clipShape(Circle())

            VStack(alignment: .leading, spacing: 4) {
                Text("\(step.index). \(step.label)")
                    .font(.subheadline.bold())
                Text(detailText)
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Text(step.plannedDistancePrescription?.displayText ?? step.plannedGoalDisplayText)
                .font(.caption.monospacedDigit().bold())
                .foregroundStyle(tint)
                .multilineTextAlignment(.trailing)
        }
        .padding(8)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var detailText: String {
        var parts: [String] = []
        if let repeatBlockIndex = step.repeatBlockIndex, let repeatIndex = step.repeatIndex {
            parts.append("Block \(repeatBlockIndex), repeat \(repeatIndex)")
        } else {
            parts.append(step.stepType.displayName)
        }
        if let plannedTargetDisplayText = RunnerPlannedWorkoutTargetText.text(
            fallback: step.plannedTargetDisplayText,
            targets: step.plannedTargets,
            policy: runDisplayPolicy
        ) {
            parts.append(plannedTargetDisplayText)
        }
        return parts.joined(separator: " · ")
    }

    private var iconName: String {
        switch step.stepType {
        case .warmup: "figure.walk"
        case .work: "bolt.fill"
        case .recovery: "arrow.triangle.2.circlepath"
        case .cooldown: "snowflake"
        case .open: "infinity"
        case .unknown: "questionmark"
        }
    }

    private var tint: Color {
        switch step.stepType {
        case .warmup: .blue
        case .work: .cyan
        case .recovery: .yellow
        case .cooldown: .teal
        case .open: .orange
        case .unknown: .secondary
        }
    }
}

private enum RunnerPlannedWorkoutTargetText {
    static func text(
        fallback: String?,
        targets: [PlannedWorkoutTarget]?,
        policy: RunDisplayPolicy
    ) -> String? {
        guard let paceTarget = targets?.first(where: { $0.kind == .pace }) else {
            return PlannedWorkoutTargetPresentation.runnerText(fallback, policy: policy)
        }

        switch (paceTarget.lowerBound, paceTarget.upperBound) {
        case let (lower?, upper?) where abs(lower - upper) >= 0.5:
            return PlannedWorkoutTargetPresentation.runnerPaceRange(
                lowerSecondsPerKm: lower,
                upperSecondsPerKm: upper,
                policy: policy
            )
        case let (lower?, _):
            return RunFormatters.pace(lower, policy: policy)
        case let (_, upper?):
            return RunFormatters.pace(upper, policy: policy)
        default:
            return PlannedWorkoutTargetPresentation.runnerText(fallback, policy: policy)
        }
    }
}

struct SplitsAndEventsPanel: View {
    let workout: CanonicalWorkout
    let segments: RunWorkoutSegments
    let supportedIntervals: WorkoutIntervalReconstructionResult?
    let intervalUnavailableMessage: String?
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy
    @State private var selectedSplitDetail: NormalSplitDetailSelection?

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            NormalSplitsSectionHeader(unit: runDisplayPolicy.primaryUnit)
            if displayedSplits.isEmpty {
                EmptyStateView(
                    title: "Splits unavailable",
                    message: segments.splitUnavailableReason(for: runDisplayPolicy.primaryUnit)
                        ?? "Apple Health did not retain enough trustworthy distance timing to calculate \(splitUnitName) splits for this run. Whole-run distance, time, and average pace remain available."
                )
            } else {
                VStack(spacing: 0) {
                    NormalSplitTableHeader(unit: runDisplayPolicy.primaryUnit)
                        .padding(.bottom, 8)
                    Divider()

                    LazyVStack(spacing: 0) {
                        ForEach(Array(displayedSplits.enumerated()), id: \.element.label) { index, split in
                            let metrics = splitMetricAverages(at: index)
                            NormalSplitCompactRow(
                                index: index,
                                split: split,
                                heartRate: metrics.heartRate,
                                policy: runDisplayPolicy
                            ) {
                                selectedSplitDetail = NormalSplitDetailSelection(
                                    id: "\(runDisplayPolicy.primaryUnit.rawValue)-\(split.label)",
                                    title: split.label,
                                    split: split,
                                    metrics: metrics
                                )
                            }

                            if index < displayedSplits.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
                .accessibilityIdentifier("normal-splits-table")

                if let sourceNote = NormalSplitPresentation.runnerFacingSourceNote(
                    segments.splitSource(for: runDisplayPolicy.primaryUnit)
                ) {
                    Label(sourceNote, systemImage: "info.circle")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .accessibilityIdentifier("normal-splits-estimate-note")
                }
            }

            if let planAudit = workout.evidence?.workoutPlanAudit, !planAudit.plannedSteps.isEmpty {
                WorkoutPlanOverviewCard(audit: planAudit)

                SectionHeader("Intervals")
                if let supportedIntervals {
                    WorkoutIntervalsCard(workout: workout, result: supportedIntervals)
                } else if let intervalUnavailableMessage {
                    NoticeCard(
                        title: "Intervals unavailable",
                        message: intervalUnavailableMessage,
                        systemImage: "list.bullet.rectangle",
                        tint: .orange
                    )
                }
            }
        }
        .sheet(item: $selectedSplitDetail) { detail in
            NormalSplitDetailsSheet(detail: detail, policy: runDisplayPolicy)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private func splitMetricAverages(at index: Int) -> NormalSplitMetricAverages {
        NormalSplitPresentation.metricAverages(
            at: index,
            splits: displayedSplits,
            workoutStartDate: workout.startDate,
            evidence: workout.evidence
        )
    }

    private var displayedSplits: [DerivedSplitEstimate] {
        segments.splits(for: runDisplayPolicy.primaryUnit)
    }

    private var splitUnitName: String {
        runDisplayPolicy.primaryUnit == .kilometers ? "kilometer" : "mile"
    }
}

private enum NormalSplitTableLayout {
    static let splitColumnWidth: CGFloat = 76
    static let heartRateColumnWidth: CGFloat = 88
    static let columnSpacing: CGFloat = 12
}

private struct NormalSplitsSectionHeader: View {
    let unit: RunningDistanceUnit

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text("Splits")
                .font(.headline)
            Spacer()
            Text(unit.normalSplitUnitText)
                .font(.subheadline.monospacedDigit().weight(.semibold))
                .foregroundStyle(RunSignalTextStyle.prominentSecondary)
        }
        .padding(.top, 8)
        .accessibilityElement(children: .combine)
        .accessibilityIdentifier("normal-splits-header")
    }
}

private struct NormalSplitTableHeader: View {
    let unit: RunningDistanceUnit

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: NormalSplitTableLayout.columnSpacing) {
            Text(unit.normalSplitColumnTitle)
                .frame(width: NormalSplitTableLayout.splitColumnWidth, alignment: .leading)
            Text("PACE")
                .frame(maxWidth: .infinity, alignment: .leading)
            Text("AVG HR")
                .frame(width: NormalSplitTableLayout.heartRateColumnWidth, alignment: .trailing)
        }
        .font(.caption2.weight(.semibold))
        .tracking(0.5)
        .foregroundStyle(RunSignalTextStyle.secondary)
        .accessibilityElement(children: .combine)
    }
}

private struct NormalSplitCompactRow: View {
    let index: Int
    let split: DerivedSplitEstimate
    let heartRate: Double?
    let policy: RunDisplayPolicy
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .firstTextBaseline, spacing: NormalSplitTableLayout.columnSpacing) {
                    Text(compactLabel)
                        .font(.subheadline.monospacedDigit().weight(.semibold))
                        .frame(width: NormalSplitTableLayout.splitColumnWidth, alignment: .leading)
                    Text(paceText)
                        .font(.headline.monospacedDigit())
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(heartRateText)
                        .font(.subheadline.monospacedDigit().weight(.medium))
                        .frame(width: NormalSplitTableLayout.heartRateColumnWidth, alignment: .trailing)
                }
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.78)

                if let supportingText {
                    Text(supportingText)
                        .font(.caption.monospacedDigit().weight(.medium))
                        .foregroundStyle(RunSignalTextStyle.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 54, alignment: .leading)
            .padding(.vertical, 4)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityLabel)
        .accessibilityHint("Shows time, distance, cadence, power, and pause details")
        .accessibilityIdentifier("normal-split-row-\(index + 1)")
    }

    private var compactLabel: String {
        NormalSplitPresentation.compactLabel(split.label, unit: policy.primaryUnit)
    }

    private var paceText: String {
        RunFormatters.pace(split.paceSecondsPerKmEstimate, policy: policy)
    }

    private var heartRateText: String {
        guard let heartRate else { return "—" }
        return "\(Int(heartRate.rounded())) bpm"
    }

    private var supportingText: String? {
        NormalSplitPresentation.supportingText(for: split, policy: policy)
    }

    private var accessibilityLabel: String {
        var parts = [
            compactLabel,
            RunFormatters.accessibilityPace(split.paceSecondsPerKmEstimate, policy: policy),
            heartRate.map { "Average heart rate \(Int($0.rounded())) beats per minute" }
                ?? "Average heart rate unavailable",
        ]
        if let supportingText {
            parts.append(supportingText)
        }
        return parts.joined(separator: ", ")
    }
}

private struct NormalSplitDetailSelection: Identifiable {
    let id: String
    let title: String
    let split: DerivedSplitEstimate
    let metrics: NormalSplitMetricAverages
}

private struct NormalSplitDetailsSheet: View {
    let detail: NormalSplitDetailSelection
    let policy: RunDisplayPolicy
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 3) {
                        Text(RunFormatters.pace(detail.split.paceSecondsPerKmEstimate, policy: policy))
                            .font(.largeTitle.monospacedDigit().bold())
                            .foregroundStyle(.primary)
                        Text("Pace")
                            .font(.subheadline.weight(.medium))
                            .foregroundStyle(RunSignalTextStyle.secondary)
                    }

                    MetricGrid(items: detailItems)
                }
                .padding()
            }
            .navigationTitle(detail.title)
            .runSignalInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var detailItems: [MetricItem] {
        var items = [
            MetricItem(
                title: "Time",
                value: RunFormatters.duration(detail.split.durationSecondsEstimate),
                detail: detail.split.pauseOverlapSeconds.map { $0 >= 0.5 ? "Active split time" : "Split time" } ?? "Split time"
            ),
            MetricItem(
                title: "Distance",
                value: RunFormatters.distance(detail.split.distanceMeters, policy: policy),
                detail: "Split distance"
            ),
            MetricItem(
                title: "Avg HR",
                value: RunFormatters.number(detail.metrics.heartRate, suffix: " bpm"),
                detail: detail.metrics.heartRate == nil ? "Not available" : "Split average"
            ),
            MetricItem(
                title: "Cadence",
                value: RunFormatters.number(detail.metrics.cadence, suffix: " spm"),
                detail: detail.metrics.cadence == nil ? "Not available" : "Split average"
            ),
            MetricItem(
                title: "Power",
                value: RunFormatters.number(detail.metrics.power, suffix: " W"),
                detail: detail.metrics.power == nil ? "Not available" : "Split average"
            ),
        ]

        if let pauseOverlap = detail.split.pauseOverlapSeconds, pauseOverlap >= 0.5 {
            items.append(
                MetricItem(
                    title: "Pause",
                    value: RunFormatters.duration(pauseOverlap),
                    detail: "Excluded from time"
                )
            )
        }

        return items
    }
}

private struct WorkoutIntervalsCard: View {
    let workout: CanonicalWorkout
    let result: WorkoutIntervalReconstructionResult

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if RunClassifier.isStructuredIntervalWorkout(result.intervals) {
                IntervalAnalysisEntryCard(workout: workout, result: result)
            } else {
                ForEach(result.intervals, id: \.index) { interval in
                    WorkoutIntervalSummaryRow(
                        interval: interval,
                        simplifiesSingleWorkLabel: workCount == 1
                    )
                }
            }
        }
        .accessibilityIdentifier("workout-intervals-card")
    }

    private var workCount: Int {
        result.intervals.filter { $0.stepType == .work }.count
    }
}

private struct WorkoutIntervalSummaryRow: View {
    let interval: ReconstructedWorkoutInterval
    let simplifiesSingleWorkLabel: Bool
    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(label)
                    .font(.headline)
                Spacer()
                if let target = RunnerPlannedWorkoutTargetText.text(
                    fallback: interval.plannedTargetDisplayText,
                    targets: interval.plannedTargets,
                    policy: runDisplayPolicy
                ) {
                    Text(target)
                        .font(.caption.bold())
                        .foregroundStyle(.blue)
                }
            }
            MetricGrid(items: intervalItems)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    private var label: String {
        if simplifiesSingleWorkLabel, interval.stepType == .work {
            return "Work"
        }
        if interval.label == "Open / Extra" {
            return "Open"
        }
        return interval.label
    }

    private var intervalItems: [MetricItem] {
        var items = IntervalGoalMeasuredText.metricItems(for: interval, policy: runDisplayPolicy)
        if let heartRate = interval.averageHeartRateBpm {
            items.append(MetricItem(title: "Avg HR", value: RunFormatters.number(heartRate, suffix: " bpm"), detail: "HealthKit activity"))
        }
        return items
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
                                            .foregroundStyle(RunSignalTextStyle.secondary)
                                    }
                                    Spacer()
                                    VStack(alignment: .trailing, spacing: 2) {
                                        Text(RunFormatters.duration(interval.durationSeconds))
                                            .font(.subheadline.monospacedDigit().bold())
                                        Text(RunFormatters.distance(interval.distanceMeters))
                                            .font(.caption2)
                                            .foregroundStyle(RunSignalTextStyle.secondary)
                                    }
                                }
                                Text("\(RunFormatters.duration(interval.startOffsetSeconds)) -> \(RunFormatters.duration(interval.endOffsetSeconds)) from workout start")
                                    .font(.caption2.monospacedDigit())
                                    .foregroundStyle(RunSignalTextStyle.secondary)
                                MetricGrid(items: [
                                    MetricItem(title: "Pace", value: RunFormatters.pace(interval.paceSecondsPerKm), detail: "Derived"),
                                    MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: "Window")
                                ])
                                if !interval.caveats.isEmpty {
                                    Text(interval.caveats.joined(separator: " "))
                                        .font(.caption)
                                        .foregroundStyle(RunSignalTextStyle.secondary)
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
                                .foregroundStyle(RunSignalTextStyle.secondary)
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
                        .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding(.top, 8)
        } label: {
            RawIntervalCompactLabel(
                title: "\(interval.index). \(interval.label)",
                subtitle: "\(interval.plannedGoalDisplayText) · \(interval.plannedTargetDisplayText ?? "Target unavailable")",
                duration: RunFormatters.duration(interval.displayDurationSeconds),
                distance: officialIntervalDisplayDistance(interval),
                badge: "Official",
                badgeColor: .blue
            )
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func officialIntervalDisplayDistance(_ interval: ReconstructedWorkoutInterval) -> String {
        if interval.plannedGoalType == .distance {
            return RunFormatters.compactDistance(interval.plannedGoalValue)
        }
        return RunFormatters.distance(interval.actualDistanceMeters)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
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
                .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .lineLimit(2)
            }
            Spacer(minLength: 8)
            VStack(alignment: .trailing, spacing: 3) {
                Text(duration)
                    .font(.subheadline.monospacedDigit().bold())
                Text(distance)
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                if let loadedRunCount {
                    Text("\(loadedRunCount) completed running workouts loaded. Duplicate-like workouts are hidden from this v1 list.")
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
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
                .foregroundStyle(RunSignalTextStyle.secondary)
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
    static let metricSupporting = Color.primary
    static let prominentSecondary = Color.primary.opacity(0.92)
    static let secondary = Color.primary.opacity(0.84)
    static let tertiary = Color.primary.opacity(0.74)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
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
                        .foregroundStyle(RunSignalTextStyle.secondary)
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
                    .foregroundStyle(RunSignalTextStyle.secondary)
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
                .foregroundStyle(RunSignalTextStyle.tertiary)
                .fixedSize(horizontal: false, vertical: true)

            Text(derivedSummary.detailText)
                .font(.caption2)
                .foregroundStyle(RunSignalTextStyle.tertiary)
                .fixedSize(horizontal: false, vertical: true)

            Text("Physical proof: \(interruptionProof.detailText)")
                .font(.caption2)
                .foregroundStyle(RunSignalTextStyle.tertiary)
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
                .foregroundStyle(RunSignalTextStyle.secondary)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(RunSignalTextStyle.secondary)
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
                        .font(.caption.weight(.medium))
                        .foregroundStyle(RunSignalTextStyle.metricSupporting)
                    Text(item.value)
                        .font(.headline.monospacedDigit())
                        .foregroundStyle(.primary)
                        .lineLimit(2)
                        .minimumScaleFactor(0.75)
                    if let secondaryValue = item.secondaryValue {
                        Text("(\(secondaryValue))")
                            .font(.caption2.monospacedDigit().weight(.medium))
                            .foregroundStyle(RunSignalTextStyle.metricSupporting)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    Text(item.detail)
                        .font(.caption2.weight(.medium))
                        .foregroundStyle(RunSignalTextStyle.metricSupporting)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, minHeight: 82, alignment: .topLeading)
                .padding()
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .runSignalAccessibilityValue(item.accessibilityValue)
            }
        }
    }
}

struct MetricItem: Identifiable {
    var id: String { "\(title)|\(detail)" }
    let title: String
    let value: String
    let detail: String
    var secondaryValue: String? = nil
    var accessibilityValue: String? = nil
}

private extension View {
    @ViewBuilder
    func runSignalAccessibilityValue(_ value: String?) -> some View {
        if let value {
            accessibilityElement(children: .combine)
                .accessibilityValue(value)
        } else {
            self
        }
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
