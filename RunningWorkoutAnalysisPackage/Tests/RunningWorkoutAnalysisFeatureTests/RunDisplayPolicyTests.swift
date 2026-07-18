import Foundation
import Testing
@testable import RunningWorkoutAnalysisFeature

private let kilometersOnly = RunDisplayPolicy(
    primaryUnit: .kilometers,
    showsSecondaryDistance: false
)

private let kilometersAndMiles = RunDisplayPolicy(
    primaryUnit: .kilometers,
    showsSecondaryDistance: true
)

private let milesOnly = RunDisplayPolicy(
    primaryUnit: .miles,
    showsSecondaryDistance: false
)

private let milesAndKilometers = RunDisplayPolicy(
    primaryUnit: .miles,
    showsSecondaryDistance: true
)

@Test func runningDistanceUnitsUseExactCanonicalConstants() {
    #expect(RunningDistanceUnit.metersPerMile == 1_609.344)
    #expect(RunningDistanceUnit.kilometers.metersPerUnit == 1_000)
    #expect(RunningDistanceUnit.miles.metersPerUnit == 1_609.344)
    #expect(kilometersOnly.normalSplitDistanceMeters == 1_000)
    #expect(milesOnly.normalSplitDistanceMeters == 1_609.344)
}

@Test func explicitDisplayPoliciesDoNotDependOnLocaleDefaults() {
    #expect(RunningDistanceUnit.initialDefault(locale: Locale(identifier: "en_US")) == .miles)
    #expect(RunningDistanceUnit.initialDefault(locale: Locale(identifier: "en_GB")) == .miles)
    #expect(RunningDistanceUnit.initialDefault(locale: Locale(identifier: "fr_FR")) == .kilometers)

    #expect(RunFormatters.distance(5_000, policy: kilometersOnly) == "5.00 km")
    #expect(RunFormatters.distance(5_000, policy: milesOnly) == "3.11 mi")
    #expect(RunFormatters.pace(422, policy: kilometersOnly) == "7:02/km")
    #expect(RunFormatters.pace(422, policy: milesOnly) == "11:19/mi")
}

@Test func displayPolicyCoversBothPrimaryUnitsAndSecondaryStates() {
    #expect(kilometersOnly.primaryUnit == .kilometers)
    #expect(kilometersOnly.secondaryUnit == nil)
    #expect(kilometersAndMiles.secondaryUnit == .miles)
    #expect(milesOnly.primaryUnit == .miles)
    #expect(milesOnly.secondaryUnit == nil)
    #expect(milesAndKilometers.secondaryUnit == .kilometers)

    #expect(RunFormatters.distance(7_030, policy: kilometersOnly, includeSecondary: true) == "7.03 km")
    #expect(RunFormatters.distance(7_030, policy: kilometersAndMiles, includeSecondary: false) == "7.03 km")
    #expect(RunFormatters.distance(7_030, policy: kilometersAndMiles, includeSecondary: true) == "7.03 km (4.37 mi)")
    #expect(RunFormatters.secondaryDistance(7_030, policy: kilometersOnly) == nil)
    #expect(RunFormatters.secondaryDistance(7_030, policy: kilometersAndMiles) == "4.37 mi")

    #expect(RunFormatters.distance(7_030, policy: milesOnly, includeSecondary: true) == "4.37 mi")
    #expect(RunFormatters.distance(7_030, policy: milesAndKilometers, includeSecondary: false) == "4.37 mi")
    #expect(RunFormatters.distance(7_030, policy: milesAndKilometers, includeSecondary: true) == "4.37 mi (7.03 km)")
    #expect(RunFormatters.secondaryDistance(7_030, policy: milesOnly) == nil)
    #expect(RunFormatters.secondaryDistance(7_030, policy: milesAndKilometers) == "7.03 km")
}

@Test func distanceFormattingCoversFiveKAndUnroundedSevenPointZeroThreeK() {
    #expect(RunFormatters.distance(5_000, policy: kilometersOnly) == "5.00 km")
    #expect(RunFormatters.distance(5_000, policy: milesOnly) == "3.11 mi")
    #expect(RunFormatters.distance(7_030.49, policy: kilometersOnly) == "7.03 km")
    #expect(RunFormatters.distance(7_030.49, policy: milesOnly) == "4.37 mi")
}

@Test func compactDistanceKeepsShortMetricIntervalsInMeters() {
    #expect(RunFormatters.compactDistance(400, policy: kilometersOnly) == "400 m")
    #expect(RunFormatters.compactDistance(400, policy: kilometersAndMiles, includeSecondary: true) == "400 m (0.25 mi)")
    #expect(RunFormatters.compactDistance(400, policy: milesOnly) == "0.25 mi")
    #expect(RunFormatters.compactDistance(400, policy: milesAndKilometers, includeSecondary: true) == "0.25 mi (400 m)")
}

