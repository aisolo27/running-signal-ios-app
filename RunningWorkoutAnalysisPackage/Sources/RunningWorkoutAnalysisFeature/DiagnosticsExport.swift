import Foundation

private let rawDebugReviewPacketScopeMarkdown = """
## Review Packet Scope

This packet bundles Raw HealthKit Debug, WorkoutKit plan audit, HealthKit activity rows, Parity Lab candidate rows, structured comparison, fallback labels, pause/tail diagnostics, source metadata, and boundary warnings. It is debug/export-only and does not approve normal workout detail behavior.

Whole-run stats remain usable when custom interval rows are blocked. External HealthFit/FIT archives stay offline validation evidence; attach or reference them separately and do not treat FIT as app input or runtime truth.

Blocked custom interval diagnostics are review aids only. A supported Parity Lab status, readable fallback label, or exported candidate row does not change normal workout detail unless the exact ledger row separately reaches the normal-detail promotion rung.
"""

public enum DiagnosticsExport {
    private static var reviewPacketMetadata: ReviewPacketMetadata {
        ReviewPacketMetadata(
            scope: "debug/export-only",
            includedArtifacts: [
                "Raw HealthKit Debug",
                "WorkoutKit plan audit",
                "HealthKit workout activities",
                "Parity Lab candidate rows",
                "structured comparison summary",
                "fallback reason labels",
                "pause and tail diagnostics",
                "source metadata",
                "boundary source warnings",
                "blocked interval guardrails"
            ],
            externalEvidencePolicy: "External HealthFit/FIT archives are offline validation evidence only. Reference or attach them separately; RunSignal does not import or use FIT as runtime truth.",
            normalWorkoutUIChanged: false,
            usesFITRuntimeTruth: false,
            fitArchiveReference: "external-reference-only"
        )
    }

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

    public static func rawHealthKitDebugMarkdown(workout: CanonicalWorkout, generatedAt: Date = Date()) -> String {
        let evidence = workout.evidence
        let coverage = evidence.map(WorkoutEvidenceAnalyzer.coverage(for:))
        let reconstructedIntervals = evidence
            .flatMap { WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: $0) }
        let segmentMarkers = evidence.map {
            DerivedAnalyticsEngine.intervalCandidates(workout: workout, evidence: $0)
        } ?? []
        let plannedSteps = evidence?.workoutPlanAudit?.plannedSteps ?? []
        let payload = rawDebugPayload(
            workout: workout,
            evidence: evidence,
            coverage: coverage,
            reconstructedIntervals: reconstructedIntervals,
            segmentMarkers: segmentMarkers,
            generatedAt: generatedAt
        )

