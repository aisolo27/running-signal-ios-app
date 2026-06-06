import Foundation
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
    #expect(applied[0].manualRunType == .threshold)
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
            .stepCount: testSeries(.stepCount, value: 120, start: start)
        ],
        route: []
    )

    let coverage = WorkoutEvidenceAnalyzer.coverage(for: evidence)

    #expect(!coverage.heartRate)
    #expect(!coverage.speedOrDistance)
    #expect(coverage.activeEnergy)
    #expect(coverage.cadenceOrSteps)
    #expect(coverage.confidence == .limited)
    #expect(coverage.caveats.contains("Heart-rate series is missing, so drift and intensity claims stay limited."))
    #expect(coverage.caveats.contains("Speed or distance series is missing, so pacing-shape claims stay limited."))
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
    #expect(rows[0].fields.first { $0.label == "Heart rate samples" }?.value == "300")
    #expect(rows[0].fields.first { $0.label == "Speed/distance samples" }?.detail == "Speed 280, distance 20.")
    #expect(rows[0].fields.first { $0.label == "Events/intervals" }?.detail == "Warmup, Work, Cooldown")
    #expect(rows[0].caveats.contains("Running power is optional and was not found as a sample series."))
    #expect(markdown.contains("# HealthKit Audit"))
    #expect(markdown.contains("- Route points: 240"))
    #expect(markdown.contains("- Speed/distance samples: 300"))
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

private func fixedCalendar() -> Calendar {
    var calendar = Calendar(identifier: .gregorian)
    calendar.timeZone = TimeZone(secondsFromGMT: 0)!
    return calendar
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
