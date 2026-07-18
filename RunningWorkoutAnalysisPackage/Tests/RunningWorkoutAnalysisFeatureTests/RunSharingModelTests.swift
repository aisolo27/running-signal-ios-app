import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func shareSummaryUsesDisplayPolicyAndHidesUnavailableTemplates() throws {
    let workout = shareWorkout(distance: 11_265.4, duration: 2_970)
    let presentation = WorkoutDetailPresentation.make(workout: workout, analysis: nil)
    let model = RunShareModelBuilder.make(
        workout: workout,
        presentation: presentation,
        policy: RunDisplayPolicy(primaryUnit: .miles, showsSecondaryDistance: true)
    )

    #expect(model.distance.contains("mi"))
    #expect(model.secondaryDistance?.contains("km") == true)
    #expect(model.pace.contains("/mi"))
    #expect(model.secondaryPace?.contains("/km") == true)
    #expect(model.availableTemplates == [.summary])
    #expect(model.routePoints.count == 3)
    #expect(model.routePoints.allSatisfy { (0...1).contains($0.x) && (0...1).contains($0.y) })
}

@Test func shareSplitsFollowThePrimaryUnitAndPaginateEveryRow() throws {
    let workout = shareWorkout(distance: 20_921.5, duration: 5_200)
    var presentation = WorkoutDetailPresentation.make(workout: workout, analysis: nil)
    presentation.segments.kilometerSplits = [shareSplit(label: "KM 1", meters: 1_000, pace: 275)]
    presentation.segments.mileSplits = (1...13).map {
        shareSplit(label: "Mile \($0)", meters: RunningDistanceUnit.metersPerMile, pace: 390 + Double($0))
    }

    let model = RunShareModelBuilder.make(
        workout: workout,
        presentation: presentation,
        policy: .milesOnly
    )

    #expect(model.splitUnitTitle == "1 mi Splits")
    #expect(model.splitRows.count == 13)
    #expect(model.splitRows.first?.label == "Mile 1")
    #expect(model.splitRows.first?.pace.contains("/mi") == true)
    #expect(model.availableTemplates == [.summary, .splits])
    #expect(model.pageCount(template: .splits, canvas: .story) == 2)
    #expect(model.splitRows(page: 0, canvas: .story).count == 11)
    #expect(model.splitRows(page: 1, canvas: .story).count == 2)
    #expect(model.pageCount(template: .splits, canvas: .post) == 2)
    #expect(model.splitRows(page: 0, canvas: .post).count == 7)
    #expect(model.splitRows(page: 1, canvas: .post).count == 6)
}

@Test func shareWorkoutRepsUseOnlyOfficialRowsAndPreserveAuthoredDistance() throws {
    let workout = shareWorkout(distance: 8_000, duration: 2_700)
    var presentation = WorkoutDetailPresentation.make(workout: workout, analysis: nil)
    presentation.supportedIntervals = WorkoutIntervalReconstructionResult(
        planSource: .workoutKit,
        windowSource: .healthKitActivityBoundaries,
        intervals: [
            shareInterval(index: 1, stepType: .work, measuredDistance: 800, activeDuration: 200),
            shareInterval(index: 2, stepType: .recovery, measuredDistance: 200, activeDuration: 100),
            shareInterval(index: 3, stepType: .work, measuredDistance: 800, activeDuration: 220),
            shareInterval(index: 4, stepType: .work, measuredDistance: 400, activeDuration: 100)
        ]
    )

    let model = RunShareModelBuilder.make(
        workout: workout,
        presentation: presentation,
        policy: .milesOnly
    )

    #expect(model.availableTemplates == [.summary, .workoutReps])
    #expect(model.workRows.count == 3)
    #expect(model.workRows.map(\.label) == ["W1", "W2", "W3"])
    #expect(model.workRows.allSatisfy { $0.goal == "800 m" })
    #expect(model.workRows.map(\.status) == [.onTarget, .slow, .shortened])
    #expect(model.workRows.allSatisfy { $0.pace.contains("/mi") })
    #expect(model.workoutPrescription?.hasPrefix("3 × 800 m") == true)
    #expect(model.workoutResultSummary == "2 of 3 on target · 0 fast · 1 slow · 1 shortened")
}