        return """
        # RunSignal Raw HealthKit Debug Export

        Generated: \(generatedAt.ISO8601Format())

        \(rawDebugReviewPacketScopeMarkdown)

        ## Workout

        | Field | Value |
        |---|---|
        | Workout ID | \(markdownCell(workout.id)) |
        | Source | \(markdownCell(workout.sourceName)) |
        | Source ID | \(markdownCell(workout.sourceID)) |
        | Device | \(markdownCell(workout.deviceName ?? "Unavailable")) |
        | Start | \(RunFormatters.date.string(from: workout.startDate)) |
        | End | \(RunFormatters.date.string(from: workout.endDate)) |
        | Duration | \(RunFormatters.duration(workout.durationSeconds)) |
        | Elapsed | \(RunFormatters.duration(workout.elapsedSeconds)) |
        | Distance | \(RunFormatters.distance(workout.distanceMeters)) |
        | Avg pace | \(RunFormatters.pace(workout.paceSecondsPerKm)) |
        | Avg HR | \(RunFormatters.number(workout.averageHeartRate, suffix: " bpm")) |
        | Max HR | \(RunFormatters.number(workout.maxHeartRate, suffix: " bpm")) |
        | Cadence | \(RunFormatters.number(workout.fullStepCadence, suffix: " spm")) |
        | Power | \(RunFormatters.number(workout.averagePower, suffix: " W")) |

        ## Evidence Counts

        | Metric | Count |
        |---|---:|
        \(evidenceCountRows(workout: workout, evidence: evidence))

        ## WorkoutKit Plan Audit

        \(workoutKitPlanAuditMarkdown(evidence?.workoutPlanAudit))

        ## Raw HKWorkoutEvent Inventory

        Debug-only inventory of public `HKWorkoutEvent` date windows and metadata keys. These rows are not Apple Fitness interval truth.

        \(rawEventInventoryMarkdown(evidence?.events ?? [], workout: workout, segmentMarkers: segmentMarkers))

        ## HKWorkoutActivity Inventory

        Debug-only inventory of public `HKWorkout.workoutActivities` rows. These rows are not used for production interval reconstruction.

        \(workoutActivityInventoryMarkdown(
            evidence?.activities ?? [],
            plannedSteps: plannedSteps,
            reconstructedIntervals: reconstructedIntervals,
            events: evidence?.events ?? [],
            segmentMarkers: segmentMarkers,
            workout: workout
        ))

        ## WorkoutKit Reconstructed Intervals

        Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

        \(reconstructedIntervalsMarkdown(reconstructedIntervals, workout: workout))

        ## HKWorkoutActivity Boundary Candidate Intervals

        Debug-only alternate reconstruction for Parity Lab exports. These rows are not production interval logic and are not shown in the normal workout UI.

        \(activityBoundaryCandidateMarkdown(
            activityBoundaryCandidate(
                plannedSteps: plannedSteps,
                activities: evidence?.activities ?? [],
                workout: workout
            )
        ))

        ## Custom Workout Candidate Rule Scorer

        Debug-only Parity Lab scorer for active-time duration, pause overlap, and Open / Extra tail rows. These rows are not production interval logic, are not shown in the normal workout UI, and do not approve a normal-detail gate.

        \(customWorkoutCandidateRuleMarkdown(
            customWorkoutCandidateRuleScore(
                activityCandidate: activityBoundaryCandidate(
                    plannedSteps: plannedSteps,
                    activities: evidence?.activities ?? [],
                    workout: workout
                ),
                events: evidence?.events ?? [],
                workout: workout
            )
        ))

        ## Custom Workout Structured Comparison

        Debug-only structured status and fallback taxonomy for Parity Lab rows. This status is not production interval logic, is not shown in the normal workout UI, and does not approve a normal-detail gate by itself.

        \(customWorkoutComparisonMarkdown(
            customWorkoutComparisonSummary(
                plannedSteps: plannedSteps,
                activities: evidence?.activities ?? [],
                workout: workout,
                events: evidence?.events ?? []
            )
        ))

        ## WorkoutKit Boundary Diagnostics

        \(boundaryDiagnosticsMarkdown(reconstructedIntervals, workout: workout))

        ## HealthKit Segment Markers

        Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

        \(segmentMarkersMarkdown(segmentMarkers))

        ## Planned Step Boundary Comparison

        Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

        \(plannedStepBoundaryComparisonMarkdown(
            reconstructedIntervals: reconstructedIntervals,
            plannedSteps: plannedSteps,
            events: evidence?.events ?? [],
            activities: evidence?.activities ?? [],
            segmentMarkers: segmentMarkers,
            workout: workout
        ))

        ## Boundary Source Warnings

        \(boundarySourceWarnings(
            events: evidence?.events ?? [],
            activities: evidence?.activities ?? [],
            reconstructedIntervals: reconstructedIntervals,
            segmentMarkers: segmentMarkers
        ).map { "- \($0)" }.joined(separator: "\n"))

        ## Evidence Caveats

        \(coverage?.caveats.isEmpty == false ? coverage!.caveats.map { "- \($0)" }.joined(separator: "\n") : "- None")

        ## JSON Payload

        ```json
        \(jsonPayload(payload))
        ```
        """
    }

    public static func parityPacketJSON(
        workout: CanonicalWorkout,
        forceReenrichResult: ParityForceReenrichResult?,
        generatedAt: Date = Date()
    ) -> String {
        let evidence = workout.evidence
        let coverage = evidence.map(WorkoutEvidenceAnalyzer.coverage(for:))
        let reconstructedIntervals = evidence
            .flatMap { WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: $0) }
        let segmentMarkers = evidence.map {
            DerivedAnalyticsEngine.intervalCandidates(workout: workout, evidence: $0)
        } ?? []
        let plannedSteps = evidence?.workoutPlanAudit?.plannedSteps ?? []
        let activityCandidate = activityBoundaryCandidate(
            plannedSteps: plannedSteps,
            activities: evidence?.activities ?? [],
            workout: workout
        )
        let candidateRuleScore = customWorkoutCandidateRuleScore(
            activityCandidate: activityCandidate,
            events: evidence?.events ?? [],
            workout: workout
        )
        let payload = ParityPacketPayload(
            packetVersion: 1,
            generatedAt: generatedAt.ISO8601Format(),
            reviewPacket: reviewPacketMetadata,
            workout: RawDebugWorkout(
                id: workout.id,
                sourceName: workout.sourceName,
                sourceID: workout.sourceID,
                deviceName: workout.deviceName,
                startDate: workout.startDate.ISO8601Format(),
                endDate: workout.endDate.ISO8601Format(),
                durationSeconds: workout.durationSeconds,
                elapsedSeconds: workout.elapsedSeconds,
                distanceMeters: workout.distanceMeters,
                paceSecondsPerKm: workout.paceSecondsPerKm,
                averageHeartRate: workout.averageHeartRate,
                maxHeartRate: workout.maxHeartRate,
                cadenceSpm: workout.fullStepCadence,
                averagePower: workout.averagePower
            ),
            cacheStatus: ParityPacketCacheStatus(
                hasCachedEvidence: evidence != nil,
                evidenceLoadedAt: evidence?.loadedAt.ISO8601Format(),
                evidenceSource: forceReenrichResult?.freshQueryReturnedWorkout == true ? "freshQuery" : (evidence == nil ? "missing" : "cachedState")
            ),
            forceReenrichResult: forceReenrichResult.map(ParityPacketForceReenrichResult.init(result:)),
            evidenceCounts: RawDebugEvidenceCounts(
                heartRate: workout.heartRateSampleCount,
                speed: workout.runningSpeedSampleCount,
                distance: workout.distanceSampleCount,
                activeEnergy: workout.activeEnergySampleCount,
                power: workout.runningPowerSampleCount,
                cadence: workout.cadenceSampleCount,
                stepCount: workout.stepCountSampleCount,
                strideLength: workout.strideLengthSampleCount,
                verticalOscillation: workout.verticalOscillationSampleCount,
                groundContact: workout.groundContactTimeSampleCount,
                routePoints: evidence?.route.count ?? workout.routePointCount,
                events: evidence?.events.count ?? workout.intervalCount,
                activities: evidence?.activities.count ?? 0
            ),
            rawWorkoutEvents: (evidence?.events ?? []).enumerated().map { offset, event in
                RawDebugWorkoutEvent(index: offset + 1, event: event, workout: workout, segmentMarkers: segmentMarkers)
            },
            workoutActivities: rawWorkoutActivities(
                evidence?.activities ?? [],
                plannedSteps: plannedSteps,
                reconstructedIntervals: reconstructedIntervals,
                events: evidence?.events ?? [],
                segmentMarkers: segmentMarkers,
                workout: workout
            ),
            workoutKitPlanAudit: evidence?.workoutPlanAudit.map(RawDebugPlanAudit.init(audit:)),
            reconstructedIntervals: reconstructedIntervals?.intervals.map { RawDebugReconstructedInterval(interval: $0, workout: workout) } ?? [],
            activityBoundaryCandidateSummary: activityCandidate.summary,
            activityBoundaryCandidateIntervals: activityCandidate.rows,
            customWorkoutCandidateRuleSummary: candidateRuleScore.summary,
            customWorkoutCandidateRuleRows: candidateRuleScore.rows,
            customWorkoutComparisonSummary: customWorkoutComparisonSummary(
                plannedSteps: plannedSteps,
                activities: evidence?.activities ?? [],
                workout: workout,
                events: evidence?.events ?? []
            ),
            plannedStepBoundaryComparisons: plannedStepBoundaryComparisons(
                reconstructedIntervals: reconstructedIntervals,
                plannedSteps: plannedSteps,
                events: evidence?.events ?? [],
                activities: evidence?.activities ?? [],
                segmentMarkers: segmentMarkers,
                workout: workout
            ),
            boundarySourceWarnings: boundarySourceWarnings(
                events: evidence?.events ?? [],
                activities: evidence?.activities ?? [],
                reconstructedIntervals: reconstructedIntervals,
                segmentMarkers: segmentMarkers
            ),
            diagnosticsWarnings: (coverage?.caveats ?? []) + (evidence?.diagnostics?.warnings ?? []),
            sourceNotes: reconstructedIntervals?.notes ?? []
        )
        return jsonPayload(payload)
    }

    private static func evidenceCountRows(workout: CanonicalWorkout, evidence: WorkoutEvidence?) -> String {
        let rows = [
            ("Heart rate", workout.heartRateSampleCount),
            ("Speed", workout.runningSpeedSampleCount),
            ("Distance", workout.distanceSampleCount),
            ("Active energy", workout.activeEnergySampleCount),
            ("Power", workout.runningPowerSampleCount),
            ("Cadence", workout.cadenceSampleCount),
            ("Step count", workout.stepCountSampleCount),
            ("Stride length", workout.strideLengthSampleCount),
            ("Vertical oscillation", workout.verticalOscillationSampleCount),
            ("Ground contact", workout.groundContactTimeSampleCount),
            ("Route points", evidence?.route.count ?? workout.routePointCount),
            ("Events", evidence?.events.count ?? workout.intervalCount),
            ("Workout activities", evidence?.activities.count ?? 0)
        ]
        return rows.map { "| \($0.0) | \($0.1) |" }.joined(separator: "\n")
    }

    private static func workoutKitPlanAuditMarkdown(_ audit: WorkoutPlanAudit?) -> String {
        guard let audit else { return "- Not audited" }
        var lines = [
            "- Status: \(audit.status.label)",
            "- Plan type: \(audit.planType ?? "Unavailable")",
            "- Plan ID: \(audit.planID ?? "Unavailable")",
            "- Display name: \(audit.displayName ?? "Unavailable")"
        ]
        if let errorMessage = audit.errorMessage {
            lines.append("- Error: \(errorMessage)")
        }
        if audit.summaryLines.isEmpty {
            lines.append("- Public plan fields: unavailable")
        } else {
            lines.append(contentsOf: audit.summaryLines.map { "- \($0)" })
        }
        return lines.joined(separator: "\n")
    }

    private static func reconstructedIntervalsMarkdown(
        _ result: WorkoutIntervalReconstructionResult?,
        workout: CanonicalWorkout
    ) -> String {
        guard let result, !result.intervals.isEmpty else {
            return "Unavailable. Whole-run stats remain safe to review, but custom interval rows need a supported public WorkoutKit and HealthKit evidence pattern before RunSignal can show them."
        }

        let rows = result.intervals.map { interval in
            [
                "\(interval.index)",
                markdownCell(interval.label),
                markdownCell(interval.plannedGoalDisplayText),
                markdownCell(interval.plannedTargetDisplayText ?? "Target unavailable"),
                RunFormatters.distance(interval.actualDistanceMeters),
                RunFormatters.duration(interval.elapsedRowWindowDurationSeconds),
                optionalSeconds(interval.pauseOverlapSeconds),
                interval.activeDurationSeconds.map(RunFormatters.duration) ?? "Unavailable",
                RunFormatters.duration(interval.displayDurationSeconds),
                markdownCell((interval.durationDisplayRule ?? ReconstructedIntervalDurationDisplayRule.elapsedRowWindow).rawValue),
                RunFormatters.pace(interval.actualPaceSecondsPerKm),
                RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"),
                RunFormatters.number(interval.maxHeartRateBpm, suffix: " bpm"),
                RunFormatters.number(interval.averagePower, suffix: " W"),
                RunFormatters.duration(interval.actualStartDate.timeIntervalSince(workout.startDate)),
                RunFormatters.duration(interval.actualEndDate.timeIntervalSince(workout.startDate)),
                markdownCell(interval.boundaryStrategy?.label ?? ""),
                optionalSeconds(interval.boundaryAdjustmentSeconds),
                optionalMeters(interval.boundaryOvershootMeters),
                interval.confidence.label,
                markdownCell(interval.sourceNote)
            ].joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        | Row | Label | Goal | Target | Distance | Elapsed | Pause overlap | Active time | Display time | Duration rule | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
        |---:|---|---|---|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
        \(rows)

        Notes: \(result.notes.map(markdownCell).joined(separator: " · "))
        """
    }

    private static func activityBoundaryCandidateMarkdown(_ candidate: RawDebugActivityBoundaryCandidate) -> String {
        let summary = candidate.summary
        let summaryTable = """
        | Field | Value |
        |---|---|
        | Mapping status | \(markdownCell(summary.mappingStatus)) |
        | Activity count | \(summary.activityCount) |
        | Planned step count | \(summary.plannedStepCount) |
        | Scoreable | \(summary.isScoreable ? "Yes" : "No") |
        | Not scoreable reason | \(markdownCell(summary.notScoreableReason ?? "n/a")) |
        | Production UI warning | \(markdownCell(summary.productionUIWarning)) |
        """

        guard !candidate.rows.isEmpty else {
            return """
            \(summaryTable)

            No activity-boundary candidate rows were produced.

            Caveats: \(summary.caveats.map(markdownCell).joined(separator: " · "))
            """
        }

        let rows = candidate.rows.map { row -> String in
            [
                "\(row.index)",
                markdownCell(row.label),
                markdownCell(row.plannedGoalDisplayText),
                markdownCell(row.mappingStatus),
                row.activityIndex.map(String.init) ?? "Inferred",
                row.startOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                row.endOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                row.distanceMeters.map(optionalMeters) ?? "Unavailable",
                row.durationSeconds.map(optionalSeconds) ?? "Unavailable",
                markdownCell(row.candidateConfidence),
                markdownCell(row.notScoreableReason ?? ""),
                markdownCell(row.caveats.joined(separator: " "))
            ].joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        \(summaryTable)

        | Row | Label | Goal | Mapping | Activity | Start Offset | End Offset | Distance | Time | Candidate Confidence | Reason If Not Scoreable | Caveats |
        |---:|---|---|---|---:|---:|---:|---:|---:|---|---|---|
        \(rows)

        Caveats: \(summary.caveats.map(markdownCell).joined(separator: " · "))
        """
    }

    private static func customWorkoutCandidateRuleMarkdown(_ score: RawDebugCustomWorkoutCandidateRuleScore) -> String {
        let summary = score.summary
        let summaryTable = """
        | Field | Value |
        |---|---|
        | Strategy | \(markdownCell(summary.strategyID)) |
        | Rule status | \(markdownCell(summary.ruleStatus)) |
        | Candidate row count | \(summary.candidateRowCount) |
        | Planned expanded row count | \(summary.plannedExpandedRowCount) |
        | Open tail row count | \(summary.openTailRowCount) |
        | Paired pause count | \(summary.pairedPauseCount) |
        | Total paired pause | \(optionalSeconds(summary.totalPairedPauseSeconds)) |
        | Fixed row exhaustion | \(markdownCell(summary.fixedRowExhaustionStatus)) |
        | Tail status | \(markdownCell(summary.tailStatus)) |
        | Tail duration | \(summary.tailElapsedDurationSeconds.map(optionalSeconds) ?? "Unavailable") |
        | Tail distance | \(summary.tailDistanceMeters.map(optionalMeters) ?? "Unavailable") |
        | Fallback reasons | \(markdownCell(summary.fallbackReasons.joined(separator: " "))) |
        | Safety flags | \(markdownCell(summary.safetyFlags.joined(separator: " "))) |
        | FIT validation | \(markdownCell(summary.fitValidationStatus)) |
        | Scoreable | \(summary.isScoreable ? "Yes" : "No") |
        | Not scoreable reason | \(markdownCell(summary.notScoreableReason ?? "n/a")) |
        | Production UI warning | \(markdownCell(summary.productionUIWarning)) |
        """

        guard !score.rows.isEmpty else {
            return """
            \(summaryTable)

            No custom-workout candidate rule rows were produced.

            Caveats: \(summary.caveats.map(markdownCell).joined(separator: " · "))
            """
        }

        let rows = score.rows.map { row -> String in
            [
                "\(row.index)",
                markdownCell(row.label),
                markdownCell(row.mappingStatus),
                row.startOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                row.endOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                row.elapsedDurationSeconds.map(optionalSeconds) ?? "Unavailable",
                optionalSeconds(row.pauseOverlapSeconds),
                row.activeDurationSeconds.map(optionalSeconds) ?? "Unavailable",
                row.distanceMeters.map(optionalMeters) ?? "Unavailable",
                markdownCell(row.durationDisplayRule),
                markdownCell(row.durationRule),
                markdownCell(row.candidateConfidence),
                markdownCell(row.caveats.joined(separator: " "))
            ].joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        \(summaryTable)

        | Row | Label | Mapping | Start offset | End offset | Elapsed | Pause overlap | Active time | Distance | Display rule | Duration rule | Confidence | Caveats |
        |---:|---|---|---:|---:|---:|---:|---:|---:|---|---|---|---|
        \(rows)

        Caveats: \(summary.caveats.map(markdownCell).joined(separator: " · "))
        """
    }

    private static func customWorkoutComparisonMarkdown(_ summary: RawDebugCustomWorkoutComparisonSummary) -> String {
        """
        | Field | Value |
        |---|---|
        | Status | \(markdownCell(summary.status)) |
        | Status label | \(markdownCell(summary.statusLabel)) |
        | Fallback reasons | \(markdownCell(summary.fallbackReasonLabels.isEmpty ? "None" : summary.fallbackReasonLabels.joined(separator: ", "))) |
        | Primary fallback | \(markdownCell(summary.primaryFallbackReasonLabel ?? "None")) |
        | Row count | \(summary.rowCount) |
        | Row confidences | \(markdownCell(summary.rowConfidences.isEmpty ? "None" : summary.rowConfidences.joined(separator: ", "))) |
        | Tail ambiguity | \(markdownCell(summary.tailAmbiguity)) |
        | Promotes production behavior | \(summary.promotesProductionBehavior ? "Yes" : "No") |
        | Scope | \(markdownCell(summary.scope)) |
        | Normal workout UI changed | \(summary.normalWorkoutUIChanged ? "Yes" : "No") |
        | Uses FIT runtime truth | \(summary.usesFITRuntimeTruth ? "Yes" : "No") |
        """
    }

    private static func segmentMarkersMarkdown(_ intervals: [DerivedWorkoutInterval]) -> String {
        guard !intervals.isEmpty else {
            return "Unavailable. RunSignal did not find usable HealthKit event windows with enough evidence to inspect segment markers."
        }

        let rows = intervals.map { interval in
            [
                "\(interval.index)",
                markdownCell(interval.label.displayName),
                markdownCell(interval.markerKind.displayName),
                markdownCell(interval.source.displayName),
                RunFormatters.distance(interval.distanceMeters),
                RunFormatters.duration(interval.durationSeconds),
                RunFormatters.pace(interval.paceSecondsPerKm),
                RunFormatters.number(interval.averageHeartRateBpm, suffix: " bpm"),
                RunFormatters.duration(interval.startOffsetSeconds),
                RunFormatters.duration(interval.endOffsetSeconds),
                interval.confidence.label,
                markdownCell(interval.caveats.joined(separator: " "))
            ].joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        | Row | Label | Marker Kind | Source | Distance | Time | Pace | Avg HR | Start Offset | End Offset | Confidence | Caveats |
        |---:|---|---|---|---:|---:|---:|---:|---:|---:|---|---|
        \(rows)
        """
    }

    private static func rawEventInventoryMarkdown(
        _ events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout,
        segmentMarkers: [DerivedWorkoutInterval]
    ) -> String {
        guard !events.isEmpty else {
            return "Unavailable. No raw `HKWorkoutEvent` records were captured for this workout."
        }

        let rows = events.enumerated().map { offset, event -> String in
            let matchingMarker = exactSegmentMarker(for: event, segmentMarkers: segmentMarkers)
            let used = matchingMarker != nil
            let markerWindow = matchingMarker.map {
                "\(RunFormatters.duration($0.startOffsetSeconds))-\(RunFormatters.duration($0.endOffsetSeconds))"
            } ?? "Unavailable"
            let markerDistance = matchingMarker.map { RunFormatters.distance($0.distanceMeters) } ?? "Unavailable"
            let markerKind = matchingMarker.map { $0.markerKind.displayName } ?? "Unavailable"
            let debugOnlyReason = matchingMarker == nil
                ? "No rendered segment marker candidate."
                : "HealthKit segment markers are raw/debug-only and not Apple Fitness interval truth."
            let exclusionReason: String
            if used {
                exclusionReason = ""
            } else if event.endDate <= event.startDate {
                exclusionReason = "Excluded from segment rendering: zero or negative duration."
            } else if event.startDate < workout.startDate || event.endDate > workout.endDate.addingTimeInterval(1) {
                exclusionReason = "Excluded from segment rendering: outside workout bounds."
            } else {
                exclusionReason = "Excluded from segment rendering: no derived segment marker was produced."
            }
            return [
                "\(offset + 1)",
                markdownCell(event.type),
                optionalLabel(event.label),
                RunFormatters.duration(event.startDate.timeIntervalSince(workout.startDate)),
                RunFormatters.duration(event.endDate.timeIntervalSince(workout.startDate)),
                optionalSeconds(event.endDate.timeIntervalSince(event.startDate)),
                markdownCell(emptyToNil((event.metadataKeys ?? []).joined(separator: ", ")) ?? "Unavailable"),
                markdownCell(markerWindow),
                markerDistance,
                markdownCell(markerKind),
                used ? "Yes" : "No",
                markdownCell(exclusionReason),
                markdownCell(debugOnlyReason)
            ].joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        | Row | Event Type | Label | Start Offset | End Offset | Duration | Metadata Keys | Rendered Marker Window | Marker Distance | Marker Kind | Used By Segment Rendering | Excluded / Filtered Reason | Debug-Only Reason |
        |---:|---|---|---:|---:|---:|---|---:|---:|---|---|---|---|
        \(rows)
        """
    }

    private static func workoutActivityInventoryMarkdown(
        _ activities: [WorkoutEvidenceActivity],
        plannedSteps: [PlannedWorkoutStep],
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        events: [WorkoutEvidenceEvent],
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) -> String {
        let rawActivities = rawWorkoutActivities(
            activities,
            plannedSteps: plannedSteps,
            reconstructedIntervals: reconstructedIntervals,
            events: events,
            segmentMarkers: segmentMarkers,
            workout: workout
        )
        guard !rawActivities.isEmpty else {
            return "Unavailable. No public `HKWorkoutActivity` records were captured for this workout."
        }

        let rows = rawActivities.map { activity -> String in
            let cells: [String] = [
                "\(activity.index)",
                markdownCell(activity.activityType),
                markdownCell(activity.startDate),
                markdownCell(activity.endDate ?? "Unavailable"),
                optionalSeconds(activity.startOffsetSeconds),
                activity.endOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                optionalSeconds(activity.durationSeconds),
                markdownCell(emptyToNil(activity.metadataKeys.joined(separator: ", ")) ?? "Unavailable"),
                markdownCell(activity.eventsSummary),
                markdownCell(activity.statisticsSummary),
                activity.alignsWithPlannedStep ? "Yes" : "No",
                markdownCell(activity.alignedPlannedStepLabel ?? "Unavailable"),
                markdownCell(activity.nearestReconstructedIntervalLabel ?? "Unavailable"),
                activity.nearestReconstructedIntervalEndDeltaSeconds.map(optionalSeconds) ?? "",
                markdownCell(activity.appleFitnessManualRowReference),
                markdownCell(activity.fitLapReference),
                activity.nearestRawEventStartOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                activity.nearestRawEventStartDeltaSeconds.map(optionalSeconds) ?? "",
                activity.nearestRawEventEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                activity.nearestRawEventEndDeltaSeconds.map(optionalSeconds) ?? "",
                activity.nearestSegmentMarkerStartOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                activity.nearestSegmentMarkerStartDeltaSeconds.map(optionalSeconds) ?? "",
                activity.nearestSegmentMarkerEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                activity.nearestSegmentMarkerEndDeltaSeconds.map(optionalSeconds) ?? "",
                activity.previousDistanceSampleEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                activity.crossingDistanceSampleEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                activity.nextDistanceSampleEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable"
            ]
            return cells.joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        | Activity | Type | Start Date | End Date | Start Offset | End Offset | Duration | Metadata Keys | Nested Events | Statistics | Aligns Planned Step | Aligned Planned Step | Nearest Reconstructed Row | Row End Delta | Apple Fitness/manual | FIT Lap | Raw Event Start | Raw Start Delta | Raw Event End | Raw End Delta | Segment Start | Segment Start Delta | Segment End | Segment End Delta | Previous Sample End | Crossing Sample End | Next Sample End |
        |---:|---|---|---|---:|---:|---:|---|---|---|---|---|---|---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|---:|
        \(rows)
        """
    }

    private static func plannedStepBoundaryComparisonMarkdown(
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        plannedSteps: [PlannedWorkoutStep],
        events: [WorkoutEvidenceEvent],
        activities: [WorkoutEvidenceActivity],
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) -> String {
        let comparisons = plannedStepBoundaryComparisons(
            reconstructedIntervals: reconstructedIntervals,
            plannedSteps: plannedSteps,
            events: events,
            activities: activities,
            segmentMarkers: segmentMarkers,
            workout: workout
        )
        guard !comparisons.isEmpty else {
            return "Unavailable. No reconstructed WorkoutKit rows are available for boundary comparison."
        }

        let rows = comparisons.map { comparison -> String in
            let cells: [String] = [
                "\(comparison.index)",
                markdownCell(comparison.plannedStepLabel ?? comparison.reconstructedLabel),
                markdownCell(comparison.plannedGoalDisplayText),
                optionalSeconds(comparison.reconstructedEndOffsetSeconds),
                comparison.fitLapEndOffsetSeconds.map(optionalSeconds) ?? "Manual FIT placeholder",
                comparison.nearestRawEventEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                comparison.nearestRawEventEndDeltaSeconds.map(optionalSeconds) ?? "",
                comparison.nearestWorkoutActivityEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                comparison.nearestWorkoutActivityEndDeltaSeconds.map(optionalSeconds) ?? "",
                markdownCell(comparison.nearestWorkoutActivityType ?? "Unavailable"),
                comparison.nearestSegmentMarkerEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                comparison.nearestSegmentMarkerEndDeltaSeconds.map(optionalSeconds) ?? "",
                comparison.previousDistanceSampleEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                comparison.crossingDistanceSampleEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                comparison.nextDistanceSampleEndOffsetSeconds.map(optionalSeconds) ?? "Unavailable",
                markdownCell(comparison.warning ?? "")
            ]
            return cells.joined(separator: " | ")
        }.map { "| \($0) |" }.joined(separator: "\n")

        return """
        | Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Activity End | Activity Delta | Activity Type | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
        |---:|---|---|---:|---:|---:|---:|---:|---:|---|---:|---:|---:|---:|---:|---|
        \(rows)
        """
    }

    private static func boundaryDiagnosticsMarkdown(
        _ result: WorkoutIntervalReconstructionResult?,
        workout: CanonicalWorkout
    ) -> String {
        guard let result, !result.intervals.isEmpty else {
            return "Unavailable. No reconstructed intervals available for boundary diagnostics."
        }

        var sections: [String] = []
        let distanceRows = result.intervals.compactMap { interval -> String? in
            guard let diagnostics = interval.boundaryDiagnostics else { return nil }
            return """
            ### Row \(interval.index): \(markdownCell(interval.label))

            | Field | Value |
            |---|---:|
            | Target distance | \(optionalMeters(diagnostics.targetDistanceMeters)) |
            | Start offset | \(RunFormatters.duration(interval.actualStartDate.timeIntervalSince(workout.startDate))) |
            | End offset | \(RunFormatters.duration(interval.actualEndDate.timeIntervalSince(workout.startDate))) |
            | Boundary strategy | \(markdownCell(interval.boundaryStrategy?.label ?? "Unavailable")) |
            | Boundary adjustment | \(optionalSeconds(interval.boundaryAdjustmentSeconds)) |
            | Overshoot | \(optionalMeters(interval.boundaryOvershootMeters)) |
            | Cumulative distance at start | \(optionalMeters(diagnostics.cumulativeDistanceAtStartMeters)) |
            | Cumulative distance at end | \(optionalMeters(diagnostics.cumulativeDistanceAtEndMeters)) |
            | Interpolation fraction | \(diagnostics.interpolationFraction.map { String(format: "%.3f", $0) } ?? "Unavailable") |

            | Boundary sample | Start offset | End offset | Start cumulative | End cumulative |
            |---|---:|---:|---:|---:|
            \(sampleRow("Previous", diagnostics.previousSample, workout: workout))
            \(sampleRow("Crossing", diagnostics.crossingSample, workout: workout))
            \(sampleRow("Next", diagnostics.nextSample, workout: workout))
            """
        }
        sections.append(contentsOf: distanceRows)

        let tailRows = result.intervals.compactMap { interval -> String? in
            guard let diagnostics = interval.tailDiagnostics else { return nil }
            return """
            ### Row \(interval.index): \(markdownCell(interval.label)) Tail

            | Field | Value |
            |---|---:|
            | Planned final step end offset | \(RunFormatters.duration(diagnostics.plannedFinalStepEndDate.timeIntervalSince(workout.startDate))) |
            | Workout end offset | \(RunFormatters.duration(diagnostics.workoutEndDate.timeIntervalSince(workout.startDate))) |
            | Remaining seconds | \(optionalSeconds(diagnostics.remainingSeconds)) |
            | Remaining meters | \(optionalMeters(diagnostics.remainingMeters)) |
            | Final distance sample offset | \(optionalOffset(diagnostics.finalDistanceSampleDate, workout: workout)) |
            | Final distance sample cumulative | \(optionalMeters(diagnostics.finalDistanceSampleCumulativeDistanceMeters)) |
            | Last HR sample offset | \(optionalOffset(diagnostics.lastHeartRateSampleDate, workout: workout)) |
            | Last power sample offset | \(optionalOffset(diagnostics.lastPowerSampleDate, workout: workout)) |
            | Last cadence sample offset | \(optionalOffset(diagnostics.lastCadenceSampleDate, workout: workout)) |
            | Reason | \(markdownCell(diagnostics.creationReason)) |
            """
        }
        sections.append(contentsOf: tailRows)

        return sections.isEmpty ? "No distance-goal boundaries or Open / Extra tail diagnostics were generated." : sections.joined(separator: "\n\n")
    }

    private static func sampleRow(_ label: String, _ sample: DistanceBoundarySample?, workout: CanonicalWorkout) -> String {
        guard let sample else {
            return "| \(label) | Unavailable | Unavailable | Unavailable | Unavailable |"
        }
        return [
            label,
            RunFormatters.duration(sample.startDate.timeIntervalSince(workout.startDate)),
            RunFormatters.duration(sample.endDate.timeIntervalSince(workout.startDate)),
            optionalMeters(sample.startCumulativeDistanceMeters),
            optionalMeters(sample.endCumulativeDistanceMeters)
        ].joined(separator: " | ").withMarkdownTablePipes()
    }

    private static func rawDebugPayload(
        workout: CanonicalWorkout,
        evidence: WorkoutEvidence?,
        coverage: WorkoutEvidenceCoverage?,
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        segmentMarkers: [DerivedWorkoutInterval],
        generatedAt: Date
    ) -> RawDebugPayload {
        let plannedSteps = evidence?.workoutPlanAudit?.plannedSteps ?? []
        let activityCandidate = activityBoundaryCandidate(
            plannedSteps: plannedSteps,
            activities: evidence?.activities ?? [],
            workout: workout
        )
        let candidateRuleScore = customWorkoutCandidateRuleScore(
            activityCandidate: activityCandidate,
            events: evidence?.events ?? [],
            workout: workout
        )
        return RawDebugPayload(
            generatedAt: generatedAt.ISO8601Format(),
            reviewPacket: reviewPacketMetadata,
            workout: RawDebugWorkout(
                id: workout.id,
                sourceName: workout.sourceName,
                sourceID: workout.sourceID,
                deviceName: workout.deviceName,
                startDate: workout.startDate.ISO8601Format(),
                endDate: workout.endDate.ISO8601Format(),
                durationSeconds: workout.durationSeconds,
                elapsedSeconds: workout.elapsedSeconds,
                distanceMeters: workout.distanceMeters,
                paceSecondsPerKm: workout.paceSecondsPerKm,
                averageHeartRate: workout.averageHeartRate,
                maxHeartRate: workout.maxHeartRate,
                cadenceSpm: workout.fullStepCadence,
                averagePower: workout.averagePower
            ),
            evidenceCounts: RawDebugEvidenceCounts(
                heartRate: workout.heartRateSampleCount,
                speed: workout.runningSpeedSampleCount,
                distance: workout.distanceSampleCount,
                activeEnergy: workout.activeEnergySampleCount,
                power: workout.runningPowerSampleCount,
                cadence: workout.cadenceSampleCount,
                stepCount: workout.stepCountSampleCount,
                strideLength: workout.strideLengthSampleCount,
                verticalOscillation: workout.verticalOscillationSampleCount,
                groundContact: workout.groundContactTimeSampleCount,
                routePoints: evidence?.route.count ?? workout.routePointCount,
                events: evidence?.events.count ?? workout.intervalCount,
                activities: evidence?.activities.count ?? 0
            ),
            rawWorkoutEvents: (evidence?.events ?? []).enumerated().map { offset, event in
                RawDebugWorkoutEvent(index: offset + 1, event: event, workout: workout, segmentMarkers: segmentMarkers)
            },
            workoutActivities: rawWorkoutActivities(
                evidence?.activities ?? [],
                plannedSteps: plannedSteps,
                reconstructedIntervals: reconstructedIntervals,
                events: evidence?.events ?? [],
                segmentMarkers: segmentMarkers,
                workout: workout
            ),
            workoutKitPlanAudit: evidence?.workoutPlanAudit.map(RawDebugPlanAudit.init(audit:)),
            reconstructedIntervals: reconstructedIntervals?.intervals.map { RawDebugReconstructedInterval(interval: $0, workout: workout) } ?? [],
            activityBoundaryCandidateSummary: activityCandidate.summary,
            activityBoundaryCandidateIntervals: activityCandidate.rows,
            customWorkoutCandidateRuleSummary: candidateRuleScore.summary,
            customWorkoutCandidateRuleRows: candidateRuleScore.rows,
            customWorkoutComparisonSummary: customWorkoutComparisonSummary(
                plannedSteps: plannedSteps,
                activities: evidence?.activities ?? [],
                workout: workout,
                events: evidence?.events ?? []
            ),
            boundaryDiagnostics: reconstructedIntervals?.intervals.map { RawDebugIntervalBoundaryDiagnostics(interval: $0, workout: workout) }.filter { $0.hasDiagnostics } ?? [],
            segmentMarkers: segmentMarkers.map(RawDebugSegmentMarker.init(interval:)),
            plannedStepBoundaryComparisons: plannedStepBoundaryComparisons(
                reconstructedIntervals: reconstructedIntervals,
                plannedSteps: plannedSteps,
                events: evidence?.events ?? [],
                activities: evidence?.activities ?? [],
                segmentMarkers: segmentMarkers,
                workout: workout
            ),
            boundarySourceWarnings: boundarySourceWarnings(
                events: evidence?.events ?? [],
                activities: evidence?.activities ?? [],
                reconstructedIntervals: reconstructedIntervals,
                segmentMarkers: segmentMarkers
            ),
            sourceNotes: reconstructedIntervals?.notes ?? [],
            caveats: coverage?.caveats ?? []
        )
    }

    private static func plannedStepBoundaryComparisons(
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        plannedSteps: [PlannedWorkoutStep],
        events: [WorkoutEvidenceEvent],
        activities: [WorkoutEvidenceActivity],
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) -> [RawDebugPlannedStepBoundaryComparison] {
        guard let intervals = reconstructedIntervals?.intervals, !intervals.isEmpty else { return [] }
        return intervals.map { interval in
            let rowEndOffset = interval.actualEndDate.timeIntervalSince(workout.startDate)
            let nearestEvent = nearestRawEvent(to: interval.actualEndDate, events: events, workout: workout)
            let nearestActivity = nearestWorkoutActivityEnd(to: interval.actualEndDate, activities: activities, workout: workout)
            let nearestMarker = nearestSegmentMarker(to: interval.actualEndDate, segmentMarkers: segmentMarkers)
            let plannedStep = plannedSteps.first { $0.index == interval.index }
            let warning: String?
            if events.isEmpty {
                warning = "No raw HKWorkoutEvent records exist for this workout."
            } else if nearestEvent == nil {
                warning = "No raw HKWorkoutEvent boundary candidate is available for this row."
            } else if let delta = nearestEvent?.deltaSeconds, abs(delta) > 3 {
                warning = "Nearest raw HKWorkoutEvent end is more than 3 seconds from the reconstructed row end."
            } else {
                warning = nil
            }

            return RawDebugPlannedStepBoundaryComparison(
                index: interval.index,
                plannedStepLabel: plannedStep?.label,
                reconstructedLabel: interval.label,
                plannedGoalDisplayText: interval.plannedGoalDisplayText,
                reconstructedEndOffsetSeconds: rowEndOffset,
                fitLapEndOffsetSeconds: nil,
                nearestRawEventStartOffsetSeconds: nearestEvent?.event.startDate.timeIntervalSince(workout.startDate),
                nearestRawEventEndOffsetSeconds: nearestEvent?.event.endDate.timeIntervalSince(workout.startDate),
                nearestRawEventEndDeltaSeconds: nearestEvent?.deltaSeconds,
                nearestRawEventType: nearestEvent?.event.type,
                nearestWorkoutActivityStartOffsetSeconds: nearestActivity?.activity.startDate.timeIntervalSince(workout.startDate),
                nearestWorkoutActivityEndOffsetSeconds: nearestActivity?.activity.endDate?.timeIntervalSince(workout.startDate),
                nearestWorkoutActivityEndDeltaSeconds: nearestActivity?.deltaSeconds,
                nearestWorkoutActivityType: nearestActivity?.activity.activityType,
                nearestSegmentMarkerStartOffsetSeconds: nearestMarker?.marker.startOffsetSeconds,
                nearestSegmentMarkerEndOffsetSeconds: nearestMarker?.marker.endOffsetSeconds,
                nearestSegmentMarkerEndDeltaSeconds: nearestMarker?.deltaSeconds,
                nearestSegmentMarkerKind: nearestMarker?.marker.markerKind.rawValue,
                previousDistanceSampleEndOffsetSeconds: interval.boundaryDiagnostics?.previousSample?.endDate.timeIntervalSince(workout.startDate),
                crossingDistanceSampleEndOffsetSeconds: interval.boundaryDiagnostics?.crossingSample?.endDate.timeIntervalSince(workout.startDate),
                nextDistanceSampleEndOffsetSeconds: interval.boundaryDiagnostics?.nextSample?.endDate.timeIntervalSince(workout.startDate),
                warning: warning
            )
        }
    }

    private static func rawWorkoutActivities(
        _ activities: [WorkoutEvidenceActivity],
        plannedSteps: [PlannedWorkoutStep],
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        events: [WorkoutEvidenceEvent],
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) -> [RawDebugWorkoutActivity] {
        activities.enumerated().map { offset, activity in
            RawDebugWorkoutActivity(
                index: offset + 1,
                activity: activity,
                plannedSteps: plannedSteps,
                reconstructedIntervals: reconstructedIntervals,
                events: events,
                segmentMarkers: segmentMarkers,
                workout: workout
            )
        }
    }

    private static func activityBoundaryCandidate(
        plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout
    ) -> RawDebugActivityBoundaryCandidate {
        let baseCaveats = [
            "debug-only, not promoted",
            "not production interval logic",
            "not shown in normal workout UI",
            "FIT and Apple Fitness/manual rows are not runtime inputs"
        ]
        let productionWarning = "HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI."

        guard !plannedSteps.isEmpty else {
            return RawDebugActivityBoundaryCandidate(
                summary: RawDebugActivityBoundaryCandidateSummary(
                    mappingStatus: "activity mapping ambiguous",
                    activityCount: activities.count,
                    plannedStepCount: 0,
                    isScoreable: false,
                    notScoreableReason: "WorkoutKit planned steps are missing.",
                    candidateConfidence: "activity mapping ambiguous",
                    caveats: baseCaveats,
                    productionUIWarning: productionWarning
                ),
                rows: []
            )
        }

        guard !activities.isEmpty else {
            return RawDebugActivityBoundaryCandidate(
                summary: RawDebugActivityBoundaryCandidateSummary(
                    mappingStatus: "activity missing",
                    activityCount: 0,
                    plannedStepCount: plannedSteps.count,
                    isScoreable: false,
                    notScoreableReason: "HKWorkoutActivity rows are missing.",
                    candidateConfidence: "activity missing",
                    caveats: baseCaveats,
                    productionUIWarning: productionWarning
                ),
                rows: []
            )
        }

        guard activities.count <= plannedSteps.count else {
            return RawDebugActivityBoundaryCandidate(
                summary: RawDebugActivityBoundaryCandidateSummary(
                    mappingStatus: "activity/planned-step count mismatch",
                    activityCount: activities.count,
                    plannedStepCount: plannedSteps.count,
                    isScoreable: false,
                    notScoreableReason: "HKWorkoutActivity row count does not match WorkoutKit planned step count.",
                    candidateConfidence: "activity/planned-step count mismatch",
                    caveats: baseCaveats,
                    productionUIWarning: productionWarning
                ),
                rows: []
            )
        }

        for index in activities.indices {
            let activity = activities[index]
            guard let endDate = activity.endDate, endDate > activity.startDate else {
                return RawDebugActivityBoundaryCandidate(
                    summary: RawDebugActivityBoundaryCandidateSummary(
                        mappingStatus: "activity mapping ambiguous",
                        activityCount: activities.count,
                        plannedStepCount: plannedSteps.count,
                        isScoreable: false,
                        notScoreableReason: "HKWorkoutActivity row \(index + 1) is missing a completed positive-duration end boundary.",
                        candidateConfidence: "activity mapping ambiguous",
                        caveats: baseCaveats,
                        productionUIWarning: productionWarning
                    ),
                    rows: []
                )
            }
            if index > 0 {
                let previous = activities[index - 1]
                if let previousEnd = previous.endDate, abs(activity.startDate.timeIntervalSince(previousEnd)) > 1 {
                    return RawDebugActivityBoundaryCandidate(
                        summary: RawDebugActivityBoundaryCandidateSummary(
                            mappingStatus: "activity mapping ambiguous",
                            activityCount: activities.count,
                            plannedStepCount: plannedSteps.count,
                            isScoreable: false,
                            notScoreableReason: "HKWorkoutActivity row \(index + 1) is not contiguous with the prior activity.",
                            candidateConfidence: "activity mapping ambiguous",
                            caveats: baseCaveats,
                            productionUIWarning: productionWarning
                        ),
                        rows: []
                    )
                }
            }
        }

        let isCompletedPrefix = activities.count < plannedSteps.count
        let resolvedPlannedSteps = Array(plannedSteps.prefix(activities.count))
        let plannedRows = zip(resolvedPlannedSteps, activities).enumerated().map { offset, pair -> RawDebugActivityBoundaryCandidateInterval in
            let (step, activity) = pair
            let distance = activityDistanceMeters(activity)
            let duration = activity.endDate?.timeIntervalSince(activity.startDate) ?? activity.durationSeconds
            let rowCaveats = [
                "Mapped to WorkoutKit planned step order only.",
                "Uses public HKWorkoutActivity statistics and date windows."
            ]
            return RawDebugActivityBoundaryCandidateInterval(
                index: step.index,
                label: step.label,
                stepType: step.stepType.rawValue,
                plannedGoalType: step.plannedGoalType.rawValue,
                plannedGoalValue: step.plannedGoalValue,
                plannedGoalDisplayText: step.plannedGoalDisplayText,
                activityIndex: offset + 1,
                mappingStatus: isCompletedPrefix ? "mappedCompletedPrefixByPlannedStepOrder" : "mappedByPlannedStepOrder",
                startOffsetSeconds: activity.startDate.timeIntervalSince(workout.startDate),
                endOffsetSeconds: activity.endDate?.timeIntervalSince(workout.startDate),
                durationSeconds: duration,
                distanceMeters: distance,
                candidateConfidence: distance == nil ? "activity mapping ambiguous" : "activity boundary direct",
                caveats: distance == nil ? rowCaveats + ["Activity distance statistic is unavailable."] : rowCaveats,
                notScoreableReason: distance == nil ? "Activity distance statistic is unavailable." : nil,
                productionUIWarning: productionWarning
            )
        }

        let scoreablePlannedRows = plannedRows.allSatisfy { $0.notScoreableReason == nil }
        let totalActivityDistance = plannedRows.compactMap(\.distanceMeters).reduce(0, +)
        var rows = plannedRows
        if activities.count == plannedSteps.count,
           let lastActivity = activities.last,
           let lastActivityEnd = lastActivity.endDate {
            let remainingSeconds = workout.endDate.timeIntervalSince(lastActivityEnd)
            let remainingMeters = workout.distanceMeters.map { max(0, $0 - totalActivityDistance) }
            if remainingSeconds > 0.5 || (remainingMeters ?? 0) > 0.5 {
                rows.append(
                    RawDebugActivityBoundaryCandidateInterval(
                        index: rows.count + 1,
                        label: "Open / Extra",
                        stepType: DerivedIntervalLabel.open.rawValue,
                        plannedGoalType: PlannedWorkoutGoalType.open.rawValue,
                        plannedGoalValue: nil,
                        plannedGoalDisplayText: "Open",
                        activityIndex: nil,
                        mappingStatus: "inferredOpenTailFromWorkoutEnd",
                        startOffsetSeconds: lastActivityEnd.timeIntervalSince(workout.startDate),
                        endOffsetSeconds: workout.endDate.timeIntervalSince(workout.startDate),
                        durationSeconds: remainingSeconds,
                        distanceMeters: remainingMeters,
                        candidateConfidence: "activity boundary inferred tail",
                        caveats: baseCaveats + [
                            "Inferred from workout end minus final mapped activity boundary.",
                            "No separate HKWorkoutActivity row represented this tail."
                        ],
                        notScoreableReason: nil,
                        productionUIWarning: productionWarning
                    )
                )
            }
        }

        let summaryCaveats = baseCaveats + [
            "Activities are generic HealthKit activity windows and labels are mapped from WorkoutKit planned step order.",
            "Missing or ambiguous activity rows must not replace current reconstruction."
        ] + (isCompletedPrefix ? [
            "Workout ended before all planned rows completed; only completed HealthKit activity rows are mapped."
        ] : [])
        return RawDebugActivityBoundaryCandidate(
            summary: RawDebugActivityBoundaryCandidateSummary(
                mappingStatus: isCompletedPrefix ? "mappedCompletedPrefixByPlannedStepOrder" : "mappedByPlannedStepOrder",
                activityCount: activities.count,
                plannedStepCount: plannedSteps.count,
                isScoreable: scoreablePlannedRows,
                notScoreableReason: scoreablePlannedRows ? nil : "One or more mapped activity rows lack required distance/time evidence.",
                candidateConfidence: scoreablePlannedRows ? (isCompletedPrefix ? "activity boundary completed prefix" : "activity boundary direct") : "activity mapping ambiguous",
                caveats: summaryCaveats,
                productionUIWarning: productionWarning
            ),
            rows: rows
        )
    }

    private static func customWorkoutCandidateRuleScore(
        activityCandidate: RawDebugActivityBoundaryCandidate,
        events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout
    ) -> RawDebugCustomWorkoutCandidateRuleScore {
        let productionWarning = "Custom workout candidate rule rows are debug-only Parity Lab output and are not production UI."
        let baseCaveats = [
            "debug-only, not promoted",
            "not production interval logic",
            "not shown in normal workout UI",
            "FIT and Apple Fitness/manual rows are not runtime inputs",
            "Active duration subtracts paired HealthKit pause/resume overlap when available."
        ]
        let pairedPauses = pairedPauseIntervals(events, workout: workout)
        let rows = activityCandidate.rows.map { row -> RawDebugCustomWorkoutCandidateRuleRow in
            let pauseOverlap = pauseOverlapSeconds(
                rowStartOffset: row.startOffsetSeconds,
                rowEndOffset: row.endOffsetSeconds,
                pauses: pairedPauses
            )
            let elapsedDuration = row.durationSeconds
            let activeDuration = elapsedDuration.map { max(0, $0 - pauseOverlap) }
            let isOpenTail = normalizedDebugLabel(row.label) == "open"
            let durationRule = isOpenTail
                ? "open-tail-measured-duration"
                : "active-duration-minus-paired-pause-overlap"
            return RawDebugCustomWorkoutCandidateRuleRow(
                index: row.index,
                label: row.label,
                stepType: row.stepType,
                mappingStatus: row.mappingStatus,
                startOffsetSeconds: row.startOffsetSeconds,
                endOffsetSeconds: row.endOffsetSeconds,
                elapsedDurationSeconds: elapsedDuration,
                pauseOverlapSeconds: pauseOverlap,
                activeDurationSeconds: activeDuration,
                distanceMeters: row.distanceMeters,
                durationDisplayRule: durationRule,
                durationRule: durationRule,
                isOpenTail: isOpenTail,
                candidateConfidence: row.candidateConfidence,
                caveats: row.caveats,
                productionUIWarning: productionWarning
            )
        }

        let openTailCount = rows.filter(\.isOpenTail).count
        let openTailRow = rows.last(where: \.isOpenTail)
        let totalPairedPause = pairedPauses.map(\.durationSeconds).reduce(0, +)
        let isScoreable = activityCandidate.summary.isScoreable && !rows.isEmpty
        let fixedRowExhaustionStatus: String
        if rows.isEmpty {
            fixedRowExhaustionStatus = "no-candidate-rows"
        } else if openTailCount > 0 && activityCandidate.summary.isScoreable {
            fixedRowExhaustionStatus = "fixed-rows-exhausted-before-tail"
        } else if activityCandidate.summary.isScoreable {
            fixedRowExhaustionStatus = "fixed-rows-mapped-no-tail"
        } else {
            fixedRowExhaustionStatus = "fixed-row-exhaustion-unresolved"
        }
        let tailStatus: String
        if openTailCount > 0 {
            tailStatus = "open-extra-tail-present"
        } else if activityCandidate.summary.isScoreable {
            tailStatus = "open-extra-tail-absent"
        } else {
            tailStatus = "open-extra-tail-unresolved"
        }
        let fallbackReasons = [activityCandidate.summary.notScoreableReason].compactMap { $0 }
        return RawDebugCustomWorkoutCandidateRuleScore(
            summary: RawDebugCustomWorkoutCandidateRuleSummary(
                ruleStatus: isScoreable ? "candidate-rule-scoreable" : "candidate-rule-not-scoreable",
                candidateRowCount: rows.count,
                plannedExpandedRowCount: activityCandidate.summary.plannedStepCount,
                openTailRowCount: openTailCount,
                pairedPauseCount: pairedPauses.count,
                totalPairedPauseSeconds: totalPairedPause,
                fixedRowExhaustionStatus: fixedRowExhaustionStatus,
                tailStatus: tailStatus,
                tailElapsedDurationSeconds: openTailRow?.elapsedDurationSeconds,
                tailDistanceMeters: openTailRow?.distanceMeters,
                fallbackReasons: fallbackReasons,
                safetyFlags: baseCaveats,
                fitValidationStatus: "offline-evidence-only-not-runtime-truth",
                isScoreable: isScoreable,
                notScoreableReason: isScoreable ? nil : activityCandidate.summary.notScoreableReason ?? "Activity-boundary candidate rows are unavailable.",
                caveats: baseCaveats,
                productionUIWarning: productionWarning
            ),
            rows: rows
        )
    }

    private static func customWorkoutComparisonSummary(
        plannedSteps: [PlannedWorkoutStep],
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout,
        events: [WorkoutEvidenceEvent]
    ) -> RawDebugCustomWorkoutComparisonSummary {
        let pairedPauses = pairedPauseIntervals(events, workout: workout)
        let hasPauseOrResumeEvidence = events.contains { event in
            let label = event.displayLabel.lowercased()
            let type = event.type.lowercased()
            return label.contains("pause")
                || label.contains("resume")
                || type.contains("rawvalue: 1")
                || type.contains("rawvalue: 2")
        }
        let enablesPausedRepeatTailRule = !pairedPauses.isEmpty
            && plannedSteps.contains { ($0.repeatIndex ?? 1) > 1 }
            && plannedSteps.contains { $0.stepType == .work && $0.repeatBlockIndex != nil }
            && plannedSteps.contains { $0.stepType == .recovery && $0.repeatBlockIndex != nil }
            && plannedSteps.last?.stepType == .cooldown
            && plannedSteps.last?.plannedGoalType != .open
        let pauseEvidenceState: CustomWorkoutPauseEvidenceState = if enablesPausedRepeatTailRule {
            .paired
        } else if hasPauseOrResumeEvidence {
            .unpaired
        } else {
            .none
        }
        let comparisonPlannedSteps: [PlannedWorkoutStep]
        if !activities.isEmpty, activities.count < plannedSteps.count {
            comparisonPlannedSteps = Array(plannedSteps.prefix(activities.count))
        } else {
            comparisonPlannedSteps = plannedSteps
        }
        return RawDebugCustomWorkoutComparisonSummary(
            comparison: DebugCustomWorkoutComparisonBuilder.comparison(
                plannedSteps: comparisonPlannedSteps,
                activities: activities,
                workout: workout,
                simpleWorkOpenRuleApproved: true,
                pausedRepeatBlockRuleApproved: true,
                recoveryContainingOpenTailRuleApproved: true,
                repeatTailRuleApproved: !hasPauseOrResumeEvidence,
                pausedRepeatTailRuleApproved: enablesPausedRepeatTailRule,
                pairedPauseCount: pairedPauses.count,
                pauseEvidenceState: pauseEvidenceState
            )
        )
    }

    private static func pairedPauseIntervals(
        _ events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout
    ) -> [RawDebugPauseInterval] {
        var pendingPause: Double?
        var intervals: [RawDebugPauseInterval] = []
        for event in events.sorted(by: { $0.startDate < $1.startDate }) {
            let label = event.displayLabel.lowercased()
            let offset = event.startDate.timeIntervalSince(workout.startDate)
            if label.contains("pause") && !label.contains("resume") {
                pendingPause = offset
            } else if label.contains("resume"), let start = pendingPause {
                let duration = max(0, offset - start)
                intervals.append(
                    RawDebugPauseInterval(
                        startOffsetSeconds: start,
                        endOffsetSeconds: offset,
                        durationSeconds: duration
                    )
                )
                pendingPause = nil
            }
        }
        return intervals
    }

    private static func pauseOverlapSeconds(
        rowStartOffset: Double?,
        rowEndOffset: Double?,
        pauses: [RawDebugPauseInterval]
    ) -> Double {
        guard let rowStartOffset, let rowEndOffset, rowEndOffset > rowStartOffset else { return 0 }
        return pauses.reduce(0) { total, pause in
            let overlapStart = max(rowStartOffset, pause.startOffsetSeconds)
            let overlapEnd = min(rowEndOffset, pause.endOffsetSeconds)
            return total + max(0, overlapEnd - overlapStart)
        }
    }

    private static func normalizedDebugLabel(_ value: String) -> String {
        let text = value.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        if text == "open / extra" || text == "extra" { return "open" }
        return text
    }

    private static func activityDistanceMeters(_ activity: WorkoutEvidenceActivity) -> Double? {
        activity.statistics.first {
            $0.quantityType == "HKQuantityTypeIdentifierDistanceWalkingRunning"
        }?.sum
    }

    fileprivate static func nearestRawEvent(
        to date: Date,
        events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout
    ) -> (event: WorkoutEvidenceEvent, deltaSeconds: Double)? {
        let boundedEvents = events.filter {
            $0.endDate > $0.startDate
                && $0.startDate >= workout.startDate
                && $0.endDate <= workout.endDate.addingTimeInterval(1)
        }
        guard let event = boundedEvents.min(by: {
            abs($0.endDate.timeIntervalSince(date)) < abs($1.endDate.timeIntervalSince(date))
        }) else { return nil }
        return (event, event.endDate.timeIntervalSince(date))
    }

    fileprivate static func nearestRawEventStart(
        to date: Date,
        events: [WorkoutEvidenceEvent],
        workout: CanonicalWorkout
    ) -> (event: WorkoutEvidenceEvent, deltaSeconds: Double)? {
        let boundedEvents = events.filter {
            $0.startDate >= workout.startDate
                && $0.startDate <= workout.endDate.addingTimeInterval(1)
        }
        guard let event = boundedEvents.min(by: {
            abs($0.startDate.timeIntervalSince(date)) < abs($1.startDate.timeIntervalSince(date))
        }) else { return nil }
        return (event, event.startDate.timeIntervalSince(date))
    }

    fileprivate static func nearestWorkoutActivityEnd(
        to date: Date,
        activities: [WorkoutEvidenceActivity],
        workout: CanonicalWorkout
    ) -> (activity: WorkoutEvidenceActivity, deltaSeconds: Double)? {
        let boundedActivities = activities.filter { activity in
            guard let endDate = activity.endDate else { return false }
            return activity.startDate >= workout.startDate
                && endDate <= workout.endDate.addingTimeInterval(1)
                && endDate > activity.startDate
        }
        guard let activity = boundedActivities.min(by: { first, second in
            guard let firstEnd = first.endDate, let secondEnd = second.endDate else { return false }
            return abs(firstEnd.timeIntervalSince(date)) < abs(secondEnd.timeIntervalSince(date))
        }), let endDate = activity.endDate else { return nil }
        return (activity, endDate.timeIntervalSince(date))
    }

    fileprivate static func nearestReconstructedInterval(
        to date: Date,
        reconstructedIntervals: WorkoutIntervalReconstructionResult?
    ) -> (interval: ReconstructedWorkoutInterval, deltaSeconds: Double)? {
        guard let intervals = reconstructedIntervals?.intervals, !intervals.isEmpty else { return nil }
        let interval = intervals.min {
            abs($0.actualEndDate.timeIntervalSince(date)) < abs($1.actualEndDate.timeIntervalSince(date))
        }
        guard let interval else { return nil }
        return (interval, interval.actualEndDate.timeIntervalSince(date))
    }

    fileprivate static func nearestSegmentMarker(
        to date: Date,
        segmentMarkers: [DerivedWorkoutInterval]
    ) -> (marker: DerivedWorkoutInterval, deltaSeconds: Double)? {
        guard let marker = segmentMarkers.min(by: {
            abs($0.endDate.timeIntervalSince(date)) < abs($1.endDate.timeIntervalSince(date))
        }) else { return nil }
        return (marker, marker.endDate.timeIntervalSince(date))
    }

    fileprivate static func nearestSegmentMarkerStart(
        to date: Date,
        segmentMarkers: [DerivedWorkoutInterval]
    ) -> (marker: DerivedWorkoutInterval, deltaSeconds: Double)? {
        guard let marker = segmentMarkers.min(by: {
            abs($0.startDate.timeIntervalSince(date)) < abs($1.startDate.timeIntervalSince(date))
        }) else { return nil }
        return (marker, marker.startDate.timeIntervalSince(date))
    }

    private static func exactSegmentMarker(
        for event: WorkoutEvidenceEvent,
        segmentMarkers: [DerivedWorkoutInterval]
    ) -> DerivedWorkoutInterval? {
        segmentMarkers.first { marker in
            abs(marker.startDate.timeIntervalSince(event.startDate)) < 0.001
                && abs(marker.endDate.timeIntervalSince(event.endDate)) < 0.001
        }
    }

    private static func boundarySourceWarnings(
        events: [WorkoutEvidenceEvent],
        activities: [WorkoutEvidenceActivity],
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        segmentMarkers: [DerivedWorkoutInterval]
    ) -> [String] {
        var warnings: [String] = []
        if events.isEmpty {
            warnings.append("No raw HKWorkoutEvent records exist for this workout.")
        }
        if events.contains(where: { ($0.metadataKeys ?? []).isEmpty }) {
            warnings.append("One or more raw HKWorkoutEvent records have unavailable metadata keys.")
        }
        if activities.isEmpty {
            warnings.append("No HKWorkoutActivity records exist for this workout.")
        }
        if activities.contains(where: { ($0.metadataKeys ?? []).isEmpty }) {
            warnings.append("One or more HKWorkoutActivity records have unavailable metadata keys.")
        }
        if activities.contains(where: { $0.statistics.isEmpty }) {
            warnings.append("One or more HKWorkoutActivity records have no public allStatistics entries.")
        }
        if reconstructedIntervals?.intervals.isEmpty != false {
            warnings.append("No reconstructed WorkoutKit rows are available for planned-step comparison.")
        }
        if !activities.isEmpty, let intervals = reconstructedIntervals?.intervals, !intervals.isEmpty {
            let activityEndDeltas = activities.compactMap { activity -> Double? in
                guard let endDate = activity.endDate else { return nil }
                return nearestReconstructedInterval(to: endDate, reconstructedIntervals: reconstructedIntervals)?.deltaSeconds
            }
            if activityEndDeltas.isEmpty {
                warnings.append("HKWorkoutActivity records exist, but none expose a completed end boundary for planned-step comparison.")
            } else if activityEndDeltas.allSatisfy({ abs($0) > 3 }) {
                warnings.append("HKWorkoutActivity end boundaries do not align within 3 seconds of reconstructed planned-step row ends.")
            } else if activityEndDeltas.contains(where: { abs($0) > 3 }) {
                warnings.append("One or more HKWorkoutActivity end boundaries are more than 3 seconds from reconstructed planned-step row ends.")
            }
        }
        if !events.isEmpty && segmentMarkers.isEmpty {
            warnings.append("Raw events exist, but none produced segment marker candidates.")
        }
        warnings.append("FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.")
        warnings.append("Apple Fitness/manual row offsets are not read by RunSignal; compare HKWorkoutActivity timing manually after physical-device export.")
        return uniquePreservingOrder(warnings)
    }

    private static func jsonPayload<T: Encodable>(_ payload: T) -> String {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }

    public static func monthlyDiagnosticsJSON(
        workouts: [CanonicalWorkout],
        selectedMonth: Date,
        calendar: Calendar = .current,
        forceReenrichResults: [String: ParityForceReenrichResult] = [:],
        monthlyRefreshResults: [String: MonthlyEvidenceRefreshResult] = [:],
        derivedRefreshSummary: DerivedAnalysisRefreshSummary = .empty,
        evidenceRefreshSummary: EvidenceRefreshJobSummary? = nil,
        generatedAt: Date = Date()
    ) -> String {
        let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth)
        let monthWorkouts = workouts
            .filter { workout in
                guard let monthInterval else { return false }
                return monthInterval.contains(workout.startDate)
            }
            .sorted { $0.startDate < $1.startDate }

        let records = monthWorkouts.map { workout -> [String: Any] in
            let refreshResult = monthlyRefreshResults[workout.id]
            let forceResult = forceReenrichResults[workout.id]
            let packet = parityPacketObject(
                workout: workout,
                forceReenrichResult: forceResult,
                generatedAt: generatedAt
            )
            let classification = monthlyClassification(
                workout: workout,
                in: monthWorkouts,
                calendar: calendar,
                refreshResult: refreshResult
            )
            let summary = monthlyDiagnosticsSummary(
                workout: workout,
                classification: classification,
                refreshResult: refreshResult,
                forceReenrichResult: forceResult
            )
            var record: [String: Any] = [
                "workoutID": workout.id,
                "startDate": workout.startDate.ISO8601Format(),
                "source": workout.sourceName,
                "device": workout.deviceName ?? "Unavailable",
                "refreshStatus": summary.refreshStatus,
                "evidenceSource": summary.evidenceSource,
                "freshQueryReturnedWorkout": summary.freshQueryReturnedWorkout,
                "cacheWasPresent": summary.cacheWasPresent,
                "evidenceCounts": packet["evidenceCounts"] ?? summary.evidenceCounts.jsonObject,
                "workoutKitPlanStatus": summary.workoutKitPlanStatus,
                "plannedStepCount": summary.plannedStepCount,
                "hkWorkoutActivityCount": summary.hkWorkoutActivityCount,
                "rawWorkoutEventCount": summary.rawWorkoutEventCount,
                "reconstructedIntervalCount": summary.reconstructedIntervalCount,
                "activityBoundaryCandidateSummary": packet["activityBoundaryCandidateSummary"] ?? [:],
                "activityBoundaryCandidateIntervals": packet["activityBoundaryCandidateIntervals"] ?? [],
                "classification": classification,
                "caveat": summary.caveat,
                "diagnosticsSummary": summary.jsonObject,
                "parityPacket": packet
            ]
            if let refreshError = summary.refreshError {
                record["refreshError"] = refreshError
            }
            if let evidenceLoadedAt = summary.evidenceLoadedAt {
                record["evidenceLoadedAt"] = evidenceLoadedAt
            }
            return record
        }
        let summary = monthlyExportSummary(
            records: records,
            selectedMonth: selectedMonth,
            calendar: calendar,
            generatedAt: generatedAt
        )

        let payload: [String: Any] = [
            "exportVersion": 1,
            "scope": "debug/research-only",
            "selectedMonth": monthlyIdentifier(for: selectedMonth, calendar: calendar),
            "generatedAt": generatedAt.ISO8601Format(),
            "workoutCount": records.count,
            "summary": summary,
            "productionIntervalBehaviorChanged": false,
            "normalWorkoutUIChanged": false,
            "boundaryLogicChanged": false,
            "usesFITRuntimeTruth": false,
            "usesAppleFitnessManualRuntimeLogic": false,
            "derivedAnalytics": [
                "status": derivedRefreshSummary.statusTitle,
                "refreshedCount": derivedRefreshSummary.refreshedCount,
                "refreshedWorkoutIDs": derivedRefreshSummary.refreshedWorkoutIDs,
                "checkedAt": derivedRefreshSummary.checkedAt?.ISO8601Format() ?? "Unavailable"
            ],
            "refreshJob": refreshJobObject(evidenceRefreshSummary),
            "records": records
        ]

        return jsonString(payload)
    }

    public static func monthlyDiagnosticsMarkdown(
        workouts: [CanonicalWorkout],
        selectedMonth: Date,
        calendar: Calendar = .current,
        forceReenrichResults: [String: ParityForceReenrichResult] = [:],
        monthlyRefreshResults: [String: MonthlyEvidenceRefreshResult] = [:],
        derivedRefreshSummary: DerivedAnalysisRefreshSummary = .empty,
        evidenceRefreshSummary: EvidenceRefreshJobSummary? = nil,
        generatedAt: Date = Date()
    ) -> String {
        let monthInterval = calendar.dateInterval(of: .month, for: selectedMonth)
        let monthWorkouts = workouts
            .filter { workout in
                guard let monthInterval else { return false }
                return monthInterval.contains(workout.startDate)
            }
            .sorted { $0.startDate < $1.startDate }

        let rows = monthWorkouts.map { workout -> String in
            let refreshResult = monthlyRefreshResults[workout.id]
            let summary = monthlyDiagnosticsSummary(
                workout: workout,
                classification: monthlyClassification(
                    workout: workout,
                    in: monthWorkouts,
                    calendar: calendar,
                    refreshResult: refreshResult
                ),
                refreshResult: refreshResult,
                forceReenrichResult: forceReenrichResults[workout.id]
            )
            return "| \(markdownCell(workout.startDate.ISO8601Format())) | \(markdownCell(workout.id)) | \(markdownCell(summary.refreshStatus)) | \(markdownCell(summary.evidenceSource)) | \(markdownCell(summary.classification)) | \(summary.hasWorkoutKitPlan ? "Yes" : "No") | \(summary.hkWorkoutActivityCount) | \(summary.reconstructedIntervalCount) | \(summary.hasOpenExtraTail ? "Yes" : "No") | \(markdownCell(summary.caveat)) |"
        }.joined(separator: "\n")

        return """
        # RunSignal Monthly Diagnostics Export

        Generated: \(RunFormatters.date.string(from: generatedAt))
        Selected month: \(monthlyIdentifier(for: selectedMonth, calendar: calendar))
        Derived analytics: \(derivedRefreshSummary.statusTitle) (\(derivedRefreshSummary.refreshedCount) refreshed)
        Refresh recovery: \(refreshJobMarkdownSummary(evidenceRefreshSummary))
        Scope: debug/research-only. Production interval behavior, normal workout UI, and boundary logic are unchanged.

        | Start | Workout ID | Refresh | Evidence source | Classification | WorkoutKit plan | Activities | Reconstructed rows | Open / Extra tail | Caveat |
        | --- | --- | --- | --- | --- | --- | ---: | ---: | --- | --- |
        \(rows.isEmpty ? "| No workouts | n/a | skipped | missing | empty month | No | 0 | 0 | No | No running workouts loaded for this month. |" : rows)
        """
    }

    private static func monthlyIdentifier(for date: Date, calendar: Calendar) -> String {
        let components = calendar.dateComponents([.year, .month], from: date)
        let year = components.year ?? 0
        let month = components.month ?? 0
        return String(format: "%04d-%02d", year, month)
    }

    private static func refreshJobObject(_ summary: EvidenceRefreshJobSummary?) -> [String: Any] {
        guard let summary else {
            return [
                "status": "unavailable",
                "interruptionDetected": false,
                "recoveryProof": "No persisted refresh job exists for the selected month."
            ]
        }
        return [
            "jobID": summary.jobID,
            "scopeKey": summary.scopeKey,
            "status": summary.status.rawValue,
            "progress": summary.progressText,
            "totalCount": summary.totalCount,
            "completedCount": summary.completedCount,
            "failedCount": summary.failedCount,
            "skippedCount": summary.skippedCount,
            "pendingCount": summary.pendingCount,
            "interruptionCount": summary.interruptionCount,
            "interruptionDetected": summary.pausedAfterRelaunch,
            "interruptionHistoryPresent": summary.hasInterruptionHistory,
            "canRecover": summary.canRecover,
            "lastError": summary.lastError ?? "None",
            "lastInterruptedAt": summary.lastInterruptedAt?.ISO8601Format() ?? "Unavailable",
            "updatedAt": summary.updatedAt.ISO8601Format(),
            "recoveryProof": summary.recoveryProofText,
            "physicalInterruptionProof": refreshInterruptionProofObject(summary)
        ]
    }

    private static func refreshInterruptionProofObject(_ summary: EvidenceRefreshJobSummary) -> [String: Any] {
        let proof = RefreshInterruptionProofSummary.make(from: summary)
        return [
            "status": proof.statusTitle,
            "detail": proof.detailText,
            "completedSteps": proof.completedSteps,
            "pendingSteps": proof.pendingSteps
        ]
    }

    private static func refreshJobMarkdownSummary(_ summary: EvidenceRefreshJobSummary?) -> String {
        guard let summary else {
            return "No persisted refresh job for selected month."
        }
        let proof = RefreshInterruptionProofSummary.make(from: summary)
        return "\(summary.statusTitle), \(summary.detailText). \(summary.recoveryProofText) Physical proof: \(proof.detailText)"
    }

    private static func parityPacketObject(
        workout: CanonicalWorkout,
        forceReenrichResult: ParityForceReenrichResult?,
        generatedAt: Date
    ) -> [String: Any] {
        let json = parityPacketJSON(
            workout: workout,
            forceReenrichResult: forceReenrichResult,
            generatedAt: generatedAt
        )
        guard
            let data = json.data(using: .utf8),
            let object = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
        else {
            return [
                "packetError": "Unable to encode parity packet for monthly diagnostics export.",
                "workoutID": workout.id
            ]
        }
        return object
    }

    private static func jsonString(_ object: Any) -> String {
        guard
            JSONSerialization.isValidJSONObject(object),
            let data = try? JSONSerialization.data(
                withJSONObject: object,
                options: [.prettyPrinted, .sortedKeys]
            ),
            let json = String(data: data, encoding: .utf8)
        else {
            return """
            {
              "exportVersion" : 1,
              "error" : "Unable to encode monthly diagnostics export."
            }
            """
        }
        return json
    }

    private static func monthlyClassification(
        workout: CanonicalWorkout,
        in monthWorkouts: [CanonicalWorkout],
        calendar: Calendar,
        refreshResult: MonthlyEvidenceRefreshResult? = nil
    ) -> String {
        guard let evidence = workout.evidence else {
            if refreshResult != nil {
                return "missing evidence after refresh"
            }
            return "missing evidence"
        }

        let plannedSteps = evidence.workoutPlanAudit?.plannedSteps ?? []
        guard !plannedSteps.isEmpty else {
            if monthWorkouts.contains(where: { other in
                other.id != workout.id && calendar.isDate(other.startDate, inSameDayAs: workout.startDate)
            }) {
                return "duplicate/same-day extra run candidate"
            }
            return "no WorkoutKit plan"
        }

        let activities = evidence.activities
        if activities.isEmpty {
            if refreshResult != nil {
                return "no HKWorkoutActivity rows after refresh"
            }
            return "no HKWorkoutActivity rows"
        }

        let reconstructed = WorkoutIntervalReconstructionEngine.reconstruct(
            workout: workout,
            evidence: evidence
        )
        let labels = reconstructed?.intervals.map { $0.label.lowercased() } ?? []
        let hasOpenTail = labels.contains { $0.contains("open") || $0.contains("extra") }
        let hasWarmup = labels.contains { $0.contains("warmup") }
        let hasCooldown = labels.contains { $0.contains("cooldown") }
        let workCount = labels.filter { $0.contains("work") }.count
        let recoveryCount = labels.filter { $0.contains("recovery") }.count

        if hasWarmup && hasCooldown && workCount == 1 && recoveryCount == 0 {
            return "warmup/work/cooldown special"
        }
        if workCount > 1 || recoveryCount > 0 || plannedSteps.count > 2 {
            return "structured interval workout"
        }
        if workCount == 1 && hasOpenTail {
            return "simple fixed-distance Work + Open candidate"
        }
        return "drift/guard candidate unknown"
    }

    private static func monthlyDiagnosticsSummary(
        workout: CanonicalWorkout,
        classification: String,
        refreshResult: MonthlyEvidenceRefreshResult? = nil,
        forceReenrichResult: ParityForceReenrichResult? = nil
    ) -> MonthlyDiagnosticsSummary {
        let evidence = workout.evidence
        let reconstructed = evidence.flatMap {
            WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: $0)
        }
        let labels = reconstructed?.intervals.map { $0.label.lowercased() } ?? []
        let plannedSteps = evidence?.workoutPlanAudit?.plannedSteps ?? []
        let hasOpenTail = labels.contains { $0.contains("open") || $0.contains("extra") }
        let evidenceCounts = ParityEvidenceCounts(workout: workout)
        let freshQueryReturnedWorkout = refreshResult?.freshQueryReturnedWorkout ?? forceReenrichResult?.freshQueryReturnedWorkout ?? false
        let evidenceSource: String
        if freshQueryReturnedWorkout {
            evidenceSource = "freshQuery"
        } else if evidence == nil {
            evidenceSource = "missing"
        } else {
            evidenceSource = "cachedState"
        }

        let caveat: String
        if evidence == nil {
            caveat = refreshResult == nil
                ? "No loaded WorkoutEvidence is available for this workout."
                : "No loaded WorkoutEvidence is available after month refresh."
        } else if plannedSteps.isEmpty {
            caveat = "WorkoutKit planned steps are missing."
        } else if evidence?.activities.isEmpty != false {
            caveat = refreshResult == nil
                ? "No HKWorkoutActivity rows are available."
                : "No HKWorkoutActivity rows are available after month refresh."
        } else {
            caveat = "Debug-only classification; compare with Apple Fitness/manual and FIT exports offline."
        }

        return MonthlyDiagnosticsSummary(
            classification: classification,
            refreshStatus: refreshResult?.refreshStatus.rawValue ?? "skipped",
            refreshError: refreshResult?.refreshError,
            evidenceSource: evidenceSource,
            freshQueryReturnedWorkout: freshQueryReturnedWorkout,
            cacheWasPresent: refreshResult?.cacheWasPresent ?? forceReenrichResult?.cacheWasPresent ?? (evidence != nil),
            evidenceCounts: evidenceCounts,
            sourceName: workout.sourceName,
            deviceName: workout.deviceName,
            startDate: workout.startDate.ISO8601Format(),
            endDate: workout.endDate.ISO8601Format(),
            durationSeconds: workout.durationSeconds,
            elapsedSeconds: workout.elapsedSeconds,
            distanceMeters: workout.distanceMeters,
            hasWorkoutKitPlan: !plannedSteps.isEmpty,
            plannedStepCount: plannedSteps.count,
            hkWorkoutActivityCount: evidence?.activities.count ?? 0,
            rawWorkoutEventCount: evidence?.events.count ?? workout.intervalCount,
            reconstructedIntervalCount: reconstructed?.intervals.count ?? 0,
            hasOpenExtraTail: hasOpenTail,
            evidenceLoadedAt: evidence?.loadedAt.ISO8601Format(),
            workoutKitPlanStatus: evidence?.workoutPlanAudit?.status.rawValue ?? "missing",
            caveat: caveat,
            productionIntervalBehaviorChanged: false,
            normalWorkoutUIChanged: false,
            boundaryLogicChanged: false
        )
    }

    private static func monthlyExportSummary(
        records: [[String: Any]],
        selectedMonth: Date,
        calendar: Calendar,
        generatedAt: Date
    ) -> [String: Any] {
        func count(_ key: String, _ value: String) -> Int {
            records.filter { $0[key] as? String == value }.count
        }

        return [
            "selectedMonth": monthlyIdentifier(for: selectedMonth, calendar: calendar),
            "generatedAt": generatedAt.ISO8601Format(),
            "totalWorkoutCount": records.count,
            "refreshedCount": count("refreshStatus", MonthlyEvidenceRefreshStatus.success.rawValue),
            "failedCount": count("refreshStatus", MonthlyEvidenceRefreshStatus.failed.rawValue),
            "skippedCount": count("refreshStatus", MonthlyEvidenceRefreshStatus.skipped.rawValue),
            "missingEvidenceCount": records.filter { ($0["evidenceSource"] as? String) == "missing" }.count,
            "cachedStateCount": count("evidenceSource", "cachedState"),
            "freshQueryCount": count("evidenceSource", "freshQuery"),
            "simpleWorkOpenCandidateCount": count("classification", "simple fixed-distance Work + Open candidate"),
            "structuredIntervalCount": count("classification", "structured interval workout"),
            "warmupWorkCooldownSpecialCount": count("classification", "warmup/work/cooldown special"),
            "noWorkoutKitPlanCount": count("classification", "no WorkoutKit plan"),
            "noHKWorkoutActivityRowsCount": records.filter {
                guard let classification = $0["classification"] as? String else { return false }
                return classification == "no HKWorkoutActivity rows"
                    || classification == "no HKWorkoutActivity rows after refresh"
            }.count,
            "duplicateSameDayExtraRunCandidateCount": count("classification", "duplicate/same-day extra run candidate")
        ]
    }

    private static func markdownCell(_ value: String) -> String {
        value.replacingOccurrences(of: "|", with: "\\|")
    }

    private static func optionalSeconds(_ seconds: Double?) -> String {
        guard let seconds else { return "" }
        return "\(String(format: "%.1f", seconds)) s"
    }

    private static func optionalMeters(_ meters: Double?) -> String {
        guard let meters else { return "" }
        return "\(String(format: "%.1f", meters)) m"
    }

    private static func optionalOffset(_ date: Date?, workout: CanonicalWorkout) -> String {
        guard let date else { return "Unavailable" }
        return RunFormatters.duration(date.timeIntervalSince(workout.startDate))
    }

    private static func optionalLabel(_ value: String?) -> String {
        markdownCell(emptyToNil(value ?? "") ?? "Unavailable")
    }

    private static func emptyToNil(_ value: String) -> String? {
        value.isEmpty ? nil : value
    }

    private static func uniquePreservingOrder(_ values: [String]) -> [String] {
        var seen: Set<String> = []
        return values.filter { seen.insert($0).inserted }
    }
}

