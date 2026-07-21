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

public enum RunSignalPersistenceSchemaV2: VersionedSchema {
    public static let versionIdentifier = Schema.Version(2, 0, 0)

    public static var models: [any PersistentModel.Type] {
        [
            PersistedWorkout.self,
            PersistedWorkoutEvidence.self,
            PersistedEvidenceEnrichmentState.self,
            PersistedEvidenceRefreshJob.self,
            PersistedEvidenceRefreshJobItem.self,
            PersistedHealthKitImportJob.self,
            PersistedDerivedWorkoutAnalysis.self,
            PersistedTrainingPeriodSummary.self,
            PersistedWorkoutEffortScore.self
        ]
    }
}

public enum RunSignalPersistenceMigrationPlan: SchemaMigrationPlan {
    public static var schemas: [any VersionedSchema.Type] {
        [RunSignalPersistenceSchemaV1.self, RunSignalPersistenceSchemaV2.self]
    }

    public static var stages: [MigrationStage] {
        [
            .lightweight(
                fromVersion: RunSignalPersistenceSchemaV1.self,
                toVersion: RunSignalPersistenceSchemaV2.self
            )
        ]
    }
}

public enum RunSignalPersistenceContainer {
    public static func make(
        configurations: [ModelConfiguration]? = nil
    ) throws -> ModelContainer {
        let schema = Schema(versionedSchema: RunSignalPersistenceSchemaV2.self)
        let resolvedConfigurations = configurations ?? [ModelConfiguration(schema: schema)]
        return try ModelContainer(
            for: schema,
            migrationPlan: RunSignalPersistenceMigrationPlan.self,
            configurations: resolvedConfigurations
        )
    }
}
