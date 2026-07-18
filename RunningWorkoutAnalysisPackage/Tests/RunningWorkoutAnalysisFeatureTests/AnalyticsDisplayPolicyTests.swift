import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func analyticsMetricUnitsFollowPrimaryDisplayPolicy() {
    #expect(WorkoutChartMetric.pace.unit(policy: .kilometersOnly) == "/km")
    #expect(WorkoutChartMetric.pace.unit(policy: .milesOnly) == "/mi")
    #expect(IntervalAnalysisMetric.distance.unit(policy: .kilometersOnly) == "km")
    #expect(IntervalAnalysisMetric.distance.unit(policy: .milesOnly) == "mi")
}

@Test func intervalDistanceChartConvertsScalarWithoutChangingCanonicalValue() {
    let canonicalMeters = RunningDistanceUnit.metersPerMile

    let miles = IntervalAnalysisMetric.distance.presentationChartValue(
        canonicalMeters,
        policy: .milesOnly
    )
    let kilometers = IntervalAnalysisMetric.distance.presentationChartValue(
        canonicalMeters,
        policy: .kilometersOnly
    )

    #expect(abs(miles - 1) < 0.000_001)
    #expect(abs(kilometers - 1.609_344) < 0.000_001)
    #expect(canonicalMeters == RunningDistanceUnit.metersPerMile)
}

@Test func intervalPaceChartGeometryStaysCanonicalAcrossPolicies() {
    let canonicalSpeedLikeValue = 3_600.0 / 300.0

    #expect(
        IntervalAnalysisMetric.pace.presentationChartValue(
            canonicalSpeedLikeValue,
            policy: .kilometersOnly
        ) == canonicalSpeedLikeValue
    )
    #expect(
        IntervalAnalysisMetric.pace.presentationChartValue(
            canonicalSpeedLikeValue,
            policy: .milesOnly
        ) == canonicalSpeedLikeValue
    )
}
