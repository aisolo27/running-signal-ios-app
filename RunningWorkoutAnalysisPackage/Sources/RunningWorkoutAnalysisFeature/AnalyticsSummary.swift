import Foundation

public enum TrainingAnalyticsPeriod: String, CaseIterable, Identifiable, Sendable {
    case week
    case month
    case year
    case allTime

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        case .allTime: "All-Time"
        }
    }
}

public enum WeeklyRunCategory: String, CaseIterable, Identifiable, Sendable {
    case easy
    case interval
    case threshold
    case longRun
    case warmupCooldown
    case race
    case other

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .easy: "Easy"
        case .interval: "Interval"
        case .threshold: "Threshold"
        case .longRun: "Long Run"
        case .warmupCooldown: "Warm-up/Cool-down"
        case .race: "Race"
        case .other: "Other"
        }
    }

    static func make(from workout: CanonicalWorkout) -> WeeklyRunCategory {
        switch workout.effectiveRunType {
        case .easy:
            return .easy
        case .interval:
            return .interval
        case .threshold, .tempo:
            return .threshold
        case .longRun:
            return .longRun
        case .recovery:
            return .warmupCooldown
        case .race:
            return .race
        case .progression, .hills, .unknown:
            return .other
        }
    }
}

public struct WeeklyRunCategoryTotal: Identifiable, Equatable, Sendable {
    public var id: WeeklyRunCategory { category }
    public var category: WeeklyRunCategory
    public var runCount: Int
    public var distanceMeters: Double
}

public struct WeeklyDailyDistance: Identifiable, Equatable, Sendable {
    public var id: Date { date }
    public var date: Date
    public var distanceMeters: Double
}

public struct WeeklyWorkoutRow: Identifiable, Equatable, Sendable {
    public var id: String { workout.id }
    public var workout: CanonicalWorkout
    public var category: WeeklyRunCategory
}

public struct WeeklyAnalyticsSummary: Equatable, Sendable {
    public var weekStart: Date
    public var weekEnd: Date
    public var workouts: [WeeklyWorkoutRow]
    public var dailyDistances: [WeeklyDailyDistance]
    public var categoryTotals: [WeeklyRunCategoryTotal]
    public var totalDistanceMeters: Double
    public var totalDurationSeconds: Double

    public var runCount: Int { workouts.count }

    public var averagePaceSecondsPerKm: Double? {
        PaceMath.paceSecondsPerKm(
            distanceMeters: totalDistanceMeters > 0 ? totalDistanceMeters : nil,
            durationSeconds: totalDurationSeconds
        )
    }

    public static func make(
        workouts allWorkouts: [CanonicalWorkout],
        containing date: Date = Date(),
        calendar: Calendar = mondayCalendar
    ) -> WeeklyAnalyticsSummary {
        let start = weekStart(containing: date, calendar: calendar)
        return make(workouts: allWorkouts, weekStart: start, calendar: calendar)
    }

    public static func make(
        workouts allWorkouts: [CanonicalWorkout],
        weekStart start: Date,
        calendar: Calendar = mondayCalendar
    ) -> WeeklyAnalyticsSummary {
        let end = calendar.date(byAdding: .day, value: 7, to: start) ?? start.addingTimeInterval(7 * 86_400)
        let included = V1WorkoutFilters.completedRuns(from: allWorkouts)
            .filter { $0.startDate >= start && $0.startDate < end }
            .sorted { $0.startDate > $1.startDate }
        let rows = included.map { WeeklyWorkoutRow(workout: $0, category: WeeklyRunCategory.make(from: $0)) }
        let totalDistance = included.compactMap(\.distanceMeters).reduce(0, +)
        let totalDuration = included.reduce(0) { partial, workout in
            guard let distance = workout.distanceMeters, distance > 0 else { return partial }
            return partial + workout.durationSeconds
        }

        let daily = (0..<7).map { offset in
            let day = calendar.date(byAdding: .day, value: offset, to: start) ?? start.addingTimeInterval(Double(offset) * 86_400)
            let dayEnd = calendar.date(byAdding: .day, value: 1, to: day) ?? day.addingTimeInterval(86_400)
            let distance = included
                .filter { $0.startDate >= day && $0.startDate < dayEnd }
                .compactMap(\.distanceMeters)
                .reduce(0, +)
            return WeeklyDailyDistance(date: day, distanceMeters: distance)
        }

        let categoryTotals = WeeklyRunCategory.allCases.map { category in
            let categoryRows = rows.filter { $0.category == category }
            return WeeklyRunCategoryTotal(
                category: category,
                runCount: categoryRows.count,
                distanceMeters: categoryRows.compactMap(\.workout.distanceMeters).reduce(0, +)
            )
        }

        return WeeklyAnalyticsSummary(
            weekStart: start,
            weekEnd: end,
            workouts: rows,
            dailyDistances: daily,
            categoryTotals: categoryTotals,
            totalDistanceMeters: totalDistance,
            totalDurationSeconds: totalDuration
        )
    }

