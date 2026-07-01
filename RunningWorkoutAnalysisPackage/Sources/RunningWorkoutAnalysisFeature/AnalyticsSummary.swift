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
