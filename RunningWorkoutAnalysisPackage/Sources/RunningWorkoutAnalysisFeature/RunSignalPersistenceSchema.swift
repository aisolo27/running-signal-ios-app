import SwiftData

public enum RunSignalPersistenceSchemaV1: VersionedSchema {
    public static let versionIdentifier = Schema.Version(1, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [
            PersistedWorkout.self,
            PersistedWorkoutEvidence.self,
            PersistedEvidenceEnrichmentState.self,
            PersistedEvidenceRefreshJob.self,
            PersistedEvidenceRefreshJobItem.self,
            PersistedHealthKitImportJob.self,
            PersistedDerivedWorkoutAnalysis.self,
            PersistedTrainingPeriodSummary.self
        ]
    }
}

public enum RunSignalPersistenceMigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [RunSignalPersistenceSchemaV1.self]
    }

    public static var stages: [MigrationStage] {
        []
    }
}

public enum RunSignalPersistenceContainer {
    public static func make(
        configurations: [ModelConfiguration]? = nil
    ) throws -> ModelContainer {
        let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV1.self)
        let resolvedConfigurations = configurations ?? [ModelConfiguration(schema: schema)]
        return try ModelContainer(
            for: schema,
            migrationPlan: RunSignalPersistenceMigrationPlan.self,
            configurations: resolvedConfigurations
        )
    }
}