@Test func paceConversionUsesCanonicalSecondsPerKilometer() {
    #expect(RunFormatters.pace(422, policy: kilometersOnly) == "7:02/km")
    #expect(RunFormatters.pace(422, policy: milesOnly) == "11:19/mi")
    #expect(abs(RunFormatters.paceSecondsPerUnit(422, policy: kilometersOnly) - 422) < 0.000_001)
    #expect(abs(RunFormatters.paceSecondsPerUnit(422, policy: milesOnly) - 679.143_168) < 0.000_001)
}

@Test func secondaryPaceAppearsOnlyWhenEnabledAndUsesTheOppositeDenominator() {
    #expect(RunFormatters.secondaryPace(422, policy: kilometersOnly) == nil)
    #expect(RunFormatters.secondaryPace(422, policy: kilometersAndMiles) == "11:19/mi")
    #expect(RunFormatters.secondaryPace(422, policy: milesOnly) == nil)
    #expect(RunFormatters.secondaryPace(422, policy: milesAndKilometers) == "7:02/km")
    #expect(RunFormatters.secondaryPace(nil, policy: kilometersAndMiles) == nil)
    #expect(RunFormatters.secondaryPace(.nan, policy: kilometersAndMiles) == nil)
}

@Test func paceAndDistanceConversionsDoNotRoundCanonicalInputFirst() {
    // Rounding 421.6 s/km before conversion would incorrectly display 11:19/mi.
    #expect(RunFormatters.pace(421.6, policy: milesOnly) == "11:18/mi")
    #expect(abs(RunFormatters.paceSecondsPerUnit(421.6, policy: milesOnly) - 678.499_430_4) < 0.000_001)

    let unroundedMeters = 7_030.49
    #expect(abs(RunFormatters.chartDistanceValue(unroundedMeters, policy: kilometersOnly) - 7.030_49) < 0.000_001)
    #expect(abs(RunFormatters.chartDistanceValue(unroundedMeters, policy: milesOnly) - (unroundedMeters / 1_609.344)) < 0.000_001)
}

@Test func paceDeltasUseTheSelectedPaceDenominator() {
    #expect(RunFormatters.paceDeltaSeconds(7, policy: kilometersOnly) == 7)
    #expect(RunFormatters.paceDeltaSeconds(-7, policy: kilometersOnly) == 7)
    #expect(RunFormatters.paceDeltaSeconds(7, policy: milesOnly) == 11)
    #expect(RunFormatters.paceDeltaSeconds(-7, policy: milesOnly) == 11)
}

@Test func chartDistanceScalarAndUnitAlwaysAgree() {
    #expect(abs(RunFormatters.chartDistanceValue(7_030, policy: kilometersOnly) - 7.03) < 0.000_001)
    #expect(RunFormatters.chartDistanceUnit(policy: kilometersOnly) == "km")

    #expect(abs(RunFormatters.chartDistanceValue(7_030, policy: milesOnly) - (7_030 / 1_609.344)) < 0.000_001)
    #expect(RunFormatters.chartDistanceUnit(policy: milesOnly) == "mi")
}

@Test func paceRejectsNilAndInvalidCanonicalValues() {
    #expect(RunFormatters.pace(nil, policy: kilometersOnly) == "Unavailable")
    #expect(RunFormatters.pace(0, policy: kilometersOnly) == "Unavailable")
    #expect(RunFormatters.pace(-1, policy: milesOnly) == "Unavailable")
    #expect(RunFormatters.pace(.nan, policy: milesOnly) == "Unavailable")
    #expect(RunFormatters.pace(.infinity, policy: milesOnly) == "Unavailable")
}

@Test func accessibilityDistanceMatchesVisiblePrimaryAndSecondaryUnits() {
    #expect(RunFormatters.accessibilityDistance(nil, policy: kilometersOnly) == "Distance unavailable")
    #expect(RunFormatters.accessibilityDistance(5_000, policy: kilometersOnly) == "5 kilometers")
    #expect(RunFormatters.accessibilityDistance(5_000, policy: kilometersOnly, includeSecondary: true) == "5 kilometers")
    #expect(RunFormatters.accessibilityDistance(5_000, policy: kilometersAndMiles, includeSecondary: true) == "5 kilometers, equivalent to 3.11 miles")
    #expect(RunFormatters.accessibilityDistance(5_000, policy: milesOnly) == "3.11 miles")
    #expect(RunFormatters.accessibilityDistance(5_000, policy: milesAndKilometers, includeSecondary: true) == "3.11 miles, equivalent to 5 kilometers")
}

@Test func accessibilityPaceMatchesVisiblePrimaryAndSecondaryUnits() {
    #expect(RunFormatters.accessibilityPace(nil, policy: kilometersOnly) == "Pace unavailable")
    #expect(RunFormatters.accessibilityPace(422, policy: kilometersOnly) == "7:02 per kilometer")
    #expect(
        RunFormatters.accessibilityPace(422, policy: kilometersAndMiles, includeSecondary: true)
            == "7:02 per kilometer, equivalent to 11:19 per mile"
    )
    #expect(RunFormatters.accessibilityPace(422, policy: milesOnly) == "11:19 per mile")
    #expect(
        RunFormatters.accessibilityPace(422, policy: milesAndKilometers, includeSecondary: true)
            == "11:19 per mile, equivalent to 7:02 per kilometer"
    )
}
