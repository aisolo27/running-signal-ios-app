import Foundation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func paceMathUsesSecondsPerKilometer() {
    let pace = PaceMath.paceSecondsPerKm(distanceMeters: 5_000, durationSeconds: 1_200)
    #expect(pace == 240)
}

@Test func compactDistanceUsesMetersForShortIntervals() {
    #expect(RunFormatters.compactDistance(400) == "400 m")
    #expect(RunFormatters.compactDistance(10.4) == "10 m")
    #expect(RunFormatters.compactDistance(2_510) == "2.51 km")
    #expect(RunFormatters.distance(400) == "0.40 km")
}

@Test func weightedPaceAggregatesDurationOverDistance() {
    let start = Date()
    let workouts = [
        CanonicalWorkout(
            id: "a",
            sourceID: "a",
            sourceName: "Test",
            startDate: start,
            endDate: start.addingTimeInterval(1_000),
            environment: .outdoor,
            distanceMeters: 2_000,
            durationSeconds: 1_000
        ),
        CanonicalWorkout(
            id: "b",
            sourceID: "b",
            sourceName: "Test",
            startDate: start,
            endDate: start.addingTimeInterval(1_200),
            environment: .outdoor,
            distanceMeters: 4_000,
            durationSeconds: 1_200
        )
    ]

    #expect(PaceMath.weightedPaceSecondsPerKm(workouts) == 366.6666666666667)
}

@Test func manualRunTypeOverridesInferredRunType() {
    let start = Date()
    let workout = CanonicalWorkout(
        id: "manual",
        sourceID: "manual",
        sourceName: "Test",
        startDate: start,
        endDate: start.addingTimeInterval(2_000),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 2_000,
        inferredRunType: .easy,
        manualRunType: .threshold
    )

    #expect(workout.effectiveRunType == RunType.threshold)
    #expect(workout.runTypeTrust.kind == .userReviewed)
}

@Test func runTypeTrustSeparatesSuggestedImportedReviewedConflictAndUnknown() {
    let start = Date(timeIntervalSince1970: 1_000)
    let suggested = testWorkout(
        id: "suggested",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_700,
        inferredRunType: .easy
    )
    let imported = CanonicalWorkout(
        id: "imported",
        sourceID: "imported",
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(1_700),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_700,
        inferredRunType: .easy,
        importedRunType: .threshold,
        importedReviewID: "web-1"
    )
    let reviewed = CanonicalWorkout(
        id: "reviewed",
        sourceID: "reviewed",
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(1_700),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_700,
        inferredRunType: .easy,
        manualRunType: .race,
        importedRunType: .race,
        importedReviewID: "web-2"
    )
    let conflict = CanonicalWorkout(
        id: "conflict",
        sourceID: "conflict",
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(1_700),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_700,
        inferredRunType: .easy,
        manualRunType: .race,
        importedRunType: .threshold,
        importedReviewID: "web-3"
    )
    let unknown = testWorkout(
        id: "unknown",
        start: start,
        distanceMeters: 3_000,
        durationSeconds: 1_400,
        inferredRunType: .unknown
    )

    #expect(suggested.runTypeTrust.kind == .suggested)
    #expect(suggested.trustedPurposeRunType == nil)
    #expect(imported.runTypeTrust.kind == .importedReview)
    #expect(imported.effectiveRunType == .threshold)
    #expect(imported.trustedPurposeRunType == .threshold)
    #expect(reviewed.runTypeTrust.kind == .userReviewed)
    #expect(reviewed.trustedPurposeRunType == .race)
    #expect(conflict.runTypeTrust.kind == .conflict)
    #expect(conflict.trustedPurposeRunType == nil)
    #expect(unknown.runTypeTrust.kind == .needsReview)
    #expect(unknown.trustedPurposeRunType == nil)
}

@Test func duplicateDetectorMarksNearMatchingRuns() {
    let start = Date()
    let first = CanonicalWorkout(
        id: "first",
        sourceID: "first",
        sourceName: "Watch",
        startDate: start,
        endDate: start.addingTimeInterval(1_800),
        environment: .outdoor,
        distanceMeters: 5_000,
        durationSeconds: 1_800
    )
    let second = CanonicalWorkout(
        id: "second",
        sourceID: "second",
        sourceName: "Mirror",
        startDate: start.addingTimeInterval(30),
        endDate: start.addingTimeInterval(1_825),
        environment: .outdoor,
        distanceMeters: 5_040,
        durationSeconds: 1_795
    )

    let marked = DuplicateDetector.markDuplicates([second, first])
    #expect(marked.filter { $0.isDuplicate }.count == 1)
}

@Test func analyticsExcludesDuplicatesFromVolume() {
    var workouts = SampleData.workouts
    var duplicate = workouts[0]
    duplicate.id = "forced-duplicate"
    duplicate.isDuplicate = true
    workouts.append(duplicate)

    let normal = AnalyticsEngine.snapshot(for: SampleData.workouts, now: Date())
    let withDuplicate = AnalyticsEngine.snapshot(for: workouts, now: Date())

    #expect(withDuplicate.weeklyVolumeKm == normal.weeklyVolumeKm)
}

@Test func readinessIsLimitedWithoutBestEfforts() {
    let report = AnalyticsEngine.makeDataQualityReport([])
    let readiness = AnalyticsEngine.makeReadiness(workouts: [], bestEfforts: [], dataQuality: report)

    #expect(readiness.status == .unavailable)
    #expect(readiness.bestFiveKSeconds == nil)
}

@Test func markdownExportIncludesConfidenceAndGoal() {
    let snapshot = AnalyticsEngine.snapshot(for: SampleData.workouts)
    let markdown = AnalyticsEngine.markdownSummary(workouts: SampleData.workouts, snapshot: snapshot, healthContext: SampleData.healthContext)

    #expect(markdown.contains("Sub-20 5K"))
    #expect(markdown.contains("Data Confidence"))
    #expect(markdown.contains("VO2 max"))
}

@Test func dataQualityCaveatsIncludeSeriesGateWhenCoverageIsLow() {
    let start = Date()
    let workouts = (0..<8).map { index in
        CanonicalWorkout(
            id: "run-\(index)",
            sourceID: "run-\(index)",
            sourceName: "HealthKit",
            startDate: start.addingTimeInterval(Double(index) * 86_400),
            endDate: start.addingTimeInterval(Double(index) * 86_400 + 1_800),
            environment: .outdoor,
            distanceMeters: 5_000,
            durationSeconds: 1_800,
            averageHeartRate: 150,
            seriesAvailable: index < 2
        )
    }

    let report = AnalyticsEngine.makeDataQualityReport(workouts)

    #expect(report.caveats.contains("Workout Analyzer and trend detail need more per-workout series evidence."))
}

@Test func parityReadinessKeepsWorkoutAnalyzerLimitedWhenSeriesArePending() {
    var report = AnalyticsEngine.makeDataQualityReport(SampleData.workouts)
    report.includedWorkoutCount = 620
    report.duplicateCount = 3
    report.heartRateCoverage = 0.9
    report.seriesCoverage = 0.48
    report.mechanicsCoverage = 0.1
    report.confidence = .moderate

    let readiness = AnalyticsEngine.parityReadiness(
        dataQuality: report,
        pendingSeriesCount: 323,
        reviewedRunTypeCount: 0
    )

    let dataQuality = readiness.first { $0.title == "Data Quality" }
    let runType = readiness.first { $0.title == "Run Type Analysis" }
    let analyzer = readiness.first { $0.title == "Workout Analyzer" }
    let trends = readiness.first { $0.title == "Trends" }
    let mechanics = readiness.first { $0.title == "Mechanics" }

    #expect(dataQuality?.detail.contains("620 included runs") == true)
    #expect(runType?.confidence == .limited)
    #expect(analyzer?.value == "Series pending")
    #expect(analyzer?.confidence == .limited)
    #expect(trends?.confidence == .limited)
    #expect(mechanics?.value == "Blocked")
}

@Test func webRunReviewCategoryMapsToNativeRunType() {
    #expect(WebRunReviewCategory.easyRun.runType == .easy)
    #expect(WebRunReviewCategory.longRun.runType == .longRun)
    #expect(WebRunReviewCategory.intervalRun.runType == .interval)
    #expect(WebRunReviewCategory.thresholdRun.runType == .threshold)
    #expect(WebRunReviewCategory.race.runType == .race)
    #expect(WebRunReviewCategory.warmupCooldown.runType == .recovery)
    #expect(WebRunReviewCategory.other.runType == .unknown)
}

@Test func runTypeBridgeAppliesConfidentReviewedCategoryByDateDistanceAndDuration() {
    let calendar = fixedCalendar()
    let start = calendar.date(from: DateComponents(year: 2026, month: 6, day: 5, hour: 7, minute: 30))!
    let workout = testWorkout(
        id: "hk-run",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_650,
        inferredRunType: .easy
    )
    let review = ReviewedRunTypeRecord(
        id: "web-run",
        localDate: "2026-06-05",
        localStartTime: "07:31",
        distanceMeters: 5_020,
        durationSeconds: 1_645,
        category: .thresholdRun
    )

    let summary = RunTypeReviewBridge.reconcile(reviews: [review], workouts: [workout], calendar: calendar)
    let applied = RunTypeReviewBridge.applyConfidentMatches(reviews: [review], to: [workout], calendar: calendar)

    #expect(summary.matchedCount == 1)
    #expect(summary.weakCount == 0)
    #expect(applied[0].manualRunType == nil)
    #expect(applied[0].importedRunType == .threshold)
    #expect(applied[0].importedReviewID == "web-run")
}

@Test func runTypeBridgeDoesNotOverwriteConflictingManualCategory() {
    let calendar = fixedCalendar()
    let start = calendar.date(from: DateComponents(year: 2026, month: 6, day: 5, hour: 7, minute: 30))!
    let workout = testWorkout(
        id: "hk-run",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_650,
        inferredRunType: .easy,
        manualRunType: .race
    )
    let review = ReviewedRunTypeRecord(
        id: "web-run",
        localDate: "2026-06-05",
        localStartTime: "07:30",
        distanceMeters: 5_000,
        durationSeconds: 1_650,
        category: .thresholdRun
    )

    let summary = RunTypeReviewBridge.reconcile(reviews: [review], workouts: [workout], calendar: calendar)
    let applied = RunTypeReviewBridge.applyConfidentMatches(reviews: [review], to: [workout], calendar: calendar)

    #expect(summary.conflictCount == 1)
    #expect(applied[0].manualRunType == .race)
    #expect(applied[0].importedRunType == nil)
}

@Test func runTypeBridgeSurfacesWeakMatchesAndPhoneOnlyRuns() {
    let calendar = fixedCalendar()
    let start = calendar.date(from: DateComponents(year: 2026, month: 6, day: 5, hour: 7, minute: 30))!
    let weakWorkout = testWorkout(
        id: "weak-hk-run",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_650
    )
    let phoneOnlyWorkout = testWorkout(
        id: "phone-only",
        start: start.addingTimeInterval(4 * 60 * 60),
        distanceMeters: 8_000,
        durationSeconds: 2_900
    )
    let review = ReviewedRunTypeRecord(
        id: "web-run",
        localDate: "2026-06-05",
        localStartTime: "07:30",
        distanceMeters: 7_000,
        durationSeconds: 2_400,
        category: .longRun
    )

    let summary = RunTypeReviewBridge.reconcile(reviews: [review], workouts: [weakWorkout, phoneOnlyWorkout], calendar: calendar)

    #expect(summary.weakCount == 1)
    #expect(summary.phoneOnlyCount == 1)
    #expect(summary.matchedCount == 0)
}

@Test func runTypeReviewImportParsesCSVExport() throws {
    let csv = """
    id,localDate,localStartTime,distanceMeters,durationSeconds,category,notes
    fit-1,2026-06-05,07:30,5000,1650,threshold_run,Track tempo
    """

    let reviews = try RunTypeReviewImportService.parseCSV(csv)

    #expect(reviews.count == 1)
    #expect(reviews[0].id == "fit-1")
    #expect(reviews[0].category == .thresholdRun)
    #expect(reviews[0].distanceMeters == 5_000)
    #expect(reviews[0].durationSeconds == 1_650)
}

@Test func diagnosticsExportIncludesBridgeCountsAndWeakReasons() {
    let calendar = fixedCalendar()
    let start = calendar.date(from: DateComponents(year: 2026, month: 6, day: 5, hour: 7, minute: 30))!
    let workout = testWorkout(
        id: "weak-hk-run",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_650
    )
    let review = ReviewedRunTypeRecord(
        id: "web-run",
        localDate: "2026-06-05",
        localStartTime: "12:30",
        distanceMeters: 5_000,
        durationSeconds: 1_650,
        category: .thresholdRun
    )
    let snapshot = AnalyticsEngine.snapshot(for: [workout], now: start)
    let reconciliation = RunTypeReviewBridge.reconcile(reviews: [review], workouts: [workout], calendar: calendar)

    let markdown = DiagnosticsExport.markdown(
        workouts: [workout],
        snapshot: snapshot,
        healthContext: HealthContext(vo2Max: 59.3),
        reconciliation: reconciliation,
        authorizationState: .authorized,
        syncState: HealthKitSyncState(
            lastSyncAt: start,
            lastFetchedCount: 3,
            lastInsertedCount: 2,
            lastUpdatedCount: 1,
            lastDeletedCount: 0,
            lastEvidencePendingCount: 4
        ),
        message: "Loaded test workouts.",
        generatedAt: start
    )

    #expect(markdown.contains("RunSignal Diagnostics"))
    #expect(markdown.contains("- Imported: 1"))
    #expect(markdown.contains("- Weak: 1"))
    #expect(markdown.contains("- Fetched changes: 3"))
    #expect(markdown.contains("- Evidence pending: 4"))
    #expect(markdown.contains("Start time differs beyond tolerance."))
}

@MainActor
@Test func diagnosticsExportKeepsLastHealthKitStatusAfterNonHealthKitMessage() async throws {
    let store = RunningAnalysisStore()

    await store.refreshFromHealthKit()
    let healthKitMessage = store.healthKitStatus.message

    let csv = """
    id,localDate,localStartTime,distanceMeters,durationSeconds,category,notes
    fit-1,2026-06-05,07:30,5000,1650,threshold_run,Track tempo
    """
    let url = FileManager.default.temporaryDirectory
        .appendingPathComponent("reviewed-runs-\(UUID().uuidString).csv")
    try csv.write(to: url, atomically: true, encoding: .utf8)
    defer { try? FileManager.default.removeItem(at: url) }

    store.importReviewedRunTypes(from: url)

    #expect(store.message.contains("Imported 1 reviewed web run categories."))
    #expect(store.diagnosticsMarkdown.contains("- Authorization: \(store.healthKitStatus.authorizationState.label)"))
    #expect(store.diagnosticsMarkdown.contains("- Message: \(healthKitMessage)"))
    #expect(!store.diagnosticsMarkdown.contains("- Message: Imported 1 reviewed web run categories."))
}

@Test func healthKitSyncStateStorePersistsLastSyncDate() {
    let defaults = UserDefaults(suiteName: "RunSignalTests.\(UUID().uuidString)")!
    let date = Date(timeIntervalSince1970: 1_800)

    HealthKitSyncStateStore.saveLastSyncAt(date, defaults: defaults)

    #expect(HealthKitSyncStateStore.loadLastSyncAt(defaults: defaults) == date)

    HealthKitSyncStateStore.reset(defaults: defaults)

    #expect(HealthKitSyncStateStore.loadLastSyncAt(defaults: defaults) == nil)
}

@Test func workoutEvidenceSeriesSortsSamplesAndSummarizesValues() {
    let start = Date(timeIntervalSince1970: 1_000)
    let series = WorkoutMetricSeries(
        metric: .heartRate,
        unit: "bpm",
        points: [
            WorkoutEvidencePoint(date: start.addingTimeInterval(20), value: 160),
            WorkoutEvidencePoint(date: start, value: 140),
            WorkoutEvidencePoint(date: start.addingTimeInterval(10), value: 150)
        ]
    )

    #expect(series.points.map(\.value) == [140, 150, 160])
    #expect(series.sampleCount == 3)
    #expect(series.average == 150)
    #expect(series.maximum == 160)
}

@Test func workoutEvidenceCoverageRequiresSeriesForStrongConfidence() {
    let start = Date(timeIntervalSince1970: 1_000)
    let evidence = WorkoutEvidence(
        workoutID: "workout-evidence",
        loadedAt: start,
        series: [
            .heartRate: testSeries(.heartRate, value: 150, start: start),
            .runningSpeed: testSeries(.runningSpeed, value: 3.6, start: start),
            .runningPower: testSeries(.runningPower, value: 310, start: start),
            .cadence: testSeries(.cadence, value: 174, start: start),
            .strideLength: testSeries(.strideLength, value: 1.2, start: start)
        ],
        route: [
            WorkoutRoutePoint(date: start, latitude: 25.7617, longitude: -80.1918)
        ]
    )

    let coverage = WorkoutEvidenceAnalyzer.coverage(for: evidence)

    #expect(coverage.heartRate)
    #expect(coverage.speedOrDistance)
    #expect(coverage.power)
    #expect(coverage.cadenceOrSteps)
    #expect(coverage.mechanics)
    #expect(coverage.route)
    #expect(coverage.confidence == .strong)
    #expect(coverage.caveats.isEmpty)
}

@Test func workoutEvidenceCoverageFallsBackToLimitedWhenKeySeriesAreMissing() {
    let start = Date(timeIntervalSince1970: 1_000)
    let evidence = WorkoutEvidence(
        workoutID: "limited-evidence",
        loadedAt: start,
        series: [
            .activeEnergy: testSeries(.activeEnergy, value: 410, start: start),
            .basalEnergy: testSeries(.basalEnergy, value: 58, start: start),
            .stepCount: testSeries(.stepCount, value: 120, start: start)
        ],
        route: []
    )

    let coverage = WorkoutEvidenceAnalyzer.coverage(for: evidence)

    #expect(!coverage.heartRate)
    #expect(!coverage.speedOrDistance)
    #expect(coverage.activeEnergy)
    #expect(evidence.sum(.basalEnergy) == 58)
    #expect(coverage.cadenceOrSteps)
    #expect(coverage.confidence == .limited)
    #expect(coverage.caveats.contains("Heart-rate series is missing, so drift and intensity claims stay limited."))
    #expect(coverage.caveats.contains("Speed or distance series is missing, so pacing-shape claims stay limited."))
}

@Test func totalCaloriesRequireActiveAndBasalEnergyEvidence() {
    #expect(HealthKitWorkoutMapper.totalEnergyKilocalories(active: 432, basal: nil) == nil)
    #expect(HealthKitWorkoutMapper.totalEnergyKilocalories(active: nil, basal: 59) == nil)
    #expect(HealthKitWorkoutMapper.totalEnergyKilocalories(active: 432, basal: 59) == 491)
}

