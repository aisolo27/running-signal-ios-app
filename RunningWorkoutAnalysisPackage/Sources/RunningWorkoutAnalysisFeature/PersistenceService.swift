import Foundation
import SwiftData

@MainActor
public enum PersistenceService {
    public static func fetchWorkouts(context: ModelContext) -> [CanonicalWorkout] {
        let descriptor = FetchDescriptor<PersistedWorkout>(
            sortBy: [SortDescriptor(\.startDate, order: .reverse)]
        )
        do {
            return try context.fetch(descriptor).map(\.canonical)
        } catch {
            return []
        }
    }

    public static func upsert(_ workouts: [CanonicalWorkout], context: ModelContext) {
        let existing = fetchPersisted(context: context)
        var byID = Dictionary(uniqueKeysWithValues: existing.map { ($0.id, $0) })

        for workout in workouts {
            if let record = byID[workout.id] {
                record.update(from: workout, preservingManualFields: true)
            } else {
                let record = PersistedWorkout(workout: workout)
                context.insert(record)
                byID[workout.id] = record
            }
        }

        try? context.save()
    }

    public static func deleteWorkouts(ids: Set<String>, context: ModelContext) {
        guard !ids.isEmpty else { return }
        for record in fetchPersisted(context: context) where ids.contains(record.id) {
            context.delete(record)
        }
        try? context.save()
    }

    public static func updateManualFields(id: String, runType: RunType?, notes: String, context: ModelContext) {
        guard let record = fetchPersisted(context: context).first(where: { $0.id == id }) else { return }
        record.manualRunTypeRaw = runType?.rawValue
        record.notes = notes
        record.updatedAt = Date()
        try? context.save()
    }

    private static func fetchPersisted(context: ModelContext) -> [PersistedWorkout] {
        do {
            return try context.fetch(FetchDescriptor<PersistedWorkout>())
        } catch {
            return []
        }
    }
}
