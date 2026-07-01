import Charts
import MapKit
import SwiftUI

struct AnalyticsView: View {
    var store: RunningAnalysisStore

    @State private var selectedPeriod = TrainingAnalyticsPeriod.week
    @State private var selectedWeekStart: Date?

    private var weekStarts: [Date] {
        WeeklyAnalyticsSummary.availableWeekStarts(workouts: store.workouts)
    }

    private var activeWeekStart: Date {
        selectedWeekStart ?? weekStarts.first ?? WeeklyAnalyticsSummary.weekStart(containing: Date())
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

                switch selectedPeriod {
                case .week:
                    WeekSignalView(
                        store: store,
                        summary: WeeklyAnalyticsSummary.make(workouts: store.workouts, weekStart: activeWeekStart),
                        weekStarts: weekStarts,
                        selectedWeekStart: $selectedWeekStart
                    )
                case .month:
                    FutureAnalyticsPeriodView(title: "Month Signal", message: "Monthly totals and calendar-style training blocks will build on the weekly analytics layer.")
                case .year:
                    FutureAnalyticsPeriodView(title: "Year Signal", message: "Yearly distance, run count, and category trends are planned after the weekly view is stable.")
                case .allTime:
                    FutureAnalyticsPeriodView(title: "All-Time Signal", message: "All-time totals and best-effort context will stay HealthKit-only and evidence-scored.")
                }
            }
            .padding()
            .padding(.bottom, 180)
        }
        .navigationTitle("Analytics")
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 72)
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
                            .foregroundStyle(.secondary)
                        Text("\(total.runCount)")
                            .font(.title3.monospacedDigit().bold())
                        Text(RunFormatters.distance(total.distanceMeters))
                            .font(.caption2)
                            .foregroundStyle(.tertiary)
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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("Runs This Week")
            VStack(spacing: 8) {
                ForEach(rows) { row in
                    NavigationLink {
                        WorkoutDetailView(store: store, workoutID: row.workout.id)
                    } label: {
                        HStack(spacing: 10) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text(RunWorkout(workout: row.workout).displayName)
                                    .font(.subheadline.bold())
                                Text("\(row.category.label) · \(RunFormatters.shortDate.string(from: row.workout.startDate))")
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            VStack(alignment: .trailing, spacing: 4) {
                                Text(RunFormatters.distance(row.workout.distanceMeters))
                                    .font(.subheadline.monospacedDigit().bold())
                                Text(RunFormatters.pace(row.workout.paceSecondsPerKm))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(10)
                        .background(.background)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .buttonStyle(.plain)
                }
            }
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

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(series) { item in
                WorkoutChartCard(series: item)
            }
        }
    }
}

private struct WorkoutChartCard: View {
    let series: WorkoutChartSeries

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(series.metric.title)
                    .font(.subheadline.bold())
                Spacer()
                Text(series.metric.unit)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if series.isRenderable {
                Chart(series.points) { point in
                    LineMark(
                        x: .value("Time", point.offsetSeconds / 60),
                        y: .value(series.metric.title, point.value)
                    )
                    .interpolationMethod(.catmullRom)
                    .foregroundStyle(.blue)
                }
                .frame(height: 145)
                .chartXAxisLabel("min")
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
}

struct IntervalAnalysisDeck: View {
    let summary: IntervalAnalysisSummary

    @State private var selectedIntervalIndex: Int?

    private var selectedRow: IntervalAnalysisRow? {
        guard let selectedIntervalIndex else { return nil }
        return summary.rows.first { $0.index == selectedIntervalIndex }
    }

    private var visibleMetrics: [IntervalAnalysisMetric] {
        summary.availableMetrics
    }

    var body: some View {
        if !summary.rows.isEmpty, !visibleMetrics.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader("Interval Analysis")

                IntervalAnalysisFocusStrip(
                    summary: summary,
                    selectedRow: selectedRow,
                    metrics: visibleMetrics
                )

                ForEach(visibleMetrics) { metric in
                    IntervalMetricChartCard(
                        summary: summary,
                        metric: metric,
                        selectedIntervalIndex: $selectedIntervalIndex
                    )
                }
            }
        }
    }
}