@Test func workoutEvidenceDiagnosticsIncludesSampleCountsAndCaveats() {
    let start = Date(timeIntervalSince1970: 1_000)
    let evidence = WorkoutEvidence(
        workoutID: "diagnostic-evidence",
        loadedAt: start,
        series: [
            .heartRate: testSeries(.heartRate, value: 150, start: start),
            .distance: testSeries(.distance, value: 1_000, start: start)
        ],
        route: []
    )

    let markdown = DiagnosticsExport.workoutEvidenceMarkdown(evidence)

    #expect(markdown.contains("Workout Evidence"))
    #expect(markdown.contains("- Workout ID: diagnostic-evidence"))
    #expect(markdown.contains("- Heart rate: 1"))
    #expect(markdown.contains("- Distance: 1"))
    #expect(markdown.contains("Route points are unavailable for this workout."))
}

@Test func workoutEvidenceDiagnosticsIncludesWorkoutKitPlanAudit() {
    let evidence = WorkoutEvidence(
        workoutID: "workoutkit-plan-audit",
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            planID: "plan-123",
            planType: "Custom workout",
            displayName: "Wednesday Interval",
            summaryLines: [
                "Warmup: goal 2 km, alert speed range",
                "Block 1: 4x, 2 step(s)"
            ]
        )
    )

    let markdown = DiagnosticsExport.workoutEvidenceMarkdown(evidence)

    #expect(markdown.contains("- WorkoutKit plan: Available"))
    #expect(markdown.contains("- Plan ID: plan-123"))
    #expect(markdown.contains("- Plan type: Custom workout"))
    #expect(markdown.contains("- Display name: Wednesday Interval"))
    #expect(markdown.contains("- Warmup: goal 2 km, alert speed range"))
    #expect(markdown.contains("- Block 1: 4x, 2 step(s)"))
}

@Test func evidenceQueuePrioritizesPendingWorkoutsWithoutFullHistoryQueries() {
    let calendar = fixedCalendar()
    let latestStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let latest = testWorkout(id: "latest", start: latestStart, distanceMeters: 5_000, durationSeconds: 1_500)
    var quality = testWorkout(
        id: "quality",
        start: latestStart.addingTimeInterval(-7 * 86_400),
        distanceMeters: 6_000,
        durationSeconds: 1_800,
        inferredRunType: .threshold
    )
    var long = testWorkout(
        id: "long",
        start: latestStart.addingTimeInterval(-14 * 86_400),
        distanceMeters: 14_000,
        durationSeconds: 5_400,
        inferredRunType: .longRun
    )
    let unknown = testWorkout(
        id: "unknown",
        start: latestStart.addingTimeInterval(-21 * 86_400),
        distanceMeters: 4_000,
        durationSeconds: 1_700,
        inferredRunType: .unknown
    )
    quality.sourceName = "HealthKit"
    long.sourceName = "HealthKit"

    let ids = EvidenceEnrichmentQueue.nextPendingIDs(
        workouts: [unknown, long, quality, latest],
        cachedEvidenceIDs: [],
        limit: 3
    )
    let items = EvidenceEnrichmentQueue.items(
        workouts: [unknown, long, quality, latest],
        cachedEvidenceIDs: []
    )

    #expect(ids == ["latest", "quality", "long"])
    #expect(items.first?.priority == .latestRun)
    #expect(EvidenceEnrichmentQueue.summary(for: items).pendingCount == 4)
}

@MainActor
@Test func evidenceQueueSkipsCachedEvidenceAndSurfacesFailedState() throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 4_000)
    let latest = testWorkout(id: "cached", start: start, distanceMeters: 5_000, durationSeconds: 1_500)
    let failed = testWorkout(
        id: "failed",
        start: start.addingTimeInterval(-86_400),
        distanceMeters: 5_000,
        durationSeconds: 1_600
    )
    let pending = testWorkout(
        id: "pending",
        start: start.addingTimeInterval(-2 * 86_400),
        distanceMeters: 5_000,
        durationSeconds: 1_650
    )
    var cached = latest
    cached.evidence = WorkoutEvidence(
        workoutID: cached.id,
        loadedAt: start,
        series: [.heartRate: testSeries(.heartRate, value: 150, start: start)]
    )
    PersistenceService.upsert([cached, failed, pending], context: context)
    PersistenceService.markEnrichmentAttempt(
        ids: [failed.id],
        status: .failed,
        message: "Could not enrich test workout.",
        context: context,
        at: start
    )

    let items = EvidenceEnrichmentQueue.items(
        workouts: PersistenceService.fetchWorkouts(context: context),
        cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(context: context),
        failedStates: PersistenceService.fetchEnrichmentStateByID(context: context)
    )
    let summary = EvidenceEnrichmentQueue.summary(for: items)
    let nextIDs = EvidenceEnrichmentQueue.nextPendingIDs(
        workouts: PersistenceService.fetchWorkouts(context: context),
        cachedEvidenceIDs: PersistenceService.fetchEvidenceIDs(context: context),
        failedStates: PersistenceService.fetchEnrichmentStateByID(context: context),
        limit: 10
    )

    #expect(summary.enrichedCount == 1)
    #expect(summary.failedCount == 1)
    #expect(summary.pendingCount == 1)
    #expect(nextIDs == [pending.id])
    #expect(items.first { $0.workoutID == failed.id }?.message == "Could not enrich test workout.")
}

@MainActor
@Test func persistenceStoresFullWorkoutEvidenceSeparatelyFromWorkoutSummary() throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 1_000)
    var workout = testWorkout(
        id: "persisted-evidence",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.heartRateSampleCount = 1
    workout.routePointCount = 1
    workout.intervalCount = 1
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start.addingTimeInterval(60),
        series: [
            .heartRate: testSeries(.heartRate, value: 151, start: start),
            .runningSpeed: testSeries(.runningSpeed, value: 3.4, start: start)
        ],
        route: [
            WorkoutRoutePoint(date: start, latitude: 25.7617, longitude: -80.1918, altitudeMeters: 2)
        ],
        events: [
            WorkoutEvidenceEvent(
                startDate: start.addingTimeInterval(300),
                endDate: start.addingTimeInterval(600),
                type: "segment",
                label: "Work"
            )
        ]
    )

    PersistenceService.upsert([workout], context: context)

    let persistedWorkouts = PersistenceService.fetchWorkouts(context: context)
    let persistedEvidence = PersistenceService.fetchEvidence(workoutID: workout.id, context: context)
    let summaries = PersistenceService.fetchEvidenceSummaries(context: context)

    #expect(persistedWorkouts.count == 1)
    #expect(persistedWorkouts[0].evidence == nil)
    #expect(persistedWorkouts[0].heartRateSampleCount == 1)
    #expect(persistedEvidence?.sampleCount(.heartRate) == 1)
    #expect(persistedEvidence?.sampleCount(.runningSpeed) == 1)
    #expect(persistedEvidence?.route.count == 1)
    #expect(persistedEvidence?.events.first?.label == "Work")
    #expect(summaries.first?.workoutID == workout.id)
    #expect(summaries.first?.seriesSampleCount == 2)
}

@MainActor
@Test func persistenceKeepsMissingEvidenceExplicitlyMissing() throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 2_000)
    var workout = testWorkout(
        id: "missing-series-evidence",
        start: start,
        distanceMeters: 8_000,
        durationSeconds: 2_800
    )
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .activeEnergy: testSeries(.activeEnergy, value: 430, start: start)
        ]
    )

    PersistenceService.upsert([workout], context: context)

    let persistedEvidence = PersistenceService.fetchEvidence(workoutID: workout.id, context: context)

    #expect(persistedEvidence?.sampleCount(.activeEnergy) == 1)
    #expect(persistedEvidence?.series[.heartRate] == nil)
    #expect(persistedEvidence?.sampleCount(.heartRate) == 0)
    #expect(persistedEvidence?.route.isEmpty == true)
    #expect(persistedEvidence?.events.isEmpty == true)
}

@MainActor
@Test func persistencePreservesManualFieldsAndEvidenceAcrossSummaryRefresh() throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 3_000)
    var workout = testWorkout(
        id: "refresh-evidence",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .heartRate: testSeries(.heartRate, value: 148, start: start)
        ]
    )

    PersistenceService.upsert([workout], context: context)
    PersistenceService.updateManualFields(id: workout.id, runType: .threshold, notes: "Felt controlled", context: context)

    var summaryOnlyRefresh = testWorkout(
        id: workout.id,
        start: start,
        distanceMeters: 5_100,
        durationSeconds: 1_540,
        inferredRunType: .easy
    )
    summaryOnlyRefresh.averageHeartRate = 150

    PersistenceService.upsert([summaryOnlyRefresh], context: context)

    let refreshed = PersistenceService.fetchWorkouts(context: context).first
    let persistedEvidence = PersistenceService.fetchEvidence(workoutID: workout.id, context: context)

    #expect(refreshed?.distanceMeters == 5_100)
    #expect(refreshed?.manualRunType == .threshold)
    #expect(refreshed?.notes == "Felt controlled")
    #expect(refreshed?.evidence == nil)
    #expect(persistedEvidence?.sampleCount(.heartRate) == 1)
    #expect(persistedEvidence?.average(.heartRate) == 148)
}

@MainActor
@Test func storeHydratesCachedEvidenceForRouteRenderingOnBootstrap() async throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 3_500)
    var workout = testWorkout(
        id: "route-hydration",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.routePointCount = 2
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        route: [
            WorkoutRoutePoint(date: start, latitude: 25.7617, longitude: -80.1918),
            WorkoutRoutePoint(date: start.addingTimeInterval(60), latitude: 25.7620, longitude: -80.1922)
        ]
    )

    PersistenceService.upsert([workout], context: context)
    let store = RunningAnalysisStore()

    await store.bootstrap(modelContext: context)

    #expect(store.workouts.first?.evidence?.route.count == 2)
    #expect(store.workouts.first?.routePointCount == 2)
}

@MainActor
@Test func persistenceStoresVersionedDerivedAnalyticsWithInputs() throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 4_000)
    var workout = testWorkout(
        id: "derived-analysis",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start.addingTimeInterval(60),
        series: [
            .heartRate: testSeries(.heartRate, values: [140, 140, 154, 154], start: start),
            .runningSpeed: testSeries(.runningSpeed, values: [3.1, 3.2, 3.35], start: start),
            .cadence: testSeries(.cadence, values: [172, 176], start: start),
            .runningPower: testSeries(.runningPower, values: [280, 300], start: start),
            .strideLength: testSeries(.strideLength, values: [1.1, 1.2], start: start)
        ],
        route: [
            WorkoutRoutePoint(date: start, latitude: 25.7617, longitude: -80.1918),
            WorkoutRoutePoint(date: start.addingTimeInterval(60), latitude: 25.7620, longitude: -80.1920)
        ],
        events: [
            WorkoutEvidenceEvent(
                startDate: start.addingTimeInterval(300),
                endDate: start.addingTimeInterval(600),
                type: "segment",
                label: "Work"
            )
        ]
    )

    PersistenceService.upsert([workout], context: context)

    let analysis = PersistenceService.fetchDerivedAnalysis(workoutID: workout.id, context: context)
    let summary = PersistenceService.fetchDerivedAnalysisSummaries(context: context).first

    #expect(analysis?.calculationVersion == DerivedWorkoutAnalysis.currentVersion)
    #expect(analysis?.inputSummary.seriesSampleCounts[WorkoutEvidenceMetric.heartRate.rawValue] == 4)
    #expect(analysis?.inputSummary.routePointCount == 2)
    #expect(analysis?.inputSummary.eventCount == 1)
    #expect(analysis?.paceConfidence == .moderate)
    #expect(analysis?.pacingShapeConfidence == .moderate)
    #expect(abs((analysis?.heartRateDriftPercent ?? 0) - 10) < 0.001)
    #expect(analysis?.heartRateDriftConfidence == .moderate)
    #expect(analysis?.executionSegments?.count == 2)
    #expect(analysis?.executionSegments?.first?.heartRateAverage == 140)
    #expect(analysis?.executionSegments?.last?.heartRateAverage == 154)
    #expect(analysis?.cadenceAverage == 174)
    #expect(analysis?.powerAverage == 290)
    #expect(analysis?.mechanicsConfidence == .moderate)
    #expect(analysis?.bestEffortEstimates.first { $0.label == "5K" }?.confidence == .limited)
    #expect(summary?.calculationVersion == DerivedWorkoutAnalysis.currentVersion)
    #expect(summary?.inputSignature.isEmpty == false)
}

@MainActor
@Test func derivedAnalyticsRecomputesFromCachedEvidenceOnSummaryRefresh() throws {
    let context = try inMemoryModelContext()
    let start = Date(timeIntervalSince1970: 5_000)
    var workout = testWorkout(
        id: "recomputed-derived-analysis",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .heartRate: testSeries(.heartRate, values: [140, 142, 145, 147], start: start)
        ]
    )
    PersistenceService.upsert([workout], context: context)
    let originalAnalysis = PersistenceService.fetchDerivedAnalysis(workoutID: workout.id, context: context)
    let originalSignature = PersistenceService.fetchDerivedAnalysisSummaries(context: context).first?.inputSignature

    let summaryRefresh = testWorkout(
        id: workout.id,
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_600
    )
    PersistenceService.upsert([summaryRefresh], context: context)

    let refreshedAnalysis = PersistenceService.fetchDerivedAnalysis(workoutID: workout.id, context: context)
    let refreshedSignature = PersistenceService.fetchDerivedAnalysisSummaries(context: context).first?.inputSignature

    #expect(originalAnalysis?.paceSecondsPerKmEstimate == 300)
    #expect(refreshedAnalysis?.paceSecondsPerKmEstimate == 320)
    #expect(originalSignature != refreshedSignature)
    #expect(refreshedAnalysis?.inputSummary.seriesSampleCounts[WorkoutEvidenceMetric.heartRate.rawValue] == 4)
    #expect(PersistenceService.refreshDerivedAnalyses(context: context) == 1)
}

@Test func derivedAnalyticsDowngradesPaceAndHeartRateWhenSeriesAreSparse() {
    let start = Date(timeIntervalSince1970: 6_000)
    let workout = testWorkout(
        id: "limited-derived-analysis",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .heartRate: testSeries(.heartRate, value: 145, start: start)
        ]
    )

    let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)

    #expect(analysis.paceSecondsPerKmEstimate == 300)
    #expect(analysis.paceConfidence == .limited)
    #expect(analysis.heartRateDriftPercent == nil)
    #expect(analysis.heartRateDriftConfidence == .unavailable)
    #expect(analysis.caveats.contains("Whole-workout average pace is an estimate until rolling speed or distance evidence exists."))
    #expect(analysis.caveats.contains("Heart-rate drift is unavailable without enough heart-rate samples."))
}

@Test func derivedAnalyticsUpgradesPaceConfidenceWithRollingEvidence() {
    let start = Date(timeIntervalSince1970: 7_000)
    let workout = testWorkout(
        id: "rolling-derived-analysis",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .runningSpeed: testSeries(.runningSpeed, values: [3.0, 3.2, 3.35, 3.45], start: start),
            .distance: testSeries(.distance, values: [400, 600, 4_000], start: start, interval: 300)
        ]
    )

    let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)

    #expect(analysis.paceConfidence == .moderate)
    #expect(analysis.pacingShape == "Faster finish")
    #expect(analysis.caveats.contains("Whole-workout average pace is an estimate until rolling speed or distance evidence exists.") == false)
    #expect(analysis.bestEffortEstimates.first { $0.label == "1K" }?.source == "rolling distance evidence")
    #expect(analysis.bestEffortEstimates.first { $0.label == "1K" }?.confidence == .moderate)
    #expect(analysis.splitEstimates?.first?.label == "KM 1")
    #expect(analysis.splitEstimates?.first?.durationSecondsEstimate == 300)
    #expect(analysis.splitEstimates?.first?.confidence == .moderate)
    #expect(analysis.executionSegments?.count == 2)
    #expect(abs((analysis.executionSegments?.first?.paceSecondsPerKmEstimate ?? 0) - 322.58) < 0.01)
    #expect(abs((analysis.executionSegments?.last?.paceSecondsPerKmEstimate ?? 0) - 294.11) < 0.01)
}

@Test func derivedAnalyticsInterpolatesSplitBoundaryTimesBetweenDistanceSamples() {
    let start = Date(timeIntervalSince1970: 8_000)
    let workout = testWorkout(
        id: "interpolated-splits",
        start: start,
        distanceMeters: 2_100,
        durationSeconds: 600
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(60), value: 900),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(180), value: 200),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(360), value: 900),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(420), value: 100)
                ]
            )
        ]
    )

    let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)
    let splits = analysis.splitEstimates ?? []

    #expect(splits.count == 2)
    #expect(splits[0].label == "KM 1")
    #expect(abs(splits[0].durationSecondsEstimate - 120) < 0.001)
    #expect(splits[1].label == "KM 2")
    #expect(abs(splits[1].durationSecondsEstimate - 240) < 0.001)
    #expect(analysis.bestEffortEstimates.first { $0.label == "1K" }?.durationSecondsEstimate == 120)
}

@Test func workoutEvidenceEventTranslatesRawHealthKitEventNamesForDisplay() {
    let start = Date(timeIntervalSince1970: 9_000)
    let rawSegment = WorkoutEvidenceEvent(
        startDate: start,
        endDate: start.addingTimeInterval(60),
        type: "HKWorkoutEventTypeSegment"
    )
    let rawValueLap = WorkoutEvidenceEvent(
        startDate: start,
        endDate: start.addingTimeInterval(60),
        type: "HKWorkoutEventType(rawValue: 3)"
    )
    let labeled = WorkoutEvidenceEvent(
        startDate: start,
        endDate: start.addingTimeInterval(60),
        type: "HKWorkoutEventTypeMarker",
        label: "Warmup"
    )

    #expect(rawSegment.displayLabel == "Segment")
    #expect(rawValueLap.displayLabel == "Lap")
    #expect(labeled.displayLabel == "Warmup")
}

@Test func workoutEventSummarySeparatesRawMarkersFromAppleFitnessIntervals() {
    let start = Date(timeIntervalSince1970: 9_500)
    let events = [
        WorkoutEvidenceEvent(
            startDate: start,
            endDate: start.addingTimeInterval(60),
            type: "HKWorkoutEventType(rawValue: 7)"
        ),
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(60),
            endDate: start.addingTimeInterval(120),
            type: "HKWorkoutEventType(rawValue: 7)"
        ),
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(120),
            endDate: start.addingTimeInterval(120),
            type: "HKWorkoutEventType(rawValue: 1)"
        ),
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(180),
            endDate: start.addingTimeInterval(240),
            type: "HKWorkoutEventTypeMarker",
            label: "Warmup"
        )
    ]

    let summary = WorkoutEventSummary(events: events)

    #expect(summary.totalCount == 4)
    #expect(summary.segmentCount == 2)
    #expect(summary.pauseCount == 1)
    #expect(summary.labeledIntervalCount == 1)
    #expect(summary.healthKitSummary.contains("2 segment markers"))
    #expect(summary.healthKitSummary.contains("1 pause markers"))
}

