import Foundation
import SwiftUI

public enum RunningDistanceUnit: String, CaseIterable, Codable, Identifiable, Sendable {
    case kilometers
    case miles

    static let metersPerMile = 1_609.344

    public var id: String { rawValue }

    var label: String {
        switch self {
        case .kilometers: "Kilometers"
        case .miles: "Miles"
        }
    }

    var abbreviation: String {
        switch self {
        case .kilometers: "km"
        case .miles: "mi"
        }
    }

    var paceSuffix: String { "/\(abbreviation)" }

    var metersPerUnit: Double {
        switch self {
        case .kilometers: 1_000
        case .miles: Self.metersPerMile
        }
    }

    var normalSplitTitle: String {
        switch self {
        case .kilometers: "1 km Splits"
        case .miles: "1 mi Splits"
        }
    }

    var normalSplitRowPrefix: String {
        switch self {
        case .kilometers: "KM"
        case .miles: "Mile"
        }
    }

    static func initialDefault(locale: Locale = .current) -> RunningDistanceUnit {
        switch locale.measurementSystem {
        case .us, .uk:
            .miles
        default:
            .kilometers
        }
    }
}

public struct RunDisplayPolicy: Equatable, Sendable {
    public var primaryUnit: RunningDistanceUnit
    public var showsSecondaryDistance: Bool

    public init(primaryUnit: RunningDistanceUnit, showsSecondaryDistance: Bool) {
        self.primaryUnit = primaryUnit
        self.showsSecondaryDistance = showsSecondaryDistance
    }

    public static let kilometersOnly = RunDisplayPolicy(primaryUnit: .kilometers, showsSecondaryDistance: false)
    public static let milesOnly = RunDisplayPolicy(primaryUnit: .miles, showsSecondaryDistance: false)

    public var secondaryUnit: RunningDistanceUnit? {
        guard showsSecondaryDistance else { return nil }
        return primaryUnit == .kilometers ? .miles : .kilometers
    }

    public var normalSplitDistanceMeters: Double { primaryUnit.metersPerUnit }
}

private struct RunDisplayPolicyEnvironmentKey: EnvironmentKey {
    static let defaultValue = RunDisplayPolicy.kilometersOnly
}

extension EnvironmentValues {
    var runDisplayPolicy: RunDisplayPolicy {
        get { self[RunDisplayPolicyEnvironmentKey.self] }
        set { self[RunDisplayPolicyEnvironmentKey.self] = newValue }
    }
}
