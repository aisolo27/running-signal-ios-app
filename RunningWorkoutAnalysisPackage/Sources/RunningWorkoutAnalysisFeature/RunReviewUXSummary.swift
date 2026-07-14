import Foundation

public struct ReviewSignal: Identifiable, Equatable, Sendable {
    public var id: String { title }
    public var title: String
    public var value: String
    public var detail: String
    public var confidence: ConfidenceLevel

    public init(title: String, value: String, detail: String, confidence: ConfidenceLevel) {
        self.title = title
        self.value = value
        self.detail = detail
        self.confidence = confidence
    }
}

public struct AppReadinessUXSummary: Equatable, Sendable {
    public var title: String
    public var detail: String
    public var confidence: ConfidenceLevel
    public var signals: [ReviewSignal]

    public static func make(
        workouts: [CanonicalWorkout],
        authorizationState: AuthorizationState,
        usesSampleData: Bool,
        isLoading: Bool,
        evidenceQueueSummary: EvidenceEnrichmentQueueSummary,
        bestEfforts: [PersonalBestEffortRecord],
        refreshJobs: [EvidenceRefreshJobSummary]
    ) -> AppReadinessUXSummary {
        let completedRuns = V1WorkoutFilters.completedRuns(from: workouts)
        let exactBestEfforts = bestEfforts.filter { $0.confidence == .exact || $0.confidence == .exactTotal }
        let activeRefresh = refreshJobs.first { $0.status == .queued || $0.status == .running || $0.status == .paused }
        let failedRefreshes = refreshJobs.filter { $0.failedCount > 0 || $0.status == .failed }.count

        let title: String
        let detail: String
        let confidence: ConfidenceLevel

        if usesSampleData {
            title = "Sample Data Mode"
            detail = "Load read-only HealthKit runs before judging Best Efforts, intervals, or analytics."
            confidence = .limited
        } else if authorizationState != .authorized && authorizationState != .partial {
            title = "HealthKit Access Needed"
            detail = "Grant Apple Health read access so RunSignal can load completed running workouts."
            confidence = .unavailable
        } else if isLoading || activeRefresh?.status == .running {
            title = "HealthKit Refresh In Progress"
            detail = "Runs are usable while detailed evidence continues loading in the foreground."
            confidence = .moderate
        } else if completedRuns.isEmpty {
            title = "No Completed Runs Loaded"
            detail = "HealthKit is reachable, but no completed running workouts match the current app filters."
            confidence = .limited
        } else if evidenceQueueSummary.pendingCount > 0 || failedRefreshes > 0 {
            title = "HealthKit Loaded, Evidence Pending"
            detail = "Whole-run review is ready. Some PRs, charts, or interval rows may need detailed evidence refresh."
            confidence = .moderate
        } else {
            title = "Run Review Ready"
            detail = "Completed HealthKit runs are loaded, with no queued detailed-evidence refresh blocking the main review surfaces."
            confidence = .strong
        }

        var signals = [
            ReviewSignal(
                title: "Runs",
                value: "\(completedRuns.count)",
                detail: usesSampleData ? "Sample rows" : "Completed",
                confidence: completedRuns.isEmpty ? .limited : .strong
            ),
            ReviewSignal(
                title: "Evidence",
                value: "\(evidenceQueueSummary.pendingCount)",
                detail: evidenceQueueSummary.pendingCount == 0 ? "Complete" : evidenceQueueSummary.nextPriority?.label ?? "Pending",
                confidence: evidenceQueueSummary.pendingCount == 0 ? .strong : .moderate
            ),
            ReviewSignal(
                title: "Best Efforts",
                value: "\(exactBestEfforts.count)",
                detail: "Official",
                confidence: exactBestEfforts.isEmpty ? .limited : .strong
            )
        ]

        if let activeRefresh {
            signals.append(
                ReviewSignal(
                    title: "Refresh",
                    value: activeRefresh.progressText,
                    detail: activeRefresh.statusTitle,
                    confidence: activeRefresh.status == .completed ? .strong : .moderate
                )
            )
        } else if failedRefreshes > 0 {
            signals.append(
                ReviewSignal(
                    title: "Refresh",
                    value: "\(failedRefreshes)",
                    detail: "Needs retry",
                    confidence: .limited
                )
            )
        }

        return AppReadinessUXSummary(title: title, detail: detail, confidence: confidence, signals: signals)
    }
}

