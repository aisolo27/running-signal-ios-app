import Charts
import MapKit
import SwiftUI

struct AnalyticsView: View {
    var store: RunningAnalysisStore

    @State private var selectedPeriod = TrainingAnalyticsPeriod.week
    @State private var selectedPeriodStart: Date?

    private var periodStarts: [Date] {
        TrainingPeriodAnalyticsSummary.availablePeriodStarts(workouts: store.workouts, period: selectedPeriod)
    }

    private var activePeriodStart: Date {
        guard selectedPeriod != .allTime else {
            return TrainingPeriodAnalyticsSummary.make(workouts: store.workouts, period: .allTime).periodStart
        }
        if let selectedPeriodStart, periodStarts.contains(selectedPeriodStart) {
            return selectedPeriodStart
        }
        return periodStarts.first ?? TrainingPeriodAnalyticsSummary.make(workouts: store.workouts, period: selectedPeriod).periodStart
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                Text("Evidence-first training signals from loaded HealthKit runs.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)

                Picker("Period", selection: $selectedPeriod) {
                    ForEach(TrainingAnalyticsPeriod.allCases) { period in
                        Text(period.label).tag(period)
                    }
                }
                .pickerStyle(.segmented)

                PeriodSignalView(
                    store: store,
                    summary: TrainingPeriodAnalyticsSummary.make(
                        workouts: store.workouts,
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
                    title: periodTitle,
                    signalTitle: signalTitle,
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
                MetricItem(title: "Evidence", value: evidenceStatus, detail: evidenceDetail)
            ])

            PeriodComparisonPanel(summary: summary)

            if summary.runCount == 0 {
                EmptyStateView(title: emptyTitle, message: "Choose an older \(summary.period.label.lowercased()) or load runs from Settings.")
            } else {
                PeriodDistanceChart(summary: summary)
                WeeklyCategoryTotalsView(totals: summary.categoryTotals)
                WeeklyWorkoutList(store: store, rows: summary.workouts, title: workoutListTitle)
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
        case .allTime: "Loaded Runs"
        }
    }

    private var distanceDetail: String {
        guard summary.isPeriodToDate else { return "Total" }
        return "To date"
    }

    private var evidenceStatus: String {
        let seriesRuns = summary.workouts.filter { $0.workout.seriesAvailable || $0.workout.seriesSampleCount > 0 }.count
        guard summary.runCount > 0 else { return "Empty" }
        return seriesRuns == summary.runCount ? "Ready" : "\(seriesRuns)/\(summary.runCount)"
    }

    private var evidenceDetail: String {
        summary.runCount == 0 ? "No period data" : "Runs with series evidence"
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
    let title: String
    let signalTitle: String
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

private struct PeriodComparisonPanel: View {
    let summary: TrainingPeriodAnalyticsSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Comparable Basis")

            if let comparison = summary.comparison {
                MetricGrid(items: [
                    MetricItem(title: "Distance change", value: signedDistance(summary.distanceDeltaMeters), detail: summary.comparisonScopeLabel),
                    MetricItem(title: "Run change", value: signedInt(summary.runCountDelta), detail: "Same day count"),
                    MetricItem(title: "Previous distance", value: RunFormatters.distance(comparison.totalDistanceMeters), detail: "\(comparison.runCount) runs"),
                    MetricItem(title: "Previous pace", value: RunFormatters.pace(comparison.averagePaceSecondsPerKm), detail: "Distance/time")
                ])
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
}

private struct PeriodDistanceChart: View {
    let summary: TrainingPeriodAnalyticsSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(chartTitle)
            Chart(summary.distanceBuckets) { bucket in
                BarMark(
                    x: .value("Period", bucket.label),
                    y: .value("Distance", bucket.distanceMeters / 1_000)
                )
                .foregroundStyle(bucket.distanceMeters > 0 ? .blue : .secondary.opacity(0.25))
                .cornerRadius(4)
            }
            .frame(height: 150)
            .chartYAxisLabel("km")
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

            VStack(spacing: 8) {
                ForEach(rows) { row in
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

                            categoryMenu {
                                update(row: row, category: $0)
                            }
                        }
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
                Text(RunWorkout(workout: row.workout).displayName)
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
            return .recovery
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

    @State private var selectedMinute: Double?

    private var series: [WorkoutChartSeries] {
        let core = WorkoutChartSeriesBuilder.coreSeries(for: workout)
        guard let interval else { return core }
        return core.map {
            WorkoutChartSeriesBuilder.clippedSeries(
                $0,
                start: interval.actualStartDate,
                end: interval.actualEndDate
            )
        }
    }

    private var officialIntervals: [ReconstructedWorkoutInterval] {
        guard interval == nil,
              let evidence = workout.evidence,
              let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) else {
            return []
        }
        return result.intervals
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(series) { item in
                WorkoutChartCard(series: item, intervalMarkers: officialIntervals.chartMarkers(workoutStart: workout.startDate), selectedMinute: $selectedMinute)
            }
        }
    }
}

private struct WorkoutChartCard: View {
    let series: WorkoutChartSeries
    let intervalMarkers: [WorkoutChartIntervalMarker]
    @Binding var selectedMinute: Double?

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
                Text(series.metric.unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if series.isRenderable {
                Chart {
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
                        .interpolationMethod(.catmullRom)
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
                .chartXSelection(value: $selectedMinute)
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

private struct WorkoutChartIntervalMarker: Identifiable {
    let id: String
    let offsetMinutes: Double
    let tint: Color
}

private extension Array where Element == ReconstructedWorkoutInterval {
    func chartMarkers(workoutStart: Date) -> [WorkoutChartIntervalMarker] {
        var seen: Set<Int> = []
        return flatMap { interval in
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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Official interval analysis")
                        .font(.subheadline.bold())
                    Text("\(summary.planSource.label) · \(summary.windowSource.label)")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Label("Official", systemImage: "checkmark.seal")
                    .font(.caption2.bold())
                    .foregroundStyle(.blue)
                    .labelStyle(.titleAndIcon)
            }

            MetricGrid(items: entryItems)

            NavigationLink {
                IntervalAnalysisScreen(workout: workout, result: result)
            } label: {
                Label("Open Interval Analysis", systemImage: "chart.bar.xaxis")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var entryItems: [MetricItem] {
        return [
            MetricItem(title: "Rows", value: "\(summary.rows.count)", detail: "Official"),
            MetricItem(title: "Distance", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .distance)?.displayValue, metric: .distance), detail: "Total"),
            MetricItem(title: "Time", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .duration)?.displayValue, metric: .duration), detail: "Total"),
            MetricItem(title: "Pace", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .pace)?.displayValue, metric: .pace), detail: "Aggregate")
        ]
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
        summary.availableMetrics
    }

    private var selectedRow: IntervalAnalysisRow? {
        guard let selectedIntervalIndex else { return nil }
        return summary.rows.first { $0.index == selectedIntervalIndex }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 14) {
                HeaderBlock(
                    title: "Interval Analysis",
                    subtitle: "Official custom workout rows from resolved HealthKit activity-boundary evidence."
                )

                IntervalExecutionSummaryPanel(summary: IntervalExecutionUXSummary.make(summary: summary))

                IntervalOverviewPanel(summary: summary)

                if summary.workRepeatSummary != nil {
                    IntervalWorkTotalsPanel(summary: summary)
                }

                VStack(alignment: .leading, spacing: 12) {
                    HStack(alignment: .center) {
                        Text(selectedMetric.title)
                            .font(.headline)
                        Spacer()
                        IntervalMetricMenu(
                            metrics: availableMetrics,
                            selectedMetric: $selectedMetric
                        )
                    }

                    IntervalPrimaryScrubChart(
                        summary: summary,
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
                    selectedRow: selectedRow
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
           summary.rows.contains(where: { $0.index == selectedIntervalIndex }) {
            return
        }
        selectedIntervalIndex = summary.rows.first?.index
    }
}

private struct IntervalExecutionSummaryPanel: View {
    let summary: IntervalExecutionUXSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "target")
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

private struct IntervalOverviewPanel: View {
    let summary: IntervalAnalysisSummary

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 3) {
                    Text("Whole interval breakdown")
                        .font(.subheadline.bold())
                    Text("\(summary.planSource.label) · \(summary.windowSource.label)")
                        .font(.caption2)
                        .foregroundStyle(.primary)
                }
                Spacer()
                Text("\(summary.rows.count) rows")
                    .font(.caption2.bold())
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.12))
                    .clipShape(Capsule())
            }

            MetricGrid(items: [
                MetricItem(title: "Rows", value: "\(summary.rows.count)", detail: "Warmup/work/recovery"),
                MetricItem(title: "Distance", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .distance)?.displayValue, metric: .distance), detail: "All official rows"),
                MetricItem(title: "Duration", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .duration)?.displayValue, metric: .duration), detail: "Display basis"),
                MetricItem(title: "Pace", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .pace)?.displayValue, metric: .pace), detail: "Aggregate")
            ])
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

