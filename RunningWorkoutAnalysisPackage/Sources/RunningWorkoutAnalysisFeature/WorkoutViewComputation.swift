import Foundation

struct WorkoutChartDeckComputationResult: Equatable, Sendable {
    let series: [WorkoutChartSeries]
    let officialIntervals: [ReconstructedWorkoutInterval]
}

enum WorkoutViewComputation {
    @concurrent
    static func detailPresentation(
        workout: CanonicalWorkout,
        analysis: DerivedWorkoutAnalysis?
    ) async throws -> WorkoutDetailPresentation {
        try Task.checkCancellation()
        let result = WorkoutDetailPresentation.make(workout: workout, analysis: analysis)
        try Task.checkCancellation()
        return result
    }

    @concurrent
    static func routeAchievements(
        route: [WorkoutRoutePoint],
        rankedRecords: [PersonalBestEffortRankedRecord],
        workoutID: String
    ) async throws -> [WorkoutRouteAchievement] {
        try Task.checkCancellation()
        let result = WorkoutRouteAchievementMapper.make(
            route: route,
            rankedRecords: rankedRecords,
            workoutID: workoutID
        )
        try Task.checkCancellation()
        return result
    }

    @concurrent
    static func chartDeck(
        workout: CanonicalWorkout,
        interval: ReconstructedWorkoutInterval?
    ) async throws -> WorkoutChartDeckComputationResult {
        var series: [WorkoutChartSeries] = []
        series.reserveCapacity(WorkoutChartMetric.allCases.count)

        for metric in WorkoutChartMetric.allCases {
            try Task.checkCancellation()
            let core = WorkoutChartSeriesBuilder.series(metric: metric, workout: workout)
            let presented: WorkoutChartSeries
            switch metric {
            case .heartRate:
                presented = core
            case .pace:
                presented = WorkoutChartSeriesBuilder.binnedSeries(core, seconds: 10)
            case .power, .cadence:
                presented = WorkoutChartSeriesBuilder.binnedSeries(
                    core,
                    seconds: WorkoutChartSeriesBuilder.adaptiveMechanicsBinSeconds(for: core)
                )
            }

            if let interval {
                series.append(
                    WorkoutChartSeriesBuilder.clippedSeries(
                        presented,
                        start: interval.actualStartDate,
                        end: interval.actualEndDate
                    )
                )
            } else {
                series.append(presented)
            }
        }

        try Task.checkCancellation()
        let officialIntervals: [ReconstructedWorkoutInterval]
        if interval == nil,
           let evidence = workout.evidence,
           let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) {
            officialIntervals = result.intervals
        } else {
            officialIntervals = []
        }

        try Task.checkCancellation()
        return WorkoutChartDeckComputationResult(
            series: series,
            officialIntervals: officialIntervals
        )
    }

    @concurrent
    static func heartRateZoneAnalysis(
        workout: CanonicalWorkout,
        profile: HeartRateZoneProfile
    ) async throws -> HeartRateZoneAnalysis? {
        try Task.checkCancellation()
        let result = HeartRateZoneAnalyzer.analyze(workout: workout, profile: profile)
        try Task.checkCancellation()
        return result
    }
}
