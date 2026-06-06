import Foundation

public enum AnalyticsEngine {
    public static func snapshot(for workouts: [CanonicalWorkout], now: Date = Date()) -> AnalysisSnapshot {
        let included = workouts.filter { !$0.isDuplicate }
        let dataQuality = makeDataQualityReport(workouts)
        let weekly = totalDistance(included, from: daysBefore(now, 7), through: now)
        let previousWeekly = totalDistance(included, from: daysBefore(now, 14), through: daysBefore(now, 7))
        let balance = intensityBalance(included, from: daysBefore(now, 28), through: now)
        let bestEfforts = makeBestEfforts(included)
        let readiness = makeReadiness(workouts: included, bestEfforts: bestEfforts, dataQuality: dataQuality, now: now)

        return AnalysisSnapshot(
            weeklyVolumeKm: weekly / 1_000,
            previousWeeklyVolumeKm: previousWeekly / 1_000,
            trainingLoadConfidence: included.count >= 6 ? .moderate : .limited,
            easyPercent: balance.easy,
            qualityPercent: balance.quality,
            longRunPercent: balance.longRun,
            fitnessTrend: makeFitnessTrend(included),
            bestEfforts: bestEfforts,
            readiness: readiness,
            dataQuality: dataQuality
        )
    }

    public static func makeDataQualityReport(_ workouts: [CanonicalWorkout]) -> DataQualityReport {
        let included = workouts.filter { !$0.isDuplicate }
        let total = max(included.count, 1)
        let heartRateCoverage = Double(included.filter { $0.averageHeartRate != nil }.count) / Double(total)
        let cadenceCoverage = Double(included.filter { $0.averageCadence != nil }.count) / Double(total)
        let powerCoverage = Double(included.filter { $0.averagePower != nil }.count) / Double(total)
        let mechanicsCoverage = Double(included.filter {
            $0.strideLengthMeters != nil || $0.verticalOscillationCentimeters != nil || $0.groundContactMilliseconds != nil
        }.count) / Double(total)
        let routeCoverage = Double(included.filter(\.routeAvailable).count) / Double(total)
        let seriesCoverage = Double(included.filter(\.seriesAvailable).count) / Double(total)

        var caveats: [String] = []
        if workouts.contains(where: \.isDuplicate) {
            caveats.append("Duplicate candidates are excluded from training totals.")
        }
        if heartRateCoverage < 0.6 {
            caveats.append("Heart-rate coverage is limited, so recovery and drift claims stay conservative.")
        }
        if mechanicsCoverage < 0.5 {
            caveats.append("Mechanics are not promoted until cadence/form fields have enough coverage.")
        }
        if seriesCoverage < 0.7 {
            caveats.append("Workout Analyzer and trend detail need more per-workout series evidence.")
        }
        if included.isEmpty {
            caveats.append("No running workouts are available yet.")
        }

        let confidence: ConfidenceLevel
        if included.count >= 12 && heartRateCoverage >= 0.7 {
            confidence = .strong
        } else if included.count >= 6 {
            confidence = .moderate
        } else if included.isEmpty {
            confidence = .unavailable
        } else {
            confidence = .limited
        }

        return DataQualityReport(
            workoutCount: workouts.count,
            includedWorkoutCount: included.count,
            duplicateCount: workouts.filter(\.isDuplicate).count,
            heartRateCoverage: heartRateCoverage,
            cadenceCoverage: cadenceCoverage,
            powerCoverage: powerCoverage,
            mechanicsCoverage: mechanicsCoverage,
            routeCoverage: routeCoverage,
            seriesCoverage: seriesCoverage,
            confidence: confidence,
            caveats: caveats
        )
    }