private struct IntervalWorkTotalsPanel: View {
    let summary: IntervalAnalysisSummary

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
                Text(summary.repeatGroups.isEmpty ? "Rows" : "\(summary.repeatGroups.count)x")
                    .font(.caption2.bold())
                    .foregroundStyle(.cyan)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.cyan.opacity(0.12))
                    .clipShape(Capsule())
            }

            MetricGrid(items: metricItems)
        }
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var title: String {
        summary.workRepeatSummary == nil ? "Official rows" : "Work repeats"
    }

    private var subtitle: String {
        "\(summary.planSource.label) · \(summary.windowSource.label)"
    }

    private var metricItems: [MetricItem] {
        guard let workSummary = summary.workRepeatSummary else {
            return [
                MetricItem(title: "Rows", value: "\(summary.rows.count)", detail: "Official"),
                MetricItem(title: "Distance", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .distance)?.displayValue, metric: .distance), detail: "Total"),
                MetricItem(title: "Duration", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .duration)?.displayValue, metric: .duration), detail: "Total"),
                MetricItem(title: "Pace", value: IntervalMetricFormatter.value(summary.aggregateValue(for: .pace)?.displayValue, metric: .pace), detail: "Aggregate")
            ]
        }

        return [
            MetricItem(title: "Repeats", value: "\(workSummary.repeatCount)", detail: "Work rows"),
            MetricItem(title: "Distance", value: RunFormatters.compactDistance(workSummary.totalDistanceMeters), detail: "Work total"),
            MetricItem(title: "Active time", value: RunFormatters.duration(workSummary.totalActiveDurationSeconds), detail: "Display basis"),
            MetricItem(title: "Pace", value: RunFormatters.pace(workSummary.aggregatePaceSecondsPerKm), detail: "Aggregate")
        ]
    }
}