public struct ParityEvidenceCounts: Codable, Equatable, Sendable {
    public var heartRate: Int
    public var speed: Int
    public var distance: Int
    public var activeEnergy: Int
    public var power: Int
    public var cadence: Int
    public var stepCount: Int
    public var strideLength: Int
    public var verticalOscillation: Int
    public var groundContact: Int
    public var routePoints: Int
    public var events: Int

    public init(workout: CanonicalWorkout) {
        heartRate = workout.heartRateSampleCount
        speed = workout.runningSpeedSampleCount
        distance = workout.distanceSampleCount
        activeEnergy = workout.activeEnergySampleCount
        power = workout.runningPowerSampleCount
        cadence = workout.cadenceSampleCount
        stepCount = workout.stepCountSampleCount
        strideLength = workout.strideLengthSampleCount
        verticalOscillation = workout.verticalOscillationSampleCount
        groundContact = workout.groundContactTimeSampleCount
        routePoints = workout.routePointCount
        events = workout.intervalCount
    }

    public var jsonObject: [String: Any] {
        [
            "heartRate": heartRate,
            "speed": speed,
            "distance": distance,
            "activeEnergy": activeEnergy,
            "power": power,
            "cadence": cadence,
            "stepCount": stepCount,
            "strideLength": strideLength,
            "verticalOscillation": verticalOscillation,
            "groundContact": groundContact,
            "routePoints": routePoints,
            "events": events
        ]
    }
}