    public static func parityReadiness(
        dataQuality: DataQualityReport,
        pendingSeriesCount: Int,
        reviewedRunTypeCount: Int
    ) -> [Insight] {
        [
            Insight(
                title: "Data Quality",
                value: dataQuality.confidence == .strong ? "Ready" : "Usable",
                detail: "\(dataQuality.includedWorkoutCount) included runs, \(dataQuality.duplicateCount) duplicate candidates excluded.",
                confidence: dataQuality.confidence
            ),
            Insight(
                title: "Run Type Analysis",
                value: reviewedRunTypeCount > 0 ? "Linked" : "Needs labels",
                detail: reviewedRunTypeCount > 0 ? "Reviewed web categories are available for native matching." : "Import reviewed web-app categories before trusting distribution by workout purpose.",
                confidence: reviewedRunTypeCount > 0 ? .moderate : .limited
            ),
            Insight(
                title: "Workout Analyzer",
                value: pendingSeriesCount == 0 ? "Ready" : "Series pending",
                detail: pendingSeriesCount == 0 ? "Per-workout evidence is available for deeper execution review." : "\(pendingSeriesCount) included workouts still need series evidence before split and execution claims can match the web app.",
                confidence: pendingSeriesCount == 0 ? .moderate : .limited
            ),
            Insight(
                title: "Trends",
                value: dataQuality.heartRateCoverage >= 0.7 && dataQuality.seriesCoverage >= 0.7 ? "Ready" : "Limited",
                detail: "Trend confidence depends on pace, heart-rate, and per-workout series coverage.",
                confidence: dataQuality.heartRateCoverage >= 0.7 && dataQuality.seriesCoverage >= 0.7 ? .moderate : .limited
            ),
            Insight(
                title: "Mechanics",
                value: dataQuality.mechanicsCoverage >= 0.5 ? "Usable" : "Blocked",
                detail: dataQuality.mechanicsCoverage >= 0.5 ? "Mechanics fields have enough coverage for cautious surfacing." : "Cadence, power, stride, vertical oscillation, and ground-contact fields need stronger coverage.",
                confidence: dataQuality.mechanicsCoverage >= 0.5 ? .moderate : .limited
            ),
            Insight(
                title: "Training Plan Brief",
                value: dataQuality.confidence == .unavailable ? "Missing" : "Draftable",
                detail: "Native export can summarize the goal and data caveats, but should stay evidence-first until analyzer parity improves.",
                confidence: dataQuality.confidence == .unavailable ? .unavailable : .moderate
            )
        ]
    }

    public static func makeBestEfforts(_ workouts: [CanonicalWorkout]) -> [BestEffort] {
        let targets: [(String, Double)] = [
            ("400m", 400),
            ("1K", 1_000),
            ("Mile", 1_609.34),
            ("2-mile", 3_218.68),
            ("5K", 5_000),
            ("10K", 10_000)
        ]

        return targets.compactMap { label, target in
            workouts
                .compactMap { workout -> BestEffort? in
                    guard let distance = workout.distanceMeters, distance >= target * 0.96 else { return nil }
                    let estimated = PaceMath.secondsForDistance(
                        paceSecondsPerKm: workout.paceSecondsPerKm ?? .infinity,
                        distanceMeters: target
                    )
                    guard estimated.isFinite else { return nil }
                    return BestEffort(
                        label: label,
                        distanceMeters: target,
                        workoutID: workout.id,
                        date: workout.startDate,
                        durationSeconds: estimated,
                        paceSecondsPerKm: estimated / (target / 1_000)
                    )
                }
                .min { $0.durationSeconds < $1.durationSeconds }
        }
    }

    public static func makeReadiness(
        workouts: [CanonicalWorkout],
        bestEfforts: [BestEffort],
        dataQuality: DataQualityReport,
        now: Date = Date()
    ) -> ReadinessSummary {
        let fiveK = bestEfforts.first { $0.label == "5K" }
        let gap = fiveK.map { $0.paceSecondsPerKm - RunningGoal.sub20FiveK.targetPaceSecondsPerKm }
        let recent = workouts.filter { $0.startDate >= daysBefore(now, 56) }
        let qualityCount = recent.filter { [.threshold, .interval, .race, .tempo].contains($0.effectiveRunType) }.count
        let easyCount = recent.filter { [.easy, .recovery, .longRun].contains($0.effectiveRunType) }.count
        let consistencyWeeks = Set(recent.map(weekKey)).count

        let evidence = [
            Insight(
                title: "5K proof",
                value: fiveK.map { RunFormatters.duration($0.durationSeconds) } ?? "Missing",
                detail: gap.map { $0 <= 0 ? "Fast enough on current evidence." : "\(Int($0.rounded())) sec/km from goal pace." } ?? "Needs a direct 5K benchmark or reliable best effort.",
                confidence: fiveK == nil ? .limited : .moderate
            ),
            Insight(
                title: "Quality sessions",
                value: "\(qualityCount) recent",
                detail: qualityCount >= 4 ? "Enough race-specific work to read direction." : "More threshold, interval, or race evidence is needed.",
                confidence: qualityCount >= 4 ? .moderate : .limited
            ),
            Insight(
                title: "Aerobic support",
                value: "\(easyCount) easy/long",
                detail: easyCount >= qualityCount * 2 ? "Easy volume is supporting hard sessions." : "Intensity may be too concentrated or under-labeled.",
                confidence: easyCount >= 4 ? .moderate : .limited
            ),
            Insight(
                title: "Consistency",
                value: "\(consistencyWeeks) weeks",
                detail: consistencyWeeks >= 4 ? "Recent frequency is stable enough to trust trends." : "Readiness will sharpen after more consistent weeks.",
                confidence: consistencyWeeks >= 4 ? .moderate : .limited
            )
        ]

        let status: ConfidenceLevel
        if dataQuality.confidence == .unavailable {
            status = .unavailable
        } else if let gap, gap <= 0, qualityCount >= 4, easyCount >= qualityCount {
            status = .strong
        } else if let gap, gap <= 15, qualityCount >= 3 {
            status = .moderate
        } else {
            status = .limited
        }

        let nextFocus: String
        if fiveK == nil {
            nextFocus = "Get a reliable 5K or 20-minute benchmark before trusting readiness."
        } else if qualityCount < 4 {
            nextFocus = "Add repeatable threshold or interval evidence without turning every run hard."
        } else if easyCount < qualityCount * 2 {
            nextFocus = "Protect easy volume so quality work can actually move fitness."
        } else {
            nextFocus = "Keep the pattern steady and look for pace gains at similar heart rate."
        }

        return ReadinessSummary(
            status: status,
            title: readinessTitle(status),
            summary: readinessSummary(status),
            paceGapSecondsPerKm: gap,
            bestFiveKSeconds: fiveK?.durationSeconds,
            nextFocus: nextFocus,
            evidence: evidence
        )
    }