private struct IntervalMetricMenu: View {
    let metrics: [IntervalAnalysisMetric]
    @Binding var selectedMetric: IntervalAnalysisMetric

    var body: some View {
        Menu {
            ForEach(metrics) { metric in
                Button(metric.title) {
                    selectedMetric = metric
                }
            }
        } label: {
            Label(selectedMetric.title, systemImage: "slider.horizontal.3")
                .font(.caption.bold())
        }
    }
}

private struct IntervalPrimaryScrubChart: View {
    let summary: IntervalAnalysisSummary
    let metric: IntervalAnalysisMetric
    @Binding var selectedIntervalIndex: Int?

    private var selectedRow: IntervalAnalysisRow? {
        guard let selectedIntervalIndex else { return nil }
        return summary.rows.first { $0.index == selectedIntervalIndex }
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
                Text(selectedRow.map { "\($0.index) \($0.roleAbbreviation)" } ?? summary.aggregateCaption(for: metric))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
            }

            Chart {
                if let aggregate = summary.aggregateValue(for: metric) {
                    RuleMark(y: .value("Average", aggregate.chartValue))
                        .foregroundStyle(.secondary.opacity(0.6))
                        .lineStyle(StrokeStyle(lineWidth: 1, dash: [4, 3]))
                }

                ForEach(summary.rows) { row in
                    if let value = row.value(for: metric) {
                        BarMark(
                            x: .value("Interval", row.index),
                            y: .value(metric.title, value.chartValue),
                            width: .ratio(0.62)
                        )
                        .foregroundStyle(barTint(for: row))
                        .cornerRadius(4)
                    }
                }

                if let selectedIntervalIndex,
                   summary.rows.contains(where: { $0.index == selectedIntervalIndex }) {
                    RuleMark(x: .value("Selected", selectedIntervalIndex))
                        .foregroundStyle(.primary.opacity(0.5))
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                }
            }
            .frame(height: 260)
            .chartXAxis {
                AxisMarks(values: summary.rows.map(\.index)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let index = value.as(Int.self),
                           let row = summary.rows.first(where: { $0.index == index }) {
                            VStack(spacing: 1) {
                                Text("\(index)")
                                Text(row.roleAbbreviation)
                                    .foregroundStyle(intervalRoleTint(for: row))
                            }
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
            .chartXSelection(value: $selectedIntervalIndex)
            .accessibilityLabel("\(metric.title) by official interval row")
        }
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
        return "\(summary.planSource.label) · \(summary.windowSource.label)"
    }

    private var metricItems: [MetricItem] {
        if let selectedRow {
            return [
                MetricItem(title: metric.title, value: IntervalMetricFormatter.value(selectedRow.value(for: metric)?.displayValue, metric: metric), detail: selectedRow.roleAbbreviation),
                MetricItem(title: "Distance", value: RunFormatters.compactDistance(selectedRow.distanceMeters), detail: selectedRow.plannedGoalDisplayText),
                MetricItem(title: "Duration", value: RunFormatters.duration(selectedRow.displayDurationSeconds), detail: selectedRow.displayBasisLabel),
                MetricItem(title: "Pace", value: RunFormatters.pace(selectedRow.paceSecondsPerKm), detail: selectedRow.displayBasisLabel)
            ]
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
            SectionHeader(summary.repeatGroups.isEmpty ? "Official Rows" : "Repeat Rows")

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
                        Text("Repeat")
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
                IntervalAnalysisCompactRow(row: row)
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
                        IntervalAnalysisCompactRow(row: row, showsBackground: false)
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
                Text(RunFormatters.compactDistance(row.distanceMeters))
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
                    subtitle: "Official interval row from resolved HealthKit activity-boundary evidence."
                )

                if routeSegment.count >= 2 {
                    WorkoutRouteMap(route: routeSegment)
                }

                MetricGrid(items: intervalMetricItems)

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
        var items = [
            MetricItem(title: "Duration", value: RunFormatters.duration(interval.displayDurationSeconds), detail: interval.durationDisplayRule == .activeTimer ? "Active timer" : "Elapsed window"),
            MetricItem(title: "Distance", value: RunFormatters.compactDistance(interval.actualDistanceMeters), detail: interval.plannedGoalDisplayText),
            MetricItem(title: "Pace", value: RunFormatters.pace(IntervalRowTimingText.displayPaceSecondsPerKm(for: interval)), detail: IntervalRowTimingText.displayPaceDetail(for: interval)),
            MetricItem(title: "Avg HR", value: RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"), detail: "Window"),
            MetricItem(title: "Power", value: RunFormatters.number(interval.averagePower, suffix: " W"), detail: "Avg"),
            MetricItem(title: "Cadence", value: RunFormatters.number(interval.averageCadence, suffix: " spm"), detail: "Avg")
        ]
        if let pausedTimingItems = IntervalRowTimingText.pausedTimingItems(for: interval) {
            items.append(contentsOf: pausedTimingItems)
        }
        return items
    }
}
