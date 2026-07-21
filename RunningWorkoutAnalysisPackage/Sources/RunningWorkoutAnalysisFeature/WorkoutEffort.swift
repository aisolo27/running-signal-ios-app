import Foundation

public enum WorkoutEffortScore {
    public static let validRange = 1.0...10.0

    public static func normalized(_ value: Double?) -> Double? {
        guard let value, value.isFinite, validRange.contains(value) else { return nil }
        return value
    }
}

public struct WorkoutEffortPresentation: Equatable, Sendable {
    public let value: String
    public let detail: String
    public let accessibilityValue: String

    public static func make(score: Double?) -> WorkoutEffortPresentation? {
        guard let score = WorkoutEffortScore.normalized(score) else { return nil }
        let number = score.rounded() == score
            ? String(Int(score))
            : score.formatted(.number.precision(.fractionLength(1)))
        return WorkoutEffortPresentation(
            value: "\(number)/10",
            detail: "Apple Health rating",
            accessibilityValue: "Effort \(number) out of 10, rated in Apple Health"
        )
    }
}
