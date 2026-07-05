import Foundation

enum IntervalGoalMeasuredText {
    static func metricItems(for interval: ReconstructedWorkoutInterval) -> [MetricItem] {
        metricItems(
            plannedGoalType: interval.plannedGoalType,
            plannedGoalValue: interval.plannedGoalValue,
            measuredDistanceMeters: interval.actualDistanceMeters,
            displayDurationSeconds: interval.displayDurationSeconds,
            measuredPaceSecondsPerKm: measuredPaceSecondsPerKm(for: interval),
            durationBasisLabel: durationBasisLabel(for: interval)
        )
    }

    static func metricItems(for row: IntervalAnalysisRow) -> [MetricItem] {
        metricItems(
            plannedGoalType: row.plannedGoalType,
            plannedGoalValue: row.plannedGoalValue,
            measuredDistanceMeters: row.distanceMeters,
            displayDurationSeconds: row.displayDurationSeconds,
            measuredPaceSecondsPerKm: row.paceSecondsPerKm,
            durationBasisLabel: row.displayBasisLabel
        )
    }

    static func measuredPaceSecondsPerKm(for interval: ReconstructedWorkoutInterval) -> Double? {
        guard interval.durationDisplayRule == .activeTimer,
              let distanceMeters = interval.actualDistanceMeters,
              distanceMeters > 0
        else {
            return interval.actualPaceSecondsPerKm
        }

        return interval.activeTimerDurationSeconds / (distanceMeters / 1_000)
    }

    static func measuredPaceDetail(for interval: ReconstructedWorkoutInterval) -> String {
        durationBasisLabel(for: interval)
    }

    private static func metricItems(
        plannedGoalType: PlannedWorkoutGoalType,
        plannedGoalValue: Double?,
        measuredDistanceMeters: Double?,
        displayDurationSeconds: Double,
        measuredPaceSecondsPerKm: Double?,
        durationBasisLabel: String
    ) -> [MetricItem] {
        switch plannedGoalType {
        case .distance:
            var items = [
                MetricItem(title: "Goal Distance", value: RunFormatters.compactDistance(plannedGoalValue), detail: "WorkoutKit"),
                MetricItem(title: "Measured Distance", value: RunFormatters.compactDistance(measuredDistanceMeters), detail: "HealthKit"),
                MetricItem(title: "Measured Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel)
            ]
            items.append(
                MetricItem(
                    title: "Goal Pace",
                    value: RunFormatters.pace(goalPaceSecondsPerKm(durationSeconds: displayDurationSeconds, plannedDistanceMeters: plannedGoalValue)),
                    detail: "Goal distance"
                )
            )
            items.append(MetricItem(title: "Measured Pace", value: RunFormatters.pace(measuredPaceSecondsPerKm), detail: durationBasisLabel))
            return items
        case .time:
            return [
                MetricItem(title: "Goal Time", value: RunFormatters.duration(plannedGoalValue), detail: "WorkoutKit"),
                MetricItem(title: "Measured Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel),
                MetricItem(title: "Measured Distance", value: RunFormatters.compactDistance(measuredDistanceMeters), detail: "HealthKit"),
                MetricItem(title: "Measured Pace", value: RunFormatters.pace(measuredPaceSecondsPerKm), detail: durationBasisLabel)
            ]
        case .open, .energy, .unavailable:
            return [
                MetricItem(title: "Measured Distance", value: RunFormatters.compactDistance(measuredDistanceMeters), detail: "HealthKit"),
                MetricItem(title: "Measured Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel),
                MetricItem(title: "Measured Pace", value: RunFormatters.pace(measuredPaceSecondsPerKm), detail: durationBasisLabel)
            ]
        }
    }

    private static func goalPaceSecondsPerKm(durationSeconds: Double, plannedDistanceMeters: Double?) -> Double? {
        guard let plannedDistanceMeters, plannedDistanceMeters > 0, durationSeconds > 0 else {
            return nil
        }
        return durationSeconds / (plannedDistanceMeters / 1_000)
    }

    private static func durationBasisLabel(for interval: ReconstructedWorkoutInterval) -> String {
        interval.durationDisplayRule == .activeTimer ? "Active timer" : "Elapsed window"
    }
}
