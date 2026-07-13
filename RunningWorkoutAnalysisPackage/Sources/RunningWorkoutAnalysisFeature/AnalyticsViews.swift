import Charts
import MapKit
import SwiftUI

struct AnalyticsView: View {
    var store: RunningAnalysisStore

    @State private var selectedPeriod = TrainingAnalyticsPeriod.week
    @State private var selectedPeriodStart: Date?

    private var periodStarts: [Date] {
        store.availableTrainingPeriodStarts(for: selectedPeriod)
    }

    private var activePeriodStart: Date {
        guard selectedPeriod != .allTime else {
            return store.defaultTrainingPeriodStart(for: .allTime)
        }
        if let selectedPeriodStart, periodStarts.contains(selectedPeriodStart) {
            return selectedPeriodStart
        }
        return periodStarts.first ?? store.defaultTrainingPeriodStart(for: selectedPeriod)
    }

    private var intervalLibraryGroups: [IntervalLibraryGroup] {
        let persisted = store.derivedAnalysesByWorkoutID.values.compactMap(\.officialIntervalWorkout)
        let loaded = store.workouts.compactMap { workout -> OfficialIntervalWorkout? in
            guard let evidence = workout.evidence,
                  let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)
            else { return nil }
            return OfficialIntervalWorkout(workoutID: workout.id, startDate: workout.startDate, rows: result.intervals)
        }
        let merged = OfficialIntervalWorkoutMerger.merged(persisted: persisted, loaded: loaded)
        return IntervalLibraryBuilder.groups(from: merged)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Training trends from your completed Apple Health runs.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Picker("Period", selection: $selectedPeriod) {
                    ForEach(TrainingAnalyticsPeriod.allCases) { period in
                        Text(period.label).tag(period)
                    }
                }
                .pickerStyle(.segmented)

                NavigationLink {
                    IntervalLibraryView(groups: intervalLibraryGroups)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "repeat.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.cyan)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Interval Library")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(intervalLibraryGroups.isEmpty
                                 ? "Structured interval workouts appear after analysis finishes."
                                 : "\(intervalLibraryGroups.count) matching workout plans · targets and trends")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.leading)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                NavigationLink {
                    BestEffortsView(store: store)
                } label: {
                    HStack(spacing: 12) {
                        Image(systemName: "medal.fill")
                            .font(.title2)
                            .foregroundStyle(.green)
                        VStack(alignment: .leading, spacing: 3) {
                            Text("Best Efforts")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(bestEffortSummaryText)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        if store.isLoading {
                            ProgressView()
                                .controlSize(.small)
                        } else {
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .buttonStyle(.plain)

                PeriodSignalView(
                    store: store,
                    summary: store.trainingPeriodSummary(
                        period: selectedPeriod,
                        periodStart: activePeriodStart
                    ),
                    periodStarts: periodStarts,
                    selectedPeriodStart: $selectedPeriodStart
                )
            }
            .padding()
            .padding(.bottom, 180)
        }
        .navigationTitle("Analytics")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
        }
        .onChange(of: selectedPeriod) {
            selectedPeriodStart = nil
        }
    }

    private var bestEffortSummaryText: String {
        let count = store.personalBestEffortSummary.allTime.count
        guard count > 0 else {
            return "Exact distance records appear after detailed analysis."
        }
        return "\(count) official all-time \(count == 1 ? "record" : "records")"
    }
}

private struct BestEffortsView: View {
    var store: RunningAnalysisStore

    private var workoutsByID: [String: CanonicalWorkout] {
        Dictionary(uniqueKeysWithValues: store.workouts.map { ($0.id, $0) })
    }