@Test func derivedIntervalCandidatesCalculateDistancePaceAndHeartRateFromEventWindows() {
    let start = Date(timeIntervalSince1970: 9_700)
    let workout = testWorkout(
        id: "derived-intervals",
        start: start,
        distanceMeters: 2_560,
        durationSeconds: 945
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(750), value: 2_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(840), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(945), value: 160)
                ]
            ),
            .heartRate: WorkoutMetricSeries(
                metric: .heartRate,
                unit: "bpm",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 130),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(780), value: 170),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(900), value: 145)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start, endDate: start.addingTimeInterval(750), type: "HKWorkoutEventTypeSegment", label: "Warmup"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(750), endDate: start.addingTimeInterval(840), type: "HKWorkoutEventTypeSegment", label: "Work"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(840), endDate: start.addingTimeInterval(945), type: "HKWorkoutEventTypeSegment", label: "Recovery")
        ]
    )

    let candidates = DerivedAnalyticsEngine.intervalCandidates(workout: workout, evidence: evidence)

    #expect(candidates.count == 3)
    #expect(candidates[0].label == .warmup)
    #expect(candidates[0].distanceMeters == 2_000)
    #expect(candidates[0].durationSeconds == 750)
    #expect(candidates[0].paceSecondsPerKm == 375)
    #expect(candidates[0].caveats.contains("Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted."))
    #expect(candidates[0].averageHeartRateBpm == 130)
    #expect(candidates[0].startOffsetSeconds == 0)
    #expect(candidates[0].endOffsetSeconds == 750)
    #expect(candidates[0].markerKind == .appleFitnessIntervalCandidate)
    #expect(candidates[0].confidence == .strong)
    #expect(candidates[1].label == .work)
    #expect(candidates[1].distanceMeters == 400)
    #expect(candidates[1].paceSecondsPerKm == 225)
    #expect(candidates[2].label == .recovery)
    #expect(candidates[2].distanceMeters == 160)
    #expect(abs((candidates[2].paceSecondsPerKm ?? 0) - 656.25) < 0.001)
}

@Test func workoutKitSpeedRangeConvertsToPaceRangeFastToSlow() {
    let display = WorkoutIntervalReconstructionFormat.paceRangeDisplay(
        speedLowerMetersPerSecond: 2.56,
        speedUpperMetersPerSecond: 2.78
    )
    let workDisplay = WorkoutIntervalReconstructionFormat.paceRangeDisplay(
        speedLowerMetersPerSecond: 4.35,
        speedUpperMetersPerSecond: 4.55
    )

    #expect(display == "6:00-6:30 /km")
    #expect(workDisplay == "3:40-3:50 /km")
}

@Test func workoutKitReconstructionUsesPlanDistanceTimeAndTailWithoutSegmentMarkers() {
    let start = Date(timeIntervalSince1970: 10_250)
    let workout = testWorkout(
        id: "workoutkit-reconstruction",
        start: start,
        distanceMeters: 2_565,
        durationSeconds: 951
    )
    let plannedSteps = [
        PlannedWorkoutStep(
            index: 1,
            label: "Warmup",
            stepType: .warmup,
            plannedGoalType: .distance,
            plannedGoalValue: 2_000,
            plannedGoalDisplayText: "2 km",
            plannedTargetDisplayText: "pace range 6:00-6:30 /km"
        ),
        PlannedWorkoutStep(
            index: 2,
            label: "Work 1",
            stepType: .work,
            repeatBlockIndex: 1,
            repeatIndex: 1,
            plannedGoalType: .distance,
            plannedGoalValue: 400,
            plannedGoalDisplayText: "400 m",
            plannedTargetDisplayText: "pace range 3:40-3:50 /km"
        ),
        PlannedWorkoutStep(
            index: 3,
            label: "Recovery 1",
            stepType: .recovery,
            repeatBlockIndex: 1,
            repeatIndex: 1,
            plannedGoalType: .time,
            plannedGoalValue: 105,
            plannedGoalDisplayText: "105 s"
        )
    ]
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(750), value: 2_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(840), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(945), value: 160),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(951), value: 5)
                ]
            ),
            .heartRate: WorkoutMetricSeries(
                metric: .heartRate,
                unit: "bpm",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 129),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(780), value: 164),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(900), value: 147),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(950), value: 154)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start, endDate: start.addingTimeInterval(300), type: "HKWorkoutEventTypeSegment"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(150), endDate: start.addingTimeInterval(450), type: "HKWorkoutEventTypeSegment")
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, planType: "Custom workout", plannedSteps: plannedSteps)
    )

    let result = WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence)

    #expect(result?.intervals.count == 4)
    #expect(result?.notes.contains("HealthKit segment markers: not used") == true)
    #expect(result?.intervals[0].label == "Warmup")
    #expect(result?.intervals[0].actualDurationSeconds == 750)
    #expect(result?.intervals[0].actualDistanceMeters == 2_000)
    #expect(result?.intervals[0].actualPaceSecondsPerKm == 375)
    #expect(result?.intervals[1].label == "Work 1")
    #expect(result?.intervals[1].actualDurationSeconds == 90)
    #expect(result?.intervals[1].actualDistanceMeters == 400)
    #expect(result?.intervals[2].label == "Recovery 1")
    #expect(result?.intervals[2].actualDurationSeconds == 105)
    #expect(result?.intervals[2].actualDistanceMeters == 160)
    #expect(result?.intervals[3].label == "Open / Extra")
    #expect(result?.intervals[3].actualDurationSeconds == 6)
    #expect(result?.intervals[3].actualDistanceMeters == 5)
}

@Test func rawHealthKitDebugExportIncludesReconstructedIntervalsAndJsonPayload() throws {
    let start = Date(timeIntervalSince1970: 10_275)
    var workout = testWorkout(
        id: "raw-debug-export",
        start: start,
        distanceMeters: 2_565,
        durationSeconds: 951
    )
    workout.heartRateSampleCount = 2
    workout.distanceSampleCount = 4
    workout.intervalCount = 1
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(750), value: 2_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(840), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(945), value: 160),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(951), value: 5)
                ]
            ),
            .heartRate: WorkoutMetricSeries(
                metric: .heartRate,
                unit: "bpm",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 129),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(780), value: 164)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(
                startDate: start,
                endDate: start.addingTimeInterval(750),
                type: "HKWorkoutEventTypeSegment",
                metadataKeys: ["HKMetadataKeyIndoorWorkout"]
            )
        ],
        activities: [
            WorkoutEvidenceActivity(
                id: "activity-1",
                activityType: "HKWorkoutActivityTypeRunning",
                locationType: "outdoor",
                startDate: start,
                endDate: start.addingTimeInterval(750),
                durationSeconds: 750,
                metadataKeys: ["HKMetadataKeyWorkoutBrandName"],
                events: [
                    WorkoutEvidenceEvent(
                        startDate: start,
                        endDate: start.addingTimeInterval(750),
                        type: "HKWorkoutEventTypeSegment",
                        label: "Activity segment",
                        metadataKeys: ["ActivityEventKey"]
                    )
                ],
                statistics: [
                    WorkoutEvidenceActivityStatistic(
                        quantityType: "HKQuantityTypeIdentifierDistanceWalkingRunning",
                        unit: "m",
                        startDate: start,
                        endDate: start.addingTimeInterval(750),
                        sourceCount: 1,
                        sum: 2_000,
                        durationSeconds: 750
                    )
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            planType: "Custom workout",
            displayName: "Export Test",
            plannedSteps: [
                PlannedWorkoutStep(
                    index: 1,
                    label: "Warmup",
                    stepType: .warmup,
                    plannedGoalType: .distance,
                    plannedGoalValue: 2_000,
                    plannedGoalDisplayText: "2 km"
                )
            ]
        )
    )

    let markdown = DiagnosticsExport.rawHealthKitDebugMarkdown(workout: workout, generatedAt: start)

    #expect(markdown.contains("# RunSignal Raw HealthKit Debug Export"))
    #expect(markdown.contains("## WorkoutKit Reconstructed Intervals"))
    #expect(markdown.contains("| 1 | Warmup | 2 km"))
    #expect(markdown.contains("## HKWorkoutActivity Boundary Candidate Intervals"))
    #expect(markdown.contains("Debug-only alternate reconstruction for Parity Lab exports."))
    #expect(markdown.contains("HKWorkoutActivity boundary rows are debug-only Parity Lab output and are not production UI."))
    #expect(markdown.contains("activity boundary direct"))
    #expect(markdown.contains("activity boundary inferred tail"))
    #expect(markdown.contains("Open / Extra"))
    #expect(markdown.contains("Boundary Strategy"))
    #expect(markdown.contains("## Custom Workout Candidate Rule Scorer"))
    #expect(markdown.contains("Debug-only Parity Lab scorer for active-time duration"))
    #expect(markdown.contains("do not approve a normal-detail gate"))
    #expect(markdown.contains("active-duration-minus-paired-pause-overlap"))
    #expect(markdown.contains("## Custom Workout Structured Comparison"))
    #expect(markdown.contains("does not approve a normal-detail gate by itself"))
    #expect(markdown.contains("| Status | open-tail-needs-rule |"))
    #expect(markdown.contains("## WorkoutKit Boundary Diagnostics"))
    #expect(markdown.contains("## Raw HKWorkoutEvent Inventory"))
    #expect(markdown.contains("HKMetadataKeyIndoorWorkout"))
    #expect(markdown.contains("## HKWorkoutActivity Inventory"))
    #expect(markdown.contains("HKWorkoutActivityTypeRunning"))
    #expect(markdown.contains("HKMetadataKeyWorkoutBrandName"))
    #expect(markdown.contains("Activity segment"))
    #expect(markdown.contains("DistanceWalkingRunning"))
    #expect(markdown.contains("## Planned Step Boundary Comparison"))
    #expect(markdown.contains("Manual FIT placeholder"))
    #expect(markdown.contains("Nearest Activity End"))
    #expect(markdown.contains("## Boundary Source Warnings"))
    #expect(markdown.contains("Target distance"))
    #expect(markdown.contains("Boundary sample"))
    #expect(markdown.contains("Row 2: Open / Extra Tail"))
    #expect(markdown.contains("Final distance sample offset"))
    #expect(markdown.contains("HealthKit Segment Markers must not be promoted as Apple Fitness interval rows."))
    #expect(markdown.contains("## JSON Payload"))
    #expect(markdown.contains("\"reconstructedIntervals\""))
    #expect(markdown.contains("\"activityBoundaryCandidateSummary\""))
    #expect(markdown.contains("\"activityBoundaryCandidateIntervals\""))
    #expect(markdown.contains("\"customWorkoutCandidateRuleSummary\""))
    #expect(markdown.contains("\"customWorkoutCandidateRuleRows\""))
    #expect(markdown.contains("\"plannedExpandedRowCount\""))
    #expect(markdown.contains("\"fixedRowExhaustionStatus\""))
    #expect(markdown.contains("\"tailStatus\""))
    #expect(markdown.contains("\"tailElapsedDurationSeconds\""))
    #expect(markdown.contains("\"tailDistanceMeters\""))
    #expect(markdown.contains("\"fallbackReasons\""))
    #expect(markdown.contains("\"safetyFlags\""))
    #expect(markdown.contains("\"fitValidationStatus\" : \"offline-evidence-only-not-runtime-truth\""))
    #expect(markdown.contains("\"durationDisplayRule\""))
    #expect(markdown.contains("\"startOffsetSeconds\""))
    #expect(markdown.contains("\"endOffsetSeconds\""))
    #expect(markdown.contains("\"customWorkoutComparisonSummary\""))
    #expect(markdown.contains("\"status\" : \"open-tail-needs-rule\""))
    #expect(markdown.contains("\"fallbackReasons\" : ["))
    #expect(markdown.contains("\"openExtraTailAmbiguous\""))
    #expect(markdown.contains("\"strategyID\" : \"custom_workout_candidate_rule_active_time\""))
    #expect(markdown.contains("\"strategyID\" : \"hkworkoutactivity_boundary\""))
    #expect(markdown.contains("\"productionIntervalBehaviorChanged\" : false"))
    #expect(markdown.contains("\"normalWorkoutUIChanged\" : false"))
    #expect(markdown.contains("\"boundaryLogicChanged\" : false"))
    #expect(markdown.contains("\"usesFITRuntimeTruth\" : false"))
    #expect(markdown.contains("\"usesAppleFitnessManualRuntimeLogic\" : false"))
    #expect(markdown.contains("\"boundaryDiagnostics\""))
    #expect(markdown.contains("\"tailDiagnostics\""))
    #expect(markdown.contains("\"segmentMarkers\""))
    #expect(markdown.contains("\"rawWorkoutEvents\""))
    #expect(markdown.contains("\"workoutActivities\""))
    #expect(markdown.contains("\"alignsWithPlannedStep\""))
    #expect(markdown.contains("\"nearestWorkoutActivityEndOffsetSeconds\""))
    #expect(markdown.contains("\"plannedStepBoundaryComparisons\""))
    #expect(markdown.contains("\"boundarySourceWarnings\""))
    #expect(markdown.contains("\"workoutKitPlanAudit\""))

    let payload = try rawDebugPayloadObject(from: markdown)
    let candidateSummary = try #require(payload["customWorkoutCandidateRuleSummary"] as? [String: Any])
    let candidateRows = try #require(payload["customWorkoutCandidateRuleRows"] as? [[String: Any]])
    let openTailRows = candidateRows.filter { ($0["isOpenTail"] as? Bool) == true }
    #expect(candidateSummary["candidateRowCount"] as? Int == candidateRows.count)
    #expect(candidateSummary["plannedExpandedRowCount"] as? Int == 1)
    #expect(candidateSummary["openTailRowCount"] as? Int == openTailRows.count)
    #expect(candidateSummary["fixedRowExhaustionStatus"] as? String == "fixed-rows-exhausted-before-tail")
    #expect(candidateSummary["tailStatus"] as? String == "open-extra-tail-present")
    #expect(candidateSummary["tailElapsedDurationSeconds"] as? Double == 201)
    #expect(candidateSummary["tailDistanceMeters"] as? Double == 565)
    #expect(candidateSummary["fallbackReasons"] as? [String] == [])
    #expect(candidateSummary["safetyFlags"] as? [String] != nil)
    #expect(candidateSummary["fitValidationStatus"] as? String == "offline-evidence-only-not-runtime-truth")
    let firstCandidateRow = try #require(candidateRows.first)
    #expect(firstCandidateRow["startOffsetSeconds"] as? Double == 0)
    #expect(firstCandidateRow["endOffsetSeconds"] as? Double == 750)
    #expect(firstCandidateRow["durationDisplayRule"] as? String == "active-duration-minus-paired-pause-overlap")
    let openTailRow = try #require(openTailRows.first)
    #expect(openTailRow["durationDisplayRule"] as? String == "open-tail-measured-duration")

    let comparisonSummary = try #require(payload["customWorkoutComparisonSummary"] as? [String: Any])
    let rowConfidences = try #require(comparisonSummary["rowConfidences"] as? [String])
    #expect(comparisonSummary["rowCount"] as? Int == rowConfidences.count)
    #expect(comparisonSummary["status"] as? String == "open-tail-needs-rule")
}

@Test func parityPacketExportIncludesStableDebugOnlyRefreshFields() {
    let start = Date(timeIntervalSince1970: 10_275)
    var workout = testWorkout(
        id: "parity-packet-export",
        start: start,
        distanceMeters: 1_000,
        durationSeconds: 300
    )
    workout.distanceSampleCount = 1
    workout.heartRateSampleCount = 1
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 1_000)]
            )
        ],
        events: [
            WorkoutEvidenceEvent(
                startDate: start,
                endDate: start.addingTimeInterval(300),
                type: "HKWorkoutEventTypeSegment",
                metadataKeys: ["source"]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .unavailable,
            summaryLines: ["WorkoutKit returned no workout plan for this completed workout."]
        ),
        diagnostics: WorkoutEvidenceDiagnostics(queryDiagnostics: [
            WorkoutEvidenceQueryDiagnostic(name: "distance", status: .loaded, count: 1),
            WorkoutEvidenceQueryDiagnostic(name: "workoutKitPlan", status: .unavailable, count: 0, message: "No plan")
        ])
    )
    let forceResult = ParityForceReenrichResult(
        workoutID: workout.id,
        requestedAt: start,
        completedAt: start.addingTimeInterval(2),
        cacheWasPresent: true,
        invalidatedCache: true,
        freshQueryReturnedWorkout: true,
        authorizationState: .authorized,
        message: "Enriched 1 HealthKit running workouts.",
        evidenceCounts: ParityEvidenceCounts(workout: workout),
        diagnosticsWarnings: ["workoutKitPlan: No plan"]
    )

    let json = DiagnosticsExport.parityPacketJSON(workout: workout, forceReenrichResult: forceResult, generatedAt: start)

    #expect(json.contains("\"packetVersion\" : 1"))
    #expect(json.contains("\"cacheStatus\""))
    #expect(json.contains("\"evidenceSource\" : \"freshQuery\""))
    #expect(json.contains("\"forceReenrichResult\""))
    #expect(json.contains("\"invalidatedCache\" : true"))
    #expect(json.contains("\"evidenceCounts\""))
    #expect(json.contains("\"workoutKitPlanAudit\""))
    #expect(json.contains("\"reconstructedIntervals\""))
    #expect(json.contains("\"activityBoundaryCandidateSummary\""))
    #expect(json.contains("\"activityBoundaryCandidateIntervals\""))
    #expect(json.contains("\"strategyID\" : \"hkworkoutactivity_boundary\""))
    #expect(json.contains("\"customWorkoutCandidateRuleSummary\""))
    #expect(json.contains("\"customWorkoutCandidateRuleRows\""))
    #expect(json.contains("\"customWorkoutComparisonSummary\""))
    #expect(json.contains("\"status\" : \"missing-required-evidence\""))
    #expect(json.contains("\"missingPlannedSteps\""))
    #expect(json.contains("\"missingActivityRows\""))
    #expect(json.contains("\"strategyID\" : \"custom_workout_candidate_rule_active_time\""))
    #expect(json.contains("\"scope\" : \"debug\\/export-only\""))
    #expect(json.contains("\"productionIntervalBehaviorChanged\" : false"))
    #expect(json.contains("\"normalWorkoutUIChanged\" : false"))
    #expect(json.contains("\"boundaryLogicChanged\" : false"))
    #expect(json.contains("\"usesFITRuntimeTruth\" : false"))
    #expect(json.contains("\"usesAppleFitnessManualRuntimeLogic\" : false"))
    #expect(json.contains("WorkoutKit planned steps are missing."))
    #expect(json.contains("\"rawWorkoutEvents\""))
    #expect(json.contains("\"workoutActivities\""))
    #expect(json.contains("\"activities\" : 0"))
    #expect(json.contains("\"metadataKeys\""))
    #expect(json.contains("\"plannedStepBoundaryComparisons\""))
    #expect(json.contains("\"boundarySourceWarnings\""))
    #expect(json.contains("No HKWorkoutActivity records exist for this workout."))
    #expect(json.contains("\"diagnosticsWarnings\""))
}