private struct IntervalAnalysisFocusStrip: View {
    let summary: IntervalAnalysisSummary
    let selectedRow: IntervalAnalysisRow?
    let metrics: [IntervalAnalysisMetric]

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
                Text(sourceBadge)
                    .font(.caption2.bold())
                    .foregroundStyle(.blue)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(.blue.opacity(0.12))
                    .clipShape(Capsule())
            }

            if let selectedRow, let pauseOverlap = selectedRow.pauseOverlapSeconds, pauseOverlap > 0 {
                MetricGrid(items: [
                    MetricItem(title: "Elapsed", value: RunFormatters.duration(selectedRow.elapsedDurationSeconds), detail: "Row window"),
                    MetricItem(title: "Pause", value: RunFormatters.duration(pauseOverlap), detail: "Paired overlap"),
                    MetricItem(title: "Active", value: RunFormatters.duration(selectedRow.activeDurationSeconds), detail: "Timer duration")
                ])
            }

            MetricGrid(items: metricItems)
        }
        .padding(10)
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

    private var sourceBadge: String {
        selectedRow == nil ? "Average" : "Selected"
    }

    private var metricItems: [MetricItem] {
        metrics.prefix(6).compactMap { metric in
            if let selectedRow, let value = selectedRow.value(for: metric) {
                return MetricItem(
                    title: metric.title,
                    value: IntervalMetricFormatter.value(value.displayValue, metric: metric),
                    detail: metric == .pace ? selectedRow.displayBasisLabel : selectedRow.roleAbbreviation
                )
            }
            guard let aggregate = summary.aggregateValue(for: metric) else { return nil }
            return MetricItem(
                title: metric.title,
                value: IntervalMetricFormatter.value(aggregate.displayValue, metric: metric),
                detail: summary.aggregateCaption(for: metric)
            )
        }
    }
}

private struct IntervalMetricChartCard: View {
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

    private var headlineDetail: String {
        if let selectedRow {
            return "\(selectedRow.index) \(selectedRow.roleAbbreviation)"
        }
        return summary.aggregateCaption(for: metric)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                Text(metric.title)
                    .font(.subheadline.bold())
                Spacer()
                VStack(alignment: .trailing, spacing: 2) {
                    Text(IntervalMetricFormatter.value(headlineValue?.displayValue, metric: metric))
                        .font(.title3.monospacedDigit().bold())
                        .foregroundStyle(metricTint(metric))
                    Text(headlineDetail)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
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
                            width: .ratio(0.65)
                        )
                        .foregroundStyle(barTint(for: row))
                        .cornerRadius(3)
                    }
                }

                if let selectedIntervalIndex,
                   summary.rows.contains(where: { $0.index == selectedIntervalIndex }) {
                    RuleMark(x: .value("Selected", selectedIntervalIndex))
                        .foregroundStyle(.primary.opacity(0.45))
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                }
            }
            .frame(height: 170)
            .chartXAxis {
                AxisMarks(values: summary.rows.map(\.index)) { value in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel {
                        if let index = value.as(Int.self),
                           let row = summary.rows.first(where: { $0.index == index }) {
                            VStack(spacing: 0) {
                                Text("\(index)")
                                Text(row.roleAbbreviation)
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
        .padding()
        .background(.background)
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private func barTint(for row: IntervalAnalysisRow) -> Color {
        guard let selectedIntervalIndex else {
            return roleTint(for: row)
        }
        return row.index == selectedIntervalIndex ? metricTint(metric) : roleTint(for: row).opacity(0.35)
    }

    private func roleTint(for row: IntervalAnalysisRow) -> Color {
        switch row.stepType {
        case .warmup: .blue
        case .work: .cyan
        case .recovery: .yellow
        case .cooldown: .teal
        case .open: .orange
        case .unknown: .secondary
        }
    }

    private func metricTint(_ metric: IntervalAnalysisMetric) -> Color {
        switch metric {
        case .pace: .blue
        case .heartRate: .red
        case .power: .purple
        case .cadence: .pink
        case .duration: .yellow
        case .distance: .cyan
        }
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
