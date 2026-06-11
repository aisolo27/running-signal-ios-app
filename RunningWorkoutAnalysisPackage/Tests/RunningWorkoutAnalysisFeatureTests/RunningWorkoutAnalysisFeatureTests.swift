import Foundation
import SwiftData
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func paceMathUsesSecondsPerKilometer() {
    let pace = PaceMath.paceSecondsPerKm(distanceMeters: 5_000, durationSeconds: 1_200)
    #expect(pace == 240)
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
    #expect(candidates[0].averageHeartRateBpm == 130)
    #expect(candidates[0].confidence == .strong)
    #expect(candidates[1].label == .work)
    #expect(candidates[1].distanceMeters == 400)
    #expect(candidates[1].paceSecondsPerKm == 225)
    #expect(candidates[2].label == .recovery)
    #expect(candidates[2].distanceMeters == 160)
    #expect(abs((candidates[2].paceSecondsPerKm ?? 0) - 656.25) < 0.001)
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
    #expect(candidates[0].confidence == .limited)
    #expect(candidates[0].caveats.contains("HealthKit did not expose an Apple Fitness interval label for this event."))
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
