import Foundation

public enum DiagnosticsExport {
    public static func markdown(
        workouts: [CanonicalWorkout],
        snapshot: AnalysisSnapshot,
        healthContext: HealthContext,
        reconciliation: RunTypeReconciliationSummary,
        authorizationState: AuthorizationState,
        syncState: HealthKitSyncState = .empty,
        message: String,
        generatedAt: Date = Date()
    ) -> String {
        let rows = reconciliation.rows
            .filter { [.weak, .conflict, .webOnly].contains($0.status) }
            .prefix(12)
            .map(diagnosticLine)
            .joined(separator: "\n")

        return """
        # RunSignal Diagnostics

        Generated: \(RunFormatters.date.string(from: generatedAt))

        ## HealthKit Load
        - Authorization: \(authorizationState.label)
        - Message: \(message)
        - Workouts: \(snapshot.dataQuality.workoutCount)
        - Included: \(snapshot.dataQuality.includedWorkoutCount)
        - Duplicates: \(snapshot.dataQuality.duplicateCount)
        - Confidence: \(snapshot.dataQuality.confidence.label)

        ## HealthKit Sync
        - Last sync: \(syncState.lastSyncAt.map { RunFormatters.date.string(from: $0) } ?? "Never")
        - Fetched changes: \(syncState.lastFetchedCount)
        - Inserted: \(syncState.lastInsertedCount)
        - Updated: \(syncState.lastUpdatedCount)
        - Deleted detected: \(syncState.lastDeletedCount)
        - Evidence pending: \(syncState.lastEvidencePendingCount)
        - Route points loaded: \(workouts.filter { !$0.isDuplicate }.map(\.routePointCount).reduce(0, +))
        - Series samples loaded: \(workouts.filter { !$0.isDuplicate }.map(\.seriesSampleCount).reduce(0, +))
        - Interval events loaded: \(workouts.filter { !$0.isDuplicate }.map(\.intervalCount).reduce(0, +))

        ## HealthKit Audit
        - Audited workouts: \(HealthKitAudit.rows(for: workouts).count)
        - Heart-rate sample rows: \(workouts.filter { !$0.isDuplicate && $0.heartRateSampleCount > 0 }.count)
        - Speed/distance sample rows: \(workouts.filter { !$0.isDuplicate && ($0.runningSpeedSampleCount > 0 || $0.distanceSampleCount > 0) }.count)
        - Running dynamics rows: \(workouts.filter { !$0.isDuplicate && ($0.strideLengthSampleCount > 0 || $0.verticalOscillationSampleCount > 0 || $0.groundContactTimeSampleCount > 0) }.count)

        ## Coverage
        - Heart rate: \(RunFormatters.percent(snapshot.dataQuality.heartRateCoverage))
        - Cadence: \(RunFormatters.percent(snapshot.dataQuality.cadenceCoverage))
        - Power: \(RunFormatters.percent(snapshot.dataQuality.powerCoverage))
        - Mechanics: \(RunFormatters.percent(snapshot.dataQuality.mechanicsCoverage))
        - Route: \(RunFormatters.percent(snapshot.dataQuality.routeCoverage))
        - Series: \(RunFormatters.percent(snapshot.dataQuality.seriesCoverage))

        ## Health Context
        - VO2 max: \(RunFormatters.number(healthContext.vo2Max, decimals: 1))
        - Resting HR: \(RunFormatters.number(healthContext.restingHeartRate, suffix: " bpm"))
        - Average HR: \(RunFormatters.number(healthContext.averageHeartRate, suffix: " bpm"))
        - Max HR: \(RunFormatters.number(healthContext.maxHeartRate, suffix: " bpm"))
        - Active energy: \(RunFormatters.calories(healthContext.activeEnergyKilocaloriesTotal))

        ## Web Category Bridge
        - Imported: \(reconciliation.importedCount)
        - Matched: \(reconciliation.matchedCount)
        - Weak: \(reconciliation.weakCount)
        - Conflicts: \(reconciliation.conflictCount)
        - Web-only: \(reconciliation.webOnlyCount)
        - iPhone-only: \(reconciliation.phoneOnlyCount)

        ## Review Samples
        \(rows.isEmpty ? "- None" : rows)

        ## Caveats
        \(snapshot.dataQuality.caveats.isEmpty ? "- None" : snapshot.dataQuality.caveats.map { "- \($0)" }.joined(separator: "\n"))
        """
    }

    private static func diagnosticLine(_ row: RunTypeReconciliationRow) -> String {
        let reviewDate = row.review?.localDate ?? "missing-date"
        let reviewTime = row.review?.localStartTime ?? "missing-time"
        let workoutDate = row.workoutDate.map { RunFormatters.date.string(from: $0) } ?? "no-workout"
        let category = row.review?.category.rawValue ?? row.matchedRunType?.rawValue ?? "unknown"
        return "- \(row.status.rawValue): \(category), review \(reviewDate) \(reviewTime), workout \(workoutDate), reason: \(row.reason)"
    }

    public static func workoutEvidenceMarkdown(_ evidence: WorkoutEvidence) -> String {
        WorkoutEvidenceAnalyzer.diagnostics(for: evidence)
    }
}