public struct ParityForceReenrichResult: Equatable, Sendable {
    public var workoutID: String
    public var requestedAt: Date
    public var completedAt: Date?
    public var cacheWasPresent: Bool
    public var invalidatedCache: Bool
    public var freshQueryReturnedWorkout: Bool
    public var authorizationState: AuthorizationState
    public var message: String?
    public var evidenceCounts: ParityEvidenceCounts?
    public var diagnosticsWarnings: [String]

    public init(
        workoutID: String,
        requestedAt: Date,
        completedAt: Date? = nil,
        cacheWasPresent: Bool,
        invalidatedCache: Bool,
        freshQueryReturnedWorkout: Bool,
        authorizationState: AuthorizationState,
        message: String? = nil,
        evidenceCounts: ParityEvidenceCounts? = nil,
        diagnosticsWarnings: [String] = []
    ) {
        self.workoutID = workoutID
        self.requestedAt = requestedAt
        self.completedAt = completedAt
        self.cacheWasPresent = cacheWasPresent
        self.invalidatedCache = invalidatedCache
        self.freshQueryReturnedWorkout = freshQueryReturnedWorkout
        self.authorizationState = authorizationState
        self.message = message
        self.evidenceCounts = evidenceCounts
        self.diagnosticsWarnings = diagnosticsWarnings
    }
}

