import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func legacyEvidenceEventAndRouteJSONRemainDecodable() throws {
    let eventData = Data(#"{"startDate":0,"endDate":0,"type":"HKWorkoutEventType(rawValue: 1)"}"#.utf8)
    let event = try JSONDecoder().decode(WorkoutEvidenceEvent.self, from: eventData)
    #expect(event.kind == nil)
    #expect(event.displayLabel == "Pause")

    let routeData = Data(#"{"date":0,"latitude":25.7,"longitude":-80.2,"altitudeMeters":4}"#.utf8)
    let point = try JSONDecoder().decode(WorkoutRoutePoint.self, from: routeData)
    #expect(point.horizontalAccuracyMeters == nil)
    #expect(point.verticalAccuracyMeters == nil)
}

@Test func typedEventKindTakesPriorityOverLegacyDescription() {
    let date = Date(timeIntervalSinceReferenceDate: 1_000)
    let event = WorkoutEvidenceEvent(
        startDate: date,
        endDate: date,
        type: "unreliable-description",
        kind: .motionPaused
    )

    #expect(event.displayLabel == "Motion paused")
}

@Test func elevationGainFiltersInaccuratePointsAndIsolatedSpikes() {
    let start = Date(timeIntervalSinceReferenceDate: 2_000)
    let altitudes = [0.0, 1, 2, 100, 3, 4]
    let route = altitudes.enumerated().map { index, altitude in
        WorkoutRoutePoint(
            date: start.addingTimeInterval(Double(index)),
            latitude: 25.7,
            longitude: -80.2,
            altitudeMeters: altitude,
            horizontalAccuracyMeters: 5,
            verticalAccuracyMeters: index == 3 ? 80 : 5
        )
    }
    let evidence = WorkoutEvidence(workoutID: "route", route: route)

    #expect(evidence.elevationGainMeters == 3)
}

@Test func typedTargetsSurviveReconstructedIntervalCoding() throws {
    let start = Date(timeIntervalSinceReferenceDate: 3_000)
    let target = PlannedWorkoutTarget(
        kind: .pace,
        lowerBound: 240,
        upperBound: 250,
        unit: "s/km",
        displayText: "4:00-4:10 /km"
    )
    let interval = ReconstructedWorkoutInterval(
        index: 1,
        label: "Work 1",
        stepType: .work,
        plannedGoalType: .distance,
        plannedGoalValue: 400,
        plannedGoalDisplayText: "400 m",
        plannedTargetDisplayText: target.displayText,
        plannedTargets: [target],
        actualStartDate: start,
        actualEndDate: start.addingTimeInterval(100),
        actualDurationSeconds: 100,
        planSource: .workoutKit,
        windowSource: .healthKitActivityBoundaries,
        sourceNote: "test",
        confidence: .high
    )

    let decoded = try JSONDecoder().decode(
        ReconstructedWorkoutInterval.self,
        from: JSONEncoder().encode(interval)
    )
    #expect(decoded.plannedTargets == [target])
}
