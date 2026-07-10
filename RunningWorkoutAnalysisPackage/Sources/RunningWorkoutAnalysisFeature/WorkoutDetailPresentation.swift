import Foundation

public struct WorkoutDetailPresentation: Equatable, Sendable {
    public var segments: RunWorkoutSegments
    public var supportedIntervals: WorkoutIntervalReconstructionResult?
    public var intervalUnavailableMessage: String?

    public static func make(
        workout: CanonicalWorkout,
        analysis: DerivedWorkoutAnalysis?
    ) -> WorkoutDetailPresentation {
        let segments = RunWorkoutSegments(workout: workout, analysis: analysis)
        guard let evidence = workout.evidence else {
            return WorkoutDetailPresentation(
                segments: segments,
                supportedIntervals: nil,
                intervalUnavailableMessage: nil
            )
        }
        let supported = CustomWorkoutNormalDetailGate.supportedIntervals(
            workout: workout,
            evidence: evidence
        )
        let hasPlan = evidence.workoutPlanAudit?.status == .available
            && evidence.workoutPlanAudit?.plannedSteps.isEmpty == false
        return WorkoutDetailPresentation(
            segments: segments,
            supportedIntervals: supported,
            intervalUnavailableMessage: hasPlan && supported == nil
                ? "Apple Health did not provide a complete, trustworthy interval boundary set for this workout."
                : nil
        )
    }
}
