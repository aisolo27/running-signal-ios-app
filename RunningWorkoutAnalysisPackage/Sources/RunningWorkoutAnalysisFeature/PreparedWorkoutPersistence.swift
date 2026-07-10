import Foundation

public struct PreparedWorkoutPersistence: Sendable {
    public var evidenceData: Data
    public var analysis: DerivedWorkoutAnalysis
    public var analysisData: Data

    nonisolated public static func make(workout: CanonicalWorkout, evidence: WorkoutEvidence) -> PreparedWorkoutPersistence {
        let analysis = DerivedAnalyticsEngine.analyze(workout: workout, evidence: evidence)
        return PreparedWorkoutPersistence(
            evidenceData: (try? JSONEncoder().encode(evidence)) ?? Data(),
            analysis: analysis,
            analysisData: (try? JSONEncoder().encode(analysis)) ?? Data()
        )
    }
}