public enum MonthlyEvidenceRefreshStatus: String, Codable, Equatable, Sendable {
    case success
    case failed
    case skipped
    case unsupported
}

public struct MonthlyEvidenceRefreshResult: Equatable, Sendable {
    public var workoutID: String
    public var requestedAt: Date
    public var completedAt: Date?
    public var refreshStatus: MonthlyEvidenceRefreshStatus
    public var refreshError: String?
    public var cacheWasPresent: Bool
    public var invalidatedCache: Bool
    public var freshQueryReturnedWorkout: Bool
    public var authorizationState: AuthorizationState
    public var evidenceCounts: ParityEvidenceCounts?
    public var evidenceLoadedAt: Date?
    public var diagnosticsWarnings: [String]

    public init(
        workoutID: String,
        requestedAt: Date,
        completedAt: Date? = nil,
        refreshStatus: MonthlyEvidenceRefreshStatus,
        refreshError: String? = nil,
        cacheWasPresent: Bool,
        invalidatedCache: Bool,
        freshQueryReturnedWorkout: Bool,
        authorizationState: AuthorizationState,
        evidenceCounts: ParityEvidenceCounts? = nil,
        evidenceLoadedAt: Date? = nil,
        diagnosticsWarnings: [String] = []
    ) {
        self.workoutID = workoutID
        self.requestedAt = requestedAt
        self.completedAt = completedAt
        self.refreshStatus = refreshStatus
        self.refreshError = refreshError
        self.cacheWasPresent = cacheWasPresent
        self.invalidatedCache = invalidatedCache
        self.freshQueryReturnedWorkout = freshQueryReturnedWorkout
        self.authorizationState = authorizationState
        self.evidenceCounts = evidenceCounts
        self.evidenceLoadedAt = evidenceLoadedAt
        self.diagnosticsWarnings = diagnosticsWarnings
    }
}

