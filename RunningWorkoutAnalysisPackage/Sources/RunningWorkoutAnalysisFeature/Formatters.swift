import Foundation

enum TemperatureUnitPreference: String, CaseIterable, Identifiable {
    case system
    case fahrenheit
    case celsius

    var id: String { rawValue }

    var label: String {
        switch self {
        case .system: "System Default"
        case .fahrenheit: "Fahrenheit"
        case .celsius: "Celsius"
        }
    }
}

enum RunFormatters {
    static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()

    static let shortDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter
    }()

    static let mediumDateWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()

    static let weekdayDateWithYear: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d, yyyy"
        return formatter
    }()

    static let workoutNavigationDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, MMM d"
        return formatter
    }()

    static let workoutFullDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }()

    static let workoutTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        return formatter
    }()

    static func distance(
        _ meters: Double?,
        policy: RunDisplayPolicy = .kilometersOnly,
        includeSecondary: Bool = false
    ) -> String {
        guard let meters else { return "Unavailable" }
        let primary = distance(meters, unit: policy.primaryUnit, compact: false)
        guard includeSecondary, let secondaryUnit = policy.secondaryUnit else { return primary }
        return "\(primary) (\(distance(meters, unit: secondaryUnit, compact: false)))"
    }

    static func compactDistance(
        _ meters: Double?,
        policy: RunDisplayPolicy = .kilometersOnly,
        includeSecondary: Bool = false
    ) -> String {
        guard let meters else { return "Unavailable" }
        let primary = distance(meters, unit: policy.primaryUnit, compact: true)
        guard includeSecondary, let secondaryUnit = policy.secondaryUnit else { return primary }
        return "\(primary) (\(distance(meters, unit: secondaryUnit, compact: true)))"
    }

    static func secondaryDistance(_ meters: Double?, policy: RunDisplayPolicy) -> String? {
        guard let meters, let secondaryUnit = policy.secondaryUnit else { return nil }
        return distance(meters, unit: secondaryUnit, compact: false)
    }

    static func secondaryPace(_ secondsPerKm: Double?, policy: RunDisplayPolicy) -> String? {
        guard let secondsPerKm,
              secondsPerKm.isFinite,
              secondsPerKm > 0,
              let secondaryUnit = policy.secondaryUnit else { return nil }
        return pace(
            secondsPerKm,
            policy: RunDisplayPolicy(primaryUnit: secondaryUnit, showsSecondaryDistance: false)
        )
    }

    static func duration(_ seconds: Double?) -> String {
        guard let seconds else { return "Unavailable" }
        let total = Int(seconds.rounded())
        let hours = total / 3_600
        let minutes = (total % 3_600) / 60
        let secs = total % 60
        if hours > 0 {
            return String(format: "%d:%02d:%02d", hours, minutes, secs)
        }
        return String(format: "%d:%02d", minutes, secs)
    }

    static func pace(
        _ secondsPerKm: Double?,
        policy: RunDisplayPolicy = .kilometersOnly
    ) -> String {
        guard let secondsPerKm, secondsPerKm.isFinite, secondsPerKm > 0 else { return "Unavailable" }
        let secondsPerUnit = paceSecondsPerUnit(secondsPerKm, policy: policy)
        let rounded = Int(secondsPerUnit.rounded())
        return String(format: "%d:%02d%@", rounded / 60, rounded % 60, policy.primaryUnit.paceSuffix)
    }

    static func paceSecondsPerUnit(_ secondsPerKm: Double, policy: RunDisplayPolicy) -> Double {
        secondsPerKm * (policy.primaryUnit.metersPerUnit / 1_000)
    }

    static func paceDeltaSeconds(_ secondsPerKm: Double, policy: RunDisplayPolicy) -> Int {
        Int(abs(paceSecondsPerUnit(secondsPerKm, policy: policy)).rounded())
    }

    static func chartDistanceValue(_ meters: Double, policy: RunDisplayPolicy) -> Double {
        meters / policy.primaryUnit.metersPerUnit
    }

    static func chartDistanceUnit(policy: RunDisplayPolicy) -> String {
        policy.primaryUnit.abbreviation
    }

    static func accessibilityDistance(
        _ meters: Double?,
        policy: RunDisplayPolicy,
        includeSecondary: Bool = false
    ) -> String {
        guard let meters else { return "Distance unavailable" }
        let primaryValue = meters / policy.primaryUnit.metersPerUnit
        let primary = "\(decimal(primaryValue, minimumFractionDigits: 0, maximumFractionDigits: 2)) \(policy.primaryUnit.label.lowercased())"
        guard includeSecondary, let secondaryUnit = policy.secondaryUnit else { return primary }
        let secondaryValue = meters / secondaryUnit.metersPerUnit
        return "\(primary), equivalent to \(decimal(secondaryValue, minimumFractionDigits: 0, maximumFractionDigits: 2)) \(secondaryUnit.label.lowercased())"
    }

    static func accessibilityPace(
        _ secondsPerKm: Double?,
        policy: RunDisplayPolicy,
        includeSecondary: Bool = false
    ) -> String {
        guard let secondsPerKm, secondsPerKm.isFinite, secondsPerKm > 0 else {
            return "Pace unavailable"
        }
        let primary = accessibilityPace(secondsPerKm, unit: policy.primaryUnit)
        guard includeSecondary, let secondaryUnit = policy.secondaryUnit else { return primary }
        return "\(primary), equivalent to \(accessibilityPace(secondsPerKm, unit: secondaryUnit))"
    }

    static func number(_ value: Double?, suffix: String = "", decimals: Int = 0) -> String {
        guard let value else { return "Unavailable" }
        return String(format: "%.\(decimals)f%@", value, suffix)
    }

    static func calories(_ value: Double?) -> String {
        guard let value else { return "Unavailable" }
        return "\(integer(value)) kcal"
    }

    static func percent(_ value: Double) -> String {
        String(format: "%.0f%%", value * 100)
    }

    static func humidity(_ percent: Double?) -> String {
        guard let percent else { return "Unavailable" }
        return String(format: "%.0f%%", percent)
    }

    static func temperature(_ celsius: Double?, preference: TemperatureUnitPreference) -> String {
        guard let celsius else { return "Unavailable" }
        let usesFahrenheit: Bool
        switch preference {
        case .fahrenheit:
            usesFahrenheit = true
        case .celsius:
            usesFahrenheit = false
        case .system:
            usesFahrenheit = Locale.current.measurementSystem == .us
        }
        if usesFahrenheit {
            return String(format: "%.0f°F", celsius * 9 / 5 + 32)
        }
        return String(format: "%.0f°C", celsius)
    }

    private static func integer(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        formatter.minimumFractionDigits = 0
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.0f", value)
    }

    private static func distance(_ meters: Double, unit: RunningDistanceUnit, compact: Bool) -> String {
        if compact, unit == .kilometers, meters < 1_000 {
            return "\(integer(meters.rounded())) m"
        }
        let value = meters / unit.metersPerUnit
        return "\(decimal(value, minimumFractionDigits: compact ? 0 : 2, maximumFractionDigits: 2)) \(unit.abbreviation)"
    }

    private static func accessibilityPace(_ secondsPerKm: Double, unit: RunningDistanceUnit) -> String {
        let secondsPerUnit = secondsPerKm * (unit.metersPerUnit / 1_000)
        let rounded = Int(secondsPerUnit.rounded())
        let unitName = unit == .miles ? "mile" : "kilometer"
        return String(format: "%d:%02d per %@", rounded / 60, rounded % 60, unitName)
    }

    private static func decimal(
        _ value: Double,
        minimumFractionDigits: Int,
        maximumFractionDigits: Int
    ) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = minimumFractionDigits
        formatter.maximumFractionDigits = maximumFractionDigits
        return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.*f", maximumFractionDigits, value)
    }
}
