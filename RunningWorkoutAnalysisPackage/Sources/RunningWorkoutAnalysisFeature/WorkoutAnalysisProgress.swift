import Foundation

public enum WorkoutAnalysisStage: String, Equatable, Sendable {
    case queued
    case readingHealthKit
    case processing
    case ready
    case paused
    case failed
}

public struct WorkoutAnalysisProgress: Equatable, Sendable {
    public var stage: WorkoutAnalysisStage
    public var message: String

    public init(stage: WorkoutAnalysisStage, message: String) {
        self.stage = stage
        self.message = message
    }

    public var isActive: Bool {
        stage == .queued || stage == .readingHealthKit || stage == .processing
    }
}