private extension String {
    func withMarkdownTablePipes() -> String {
        "| \(self) |"
    }
}

private struct MonthlyDiagnosticsSummary {
    var classification: String
    var refreshStatus: String
    var refreshError: String?
    var evidenceSource: String
    var freshQueryReturnedWorkout: Bool
    var cacheWasPresent: Bool
    var evidenceCounts: ParityEvidenceCounts
    var sourceName: String
    var deviceName: String?
    var startDate: String
    var endDate: String
    var durationSeconds: Double
    var elapsedSeconds: Double?
    var distanceMeters: Double?
    var hasWorkoutKitPlan: Bool
    var plannedStepCount: Int
    var hkWorkoutActivityCount: Int
    var rawWorkoutEventCount: Int
    var reconstructedIntervalCount: Int
    var hasOpenExtraTail: Bool
    var evidenceLoadedAt: String?
    var workoutKitPlanStatus: String
    var caveat: String
    var productionIntervalBehaviorChanged: Bool
    var normalWorkoutUIChanged: Bool
    var boundaryLogicChanged: Bool

    var jsonObject: [String: Any] {
        var object: [String: Any] = [
            "classification": classification,
            "refreshStatus": refreshStatus,
            "evidenceSource": evidenceSource,
            "freshQueryReturnedWorkout": freshQueryReturnedWorkout,
            "cacheWasPresent": cacheWasPresent,
            "evidenceCounts": evidenceCounts.jsonObject,
            "sourceName": sourceName,
            "startDate": startDate,
            "endDate": endDate,
            "durationSeconds": durationSeconds,
            "hasWorkoutKitPlan": hasWorkoutKitPlan,
            "plannedStepCount": plannedStepCount,
            "hkWorkoutActivityCount": hkWorkoutActivityCount,
            "rawWorkoutEventCount": rawWorkoutEventCount,
            "reconstructedIntervalCount": reconstructedIntervalCount,
            "hasOpenExtraTail": hasOpenExtraTail,
            "workoutKitPlanStatus": workoutKitPlanStatus,
            "caveat": caveat,
            "productionIntervalBehaviorChanged": productionIntervalBehaviorChanged,
            "normalWorkoutUIChanged": normalWorkoutUIChanged,
            "boundaryLogicChanged": boundaryLogicChanged
        ]
        if let deviceName {
            object["deviceName"] = deviceName
        }
        if let elapsedSeconds {
            object["elapsedSeconds"] = elapsedSeconds
        }
        if let distanceMeters {
            object["distanceMeters"] = distanceMeters
        }
        if let evidenceLoadedAt {
            object["evidenceLoadedAt"] = evidenceLoadedAt
        }
        if let refreshError {
            object["refreshError"] = refreshError
        }
        return object
    }
}

private struct RawDebugPayload: Codable {
    var generatedAt: String
    var reviewPacket: ReviewPacketMetadata
    var workout: RawDebugWorkout
    var evidenceCounts: RawDebugEvidenceCounts
    var rawWorkoutEvents: [RawDebugWorkoutEvent]
    var workoutActivities: [RawDebugWorkoutActivity]
    var workoutKitPlanAudit: RawDebugPlanAudit?
    var reconstructedIntervals: [RawDebugReconstructedInterval]
    var activityBoundaryCandidateSummary: RawDebugActivityBoundaryCandidateSummary
    var activityBoundaryCandidateIntervals: [RawDebugActivityBoundaryCandidateInterval]
    var customWorkoutCandidateRuleSummary: RawDebugCustomWorkoutCandidateRuleSummary
    var customWorkoutCandidateRuleRows: [RawDebugCustomWorkoutCandidateRuleRow]
    var customWorkoutComparisonSummary: RawDebugCustomWorkoutComparisonSummary
    var boundaryDiagnostics: [RawDebugIntervalBoundaryDiagnostics]
    var segmentMarkers: [RawDebugSegmentMarker]
    var plannedStepBoundaryComparisons: [RawDebugPlannedStepBoundaryComparison]
    var boundarySourceWarnings: [String]
    var sourceNotes: [String]
    var caveats: [String]
}

