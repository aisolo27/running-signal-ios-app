import Testing
@testable import RunningWorkoutAnalysisFeature

@Test func runTypePresentationUsesStableSemanticAccents() {
    #expect(RunType.easy.runSignalAccent == .green)
    #expect(RunType.recovery.runSignalAccent == .green)
    #expect(RunType.longRun.runSignalAccent == .orange)
    #expect(RunType.interval.runSignalAccent == .cyan)
    #expect(RunType.tempo.runSignalAccent == .purple)
    #expect(RunType.threshold.runSignalAccent == .purple)
    #expect(RunType.race.runSignalAccent == .pink)
    #expect(RunType.progression.runSignalAccent == .gray)
    #expect(RunType.hills.runSignalAccent == .gray)
    #expect(RunType.unknown.runSignalAccent == .gray)
}

@Test func weeklyRunCategoryPresentationMatchesRunTypeTaxonomy() {
    #expect(WeeklyRunCategory.easy.runSignalAccent == .green)
    #expect(WeeklyRunCategory.warmupCooldown.runSignalAccent == .green)
    #expect(WeeklyRunCategory.longRun.runSignalAccent == .orange)
    #expect(WeeklyRunCategory.interval.runSignalAccent == .cyan)
    #expect(WeeklyRunCategory.threshold.runSignalAccent == .purple)
    #expect(WeeklyRunCategory.race.runSignalAccent == .pink)
    #expect(WeeklyRunCategory.other.runSignalAccent == .gray)
}