@Test func parityPacketExportIncludesDebugOnlyActiveTimeRuleScorer() throws {
    let start = Date(timeIntervalSince1970: 1_797_000_000)
    var workout = testWorkout(
        id: "active-time-rule",
        start: start,
        distanceMeters: 1_200,
        durationSeconds: 240
    )
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        events: [
            WorkoutEvidenceEvent(
                startDate: start.addingTimeInterval(100),
                endDate: start.addingTimeInterval(100),
                type: "HKWorkoutEventType(rawValue: 1)"
            ),
            WorkoutEvidenceEvent(
                startDate: start.addingTimeInterval(160),
                endDate: start.addingTimeInterval(160),
                type: "HKWorkoutEventType(rawValue: 2)"
            )
        ],
        activities: [
            WorkoutEvidenceActivity(
                id: "activity-1",
                activityType: "HKWorkoutActivityTypeRunning",
                startDate: start,
                endDate: start.addingTimeInterval(300),
                durationSeconds: 300,
                statistics: [
                    WorkoutEvidenceActivityStatistic(
                        quantityType: "HKQuantityTypeIdentifierDistanceWalkingRunning",
                        unit: "m",
                        startDate: start,
                        endDate: start.addingTimeInterval(300),
                        sourceCount: 1,
                        sum: 1_200,
                        durationSeconds: 300
                    )
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            planType: "Custom workout",
            displayName: "Active Time Rule Test",
            plannedSteps: [
                PlannedWorkoutStep(
                    index: 1,
                    label: "Work",
                    stepType: .work,
                    plannedGoalType: .distance,
                    plannedGoalValue: 1_200,
                    plannedGoalDisplayText: "1.2 km"
                )
            ]
        )
    )

    let json = DiagnosticsExport.parityPacketJSON(workout: workout, forceReenrichResult: nil, generatedAt: start)
    let data = try #require(json.data(using: .utf8))
    let object = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    let summary = try #require(object["customWorkoutCandidateRuleSummary"] as? [String: Any])
    let rows = try #require(object["customWorkoutCandidateRuleRows"] as? [[String: Any]])
    let row = try #require(rows.first)

    #expect(summary["strategyID"] as? String == "custom_workout_candidate_rule_active_time")
    #expect(summary["scope"] as? String == "debug/export-only")
    #expect(summary["pairedPauseCount"] as? Int == 1)
    #expect(summary["totalPairedPauseSeconds"] as? Double == 60)
    #expect(summary["productionIntervalBehaviorChanged"] as? Bool == false)
    #expect(summary["normalWorkoutUIChanged"] as? Bool == false)
    #expect(summary["usesFITRuntimeTruth"] as? Bool == false)
    #expect(summary["usesAppleFitnessManualRuntimeLogic"] as? Bool == false)
    let comparisonSummary = try #require(object["customWorkoutComparisonSummary"] as? [String: Any])
    #expect(comparisonSummary["status"] as? String == "supported")
    #expect((comparisonSummary["fallbackReasons"] as? [String])?.isEmpty == true)
    #expect(comparisonSummary["promotesProductionBehavior"] as? Bool == false)
    #expect(comparisonSummary["normalWorkoutUIChanged"] as? Bool == false)
    #expect(comparisonSummary["usesFITRuntimeTruth"] as? Bool == false)
    #expect(row["elapsedDurationSeconds"] as? Double == 300)
    #expect(row["pauseOverlapSeconds"] as? Double == 60)
    #expect(row["activeDurationSeconds"] as? Double == 240)
    #expect(row["durationRule"] as? String == "active-duration-minus-paired-pause-overlap")
}

@Test func workoutEvidenceDecodesMissingWorkoutActivitiesAsEmpty() throws {
    let encoded = try JSONEncoder().encode(
        WorkoutEvidence(
            workoutID: "legacy-evidence",
            loadedAt: Date(timeIntervalSince1970: 0),
            series: [:],
            route: [],
            events: []
        )
    )
    var object = try #require(JSONSerialization.jsonObject(with: encoded) as? [String: Any])
    object.removeValue(forKey: "activities")
    let json = try JSONSerialization.data(withJSONObject: object)

    let evidence = try JSONDecoder().decode(WorkoutEvidence.self, from: json)

    #expect(evidence.activities.isEmpty)
}

@Test func jun10WorkoutKitReconstructionMatchesAppleFitnessFixtureTolerances() throws {
    let start = Date(timeIntervalSince1970: 10_300)
    let workout = testWorkout(
        id: "jun-10-workoutkit-fixture",
        start: start,
        distanceMeters: 6_759,
        durationSeconds: 2_443,
        inferredRunType: .interval
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(750), value: 2_008),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(840), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(945), value: 160),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(1_036), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(1_141), value: 164),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(1_229), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(1_334), value: 147),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(1_421), value: 400),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(1_526), value: 167),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(2_437), value: 2_508),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(2_443), value: 5)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start, endDate: start.addingTimeInterval(376), type: "HKWorkoutEventTypeSegment"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(376), endDate: start.addingTimeInterval(747), type: "HKWorkoutEventTypeSegment")
        ],
        workoutPlanAudit: WorkoutPlanAudit(
            status: .available,
            planType: "Custom workout",
            displayName: "Wednesday Interval (6kmm)",
            plannedSteps: jun10PlannedWorkoutSteps()
        )
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))
    let rows = result.intervals

    #expect(rows.count == 11)
    assertInterval(rows[0], label: "Warmup", expectedDuration: 750, durationTolerance: 3, expectedDistance: 2_000, distanceTolerance: 15)
    assertInterval(rows[1], label: "Work 1", expectedDuration: 90, durationTolerance: 3, expectedDistance: 400, distanceTolerance: 5)
    assertInterval(rows[2], label: "Recovery 1", expectedDuration: 105, durationTolerance: 1, expectedDistance: 160, distanceTolerance: 15)
    assertInterval(rows[3], label: "Work 2", expectedDuration: 91, durationTolerance: 3, expectedDistance: 400, distanceTolerance: 5)
    assertInterval(rows[4], label: "Recovery 2", expectedDuration: 105, durationTolerance: 1, expectedDistance: 164, distanceTolerance: 15)
    assertInterval(rows[5], label: "Work 3", expectedDuration: 88, durationTolerance: 3, expectedDistance: 400, distanceTolerance: 5)
    assertInterval(rows[6], label: "Recovery 3", expectedDuration: 105, durationTolerance: 1, expectedDistance: 147, distanceTolerance: 15)
    assertInterval(rows[7], label: "Work 4", expectedDuration: 87, durationTolerance: 3, expectedDistance: 400, distanceTolerance: 5)
    assertInterval(rows[8], label: "Recovery 4", expectedDuration: 105, durationTolerance: 1, expectedDistance: 167, distanceTolerance: 15)
    assertInterval(rows[9], label: "Cooldown", expectedDuration: 911, durationTolerance: 3, expectedDistance: 2_500, distanceTolerance: 15)
    assertInterval(rows[10], label: "Open / Extra", expectedDuration: 6, durationTolerance: 5, expectedDistance: 5, distanceTolerance: 10)
    #expect(rows[0].boundaryStrategy == .crossingSampleEnd)
    #expect(abs((rows[0].boundaryAdjustmentSeconds ?? 0) - 2.988) < 0.01)
    #expect(rows[10].actualDurationSeconds <= 11)
    #expect(result.notes.contains("HealthKit segment markers: not used"))
}

@Test func distanceGoalBoundaryUsesInterpolatedCrossingWhenSampleEndOvershootsTooMuch() throws {
    let start = Date(timeIntervalSince1970: 10_400)
    let workout = testWorkout(id: "distance-boundary-interpolation", start: start, distanceMeters: 1_020, durationSeconds: 120)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(100), value: 1_020)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))
    let interval = try #require(result.intervals.first)

    #expect(interval.boundaryStrategy == .interpolatedCrossing)
    #expect(abs(interval.actualDurationSeconds - 98.039) < 0.01)
    #expect(abs((interval.actualDistanceMeters ?? 0) - 1_000) < 0.01)
    #expect(abs((interval.boundaryOvershootMeters ?? 0) - 20) < 0.001)
}

@Test func distanceGoalBoundaryUsesCrossingSampleEndWhenOvershootIsSmall() throws {
    let start = Date(timeIntervalSince1970: 10_500)
    let workout = testWorkout(id: "distance-boundary-sample-end", start: start, distanceMeters: 1_008, durationSeconds: 106)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(100), value: 1_008),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(106), value: 0)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))
    let interval = try #require(result.intervals.first)

    #expect(interval.boundaryStrategy == .crossingSampleEnd)
    #expect(interval.actualDurationSeconds == 100)
    #expect(interval.actualDistanceMeters == 1_008)
    #expect(abs((interval.boundaryAdjustmentSeconds ?? 0) - 0.794) < 0.01)
    #expect(interval.sourceNote.contains("crossing sample end"))
}

@Test func adjustedDistanceBoundaryAdvancesCursorAndShrinksOpenTail() throws {
    let start = Date(timeIntervalSince1970: 10_600)
    let workout = testWorkout(id: "cursor-after-sample-end", start: start, distanceMeters: 1_509, durationSeconds: 171)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(65), value: 504),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(165), value: 1_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(171), value: 5)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 500, plannedGoalDisplayText: "500 m"),
            PlannedWorkoutStep(index: 2, label: "Recovery 1", stepType: .recovery, plannedGoalType: .time, plannedGoalValue: 100, plannedGoalDisplayText: "100 s")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Warmup", "Recovery 1", "Open / Extra"])
    #expect(result.intervals[0].actualDurationSeconds == 65)
    #expect(result.intervals[0].boundaryStrategy == .crossingSampleEnd)
    #expect(result.intervals[1].actualStartDate == start.addingTimeInterval(65))
    #expect(result.intervals[1].actualDurationSeconds == 100)
    #expect(result.intervals[2].actualDurationSeconds == 6)
    #expect(result.intervals[2].actualDistanceMeters == 5)
}

@Test func finalPlannedOpenCooldownExtendsToWorkoutEndWithoutOpenExtraTail() throws {
    let start = Date(timeIntervalSince1970: 10_650)
    let workout = testWorkout(id: "open-cooldown", start: start, distanceMeters: 1_500, durationSeconds: 900)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(600), value: 1_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(900), value: 500)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 2, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Work 1", "Cooldown"])
    #expect(result.intervals[1].stepType == .cooldown)
    #expect(result.intervals[1].plannedGoalType == .open)
    #expect(result.intervals[1].actualStartDate == start.addingTimeInterval(600))
    #expect(result.intervals[1].actualEndDate == workout.endDate)
    #expect(result.intervals[1].actualDurationSeconds == 300)
    #expect(result.intervals[1].actualDistanceMeters == 500)
    #expect(result.intervals[1].sourceNote == "Planned open cooldown extended to workout end")
    #expect(result.intervals.map(\.label).contains("Open / Extra") == false)
}

@Test func normalDetailGateSupportsOnlyNarrowWarmupWorkOpenCooldown() throws {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "normal-detail-narrow", start: start, distanceMeters: 3_500, durationSeconds: 1_500)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 600, plannedGoalDisplayText: "600 s"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 1_400, 1_250),
            (1_400, 1_500, 250)
        ],
        distancePoints: [
            (800, 2_000),
            (1_400, 1_250),
            (1_500, 250)
        ]
    )

    let result = try #require(CustomWorkoutNormalDetailGate.supportedNarrowWarmupWorkOpenCooldown(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Warmup", "Work 1", "Cooldown"])
    #expect(result.intervals.map(\.stepType) == [.warmup, .work, .cooldown])
    #expect(result.intervals.map(\.label).contains("Open / Extra") == false)
    assertElapsedTimingSemantics(result.intervals)
}

@Test func normalDetailGateBlocksPausedTimeGoalWarmupWorkOpenCooldown() {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "normal-detail-paused-time-goal", start: start, distanceMeters: 3_500, durationSeconds: 1_500)
    var evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 600, plannedGoalDisplayText: "600 s"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 1_400, 1_250),
            (1_400, 1_500, 250)
        ],
        distancePoints: [
            (800, 2_000),
            (1_400, 1_250),
            (1_500, 250)
        ]
    )
    evidence.events = [
        WorkoutEvidenceEvent(startDate: start.addingTimeInterval(900), endDate: start.addingTimeInterval(900), type: "HKWorkoutEventType(rawValue: 1)"),
        WorkoutEvidenceEvent(startDate: start.addingTimeInterval(960), endDate: start.addingTimeInterval(960), type: "HKWorkoutEventType(rawValue: 2)")
    ]

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowWarmupWorkOpenCooldown(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: evidence).contains {
        $0.contains("pause/resume")
    })
}

@Test func pauseWindowResolverUsesStateMachineForCleanPairsAndToggles() {
    let start = Date(timeIntervalSince1970: 10_655)
    let workoutEnd = start.addingTimeInterval(600)

    let clean = PauseWindowResolver.resolve(
        events: [
            PauseResolutionEvent(timestamp: start.addingTimeInterval(120), kind: .pause),
            PauseResolutionEvent(timestamp: start.addingTimeInterval(180), kind: .resume)
        ],
        workoutStart: start,
        workoutEnd: workoutEnd
    )

    #expect(clean.confidence == .high)
    #expect(clean.caveats.isEmpty)
    #expect(clean.intervals.count == 1)
    #expect(abs((clean.intervals.first?.duration ?? 0) - 60) <= 0.001)

    let toggleOnly = PauseWindowResolver.resolve(
        events: [
            PauseResolutionEvent(timestamp: start.addingTimeInterval(240), kind: .toggle),
            PauseResolutionEvent(timestamp: start.addingTimeInterval(300), kind: .toggle)
        ],
        workoutStart: start,
        workoutEnd: workoutEnd
    )

    #expect(toggleOnly.confidence == .high)
    #expect(toggleOnly.caveats.isEmpty)
    #expect(toggleOnly.intervals.count == 1)
    #expect(abs((toggleOnly.intervals.first?.duration ?? 0) - 60) <= 0.001)
}

@Test func pauseWindowResolverFlagsMalformedPauseStreams() {
    let start = Date(timeIntervalSince1970: 10_655)
    let workoutEnd = start.addingTimeInterval(600)

    let duplicatePause = PauseWindowResolver.resolve(
        events: [
            PauseResolutionEvent(timestamp: start.addingTimeInterval(120), kind: .pause),
            PauseResolutionEvent(timestamp: start.addingTimeInterval(150), kind: .pause),
            PauseResolutionEvent(timestamp: start.addingTimeInterval(210), kind: .resume)
        ],
        workoutStart: start,
        workoutEnd: workoutEnd
    )

    #expect(duplicatePause.confidence == .low)
    #expect(duplicatePause.isReliableForNormalDetail == false)
    #expect(duplicatePause.caveats.contains("Duplicate pause event ignored"))
    #expect(duplicatePause.intervals.count == 1)
    #expect(abs((duplicatePause.intervals.first?.duration ?? 0) - 90) <= 0.001)

    let danglingPause = PauseWindowResolver.resolve(
        events: [
            PauseResolutionEvent(timestamp: start.addingTimeInterval(540), kind: .pause)
        ],
        workoutStart: start,
        workoutEnd: workoutEnd
    )

    #expect(danglingPause.confidence == .low)
    #expect(danglingPause.isReliableForNormalDetail == false)
    #expect(danglingPause.caveats.contains("Dangling pause closed at workout end"))
    #expect(danglingPause.intervals.count == 1)
    #expect(abs((danglingPause.intervals.first?.duration ?? 0) - 60) <= 0.001)
}

@Test func pauseWindowResolverReturnsElapsedTimingWhenThereAreNoPauses() {
    let start = Date(timeIntervalSince1970: 10_655)
    let resolution = PauseWindowResolver.resolve(
        events: [],
        workoutStart: start,
        workoutEnd: start.addingTimeInterval(600)
    )

    #expect(resolution.confidence == .high)
    #expect(resolution.caveats.isEmpty)
    #expect(resolution.intervals.isEmpty)
}

@Test func reconstructedIntervalsResolvePauseResumeRequestToggleEvents() throws {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "pause-resume-request-timing", start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "2 min"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalValue: nil, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 920, 400),
            (920, 1_200, 600)
        ],
        distancePoints: [(0, 0), (800, 2_000), (920, 2_400), (1_200, 3_000)],
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(830), endDate: start.addingTimeInterval(830), type: "HKWorkoutEventTypePauseOrResumeRequest", label: "Pause/resume request"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(860), endDate: start.addingTimeInterval(860), type: "HKWorkoutEventTypePauseOrResumeRequest", label: "Pause/resume request")
        ]
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence))
    let work = try #require(result.intervals.first { $0.label == "Work 1" })

    #expect(abs((work.pauseOverlapSeconds ?? 0) - 30) <= 0.001)
    #expect(abs((work.activeDurationSeconds ?? 0) - 90) <= 0.001)
}

@Test func reconstructedIntervalsResolveMixedManualAndMotionPauseEvents() throws {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "mixed-manual-motion-pauses", start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "2 min"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalValue: nil, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 920, 400),
            (920, 1_200, 600)
        ],
        distancePoints: [(0, 0), (800, 2_000), (920, 2_400), (1_200, 3_000)],
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(830), endDate: start.addingTimeInterval(830), type: "HKWorkoutEventType(rawValue: 1)", label: "Pause"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(860), endDate: start.addingTimeInterval(860), type: "HKWorkoutEventType(rawValue: 2)", label: "Resume"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(880), endDate: start.addingTimeInterval(880), type: "HKWorkoutEventTypeMotionPaused"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(900), endDate: start.addingTimeInterval(900), type: "HKWorkoutEventTypeMotionResumed")
        ]
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence))
    let work = try #require(result.intervals.first { $0.label == "Work 1" })

    #expect(abs((work.pauseOverlapSeconds ?? 0) - 50) <= 0.001)
    #expect(abs((work.activeDurationSeconds ?? 0) - 70) <= 0.001)
}

@Test func reconstructedIntervalsCarryPausedTimingSemanticsWithoutPromotion() throws {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "paused-timing-semantics", start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "2 min"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalValue: nil, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 920, 400),
            (920, 1_200, 600)
        ],
        distancePoints: [(0, 0), (800, 2_000), (920, 2_400), (1_200, 3_000)],
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(830), endDate: start.addingTimeInterval(830), type: "HKWorkoutEventType(rawValue: 1)", label: "Pause"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(860), endDate: start.addingTimeInterval(860), type: "HKWorkoutEventType(rawValue: 2)", label: "Resume")
        ]
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstructFromActivityBoundaries(workout: workout, evidence: evidence))
    let work = try #require(result.intervals.first { $0.label == "Work 1" })

    #expect(abs(work.actualDurationSeconds - 120) <= 0.001)
    #expect(abs((work.elapsedDurationSeconds ?? 0) - 120) <= 0.001)
    #expect(abs((work.pauseOverlapSeconds ?? 0) - 30) <= 0.001)
    #expect(abs((work.activeDurationSeconds ?? 0) - 90) <= 0.001)
    #expect(work.durationDisplayRule == .elapsedRowWindow)
    #expect(abs(work.displayDurationSeconds - 120) <= 0.001)

    var exportWorkout = workout
    exportWorkout.evidence = evidence
    let json = DiagnosticsExport.parityPacketJSON(workout: exportWorkout, forceReenrichResult: nil, generatedAt: start)
    let data = try #require(json.data(using: .utf8))
    let object = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
    let exportedIntervals = try #require(object["reconstructedIntervals"] as? [[String: Any]])
    let exportedWork = try #require(exportedIntervals.first { $0["label"] as? String == "Work 1" })
    #expect(abs((exportedWork["elapsedDurationSeconds"] as? Double ?? 0) - 120) <= 0.001)
    #expect(abs((exportedWork["pauseOverlapSeconds"] as? Double ?? 0) - 30) <= 0.001)
    #expect(abs((exportedWork["activeDurationSeconds"] as? Double ?? 0) - 90) <= 0.001)
    #expect(abs((exportedWork["displayDurationSeconds"] as? Double ?? 0) - 120) <= 0.001)
    #expect(exportedWork["durationDisplayRule"] as? String == "elapsedRowWindow")

    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
}