    public static func availableWeekStarts(
        workouts: [CanonicalWorkout],
        now: Date = Date(),
        calendar: Calendar = mondayCalendar
    ) -> [Date] {
        let completed = V1WorkoutFilters.completedRuns(from: workouts)
        let starts = Set(completed.map { weekStart(containing: $0.startDate, calendar: calendar) })
        let current = weekStart(containing: now, calendar: calendar)
        return Array(starts.union([current])).sorted(by: >)
    }

    public static func weekStart(containing date: Date, calendar: Calendar = mondayCalendar) -> Date {
        let startOfDay = calendar.startOfDay(for: date)
        let weekday = calendar.component(.weekday, from: startOfDay)
        let daysFromMonday = (weekday + 5) % 7
        return calendar.date(byAdding: .day, value: -daysFromMonday, to: startOfDay) ?? startOfDay
    }

    public static var mondayCalendar: Calendar {
        var calendar = Calendar(identifier: .gregorian)
        calendar.firstWeekday = 2
        calendar.minimumDaysInFirstWeek = 4
        return calendar
    }
}

public struct TrainingPeriodDistanceBucket: Identifiable, Equatable, Sendable {
    public var id: Date { startDate }
    public var startDate: Date
    public var endDate: Date
    public var label: String
    public var distanceMeters: Double
}

public struct TrainingPeriodComparison: Equatable, Sendable {
    public var startDate: Date
    public var endDate: Date
    public var elapsedDayCount: Int
    public var runCount: Int
    public var totalDistanceMeters: Double
    public var totalDurationSeconds: Double

    public var averagePaceSecondsPerKm: Double? {
        PaceMath.paceSecondsPerKm(
            distanceMeters: totalDistanceMeters > 0 ? totalDistanceMeters : nil,
            durationSeconds: totalDurationSeconds
        )
    }
}

public struct TrainingPeriodAnalyticsSummary: Equatable, Sendable {
    public var period: TrainingAnalyticsPeriod
    public var periodStart: Date
    public var periodEnd: Date
    public var analysisEnd: Date
    public var elapsedDayCount: Int
    public var isPeriodToDate: Bool
    public var workouts: [WeeklyWorkoutRow]
    public var distanceBuckets: [TrainingPeriodDistanceBucket]
    public var categoryTotals: [WeeklyRunCategoryTotal]
    public var totalDistanceMeters: Double
    public var totalDurationSeconds: Double
    public var comparison: TrainingPeriodComparison?

    public var runCount: Int { workouts.count }

    public var averagePaceSecondsPerKm: Double? {
        PaceMath.paceSecondsPerKm(
            distanceMeters: totalDistanceMeters > 0 ? totalDistanceMeters : nil,
            durationSeconds: totalDurationSeconds
        )
    }

    public var distanceDeltaMeters: Double? {
        comparison.map { totalDistanceMeters - $0.totalDistanceMeters }
    }

    public var runCountDelta: Int? {
        comparison.map { runCount - $0.runCount }
    }

    public var comparisonScopeLabel: String {
        guard let comparison else { return "No previous period" }
        let basis = isPeriodToDate ? "first \(comparison.elapsedDayCount) day\(comparison.elapsedDayCount == 1 ? "" : "s")" : "full period"
        return "vs previous \(period.comparisonNoun) \(basis)"
    }