    var body: some View {
        List {
            Section {
                Text("RunSignal uses detailed Apple Health distance samples for official segment records. Summary-only estimates are not promoted as best efforts.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Section("All-Time Records") {
                if store.personalBestEffortSummary.allTime.isEmpty {
                    EmptyStateView(
                        title: "No exact best efforts yet",
                        message: "Detailed distance samples are needed before official segment records can be calculated."
                    )
                } else {
                    ForEach(store.personalBestEffortSummary.allTime, id: \.bucket) { effort in
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
            }
        }
        .navigationTitle("Best Efforts")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
    }
}

private struct IntervalLibraryView: View {
    let groups: [IntervalLibraryGroup]

    private var broadGroups: [(key: [IntervalGoalSignature], groups: [IntervalLibraryGroup])] {
        Dictionary(grouping: groups, by: { $0.signature.workGoals })
            .map { (key: $0.key, groups: $0.value) }
            .sorted { intervalGoalListLabel($0.key) < intervalGoalListLabel($1.key) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Interval workouts grouped by matching work and recovery plans.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                if broadGroups.isEmpty {
                    EmptyStateView(
                        title: "No official interval groups yet",
                        message: "Whole-run analytics are still available. Interval groups appear after RunSignal finishes processing a compatible custom workout."
                    )
                } else {
                    ForEach(Array(broadGroups.enumerated()), id: \.offset) { _, broad in
                        VStack(alignment: .leading, spacing: 10) {
                            Text("\(intervalGoalListLabel(broad.key)) Work")
                                .font(.headline)
                            ForEach(broad.groups) { group in
                                NavigationLink {
                                    IntervalTrendView(group: group)
                                } label: {
                                    HStack {
                                        VStack(alignment: .leading, spacing: 3) {
                                            Text(intervalPrescriptionLabel(group.signature))
                                                .font(.subheadline.bold())
                                                .foregroundStyle(.primary)
                                            Text("\(group.workouts.count) workout\(group.workouts.count == 1 ? "" : "s")")
                                                .font(.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chart.xyaxis.line")
                                            .foregroundStyle(.cyan)
                                    }
                                    .padding(10)
                                    .background(.secondary.opacity(0.08))
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding()
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
            }
            .padding()
            .padding(.bottom, 120)
        }
        .navigationTitle("Interval Library")
    }
}

private struct IntervalTrendView: View {
    let group: IntervalLibraryGroup

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(
                    title: intervalPrescriptionLabel(group.signature),
                    subtitle: "Trend across workouts with the same planned work and recovery structure."
                )

                MetricGrid(items: [
                    MetricItem(title: "Sessions", value: "\(group.trendPoints.count)", detail: "Comparable"),
                    MetricItem(title: "Latest Pace", value: RunFormatters.pace(group.trendPoints.last?.aggregatePaceSecondsPerKilometer), detail: "Work aggregate"),
                    MetricItem(title: "On Target", value: "\(group.trendPoints.reduce(0) { $0 + $1.onTargetCount })", detail: "All sessions"),
                    MetricItem(title: "Shortened", value: "\(group.trendPoints.reduce(0) { $0 + $1.shortenedCount })", detail: "Completion")
                ])

                if !group.trendPoints.isEmpty {
                    Chart(group.trendPoints) { point in
                        if let pace = point.aggregatePaceSecondsPerKilometer, pace > 0 {
                            LineMark(
                                x: .value("Date", point.startDate),
                                y: .value("Pace", 3_600 / pace)
                            )
                            .foregroundStyle(.cyan)
                            PointMark(
                                x: .value("Date", point.startDate),
                                y: .value("Pace", 3_600 / pace)
                            )
                            .foregroundStyle(.cyan)
                        }
                    }
                    .frame(height: 240)
                    .chartYAxis {
                        AxisMarks(position: .leading) { value in
                            AxisGridLine()
                            AxisValueLabel {
                                if let speedLike = value.as(Double.self), speedLike > 0 {
                                    Text(RunFormatters.pace(3_600 / speedLike))
                                }
                            }
                        }
                    }
                    .accessibilityLabel("Aggregate Work pace trend")
                }

                ForEach(group.trendPoints.reversed()) { point in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(RunFormatters.mediumDateWithYear.string(from: point.startDate))
                                .font(.subheadline.bold())
                            Spacer()
                            Text(RunFormatters.pace(point.aggregatePaceSecondsPerKilometer))
                                .font(.subheadline.monospacedDigit())
                        }
                        Text("\(point.onTargetCount) on target · \(point.fastCount) fast · \(point.slowCount) slow · \(point.shortenedCount) shortened")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding()
            .padding(.bottom, 120)
        }
        .navigationTitle("Interval Trend")
    }
}

private func intervalPrescriptionLabel(_ signature: IntervalPrescriptionSignature) -> String {
    let work = intervalGoalListLabel(signature.workGoals)
    let recovery = intervalGoalListLabel(signature.recoveryGoals)
    let recoveryText = signature.recoveryCount > 0 ? " / \(recovery) Recovery" : ""
    return "\(signature.workCount) × \(work)\(recoveryText)"
}

private func intervalGoalListLabel(_ goals: [IntervalGoalSignature]) -> String {
    guard !goals.isEmpty else { return "Open" }
    return goals.map(intervalGoalLabel).joined(separator: " + ")
}

private func intervalGoalLabel(_ goal: IntervalGoalSignature) -> String {
    switch goal.type {
    case .distance:
        return RunFormatters.compactDistance(goal.value)
    case .time:
        return goal.value.map { RunFormatters.duration($0) } ?? "Timed"
    case .open: return "Open"
    case .energy: return goal.value.map { "\(Int($0.rounded())) kcal" } ?? "Energy"
    case .unavailable: return "Other"
    }
}

private struct PeriodSignalView: View {
    var store: RunningAnalysisStore
    var summary: TrainingPeriodAnalyticsSummary
    var periodStarts: [Date]
    @Binding var selectedPeriodStart: Date?

    private var activeIndex: Int? {
        periodStarts.firstIndex(of: summary.periodStart)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            if summary.period != .allTime {
                PeriodNavigator(
                    period: summary.period,
                    title: periodTitle,
                    signalTitle: signalTitle,
                    periodStarts: periodStarts,
                    selectedPeriodStart: $selectedPeriodStart,
                    canMoveNewer: (activeIndex ?? 0) > 0,
                    canMoveOlder: (activeIndex ?? periodStarts.count) < periodStarts.count - 1,
                    canResetToCurrent: activeIndex != nil && activeIndex != 0,
                    resetTitle: currentPeriodButtonTitle,
                    resetToCurrent: resetToCurrent,
                    moveNewer: moveNewer,
                    moveOlder: moveOlder
                )
            } else {
                HeaderBlock(title: signalTitle, subtitle: periodTitle)
            }

            MetricGrid(items: [
                MetricItem(title: "Distance", value: RunFormatters.distance(summary.totalDistanceMeters), detail: distanceDetail),
                MetricItem(title: "Runs", value: "\(summary.runCount)", detail: "Completed"),
                MetricItem(title: "Avg pace", value: RunFormatters.pace(summary.averagePaceSecondsPerKm), detail: "Distance/time"),
                MetricItem(title: "Detailed Data", value: evidenceStatus, detail: evidenceDetail)
            ])

            if summary.period != .allTime {
                PeriodComparisonPanel(summary: summary)
            }

            if summary.runCount == 0 {
                EmptyStateView(title: emptyTitle, message: "Choose an older \(summary.period.label.lowercased()) or load runs from Settings.")
            } else {
                PeriodDistanceChart(summary: summary)
                WeeklyCategoryTotalsView(totals: summary.categoryTotals)
                if summary.period == .week || summary.period == .month {
                    WeeklyWorkoutList(store: store, rows: summary.workouts, title: workoutListTitle)
                } else {
                    NavigationLink {
                        PeriodWorkoutCollectionView(store: store, rows: summary.workouts, title: workoutListTitle)
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: "list.bullet")
                                .font(.title2)
                                .foregroundStyle(.blue)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(workoutListTitle)
                                    .font(.headline)
                                    .foregroundStyle(.primary)
                                Text("Browse and manage \(summary.runCount) \(summary.runCount == 1 ? "run" : "runs")")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.secondary)
                        }
                        .padding()
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var periodTitle: String {
        switch summary.period {
        case .week:
            "\(RunFormatters.mediumDateWithYear.string(from: summary.periodStart)) - \(RunFormatters.mediumDateWithYear.string(from: summary.analysisEnd.addingTimeInterval(-1)))"
        case .month, .year:
            "\(RunFormatters.mediumDateWithYear.string(from: summary.periodStart)) - \(RunFormatters.mediumDateWithYear.string(from: summary.analysisEnd.addingTimeInterval(-1)))"
        case .allTime:
            summary.runCount == 0
                ? "No loaded runs"
                : "\(RunFormatters.mediumDateWithYear.string(from: summary.periodStart)) - \(RunFormatters.mediumDateWithYear.string(from: summary.analysisEnd.addingTimeInterval(-1)))"
        }
    }

    private var currentPeriodButtonTitle: String {
        switch summary.period {
        case .week: "Current Week"
        case .month: "Current Month"
        case .year: "Current Year"
        case .allTime: "All-Time"
        }
    }

    private var signalTitle: String {
        switch summary.period {
        case .week: "Week Signal"
        case .month: "Month Signal"
        case .year: "Year Signal"
        case .allTime: "All-Time Signal"
        }
    }

    private var emptyTitle: String {
        switch summary.period {
        case .week: "No runs this week"
        case .month: "No runs this month"
        case .year: "No runs this year"
        case .allTime: "No loaded runs"
        }
    }

    private var workoutListTitle: String {
        switch summary.period {
        case .week: "Runs This Week"
        case .month: "Runs This Month"
        case .year: "Runs This Year"
        case .allTime: "All Runs"
        }
    }

    private var distanceDetail: String {
        guard summary.isPeriodToDate else { return "Total" }
        return "To date"
    }

    private var evidenceStatus: String {
        let seriesRuns = summary.workouts.filter { $0.workout.seriesAvailable || $0.workout.seriesSampleCount > 0 }.count
        guard summary.runCount > 0 else { return "None" }
        return seriesRuns == summary.runCount ? "All \(summary.runCount)" : "\(seriesRuns) of \(summary.runCount)"
    }

    private var evidenceDetail: String {
        let detailedCount = summary.workouts.filter { $0.workout.seriesAvailable || $0.workout.seriesSampleCount > 0 }.count
        if summary.runCount == 0 { return "No runs in this period" }
        if detailedCount == 0 { return "Summary metrics only" }
        if detailedCount == summary.runCount { return "All runs include charts and splits" }
        return "\(detailedCount) runs include charts and splits"
    }

    private func moveNewer() {
        guard let activeIndex, activeIndex > 0 else { return }
        selectedPeriodStart = periodStarts[activeIndex - 1]
    }

    private func moveOlder() {
        guard let activeIndex, activeIndex < periodStarts.count - 1 else { return }
        selectedPeriodStart = periodStarts[activeIndex + 1]
    }

    private func resetToCurrent() {
        selectedPeriodStart = nil
    }
}

private struct PeriodNavigator: View {
    let period: TrainingAnalyticsPeriod
    let title: String
    let signalTitle: String
    let periodStarts: [Date]
    @Binding var selectedPeriodStart: Date?
    let canMoveNewer: Bool
    let canMoveOlder: Bool
    let canResetToCurrent: Bool
    let resetTitle: String
    let resetToCurrent: () -> Void
    let moveNewer: () -> Void
    let moveOlder: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Button(action: moveOlder) {
                    Image(systemName: "chevron.left")
                }
                .buttonStyle(.bordered)
                .disabled(!canMoveOlder)
                .accessibilityLabel("Previous period")

                VStack(alignment: .leading, spacing: 3) {
                    Text(signalTitle)
                        .font(.headline)
                    Text(title)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Button(action: moveNewer) {
                    Image(systemName: "chevron.right")
                }
                .buttonStyle(.bordered)
                .disabled(!canMoveNewer)
                .accessibilityLabel("Next period")
            }

            HStack {
                PeriodJumpMenu(
                    period: period,
                    periodStarts: periodStarts,
                    selectedPeriodStart: $selectedPeriodStart
                )

                if canResetToCurrent {
                    Button(action: resetToCurrent) {
                        Label(resetTitle, systemImage: "calendar.badge.clock")
                    }
                    .buttonStyle(.borderedProminent)
                    .controlSize(.small)
                }
            }
        }
    }
}

private struct PeriodJumpMenu: View {
    let period: TrainingAnalyticsPeriod
    let periodStarts: [Date]
    @Binding var selectedPeriodStart: Date?

    private var groups: [PeriodStartGroup] {
        Dictionary(grouping: periodStarts) { Calendar.current.component(.year, from: $0) }
            .map { PeriodStartGroup(year: $0.key, starts: $0.value.sorted(by: >)) }
            .sorted { $0.year > $1.year }
    }

    var body: some View {
        Menu {
            if period == .year {
                ForEach(periodStarts, id: \.self) { start in
                    periodButton(start)
                }
            } else {
                ForEach(groups) { group in
                    Menu(String(group.year)) {
                        ForEach(group.starts, id: \.self) { start in
                            periodButton(start)
                        }
                    }
                }
            }
        } label: {
            Label("Choose \(period.label)", systemImage: "calendar")
        }
        .buttonStyle(.bordered)
        .controlSize(.small)
        .accessibilityLabel("Choose a specific \(period.label.lowercased())")
    }

    @ViewBuilder
    private func periodButton(_ start: Date) -> some View {
        Button {
            selectedPeriodStart = start
        } label: {
            if selectedPeriodStart == start {
                Label(choiceLabel(start), systemImage: "checkmark")
            } else {
                Text(choiceLabel(start))
            }
        }
    }

    private func choiceLabel(_ start: Date) -> String {
        switch period {
        case .week:
            let end = Calendar.current.date(byAdding: .day, value: 6, to: start) ?? start
            return "\(RunFormatters.shortDate.string(from: start)) – \(RunFormatters.shortDate.string(from: end))"
        case .month:
            return start.formatted(.dateTime.month(.wide))
        case .year:
            return start.formatted(.dateTime.year())
        case .allTime:
            return "All-Time"
        }
    }
}

private struct PeriodStartGroup: Identifiable {
    let year: Int
    let starts: [Date]
    var id: Int { year }
}

private struct PeriodComparisonPanel: View {
    let summary: TrainingPeriodAnalyticsSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Compared with Previous")

            if let comparison = summary.comparison {
                VStack(spacing: 10) {
                    comparisonRow(
                        firstTitle: "Distance",
                        firstValue: signedDistance(summary.distanceDeltaMeters),
                        secondTitle: "Runs",
                        secondValue: signedInt(summary.runCountDelta)
                    )
                    Divider()
                    comparisonRow(
                        firstTitle: "Previous",
                        firstValue: RunFormatters.distance(comparison.totalDistanceMeters),
                        secondTitle: "Previous pace",
                        secondValue: RunFormatters.pace(comparison.averagePaceSecondsPerKm)
                    )
                    Text(summary.comparisonScopeLabel)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                NoticeCard(
                    title: "No comparison period",
                    message: "All-time analysis summarizes the loaded HealthKit history without forcing a prior-period comparison."
                )
            }
        }
    }

    private func signedDistance(_ meters: Double?) -> String {
        guard let meters else { return "Unavailable" }
        let prefix = meters > 0 ? "+" : ""
        return "\(prefix)\(RunFormatters.distance(meters))"
    }

    private func signedInt(_ value: Int?) -> String {
        guard let value else { return "Unavailable" }
        return value > 0 ? "+\(value)" : "\(value)"
    }

    private func comparisonRow(
        firstTitle: String,
        firstValue: String,
        secondTitle: String,
        secondValue: String
    ) -> some View {
        HStack(spacing: 16) {
            comparisonValue(title: firstTitle, value: firstValue)
            comparisonValue(title: secondTitle, value: secondValue)
        }
    }

    private func comparisonValue(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.headline.monospacedDigit())
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct PeriodDistanceChart: View {
    let summary: TrainingPeriodAnalyticsSummary
    @State private var selectedBucketLabel: String?

    private var selectedBucket: TrainingPeriodDistanceBucket? {
        guard let selectedBucketLabel else { return nil }
        return summary.distanceBuckets.first { $0.label == selectedBucketLabel }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(chartTitle)
            HStack(alignment: .lastTextBaseline, spacing: 6) {
                if let selectedBucket {
                    Text(selectedBucket.label)
                        .font(.subheadline.bold())
                    Text(RunFormatters.distance(selectedBucket.distanceMeters))
                        .font(.title3.monospacedDigit().bold())
                        .foregroundStyle(.blue)
                } else {
                    Text("Tap or drag across the bars to see distance")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
            Chart {
                ForEach(summary.distanceBuckets) { bucket in
                    BarMark(
                        x: .value("Period", bucket.label),
                        y: .value("Distance", bucket.distanceMeters / 1_000)
                    )
                    .foregroundStyle(bucketColor(bucket))
                    .cornerRadius(4)
                }

                if let selectedBucket {
                    RuleMark(x: .value("Selected period", selectedBucket.label))
                        .foregroundStyle(.primary.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                }
            }
            .frame(height: 150)
            .chartYAxisLabel("km")
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    guard let plotFrame = proxy.plotFrame else { return }
                                    let frame = geometry[plotFrame]
                                    let x = value.location.x - frame.origin.x
                                    guard x >= 0, x <= frame.width,
                                          let label: String = proxy.value(atX: x) else { return }
                                    selectedBucketLabel = label
                                }
                        )
                }
            }
            .accessibilityLabel("\(chartTitle) chart. Tap or drag to inspect a period.")
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var chartTitle: String {
        switch summary.period {
        case .week: "Daily Distance"
        case .month: "Day-by-Day Distance"
        case .year: "Monthly Distance"
        case .allTime: "Yearly Distance"
        }
    }

    private func bucketColor(_ bucket: TrainingPeriodDistanceBucket) -> Color {
        if selectedBucketLabel == bucket.label { return .cyan }
        return bucket.distanceMeters > 0 ? .blue : .secondary.opacity(0.25)
    }
}

private struct WeekSignalView: View {
    var store: RunningAnalysisStore
    var summary: WeeklyAnalyticsSummary
    var weekStarts: [Date]
    @Binding var selectedWeekStart: Date?

    private var activeIndex: Int? {
        weekStarts.firstIndex(of: summary.weekStart)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            WeekNavigator(
                title: weekTitle,
                canMoveNewer: activeIndex.map { $0 > 0 } ?? false,
                canMoveOlder: activeIndex.map { $0 < weekStarts.count - 1 } ?? false,
                moveNewer: moveNewer,
                moveOlder: moveOlder
            )

            MetricGrid(items: [
                MetricItem(title: "Distance", value: RunFormatters.distance(summary.totalDistanceMeters), detail: "Monday-start week"),
                MetricItem(title: "Runs", value: "\(summary.runCount)", detail: "Non-duplicate"),
                MetricItem(title: "Avg pace", value: RunFormatters.pace(summary.averagePaceSecondsPerKm), detail: "Distance/time"),
                MetricItem(title: "Evidence", value: evidenceStatus, detail: evidenceDetail)
            ])

            if summary.runCount == 0 {
                EmptyStateView(title: "No runs this week", message: "Choose an older week or load runs from Settings.")
            } else {
                DailyDistanceChart(days: summary.dailyDistances)
                WeeklyCategoryTotalsView(totals: summary.categoryTotals)
                WeeklyWorkoutList(store: store, rows: summary.workouts)
            }
        }
    }

    private var weekTitle: String {
        "\(RunFormatters.shortDate.string(from: summary.weekStart)) - \(RunFormatters.shortDate.string(from: summary.weekEnd.addingTimeInterval(-1)))"
    }

    private var evidenceStatus: String {
        let seriesRuns = summary.workouts.filter { $0.workout.seriesAvailable || $0.workout.seriesSampleCount > 0 }.count
        guard summary.runCount > 0 else { return "Empty" }
        return seriesRuns == summary.runCount ? "Ready" : "\(seriesRuns)/\(summary.runCount)"
    }

    private var evidenceDetail: String {
        summary.runCount == 0 ? "No week data" : "Runs with series evidence"
    }

    private func moveNewer() {
        guard let activeIndex, activeIndex > 0 else { return }
        selectedWeekStart = weekStarts[activeIndex - 1]
    }

    private func moveOlder() {
        guard let activeIndex, activeIndex < weekStarts.count - 1 else { return }
        selectedWeekStart = weekStarts[activeIndex + 1]
    }
}

private struct WeekNavigator: View {
    let title: String
    let canMoveNewer: Bool
    let canMoveOlder: Bool
    let moveNewer: () -> Void
    let moveOlder: () -> Void

    var body: some View {
        HStack {
            Button(action: moveOlder) {
                Image(systemName: "chevron.left")
            }
            .buttonStyle(.bordered)
            .disabled(!canMoveOlder)
            .accessibilityLabel("Previous week")

            VStack(alignment: .leading, spacing: 3) {
                Text("Week Signal")
                    .font(.headline)
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Button(action: moveNewer) {
                Image(systemName: "chevron.right")
            }
            .buttonStyle(.bordered)
            .disabled(!canMoveNewer)
            .accessibilityLabel("Next week")
        }
    }
}

private struct DailyDistanceChart: View {
    let days: [WeeklyDailyDistance]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Daily Distance")
            Chart(days) { day in
                BarMark(
                    x: .value("Day", weekdayLabel(day.date)),
                    y: .value("Distance", day.distanceMeters / 1_000)
                )
                .foregroundStyle(day.distanceMeters > 0 ? .blue : .secondary.opacity(0.25))
                .cornerRadius(4)
            }
            .frame(height: 150)
            .chartYAxisLabel("km")
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func weekdayLabel(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter.string(from: date)
    }
}

private struct WeeklyCategoryTotalsView: View {
    let totals: [WeeklyRunCategoryTotal]

    private var visibleTotals: [WeeklyRunCategoryTotal] {
        totals.filter { $0.runCount > 0 || $0.category == .other }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Purpose Mix")
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 145), spacing: 8)], spacing: 8) {
                ForEach(visibleTotals) { total in
                    VStack(alignment: .leading, spacing: 5) {
                        Text(total.category.label)
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(RunSignalTextStyle.secondary)
                        Text("\(total.runCount)")
                            .font(.title3.monospacedDigit().bold())
                        Text(RunFormatters.distance(total.distanceMeters))
                            .font(.caption2)
                            .foregroundStyle(RunSignalTextStyle.tertiary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(10)
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
        }
    }
}

private struct PeriodWorkoutCollectionView: View {
    var store: RunningAnalysisStore
    let rows: [WeeklyWorkoutRow]
    let title: String

    var body: some View {
        ScrollView {
            WeeklyWorkoutList(store: store, rows: rows, title: title)
                .padding()
                .padding(.bottom, 120)
        }
        .navigationTitle(title)
        .runSignalInlineNavigationTitle()
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
    }
}

private struct WeeklyWorkoutList: View {
    var store: RunningAnalysisStore
    let rows: [WeeklyWorkoutRow]
    var title = "Runs This Week"

    @State private var isSelecting = false
    @State private var selectedWorkoutIDs: Set<String> = []
    @State private var bulkCategory = WeeklyRunCategory.easy

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                SectionHeader(title)
                Spacer()
                Button(isSelecting ? "Done" : "Select") {
                    isSelecting.toggle()
                    if !isSelecting {
                        selectedWorkoutIDs.removeAll()
                    }
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            if isSelecting {
                bulkControls
            }

            LazyVStack(spacing: 8) {
                ForEach(rows) { row in
                    Group {
                        if isSelecting {
                            Button {
                                toggleSelection(row.workout.id)
                            } label: {
                                workoutRow(row, selected: selectedWorkoutIDs.contains(row.workout.id), selectable: true)
                            }
                            .buttonStyle(.plain)
                        } else {
                            HStack(spacing: 8) {
                                NavigationLink {
                                    WorkoutDetailView(store: store, workoutID: row.workout.id)
                                } label: {
                                    workoutRow(row, selected: false, selectable: false)
                                }
                                .buttonStyle(.plain)

                                if store.pendingManualWorkoutIDs.contains(row.workout.id) {
                                    ProgressView()
                                        .controlSize(.small)
                                        .frame(width: 34, height: 34)
                                        .accessibilityLabel("Saving category")
                                } else {
                                    categoryMenu {
                                        update(row: row, category: $0)
                                    }
                                }
                            }
                        }
                    }
                    .task {
                        await store.hydrateCachedWorkoutPlanNameIfAvailable(for: row.workout.id)
                    }
                }
            }
        }
    }

    private var bulkControls: some View {
        VStack(alignment: .leading, spacing: 8) {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 120), spacing: 8)], spacing: 8) {
                Button("All Visible") {
                    selectedWorkoutIDs = Set(rows.map(\.workout.id))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Before Nov 2025") {
                    selectedWorkoutIDs = Set(rows.filter { isBeforeManualReviewEra($0.workout.startDate) }.map(\.workout.id))
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button("Clear") {
                    selectedWorkoutIDs.removeAll()
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }

            LazyVGrid(columns: [GridItem(.adaptive(minimum: 135), spacing: 8)], spacing: 8) {
                Menu {
                    ForEach(WeeklyRunCategory.allCases) { category in
                        Button(category.label) {
                            bulkCategory = category
                        }
                    }
                } label: {
                    Label(bulkCategory.label, systemImage: "tag")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)

                Button {
                    applyBulkCategory()
                } label: {
                    Label("Apply to \(selectedWorkoutIDs.count)", systemImage: "checkmark.circle")
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.small)
                .disabled(selectedWorkoutIDs.isEmpty)
            }
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func workoutRow(_ row: WeeklyWorkoutRow, selected: Bool, selectable: Bool) -> some View {
        HStack(spacing: 10) {
            if selectable {
                Image(systemName: selected ? "checkmark.circle.fill" : "circle")
                    .foregroundStyle(selected ? .blue : RunSignalTextStyle.secondary)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(RunWorkout(workout: row.workout).runnerFacingTitle)
                    .font(.subheadline.bold())
                Text("\(row.category.label) · \(RunFormatters.mediumDateWithYear.string(from: row.workout.startDate))")
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(RunFormatters.distance(row.workout.distanceMeters))
                    .font(.subheadline.monospacedDigit().bold())
                Text(RunFormatters.pace(row.workout.paceSecondsPerKm))
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func categoryMenu(_ action: @escaping (WeeklyRunCategory) -> Void) -> some View {
        Menu {
            ForEach(WeeklyRunCategory.allCases) { category in
                Button(category.label) {
                    action(category)
                }
            }
        } label: {
            Image(systemName: "tag")
                .frame(width: 34, height: 34)
        }
        .buttonStyle(.bordered)
        .accessibilityLabel("Set run category")
    }

    private func toggleSelection(_ workoutID: String) {
        if selectedWorkoutIDs.contains(workoutID) {
            selectedWorkoutIDs.remove(workoutID)
        } else {
            selectedWorkoutIDs.insert(workoutID)
        }
    }

    private func applyBulkCategory() {
        let selectedIDs = selectedWorkoutIDs
        let updates = rows.compactMap { row -> ManualWorkoutFieldUpdate? in
            guard selectedIDs.contains(row.workout.id) else { return nil }
            return ManualWorkoutFieldUpdate(
                id: row.workout.id,
                runType: bulkCategory.manualRunType,
                notes: row.workout.notes
            )
        }
        store.updateManualFields(updates)
        selectedWorkoutIDs.removeAll()
    }

    private func update(row: WeeklyWorkoutRow, category: WeeklyRunCategory) {
        store.update(
            workoutID: row.workout.id,
            manualRunType: category.manualRunType,
            notes: row.workout.notes
        )
    }

    private func isBeforeManualReviewEra(_ date: Date) -> Bool {
        let cutoff = DateComponents(calendar: .current, year: 2025, month: 11, day: 1).date
        return cutoff.map { date < $0 } ?? false
    }
}

private extension WeeklyRunCategory {
    var manualRunType: RunType {
        switch self {
        case .easy:
            return .easy
        case .interval:
            return .interval
        case .threshold:
            return .threshold
        case .longRun:
            return .longRun
        case .warmupCooldown:
            return .easy
        case .race:
            return .race
        case .other:
            return .unknown
        }
    }
}

private struct FutureAnalyticsPeriodView: View {
    let title: String
    let message: String

    var body: some View {
        EmptyStateView(title: title, message: message)
    }
}

struct WorkoutChartDeck: View {
    let workout: CanonicalWorkout
    var interval: ReconstructedWorkoutInterval?
    var heartRateZoneProfile: HeartRateZoneProfile?

    @State private var selectedMinute: Double?
    @State private var selectedMetric = WorkoutChartMetric.pace
    @State private var series: [WorkoutChartSeries] = []
    @State private var officialIntervals: [ReconstructedWorkoutInterval] = []
    @State private var heartRateZoneAnalysis: HeartRateZoneAnalysis?
    @State private var presentedHeartRateZoneAnalysis: HeartRateZoneAnalysis?

    init(
        workout: CanonicalWorkout,
        interval: ReconstructedWorkoutInterval? = nil,
        heartRateZoneProfile: HeartRateZoneProfile? = nil
    ) {
        self.workout = workout
        self.interval = interval
        self.heartRateZoneProfile = heartRateZoneProfile
    }

    private var availableSeries: [WorkoutChartSeries] {
        series.filter(\.isRenderable)
    }

    private var visibleSeries: [WorkoutChartSeries] {
        availableSeries.filter { $0.metric != .power }
    }

    private var selectedSeries: WorkoutChartSeries? {
        visibleSeries.first { $0.metric == selectedMetric } ?? visibleSeries.first
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if visibleSeries.count > 1 {
                Picker("Chart metric", selection: $selectedMetric) {
                    ForEach(visibleSeries) { item in
                        Text(item.metric.pickerTitle).tag(item.metric)
                    }
                }
                .pickerStyle(.segmented)
            }

            if let selectedSeries {
                WorkoutChartCard(
                    series: selectedSeries,
                    intervalMarkers: officialIntervals.chartMarkers(workoutStart: workout.startDate),
                    intervalSpans: officialIntervals.chartSpans(workoutStart: workout.startDate),
                    selectedMinute: $selectedMinute,
                    heartRateZoneAnalysis: selectedSeries.metric == .heartRate ? heartRateZoneAnalysis : nil,
                    showHeartRateZoneDetails: {
                        presentedHeartRateZoneAnalysis = heartRateZoneAnalysis
                    }
                )
            } else if !series.isEmpty {
                EmptyStateView(
                    title: "Charts unavailable",
                    message: "RunSignal needs at least two loaded samples for a workout chart."
                )
            }
        }
        .task(id: presentationID) {
            let workout = workout
            let interval = interval
            let presentation = await Task.detached(priority: .userInitiated) {
                let core = WorkoutChartSeriesBuilder.presentationSeries(for: workout)
                let series: [WorkoutChartSeries]
                if let interval {
                    series = core.map {
                        WorkoutChartSeriesBuilder.clippedSeries(
                            $0,
                            start: interval.actualStartDate,
                            end: interval.actualEndDate
                        )
                    }
                } else {
                    series = core
                }
                let officialIntervals: [ReconstructedWorkoutInterval]
                if interval == nil,
                   let evidence = workout.evidence,
                   let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) {
                    officialIntervals = result.intervals
                } else {
                    officialIntervals = []
                }
                return (series, officialIntervals)
            }.value
            series = presentation.0
            officialIntervals = presentation.1
            if !visibleSeries.contains(where: { $0.metric == selectedMetric }),
               let first = visibleSeries.first {
                selectedMetric = first.metric
            }
            if interval == nil, let heartRateZoneProfile {
                heartRateZoneAnalysis = await Task.detached(priority: .userInitiated) {
                    HeartRateZoneAnalyzer.analyze(workout: workout, profile: heartRateZoneProfile)
                }.value
            } else {
                heartRateZoneAnalysis = nil
            }
        }
        .sheet(item: $presentedHeartRateZoneAnalysis) { analysis in
            HeartRateZoneDetailView(workout: workout, analysis: analysis)
        }
    }

    private var presentationID: String {
        let loadedAt = workout.evidence?.loadedAt.timeIntervalSince1970 ?? 0
        return "\(loadedAt)|\(interval?.index ?? -1)"
    }
}

private struct WorkoutChartCard: View {
    let series: WorkoutChartSeries
    let intervalMarkers: [WorkoutChartIntervalMarker]
    let intervalSpans: [WorkoutChartIntervalSpan]
    @Binding var selectedMinute: Double?
    let heartRateZoneAnalysis: HeartRateZoneAnalysis?
    let showHeartRateZoneDetails: () -> Void

    private var selectedPoint: WorkoutChartPoint? {
        guard let selectedMinute, !series.points.isEmpty else { return nil }
        return series.points.min {
            abs($0.offsetSeconds / 60 - selectedMinute) < abs($1.offsetSeconds / 60 - selectedMinute)
        }
    }

    private var headlineValue: Double? {
        selectedPoint?.value ?? medianValue
    }

    private var medianValue: Double? {
        let values = finiteValues.sorted()
        guard !values.isEmpty else { return nil }
        return values[values.count / 2]
    }

    private var finiteValues: [Double] {
        series.points.map(\.value).filter { $0.isFinite }
    }

    private var xDomain: ClosedRange<Double> {
        let minutes = series.points.map { $0.offsetSeconds / 60 }.filter { $0.isFinite }
        guard let minimum = minutes.min(), let maximum = minutes.max() else {
            return 0...1
        }
        guard minimum != maximum else {
            return minimum...(minimum + 1)
        }
        return minimum...maximum
    }

    private var yDomain: ClosedRange<Double> {
        let values = finiteValues
        guard let minimum = values.min(), let maximum = values.max() else {
            return 0...1
        }
        guard minimum != maximum else {
            let padding = max(abs(minimum) * 0.1, 1)
            return (minimum - padding)...(maximum + padding)
        }

        let padding = max((maximum - minimum) * 0.12, yMinimumPadding)
        let lower = yLowerBound(minimum - padding)
        return lower...(maximum + padding)
    }

    private var yMinimumPadding: Double {
        switch series.metric {
        case .pace:
            15
        case .heartRate:
            5
        case .power:
            10
        case .cadence:
            5
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(series.metric.title)
                        .font(.subheadline.bold())
                    HStack(alignment: .lastTextBaseline, spacing: 6) {
                        Text(WorkoutChartFormatter.value(headlineValue, metric: series.metric))
                            .font(.title3.monospacedDigit().bold())
                        Text(selectionCaption)
                            .font(.caption2)
                            .foregroundStyle(.secondary)
                    }
                }
                Spacer()
                if selectedMinute != nil {
                    Button("Clear") {
                        selectedMinute = nil
                    }
                    .font(.caption.bold())
                    .buttonStyle(.bordered)
                }
                if heartRateZoneAnalysis != nil {
                    Button("Zones", action: showHeartRateZoneDetails)
                        .font(.caption.bold())
                        .buttonStyle(.bordered)
                }
                Text(series.metric.unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if series.isRenderable {
                Chart {
                    ForEach(intervalSpans) { span in
                        RectangleMark(
                            xStart: .value("Interval start", span.startMinute),
                            xEnd: .value("Interval end", span.endMinute),
                            yStart: .value("Chart minimum", yDomain.lowerBound),
                            yEnd: .value("Chart maximum", yDomain.upperBound)
                        )
                        .foregroundStyle(span.tint.opacity(span.opacity))
                    }

                    ForEach(intervalMarkers) { marker in
                        RuleMark(x: .value("Interval boundary", marker.offsetMinutes))
                            .foregroundStyle(marker.tint.opacity(0.32))
                            .lineStyle(StrokeStyle(lineWidth: 1, dash: [2, 4]))
                    }

                    ForEach(series.points) { point in
                        LineMark(
                            x: .value("Time", point.offsetSeconds / 60),
                            y: .value(series.metric.title, point.value)
                        )
                        .interpolationMethod(.linear)
                        .foregroundStyle(.blue)
                    }

                    if let selectedPoint {
                        RuleMark(x: .value("Selected", selectedPoint.offsetSeconds / 60))
                            .foregroundStyle(.primary.opacity(0.45))
                            .lineStyle(StrokeStyle(lineWidth: 1.5))
                        PointMark(
                            x: .value("Selected time", selectedPoint.offsetSeconds / 60),
                            y: .value(series.metric.title, selectedPoint.value)
                        )
                        .foregroundStyle(.blue)
                        .symbolSize(34)
                    }
                }
                .frame(height: 165)
                .chartXScale(domain: xDomain)
                .chartYScale(domain: yDomain)
                .chartXAxis {
                    AxisMarks { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let minute = value.as(Double.self) {
                                Text(WorkoutChartFormatter.axisTime(minute))
                            }
                        }
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .trailing) { value in
                        AxisGridLine()
                        AxisTick()
                        AxisValueLabel {
                            if let chartValue = value.as(Double.self) {
                                Text(WorkoutChartFormatter.axisValue(chartValue, metric: series.metric))
                            }
                        }
                    }
                }
                .chartOverlay { proxy in
                    GeometryReader { geometry in
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        guard let plotFrame = proxy.plotFrame else { return }
                                        let frame = geometry[plotFrame]
                                        let x = value.location.x - frame.origin.x
                                        guard x >= 0, x <= frame.width,
                                              let minute: Double = proxy.value(atX: x) else { return }
                                        selectedMinute = min(max(minute, xDomain.lowerBound), xDomain.upperBound)
                                    }
                            )
                    }
                }
                .accessibilityLabel("\(series.metric.title) chart")
            } else {
                EmptyStateView(
                    title: "\(series.metric.title) unavailable",
                    message: "RunSignal needs at least two loaded HealthKit samples for this chart."
                )
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var selectionCaption: String {
        guard medianValue != nil else { return "No samples" }
        guard let selectedPoint else { return "Median" }
        return RunFormatters.duration(selectedPoint.offsetSeconds)
    }

    private func yLowerBound(_ value: Double) -> Double {
        switch series.metric {
        case .pace:
            max(90, value)
        case .heartRate:
            max(40, value)
        case .power, .cadence:
            max(0, value)
        }
    }
}

private struct HeartRateZoneDetailView: View {
    @Environment(\.dismiss) private var dismiss

    let workout: CanonicalWorkout
    let analysis: HeartRateZoneAnalysis

    private var workoutDuration: Double {
        max(workout.durationSeconds, 1)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Average Heart Rate")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text(RunFormatters.number(workout.averageHeartRate, suffix: " bpm"))
                            .font(.title.bold().monospacedDigit())
                    }

                    Chart {
                        ForEach(analysis.samples) { sample in
                            LineMark(
                                x: .value("Time", sample.offsetSeconds / 60),
                                y: .value("Heart rate", sample.beatsPerMinute)
                            )
                            .interpolationMethod(.linear)
                            .foregroundStyle(.secondary.opacity(0.35))

                            PointMark(
                                x: .value("Time", sample.offsetSeconds / 60),
                                y: .value("Heart rate", sample.beatsPerMinute)
                            )
                            .foregroundStyle(HeartRateZonePalette.color(for: sample.zone))
                            .symbolSize(12)
                        }
                    }
                    .frame(height: 210)
                    .chartXAxisLabel("Workout time")
                    .chartYAxisLabel("bpm")
                    .accessibilityLabel("Heart rate colored by zone")

                    VStack(spacing: 12) {
                        ForEach(analysis.durations) { duration in
                            HeartRateZoneDurationRow(
                                duration: duration,
                                range: analysis.profile.ranges.first { $0.zone == duration.zone },
                                workoutDuration: workoutDuration
                            )
                        }
                    }

                    Text("Estimated time in each heart rate zone")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    if analysis.unclassifiedDurationSeconds >= 1 {
                        LabeledContent(
                            "Unclassified",
                            value: RunFormatters.duration(analysis.unclassifiedDurationSeconds)
                        )
                        .font(.subheadline)
                    }

                    if let caveat = analysis.caveat {
                        NoticeCard(
                            title: "Pause timing note",
                            message: caveat,
                            systemImage: "pause.circle",
                            tint: .orange
                        )
                    }

                    VStack(alignment: .leading, spacing: 6) {
                        Text("Zone Profile")
                            .font(.headline)
                        LabeledContent("Method", value: analysis.profile.method.label)
                        LabeledContent("Effective", value: effectiveDateText)
                        if let resting = analysis.profile.restingHeartRate {
                            LabeledContent("Resting HR", value: "\(resting) bpm")
                        }
                        if let maximum = analysis.profile.maximumHeartRate {
                            LabeledContent(
                                analysis.profile.maximumHeartRateIsUserOverride ? "Confirmed maximum HR" : "Maximum HR",
                                value: "\(maximum) bpm"
                            )
                        }
                        Text(analysis.profile.sourceDetail)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding()
                .padding(.bottom, 24)
            }
            .navigationTitle("Heart Rate Zones")
            .runSignalInlineNavigationTitle()
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }

    private var effectiveDateText: String {
        analysis.profile.isHistoricalBackfill
            ? "Existing history"
            : RunFormatters.shortDate.string(from: analysis.profile.effectiveDate)
    }
}

private struct HeartRateZoneDurationRow: View {
    let duration: HeartRateZoneDuration
    let range: HeartRateZoneRange?
    let workoutDuration: Double

    private var fraction: Double {
        min(max(duration.durationSeconds / workoutDuration, 0), 1)
    }

    var body: some View {
        VStack(spacing: 6) {
            HStack {
                Circle()
                    .fill(HeartRateZonePalette.color(for: duration.zone))
                    .frame(width: 10, height: 10)
                Text("Zone \(duration.zone)")
                    .font(.subheadline.bold())
                Spacer()
                Text(RunFormatters.duration(duration.durationSeconds))
                    .font(.subheadline.monospacedDigit().bold())
                Text(range?.displayRange ?? "")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            ProgressView(value: fraction)
                .tint(HeartRateZonePalette.color(for: duration.zone))
        }
    }
}

private enum HeartRateZonePalette {
    static func color(for zone: Int) -> Color {
        switch zone {
        case 1: .blue
        case 2: .mint
        case 3: .green
        case 4: .orange
        case 5: .pink
        default: .secondary
        }
    }
}

private struct WorkoutChartIntervalMarker: Identifiable {
    let id: String
    let offsetMinutes: Double
    let tint: Color
}

private struct WorkoutChartIntervalSpan: Identifiable {
    let id: String
    let startMinute: Double
    let endMinute: Double
    let tint: Color
    let opacity: Double
}

private extension Array where Element == ReconstructedWorkoutInterval {
    func chartSpans(workoutStart: Date) -> [WorkoutChartIntervalSpan] {
        filter { $0.stepType == .work }.compactMap { interval in
            let start = interval.actualStartDate.timeIntervalSince(workoutStart) / 60
            let end = interval.actualEndDate.timeIntervalSince(workoutStart) / 60
            guard end > start else { return nil }
            return WorkoutChartIntervalSpan(
                id: "span-\(interval.index)",
                startMinute: start,
                endMinute: end,
                tint: intervalRoleTint(for: interval.stepType),
                opacity: 0.10
            )
        }
    }

    func chartMarkers(workoutStart: Date) -> [WorkoutChartIntervalMarker] {
        var seen: Set<Int> = []
        return filter { $0.stepType == .work }.flatMap { interval in
            [
                WorkoutChartIntervalMarker(
                    id: "start-\(interval.index)",
                    offsetMinutes: interval.actualStartDate.timeIntervalSince(workoutStart) / 60,
                    tint: intervalRoleTint(for: interval.stepType)
                ),
                WorkoutChartIntervalMarker(
                    id: "end-\(interval.index)",
                    offsetMinutes: interval.actualEndDate.timeIntervalSince(workoutStart) / 60,
                    tint: intervalRoleTint(for: interval.stepType)
                )
            ]
        }
        .filter { marker in
            let key = Int((marker.offsetMinutes * 1_000).rounded())
            return seen.insert(key).inserted
        }
    }
}

private enum WorkoutChartFormatter {
    static func value(_ value: Double?, metric: WorkoutChartMetric) -> String {
        guard let value else { return "Unavailable" }
        switch metric {
        case .pace:
            return RunFormatters.pace(value)
        case .heartRate:
            return RunFormatters.number(value, suffix: " bpm")
        case .power:
            return RunFormatters.number(value, suffix: " W")
        case .cadence:
            return RunFormatters.number(value, suffix: " spm")
        }
    }

    static func axisValue(_ value: Double, metric: WorkoutChartMetric) -> String {
        switch metric {
        case .pace:
            return RunFormatters.pace(value).replacingOccurrences(of: " /km", with: "")
        case .heartRate, .power, .cadence:
            return RunFormatters.number(value, suffix: "")
        }
    }

    static func axisTime(_ minute: Double) -> String {
        "\(Int(minute.rounded()))"
    }
}

private enum IntervalMetricFormatter {
    static func value(_ value: Double?, metric: IntervalAnalysisMetric) -> String {
        guard let value else { return "Unavailable" }
        switch metric {
        case .pace:
            return RunFormatters.pace(value)
        case .heartRate:
            return RunFormatters.number(value, suffix: " bpm")
        case .power:
            return RunFormatters.number(value, suffix: " W")
        case .cadence:
            return RunFormatters.number(value, suffix: " spm")
        case .duration:
            return RunFormatters.duration(value)
        case .distance:
            return RunFormatters.compactDistance(value)
        }
    }

    static func axisValue(_ chartValue: Double, metric: IntervalAnalysisMetric) -> String {
        switch metric {
        case .pace:
            guard chartValue > 0 else { return "" }
            return RunFormatters.pace(3_600 / chartValue).replacingOccurrences(of: " /km", with: "")
        case .heartRate:
            return RunFormatters.number(chartValue, suffix: "")
        case .power:
            return RunFormatters.number(chartValue, suffix: "")
        case .cadence:
            return RunFormatters.number(chartValue, suffix: "")
        case .duration:
            return RunFormatters.duration(chartValue)
        case .distance:
            return chartValue >= 1_000
                ? String(format: "%.1f km", chartValue / 1_000)
                : "\(Int(chartValue.rounded())) m"
        }
    }
}

struct IntervalAnalysisEntryCard: View {
    let workout: CanonicalWorkout
    let result: WorkoutIntervalReconstructionResult

    private var summary: IntervalAnalysisSummary {
        IntervalAnalysisSummary(workout: workout, result: result)
    }

    private var targetEvaluations: [WorkTargetEvaluation] {
        result.intervals.compactMap { WorkTargetEvaluator.evaluate(interval: $0) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            IntervalResultsPanel(summary: summary, evaluations: targetEvaluations)

            NavigationLink {
                IntervalAnalysisScreen(workout: workout, result: result)
            } label: {
                Label("Review Intervals", systemImage: "chart.bar.xaxis")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
    }
}

struct IntervalAnalysisScreen: View {
    let workout: CanonicalWorkout
    let result: WorkoutIntervalReconstructionResult

    @State private var selectedMetric = IntervalAnalysisMetric.pace
    @State private var selectedIntervalIndex: Int?

    private var summary: IntervalAnalysisSummary {
        IntervalAnalysisSummary(workout: workout, result: result)
    }

    private var availableMetrics: [IntervalAnalysisMetric] {
        [.pace, .heartRate, .cadence].filter { summary.availableMetrics.contains($0) }
    }

    private var chartRows: [IntervalAnalysisRow] {
        summary.rows.filter { $0.stepType == .work }
    }

    private var selectedRow: IntervalAnalysisRow? {
        guard let selectedIntervalIndex else { return nil }
        return summary.rows.first { $0.index == selectedIntervalIndex }
    }

    private var selectedInterval: ReconstructedWorkoutInterval? {
        guard let selectedIntervalIndex else { return nil }
        return result.intervals.first { $0.index == selectedIntervalIndex }
    }

    private var targetEvaluations: [WorkTargetEvaluation] {
        result.intervals.compactMap { WorkTargetEvaluator.evaluate(interval: $0) }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(
                    title: "Interval Analysis",
                    subtitle: "Review work-rep consistency, pace targets, and every completed interval."
                )

                IntervalResultsPanel(summary: summary, evaluations: targetEvaluations)

                VStack(alignment: .leading, spacing: 12) {
                    Text("Work Rep Comparison")
                        .font(.headline)

                    Text("This chart compares the same metric across your Work reps. Tap a rep to inspect it; Repeat Details below shows every Work and Recovery row.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)

                    if availableMetrics.count > 1 {
                        IntervalMetricPicker(metrics: availableMetrics, selectedMetric: $selectedMetric)
                    } else if let metric = availableMetrics.first {
                        Text(metric.title)
                            .font(.subheadline.bold())
                    }

                    IntervalPrimaryScrubChart(
                        summary: summary,
                        intervals: result.intervals,
                        rows: chartRows,
                        metric: selectedMetric,
                        selectedIntervalIndex: $selectedIntervalIndex
                    )
                }
                .padding()
                .background(.background)
                .clipShape(RoundedRectangle(cornerRadius: 8))

                IntervalSelectedRowPanel(
                    summary: summary,
                    metric: selectedMetric,
                    selectedRow: selectedRow,
                    selectedInterval: selectedInterval
                )

                IntervalAnalysisRowsPanel(
                    workout: workout,
                    result: result,
                    summary: summary
                )
            }
            .padding()
            .padding(.bottom, 160)
        }
        .navigationTitle("Intervals")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
        }
        .onAppear(perform: normalizeSelection)
        .onChange(of: selectedMetric) {
            normalizeSelection()
        }
    }

    private func normalizeSelection() {
        if !availableMetrics.contains(selectedMetric), let firstMetric = availableMetrics.first {
            selectedMetric = firstMetric
        }
        if let selectedIntervalIndex,
           !chartRows.contains(where: { $0.index == selectedIntervalIndex }) {
            self.selectedIntervalIndex = nil
        }
    }
}

private struct IntervalResultsPanel: View {
    let summary: IntervalAnalysisSummary
    let evaluations: [WorkTargetEvaluation]

    private var targeted: [WorkTargetEvaluation] {
        evaluations.filter { $0.result != .noTarget }
    }

    private var exactTargeted: [WorkTargetEvaluation] {
        evaluations.filter { $0.exactTargetSecondsPerKilometer != nil }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Interval Results")
                        .font(.headline)
                    Text(prescriptionTitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                if !targeted.isEmpty || !exactTargeted.isEmpty {
                    Text("\(max(targeted.count, exactTargeted.count)) reps")
                        .font(.caption2.bold())
                        .foregroundStyle(.blue)
                }
            }

            if !targeted.isEmpty {
                Text(workTargetSummaryText(targeted))
                    .font(.headline.monospacedDigit())
            } else if let exactTargetSummary {
                Text(exactTargetSummary)
                    .font(.headline.monospacedDigit())
            }

            MetricGrid(items: metricItems)

            if let measuredDistanceText {
                Label(measuredDistanceText, systemImage: "waveform.path.ecg")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if targeted.contains(where: { $0.completionStatus == .shortened }) {
                Text("A shortened rep keeps its pace result separate from completion.")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .contain)
    }

    private var prescriptionTitle: String {
        let workRows = summary.rows.filter { $0.stepType == .work }
        guard let first = workRows.first else { return "Completed interval structure" }
        let matchingGoals = workRows.filter {
            $0.plannedGoalType == first.plannedGoalType &&
                abs(($0.plannedGoalValue ?? 0) - (first.plannedGoalValue ?? 0)) < 0.5
        }
        guard matchingGoals.count == workRows.count else { return "\(workRows.count) work intervals" }
        return "\(workRows.count) × \(first.plannedGoalDisplayText)"
    }

    private var metricItems: [MetricItem] {
        guard let workSummary = summary.workRepeatSummary else {
            return [MetricItem(title: "Intervals", value: "\(summary.rows.count)", detail: "Completed rows")]
        }
        return [
            MetricItem(title: "Work Intervals", value: "\(workSummary.repeatCount)", detail: "Completed"),
            MetricItem(title: "Work Distance", value: RunFormatters.compactDistance(workSummary.primaryDistanceMeters), detail: "Prescribed basis"),
            MetricItem(title: "Work Time", value: RunFormatters.duration(workSummary.primaryDurationSeconds), detail: "Completed intervals"),
            MetricItem(title: "Avg Work Pace", value: RunFormatters.pace(workSummary.primaryPaceSecondsPerKm), detail: "Prescribed basis")
        ]
    }

    private var measuredDistanceText: String? {
        guard let workSummary = summary.workRepeatSummary,
              abs(workSummary.totalDistanceMeters - workSummary.primaryDistanceMeters) >= 5 else { return nil }
        return "Apple Health measured \(RunFormatters.compactDistance(workSummary.totalDistanceMeters)) across the work intervals."
    }

    private var exactTargetSummary: String? {
        guard !exactTargeted.isEmpty,
              let target = exactTargeted.compactMap(\.exactTargetSecondsPerKilometer).first,
              exactTargeted.allSatisfy({
                  guard let candidate = $0.exactTargetSecondsPerKilometer else { return false }
                  return abs(candidate - target) < 0.5
              }) else { return nil }
        let measuredPaces = exactTargeted.compactMap(\.measurement.paceSecondsPerKilometer)
        guard !measuredPaces.isEmpty else {
            return "Exact pace target \(RunFormatters.pace(target)) · comparison unavailable"
        }
        let average = measuredPaces.reduce(0, +) / Double(measuredPaces.count)
        let delta = Int(abs(average - target).rounded())
        let comparison = delta == 0
            ? "average matched"
            : "average \(delta)s/km \(average < target ? "faster" : "slower")"
        return "Exact pace target \(RunFormatters.pace(target)) · \(comparison)"
    }
}

private struct IntervalMetricPicker: View {
    let metrics: [IntervalAnalysisMetric]
    @Binding var selectedMetric: IntervalAnalysisMetric

    var body: some View {
        Picker("Metric", selection: $selectedMetric) {
            ForEach(metrics) { metric in
                Text(metric.pickerTitle).tag(metric)
            }
        }
        .pickerStyle(.segmented)
    }
}

private struct IntervalPrimaryScrubChart: View {
    let summary: IntervalAnalysisSummary
    let intervals: [ReconstructedWorkoutInterval]
    let rows: [IntervalAnalysisRow]
    let metric: IntervalAnalysisMetric
    @Binding var selectedIntervalIndex: Int?

    private var selectedRow: IntervalAnalysisRow? {
        guard let selectedIntervalIndex else { return nil }
        return rows.first { $0.index == selectedIntervalIndex }
    }

    private var headlineValue: IntervalAnalysisMetricValue? {
        if let selectedRow, let value = selectedRow.value(for: metric) {
            return value
        }
        return summary.aggregateValue(for: metric)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .lastTextBaseline) {
                Text(IntervalMetricFormatter.value(headlineValue?.displayValue, metric: metric))
                    .font(.title2.monospacedDigit().bold())
                    .foregroundStyle(intervalMetricTint(metric))
                Text(selectedRow?.label ?? "Average Work")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                if selectedIntervalIndex != nil {
                    Button("Average") {
                        selectedIntervalIndex = nil
                    }
                    .font(.caption.bold())
                    .buttonStyle(.bordered)
                }
            }

            Chart {
                if metric == .pace {
                    ForEach(rows) { row in
                        if let interval = intervals.first(where: { $0.index == row.index }),
                           let range = WorkTargetEvaluator.evaluate(interval: interval)?.targetRange {
                            let position = Double(xPosition(for: row))
                            RectangleMark(
                                xStart: .value("Target start", position - 0.42),
                                xEnd: .value("Target end", position + 0.42),
                                yStart: .value("Target slow", 3_600 / range.slowestSecondsPerKilometer),
                                yEnd: .value("Target fast", 3_600 / range.fastestSecondsPerKilometer)
                            )
                            .foregroundStyle(.green.opacity(0.16))
                        }
                    }
                }

                if let aggregate = summary.aggregateValue(for: metric) {
                    RuleMark(y: .value("Average", aggregate.chartValue))
                        .foregroundStyle(.secondary.opacity(0.6))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                }

                ForEach(rows) { row in
                    if let value = row.value(for: metric) {
                        BarMark(
                            x: .value("Interval", xPosition(for: row)),
                            y: .value(metric.title, value.chartValue),
                            width: .ratio(0.62)
                        )
                        .foregroundStyle(barTint(for: row))
                        .cornerRadius(4)
                    }
                }

                if let selectedIntervalIndex,
                   let row = rows.first(where: { $0.index == selectedIntervalIndex }) {
                    RuleMark(x: .value("Selected", xPosition(for: row)))
                        .foregroundStyle(.primary.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                }
            }
            .frame(height: 260)
            .chartXAxis {
                AxisMarks(values: Array(1...max(rows.count, 1))) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let position = value.as(Int.self),
                           rows.indices.contains(position - 1) {
                            let row = rows[position - 1]
                            Text(axisLabel(for: row))
                                .foregroundStyle(intervalRoleTint(for: row))
                        }
                    }
                }
            }
            .chartYAxis {
                AxisMarks(position: .leading) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let chartValue = value.as(Double.self) {
                            Text(IntervalMetricFormatter.axisValue(chartValue, metric: metric))
                        }
                    }
                }
            }
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    Rectangle()
                        .fill(.clear)
                        .contentShape(Rectangle())
                        .gesture(
                            DragGesture(minimumDistance: 0)
                                .onChanged { value in
                                    guard let plotFrame = proxy.plotFrame else { return }
                                    let frame = geometry[plotFrame]
                                    let x = value.location.x - frame.origin.x
                                    guard x >= 0, x <= frame.width,
                                          let position: Int = proxy.value(atX: x),
                                          rows.indices.contains(position - 1) else { return }
                                    selectedIntervalIndex = rows[position - 1].index
                                }
                        )
                }
            }
            .accessibilityLabel("\(metric.title) by interval")
        }
    }

    private func xPosition(for row: IntervalAnalysisRow) -> Int {
        (rows.firstIndex(where: { $0.index == row.index }) ?? 0) + 1
    }

    private func axisLabel(for row: IntervalAnalysisRow) -> String {
        let matchingRows = rows.filter { $0.stepType == row.stepType }
        let ordinal = (matchingRows.firstIndex(where: { $0.index == row.index }) ?? 0) + 1
        return "\(row.roleAbbreviation)\(ordinal)"
    }

    private func barTint(for row: IntervalAnalysisRow) -> Color {
        guard let selectedIntervalIndex else {
            return intervalRoleTint(for: row)
        }
        return row.index == selectedIntervalIndex ? intervalMetricTint(metric) : intervalRoleTint(for: row).opacity(0.35)
    }
}

