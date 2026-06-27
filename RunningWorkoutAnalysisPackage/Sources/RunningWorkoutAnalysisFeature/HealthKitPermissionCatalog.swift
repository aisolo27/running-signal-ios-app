import Foundation
@preconcurrency import HealthKit

public enum HealthKitPermissionScope: String, Codable, Sendable {
    case coreRunning
    case calories
    case recovery
    case profile
    case trainingLoad
}

public struct HealthKitPermissionItem: Identifiable, Equatable, Sendable {
    public var id: String { healthKitIdentifier }
    public var displayName: String
    public var healthKitIdentifier: String
    public var scope: HealthKitPermissionScope
    public var reason: String
    public var isWorkoutScoped: Bool
    public var isBroadContext: Bool

    public init(
        displayName: String,
        healthKitIdentifier: String,
        scope: HealthKitPermissionScope,
        reason: String,
        isWorkoutScoped: Bool,
        isBroadContext: Bool
    ) {
        self.displayName = displayName
        self.healthKitIdentifier = healthKitIdentifier
        self.scope = scope
        self.reason = reason
        self.isWorkoutScoped = isWorkoutScoped
        self.isBroadContext = isBroadContext
    }
}

public enum HealthKitPermissionCatalog {
    public static let permissionExplanation = "RunSignal reads completed running workouts from HealthKit, including workout summaries, routes, heart rate, VO2 Max, resting heart rate, pace, power, cadence, running mechanics, and workout calories. Health data is used only for this read-only workout viewer and is not used for advertising or sold."

    public static let readItems: [HealthKitPermissionItem] = [
        item("Workouts", "HKWorkoutTypeIdentifier", .coreRunning, "Find completed running workouts and preserve workout identity, source, duration, distance, and events.", workout: true),
        item("Workout routes", "HKSeriesTypeIdentifierWorkoutRoute", .coreRunning, "Check route availability, GPS points, elevation, and outdoor workout evidence.", workout: true),
        item("Walking + Running Distance", "HKQuantityTypeIdentifierDistanceWalkingRunning", .coreRunning, "Validate workout distance, derive splits, and compare summary distance to associated samples.", workout: true),
        item("Step Count", "HKQuantityTypeIdentifierStepCount", .coreRunning, "Estimate cadence in full steps per minute when running cadence samples are unavailable.", workout: true),
        item("Heart Rate", "HKQuantityTypeIdentifierHeartRate", .coreRunning, "Calculate workout average/max heart rate, drift, and future time-in-zone analysis.", workout: true),
        item("VO2 Max", "HKQuantityTypeIdentifierVO2Max", .recovery, "Show optional whole-run fitness context when Apple Health has a recent value.", context: true),
        item("Resting Heart Rate", "HKQuantityTypeIdentifierRestingHeartRate", .recovery, "Show optional whole-run recovery context when Apple Health has a recent value.", context: true),
        item("Active Energy", "HKQuantityTypeIdentifierActiveEnergyBurned", .calories, "Show active calories separately and compare workout summary calories to associated samples.", workout: true),
        item("Basal Energy", "HKQuantityTypeIdentifierBasalEnergyBurned", .calories, "Support total-calorie comparisons when HealthKit provides enough evidence; never invent missing total calories.", context: true),
        item("Running Speed", "HKQuantityTypeIdentifierRunningSpeed", .coreRunning, "Support pacing-shape, split, and best-effort validation when available.", workout: true),
        item("Running Power", "HKQuantityTypeIdentifierRunningPower", .coreRunning, "Analyze power trends and interval execution when Apple Watch records power.", workout: true),
        item("Running Stride Length", "HKQuantityTypeIdentifierRunningStrideLength", .coreRunning, "Show running mechanics only when HealthKit records stride evidence.", workout: true),
        item("Ground Contact Time", "HKQuantityTypeIdentifierRunningGroundContactTime", .coreRunning, "Show form/mechanics only when HealthKit records ground contact evidence.", workout: true),
        item("Vertical Oscillation", "HKQuantityTypeIdentifierRunningVerticalOscillation", .coreRunning, "Show form/mechanics only when HealthKit records vertical oscillation evidence.", workout: true)
    ]

    public static let intentionallySkipped: [String] = [
        "Water",
        "Protein",
        "Carbohydrates",
        "Dietary Energy",
        "Blood Glucose",
        "Insulin",
        "Menstruation",
        "Underwater Depth",
        "Swimming metrics",
        "Cycling metrics",
        "Rowing metrics",
        "Wheelchair metrics",
        "Unrelated mobility metrics",
        "Heart Rate Variability",
        "Sleep Analysis",
        "Profile characteristics",
        "Body composition",
        "Exercise minutes"
    ]

    public static var readTypes: Set<HKObjectType> {
        var types: Set<HKObjectType> = []
        for item in readItems {
            if item.healthKitIdentifier == "HKWorkoutTypeIdentifier" {
                types.insert(HKObjectType.workoutType())
            } else if item.healthKitIdentifier == "HKSeriesTypeIdentifierWorkoutRoute" {
                types.insert(HKSeriesType.workoutRoute())
            } else if item.healthKitIdentifier.hasPrefix("HKQuantityTypeIdentifier") {
                if let type = HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier(rawValue: item.healthKitIdentifier)) {
                    types.insert(type)
                }
            } else if item.healthKitIdentifier.hasPrefix("HKCategoryTypeIdentifier") {
                if let type = HKObjectType.categoryType(forIdentifier: HKCategoryTypeIdentifier(rawValue: item.healthKitIdentifier)) {
                    types.insert(type)
                }
            } else if item.healthKitIdentifier.hasPrefix("HKCharacteristicTypeIdentifier") {
                if let type = HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier(rawValue: item.healthKitIdentifier)) {
                    types.insert(type)
                }
            }
        }
        return types
    }

    public static func markdown() -> String {
        let requested = readItems.map { item in
            "- \(item.displayName) (`\(item.healthKitIdentifier)`): \(item.reason)"
        }.joined(separator: "\n")
        let skipped = intentionallySkipped.map { "- \($0)" }.joined(separator: "\n")

        return """
        # RunSignal HealthKit Permission Review

        RunSignal requests read-only HealthKit access. It requests no write permissions in this milestone.

        ## Permission Explanation
        \(permissionExplanation)

        ## Requested Read Types
        \(requested)

        ## Not Requested
        \(skipped)

        ## HR Zones
        Apple's manual heart-rate zone configuration is not assumed to be readable by this app. RunSignal will label zone source as Apple Health, RunSignal manual, RunSignal estimated, or unavailable only after SDK support is verified.
        """
    }

    private static func item(
        _ displayName: String,
        _ identifier: String,
        _ scope: HealthKitPermissionScope,
        _ reason: String,
        workout: Bool = false,
        context: Bool = false
    ) -> HealthKitPermissionItem {
        HealthKitPermissionItem(
            displayName: displayName,
            healthKitIdentifier: identifier,
            scope: scope,
            reason: reason,
            isWorkoutScoped: workout,
            isBroadContext: context
        )
    }
}