    public static func make(
        workouts allWorkouts: [CanonicalWorkout],
        period: TrainingAnalyticsPeriod,
        containing date: Date = Date(),
        now: Date = Date(),
        calendar: Calendar = WeeklyAnalyticsSummary.mondayCalendar
    ) -> TrainingPeriodAnalyticsSummary {
        let start = period.start(containing: date, workouts: allWorkouts, now: now, calendar: calendar)
        return make(workouts: allWorkouts, period: period, periodStart: start, now: now, calendar: calendar)
    }

    public static func make(
        workouts allWorkouts: [CanonicalWorkout],
        period: TrainingAnalyticsPeriod,
        periodStart start: Date,
        now: Date = Date(),
        calendar: Calendar = WeeklyAnalyticsSummary.mondayCalendar
    ) -> TrainingPeriodAnalyticsSummary {
        let completed = V1WorkoutFilters.completedRuns(from: allWorkouts)
        let fullEnd = period.end(after: start, workouts: completed, now: now, calendar: calendar)
        let currentStart = period.start(containing: now, workouts: completed, now: now, calendar: calendar)
        let isCurrent = period != .allTime && calendar.isDate(start, inSameDayAs: currentStart)
        let elapsedDays = period.elapsedDayCount(from: start, fullEnd: fullEnd, now: now, isCurrent: isCurrent, calendar: calendar)
        let analysisEnd = period == .allTime
            ? fullEnd
            : minDate(period.addingDays(elapsedDays, to: start, calendar: calendar), fullEnd)
        let included = completed.filteredAndSorted(from: start, to: analysisEnd)
        let rows = included.map { WeeklyWorkoutRow(workout: $0, category: WeeklyRunCategory.make(from: $0)) }
        let totals = totals(for: included)
        let buckets = period.distanceBuckets(for: completed, start: start, end: analysisEnd, calendar: calendar)
        let categoryTotals = WeeklyRunCategory.allCases.map { category in
            let categoryRows = rows.filter { $0.category == category }
            return WeeklyRunCategoryTotal(
                category: category,
                runCount: categoryRows.count,
                distanceMeters: categoryRows.compactMap(\.workout.distanceMeters).reduce(0, +)
            )
        }

        return TrainingPeriodAnalyticsSummary(
            period: period,
            periodStart: start,
            periodEnd: fullEnd,
            analysisEnd: analysisEnd,
            elapsedDayCount: elapsedDays,
            isPeriodToDate: isCurrent,
            workouts: rows,
            distanceBuckets: buckets,
            categoryTotals: categoryTotals,
            totalDistanceMeters: totals.distance,
            totalDurationSeconds: totals.duration,
            comparison: comparison(
                workouts: completed,
                period: period,
                periodStart: start,
                elapsedDayCount: elapsedDays,
                isPeriodToDate: isCurrent,
                calendar: calendar
            )
        )
    }

    public static func availablePeriodStarts(
        workouts: [CanonicalWorkout],
        period: TrainingAnalyticsPeriod,
        now: Date = Date(),
        calendar: Calendar = WeeklyAnalyticsSummary.mondayCalendar
    ) -> [Date] {
        guard period != .allTime else { return [] }
        let completed = V1WorkoutFilters.completedRuns(from: workouts)
        let starts = Set(completed.map { period.start(containing: $0.startDate, workouts: completed, now: now, calendar: calendar) })
        let current = period.start(containing: now, workouts: completed, now: now, calendar: calendar)
        return Array(starts.union([current])).sorted(by: >)
    }

    private static func comparison(
        workouts: [CanonicalWorkout],
        period: TrainingAnalyticsPeriod,
        periodStart start: Date,
        elapsedDayCount: Int,
        isPeriodToDate: Bool,
        calendar: Calendar
    ) -> TrainingPeriodComparison? {
        guard period != .allTime,
              let previousStart = period.previousStart(before: start, calendar: calendar)
        else { return nil }

        let previousFullEnd = start
        let previousEnd = isPeriodToDate
            ? minDate(period.addingDays(elapsedDayCount, to: previousStart, calendar: calendar), previousFullEnd)
            : previousFullEnd
        let included = workouts.filteredAndSorted(from: previousStart, to: previousEnd)
        let totals = totals(for: included)

        return TrainingPeriodComparison(
            startDate: previousStart,
            endDate: previousEnd,
            elapsedDayCount: max(0, calendar.dateComponents([.day], from: previousStart, to: previousEnd).day ?? 0),
            runCount: included.count,
            totalDistanceMeters: totals.distance,
            totalDurationSeconds: totals.duration
        )
    }