@Test func normalDetailGateBlocksUnpairedPauseEvents() {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "normal-detail-unpaired-pause", start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "2 min"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalValue: nil, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 920, 400),
            (920, 1_200, 600)
        ],
        distancePoints: [(0, 0), (800, 2_000), (920, 2_400), (1_200, 3_000)],
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(830), endDate: start.addingTimeInterval(830), type: "HKWorkoutEventType(rawValue: 1)", label: "Pause")
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: evidence).contains {
        $0.contains("unpaired pause/resume")
    })
}

@Test func normalDetailGateBlocksPausedTimingWhenActivityRowsAreMissing() {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "normal-detail-paused-missing-activities", start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "2 min"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalValue: nil, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [],
        distancePoints: [(0, 0), (800, 2_000), (920, 2_400), (1_200, 3_000)],
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(830), endDate: start.addingTimeInterval(830), type: "HKWorkoutEventType(rawValue: 1)", label: "Pause"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(860), endDate: start.addingTimeInterval(860), type: "HKWorkoutEventType(rawValue: 2)", label: "Resume")
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: evidence).contains {
        $0.contains("activity rows are missing")
    })
}

@Test func normalDetailGateSupportsNarrowFixedCooldownOpenTail() throws {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "normal-detail-fixed-cooldown-tail", start: start, distanceMeters: 4_500, durationSeconds: 1_800)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 1_100, 1_000),
            (1_100, 1_600, 1_000)
        ],
        distancePoints: [
            (800, 2_000),
            (1_100, 1_000),
            (1_600, 1_000),
            (1_800, 500)
        ]
    )

    let result = try #require(CustomWorkoutNormalDetailGate.supportedNarrowWarmupWorkFixedCooldownOpenTail(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Warmup", "Work 1", "Cooldown", "Open / Extra"])
    #expect(result.intervals.map(\.stepType) == [.warmup, .work, .cooldown, .open])
    #expect(result.intervals.last?.tailDiagnostics?.remainingSeconds == 200)
    #expect(result.intervals.last?.actualDistanceMeters == 500)
    assertElapsedTimingSemantics(result.intervals)
}

@Test func normalDetailGateSupportsSimpleFixedDistanceWorkOpenTail() throws {
    let start = Date(timeIntervalSince1970: 10_654)
    let workout = testWorkout(id: "normal-detail-simple-work-open", start: start, distanceMeters: 5_050, durationSeconds: 1_930)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityWindows: [
            (0, 1_900, 5_005)
        ],
        distancePoints: [
            (1_900, 5_005),
            (1_930, 45)
        ]
    )

    let result = try #require(CustomWorkoutNormalDetailGate.supportedNarrowSimpleFixedDistanceWorkOpenTail(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Work 1", "Open / Extra"])
    #expect(result.intervals.map(\.stepType) == [.work, .open])
    #expect(result.intervals.first?.plannedGoalType == .distance)
    #expect(result.intervals.last?.tailDiagnostics?.remainingSeconds == 30)
    #expect(result.intervals.last?.actualDistanceMeters == 45)
    assertElapsedTimingSemantics(result.intervals)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)?.intervals.map(\.label) == result.intervals.map(\.label))
}

@Test func normalDetailGateBlocksSimpleWorkOpenWhenActivityRowsAreMissing() {
    let start = Date(timeIntervalSince1970: 10_654)
    let workout = testWorkout(id: "normal-detail-simple-work-open-missing", start: start, distanceMeters: 5_050, durationSeconds: 1_930)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityWindows: [],
        distancePoints: [
            (1_930, 5_050)
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowSimpleFixedDistanceWorkOpenTail(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
}

@Test func normalDetailGateBlocksSimpleWorkOpenForTrueRepeatRows() {
    let start = Date(timeIntervalSince1970: 10_654)
    let workout = testWorkout(id: "normal-detail-simple-work-open-repeat", start: start, distanceMeters: 450, durationSeconds: 190)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m")
        ],
        activityWindows: [
            (0, 160, 405)
        ],
        distancePoints: [
            (160, 405),
            (190, 45)
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowSimpleFixedDistanceWorkOpenTail(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
}

@Test func normalDetailGateSupportsRecoveryContainingFixedCooldownOpenTail() throws {
    let (workout, evidence) = recoveryTailNormalDetailFixture()

    let result = try #require(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        )
    )

    #expect(result.intervals.map(\.label) == ["Warmup", "Recovery 1", "Work 1", "Cooldown", "Open / Extra"])
    #expect(result.intervals.map(\.stepType) == [.warmup, .recovery, .work, .cooldown, .open])

    let recovery = try #require(result.intervals.first { $0.label == "Recovery 1" })
    #expect(recovery.durationDisplayRule == .elapsedRowWindow)
    #expect(abs(recovery.elapsedRowWindowDurationSeconds - 119.5) <= 0.001)
    #expect((recovery.pauseOverlapSeconds ?? 0) == 0)
    #expect(IntervalRowTimingText.pausedTimingDetail(for: recovery) == nil)

    let work = try #require(result.intervals.first { $0.label == "Work 1" })
    #expect(work.durationDisplayRule == .activeTimer)
    #expect(abs(work.elapsedRowWindowDurationSeconds - 1_445.4) <= 0.001)
    #expect(abs((work.pauseOverlapSeconds ?? 0) - 141.0) <= 0.001)
    #expect(abs(work.activeTimerDurationSeconds - 1_304.4) <= 0.001)
    #expect(abs(work.displayDurationSeconds - 1_304.4) <= 0.001)
    #expect(abs((work.actualPaceSecondsPerKm ?? 0) - (1_304.4 / 5.0057)) <= 0.001)
    #expect(IntervalRowTimingText.pausedTimingDetail(for: work) != nil)

    let cooldown = try #require(result.intervals.first { $0.label == "Cooldown" })
    #expect(cooldown.durationDisplayRule == .activeTimer)
    #expect(abs(cooldown.elapsedRowWindowDurationSeconds - 834.0) <= 0.001)
    #expect(abs((cooldown.pauseOverlapSeconds ?? 0) - 91.8) <= 0.001)
    #expect(abs(cooldown.activeTimerDurationSeconds - 742.2) <= 0.001)

    let tail = try #require(result.intervals.last)
    #expect(tail.label == "Open / Extra")
    #expect(tail.tailDiagnostics != nil)
    #expect(tail.durationDisplayRule == .elapsedRowWindow)
    #expect(abs(tail.elapsedRowWindowDurationSeconds - 9.9) <= 0.001)
    #expect(abs((tail.actualDistanceMeters ?? 0) - 16.6) <= 0.001)
}

@Test func normalDetailGateBlocksRecoveryContainingTailWhenActivityRowsAreMissing() {
    let windows = Array(recoveryTailActivityWindows().dropLast())
    let (workout, evidence) = recoveryTailNormalDetailFixture(
        id: "normal-detail-recovery-tail-missing-row",
        activityWindows: windows
    )

    #expect(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        ) == nil
    )
}

@Test func normalDetailGateBlocksRecoveryContainingTailWhenRowsAreNotContiguous() {
    var windows = recoveryTailActivityWindows()
    windows[2] = (start: 900.0, end: 2_337.4, distance: 5_005.7)
    let (workout, evidence) = recoveryTailNormalDetailFixture(
        id: "normal-detail-recovery-tail-non-contiguous",
        activityWindows: windows
    )

    #expect(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        ) == nil
    )
}

@Test func normalDetailGateBlocksRecoveryContainingTailWithUnpairedPause() {
    let start = Date(timeIntervalSince1970: 10_661)
    let (workout, evidence) = recoveryTailNormalDetailFixture(
        id: "normal-detail-recovery-tail-unpaired-pause",
        start: start,
        events: [
            WorkoutEvidenceEvent(
                startDate: start.addingTimeInterval(1_500.0),
                endDate: start.addingTimeInterval(1_500.0),
                type: "HKWorkoutEventType(rawValue: 1)",
                label: "Pause"
            )
        ]
    )

    #expect(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        ) == nil
    )
}

@Test func normalDetailGateBlocksRecoveryContainingTailWithRepeatRows() {
    var plannedSteps = recoveryTailPlannedSteps()
    plannedSteps[2].repeatBlockIndex = 1
    plannedSteps[2].repeatIndex = 1
    let (workout, evidence) = recoveryTailNormalDetailFixture(
        id: "normal-detail-recovery-tail-repeat-row",
        plannedSteps: plannedSteps
    )

    #expect(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        ) == nil
    )
}

@Test func normalDetailGateBlocksRecoveryContainingTailWithOpenCooldownFinalStep() {
    var plannedSteps = recoveryTailPlannedSteps()
    plannedSteps[3] = PlannedWorkoutStep(
        index: 4,
        label: "Cooldown",
        stepType: .cooldown,
        plannedGoalType: .open,
        plannedGoalDisplayText: "Open"
    )
    let (workout, evidence) = recoveryTailNormalDetailFixture(
        id: "normal-detail-recovery-tail-open-cooldown",
        plannedSteps: plannedSteps
    )

    #expect(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        ) == nil
    )
}

@Test func normalDetailGateBlocksRecoveryContainingTailWhenTailIsBelowThreshold() {
    let windows = recoveryTailActivityWindows()
    let mappedDistance = windows.reduce(0) { $0 + $1.distance }
    let (workout, evidence) = recoveryTailNormalDetailFixture(
        id: "normal-detail-recovery-tail-below-threshold",
        activityWindows: windows,
        workoutDistanceMeters: mappedDistance + 0.4,
        workoutDurationSeconds: 3_171.8
    )

    #expect(
        CustomWorkoutNormalDetailGate.supportedNarrowRecoveryContainingFixedCooldownOpenTail(
            workout: workout,
            evidence: evidence
        ) == nil
    )
}

@Test func normalDetailGateBlocksRecoveryContainingSimpleTail() {
    let start = Date(timeIntervalSince1970: 10_654)
    let workout = testWorkout(id: "normal-detail-recovery-tail-blocked", start: start, distanceMeters: 5_250, durationSeconds: 2_080)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "120 s"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityWindows: [
            (0, 120, 180),
            (120, 2_050, 5_005)
        ],
        distancePoints: [
            (120, 180),
            (2_050, 5_005),
            (2_080, 65)
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowSimpleFixedDistanceWorkOpenTail(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
}

@Test func normalDetailGateUsesActivityBoundaryRowsWhenDistanceReconstructionDrifts() throws {
    let start = Date(timeIntervalSince1970: 10_655)
    let workout = testWorkout(id: "normal-detail-activity-boundary-drift", start: start, distanceMeters: 4_500, durationSeconds: 1_800)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ],
        activityWindows: [
            (0, 800, 2_000),
            (800, 1_120, 1_000),
            (1_120, 1_600, 1_000)
        ],
        distancePoints: [
            (800, 2_000),
            (1_100, 1_000),
            (1_600, 1_000),
            (1_800, 500)
        ]
    )

    let result = try #require(CustomWorkoutNormalDetailGate.supportedNarrowWarmupWorkFixedCooldownOpenTail(workout: workout, evidence: evidence))

    #expect(result.windowSource == .healthKitActivityBoundaries)
    #expect(result.intervals.map(\.label) == ["Warmup", "Work 1", "Cooldown", "Open / Extra"])
    #expect(result.intervals[1].actualDurationSeconds == 320)
    #expect(result.intervals[1].actualDistanceMeters == 1_000)
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: evidence).isEmpty)
}

@Test func normalDetailGateSupportsCleanRepeatBlockOpenCooldown() throws {
    let start = Date(timeIntervalSince1970: 10_656)
    let workout = testWorkout(id: "normal-detail-clean-repeat", start: start, distanceMeters: 4_800, durationSeconds: 1_600)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 150, plannedGoalDisplayText: "150 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 150, plannedGoalDisplayText: "150 s"),
            PlannedWorkoutStep(index: 6, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 700, 2_000),
            (700, 950, 1_000),
            (950, 1_100, 200),
            (1_100, 1_350, 1_000),
            (1_350, 1_500, 200),
            (1_500, 1_600, 400)
        ],
        distancePoints: [
            (704, 2_000),
            (956, 1_000),
            (1_100, 200),
            (1_356, 1_000),
            (1_500, 200),
            (1_600, 400)
        ]
    )

    let result = try #require(CustomWorkoutNormalDetailGate.supportedNarrowNoPauseRepeatBlockOpenCooldown(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Warmup", "Work 1", "Recovery 1", "Work 2", "Recovery 2", "Cooldown"])
    #expect(result.intervals.map(\.stepType) == [.warmup, .work, .recovery, .work, .recovery, .cooldown])
    #expect(result.windowSource == .healthKitActivityBoundaries)
    #expect(result.intervals[1].actualDurationSeconds == 250)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)?.intervals.map(\.label) == result.intervals.map(\.label))
    #expect(result.intervals.map(\.label).contains("Open / Extra") == false)
    assertElapsedTimingSemantics(result.intervals)
}

@Test func normalDetailGateSupportsCleanRepeatBlockFixedCooldownOpenTail() throws {
    let start = Date(timeIntervalSince1970: 10_657)
    let workout = testWorkout(id: "normal-detail-clean-repeat-tail", start: start, distanceMeters: 4_040, durationSeconds: 1_615)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
            PlannedWorkoutStep(index: 6, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ],
        activityWindows: [
            (0, 700, 2_000),
            (700, 820, 400),
            (820, 925, 100),
            (925, 1_045, 400),
            (1_045, 1_150, 100),
            (1_150, 1_605, 1_000)
        ],
        distancePoints: [
            (704, 2_000),
            (826, 400),
            (925, 100),
            (1_051, 400),
            (1_150, 100),
            (1_605, 1_000),
            (1_615, 40)
        ]
    )

    let result = try #require(CustomWorkoutNormalDetailGate.supportedNarrowNoPauseRepeatBlockFixedCooldownOpenTail(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Warmup", "Work 1", "Recovery 1", "Work 2", "Recovery 2", "Cooldown", "Open / Extra"])
    #expect(result.intervals.map(\.stepType) == [.warmup, .work, .recovery, .work, .recovery, .cooldown, .open])
    #expect(result.windowSource == .healthKitActivityBoundaries)
    #expect(result.intervals[1].actualDurationSeconds == 120)
    #expect(result.intervals.last?.tailDiagnostics?.remainingSeconds == 10)
    #expect(result.intervals.last?.actualDistanceMeters == 40)
    assertElapsedTimingSemantics(result.intervals)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence)?.intervals.map(\.label) == result.intervals.map(\.label))
}

@Test func normalDetailGateSupportsPausedRepeatBlockOpenCooldownWithActiveTiming() throws {
    let start = Date(timeIntervalSince1970: 10_656)
    let workout = testWorkout(id: "normal-detail-paused-repeat", start: start, distanceMeters: 4_800, durationSeconds: 1_700)
    var evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 150, plannedGoalDisplayText: "150 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 150, plannedGoalDisplayText: "150 s"),
            PlannedWorkoutStep(index: 6, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [
            (0, 700, 2_000),
            (700, 950, 1_000),
            (950, 1_100, 200),
            (1_100, 1_350, 1_000),
            (1_350, 1_500, 200),
            (1_500, 1_700, 400)
        ],
        distancePoints: [
            (700, 2_000),
            (950, 1_000),
            (1_100, 200),
            (1_350, 1_000),
            (1_500, 200),
            (1_700, 400)
        ]
    )
    evidence.events = [
        WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_000), endDate: start.addingTimeInterval(1_000), type: "HKWorkoutEventType(rawValue: 1)"),
        WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_090), endDate: start.addingTimeInterval(1_090), type: "HKWorkoutEventType(rawValue: 2)")
    ]

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowNoPauseRepeatBlockOpenCooldown(workout: workout, evidence: evidence) == nil)
    let result = try #require(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence))
    #expect(result.intervals.count == 6)
    #expect(result.intervals.map(\.label) == ["Warmup", "Work 1", "Recovery 1", "Work 2", "Recovery 2", "Cooldown"])

    let recovery = try #require(result.intervals.first { $0.label == "Recovery 1" })
    #expect(recovery.durationDisplayRule == .activeTimer)
    #expect(abs(recovery.elapsedRowWindowDurationSeconds - 150) <= 0.001)
    #expect(abs((recovery.pauseOverlapSeconds ?? 0) - 90) <= 0.001)
    #expect(abs(recovery.activeTimerDurationSeconds - 60) <= 0.001)
    #expect(abs(recovery.displayDurationSeconds - 60) <= 0.001)
    #expect(abs((recovery.actualPaceSecondsPerKm ?? 0) - 300) <= 0.001)
    #expect(IntervalRowTimingText.pausedTimingDetail(for: recovery) == "Active 1:00 · elapsed 2:30 · paused 1:30")

    let warmup = try #require(result.intervals.first)
    #expect(warmup.durationDisplayRule == .elapsedRowWindow)
    #expect(IntervalRowTimingText.pausedTimingDetail(for: warmup) == nil)
}

@Test func normalDetailGateBlocksPausedRepeatBlockCountMismatch() {
    let fixture = pausedRepeatOpenCooldownFixture(
        id: "normal-detail-paused-repeat-count-mismatch",
        activityWindows: [
            (0, 700, 2_000),
            (700, 950, 1_000),
            (950, 1_100, 200),
            (1_100, 1_350, 1_000),
            (1_350, 1_500, 200)
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: fixture.workout, evidence: fixture.evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: fixture.workout, evidence: fixture.evidence).contains { $0.contains("Planned row count") })
}

@Test func normalDetailGateBlocksPausedRepeatBlockNonContiguousRows() {
    let fixture = pausedRepeatOpenCooldownFixture(
        id: "normal-detail-paused-repeat-non-contiguous",
        activityWindows: [
            (0, 700, 2_000),
            (700, 950, 1_000),
            (960, 1_110, 200),
            (1_110, 1_360, 1_000),
            (1_360, 1_510, 200),
            (1_510, 1_700, 1_000)
        ],
        distancePoints: [
            (700, 2_000),
            (950, 1_000),
            (1_110, 200),
            (1_360, 1_000),
            (1_510, 200),
            (1_700, 1_000)
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: fixture.workout, evidence: fixture.evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: fixture.workout, evidence: fixture.evidence).contains { $0.contains("not contiguous") })
}