private struct ParityPacketPayload: Codable {
    var packetVersion: Int
    var generatedAt: String
    var reviewPacket: ReviewPacketMetadata
    var workout: RawDebugWorkout
    var cacheStatus: ParityPacketCacheStatus
    var forceReenrichResult: ParityPacketForceReenrichResult?
    var evidenceCounts: RawDebugEvidenceCounts
    var rawWorkoutEvents: [RawDebugWorkoutEvent]
    var workoutActivities: [RawDebugWorkoutActivity]
    var workoutKitPlanAudit: RawDebugPlanAudit?
    var reconstructedIntervals: [RawDebugReconstructedInterval]
    var activityBoundaryCandidateSummary: RawDebugActivityBoundaryCandidateSummary
    var activityBoundaryCandidateIntervals: [RawDebugActivityBoundaryCandidateInterval]
    var customWorkoutCandidateRuleSummary: RawDebugCustomWorkoutCandidateRuleSummary
    var customWorkoutCandidateRuleRows: [RawDebugCustomWorkoutCandidateRuleRow]
    var customWorkoutComparisonSummary: RawDebugCustomWorkoutComparisonSummary
    var plannedStepBoundaryComparisons: [RawDebugPlannedStepBoundaryComparison]
    var boundarySourceWarnings: [String]
    var diagnosticsWarnings: [String]
    var sourceNotes: [String]
}

private struct ReviewPacketMetadata: Codable {
    var scope: String
    var includedArtifacts: [String]
    var externalEvidencePolicy: String
    var normalWorkoutUIChanged: Bool
    var usesFITRuntimeTruth: Bool
    var fitArchiveReference: String
}

private struct ParityPacketCacheStatus: Codable {
    var hasCachedEvidence: Bool
    var evidenceLoadedAt: String?
    var evidenceSource: String
}

private struct ParityPacketForceReenrichResult: Codable {
    var workoutID: String
    var requestedAt: String
    var completedAt: String?
    var cacheWasPresent: Bool
    var invalidatedCache: Bool
    var freshQueryReturnedWorkout: Bool
    var authorizationState: String
    var message: String?
    var evidenceCounts: ParityEvidenceCounts?
    var diagnosticsWarnings: [String]

    init(result: ParityForceReenrichResult) {
        workoutID = result.workoutID
        requestedAt = result.requestedAt.ISO8601Format()
        completedAt = result.completedAt?.ISO8601Format()
        cacheWasPresent = result.cacheWasPresent
        invalidatedCache = result.invalidatedCache
        freshQueryReturnedWorkout = result.freshQueryReturnedWorkout
        authorizationState = result.authorizationState.rawValue
        message = result.message
        evidenceCounts = result.evidenceCounts
        diagnosticsWarnings = result.diagnosticsWarnings
    }
}

private struct RawDebugWorkout: Codable {
    var id: String
    var sourceName: String
    var sourceID: String
    var deviceName: String?
    var startDate: String
    var endDate: String
    var durationSeconds: Double
    var elapsedSeconds: Double
    var distanceMeters: Double?
    var paceSecondsPerKm: Double?
    var averageHeartRate: Double?
    var maxHeartRate: Double?
    var cadenceSpm: Double?
    var averagePower: Double?
}

private struct RawDebugEvidenceCounts: Codable {
    var heartRate: Int
    var speed: Int
    var distance: Int
    var activeEnergy: Int
    var power: Int
    var cadence: Int
    var stepCount: Int
    var strideLength: Int
    var verticalOscillation: Int
    var groundContact: Int
    var routePoints: Int
    var events: Int
    var activities: Int
}

private struct RawDebugWorkoutEvent: Codable {
    var index: Int
    var type: String
    var label: String?
    var startDate: String
    var endDate: String
    var startOffsetSeconds: Double
    var endOffsetSeconds: Double
    var durationSeconds: Double
    var metadataKeys: [String]
    var renderedSegmentMarkerStartOffsetSeconds: Double?
    var renderedSegmentMarkerEndOffsetSeconds: Double?
    var renderedSegmentMarkerDistanceMeters: Double?
    var renderedSegmentMarkerDurationSeconds: Double?
    var renderedSegmentMarkerKind: String?
    var segmentMarkerDebugOnlyReason: String
    var usedBySegmentMarkerRendering: Bool
    var excludedOrFilteredReason: String?

    init(
        index: Int,
        event: WorkoutEvidenceEvent,
        workout: CanonicalWorkout,
        segmentMarkers: [DerivedWorkoutInterval]
    ) {
        self.index = index
        type = event.type
        label = event.label
        startDate = event.startDate.ISO8601Format()
        endDate = event.endDate.ISO8601Format()
        startOffsetSeconds = event.startDate.timeIntervalSince(workout.startDate)
        endOffsetSeconds = event.endDate.timeIntervalSince(workout.startDate)
        durationSeconds = event.endDate.timeIntervalSince(event.startDate)
        metadataKeys = event.metadataKeys ?? []
        let matchingMarker = segmentMarkers.first { marker in
            abs(marker.startDate.timeIntervalSince(event.startDate)) < 0.001
                && abs(marker.endDate.timeIntervalSince(event.endDate)) < 0.001
        }
        renderedSegmentMarkerStartOffsetSeconds = matchingMarker?.startOffsetSeconds
        renderedSegmentMarkerEndOffsetSeconds = matchingMarker?.endOffsetSeconds
        renderedSegmentMarkerDistanceMeters = matchingMarker?.distanceMeters
        renderedSegmentMarkerDurationSeconds = matchingMarker?.durationSeconds
        renderedSegmentMarkerKind = matchingMarker?.markerKind.rawValue
        segmentMarkerDebugOnlyReason = matchingMarker == nil
            ? "noRenderedSegmentMarkerCandidate"
            : "healthKitSegmentMarkersAreDebugOnlyNotAppleFitnessTruth"
        usedBySegmentMarkerRendering = matchingMarker != nil
        if usedBySegmentMarkerRendering {
            excludedOrFilteredReason = nil
        } else if event.endDate <= event.startDate {
            excludedOrFilteredReason = "zeroOrNegativeDuration"
        } else if event.startDate < workout.startDate || event.endDate > workout.endDate.addingTimeInterval(1) {
            excludedOrFilteredReason = "outsideWorkoutBounds"
        } else {
            excludedOrFilteredReason = "noDerivedSegmentMarker"
        }
    }
}

private struct RawDebugActivityBoundaryCandidate {
    var summary: RawDebugActivityBoundaryCandidateSummary
    var rows: [RawDebugActivityBoundaryCandidateInterval]
}

private struct RawDebugActivityBoundaryCandidateSummary: Codable {
    var strategyID: String = "hkworkoutactivity_boundary"
    var scope: String = "debug/export-only"
    var mappingStatus: String
    var activityCount: Int
    var plannedStepCount: Int
    var isScoreable: Bool
    var notScoreableReason: String?
    var candidateConfidence: String
    var caveats: [String]
    var productionUIWarning: String
    var productionIntervalBehaviorChanged: Bool = false
    var normalWorkoutUIChanged: Bool = false
    var boundaryLogicChanged: Bool = false
    var usesFITRuntimeTruth: Bool = false
    var usesAppleFitnessManualRuntimeLogic: Bool = false
}

private struct RawDebugActivityBoundaryCandidateInterval: Codable {
    var index: Int
    var label: String
    var stepType: String
    var plannedGoalType: String
    var plannedGoalValue: Double?
    var plannedGoalDisplayText: String
    var activityIndex: Int?
    var mappingStatus: String
    var startOffsetSeconds: Double?
    var endOffsetSeconds: Double?
    var durationSeconds: Double?
    var distanceMeters: Double?
    var candidateConfidence: String
    var caveats: [String]
    var notScoreableReason: String?
    var productionUIWarning: String
}

private struct RawDebugCustomWorkoutCandidateRuleScore {
    var summary: RawDebugCustomWorkoutCandidateRuleSummary
    var rows: [RawDebugCustomWorkoutCandidateRuleRow]
}

private struct RawDebugCustomWorkoutCandidateRuleSummary: Codable {
    var strategyID: String = "custom_workout_candidate_rule_active_time"
    var scope: String = "debug/export-only"
    var ruleStatus: String
    var candidateRowCount: Int
    var plannedExpandedRowCount: Int
    var openTailRowCount: Int
    var pairedPauseCount: Int
    var totalPairedPauseSeconds: Double
    var fixedRowExhaustionStatus: String
    var tailStatus: String
    var tailElapsedDurationSeconds: Double?
    var tailDistanceMeters: Double?
    var fallbackReasons: [String]
    var safetyFlags: [String]
    var fitValidationStatus: String
    var isScoreable: Bool
    var notScoreableReason: String?
    var caveats: [String]
    var productionUIWarning: String
    var productionIntervalBehaviorChanged: Bool = false
    var normalWorkoutUIChanged: Bool = false
    var boundaryLogicChanged: Bool = false
    var usesFITRuntimeTruth: Bool = false
    var usesAppleFitnessManualRuntimeLogic: Bool = false
}

private struct RawDebugCustomWorkoutCandidateRuleRow: Codable {
    var index: Int
    var label: String
    var stepType: String
    var mappingStatus: String
    var startOffsetSeconds: Double?
    var endOffsetSeconds: Double?
    var elapsedDurationSeconds: Double?
    var pauseOverlapSeconds: Double
    var activeDurationSeconds: Double?
    var distanceMeters: Double?
    var durationDisplayRule: String
    var durationRule: String
    var isOpenTail: Bool
    var candidateConfidence: String
    var caveats: [String]
    var productionUIWarning: String
}

private struct RawDebugCustomWorkoutComparisonSummary: Codable {
    var status: String
    var statusLabel: String
    var fallbackReasons: [String]
    var fallbackReasonLabels: [String]
    var primaryFallbackReasonLabel: String?
    var rowCount: Int
    var rowConfidences: [String]
    var tailAmbiguity: String
    var promotesProductionBehavior: Bool
    var scope: String = "debug/export-only"
    var productionIntervalBehaviorChanged: Bool = false
    var normalWorkoutUIChanged: Bool = false
    var usesFITRuntimeTruth: Bool = false

    init(comparison: DebugCustomWorkoutComparison) {
        status = comparison.status.rawValue
        statusLabel = comparison.status.normalDetailBlockedReasonLabel
        fallbackReasons = comparison.fallbackReasons.map(\.rawValue)
        fallbackReasonLabels = comparison.fallbackReasons.map(\.normalDetailBlockedReasonLabel)
        primaryFallbackReasonLabel = comparison.fallbackReasons.first?.normalDetailBlockedReasonLabel
        rowCount = comparison.rows.count
        rowConfidences = comparison.rows.map { $0.confidence.rawValue }
        tailAmbiguity = comparison.tailAmbiguity.rawValue
        promotesProductionBehavior = comparison.promotesProductionBehavior
    }
}

private struct RawDebugPauseInterval {
    var startOffsetSeconds: Double
    var endOffsetSeconds: Double
    var durationSeconds: Double
}

private struct RawDebugWorkoutActivity: Codable {
    var index: Int
    var id: String
    var activityType: String
    var locationType: String?
    var startDate: String
    var endDate: String?
    var startOffsetSeconds: Double
    var endOffsetSeconds: Double?
    var durationSeconds: Double
    var metadataKeys: [String]
    var events: [RawDebugWorkoutEvent]
    var eventsSummary: String
    var statistics: [RawDebugWorkoutActivityStatistic]
    var statisticsSummary: String
    var alignsWithPlannedStep: Bool
    var alignedPlannedStepIndex: Int?
    var alignedPlannedStepLabel: String?
    var nearestReconstructedIntervalIndex: Int?
    var nearestReconstructedIntervalLabel: String?
    var nearestReconstructedIntervalEndOffsetSeconds: Double?
    var nearestReconstructedIntervalEndDeltaSeconds: Double?
    var appleFitnessManualRowReference: String
    var nearestAppleFitnessManualRowEndOffsetSeconds: Double?
    var fitLapReference: String
    var nearestFITLapEndOffsetSeconds: Double?
    var nearestRawEventStartOffsetSeconds: Double?
    var nearestRawEventStartDeltaSeconds: Double?
    var nearestRawEventEndOffsetSeconds: Double?
    var nearestRawEventEndDeltaSeconds: Double?
    var nearestRawEventType: String?
    var nearestSegmentMarkerStartOffsetSeconds: Double?
    var nearestSegmentMarkerStartDeltaSeconds: Double?
    var nearestSegmentMarkerEndOffsetSeconds: Double?
    var nearestSegmentMarkerEndDeltaSeconds: Double?
    var nearestSegmentMarkerKind: String?
    var previousDistanceSampleEndOffsetSeconds: Double?
    var crossingDistanceSampleEndOffsetSeconds: Double?
    var nextDistanceSampleEndOffsetSeconds: Double?

    init(
        index: Int,
        activity: WorkoutEvidenceActivity,
        plannedSteps: [PlannedWorkoutStep],
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        events: [WorkoutEvidenceEvent],
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) {
        self.index = index
        id = activity.id
        activityType = activity.activityType
        locationType = activity.locationType
        startDate = activity.startDate.ISO8601Format()
        endDate = activity.endDate?.ISO8601Format()
        startOffsetSeconds = activity.startDate.timeIntervalSince(workout.startDate)
        endOffsetSeconds = activity.endDate?.timeIntervalSince(workout.startDate)
        durationSeconds = activity.durationSeconds
        metadataKeys = activity.metadataKeys ?? []
        self.events = activity.events.enumerated().map { offset, event in
            RawDebugWorkoutEvent(index: offset + 1, event: event, workout: workout, segmentMarkers: segmentMarkers)
        }
        eventsSummary = Self.eventsSummary(activity.events)
        statistics = activity.statistics.map(RawDebugWorkoutActivityStatistic.init(statistic:))
        statisticsSummary = Self.statisticsSummary(statistics)

        let nearestInterval = activity.endDate.flatMap {
            DiagnosticsExport.nearestReconstructedInterval(to: $0, reconstructedIntervals: reconstructedIntervals)
        }
        let plannedStep = nearestInterval.flatMap { nearest in
            plannedSteps.first { $0.index == nearest.interval.index }
        }
        let alignsWithRow = nearestInterval.map { abs($0.deltaSeconds) <= 3 } ?? false
        alignsWithPlannedStep = alignsWithRow && plannedStep != nil
        alignedPlannedStepIndex = alignsWithPlannedStep ? plannedStep?.index : nil
        alignedPlannedStepLabel = alignsWithPlannedStep ? plannedStep?.label : nil
        nearestReconstructedIntervalIndex = nearestInterval?.interval.index
        nearestReconstructedIntervalLabel = nearestInterval?.interval.label
        nearestReconstructedIntervalEndOffsetSeconds = nearestInterval?.interval.actualEndDate.timeIntervalSince(workout.startDate)
        nearestReconstructedIntervalEndDeltaSeconds = nearestInterval?.deltaSeconds

        appleFitnessManualRowReference = "Unavailable in runtime export; compare manual fixture after export."
        nearestAppleFitnessManualRowEndOffsetSeconds = nil
        fitLapReference = "Manual FIT placeholder; FIT is not runtime truth."
        nearestFITLapEndOffsetSeconds = nil

        let nearestEventStart = DiagnosticsExport.nearestRawEventStart(to: activity.startDate, events: events, workout: workout)
        let nearestEventEnd = activity.endDate.flatMap {
            DiagnosticsExport.nearestRawEvent(to: $0, events: events, workout: workout)
        }
        nearestRawEventStartOffsetSeconds = nearestEventStart?.event.startDate.timeIntervalSince(workout.startDate)
        nearestRawEventStartDeltaSeconds = nearestEventStart?.deltaSeconds
        nearestRawEventEndOffsetSeconds = nearestEventEnd?.event.endDate.timeIntervalSince(workout.startDate)
        nearestRawEventEndDeltaSeconds = nearestEventEnd?.deltaSeconds
        nearestRawEventType = nearestEventEnd?.event.type ?? nearestEventStart?.event.type

        let nearestMarkerStart = DiagnosticsExport.nearestSegmentMarkerStart(to: activity.startDate, segmentMarkers: segmentMarkers)
        let nearestMarkerEnd = activity.endDate.flatMap {
            DiagnosticsExport.nearestSegmentMarker(to: $0, segmentMarkers: segmentMarkers)
        }
        nearestSegmentMarkerStartOffsetSeconds = nearestMarkerStart?.marker.startOffsetSeconds
        nearestSegmentMarkerStartDeltaSeconds = nearestMarkerStart?.deltaSeconds
        nearestSegmentMarkerEndOffsetSeconds = nearestMarkerEnd?.marker.endOffsetSeconds
        nearestSegmentMarkerEndDeltaSeconds = nearestMarkerEnd?.deltaSeconds
        nearestSegmentMarkerKind = nearestMarkerEnd?.marker.markerKind.rawValue ?? nearestMarkerStart?.marker.markerKind.rawValue

        previousDistanceSampleEndOffsetSeconds = nearestInterval?.interval.boundaryDiagnostics?.previousSample?.endDate.timeIntervalSince(workout.startDate)
        crossingDistanceSampleEndOffsetSeconds = nearestInterval?.interval.boundaryDiagnostics?.crossingSample?.endDate.timeIntervalSince(workout.startDate)
        nextDistanceSampleEndOffsetSeconds = nearestInterval?.interval.boundaryDiagnostics?.nextSample?.endDate.timeIntervalSince(workout.startDate)
    }