public enum EvidenceReadinessAction: Equatable, Sendable {
    case none
    case load
    case refresh

    public var title: String? {
        switch self {
        case .none: nil
        case .load: "Load full analysis"
        case .refresh: "Refresh full analysis"
        }
    }
}

public struct EvidenceReadinessSummary: Equatable, Sendable {
    public var title: String
    public var detail: String
    public var confidence: ConfidenceLevel
    public var action: EvidenceReadinessAction
    public var technicalDetail: String?

    public static func make(
        workout: CanonicalWorkout,
        queueItem: EvidenceEnrichmentQueueItem?,
        isProcessing: Bool,
        supportedIntervals: WorkoutIntervalReconstructionResult?,
        blockedReasons: [String]
    ) -> EvidenceReadinessSummary {
        let isHealthKitSource = workout.dataSourceLabel.contains("HealthKit")
        guard isHealthKitSource else {
            return EvidenceReadinessSummary(
                title: "Sample summary ready",
                detail: "This sample workout keeps the app usable, but it is not Apple Health evidence.",
                confidence: .limited,
                action: .none,
                technicalDetail: "Sample workouts do not load HealthKit samples, routes, or WorkoutKit plans."
            )
        }

        if isProcessing {
            return EvidenceReadinessSummary(
                title: "Analyzing run",
                detail: "RunSignal is reading HealthKit samples, route, workout events, and structured workout evidence.",
                confidence: .moderate,
                action: .none,
                technicalDetail: "Detailed evidence refresh is running in the foreground."
            )
        }

        if let queueItem, queueItem.status == .failed {
            return EvidenceReadinessSummary(
                title: "Analysis failed",
                detail: queueItem.message ?? "RunSignal could not load full HealthKit evidence for this run.",
                confidence: .limited,
                action: .refresh,
                technicalDetail: "Retry reads detailed HealthKit evidence for the selected workout only."
            )
        }

        if let queueItem, queueItem.status == .pending {
            return EvidenceReadinessSummary(
                title: "Full analysis queued",
                detail: "Summary stats are ready. Detailed HealthKit evidence is waiting in the analysis queue.",
                confidence: .moderate,
                action: .load,
                technicalDetail: "Opening this run can prioritize it ahead of the normal queue."
            )
        }

        let hasDetailedEvidence = workout.evidence != nil && (workout.seriesSampleCount > 0 || workout.routePointCount > 0 || workout.intervalCount > 0)
        if hasDetailedEvidence, supportedIntervals?.intervals.isEmpty == false {
            return EvidenceReadinessSummary(
                title: "Full analysis ready",
                detail: "Charts, samples, and official structured interval evidence are available.",
                confidence: .strong,
                action: .refresh,
                technicalDetail: "Planned goals come from WorkoutKit; recorded metrics come from HealthKit activities and samples."
            )
        }

        if hasDetailedEvidence {
            let blockedDetail = blockedReasons.first.map {
                "Detailed HealthKit evidence is loaded, but official interval rows are blocked: \($0)"
            } ?? "Detailed HealthKit evidence is loaded. Some structured interval details remain unavailable."
            return EvidenceReadinessSummary(
                title: "Some details unavailable",
                detail: blockedDetail,
                confidence: .moderate,
                action: .refresh,
                technicalDetail: "Summary, route, charts, and whole-run metrics can still be valid when custom interval rows are blocked."
            )
        }

        return EvidenceReadinessSummary(
            title: "Summary ready",
            detail: "Basic workout stats are loaded from Apple Health. Full charts and intervals need detailed analysis.",
            confidence: .limited,
            action: .load,
            technicalDetail: "Full analysis reads HealthKit samples, routes, workout events, activities, and WorkoutKit plan metadata when available."
        )
    }
}

public struct WorkoutReviewUXSummary: Equatable, Sendable {
    public var title: String
    public var detail: String
    public var confidence: ConfidenceLevel
    public var signals: [ReviewSignal]

