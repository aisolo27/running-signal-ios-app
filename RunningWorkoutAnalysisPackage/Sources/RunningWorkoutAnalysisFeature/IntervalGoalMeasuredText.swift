import Foundation

enum IntervalGoalMeasuredText {
    static func metricItems(
        for interval: ReconstructedWorkoutInterval,
        policy: RunDisplayPolicy = .kilometersOnly
    ) -> [MetricItem] {
        return metricItems(
            plannedGoalType: interval.plannedGoalType,
            plannedGoalValue: interval.plannedGoalValue,
            plannedDistancePrescription: interval.plannedDistancePrescription,
            measuredDistanceMeters: interval.actualDistanceMeters,
            displayDurationSeconds: interval.displayDurationSeconds,
            measuredPaceSecondsPerKm: measuredPaceSecondsPerKm(for: interval),
            durationBasisLabel: durationBasisLabel(for: interval),
            policy: policy
        )
    }

    static func metricItems(
        for row: IntervalAnalysisRow,
        policy: RunDisplayPolicy = .kilometersOnly
    ) -> [MetricItem] {
        metricItems(
            plannedGoalType: row.plannedGoalType,
            plannedGoalValue: row.plannedGoalValue,
            plannedDistancePrescription: row.plannedDistancePrescription,
            measuredDistanceMeters: row.distanceMeters,
            displayDurationSeconds: row.displayDurationSeconds,
            measuredPaceSecondsPerKm: row.paceSecondsPerKm,
            durationBasisLabel: row.displayBasisLabel,
            policy: policy
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
        plannedDistancePrescription: PlannedDistancePrescription?,
        measuredDistanceMeters: Double?,
        displayDurationSeconds: Double,
        measuredPaceSecondsPerKm: Double?,
        durationBasisLabel: String,
        policy: RunDisplayPolicy
    ) -> [MetricItem] {
        switch plannedGoalType {
        case .distance:
            let completedGoal = {
                guard let plannedGoalValue, plannedGoalValue > 0,
                      let measuredDistanceMeters else { return false }
                return measuredDistanceMeters >= plannedGoalValue * 0.9
            }()
            if !completedGoal {
                return [
                    MetricItem(title: "Distance", value: RunFormatters.compactDistance(measuredDistanceMeters, policy: policy), detail: "Shortened · HealthKit"),
                    MetricItem(title: "Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel),
                    MetricItem(title: "Pace", value: RunFormatters.pace(measuredPaceSecondsPerKm, policy: policy), detail: "Measured distance")
                ]
            }
            return [
                MetricItem(
                    title: "Distance",
                    value: plannedDistancePrescription?.displayText
                        ?? RunFormatters.compactDistance(plannedGoalValue, policy: policy),
                    detail: "Workout plan"
                ),
                MetricItem(title: "Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel),
                MetricItem(
                    title: "Pace",
                    value: RunFormatters.pace(
                        goalPaceSecondsPerKm(durationSeconds: displayDurationSeconds, plannedDistanceMeters: plannedGoalValue),
                        policy: policy
                    ),
                    detail: "Planned distance"
                )
            ]
        case .time:
            return [
                MetricItem(title: "Distance", value: RunFormatters.compactDistance(measuredDistanceMeters, policy: policy), detail: "HealthKit"),
                MetricItem(title: "Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel),
                MetricItem(title: "Pace", value: RunFormatters.pace(measuredPaceSecondsPerKm, policy: policy), detail: durationBasisLabel)
            ]
        case .open, .energy, .unavailable:
            return [
                MetricItem(title: "Measured Distance", value: RunFormatters.compactDistance(measuredDistanceMeters, policy: policy), detail: "HealthKit"),
                MetricItem(title: "Measured Time", value: RunFormatters.duration(displayDurationSeconds), detail: durationBasisLabel),
                MetricItem(title: "Measured Pace", value: RunFormatters.pace(measuredPaceSecondsPerKm, policy: policy), detail: durationBasisLabel)
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