    private static func totals(for workouts: [CanonicalWorkout]) -> (distance: Double, duration: Double) {
        let distance = workouts.compactMap(\.distanceMeters).reduce(0, +)
        let duration = workouts.reduce(0) { partial, workout in
            guard let distance = workout.distanceMeters, distance > 0 else { return partial }
            return partial + workout.durationSeconds
        }
        return (distance, duration)
    }

    private static func minDate(_ lhs: Date, _ rhs: Date) -> Date {
        lhs < rhs ? lhs : rhs
    }
}

private extension TrainingAnalyticsPeriod {
    var comparisonNoun: String {
        switch self {
        case .week: "week"
        case .month: "month"
        case .year: "year"
        case .allTime: "period"
        }
    }

    var signalTitle: String {
        switch self {
        case .week: "Week Signal"
        case .month: "Month Signal"
        case .year: "Year Signal"
        case .allTime: "All-Time Signal"
        }
    }

    func start(containing date: Date, workouts: [CanonicalWorkout], now: Date, calendar: Calendar) -> Date {
        switch self {
        case .week:
            return WeeklyAnalyticsSummary.weekStart(containing: date, calendar: calendar)
        case .month:
            let components = calendar.dateComponents([.year, .month], from: date)
            return calendar.date(from: DateComponents(timeZone: calendar.timeZone, year: components.year, month: components.month, day: 1))
                ?? calendar.startOfDay(for: date)
        case .year:
            let year = calendar.component(.year, from: date)
            return calendar.date(from: DateComponents(timeZone: calendar.timeZone, year: year, month: 1, day: 1))
                ?? calendar.startOfDay(for: date)
        case .allTime:
            return workouts.map { calendar.startOfDay(for: $0.startDate) }.min()
                ?? calendar.startOfDay(for: now)
        }
    }