    public static func latestRunReview(_ workout: CanonicalWorkout?) -> [Insight] {
        guard let workout else {
            return [Insight(title: "Latest run", value: "Missing", detail: "No running workout is available yet.", confidence: .unavailable)]
        }

        let splitSignal = workout.seriesAvailable
            ? "Series exists for deeper split review."
            : "No time series loaded; split review stays limited."
        let hrSignal = workout.averageHeartRate.map { "Average HR \(Int($0.rounded())) bpm." } ?? "Heart-rate data is missing."
        let confidence: ConfidenceLevel = workout.seriesAvailable ? .moderate : .limited

        return [
            Insight(title: "Execution", value: workout.effectiveRunType.label, detail: splitSignal, confidence: confidence),
            Insight(title: "Intensity", value: RunFormatters.pace(workout.paceSecondsPerKm), detail: hrSignal, confidence: workout.averageHeartRate == nil ? .limited : .moderate),
            Insight(title: "Next time", value: "Control the first third", detail: "Until split data is available, keep the opening segment smooth and judge finish quality after the run.", confidence: .limited)
        ]
    }

    public static func markdownSummary(
        workouts: [CanonicalWorkout],
        snapshot: AnalysisSnapshot,
        healthContext: HealthContext = HealthContext()
    ) -> String {
        let latest = workouts.filter { !$0.isDuplicate }.sorted { $0.startDate > $1.startDate }.first
        return """
        # Running Analysis Brief

        ## Race Goal
        - Goal: \(RunningGoal.sub20FiveK.title) on Oct 17, 2026
        - Target pace: \(RunFormatters.pace(RunningGoal.sub20FiveK.targetPaceSecondsPerKm))
        - Current readiness: \(snapshot.readiness.status.label)
        - Next focus: \(snapshot.readiness.nextFocus)

        ## Latest Run
        - Date: \(latest.map { RunFormatters.date.string(from: $0.startDate) } ?? "Missing")
        - Type: \(latest?.effectiveRunType.label ?? "Missing")
        - Distance: \(RunFormatters.distance(latest?.distanceMeters))
        - Pace: \(RunFormatters.pace(latest?.paceSecondsPerKm))
        - Active calories: \(RunFormatters.calories(latest?.activeEnergyKilocalories))
        - Elevation gain: \(RunFormatters.number(latest?.elevationGainMeters, suffix: " m"))
        - Evidence samples: \(latest.map { "\($0.seriesSampleCount)" } ?? "Missing")
        - Interval events: \(latest.map { "\($0.intervalCount)" } ?? "Missing")

        ## Training Load
        - Last 7 days: \(String(format: "%.1f km", snapshot.weeklyVolumeKm))
        - Previous 7 days: \(String(format: "%.1f km", snapshot.previousWeeklyVolumeKm))
        - Easy / quality / long-run balance: \(RunFormatters.percent(snapshot.easyPercent)) / \(RunFormatters.percent(snapshot.qualityPercent)) / \(RunFormatters.percent(snapshot.longRunPercent))

        ## Health Context
        - VO2 max: \(RunFormatters.number(healthContext.vo2Max, decimals: 1))
        - Resting heart rate: \(RunFormatters.number(healthContext.restingHeartRate, suffix: " bpm"))
        - Average heart rate: \(RunFormatters.number(healthContext.averageHeartRate, suffix: " bpm"))
        - Max heart rate: \(RunFormatters.number(healthContext.maxHeartRate, suffix: " bpm"))
        - Active energy, all available: \(RunFormatters.calories(healthContext.activeEnergyKilocaloriesTotal))

        ## Data Confidence
        - Confidence: \(snapshot.dataQuality.confidence.label)
        - Included workouts: \(snapshot.dataQuality.includedWorkoutCount)
        - Duplicate candidates excluded: \(snapshot.dataQuality.duplicateCount)
        - Caveats: \(snapshot.dataQuality.caveats.isEmpty ? "None" : snapshot.dataQuality.caveats.joined(separator: " "))
        """
    }

