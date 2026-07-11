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

    static func distance(_ meters: Double?) -> String {
        guard let meters else { return "Unavailable" }
        return String(format: "%.2f km", meters / 1_000)
    }

    static func compactDistance(_ meters: Double?) -> String {
        guard let meters else { return "Unavailable" }
        if meters < 1_000 {
            return "\(Int(meters.rounded())) m"
        }
        return String(format: "%.2f km", meters / 1_000)
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

    static func pace(_ secondsPerKm: Double?) -> String {
        guard let secondsPerKm, secondsPerKm.isFinite, secondsPerKm > 0 else { return "Unavailable" }
        let rounded = Int(secondsPerKm.rounded())
        return String(format: "%d:%02d /km", rounded / 60, rounded % 60)
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
}