    func end(after start: Date, workouts: [CanonicalWorkout], now: Date, calendar: Calendar) -> Date {
        switch self {
        case .week:
            return calendar.date(byAdding: .day, value: 7, to: start) ?? start.addingTimeInterval(7 * 86_400)
        case .month:
            return calendar.date(byAdding: .month, value: 1, to: start) ?? start.addingTimeInterval(31 * 86_400)
        case .year:
            return calendar.date(byAdding: .year, value: 1, to: start) ?? start.addingTimeInterval(366 * 86_400)
        case .allTime:
            let tomorrow = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now.addingTimeInterval(86_400)
            guard let latest = workouts.map(\.startDate).max() else { return tomorrow }
            let afterLatest = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: latest)) ?? latest.addingTimeInterval(86_400)
            return max(tomorrow, afterLatest)
        }
    }

    func previousStart(before start: Date, calendar: Calendar) -> Date? {
        switch self {
        case .week:
            return calendar.date(byAdding: .day, value: -7, to: start)
        case .month:
            return calendar.date(byAdding: .month, value: -1, to: start)
        case .year:
            return calendar.date(byAdding: .year, value: -1, to: start)
        case .allTime:
            return nil
        }
    }

    func elapsedDayCount(from start: Date, fullEnd: Date, now: Date, isCurrent: Bool, calendar: Calendar) -> Int {
        guard isCurrent else {
            return max(0, calendar.dateComponents([.day], from: start, to: fullEnd).day ?? 0)
        }
        let currentDayEnd = calendar.date(byAdding: .day, value: 1, to: calendar.startOfDay(for: now)) ?? now
        let clampedEnd = min(currentDayEnd, fullEnd)
        return max(1, calendar.dateComponents([.day], from: start, to: clampedEnd).day ?? 1)
    }

    func addingDays(_ days: Int, to date: Date, calendar: Calendar) -> Date {
        calendar.date(byAdding: .day, value: days, to: date) ?? date.addingTimeInterval(Double(days) * 86_400)
    }

    func distanceBuckets(
        for workouts: [CanonicalWorkout],
        start: Date,
        end: Date,
        calendar: Calendar
    ) -> [TrainingPeriodDistanceBucket] {
        switch self {
        case .week, .month:
            return dayBuckets(for: workouts, start: start, end: end, calendar: calendar)
        case .year:
            return componentBuckets(.month, dateFormat: "MMM", workouts: workouts, start: start, end: end, calendar: calendar)
        case .allTime:
            return componentBuckets(.year, dateFormat: "yyyy", workouts: workouts, start: start, end: end, calendar: calendar)
        }
    }

    private func dayBuckets(
        for workouts: [CanonicalWorkout],
        start: Date,
        end: Date,
        calendar: Calendar
    ) -> [TrainingPeriodDistanceBucket] {
        let dayCount = max(0, calendar.dateComponents([.day], from: start, to: end).day ?? 0)
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = self == .week ? "EEE" : "d"

        return (0..<dayCount).map { offset in
            let bucketStart = addingDays(offset, to: start, calendar: calendar)
            let bucketEnd = min(addingDays(1, to: bucketStart, calendar: calendar), end)
            return TrainingPeriodDistanceBucket(
                startDate: bucketStart,
                endDate: bucketEnd,
                label: formatter.string(from: bucketStart),
                distanceMeters: workouts.distance(from: bucketStart, to: bucketEnd)
            )
        }
    }

    private func componentBuckets(
        _ component: Calendar.Component,
        dateFormat: String,
        workouts: [CanonicalWorkout],
        start: Date,
        end: Date,
        calendar: Calendar
    ) -> [TrainingPeriodDistanceBucket] {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.timeZone = calendar.timeZone
        formatter.dateFormat = dateFormat

        var buckets: [TrainingPeriodDistanceBucket] = []
        var cursor = start
        while cursor < end {
            let next = calendar.date(byAdding: component, value: 1, to: cursor) ?? end
            let bucketEnd = min(next, end)
            buckets.append(
                TrainingPeriodDistanceBucket(
                    startDate: cursor,
                    endDate: bucketEnd,
                    label: formatter.string(from: cursor),
                    distanceMeters: workouts.distance(from: cursor, to: bucketEnd)
                )
            )
            cursor = next
        }
        return buckets
    }
}

private extension [CanonicalWorkout] {
    func filteredAndSorted(from start: Date, to end: Date) -> [CanonicalWorkout] {
        filter { $0.startDate >= start && $0.startDate < end }
            .sorted { $0.startDate > $1.startDate }
    }

    func distance(from start: Date, to end: Date) -> Double {
        filter { $0.startDate >= start && $0.startDate < end }
            .compactMap(\.distanceMeters)
            .reduce(0, +)
    }
}

public enum WorkoutChartMetric: String, CaseIterable, Identifiable, Sendable {
    case pace
    case heartRate
    case power
    case cadence

    public var id: String { rawValue }

    var title: String {
        switch self {
        case .pace: "Pace"
        case .heartRate: "Heart Rate"
        case .power: "Power"
        case .cadence: "Cadence"
        }
    }

    var unit: String {
        switch self {
        case .pace: "/km"
        case .heartRate: "bpm"
        case .power: "W"
        case .cadence: "spm"
        }
    }
}

public struct WorkoutChartPoint: Identifiable, Equatable, Sendable {
    public var id: Date { date }
    public var date: Date
    public var offsetSeconds: Double
    public var value: Double
}

public struct WorkoutChartSeries: Identifiable, Equatable, Sendable {
    public var id: WorkoutChartMetric { metric }
    public var metric: WorkoutChartMetric
    public var points: [WorkoutChartPoint]

    public var isRenderable: Bool {
        points.count >= 2
    }
}

public enum WorkoutChartSeriesBuilder {
    public static func coreSeries(for workout: CanonicalWorkout) -> [WorkoutChartSeries] {
        WorkoutChartMetric.allCases.map { series(metric: $0, workout: workout) }
    }

    public static func series(metric: WorkoutChartMetric, workout: CanonicalWorkout) -> WorkoutChartSeries {
        let points: [WorkoutChartPoint]
        switch metric {
        case .pace:
            points = pacePoints(workout: workout)
        case .heartRate:
            points = metricPoints(.heartRate, workout: workout)
        case .power:
            points = metricPoints(.runningPower, workout: workout)
        case .cadence:
            points = metricPoints(.cadence, workout: workout)
                .ifEmpty(metricPoints(.stepCount, workout: workout))
        }
        return WorkoutChartSeries(metric: metric, points: points)
    }