@Test func normalDetailGateBlocksPausedRepeatBlockPauseCrossingRowBoundary() {
    let start = Date(timeIntervalSince1970: 10_656)
    let fixture = pausedRepeatOpenCooldownFixture(
        id: "normal-detail-paused-repeat-cross-row-pause",
        events: [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(940), endDate: start.addingTimeInterval(940), type: "HKWorkoutEventType(rawValue: 1)", label: "Pause"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_000), endDate: start.addingTimeInterval(1_000), type: "HKWorkoutEventType(rawValue: 2)", label: "Resume")
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: fixture.workout, evidence: fixture.evidence) == nil)
}

@Test func normalDetailGateBlocksPausedRepeatBlockFixedCooldownOpenTail() {
    let start = Date(timeIntervalSince1970: 10_657)
    let workout = testWorkout(id: "normal-detail-paused-repeat-tail", start: start, distanceMeters: 4_040, durationSeconds: 1_615)
    var evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
            PlannedWorkoutStep(index: 6, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ],
        activityWindows: [
            (0, 700, 2_000),
            (700, 820, 400),
            (820, 925, 100),
            (925, 1_045, 400),
            (1_045, 1_150, 100),
            (1_150, 1_605, 1_000)
        ],
        distancePoints: [
            (700, 2_000),
            (820, 400),
            (925, 100),
            (1_045, 400),
            (1_150, 100),
            (1_605, 1_000),
            (1_615, 40)
        ]
    )
    evidence.events = [
        WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_000), endDate: start.addingTimeInterval(1_000), type: "HKWorkoutEventType(rawValue: 1)"),
        WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_090), endDate: start.addingTimeInterval(1_090), type: "HKWorkoutEventType(rawValue: 2)")
    ]

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowNoPauseRepeatBlockFixedCooldownOpenTail(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)

    let blockedReasons = CustomWorkoutNormalDetailGate.blockedReasons(workout: workout, evidence: evidence)
    #expect(blockedReasons.contains { $0.contains("pause-adjusted timer logic") })
    #expect(blockedReasons.contains { $0.contains("Tail status is fixedCooldownFollowedByPossibleOpenExtraTail") })
}

@Test func normalDetailGateBlocksRepeatAndOpenTailCases() {
    let start = Date(timeIntervalSince1970: 10_656)
    let repeatWorkout = testWorkout(id: "normal-detail-repeat", start: start, distanceMeters: 3_000, durationSeconds: 1_200)
    let repeatEvidence = normalDetailGateEvidence(
        workout: repeatWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 60, plannedGoalDisplayText: "60 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m")
        ],
        activityWindows: [
            (0, 700, 2_000),
            (700, 800, 400),
            (800, 860, 100),
            (860, 960, 400)
        ],
        distancePoints: [
            (700, 2_000),
            (800, 400),
            (860, 100),
            (960, 400),
            (1_200, 100)
        ]
    )

    let recoveryTailWorkout = testWorkout(id: "normal-detail-recovery-tail", start: start, distanceMeters: 1_150, durationSeconds: 420)
    let recoveryTailEvidence = normalDetailGateEvidence(
        workout: recoveryTailWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Recovery 1", stepType: .recovery, plannedGoalType: .time, plannedGoalValue: 60, plannedGoalDisplayText: "60 s"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ],
        activityWindows: [
            (0, 60, 100),
            (60, 360, 1_000)
        ],
        distancePoints: [
            (60, 100),
            (360, 1_000),
            (420, 50)
        ]
    )

    let repeatTailWorkout = testWorkout(id: "normal-detail-repeat-tail", start: start, distanceMeters: 1_100, durationSeconds: 420)
    let repeatTailEvidence = normalDetailGateEvidence(
        workout: repeatTailWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 2, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 60, plannedGoalDisplayText: "60 s"),
            PlannedWorkoutStep(index: 3, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 4, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 100, plannedGoalDisplayText: "100 m")
        ],
        activityWindows: [
            (0, 120, 400),
            (120, 180, 100),
            (180, 300, 400),
            (300, 360, 100)
        ],
        distancePoints: [
            (120, 400),
            (180, 100),
            (300, 400),
            (360, 100),
            (420, 100)
        ]
    )

    #expect(CustomWorkoutNormalDetailGate.supportedNarrowWarmupWorkOpenCooldown(workout: repeatWorkout, evidence: repeatEvidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedNarrowWarmupWorkOpenCooldown(workout: recoveryTailWorkout, evidence: recoveryTailEvidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: recoveryTailWorkout, evidence: recoveryTailEvidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: repeatTailWorkout, evidence: repeatTailEvidence) == nil)

    let repeatTailBlockedReasons = CustomWorkoutNormalDetailGate.blockedReasons(workout: repeatTailWorkout, evidence: repeatTailEvidence)
    #expect(repeatTailBlockedReasons.contains { $0.contains("Structured comparison status is open-tail-needs-rule") })
    #expect(repeatTailBlockedReasons.contains { $0.contains("Open / Extra tail handling is ambiguous") })
    #expect(repeatTailBlockedReasons.contains { $0.contains("Tail status is fixedCooldownFollowedByPossibleOpenExtraTail") })
    #expect(CustomWorkoutNormalDetailGate.blockedReasons(workout: repeatWorkout, evidence: repeatEvidence).contains {
        $0.contains("outside the approved")
    })
}

@Test func finalFixedDistanceCooldownStillCreatesOpenExtraForContinuedRunning() throws {
    let start = Date(timeIntervalSince1970: 10_660)
    let workout = testWorkout(id: "fixed-distance-cooldown-tail", start: start, distanceMeters: 510, durationSeconds: 510)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(500), value: 500),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(510), value: 10)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 500, plannedGoalDisplayText: "500 m")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Cooldown", "Open / Extra"])
    #expect(result.intervals[0].stepType == .cooldown)
    #expect(result.intervals[0].plannedGoalType == .distance)
    #expect(result.intervals[1].stepType == .open)
    #expect(result.intervals[1].actualDurationSeconds == 10)
    #expect(result.intervals[1].tailDiagnostics?.remainingSeconds == 10)
}

@Test func finalFixedTimeCooldownStillCreatesOpenExtraForContinuedRunning() throws {
    let start = Date(timeIntervalSince1970: 10_670)
    let workout = testWorkout(id: "fixed-time-cooldown-tail", start: start, distanceMeters: 650, durationSeconds: 330)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 600),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(330), value: 50)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Cooldown", stepType: .cooldown, plannedGoalType: .time, plannedGoalValue: 300, plannedGoalDisplayText: "300 s")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Cooldown", "Open / Extra"])
    #expect(result.intervals[0].stepType == .cooldown)
    #expect(result.intervals[0].plannedGoalType == .time)
    #expect(result.intervals[1].stepType == .open)
    #expect(result.intervals[1].actualDurationSeconds == 30)
    #expect(result.intervals[1].actualDistanceMeters == 50)
}

@Test func tinyFinalResidualRemainsHiddenBelowThreshold() throws {
    let start = Date(timeIntervalSince1970: 10_680)
    let workout = testWorkout(id: "tiny-residual-hidden", start: start, distanceMeters: 1_004, durationSeconds: 103)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(100), value: 1_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(103), value: 4)
                ]
            )
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))

    #expect(result.intervals.map(\.label) == ["Work 1"])
}

@Test func stoppedEarlySingleFixedDistanceWorkUsesActivityBoundaryInNormalDetail() throws {
    let start = Date(timeIntervalSince1970: 10_690)
    let workout = testWorkout(id: "stopped-early-single-work", start: start, distanceMeters: 3_026, durationSeconds: 733.8)
    let plannedSteps = [
        PlannedWorkoutStep(
            index: 1,
            label: "Work 1",
            stepType: .work,
            plannedGoalType: .distance,
            plannedGoalValue: 5_000,
            plannedGoalDisplayText: "5 km",
            plannedTargetDisplayText: "4:00 /km"
        )
    ]
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: plannedSteps,
        activityWindows: [(start: 0, end: 733.8, distance: 3_026)],
        distancePoints: [(733.8, 3_026)]
    )

    let productionFallback = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))
    let result = try #require(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence))

    #expect(productionFallback.intervals.map(\.label) == ["Open / Extra"])
    #expect(result.intervals.map(\.label) == ["Work 1"])
    #expect(result.intervals[0].stepType == .work)
    #expect(result.intervals[0].windowSource == .healthKitActivityBoundaries)
    #expect(abs(result.intervals[0].actualDurationSeconds - 733.8) < 0.001)
    #expect(result.intervals[0].actualDistanceMeters == 3_026)
    #expect(result.intervals.map(\.label).contains("Open / Extra") == false)
    assertElapsedTimingSemantics(result.intervals)
}

@Test func openRunWithoutPlannedStepsDoesNotInventCustomIntervals() {
    let start = Date(timeIntervalSince1970: 10_695)
    let workout = testWorkout(id: "plain-open-run", start: start, distanceMeters: 2_199.8, durationSeconds: 1_199.5)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [],
        activityWindows: [(start: 0, end: 1_199.5, distance: 2_199.8)],
        distancePoints: [(386.3, 1_000), (1_044.4, 1_000), (1_196.8, 199.8)]
    )

    #expect(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence) == nil)
    #expect(CustomWorkoutNormalDetailGate.supportedIntervals(workout: workout, evidence: evidence) == nil)
}

@Test func approvedNormalDetailGateRouterStillRecognizesEightNarrowShapes() {
    func repeatSteps(finalCooldownGoal: PlannedWorkoutGoalType) -> [PlannedWorkoutStep] {
        [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "120 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "120 s"),
            PlannedWorkoutStep(
                index: 6,
                label: "Cooldown",
                stepType: .cooldown,
                plannedGoalType: finalCooldownGoal,
                plannedGoalValue: finalCooldownGoal == .distance ? 1_000 : nil,
                plannedGoalDisplayText: finalCooldownGoal == .distance ? "1 km" : "Open"
            )
        ]
    }

    let stoppedEarlyWorkout = testWorkout(id: "freeze-stopped-early-single-work", start: Date(timeIntervalSince1970: 10_710), distanceMeters: 3_026, durationSeconds: 733.8)
    let stoppedEarlyEvidence = normalDetailGateEvidence(
        workout: stoppedEarlyWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityWindows: [(start: 0, end: 733.8, distance: 3_026)],
        distancePoints: [(733.8, 3_026)]
    )

    let simpleWorkOpenWorkout = testWorkout(id: "freeze-simple-work-open", start: Date(timeIntervalSince1970: 10_720), distanceMeters: 5_050, durationSeconds: 1_900)
    let simpleWorkOpenEvidence = normalDetailGateEvidence(
        workout: simpleWorkOpenWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityWindows: [(start: 0, end: 1_800, distance: 5_000)],
        distancePoints: [(1_800, 5_000), (1_900, 5_050)]
    )

    let warmupWorkOpenCooldownWorkout = testWorkout(id: "freeze-warmup-work-open-cooldown", start: Date(timeIntervalSince1970: 10_730), distanceMeters: 3_500, durationSeconds: 1_500)
    let warmupWorkOpenCooldownEvidence = normalDetailGateEvidence(
        workout: warmupWorkOpenCooldownWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .time, plannedGoalValue: 600, plannedGoalDisplayText: "600 s"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ],
        activityWindows: [(start: 0, end: 800, distance: 2_000), (start: 800, end: 1_400, distance: 1_250), (start: 1_400, end: 1_500, distance: 250)],
        distancePoints: [(800, 2_000), (1_400, 3_250), (1_500, 3_500)]
    )

    let warmupWorkFixedCooldownTailWorkout = testWorkout(id: "freeze-warmup-work-fixed-cooldown-tail", start: Date(timeIntervalSince1970: 10_740), distanceMeters: 4_050, durationSeconds: 1_700)
    let warmupWorkFixedCooldownTailEvidence = normalDetailGateEvidence(
        workout: warmupWorkFixedCooldownTailWorkout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 3, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ],
        activityWindows: [(start: 0, end: 800, distance: 2_000), (start: 800, end: 1_200, distance: 1_000), (start: 1_200, end: 1_600, distance: 1_000)],
        distancePoints: [(800, 2_000), (1_200, 3_000), (1_600, 4_000), (1_700, 4_050)]
    )

    let repeatOpenCooldownWorkout = testWorkout(id: "freeze-repeat-open-cooldown", start: Date(timeIntervalSince1970: 10_750), distanceMeters: 4_800, durationSeconds: 1_600)
    let repeatOpenCooldownEvidence = normalDetailGateEvidence(
        workout: repeatOpenCooldownWorkout,
        plannedSteps: repeatSteps(finalCooldownGoal: .open),
        activityWindows: [(start: 0, end: 700, distance: 2_000), (start: 700, end: 820, distance: 400), (start: 820, end: 940, distance: 100), (start: 940, end: 1_060, distance: 400), (start: 1_060, end: 1_180, distance: 100), (start: 1_180, end: 1_600, distance: 1_800)],
        distancePoints: [(700, 2_000), (820, 2_400), (940, 2_500), (1_060, 2_900), (1_180, 3_000), (1_600, 4_800)]
    )

    let repeatFixedCooldownTailWorkout = testWorkout(id: "freeze-repeat-fixed-cooldown-tail", start: Date(timeIntervalSince1970: 10_760), distanceMeters: 4_050, durationSeconds: 1_500)
    let repeatFixedCooldownTailEvidence = normalDetailGateEvidence(
        workout: repeatFixedCooldownTailWorkout,
        plannedSteps: repeatSteps(finalCooldownGoal: .distance),
        activityWindows: [(start: 0, end: 700, distance: 2_000), (start: 700, end: 820, distance: 400), (start: 820, end: 940, distance: 100), (start: 940, end: 1_060, distance: 400), (start: 1_060, end: 1_180, distance: 100), (start: 1_180, end: 1_400, distance: 1_000)],
        distancePoints: [(700, 2_000), (820, 2_400), (940, 2_500), (1_060, 2_900), (1_180, 3_000), (1_400, 4_000), (1_500, 4_050)]
    )

    let pausedRepeatOpenCooldown = pausedRepeatOpenCooldownFixture(id: "freeze-paused-repeat-open-cooldown")
    let recoveryTail = recoveryTailNormalDetailFixture(id: "freeze-recovery-containing-tail")

    let fixtures: [(name: String, workout: CanonicalWorkout, evidence: WorkoutEvidence, labels: [String])] = [
        ("stopped-early single Work", stoppedEarlyWorkout, stoppedEarlyEvidence, ["Work 1"]),
        ("simple Work/Open", simpleWorkOpenWorkout, simpleWorkOpenEvidence, ["Work 1", "Open / Extra"]),
        ("warmup/work/open cooldown", warmupWorkOpenCooldownWorkout, warmupWorkOpenCooldownEvidence, ["Warmup", "Work 1", "Cooldown"]),
        ("warmup/work/fixed cooldown tail", warmupWorkFixedCooldownTailWorkout, warmupWorkFixedCooldownTailEvidence, ["Warmup", "Work 1", "Cooldown", "Open / Extra"]),
        ("clean repeat open cooldown", repeatOpenCooldownWorkout, repeatOpenCooldownEvidence, ["Warmup", "Work 1", "Recovery 1", "Work 2", "Recovery 2", "Cooldown"]),
        ("clean repeat fixed cooldown tail", repeatFixedCooldownTailWorkout, repeatFixedCooldownTailEvidence, ["Warmup", "Work 1", "Recovery 1", "Work 2", "Recovery 2", "Cooldown", "Open / Extra"]),
        ("paused repeat open cooldown", pausedRepeatOpenCooldown.workout, pausedRepeatOpenCooldown.evidence, []),
        ("recovery-containing fixed cooldown tail", recoveryTail.workout, recoveryTail.evidence, ["Warmup", "Recovery 1", "Work 1", "Cooldown", "Open / Extra"])
    ]

    #expect(fixtures.count == 8)
    for fixture in fixtures {
        let result = CustomWorkoutNormalDetailGate.supportedIntervals(workout: fixture.workout, evidence: fixture.evidence)
        #expect(result != nil, "\(fixture.name) should stay approved")
        if fixture.labels.isEmpty {
            #expect(result?.intervals.map(\.stepType) == [.warmup, .work, .recovery, .work, .recovery, .cooldown])
            #expect(result?.intervals.contains { ($0.pauseOverlapSeconds ?? 0) > 0 } == true)
        } else {
            #expect(result?.intervals.map(\.label) == fixture.labels)
        }
    }
}

@Test func healthKitSegmentMarkersAreNotUsedAsWorkoutKitReconstructedIntervals() throws {
    let start = Date(timeIntervalSince1970: 10_700)
    let workout = testWorkout(id: "segment-markers-not-used", start: start, distanceMeters: 1_000, durationSeconds: 600)
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(600), value: 1_000)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start, endDate: start.addingTimeInterval(200), type: "HKWorkoutEventTypeSegment", label: "Warmup"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(200), endDate: start.addingTimeInterval(400), type: "HKWorkoutEventTypeSegment", label: "Work"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(400), endDate: start.addingTimeInterval(600), type: "HKWorkoutEventTypeSegment", label: "Cooldown")
        ],
        workoutPlanAudit: WorkoutPlanAudit(status: .available, plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km")
        ])
    )

    let result = try #require(WorkoutIntervalReconstructionEngine.reconstruct(workout: workout, evidence: evidence))

    #expect(result.intervals.count == 1)
    #expect(result.intervals[0].actualDurationSeconds == 600)
    #expect(result.notes.contains("HealthKit segment markers: not used"))
    #expect(result.intervals.map(\.label).contains("Work") == false)
    #expect(result.intervals.map(\.label).contains("Cooldown") == false)
}

@Test func derivedIntervalCandidatesKeepUnlabeledSegmentsLimited() {
    let start = Date(timeIntervalSince1970: 9_900)
    let workout = testWorkout(
        id: "unlabeled-intervals",
        start: start,
        distanceMeters: 1_000,
        durationSeconds: 300
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 1_000)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start, endDate: start.addingTimeInterval(300), type: "HKWorkoutEventTypeSegment")
        ]
    )

    let candidates = DerivedAnalyticsEngine.intervalCandidates(workout: workout, evidence: evidence)

    #expect(candidates.count == 1)
    #expect(candidates[0].label == .unknown)
    #expect(candidates[0].source == .healthKitSegmentPattern)
    #expect(candidates[0].markerKind == .splitMarker)
    #expect(candidates[0].confidence == .limited)
    #expect(candidates[0].caveats.contains("HealthKit did not expose an Apple Fitness interval label for this event."))
    #expect(candidates[0].caveats.contains("This event window matches a split-like distance marker, not an Apple Fitness interval row."))
    #expect(candidates[0].caveats.contains("Duration and pace use elapsed HealthKit event-window time; pause overlap is not subtracted."))
}