@Test func shareRouteDropsInvalidCoordinatesAndBoundsLargeRoutes() {
    let start = Date(timeIntervalSince1970: 1_000)
    var route = (0..<1_500).map { index in
        WorkoutRoutePoint(
            date: start.addingTimeInterval(Double(index)),
            latitude: 25 + Double(index) * 0.000_01,
            longitude: -80 + Double(index) * 0.000_01
        )
    }
    route.append(WorkoutRoutePoint(date: start, latitude: .nan, longitude: -80))
    route.append(WorkoutRoutePoint(date: start, latitude: 91, longitude: -80))

    let normalized = RunShareModelBuilder.normalizedRoute(route)

    #expect(normalized.count <= 601)
    #expect(normalized.count >= 2)
    #expect(normalized.allSatisfy { (0...1).contains($0.x) && (0...1).contains($0.y) })
}

@Test func shareRouteAspectFitsWithoutStretchingPostCanvas() throws {
    let points = [
        RunShareRoutePoint(x: 0, y: 0.25),
        RunShareRoutePoint(x: 1, y: 0.75)
    ]

    let fitted = RunShareRouteLayout.fittedPoints(
        points,
        in: CGSize(width: 300, height: 100),
        inset: 10
    )
    let first = try #require(fitted.first)
    let last = try #require(fitted.last)

    #expect(abs((last.x - first.x) - 160) < 0.001)
    #expect(abs((last.y - first.y) - 80) < 0.001)
    #expect(abs(first.x - 70) < 0.001)
    #expect(abs(first.y - 10) < 0.001)
}

private func shareWorkout(distance: Double, duration: Double) -> CanonicalWorkout {
    let start = Date(timeIntervalSince1970: 1_721_000_000)
    let route = [
        WorkoutRoutePoint(date: start, latitude: 25.799, longitude: -80.199),
        WorkoutRoutePoint(date: start.addingTimeInterval(30), latitude: 25.801, longitude: -80.197),
        WorkoutRoutePoint(date: start.addingTimeInterval(60), latitude: 25.804, longitude: -80.200)
    ]
    let evidence = WorkoutEvidence(
        workoutID: "share-workout",
        route: route,
        weather: WorkoutWeather(temperatureCelsius: 27, humidityPercent: 70),
        cityName: "Miami"
    )
    return CanonicalWorkout(
        id: "share-workout",
        sourceID: "share-workout",
        sourceName: "HealthKit",
        startDate: start,
        endDate: start.addingTimeInterval(duration),
        environment: .outdoor,
        distanceMeters: distance,
        durationSeconds: duration,
        averageHeartRate: 154,
        routeAvailable: true,
        routePointCount: route.count,
        inferredRunType: .easy,
        evidence: evidence
    )
}

private func shareSplit(label: String, meters: Double, pace: Double) -> DerivedSplitEstimate {
    DerivedSplitEstimate(
        label: label,
        distanceMeters: meters,
        durationSecondsEstimate: pace * (meters / 1_000),
        paceSecondsPerKmEstimate: pace,
        confidence: .strong
    )
}

private func shareInterval(
    index: Int,
    stepType: DerivedIntervalLabel,
    measuredDistance: Double,
    activeDuration: Double
) -> ReconstructedWorkoutInterval {
    let start = Date(timeIntervalSince1970: 1_721_000_000 + Double(index) * 300)
    let target = PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 1_000 / 260,
        upperBound: 1_000 / 240,
        unit: "m/s",
        displayText: "4:00–4:20 /km"
    )
    return ReconstructedWorkoutInterval(
        index: index,
        label: "\(stepType.displayName) \(index)",
        stepType: stepType,
        plannedGoalType: .distance,
        plannedGoalValue: 800,
        plannedDistancePrescription: PlannedDistancePrescription(value: 800, unit: .meters),
        plannedGoalDisplayText: "800 m",
        plannedTargetDisplayText: "4:00–4:20 /km",
        plannedTargets: [target],
        actualStartDate: start,
        actualEndDate: start.addingTimeInterval(activeDuration),
        actualDurationSeconds: activeDuration,
        elapsedDurationSeconds: activeDuration,
        pauseOverlapSeconds: 0,
        activeDurationSeconds: activeDuration,
        durationDisplayRule: .activeTimer,
        actualDistanceMeters: measuredDistance,
        actualPaceSecondsPerKm: activeDuration / (measuredDistance / 1_000),
        averageHeartRateBpm: 166,
        maxHeartRateBpm: 174,
        averageCadence: 184,
        averagePower: 310,
        plannedDistanceMetricWindow: nil,
        planSource: .workoutKit,
        windowSource: .healthKitActivityBoundaries,
        boundaryStrategy: nil,
        boundaryAdjustmentSeconds: nil,
        boundaryOvershootMeters: nil,
        boundaryDiagnostics: nil,
        tailDiagnostics: nil,
        sourceNote: "test",
        confidence: .high
    )
}