    public static func clippedSeries(_ series: WorkoutChartSeries, start: Date, end: Date) -> WorkoutChartSeries {
        let clipped = series.points.filter { $0.date >= start && $0.date <= end }
        return WorkoutChartSeries(metric: series.metric, points: clipped)
    }

    private static func metricPoints(_ metric: WorkoutEvidenceMetric, workout: CanonicalWorkout) -> [WorkoutChartPoint] {
        guard let source = workout.evidence?.series[metric] else { return [] }
        return source.points.map { point in
            WorkoutChartPoint(
                date: point.date,
                offsetSeconds: point.date.timeIntervalSince(workout.startDate),
                value: point.value
            )
        }
    }

    private static func pacePoints(workout: CanonicalWorkout) -> [WorkoutChartPoint] {
        if let speed = workout.evidence?.series[.runningSpeed], speed.points.count >= 2 {
            return speed.points.compactMap { point in
                guard point.value > 0 else { return nil }
                return WorkoutChartPoint(
                    date: point.date,
                    offsetSeconds: point.date.timeIntervalSince(workout.startDate),
                    value: 1_000 / point.value
                )
            }
        }

        guard let distance = workout.evidence?.series[.distance], distance.points.count >= 2 else { return [] }
        var previous = WorkoutEvidencePoint(date: workout.startDate, value: 0)
        var points: [WorkoutChartPoint] = []
        for point in distance.points {
            let seconds = point.date.timeIntervalSince(previous.date)
            let meters = point.value - previous.value
            if seconds > 0, meters > 0 {
                points.append(
                    WorkoutChartPoint(
                        date: point.date,
                        offsetSeconds: point.date.timeIntervalSince(workout.startDate),
                        value: seconds / (meters / 1_000)
                    )
                )
            }
            previous = point
        }
        return points
    }
}

public enum IntervalAnalysisMetric: String, CaseIterable, Identifiable, Sendable {
    case pace
    case heartRate
    case power
    case cadence
    case duration
    case distance

    public var id: String { rawValue }

    var title: String {
        switch self {
        case .pace: "Pace"
        case .heartRate: "Heart Rate"
        case .power: "Power"
        case .cadence: "Cadence"
        case .duration: "Duration"
        case .distance: "Distance"
        }
    }

    var unit: String {
        switch self {
        case .pace: "/km"
        case .heartRate: "bpm"
        case .power: "W"
        case .cadence: "spm"
        case .duration: "time"
        case .distance: "m"
        }
    }

    var usesTotalAggregate: Bool {
        switch self {
        case .duration, .distance: true
        case .pace, .heartRate, .power, .cadence: false
        }
    }
}

public struct IntervalAnalysisMetricValue: Equatable, Sendable {
    public var displayValue: Double
    public var chartValue: Double

    public init(displayValue: Double, chartValue: Double) {
        self.displayValue = displayValue
        self.chartValue = chartValue
    }
}

public struct IntervalWorkRepeatSummary: Equatable, Sendable {
    public var repeatCount: Int
    public var totalDistanceMeters: Double
    public var totalActiveDurationSeconds: Double
    public var aggregatePaceSecondsPerKm: Double?

    public init(repeatCount: Int, totalDistanceMeters: Double, totalActiveDurationSeconds: Double) {
        self.repeatCount = repeatCount
        self.totalDistanceMeters = totalDistanceMeters
        self.totalActiveDurationSeconds = totalActiveDurationSeconds
        aggregatePaceSecondsPerKm = totalDistanceMeters > 0
            ? totalActiveDurationSeconds / (totalDistanceMeters / 1_000)
            : nil
    }
}

public struct IntervalRepeatGroup: Identifiable, Equatable, Sendable {
    public var id: Int { repeatNumber }
    public var repeatNumber: Int
    public var rows: [IntervalAnalysisRow]

    public init(repeatNumber: Int, rows: [IntervalAnalysisRow]) {
        self.repeatNumber = repeatNumber
        self.rows = rows
    }
}