private struct IntervalSelectedRowPanel: View {
    let summary: IntervalAnalysisSummary
    let metric: IntervalAnalysisMetric
    let selectedRow: IntervalAnalysisRow?
    let selectedInterval: ReconstructedWorkoutInterval?

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.subheadline.bold())
                    Text(subtitle)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text(selectedRow == nil ? "Average" : "Selected")
                    .font(.caption2.bold())
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.12))
                    .clipShape(Capsule())
            }

            if let selectedRow,
               let pauseOverlap = selectedRow.pauseOverlapSeconds,
               pauseOverlap > 0 {
                MetricGrid(items: [
                    MetricItem(title: "Elapsed", value: RunFormatters.duration(selectedRow.elapsedDurationSeconds), detail: "Row window"),
                    MetricItem(title: "Pause", value: RunFormatters.duration(pauseOverlap), detail: "Paired overlap"),
                    MetricItem(title: "Active", value: RunFormatters.duration(selectedRow.activeDurationSeconds), detail: "Timer duration")
                ])
            }

            if let selectedInterval,
               let evaluation = WorkTargetEvaluator.evaluate(interval: selectedInterval),
               evaluation.result != .noTarget || evaluation.exactTargetSecondsPerKilometer != nil {
                WorkTargetDetailGrid(evaluation: evaluation)
            }

            MetricGrid(items: metricItems)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var title: String {
        if let selectedRow {
            return "\(selectedRow.index). \(selectedRow.label)"
        }
        return summary.aggregateScopeLabel
    }

    private var subtitle: String {
        if let selectedRow {
            return "\(selectedRow.plannedGoalDisplayText) · \(selectedRow.displayBasisLabel)"
        }
        return "Across all completed work intervals"
    }

    private var metricItems: [MetricItem] {
        if let selectedRow {
            return [
                MetricItem(title: metric.title, value: IntervalMetricFormatter.value(selectedRow.value(for: metric)?.displayValue, metric: metric), detail: selectedRow.roleAbbreviation),
            ] + IntervalGoalMeasuredText.metricItems(for: selectedRow)
        }

        return [
            MetricItem(title: metric.title, value: IntervalMetricFormatter.value(summary.aggregateValue(for: metric)?.displayValue, metric: metric), detail: summary.aggregateCaption(for: metric)),
            MetricItem(title: "Distance", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .distance)?.displayValue, metric: .distance), detail: "Total"),
            MetricItem(title: "Duration", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .duration)?.displayValue, metric: .duration), detail: "Total"),
            MetricItem(title: "Pace", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .pace)?.displayValue, metric: .pace), detail: "Aggregate")
        ]
    }
}

