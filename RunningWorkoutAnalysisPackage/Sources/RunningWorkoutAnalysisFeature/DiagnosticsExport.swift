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

    public static func rawHealthKitDebugMarkdown(workout: CanonicalWorkout, generatedAt: Date = Date()) -> String {
        let evidence = workout.evidence
        let coverage = evidence.map(WorkoutEvidenceAnalyzer.coverage(for:))
        let reconstructedIntervals = evidence
            .flatMap { WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: $0) }
        let segmentMarkers = evidence.map {
            DerivedAnalyticsEngine.intervalCandidates(workout: workout, evidence: $0)
        } ?? []
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

        ## WorkoutKit Reconstructed Intervals

        Planned structure source: WorkoutKit when available. Measured stats source: HealthKit samples.

        \(reconstructedIntervalsMarkdown(reconstructedIntervals, workout: workout))

        ## WorkoutKit Boundary Diagnostics

        \(boundaryDiagnosticsMarkdown(reconstructedIntervals, workout: workout))

        ## HealthKit Segment Markers

        Raw debug only. HealthKit Segment Markers must not be promoted as Apple Fitness interval rows.

        \(segmentMarkersMarkdown(segmentMarkers))

        ## Planned Step Boundary Comparison

        Debug-only comparison helper for FIT/Apple boundary investigation. The FIT lap end offset is intentionally a manual placeholder; RunSignal does not read FIT at runtime.

        \(plannedStepBoundaryComparisonMarkdown(
            reconstructedIntervals: reconstructedIntervals,
            plannedSteps: evidence?.workoutPlanAudit?.plannedSteps ?? [],
            events: evidence?.events ?? [],
            segmentMarkers: segmentMarkers,
            workout: workout
        ))

        ## Boundary Source Warnings

        \(boundarySourceWarnings(
            events: evidence?.events ?? [],
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
        let payload = ParityPacketPayload(
            packetVersion: 1,
            generatedAt: generatedAt.ISO8601Format(),
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
                events: evidence?.events.count ?? workout.intervalCount
            ),
            rawWorkoutEvents: (evidence?.events ?? []).enumerated().map { offset, event in
                RawDebugWorkoutEvent(index: offset + 1, event: event, workout: workout, segmentMarkers: segmentMarkers)
            },
            workoutKitPlanAudit: evidence?.workoutPlanAudit.map(RawDebugPlanAudit.init(audit:)),
            reconstructedIntervals: reconstructedIntervals?.intervals.map { RawDebugReconstructedInterval(interval: $0, workout: workout) } ?? [],
            plannedStepBoundaryComparisons: plannedStepBoundaryComparisons(
                reconstructedIntervals: reconstructedIntervals,
                plannedSteps: evidence?.workoutPlanAudit?.plannedSteps ?? [],
                events: evidence?.events ?? [],
                segmentMarkers: segmentMarkers,
                workout: workout
            ),
            boundarySourceWarnings: boundarySourceWarnings(
                events: evidence?.events ?? [],
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
            ("Events", evidence?.events.count ?? workout.intervalCount)
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
            return "Unavailable. RunSignal needs a WorkoutKit plan and HealthKit distance/time evidence before it can reconstruct custom workout intervals."
        }

        let rows = result.intervals.map { interval in
            [
                "\(interval.index)",
                markdownCell(interval.label),
                markdownCell(interval.plannedGoalDisplayText),
                markdownCell(interval.plannedTargetDisplayText ?? "Target unavailable"),
                RunFormatters.distance(interval.actualDistanceMeters),
                RunFormatters.duration(interval.actualDurationSeconds),
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
        | Row | Label | Goal | Target | Distance | Time | Pace | Avg HR | Max HR | Power | Start Offset | End Offset | Boundary Strategy | Boundary Adjustment | Overshoot | Confidence | Notes |
        |---:|---|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---|---:|---:|---|---|
        \(rows)

        Notes: \(result.notes.map(markdownCell).joined(separator: " · "))
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

    private static func plannedStepBoundaryComparisonMarkdown(
        reconstructedIntervals: WorkoutIntervalReconstructionResult?,
        plannedSteps: [PlannedWorkoutStep],
        events: [WorkoutEvidenceEvent],
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) -> String {
        let comparisons = plannedStepBoundaryComparisons(
            reconstructedIntervals: reconstructedIntervals,
            plannedSteps: plannedSteps,
            events: events,
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
        | Row | Planned Step | Goal | RunSignal End | FIT Lap End | Nearest Raw Event End | Event Delta | Nearest Segment End | Segment Delta | Previous Sample End | Crossing Sample End | Next Sample End | Warning |
        |---:|---|---|---:|---:|---:|---:|---:|---:|---:|---:|---:|---|
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
        RawDebugPayload(
            generatedAt: generatedAt.ISO8601Format(),
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
                events: evidence?.events.count ?? workout.intervalCount
            ),
            rawWorkoutEvents: (evidence?.events ?? []).enumerated().map { offset, event in
                RawDebugWorkoutEvent(index: offset + 1, event: event, workout: workout, segmentMarkers: segmentMarkers)
            },
            workoutKitPlanAudit: evidence?.workoutPlanAudit.map(RawDebugPlanAudit.init(audit:)),
            reconstructedIntervals: reconstructedIntervals?.intervals.map { RawDebugReconstructedInterval(interval: $0, workout: workout) } ?? [],
            boundaryDiagnostics: reconstructedIntervals?.intervals.map { RawDebugIntervalBoundaryDiagnostics(interval: $0, workout: workout) }.filter { $0.hasDiagnostics } ?? [],
            segmentMarkers: segmentMarkers.map(RawDebugSegmentMarker.init(interval:)),
            plannedStepBoundaryComparisons: plannedStepBoundaryComparisons(
                reconstructedIntervals: reconstructedIntervals,
                plannedSteps: evidence?.workoutPlanAudit?.plannedSteps ?? [],
                events: evidence?.events ?? [],
                segmentMarkers: segmentMarkers,
                workout: workout
            ),
            boundarySourceWarnings: boundarySourceWarnings(
                events: evidence?.events ?? [],
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
        segmentMarkers: [DerivedWorkoutInterval],
        workout: CanonicalWorkout
    ) -> [RawDebugPlannedStepBoundaryComparison] {
        guard let intervals = reconstructedIntervals?.intervals, !intervals.isEmpty else { return [] }
        return intervals.map { interval in
            let rowEndOffset = interval.actualEndDate.timeIntervalSince(workout.startDate)
            let nearestEvent = nearestRawEvent(to: interval.actualEndDate, events: events, workout: workout)
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

    private static func nearestRawEvent(
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

    private static func nearestSegmentMarker(
        to date: Date,
        segmentMarkers: [DerivedWorkoutInterval]
    ) -> (marker: DerivedWorkoutInterval, deltaSeconds: Double)? {
        guard let marker = segmentMarkers.min(by: {
            abs($0.endDate.timeIntervalSince(date)) < abs($1.endDate.timeIntervalSince(date))
        }) else { return nil }
        return (marker, marker.endDate.timeIntervalSince(date))
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
        if reconstructedIntervals?.intervals.isEmpty != false {
            warnings.append("No reconstructed WorkoutKit rows are available for planned-step comparison.")
        }
        if !events.isEmpty && segmentMarkers.isEmpty {
            warnings.append("Raw events exist, but none produced segment marker candidates.")
        }
        warnings.append("FIT lap end offsets are not read by RunSignal; compare them manually after physical-device export.")
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

private extension String {
    func withMarkdownTablePipes() -> String {
        "| \(self) |"
    }
}

private struct RawDebugPayload: Codable {
    var generatedAt: String
    var workout: RawDebugWorkout
    var evidenceCounts: RawDebugEvidenceCounts
    var rawWorkoutEvents: [RawDebugWorkoutEvent]
    var workoutKitPlanAudit: RawDebugPlanAudit?
    var reconstructedIntervals: [RawDebugReconstructedInterval]
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
    var workout: RawDebugWorkout
    var cacheStatus: ParityPacketCacheStatus
    var forceReenrichResult: ParityPacketForceReenrichResult?
    var evidenceCounts: RawDebugEvidenceCounts
    var rawWorkoutEvents: [RawDebugWorkoutEvent]
    var workoutKitPlanAudit: RawDebugPlanAudit?
    var reconstructedIntervals: [RawDebugReconstructedInterval]
    var plannedStepBoundaryComparisons: [RawDebugPlannedStepBoundaryComparison]
    var boundarySourceWarnings: [String]
    var diagnosticsWarnings: [String]
    var sourceNotes: [String]
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
    var nearestSegmentMarkerStartOffsetSeconds: Double?
    var nearestSegmentMarkerEndOffsetSeconds: Double?
    var nearestSegmentMarkerEndDeltaSeconds: Double?
    var nearestSegmentMarkerKind: String?
    var previousDistanceSampleEndOffsetSeconds: Double?
    var crossingDistanceSampleEndOffsetSeconds: Double?
    var nextDistanceSampleEndOffsetSeconds: Double?
    var warning: String?
}