@Test func derivedIntervalCandidatesFlagOverlappingRawSegments() {
    let start = Date(timeIntervalSince1970: 10_100)
    let workout = testWorkout(
        id: "overlapping-intervals",
        start: start,
        distanceMeters: 1_600,
        durationSeconds: 600
    )
    let evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 800),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(600), value: 800)
                ]
            )
        ],
        events: [
            WorkoutEvidenceEvent(startDate: start, endDate: start.addingTimeInterval(300), type: "HKWorkoutEventTypeSegment"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(150), endDate: start.addingTimeInterval(450), type: "HKWorkoutEventTypeSegment")
        ]
    )

    let candidates = DerivedAnalyticsEngine.intervalCandidates(workout: workout, evidence: evidence)

    #expect(candidates.count == 2)
    #expect(candidates[0].markerKind == .rawSegmentMarker)
    #expect(candidates[1].markerKind == .overlappingSegmentMarker)
    #expect(candidates[1].startOffsetSeconds == 150)
    #expect(candidates[1].endOffsetSeconds == 450)
    #expect(candidates[1].caveats.contains("This event overlaps another segment window, so it should stay raw/debug-only."))
}

@Test func healthKitAuditReportsPerWorkoutFieldsAndCaveats() {
    let start = Date(timeIntervalSince1970: 1_000)
    var workout = testWorkout(
        id: "audit-workout",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.averageHeartRate = 154
    workout.activeEnergyKilocalories = 360
    workout.routePointCount = 240
    workout.heartRateSampleCount = 300
    workout.runningSpeedSampleCount = 280
    workout.distanceSampleCount = 20
    workout.activeEnergySampleCount = 1
    workout.runningPowerSampleCount = 0
    workout.cadenceSampleCount = 150
    workout.stepCountSampleCount = 25
    workout.strideLengthSampleCount = 75
    workout.verticalOscillationSampleCount = 75
    workout.groundContactTimeSampleCount = 75
    workout.intervalCount = 4
    workout.intervalLabelsSummary = "Warmup, Work, Cooldown"

    let rows = HealthKitAudit.rows(for: [workout])
    let markdown = HealthKitAudit.markdown(workouts: [workout], generatedAt: start)

    #expect(rows.count == 1)
    #expect(rows[0].fields.first { $0.label == "Heart rate" }?.value == "300")
    #expect(rows[0].fields.first { $0.label == "Speed/distance samples" }?.detail == "Speed 280, distance 20.")
    #expect(rows[0].fields.first { $0.label == "Events/intervals" }?.detail == "Warmup, Work, Cooldown")
    #expect(rows[0].caveats.contains("Running power may exist as a summary, but the detailed power series was not found."))
    #expect(markdown.contains("# HealthKit Audit"))
    #expect(markdown.contains("- Route points: 240"))
    #expect(markdown.contains("- Speed/distance samples: 300"))
}

@Test func healthKitAuditExplainsEventsWithoutLabels() {
    let start = Date(timeIntervalSince1970: 1_000)
    var workout = testWorkout(
        id: "event-no-label-workout",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.intervalCount = 3

    let row = HealthKitAudit.rows(for: [workout])[0]

    #expect(row.fields.first { $0.label == "Events/intervals" }?.value == "3")
    #expect(row.fields.first { $0.label == "Events/intervals" }?.detail == "Workout events were found, but HealthKit did not expose labels.")
    #expect(row.caveats.contains("Workout events were found, but HealthKit did not expose Warmup, Work, Cooldown, or similar labels."))
}

@Test func healthKitAuditSkipsDuplicateWorkouts() {
    let start = Date(timeIntervalSince1970: 1_000)
    var duplicate = testWorkout(
        id: "duplicate-audit-workout",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    duplicate.isDuplicate = true

    #expect(HealthKitAudit.rows(for: [duplicate]).isEmpty)
    #expect(HealthKitAudit.markdown(workouts: [duplicate], generatedAt: start).contains("No non-duplicate workouts are available for audit."))
}

@Test func physicalVerificationReportSelectsRepresentativeRunsAndMissingSlots() {
    let calendar = Calendar(identifier: .gregorian)
    let easyDate = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let indoorDate = calendar.date(from: DateComponents(year: 2026, month: 5, day: 20))!
    let intervalDate = calendar.date(from: DateComponents(year: 2026, month: 5, day: 10))!
    let olderDate = calendar.date(from: DateComponents(year: 2019, month: 1, day: 3))!

    var easy = testWorkout(id: "easy", start: easyDate, distanceMeters: 6_000, durationSeconds: 1_900, inferredRunType: .easy)
    easy.routePointCount = 300
    easy.heartRateSampleCount = 20
    easy.runningSpeedSampleCount = 20

    var treadmill = CanonicalWorkout(
        id: "treadmill",
        sourceID: "treadmill",
        sourceName: "HealthKit",
        startDate: indoorDate,
        endDate: indoorDate.addingTimeInterval(2_000),
        environment: .indoor,
        distanceMeters: 5_000,
        durationSeconds: 2_000,
        inferredRunType: .easy
    )
    treadmill.heartRateSampleCount = 12

    var interval = testWorkout(id: "interval", start: intervalDate, distanceMeters: 8_000, durationSeconds: 2_800, inferredRunType: .interval)
    interval.intervalCount = 8
    interval.heartRateSampleCount = 30
    interval.distanceSampleCount = 30

    let older = testWorkout(id: "older", start: olderDate, distanceMeters: 4_000, durationSeconds: 1_600, inferredRunType: .unknown)

    let rows = PhysicalVerificationReport.rows(for: [easy, treadmill, interval, older])

    #expect(rows.first { $0.kind == .easyOutdoor }?.workout?.id == "easy")
    #expect(rows.first { $0.kind == .treadmill }?.workout?.id == "treadmill")
    #expect(rows.first { $0.kind == .intervalOrStructured }?.workout?.id == "interval")
    #expect(rows.first { $0.kind == .olderHistorical }?.workout?.id == "older")
    #expect(rows.first { $0.kind == .raceOrTimeTrial }?.workout == nil)

    let markdown = PhysicalVerificationReport.markdown(workouts: [easy, treadmill, interval, older], generatedAt: easyDate)
    #expect(markdown.contains("Race or time trial | Missing"))
    #expect(markdown.contains("representative slots are still missing candidates"))
}

@Test func normalizedRunKeepsMissingMetricsNilAndLabelsProvenance() {
    let start = Date(timeIntervalSince1970: 1_000)
    let workout = testWorkout(
        id: "normalized",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )

    let normalized = NormalizedRun.from(workout)

    #expect(normalized.averagePaceSecondsPerKm == 300)
    #expect(normalized.elapsedSeconds == 1_500)
    #expect(normalized.totalEnergyKcal == nil)
    #expect(normalized.metricProvenance["totalEnergyKcal"]?.source == .unavailable)
    #expect(normalized.dataQualityReport.warnings.contains("Total calories are unavailable; active calories remain separate."))
}

@Test func sampleCadenceUsesFullStepsPerMinute() {
    let cadences = SampleData.workouts.compactMap(\.averageCadence)

    #expect(!cadences.isEmpty)
    #expect(cadences.allSatisfy { $0 >= 120 })
}

@Test func duplicateDetectorPrefersAppleWatchThenRichestEvidence() {
    let start = Date(timeIntervalSince1970: 2_000)
    var thirdParty = testWorkout(
        id: "strava",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    thirdParty.sourceName = "Strava"
    thirdParty.seriesSampleCount = 400

    var appleWatch = testWorkout(
        id: "apple-watch",
        start: start.addingTimeInterval(20),
        distanceMeters: 5_020,
        durationSeconds: 1_505
    )
    appleWatch.sourceName = "Apple Fitness"
    appleWatch.deviceName = "Apple Watch"

    let marked = DuplicateDetector.markDuplicates([thirdParty, appleWatch])

    #expect(marked.first { $0.id == "apple-watch" }?.isDuplicate == false)
    #expect(marked.first { $0.id == "strava" }?.isDuplicate == true)
    #expect(marked.first { $0.id == "strava" }?.duplicateOfID == "apple-watch")
}

@Test func healthKitPermissionCatalogIsReadOnlyAndDocumentsReasons() {
    #expect(!HealthKitPermissionCatalog.readItems.isEmpty)
    #expect(HealthKitPermissionCatalog.permissionExplanation.contains("not used for advertising or sold"))
    #expect(HealthKitPermissionCatalog.readItems.allSatisfy { !$0.reason.isEmpty })
    #expect(HealthKitPermissionCatalog.intentionallySkipped.contains("Cycling metrics"))
    #expect(HealthKitPermissionCatalog.markdown().contains("requests no write permissions"))
}

@Test func goldenAppleFitnessValidationAppliesTolerances() {
    let start = Date(timeIntervalSince1970: 3_000)
    var workout = testWorkout(
        id: "golden",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )
    workout.activeEnergyKilocalories = 300
    workout.totalEnergyKilocalories = 358
    workout.averageHeartRate = 150
    workout.maxHeartRate = 172
    workout.averageCadence = 176
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 1_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(600), value: 1_000)
                ]
            )
        ]
    )

    let expected = GoldenAppleFitnessExpectedWorkout(
        workoutId: "golden",
        date: "Test",
        expectedDistanceKm: 5.01,
        expectedWorkoutDurationSeconds: 1_501,
        expectedElapsedTimeSeconds: 1_500,
        expectedAveragePaceSecPerKm: 300,
        expectedActiveCaloriesKcal: 305,
        expectedTotalCaloriesKcal: 359,
        expectedAverageHeartRateBpm: 151,
        expectedMaxHeartRateBpm: 172,
        expectedAverageCadenceSpm: 175,
        expectedRouteAvailable: false,
        expectedSplitCount: 2,
        expectedSplitTimesSeconds: [303, 300]
    )

    let results = GoldenAppleFitnessValidation.results(workouts: [workout], expected: [expected])
    let fields = results[0].fieldResults

    #expect(fields.first { $0.field == "Distance" }?.status == .pass)
    #expect(fields.first { $0.field == "Workout duration" }?.status == .pass)
    #expect(fields.first { $0.field == "Average HR" }?.status == .pass)
    #expect(fields.first { $0.field == "Total calories" }?.status == .pass)
    #expect(fields.first { $0.field == "Split count" }?.status == .pass)
    #expect(fields.first { $0.field == "KM 1 split" }?.status == .pass)
}

@Test func goldenAppleFitnessValidationExportsEditableCSVTemplate() {
    let start = Date(timeIntervalSince1970: 3_000)
    let workout = testWorkout(
        id: "csv-golden",
        start: start,
        distanceMeters: 5_000,
        durationSeconds: 1_500
    )

    let csv = GoldenAppleFitnessValidation.csvTemplate(workouts: [workout])

    #expect(csv.contains("workoutId,date,appleFitnessTitle"))
    #expect(csv.contains("csv-golden"))
    #expect(csv.contains("expectedDistanceKm"))
    #expect(csv.contains("expectedSplitTimesSeconds"))
}

@Test func goldenAppleFitnessChecklistExportsHeartRateAndSplitRows() {
    let start = Date(timeIntervalSince1970: 3_000)
    var workout = testWorkout(
        id: "checklist-golden",
        start: start,
        distanceMeters: 2_000,
        durationSeconds: 600
    )
    workout.averageHeartRate = 146
    workout.maxHeartRate = 179
    workout.evidence = WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: start,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: [
                    WorkoutEvidencePoint(date: start.addingTimeInterval(300), value: 1_000),
                    WorkoutEvidencePoint(date: start.addingTimeInterval(600), value: 1_000)
                ]
            )
        ]
    )

    let markdown = GoldenAppleFitnessValidation.checklistMarkdown(workouts: [workout], generatedAt: start)

    #expect(markdown.contains("average HR 146 bpm"))
    #expect(markdown.contains("max HR 179 bpm"))
    #expect(markdown.contains("RunSignal 1 km splits"))
    #expect(markdown.contains("KM 1: 5:00"))
}

@Test func monthlyDiagnosticsExportIncludesSchemaAndMultipleWorkoutRecords() throws {
    let calendar = fixedCalendar()
    let month = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let simpleStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 2, hour: 7))!
    let noPlanStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 3, hour: 8))!
    let outsideStart = calendar.date(from: DateComponents(year: 2026, month: 5, day: 31, hour: 7))!

    var simple = testWorkout(id: "simple", start: simpleStart, distanceMeters: 5_060, durationSeconds: 1_830)
    simple.evidence = monthlyEvidence(
        workout: simple,
        plannedSteps: [
            PlannedWorkoutStep(
                index: 1,
                label: "Work 1",
                stepType: .work,
                plannedGoalType: .distance,
                plannedGoalValue: 5_000,
                plannedGoalDisplayText: "5 km"
            )
        ],
        activityEndOffset: 1_800,
        activityDistanceMeters: 5_000,
        distancePoints: [(0, 0), (1_800, 5_000), (1_830, 5_060)]
    )

    var noPlan = testWorkout(id: "no-plan", start: noPlanStart, distanceMeters: 1_000, durationSeconds: 360)
    noPlan.evidence = monthlyEvidence(
        workout: noPlan,
        plannedSteps: [],
        activityEndOffset: 360,
        activityDistanceMeters: 1_000,
        distancePoints: [(0, 0), (360, 1_000)]
    )

    let outside = testWorkout(id: "outside", start: outsideStart, distanceMeters: 5_000, durationSeconds: 1_500)

    let object = try monthlyDiagnosticsObject(
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: [outside, noPlan, simple],
            selectedMonth: month,
            calendar: calendar,
            generatedAt: month
        )
    )
    let records = try #require(object["records"] as? [[String: Any]])

    #expect(object["exportVersion"] as? Int == 1)
    #expect(object["selectedMonth"] as? String == "2026-06")
    #expect(object["workoutCount"] as? Int == 2)
    #expect(object["productionIntervalBehaviorChanged"] as? Bool == false)
    #expect(object["normalWorkoutUIChanged"] as? Bool == false)
    #expect(object["boundaryLogicChanged"] as? Bool == false)
    #expect(records.map { $0["workoutID"] as? String } == ["simple", "no-plan"])

    let firstSummary = try #require(records[0]["diagnosticsSummary"] as? [String: Any])
    #expect(firstSummary["classification"] as? String == "simple fixed-distance Work + Open candidate")
    #expect(firstSummary["hasWorkoutKitPlan"] as? Bool == true)
    #expect(firstSummary["hkWorkoutActivityCount"] as? Int == 1)
    #expect(firstSummary["hasOpenExtraTail"] as? Bool == true)

    let firstPacket = try #require(records[0]["parityPacket"] as? [String: Any])
    #expect(firstPacket["activityBoundaryCandidateSummary"] != nil)
    #expect(firstPacket["activityBoundaryCandidateIntervals"] != nil)

    let secondSummary = try #require(records[1]["diagnosticsSummary"] as? [String: Any])
    #expect(secondSummary["classification"] as? String == "no WorkoutKit plan")
    #expect(secondSummary["hasWorkoutKitPlan"] as? Bool == false)
}

@Test func monthlyDiagnosticsExportIncludesRefreshSummaryAndPerWorkoutStatus() throws {
    let calendar = fixedCalendar()
    let month = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let successStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 4, hour: 7))!
    let failedStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 5, hour: 7))!

    var refreshed = testWorkout(id: "refreshed", start: successStart, distanceMeters: 5_000, durationSeconds: 1_700)
    refreshed.evidence = monthlyEvidence(
        workout: refreshed,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityEndOffset: 1_700,
        activityDistanceMeters: 5_000,
        distancePoints: [(0, 0), (1_700, 5_000)]
    )
    let failed = testWorkout(id: "failed", start: failedStart, distanceMeters: 4_000, durationSeconds: 1_500)

    let object = try monthlyDiagnosticsObject(
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: [failed, refreshed],
            selectedMonth: month,
            calendar: calendar,
            monthlyRefreshResults: [
                refreshed.id: MonthlyEvidenceRefreshResult(
                    workoutID: refreshed.id,
                    requestedAt: month,
                    completedAt: month.addingTimeInterval(1),
                    refreshStatus: .success,
                    cacheWasPresent: true,
                    invalidatedCache: true,
                    freshQueryReturnedWorkout: true,
                    authorizationState: .authorized,
                    evidenceCounts: ParityEvidenceCounts(workout: refreshed),
                    evidenceLoadedAt: refreshed.evidence?.loadedAt
                ),
                failed.id: MonthlyEvidenceRefreshResult(
                    workoutID: failed.id,
                    requestedAt: month,
                    completedAt: month.addingTimeInterval(2),
                    refreshStatus: .failed,
                    refreshError: "No matching HealthKit running workouts were found for enrichment.",
                    cacheWasPresent: false,
                    invalidatedCache: true,
                    freshQueryReturnedWorkout: false,
                    authorizationState: .partial
                )
            ],
            generatedAt: month
        )
    )
    let summary = try #require(object["summary"] as? [String: Any])
    let records = try #require(object["records"] as? [[String: Any]])

    #expect(summary["totalWorkoutCount"] as? Int == 2)
    #expect(summary["refreshedCount"] as? Int == 1)
    #expect(summary["failedCount"] as? Int == 1)
    #expect(summary["freshQueryCount"] as? Int == 1)
    #expect(summary["missingEvidenceCount"] as? Int == 1)

    #expect(records[0]["refreshStatus"] as? String == "success")
    #expect(records[0]["evidenceSource"] as? String == "freshQuery")
    #expect(records[0]["freshQueryReturnedWorkout"] as? Bool == true)
    #expect(records[0]["cacheWasPresent"] as? Bool == true)

    #expect(records[1]["refreshStatus"] as? String == "failed")
    #expect(records[1]["classification"] as? String == "missing evidence after refresh")
    #expect(records[1]["refreshError"] as? String == "No matching HealthKit running workouts were found for enrichment.")
}

@Test func monthlyDiagnosticsExportHandlesEmptyMonth() throws {
    let calendar = fixedCalendar()
    let month = calendar.date(from: DateComponents(year: 2026, month: 2, day: 1))!
    let object = try monthlyDiagnosticsObject(
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: [],
            selectedMonth: month,
            calendar: calendar,
            generatedAt: month
        )
    )
    let records = try #require(object["records"] as? [[String: Any]])

    #expect(object["selectedMonth"] as? String == "2026-02")
    #expect(object["workoutCount"] as? Int == 0)
    #expect(records.isEmpty)
}

@Test func monthlyDiagnosticsExportClassifiesNoPlanWithGoodHealthKitEvidenceAfterRefresh() throws {
    let calendar = fixedCalendar()
    let month = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let start = calendar.date(from: DateComponents(year: 2026, month: 6, day: 6, hour: 7))!

    var workout = testWorkout(id: "good-no-plan", start: start, distanceMeters: 3_000, durationSeconds: 1_100)
    workout.evidence = monthlyEvidence(
        workout: workout,
        plannedSteps: [],
        activityEndOffset: 1_100,
        activityDistanceMeters: 3_000,
        distancePoints: [(0, 0), (1_100, 3_000)]
    )

    let object = try monthlyDiagnosticsObject(
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: [workout],
            selectedMonth: month,
            calendar: calendar,
            monthlyRefreshResults: [
                workout.id: MonthlyEvidenceRefreshResult(
                    workoutID: workout.id,
                    requestedAt: month,
                    completedAt: month,
                    refreshStatus: .success,
                    cacheWasPresent: false,
                    invalidatedCache: true,
                    freshQueryReturnedWorkout: true,
                    authorizationState: .authorized
                )
            ],
            generatedAt: month
        )
    )
    let records = try #require(object["records"] as? [[String: Any]])

    #expect(records[0]["classification"] as? String == "no WorkoutKit plan")
    #expect(records[0]["evidenceSource"] as? String == "freshQuery")
    #expect(records[0]["workoutKitPlanStatus"] as? String == "unavailable")
}