private struct IntervalAnalysisRowsPanel: View {
    let workout: CanonicalWorkout
    let result: WorkoutIntervalReconstructionResult
    let summary: IntervalAnalysisSummary

    private var groupedIndexes: Set<Int> {
        Set(summary.repeatGroups.flatMap { $0.rows.map(\.index) })
    }

    private var rowsBeforeGroups: [IntervalAnalysisRow] {
        guard let firstGroupedIndex = groupedIndexes.min() else { return [] }
        return summary.rows.filter { $0.index < firstGroupedIndex }
    }

    private var rowsAfterGroups: [IntervalAnalysisRow] {
        guard let lastGroupedIndex = groupedIndexes.max() else { return [] }
        return summary.rows.filter { $0.index > lastGroupedIndex }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(summary.repeatGroups.isEmpty ? "Interval Details" : "Repeat Details")

            if summary.repeatGroups.isEmpty {
                VStack(spacing: 8) {
                    ForEach(summary.rows) { row in
                        rowLink(row)
                    }
                }
            } else {
                VStack(spacing: 8) {
                    ForEach(rowsBeforeGroups) { row in
                        rowLink(row)
                    }

                    HStack {
                        Text("Work + Recovery")
                            .font(.headline)
                        Spacer()
                        Label("\(summary.repeatGroups.count)", systemImage: "repeat")
                            .font(.subheadline.bold())
                            .foregroundStyle(.purple)
                    }

                    ForEach(summary.repeatGroups) { group in
                        IntervalRepeatGroupCard(
                            workout: workout,
                            result: result,
                            group: group
                        )
                    }

                    ForEach(rowsAfterGroups) { row in
                        rowLink(row)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private func rowLink(_ row: IntervalAnalysisRow) -> some View {
        if let interval = result.intervals.first(where: { $0.index == row.index }) {
            NavigationLink {
                IntervalDetailView(workout: workout, interval: interval)
            } label: {
                IntervalAnalysisCompactRow(
                    row: row,
                    evaluation: WorkTargetEvaluator.evaluate(interval: interval)
                )
            }
            .buttonStyle(.plain)
        } else {
            IntervalAnalysisCompactRow(row: row)
        }
    }
}

private struct IntervalRepeatGroupCard: View {
    let workout: CanonicalWorkout
    let result: WorkoutIntervalReconstructionResult
    let group: IntervalRepeatGroup

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Label("\(group.repeatNumber) of \(repeatCount)", systemImage: "repeat")
                    .font(.subheadline.bold())
                    .foregroundStyle(.purple)
                Spacer()
            }

            ForEach(group.rows) { row in
                if let interval = result.intervals.first(where: { $0.index == row.index }) {
                    NavigationLink {
                        IntervalDetailView(workout: workout, interval: interval)
                    } label: {
                        IntervalAnalysisCompactRow(
                            row: row,
                            evaluation: WorkTargetEvaluator.evaluate(interval: interval),
                            showsBackground: false
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    IntervalAnalysisCompactRow(row: row, showsBackground: false)
                }
            }
        }
        .padding(10)
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var repeatCount: Int {
        result.intervals.filter { $0.stepType == .work }.count
    }
}

private struct IntervalAnalysisCompactRow: View {
    let row: IntervalAnalysisRow
    var evaluation: WorkTargetEvaluation? = nil
    var showsBackground = true

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            VStack(alignment: .leading, spacing: 3) {
                Text(row.label)
                    .font(.subheadline.bold())
                    .foregroundStyle(intervalRoleTint(for: row))
                Text(row.plannedGoalDisplayText)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 3) {
                if let evaluation,
                   evaluation.result != .noTarget || evaluation.exactTargetSecondsPerKilometer != nil {
                    WorkTargetBadge(evaluation: evaluation)
                }
                Text(displayDistance)
                    .font(.subheadline.monospacedDigit().bold())
                Text(RunFormatters.pace(row.paceSecondsPerKm))
                    .font(.caption2.monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(showsBackground ? 10 : 4)
        .background(showsBackground ? AnyShapeStyle(.background) : AnyShapeStyle(.clear))
        .clipShape(RoundedRectangle(cornerRadius: showsBackground ? 8 : 0))
    }

    private var displayDistance: String {
        if row.plannedGoalType == .distance {
            return RunFormatters.compactDistance(row.plannedGoalValue)
        }
        return RunFormatters.compactDistance(row.distanceMeters)
    }
}

private func intervalRoleTint(for row: IntervalAnalysisRow) -> Color {
    intervalRoleTint(for: row.stepType)
}

private func intervalRoleTint(for stepType: DerivedIntervalLabel) -> Color {
    switch stepType {
    case .warmup: .blue
    case .work: .cyan
    case .recovery: .yellow
    case .cooldown: .teal
    case .open: .orange
    case .unknown: .secondary
    }
}

private func intervalMetricTint(_ metric: IntervalAnalysisMetric) -> Color {
    switch metric {
    case .pace: .blue
    case .heartRate: .red
    case .power: .purple
    case .cadence: .pink
    case .duration: .yellow
    case .distance: .cyan
    }
}

struct IntervalDetailView: View {
    let workout: CanonicalWorkout
    let interval: ReconstructedWorkoutInterval

    private var routeSegment: [WorkoutRoutePoint] {
        workout.evidence?.route.filter {
            $0.date >= interval.actualStartDate && $0.date <= interval.actualEndDate
        } ?? []
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(
                    title: "\(interval.index). \(interval.label)",
                    subtitle: "Metrics for this completed interval."
                )

                if routeSegment.count >= 2 {
                    WorkoutRouteMap(route: routeSegment)
                }

                MetricGrid(items: intervalMetricItems)

                if let evaluation = WorkTargetEvaluator.evaluate(interval: interval),
                   evaluation.result != .noTarget || evaluation.exactTargetSecondsPerKilometer != nil {
                    VStack(alignment: .leading, spacing: 10) {
                        SectionHeader("Pace Target")
                        WorkTargetDetailGrid(evaluation: evaluation)
                    }
                }

                if let pausedTimingDetail = IntervalRowTimingText.pausedTimingDetail(for: interval) {
                    NoticeCard(
                        title: "Pause-aware timing",
                        message: pausedTimingDetail,
                        systemImage: "pause.circle",
                        tint: .blue
                    )
                }

                SectionHeader("Interval Charts")
                WorkoutChartDeck(workout: workout, interval: interval)
            }
            .padding()
            .padding(.bottom, 160)
        }
        .navigationTitle("Interval")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
        }
    }

    private var intervalMetricItems: [MetricItem] {
        let detailBasis = interval.windowSource == .healthKitActivityBoundaries ? "Activity row" : "Window"
        var items = IntervalGoalMeasuredText.metricItems(for: interval) + [
            MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: detailBasis),
            MetricItem(title: "Cadence", value: RunFormatters.number(interval.averageCadence, suffix: " spm"), detail: detailBasis),
            MetricItem(title: "Power", value: RunFormatters.number(interval.averagePower, suffix: " W"), detail: detailBasis)
        ]
        if let pausedTimingItems = IntervalRowTimingText.pausedTimingItems(for: interval) {
            items.append(contentsOf: pausedTimingItems)
        }
        return items
    }
}

private struct WorkTargetBadge: View {
    let evaluation: WorkTargetEvaluation