    private static func eventsSummary(_ events: [WorkoutEvidenceEvent]) -> String {
        guard !events.isEmpty else { return "No nested events" }
        let types = events.map(\.type)
        let uniqueTypes = Array(Set(types)).sorted().prefix(4).joined(separator: ", ")
        return "\(events.count) event(s): \(uniqueTypes)"
    }

    private static func statisticsSummary(_ statistics: [RawDebugWorkoutActivityStatistic]) -> String {
        guard !statistics.isEmpty else { return "Unavailable" }
        return statistics.prefix(4).map(\.summary).joined(separator: "; ")
    }
}

private struct RawDebugWorkoutActivityStatistic: Codable {
    var quantityType: String
    var unit: String?
    var startDate: String
    var endDate: String
    var sourceCount: Int
    var sum: Double?
    var average: Double?
    var minimum: Double?
    var maximum: Double?
    var durationSeconds: Double?
    var summary: String

    init(statistic: WorkoutEvidenceActivityStatistic) {
        quantityType = statistic.quantityType
        unit = statistic.unit
        startDate = statistic.startDate.ISO8601Format()
        endDate = statistic.endDate.ISO8601Format()
        sourceCount = statistic.sourceCount
        sum = statistic.sum
        average = statistic.average
        minimum = statistic.minimum
        maximum = statistic.maximum
        durationSeconds = statistic.durationSeconds
        summary = Self.summary(for: statistic)
    }

    private static func summary(for statistic: WorkoutEvidenceActivityStatistic) -> String {
        let label = statistic.quantityType.replacingOccurrences(of: "HKQuantityTypeIdentifier", with: "")
        let unit = statistic.unit.map { " \($0)" } ?? ""
        let values: [String] = [
            statistic.sum.map { "sum \(String(format: "%.1f", $0))\(unit)" },
            statistic.average.map { "avg \(String(format: "%.1f", $0))\(unit)" },
            statistic.minimum.map { "min \(String(format: "%.1f", $0))\(unit)" },
            statistic.maximum.map { "max \(String(format: "%.1f", $0))\(unit)" },
            statistic.durationSeconds.map { "duration \(String(format: "%.1f", $0))s" }
        ].compactMap { $0 }
        return values.isEmpty ? "\(label): available" : "\(label): \(values.joined(separator: ", "))"
    }
}

private struct RawDebugPlanAudit: Codable {
    var status: String
    var planID: String?
    var planType: String?
    var displayName: String?
    var summaryLines: [String]
    var plannedSteps: [RawDebugPlannedStep]
    var errorMessage: String?

    init(audit: WorkoutPlanAudit) {
        status = audit.status.rawValue
        planID = audit.planID
        planType = audit.planType
        displayName = audit.displayName
        summaryLines = audit.summaryLines
        plannedSteps = audit.plannedSteps.map(RawDebugPlannedStep.init(step:))
        errorMessage = audit.errorMessage
    }
}

private struct RawDebugPlannedStep: Codable {
    var index: Int
    var label: String
    var stepType: String
    var repeatBlockIndex: Int?
    var repeatIndex: Int?
    var plannedGoalType: String
    var plannedGoalValue: Double?
    var plannedGoalDisplayText: String
    var plannedTargetDisplayText: String?

    init(step: PlannedWorkoutStep) {
        index = step.index
        label = step.label
        stepType = step.stepType.rawValue
        repeatBlockIndex = step.repeatBlockIndex
        repeatIndex = step.repeatIndex
        plannedGoalType = step.plannedGoalType.rawValue
        plannedGoalValue = step.plannedGoalValue
        plannedGoalDisplayText = step.plannedGoalDisplayText
        plannedTargetDisplayText = step.plannedTargetDisplayText
    }
}

private struct RawDebugReconstructedInterval: Codable {
    var index: Int
    var label: String
    var stepType: String
    var plannedGoalType: String
    var plannedGoalValue: Double?
    var plannedGoalDisplayText: String
    var plannedTargetDisplayText: String?
    var startOffsetSeconds: Double
    var endOffsetSeconds: Double
    var durationSeconds: Double
    var elapsedDurationSeconds: Double
    var pauseOverlapSeconds: Double?
    var activeDurationSeconds: Double?
    var displayDurationSeconds: Double
    var durationDisplayRule: String
    var distanceMeters: Double?
    var paceSecondsPerKm: Double?
    var averageHeartRateBpm: Double?
    var maxHeartRateBpm: Double?
    var averagePower: Double?
    var boundaryStrategy: String?
    var boundaryAdjustmentSeconds: Double?
    var boundaryOvershootMeters: Double?
    var boundaryDiagnostics: RawDebugDistanceBoundaryDiagnostics?
    var tailDiagnostics: RawDebugTailDiagnostics?
    var confidence: String
    var sourceNote: String

    init(interval: ReconstructedWorkoutInterval, workout: CanonicalWorkout) {
        index = interval.index
        label = interval.label
        stepType = interval.stepType.rawValue
        plannedGoalType = interval.plannedGoalType.rawValue
        plannedGoalValue = interval.plannedGoalValue
        plannedGoalDisplayText = interval.plannedGoalDisplayText
        plannedTargetDisplayText = interval.plannedTargetDisplayText
        startOffsetSeconds = interval.actualStartDate.timeIntervalSince(workout.startDate)
        endOffsetSeconds = interval.actualEndDate.timeIntervalSince(workout.startDate)
        durationSeconds = interval.actualDurationSeconds
        elapsedDurationSeconds = interval.elapsedRowWindowDurationSeconds
        pauseOverlapSeconds = interval.pauseOverlapSeconds
        activeDurationSeconds = interval.activeDurationSeconds
        displayDurationSeconds = interval.displayDurationSeconds
        durationDisplayRule = (interval.durationDisplayRule ?? ReconstructedIntervalDurationDisplayRule.elapsedRowWindow).rawValue
        distanceMeters = interval.actualDistanceMeters
        paceSecondsPerKm = interval.actualPaceSecondsPerKm
        averageHeartRateBpm = interval.averageHeartRateBpm
        maxHeartRateBpm = interval.maxHeartRateBpm
        averagePower = interval.averagePower
        boundaryStrategy = interval.boundaryStrategy?.rawValue
        boundaryAdjustmentSeconds = interval.boundaryAdjustmentSeconds
        boundaryOvershootMeters = interval.boundaryOvershootMeters
        boundaryDiagnostics = interval.boundaryDiagnostics.map { RawDebugDistanceBoundaryDiagnostics(diagnostics: $0, workout: workout) }
        tailDiagnostics = interval.tailDiagnostics.map { RawDebugTailDiagnostics(diagnostics: $0, workout: workout) }
        confidence = interval.confidence.rawValue
        sourceNote = interval.sourceNote
    }
}

private struct RawDebugIntervalBoundaryDiagnostics: Codable {
    var index: Int
    var label: String
    var distanceBoundary: RawDebugDistanceBoundaryDiagnostics?
    var tail: RawDebugTailDiagnostics?

    var hasDiagnostics: Bool {
        distanceBoundary != nil || tail != nil
    }

    init(interval: ReconstructedWorkoutInterval, workout: CanonicalWorkout) {
        index = interval.index
        label = interval.label
        distanceBoundary = interval.boundaryDiagnostics.map { RawDebugDistanceBoundaryDiagnostics(diagnostics: $0, workout: workout) }
        tail = interval.tailDiagnostics.map { RawDebugTailDiagnostics(diagnostics: $0, workout: workout) }
    }
}

private struct RawDebugDistanceBoundaryDiagnostics: Codable {
    var targetDistanceMeters: Double
    var cumulativeDistanceAtStartMeters: Double
    var cumulativeDistanceAtEndMeters: Double
    var interpolationFraction: Double?
    var previousSample: RawDebugDistanceBoundarySample?
    var crossingSample: RawDebugDistanceBoundarySample?
    var nextSample: RawDebugDistanceBoundarySample?

    init(diagnostics: DistanceBoundaryDiagnostics, workout: CanonicalWorkout) {
        targetDistanceMeters = diagnostics.targetDistanceMeters
        cumulativeDistanceAtStartMeters = diagnostics.cumulativeDistanceAtStartMeters
        cumulativeDistanceAtEndMeters = diagnostics.cumulativeDistanceAtEndMeters
        interpolationFraction = diagnostics.interpolationFraction
        previousSample = diagnostics.previousSample.map { RawDebugDistanceBoundarySample(sample: $0, workout: workout) }
        crossingSample = diagnostics.crossingSample.map { RawDebugDistanceBoundarySample(sample: $0, workout: workout) }
        nextSample = diagnostics.nextSample.map { RawDebugDistanceBoundarySample(sample: $0, workout: workout) }
    }
}

private struct RawDebugDistanceBoundarySample: Codable {
    var startOffsetSeconds: Double
    var endOffsetSeconds: Double
    var startDate: String
    var endDate: String
    var startCumulativeDistanceMeters: Double
    var endCumulativeDistanceMeters: Double

    init(sample: DistanceBoundarySample, workout: CanonicalWorkout) {
        startOffsetSeconds = sample.startDate.timeIntervalSince(workout.startDate)
        endOffsetSeconds = sample.endDate.timeIntervalSince(workout.startDate)
        startDate = sample.startDate.ISO8601Format()
        endDate = sample.endDate.ISO8601Format()
        startCumulativeDistanceMeters = sample.startCumulativeDistanceMeters
        endCumulativeDistanceMeters = sample.endCumulativeDistanceMeters
    }
}

private struct RawDebugTailDiagnostics: Codable {
    var plannedFinalStepEndOffsetSeconds: Double
    var workoutEndOffsetSeconds: Double
    var remainingSeconds: Double
    var remainingMeters: Double?
    var finalDistanceSampleOffsetSeconds: Double?
    var finalDistanceSampleCumulativeDistanceMeters: Double?
    var lastHeartRateSampleOffsetSeconds: Double?
    var lastPowerSampleOffsetSeconds: Double?
    var lastCadenceSampleOffsetSeconds: Double?
    var creationReason: String

    init(diagnostics: TailDiagnostics, workout: CanonicalWorkout) {
        plannedFinalStepEndOffsetSeconds = diagnostics.plannedFinalStepEndDate.timeIntervalSince(workout.startDate)
        workoutEndOffsetSeconds = diagnostics.workoutEndDate.timeIntervalSince(workout.startDate)
        remainingSeconds = diagnostics.remainingSeconds
        remainingMeters = diagnostics.remainingMeters
        finalDistanceSampleOffsetSeconds = diagnostics.finalDistanceSampleDate?.timeIntervalSince(workout.startDate)
        finalDistanceSampleCumulativeDistanceMeters = diagnostics.finalDistanceSampleCumulativeDistanceMeters
        lastHeartRateSampleOffsetSeconds = diagnostics.lastHeartRateSampleDate?.timeIntervalSince(workout.startDate)
        lastPowerSampleOffsetSeconds = diagnostics.lastPowerSampleDate?.timeIntervalSince(workout.startDate)
        lastCadenceSampleOffsetSeconds = diagnostics.lastCadenceSampleDate?.timeIntervalSince(workout.startDate)
        creationReason = diagnostics.creationReason
    }
}

private struct RawDebugSegmentMarker: Codable {
    var index: Int
    var label: String
    var markerKind: String
    var source: String
    var startOffsetSeconds: Double
    var endOffsetSeconds: Double
    var durationSeconds: Double
    var distanceMeters: Double?
    var paceSecondsPerKm: Double?
    var averageHeartRateBpm: Double?
    var confidence: String
    var caveats: [String]

    init(interval: DerivedWorkoutInterval) {
        index = interval.index
        label = interval.label.rawValue
        markerKind = interval.markerKind.rawValue
        source = interval.source.rawValue
        startOffsetSeconds = interval.startOffsetSeconds
        endOffsetSeconds = interval.endOffsetSeconds
        durationSeconds = interval.durationSeconds
        distanceMeters = interval.distanceMeters
        paceSecondsPerKm = interval.paceSecondsPerKm
        averageHeartRateBpm = interval.averageHeartRateBpm
        confidence = interval.confidence.rawValue
        caveats = interval.caveats
    }
}

private struct RawDebugPlannedStepBoundaryComparison: Codable {
    var index: Int
    var plannedStepLabel: String?
    var reconstructedLabel: String
    var plannedGoalDisplayText: String
    var reconstructedEndOffsetSeconds: Double
    var fitLapEndOffsetSeconds: Double?
    var nearestRawEventStartOffsetSeconds: Double?
    var nearestRawEventEndOffsetSeconds: Double?
    var nearestRawEventEndDeltaSeconds: Double?
    var nearestRawEventType: String?
    var nearestWorkoutActivityStartOffsetSeconds: Double?
    var nearestWorkoutActivityEndOffsetSeconds: Double?
    var nearestWorkoutActivityEndDeltaSeconds: Double?
    var nearestWorkoutActivityType: String?
    var nearestSegmentMarkerStartOffsetSeconds: Double?
    var nearestSegmentMarkerEndOffsetSeconds: Double?
    var nearestSegmentMarkerEndDeltaSeconds: Double?
    var nearestSegmentMarkerKind: String?
    var previousDistanceSampleEndOffsetSeconds: Double?
    var crossingDistanceSampleEndOffsetSeconds: Double?
    var nextDistanceSampleEndOffsetSeconds: Double?
    var warning: String?
}
