import Foundation

public enum RunTypeReviewImportError: LocalizedError, Sendable {
    case unsupportedFormat
    case invalidPayload

    public var errorDescription: String? {
        switch self {
        case .unsupportedFormat: "Use a JSON or CSV file exported from the web app."
        case .invalidPayload: "The reviewed run category file could not be parsed."
        }
    }
}

public enum RunTypeReviewImportService {
    public static func loadSavedReviews() -> [ReviewedRunTypeRecord] {
        guard let data = try? Data(contentsOf: savedReviewsURL()) else { return [] }
        return (try? JSONDecoder().decode([ReviewedRunTypeRecord].self, from: data)) ?? []
    }

    public static func saveReviews(_ reviews: [ReviewedRunTypeRecord]) {
        do {
            let url = savedReviewsURL()
            try FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
            let data = try JSONEncoder().encode(reviews)
            try data.write(to: url, options: [.atomic])
        } catch {
            return
        }
    }

    public static func importReviews(from url: URL) throws -> [ReviewedRunTypeRecord] {
        let didStartAccessing = url.startAccessingSecurityScopedResource()
        defer {
            if didStartAccessing {
                url.stopAccessingSecurityScopedResource()
            }
        }

        let data = try Data(contentsOf: url)
        let extensionName = url.pathExtension.lowercased()
        if extensionName == "csv" {
            return try parseCSV(String(decoding: data, as: UTF8.self))
        }
        return try parseJSON(data)
    }

    public static func parseJSON(_ data: Data) throws -> [ReviewedRunTypeRecord] {
        let decoder = JSONDecoder()
        if let direct = try? decoder.decode([ReviewedRunTypeRecord].self, from: data) {
            return direct
        }
        if let wrapped = try? decoder.decode(ReviewedRunTypePayload.self, from: data) {
            return wrapped.reviews ?? wrapped.runs ?? wrapped.workouts ?? []
        }
        throw RunTypeReviewImportError.invalidPayload
    }

    public static func parseCSV(_ text: String) throws -> [ReviewedRunTypeRecord] {
        let rows = text
            .split(whereSeparator: \.isNewline)
            .map { parseCSVLine(String($0)) }
            .filter { !$0.isEmpty }

        guard let header = rows.first else { return [] }
        let fields = header.map(normalizedHeader)
        let records = rows.dropFirst().compactMap { row -> ReviewedRunTypeRecord? in
            let values = Dictionary(uniqueKeysWithValues: zip(fields, row))
            guard let localDate = firstValue(values, ["localdate", "date"]),
                  let categoryRaw = firstValue(values, ["category", "runtype", "run_type"]),
                  let category = WebRunReviewCategory(rawValue: categoryRaw)
            else {
                return nil
            }

            let id = firstValue(values, ["id", "reviewid", "workoutid", "sourceworkoutid"])
                ?? "\(localDate)-\(category.rawValue)-\(recordsSeed(values))"
            let distanceMeters = firstDouble(values, ["distancemeters", "distance_meters"])
                ?? firstDouble(values, ["distancekm", "distance_km"]).map { $0 * 1_000 }
            return ReviewedRunTypeRecord(
                id: id,
                sourceWorkoutID: firstValue(values, ["sourceworkoutid", "source_workout_id", "fitid", "fit_id"]),
                localDate: localDate,
                localStartTime: firstValue(values, ["localstarttime", "starttime", "time"]),
                distanceMeters: distanceMeters,
                durationSeconds: firstDouble(values, ["durationseconds", "duration_seconds"]),
                category: category,
                notes: firstValue(values, ["notes"])
            )
        }

        if records.isEmpty && rows.count > 1 {
            throw RunTypeReviewImportError.invalidPayload
        }
        return records
    }

    private static func savedReviewsURL() -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        return base
            .appendingPathComponent("RunningWorkoutAnalysis", isDirectory: true)
            .appendingPathComponent("reviewed-run-types.json")
    }

    private static func parseCSVLine(_ line: String) -> [String] {
        var values: [String] = []
        var current = ""
        var inQuotes = false
        var iterator = line.makeIterator()

        while let character = iterator.next() {
            if character == "\"" {
                if inQuotes, let next = iterator.next() {
                    if next == "\"" {
                        current.append("\"")
                    } else {
                        inQuotes = false
                        if next == "," {
                            values.append(current.trimmingCharacters(in: .whitespacesAndNewlines))
                            current = ""
                        } else {
                            current.append(next)
                        }
                    }
                } else {
                    inQuotes.toggle()
                }
            } else if character == "," && !inQuotes {
                values.append(current.trimmingCharacters(in: .whitespacesAndNewlines))
                current = ""
            } else {
                current.append(character)
            }
        }

        values.append(current.trimmingCharacters(in: .whitespacesAndNewlines))
        return values
    }

    private static func normalizedHeader(_ value: String) -> String {
        value
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
    }

    private static func firstValue(_ values: [String: String], _ keys: [String]) -> String? {
        keys.compactMap { values[$0] }.first { !$0.isEmpty }
    }

    private static func firstDouble(_ values: [String: String], _ keys: [String]) -> Double? {
        firstValue(values, keys).flatMap(Double.init)
    }

    private static func recordsSeed(_ values: [String: String]) -> String {
        [values["localstarttime"], values["starttime"], values["distancemeters"], values["durationseconds"]]
            .compactMap { $0 }
            .joined(separator: "-")
    }
}

private struct ReviewedRunTypePayload: Decodable {
    var reviews: [ReviewedRunTypeRecord]?
    var runs: [ReviewedRunTypeRecord]?
    var workouts: [ReviewedRunTypeRecord]?
}