    var body: some View {
        Label(WorkTargetPresentation.badgeLabel(for: evaluation), systemImage: symbol)
            .font(.caption2.bold())
            .foregroundStyle(tint)
            .labelStyle(.titleAndIcon)
            .accessibilityLabel(accessibilityText)
    }

    private var symbol: String {
        evaluation.exactTargetSecondsPerKilometer == nil ? evaluation.result.symbol : "arrow.left.and.right"
    }

    private var tint: Color {
        if evaluation.completionStatus == .shortened { return .orange }
        return evaluation.exactTargetSecondsPerKilometer == nil ? evaluation.result.tint : .blue
    }

    private var accessibilityText: String {
        if let comparison = WorkTargetPresentation.exactTargetDeltaText(evaluation) {
            return "Exact pace target comparison: \(comparison), completion \(evaluation.completionStatus.runnerLabel)"
        }
        return "Pace result \(evaluation.result.runnerLabel), completion \(evaluation.completionStatus.runnerLabel)"
    }
}

private struct WorkTargetDetailGrid: View {
    let evaluation: WorkTargetEvaluation

    var body: some View {
        MetricGrid(items: [
            MetricItem(title: "Target", value: targetText, detail: targetDetail),
            MetricItem(title: "Actual", value: RunFormatters.pace(evaluation.measurement.paceSecondsPerKilometer), detail: evaluation.measurement.basis.runnerLabel),
            MetricItem(title: resultTitle, value: resultText, detail: deltaText),
            MetricItem(title: "Completion", value: evaluation.completionStatus.runnerLabel, detail: "Separate from pace")
        ])
    }