    public static func make(
        workout: CanonicalWorkout,
        supportedIntervals: WorkoutIntervalReconstructionResult?,
        blockedReasons: [String]
    ) -> WorkoutReviewUXSummary {
        let isHealthKitSource = workout.dataSourceLabel.contains("HealthKit")
        let hasDetailedSeries = isHealthKitSource && workout.seriesAvailable && workout.seriesSampleCount > 0
        let hasOfficialIntervals = supportedIntervals?.intervals.isEmpty == false
        let capability = workout.capabilityProfile
        let intervalDetail = hasOfficialIntervals
            ? "Official rows"
            : blockedReasons.first ?? "Whole-run only"
        let intervalConfidence: ConfidenceLevel = hasOfficialIntervals ? .strong : (workout.evidence == nil ? .limited : .moderate)

        let title: String
        let detail: String
        let confidence: ConfidenceLevel

        if workout.isDuplicate {
            title = "Duplicate Review Only"
            detail = "This workout is excluded from totals, analytics, and Best Efforts so duplicated HealthKit records do not distort results."
            confidence = .blocked
        } else if !isHealthKitSource {
            title = "Sample Workout Review"
            detail = "This sample workout keeps the screen usable, but it is not HealthKit proof and should not be compared with Apple Fitness."
            confidence = .limited
        } else if hasOfficialIntervals {
            title = "Structured Workout Official"
            detail = "Whole-run stats and official custom-workout rows are ready for review from HealthKit evidence."
            confidence = .strong
        } else if hasDetailedSeries {
            title = "Whole-Run Review Ready"
            detail = "Detailed HealthKit series are loaded. Interval rows remain under review until the public evidence gate passes."
            confidence = .moderate
        } else {
            title = "Summary Review Only"
            detail = "HealthKit summary fields are available, but detailed evidence is missing for charts, Best Efforts, or interval rows."
            confidence = .limited
        }

        let missingCapabilityCount = capability.missingExpectedMetrics.count
        let capabilityConfidence: ConfidenceLevel = switch capability.environmentConfidence {
        case .strong:
            missingCapabilityCount == 0 ? .strong : .moderate
        case .moderate:
            .moderate
        case .limited:
            .limited
        }

        let signals = [
            ReviewSignal(
                title: "Whole Run",
                value: RunFormatters.pace(workout.paceSecondsPerKm),
                detail: RunFormatters.distance(workout.distanceMeters),
                confidence: workout.distanceMeters == nil || workout.durationSeconds <= 0 ? .limited : .strong
            ),
            ReviewSignal(
                title: "Intervals",
                value: hasOfficialIntervals ? "\(supportedIntervals?.intervals.count ?? 0)" : "Review",
                detail: intervalDetail,
                confidence: intervalConfidence
            ),
            ReviewSignal(
                title: "Evidence",
                value: hasDetailedSeries ? "\(workout.seriesSampleCount)" : "Summary",
                detail: hasDetailedSeries ? "Samples" : "No series",
                confidence: hasDetailedSeries ? .strong : .limited
            ),
            ReviewSignal(
                title: "Expected Data",
                value: capability.environment.label,
                detail: missingCapabilityCount == 0 ? "Matches run type" : "\(missingCapabilityCount) missing",
                confidence: capabilityConfidence
            ),
            ReviewSignal(
                title: "Source",
                value: isHealthKitSource ? "HealthKit" : "Sample",
                detail: workout.sourceName,
                confidence: isHealthKitSource ? .strong : .limited
            )
        ]

        return WorkoutReviewUXSummary(title: title, detail: detail, confidence: confidence, signals: signals)
    }
}

public struct BestEffortUXSummary: Equatable, Sendable {
    public var title: String
    public var detail: String
    public var confidence: ConfidenceLevel