@Test func monthlyDiagnosticsExportClassifiesMissingActivitiesAfterRefresh() throws {
    let calendar = fixedCalendar()
    let month = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let start = calendar.date(from: DateComponents(year: 2026, month: 6, day: 7, hour: 7))!

    var workout = testWorkout(id: "no-activities", start: start, distanceMeters: 5_000, durationSeconds: 1_800)
    workout.evidence = monthlyEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 5_000, plannedGoalDisplayText: "5 km")
        ],
        activityEndOffset: 1_800,
        activityDistanceMeters: 5_000,
        distancePoints: [(0, 0), (1_800, 5_000)],
        includeActivity: false
    )

    let object = try monthlyDiagnosticsObject(
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: [workout],
            selectedMonth: month,
            calendar: calendar,
            monthlyRefreshResults: [
                workout.id: MonthlyEvidenceRefreshResult(
                    workoutID: workout.id,
                    requestedAt: month,
                    completedAt: month,
                    refreshStatus: .success,
                    cacheWasPresent: true,
                    invalidatedCache: true,
                    freshQueryReturnedWorkout: true,
                    authorizationState: .authorized
                )
            ],
            generatedAt: month
        )
    )
    let summary = try #require(object["summary"] as? [String: Any])
    let records = try #require(object["records"] as? [[String: Any]])

    #expect(records[0]["classification"] as? String == "no HKWorkoutActivity rows after refresh")
    #expect(summary["noHKWorkoutActivityRowsCount"] as? Int == 1)
    #expect(records[0]["productionIntervalBehaviorChanged"] == nil)
    #expect(object["productionIntervalBehaviorChanged"] as? Bool == false)
    #expect(object["normalWorkoutUIChanged"] as? Bool == false)
    #expect(object["usesFITRuntimeTruth"] as? Bool == false)
}

@Test func monthlyDiagnosticsExportClassifiesStructuredAndSameDayExtraRuns() throws {
    let calendar = fixedCalendar()
    let month = calendar.date(from: DateComponents(year: 2026, month: 6, day: 1))!
    let intervalStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 3, hour: 7))!
    let extraStart = calendar.date(from: DateComponents(year: 2026, month: 6, day: 3, hour: 18))!

    var interval = testWorkout(id: "interval", start: intervalStart, distanceMeters: 2_200, durationSeconds: 900)
    interval.evidence = monthlyEvidence(
        workout: interval,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .time, plannedGoalValue: 300, plannedGoalDisplayText: "5 min"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, plannedGoalType: .time, plannedGoalValue: 120, plannedGoalDisplayText: "2 min"),
            PlannedWorkoutStep(index: 4, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalValue: nil, plannedGoalDisplayText: "Open")
        ],
        activityEndOffset: 900,
        activityDistanceMeters: 2_200,
        distancePoints: [(0, 0), (300, 1_000), (420, 1_400), (540, 1_600), (900, 2_200)]
    )

    var extra = testWorkout(id: "extra", start: extraStart, distanceMeters: 1_000, durationSeconds: 360)
    extra.evidence = monthlyEvidence(
        workout: extra,
        plannedSteps: [],
        activityEndOffset: 360,
        activityDistanceMeters: 1_000,
        distancePoints: [(0, 0), (360, 1_000)]
    )

    let object = try monthlyDiagnosticsObject(
        DiagnosticsExport.monthlyDiagnosticsJSON(
            workouts: [extra, interval],
            selectedMonth: month,
            calendar: calendar,
            generatedAt: month
        )
    )
    let records = try #require(object["records"] as? [[String: Any]])
    let summaries = try records.map { try #require($0["diagnosticsSummary"] as? [String: Any]) }

    #expect(summaries[0]["classification"] as? String == "structured interval workout")
    #expect(summaries[1]["classification"] as? String == "duplicate/same-day extra run candidate")
    #expect(records.map { $0["workoutID"] as? String } == ["interval", "extra"])
}

private func jun10PlannedWorkoutSteps() -> [PlannedWorkoutStep] {
    [
        PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km", plannedTargetDisplayText: "pace range 6:00-6:30 /km"),
        PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m", plannedTargetDisplayText: "pace range 3:40-3:50 /km"),
        PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
        PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m", plannedTargetDisplayText: "pace range 3:40-3:50 /km"),
        PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
        PlannedWorkoutStep(index: 6, label: "Work 3", stepType: .work, repeatBlockIndex: 1, repeatIndex: 3, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m", plannedTargetDisplayText: "pace range 3:40-3:50 /km"),
        PlannedWorkoutStep(index: 7, label: "Recovery 3", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 3, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
        PlannedWorkoutStep(index: 8, label: "Work 4", stepType: .work, repeatBlockIndex: 1, repeatIndex: 4, plannedGoalType: .distance, plannedGoalValue: 400, plannedGoalDisplayText: "400 m", plannedTargetDisplayText: "pace range 3:40-3:50 /km"),
        PlannedWorkoutStep(index: 9, label: "Recovery 4", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 4, plannedGoalType: .time, plannedGoalValue: 105, plannedGoalDisplayText: "105 s"),
        PlannedWorkoutStep(index: 10, label: "Cooldown", stepType: .cooldown, plannedGoalType: .distance, plannedGoalValue: 2_500, plannedGoalDisplayText: "2.50 km", plannedTargetDisplayText: "pace range 6:00-6:30 /km")
    ]
}

private func assertInterval(
    _ interval: ReconstructedWorkoutInterval,
    label: String,
    expectedDuration: Double,
    durationTolerance: Double,
    expectedDistance: Double,
    distanceTolerance: Double
) {
    #expect(interval.label == label)
    #expect(abs(interval.actualDurationSeconds - expectedDuration) <= durationTolerance)
    #expect(abs((interval.actualDistanceMeters ?? 0) - expectedDistance) <= distanceTolerance)
}

private func assertElapsedTimingSemantics(_ intervals: [ReconstructedWorkoutInterval]) {
    for interval in intervals {
        #expect(interval.durationDisplayRule == .elapsedRowWindow)
        #expect(abs((interval.elapsedDurationSeconds ?? -1) - interval.actualDurationSeconds) <= 0.001)
        #expect(abs((interval.pauseOverlapSeconds ?? -1) - 0) <= 0.001)
        #expect(abs((interval.activeDurationSeconds ?? -1) - interval.actualDurationSeconds) <= 0.001)
        #expect(abs(interval.displayDurationSeconds - interval.actualDurationSeconds) <= 0.001)
        #expect(IntervalRowTimingText.pausedTimingDetail(for: interval) == nil)
    }
}

private func monthlyDiagnosticsObject(_ json: String) throws -> [String: Any] {
    let data = try #require(json.data(using: .utf8))
    return try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
}

private func rawDebugPayloadObject(from markdown: String) throws -> [String: Any] {
    let startRange = try #require(markdown.range(of: "```json\n"))
    let payloadStart = startRange.upperBound
    let remaining = markdown[payloadStart...]
    let endRange = try #require(remaining.range(of: "\n```"))
    return try monthlyDiagnosticsObject(String(remaining[..<endRange.lowerBound]))
}

private func pausedRepeatOpenCooldownFixture(
    id: String,
    activityWindows: [(start: TimeInterval, end: TimeInterval, distance: Double)] = [
        (0, 700, 2_000),
        (700, 950, 1_000),
        (950, 1_100, 200),
        (1_100, 1_350, 1_000),
        (1_350, 1_500, 200),
        (1_500, 1_700, 1_000)
    ],
    distancePoints: [(offset: TimeInterval, distance: Double)] = [
        (700, 2_000),
        (950, 1_000),
        (1_100, 200),
        (1_350, 1_000),
        (1_500, 200),
        (1_700, 1_000)
    ],
    events: [WorkoutEvidenceEvent]? = nil
) -> (workout: CanonicalWorkout, evidence: WorkoutEvidence) {
    let start = Date(timeIntervalSince1970: 10_656)
    let workout = testWorkout(id: id, start: start, distanceMeters: 4_800, durationSeconds: 1_700)
    let evidence = normalDetailGateEvidence(
        workout: workout,
        plannedSteps: [
            PlannedWorkoutStep(index: 1, label: "Warmup", stepType: .warmup, plannedGoalType: .distance, plannedGoalValue: 2_000, plannedGoalDisplayText: "2 km"),
            PlannedWorkoutStep(index: 2, label: "Work 1", stepType: .work, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 3, label: "Recovery 1", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 1, plannedGoalType: .time, plannedGoalValue: 150, plannedGoalDisplayText: "150 s"),
            PlannedWorkoutStep(index: 4, label: "Work 2", stepType: .work, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .distance, plannedGoalValue: 1_000, plannedGoalDisplayText: "1 km"),
            PlannedWorkoutStep(index: 5, label: "Recovery 2", stepType: .recovery, repeatBlockIndex: 1, repeatIndex: 2, plannedGoalType: .time, plannedGoalValue: 150, plannedGoalDisplayText: "150 s"),
            PlannedWorkoutStep(index: 6, label: "Cooldown", stepType: .cooldown, plannedGoalType: .open, plannedGoalDisplayText: "Open")
        ],
        activityWindows: activityWindows,
        distancePoints: distancePoints,
        events: events ?? [
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_000), endDate: start.addingTimeInterval(1_000), type: "HKWorkoutEventType(rawValue: 1)", label: "Pause"),
            WorkoutEvidenceEvent(startDate: start.addingTimeInterval(1_090), endDate: start.addingTimeInterval(1_090), type: "HKWorkoutEventType(rawValue: 2)", label: "Resume")
        ]
    )

    return (workout, evidence)
}

private func recoveryTailNormalDetailFixture(
    id: String = "normal-detail-recovery-tail-supported",
    start: Date = Date(timeIntervalSince1970: 10_661),
    plannedSteps: [PlannedWorkoutStep] = recoveryTailPlannedSteps(),
    activityWindows: [(start: TimeInterval, end: TimeInterval, distance: Double)] = recoveryTailActivityWindows(),
    workoutDistanceMeters: Double? = nil,
    workoutDurationSeconds: Double? = nil,
    distancePoints: [(offset: TimeInterval, distance: Double)]? = nil,
    events: [WorkoutEvidenceEvent]? = nil
) -> (workout: CanonicalWorkout, evidence: WorkoutEvidence) {
    let mappedDurationSeconds = activityWindows.last?.end ?? 0
    let mappedDistanceMeters = activityWindows.reduce(0) { $0 + $1.distance }
    let durationSeconds = workoutDurationSeconds ?? mappedDurationSeconds + 9.9
    let distanceMeters = workoutDistanceMeters ?? mappedDistanceMeters + 16.6
    let workout = testWorkout(id: id, start: start, distanceMeters: distanceMeters, durationSeconds: durationSeconds)
    let defaultEvents = [
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(1_500.0),
            endDate: start.addingTimeInterval(1_500.0),
            type: "HKWorkoutEventType(rawValue: 1)",
            label: "Pause"
        ),
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(1_641.0),
            endDate: start.addingTimeInterval(1_641.0),
            type: "HKWorkoutEventType(rawValue: 2)",
            label: "Resume"
        ),
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(2_500.0),
            endDate: start.addingTimeInterval(2_500.0),
            type: "HKWorkoutEventType(rawValue: 1)",
            label: "Pause"
        ),
        WorkoutEvidenceEvent(
            startDate: start.addingTimeInterval(2_591.8),
            endDate: start.addingTimeInterval(2_591.8),
            type: "HKWorkoutEventType(rawValue: 2)",
            label: "Resume"
        )
    ]

    return (
        workout,
        normalDetailGateEvidence(
            workout: workout,
            plannedSteps: plannedSteps,
            activityWindows: activityWindows,
            distancePoints: distancePoints ?? recoveryTailDistancePoints(from: activityWindows),
            events: events ?? defaultEvents
        )
    )
}

private func recoveryTailPlannedSteps() -> [PlannedWorkoutStep] {
    [
        PlannedWorkoutStep(
            index: 1,
            label: "Warmup",
            stepType: .warmup,
            plannedGoalType: .distance,
            plannedGoalValue: 2_000,
            plannedGoalDisplayText: "2 km"
        ),
        PlannedWorkoutStep(
            index: 2,
            label: "Recovery 1",
            stepType: .recovery,
            plannedGoalType: .time,
            plannedGoalValue: 120,
            plannedGoalDisplayText: "2 min"
        ),
        PlannedWorkoutStep(
            index: 3,
            label: "Work 1",
            stepType: .work,
            plannedGoalType: .distance,
            plannedGoalValue: 5_000,
            plannedGoalDisplayText: "5 km"
        ),
        PlannedWorkoutStep(
            index: 4,
            label: "Cooldown",
            stepType: .cooldown,
            plannedGoalType: .distance,
            plannedGoalValue: 2_000,
            plannedGoalDisplayText: "2 km"
        )
    ]
}

private func recoveryTailActivityWindows() -> [(start: TimeInterval, end: TimeInterval, distance: Double)] {
    [
        (start: 0.0, end: 772.5, distance: 2_009.1),
        (start: 772.5, end: 892.0, distance: 194.8),
        (start: 892.0, end: 2_337.4, distance: 5_005.7),
        (start: 2_337.4, end: 3_171.4, distance: 1_995.9)
    ]
}

private func recoveryTailDistancePoints(
    from activityWindows: [(start: TimeInterval, end: TimeInterval, distance: Double)]
) -> [(offset: TimeInterval, distance: Double)] {
    activityWindows.map { (offset: $0.end, distance: $0.distance) }
}

private func normalDetailGateEvidence(
    workout: CanonicalWorkout,
    plannedSteps: [PlannedWorkoutStep],
    activityWindows: [(start: TimeInterval, end: TimeInterval, distance: Double)],
    distancePoints: [(offset: TimeInterval, distance: Double)],
    events: [WorkoutEvidenceEvent] = []
) -> WorkoutEvidence {
    WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: workout.startDate,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: distancePoints.map { offset, distance in
                    WorkoutEvidencePoint(
                        date: workout.startDate.addingTimeInterval(offset),
                        value: distance
                    )
                }
            )
        ],
        events: events,
        activities: activityWindows.enumerated().map { offset, window in
            let startDate = workout.startDate.addingTimeInterval(window.start)
            let endDate = workout.startDate.addingTimeInterval(window.end)
            return WorkoutEvidenceActivity(
                id: "\(workout.id)-activity-\(offset + 1)",
                activityType: "HKWorkoutActivityTypeRunning",
                locationType: nil,
                startDate: startDate,
                endDate: endDate,
                durationSeconds: window.end - window.start,
                metadataKeys: [],
                events: [],
                statistics: [
                    WorkoutEvidenceActivityStatistic(
                        quantityType: "HKQuantityTypeIdentifierDistanceWalkingRunning",
                        unit: "m",
                        startDate: startDate,
                        endDate: endDate,
                        sourceCount: 1,
                        sum: window.distance,
                        durationSeconds: window.end - window.start
                    )
                ]
            )
        },
        workoutPlanAudit: WorkoutPlanAudit(
            status: plannedSteps.isEmpty ? .unavailable : .available,
            planType: plannedSteps.isEmpty ? nil : "Custom workout",
            plannedSteps: plannedSteps
        )
    )
}

private func monthlyEvidence(
    workout: CanonicalWorkout,
    plannedSteps: [PlannedWorkoutStep],
    activityEndOffset: TimeInterval,
    activityDistanceMeters: Double,
    distancePoints: [(TimeInterval, Double)],
    includeActivity: Bool = true
) -> WorkoutEvidence {
    WorkoutEvidence(
        workoutID: workout.id,
        loadedAt: workout.startDate,
        series: [
            .distance: WorkoutMetricSeries(
                metric: .distance,
                unit: "m",
                points: distancePoints.map { offset, distance in
                    WorkoutEvidencePoint(
                        date: workout.startDate.addingTimeInterval(offset),
                        value: distance
                    )
                }
            )
        ],
        events: [],
        activities: includeActivity ? [
            WorkoutEvidenceActivity(
                id: "\(workout.id)-activity",
                activityType: "HKWorkoutActivityTypeRunning",
                locationType: nil,
                startDate: workout.startDate,
                endDate: workout.startDate.addingTimeInterval(activityEndOffset),
                durationSeconds: activityEndOffset,
                metadataKeys: [],
                events: [],
                statistics: [
                    WorkoutEvidenceActivityStatistic(
                        quantityType: "HKQuantityTypeIdentifierDistanceWalkingRunning",
                        unit: "m",
                        startDate: workout.startDate,
                        endDate: workout.startDate.addingTimeInterval(activityEndOffset),
                        sourceCount: 1,
                        sum: activityDistanceMeters,
                        durationSeconds: activityEndOffset
                    )
                ]
            )
        ] : [],
        workoutPlanAudit: WorkoutPlanAudit(
            status: plannedSteps.isEmpty ? .unavailable : .available,
            planType: plannedSteps.isEmpty ? nil : "Custom workout",
            plannedSteps: plannedSteps
        )
    )
}

private func fixedCalendar() -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar
}

@MainActor
private func inMemoryModelContext() throws -> ModelContext {
    let schema = Schema([
        PersistedWorkout.self,
        PersistedWorkoutEvidence.self,
        PersistedEvidenceEnrichmentState.self,
        PersistedDerivedWorkoutAnalysis.self
    ])
    let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: true)
    let container = try ModelContainer(for: schema, configurations: [configuration])
    return ModelContext(container)
}

private func testSeries(_ metric: WorkoutEvidenceMetric, value: Double, start: Date) -> WorkoutMetricSeries {
    WorkoutMetricSeries(
        metric: metric,
        unit: "test",
        points: [
            WorkoutEvidencePoint(date: start, value: value)
        ]
    )
}

private func testSeries(
    _ metric: WorkoutEvidenceMetric,
    values: [Double],
    start: Date,
    interval: TimeInterval = 60
) -> WorkoutMetricSeries {
    WorkoutMetricSeries(
        metric: metric,
        unit: "test",
        points: values.enumerated().map { index, value in
            WorkoutEvidencePoint(date: start.addingTimeInterval(TimeInterval(index) * interval), value: value)
        }
    )
}

private func testWorkout(
    id: String,
    start: Date,
    distanceMeters: Double?,
    durationSeconds: TimeInterval,
    inferredRunType: RunType = .easy,
    manualRunType: RunType? = nil
) -> CanonicalWorkout {
    CanonicalWorkout(
        id: id,
        sourceID: id,
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(durationSeconds),
        environment: .outdoor,
        distanceMeters: distanceMeters,
        durationSeconds: durationSeconds,
        inferredRunType: inferredRunType,
        manualRunType: manualRunType
    )
}