    private var targetDetail: String {
        evaluation.exactTargetSecondsPerKilometer == nil ? "Planned range" : "Exact WorkoutKit target"
    }

    private var resultTitle: String {
        evaluation.exactTargetSecondsPerKilometer == nil ? "Result" : "Difference"
    }

    private var resultText: String {
        WorkTargetPresentation.exactTargetDeltaText(evaluation) ?? evaluation.result.runnerLabel
    }

    private var targetText: String {
        if let exact = evaluation.exactTargetSecondsPerKilometer {
            return RunFormatters.pace(exact)
        }
        guard let range = evaluation.targetRange else { return "Unavailable" }
        return "\(RunFormatters.pace(range.fastestSecondsPerKilometer))–\(RunFormatters.pace(range.slowestSecondsPerKilometer))"
    }

    private var deltaText: String {
        if WorkTargetPresentation.exactTargetDeltaText(evaluation) != nil {
            return "Exact target comparison; no tolerance range"
        }
        guard let pace = evaluation.measurement.paceSecondsPerKilometer,
              let range = evaluation.targetRange else { return "No comparison" }
        if range.contains(pace) { return "Inside target" }
        let edge = pace < range.fastestSecondsPerKilometer
            ? range.fastestSecondsPerKilometer
            : range.slowestSecondsPerKilometer
        let delta = Int(abs(pace - edge).rounded())
        return "\(delta)s/km \(pace < edge ? "faster" : "slower")"
    }
}

private func workTargetSummaryText(_ evaluations: [WorkTargetEvaluation]) -> String {
    WorkTargetPresentation.summaryText(evaluations)
}

private extension WorkTargetResult {
    var runnerLabel: String {
        WorkTargetPresentation.resultLabel(self)
    }

    var symbol: String {
        switch self {
        case .onTarget: "checkmark.circle.fill"
        case .fast: "arrow.up.circle.fill"
        case .slow: "arrow.down.circle.fill"
        case .noTarget: "minus.circle"
        }
    }

    var tint: Color {
        switch self {
        case .onTarget: .green
        case .fast: .orange
        case .slow: .red
        case .noTarget: .secondary
        }
    }
}

private extension WorkCompletionStatus {
    var runnerLabel: String {
        WorkTargetPresentation.completionLabel(self)
    }
}

private extension WorkPaceMeasurementBasis {
    var runnerLabel: String {
        switch self {
        case .completedGoalWindow: "Goal window"
        case .completedPlannedDistance: "Active timer"
        case .shortenedMeasured: "Measured shortened rep"
        case .measured: "Measured"
        case .unavailable: "Unavailable"
        }
    }
}