    private static func makeFitnessTrend(_ workouts: [CanonicalWorkout]) -> Insight {
        let eligible = workouts
            .filter { $0.averageHeartRate != nil && $0.distanceMeters != nil && $0.durationSeconds > 0 }
            .sorted { $0.startDate < $1.startDate }
        guard eligible.count >= 4 else {
            return Insight(title: "Fitness trend", value: "Limited", detail: "Need at least four runs with pace and heart rate.", confidence: .limited)
        }
        let midpoint = eligible.count / 2
        let early = efficiency(Array(eligible.prefix(midpoint)))
        let recent = efficiency(Array(eligible.suffix(eligible.count - midpoint)))
        guard let early, let recent else {
            return Insight(title: "Fitness trend", value: "Limited", detail: "Missing distance, pace, or heart-rate coverage.", confidence: .limited)
        }
        let change = (recent - early) / early
        let value = change >= 0.03 ? "Improving" : change <= -0.03 ? "Declining" : "Stable"
        return Insight(
            title: "Fitness trend",
            value: value,
            detail: "Meters per heartbeat changed \(RunFormatters.percent(change)) across the available sample.",
            confidence: eligible.count >= 8 ? .moderate : .limited
        )
    }

    private static func efficiency(_ workouts: [CanonicalWorkout]) -> Double? {
        let values = workouts.compactMap { workout -> Double? in
            guard let pace = workout.paceSecondsPerKm, let hr = workout.averageHeartRate, hr > 0 else { return nil }
            return (1_000 / pace) / hr
        }
        guard !values.isEmpty else { return nil }
        return values.reduce(0, +) / Double(values.count)
    }

    private static func intensityBalance(_ workouts: [CanonicalWorkout], from start: Date, through end: Date) -> (easy: Double, quality: Double, longRun: Double) {
        let recent = workouts.filter { $0.startDate >= start && $0.startDate < end }
        let total = max(recent.count, 1)
        let easy = recent.filter { [.easy, .recovery].contains($0.effectiveRunType) }.count
        let quality = recent.filter { [.tempo, .threshold, .interval, .race, .hills, .progression].contains($0.effectiveRunType) }.count
        let longRun = recent.filter { $0.effectiveRunType == .longRun }.count
        return (Double(easy) / Double(total), Double(quality) / Double(total), Double(longRun) / Double(total))
    }

    private static func totalDistance(_ workouts: [CanonicalWorkout], from start: Date, through end: Date) -> Double {
        workouts
            .filter { $0.startDate >= start && $0.startDate < end }
            .compactMap(\.distanceMeters)
            .reduce(0, +)
    }

    private static func daysBefore(_ date: Date, _ days: Int) -> Date {
        Calendar.current.date(byAdding: .day, value: -days, to: date) ?? date
    }

    private static func weekKey(_ workout: CanonicalWorkout) -> String {
        let comps = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: workout.startDate)
        return "\(comps.yearForWeekOfYear ?? 0)-\(comps.weekOfYear ?? 0)"
    }

    private static func readinessTitle(_ confidence: ConfidenceLevel) -> String {
        switch confidence {
        case .strong: "Ready evidence is forming"
        case .moderate: "Close, but keep proving it"
        case .limited: "Building with limited proof"
        case .unavailable: "Readiness unavailable"
        }
    }

    private static func readinessSummary(_ confidence: ConfidenceLevel) -> String {
        switch confidence {
        case .strong: "The available data supports sub-20 direction, but this is still not a prediction."
        case .moderate: "Useful evidence exists, with a few proof points still missing."
        case .limited: "The app needs more reliable workout and intensity evidence before making a strong call."
        case .unavailable: "No reliable running sample is available yet."
        }
    }
}