public struct IntervalAnalysisRow: Identifiable, Equatable, Sendable {
    public var id: Int { index }
    public var index: Int
    public var label: String
    public var stepType: DerivedIntervalLabel
    public var plannedGoalDisplayText: String
    public var plannedTargetDisplayText: String?
    public var displayDurationSeconds: Double
    public var elapsedDurationSeconds: Double
    public var activeDurationSeconds: Double
    public var pauseOverlapSeconds: Double?
    public var durationDisplayRule: ReconstructedIntervalDurationDisplayRule
    public var distanceMeters: Double?
    public var paceSecondsPerKm: Double?
    public var averageHeartRateBpm: Double?
    public var maxHeartRateBpm: Double?
    public var averagePower: Double?
    public var averageCadence: Double?
    public var startOffsetSeconds: Double
    public var endOffsetSeconds: Double

    public init(interval: ReconstructedWorkoutInterval, workoutStart: Date) {
        index = interval.index
        label = interval.label
        stepType = interval.stepType
        plannedGoalDisplayText = interval.plannedGoalDisplayText
        plannedTargetDisplayText = interval.plannedTargetDisplayText
        displayDurationSeconds = interval.displayDurationSeconds
        elapsedDurationSeconds = interval.elapsedRowWindowDurationSeconds
        activeDurationSeconds = interval.activeTimerDurationSeconds
        pauseOverlapSeconds = interval.pauseOverlapSeconds
        durationDisplayRule = interval.durationDisplayRule ?? .elapsedRowWindow
        distanceMeters = interval.actualDistanceMeters
        paceSecondsPerKm = Self.displayPaceSecondsPerKm(for: interval)
        averageHeartRateBpm = interval.averageHeartRateBpm
        maxHeartRateBpm = interval.maxHeartRateBpm
        averagePower = interval.averagePower
        averageCadence = interval.averageCadence
        startOffsetSeconds = interval.actualStartDate.timeIntervalSince(workoutStart)
        endOffsetSeconds = interval.actualEndDate.timeIntervalSince(workoutStart)
    }

    public func value(for metric: IntervalAnalysisMetric) -> IntervalAnalysisMetricValue? {
        switch metric {
        case .pace:
            guard let paceSecondsPerKm, paceSecondsPerKm > 0 else { return nil }
            return IntervalAnalysisMetricValue(displayValue: paceSecondsPerKm, chartValue: 3_600 / paceSecondsPerKm)
        case .heartRate:
            return averageHeartRateBpm.map { IntervalAnalysisMetricValue(displayValue: $0, chartValue: $0) }
        case .power:
            return averagePower.map { IntervalAnalysisMetricValue(displayValue: $0, chartValue: $0) }
        case .cadence:
            return averageCadence.map { IntervalAnalysisMetricValue(displayValue: $0, chartValue: $0) }
        case .duration:
            return IntervalAnalysisMetricValue(displayValue: displayDurationSeconds, chartValue: displayDurationSeconds)
        case .distance:
            return distanceMeters.map { IntervalAnalysisMetricValue(displayValue: $0, chartValue: $0) }
        }
    }

    public var roleAbbreviation: String {
        switch stepType {
        case .warmup: "WU"
        case .work: "W"
        case .recovery: "R"
        case .cooldown: "CD"
        case .open: "O"
        case .unknown: "?"
        }
    }

    public var displayBasisLabel: String {
        durationDisplayRule == .activeTimer ? "Active timer" : "Elapsed window"
    }

    private static func displayPaceSecondsPerKm(for interval: ReconstructedWorkoutInterval) -> Double? {
        guard interval.durationDisplayRule == .activeTimer,
              let distanceMeters = interval.actualDistanceMeters,
              distanceMeters > 0
        else {
            return interval.actualPaceSecondsPerKm
        }

        return interval.activeTimerDurationSeconds / (distanceMeters / 1_000)
    }
}

public struct IntervalAnalysisSummary: Equatable, Sendable {
    public var rows: [IntervalAnalysisRow]
    public var planSource: IntervalPlanSource
    public var windowSource: IntervalWindowSource