    public static func make(effort: PersonalBestEffortRecord) -> BestEffortUXSummary {
        let caveatText = effort.caveats
            .filter { $0 != .routeMissing }
            .map(caveatLabel)
            .joined(separator: ", ")
        let suffix = caveatText.isEmpty ? "" : " Note: \(caveatText)."

        switch effort.confidence {
        case .exact:
            return BestEffortUXSummary(
                title: "Verified",
                detail: "Verified from detailed Apple Health distance data.\(suffix)",
                confidence: .strong
            )
        case .exactTotal:
            return BestEffortUXSummary(
                title: "Verified total",
                detail: "Verified from the full Apple Health workout.\(suffix)",
                confidence: .strong
            )
        case .estimated:
            return BestEffortUXSummary(
                title: "Estimate",
                detail: "Calculated from whole-run pace because exact segment evidence is incomplete.\(suffix)",
                confidence: .limited
            )
        case .unavailable:
            return BestEffortUXSummary(
                title: "Unavailable",
                detail: "RunSignal does not have enough trustworthy HealthKit evidence for this effort yet.\(suffix)",
                confidence: .unavailable
            )
        }
    }

    public static func caveatLabel(_ caveat: PersonalBestEffortCaveat) -> String {
        switch caveat {
        case .summaryOnlyEstimate:
            "summary-only"
        case .indoorDeviceDerivedDistance:
            "indoor/device distance"
        case .routeMissing:
            "route missing"
        case .pauseOverlap:
            "pause overlap"
        case .sampleGap:
            "sample gap"
        case .shortBucketDensityLimited:
            "short-bucket density"
        case .unrealisticSegmentPace:
            "unrealistic segment pace"
        case .distanceSeriesUnusable:
            "distance series unusable"
        }
    }
}

public struct IntervalExecutionUXSummary: Equatable, Sendable {
    public var title: String
    public var detail: String
    public var confidence: ConfidenceLevel
    public var signals: [ReviewSignal]

    public static func make(summary: IntervalAnalysisSummary) -> IntervalExecutionUXSummary {
        let workRows = summary.rows.filter { $0.stepType == .work }
        let recoveryRows = summary.rows.filter { $0.stepType == .recovery }
        let pausedRows = summary.rows.filter { ($0.pauseOverlapSeconds ?? 0) > 0 }
        let openRows = summary.rows.filter { $0.stepType == .open }

        let title = workRows.isEmpty
            ? "\(summary.rows.count) official rows"
            : "\(workRows.count) work reps official"
        let fadeSignal = workFadeSignal(workRows: workRows)
        let detail = workRows.isEmpty
            ? "Official rows are available; no Work rows were detected, so the summary stays whole-structure focused."
            : "Work reps drive the execution read. Warmup, recovery, cooldown, pauses, and Open / Extra remain visible context."

        var signals = [
            ReviewSignal(
                title: "Work",
                value: "\(workRows.count)",
                detail: "Official reps",
                confidence: workRows.isEmpty ? .limited : .strong
            ),
            fadeSignal,
            ReviewSignal(
                title: "Recovery",
                value: "\(recoveryRows.count)",
                detail: "Context rows",
                confidence: recoveryRows.isEmpty ? .limited : .moderate
            ),
            ReviewSignal(
                title: "Pauses",
                value: "\(pausedRows.count)",
                detail: pausedRows.isEmpty ? "None in rows" : "Active timer shown",
                confidence: pausedRows.isEmpty ? .strong : .moderate
            )
        ]

        if !openRows.isEmpty {
            signals.append(
                ReviewSignal(
                    title: "Extra",
                    value: "\(openRows.count)",
                    detail: "Open / Extra",
                    confidence: .moderate
                )
            )
        }

        return IntervalExecutionUXSummary(
            title: title,
            detail: detail,
            confidence: workRows.isEmpty ? .moderate : .strong,
            signals: signals
        )
    }

    private static func workFadeSignal(workRows: [IntervalAnalysisRow]) -> ReviewSignal {
        guard workRows.count >= 2,
              let firstPace = workRows.first?.paceSecondsPerKm,
              let lastPace = workRows.last?.paceSecondsPerKm,
              firstPace > 0,
              lastPace > 0
        else {
            return ReviewSignal(title: "Fade", value: "N/A", detail: "Needs 2+ work reps", confidence: .limited)
        }

        let delta = lastPace - firstPace
        let confidence: ConfidenceLevel = abs(delta) <= 5 ? .strong : .moderate
        let direction = delta > 0 ? "slower" : "faster"
        let value = "\(delta > 0 ? "+" : "")\(Int(delta.rounded()))s/km"
        return ReviewSignal(title: "Fade", value: value, detail: "Last rep \(direction)", confidence: confidence)
    }
}