    public init(workout: CanonicalWorkout, result: WorkoutIntervalReconstructionResult) {
        rows = result.intervals
            .map { IntervalAnalysisRow(interval: $0, workoutStart: workout.startDate) }
            .sorted { $0.index < $1.index }
        planSource = result.planSource
        windowSource = result.windowSource
    }

    public var availableMetrics: [IntervalAnalysisMetric] {
        IntervalAnalysisMetric.allCases.filter { metric in
            rows.contains { $0.value(for: metric) != nil }
        }
    }

    public var aggregateRows: [IntervalAnalysisRow] {
        let workRows = rows.filter { $0.stepType == .work }
        return workRows.isEmpty ? rows : workRows
    }

    public var workRepeatSummary: IntervalWorkRepeatSummary? {
        let workRows = rows.filter { $0.stepType == .work }
        guard !workRows.isEmpty else { return nil }

        let totalDistance = workRows
            .compactMap(\.distanceMeters)
            .reduce(0, +)
        let totalDuration = workRows
            .map(\.displayDurationSeconds)
            .reduce(0, +)

        return IntervalWorkRepeatSummary(
            repeatCount: workRows.count,
            totalDistanceMeters: totalDistance,
            totalActiveDurationSeconds: totalDuration
        )
    }

    public var repeatGroups: [IntervalRepeatGroup] {
        var groups: [IntervalRepeatGroup] = []
        var currentIndex = rows.startIndex

        while currentIndex < rows.endIndex {
            let row = rows[currentIndex]
            let nextIndex = rows.index(after: currentIndex)

            guard row.stepType == .work,
                  nextIndex < rows.endIndex,
                  rows[nextIndex].stepType == .recovery else {
                currentIndex = nextIndex
                continue
            }

            groups.append(
                IntervalRepeatGroup(
                    repeatNumber: groups.count + 1,
                    rows: [row, rows[nextIndex]]
                )
            )
            currentIndex = rows.index(after: nextIndex)
        }

        return groups.count >= 2 ? groups : []
    }

    public var aggregateScopeLabel: String {
        rows.contains { $0.stepType == .work } ? "Work rows" : "Official rows"
    }

    public func aggregateValue(for metric: IntervalAnalysisMetric) -> IntervalAnalysisMetricValue? {
        let sourceRows = aggregateRows

        switch metric {
        case .pace:
            let totals = sourceRows.reduce(into: (duration: 0.0, distance: 0.0)) { partial, row in
                guard let distance = row.distanceMeters, distance > 0 else { return }
                partial.duration += row.displayDurationSeconds
                partial.distance += distance
            }
            guard totals.duration > 0, totals.distance > 0 else { return nil }
            let pace = totals.duration / (totals.distance / 1_000)
            return IntervalAnalysisMetricValue(displayValue: pace, chartValue: 3_600 / pace)
        case .duration:
            let total = sourceRows
                .compactMap { $0.value(for: metric)?.displayValue }
                .reduce(0, +)
            return total > 0 ? IntervalAnalysisMetricValue(displayValue: total, chartValue: total) : nil
        case .distance:
            let total = sourceRows
                .compactMap { $0.value(for: metric)?.displayValue }
                .reduce(0, +)
            return total > 0 ? IntervalAnalysisMetricValue(displayValue: total, chartValue: total) : nil
        case .heartRate, .power, .cadence:
            let values = sourceRows.compactMap { $0.value(for: metric)?.displayValue }
            guard !values.isEmpty else { return nil }
            let average = values.reduce(0, +) / Double(values.count)
            return IntervalAnalysisMetricValue(displayValue: average, chartValue: average)
        }
    }

    public func aggregateCaption(for metric: IntervalAnalysisMetric) -> String {
        "\(metric.usesTotalAggregate ? "Total" : "Average") \(aggregateScopeLabel)"
    }
}

public enum IntervalDrillDownEligibility {
    public static func officialRows(workout: CanonicalWorkout, evidence: WorkoutEvidence?) -> [ReconstructedWorkoutInterval] {
        guard let evidence,
              let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) else {
            return []
        }
        return result.intervals
    }
}

private extension Array {
    func ifEmpty(_ fallback: @autoclosure () -> [Element]) -> [Element] {
        isEmpty ? fallback() : self
    }
}
