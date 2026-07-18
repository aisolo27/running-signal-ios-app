import Foundation

public struct WorkoutRouteAchievement: Identifiable, Equatable, Sendable {
    public var id: String
    public var bucket: PersonalBestEffortBucket
    public var lifetimeRank: Int
    public var durationSeconds: Double
    public var route: [WorkoutRoutePoint]
    public var marker: WorkoutRoutePoint

    public init(
        bucket: PersonalBestEffortBucket,
        lifetimeRank: Int,
        durationSeconds: Double,
        route: [WorkoutRoutePoint],
        marker: WorkoutRoutePoint
    ) {
        self.id = "\(bucket.rawValue)-\(lifetimeRank)"
        self.bucket = bucket
        self.lifetimeRank = lifetimeRank
        self.durationSeconds = durationSeconds
        self.route = route
        self.marker = marker
    }

    public var title: String {
        let placement = switch lifetimeRank {
        case 1: "Fastest"
        case 2: "2nd fastest"
        case 3: "3rd fastest"
        default: "Ranked"
        }
        return "\(placement) \(bucket.label) · Lifetime"
    }
}

public enum WorkoutRouteAchievementMapper {
    static let maximumBoundaryInterpolationGap: TimeInterval = 60

    public static func make(
        route: [WorkoutRoutePoint],
        rankedRecords: [PersonalBestEffortRankedRecord],
        workoutID: String
    ) -> [WorkoutRouteAchievement] {
        let preparedRoute = preparedRoute(route)
        guard preparedRoute.count >= 2 else { return [] }

        return rankedRecords.compactMap { ranked in
            let record = ranked.record
            guard record.workoutID == workoutID,
                  ranked.lifetimeRank >= 1,
                  ranked.lifetimeRank <= 3,
                  record.bucket != .longestRun,
                  record.method == .exactSegment,
                  record.confidence == .exact,
                  let startDate = record.segmentStartDate,
                  let endDate = record.segmentEndDate,
                  let durationSeconds = record.durationSeconds,
                  durationSeconds > 0,
                  endDate > startDate,
                  let start = interpolatedPoint(at: startDate, in: preparedRoute),
                  let end = interpolatedPoint(at: endDate, in: preparedRoute)
            else { return nil }

            let interior = preparedRoute.filter { point in
                point.date > startDate && point.date < endDate
            }
            let segment = [start] + interior + [end]
            guard segment.count >= 2,
                  zip(segment, segment.dropFirst()).allSatisfy({ lower, upper in
                      upper.date.timeIntervalSince(lower.date) <= maximumBoundaryInterpolationGap
                  })
            else { return nil }

            let midpointDate = startDate.addingTimeInterval(endDate.timeIntervalSince(startDate) / 2)
            let marker = interpolatedPoint(at: midpointDate, in: segment)
                ?? segment.min(by: {
                    abs($0.date.timeIntervalSince(midpointDate)) < abs($1.date.timeIntervalSince(midpointDate))
                })
            guard let marker else { return nil }

            return WorkoutRouteAchievement(
                bucket: record.bucket,
                lifetimeRank: ranked.lifetimeRank,
                durationSeconds: durationSeconds,
                route: segment,
                marker: marker
            )
        }
        .sorted { lhs, rhs in
            if lhs.lifetimeRank != rhs.lifetimeRank {
                return lhs.lifetimeRank < rhs.lifetimeRank
            }
            return (lhs.bucket.distanceMeters ?? 0) > (rhs.bucket.distanceMeters ?? 0)
        }
    }

    private static func preparedRoute(_ route: [WorkoutRoutePoint]) -> [WorkoutRoutePoint] {
        let sorted = route
            .filter(isValid)
            .sorted { lhs, rhs in lhs.date < rhs.date }
        var result: [WorkoutRoutePoint] = []
        result.reserveCapacity(sorted.count)
        for point in sorted {
            if result.last?.date == point.date {
                result[result.count - 1] = point
            } else {
                result.append(point)
            }
        }
        return result
    }

    private static func isValid(_ point: WorkoutRoutePoint) -> Bool {
        point.latitude.isFinite
            && point.longitude.isFinite
            && (-90...90).contains(point.latitude)
            && (-180...180).contains(point.longitude)
    }

    private static func interpolatedPoint(
        at date: Date,
        in route: [WorkoutRoutePoint]
    ) -> WorkoutRoutePoint? {
        guard let first = route.first,
              let last = route.last,
              date >= first.date,
              date <= last.date
        else { return nil }

        if date == first.date { return first }
        if date == last.date { return last }

        guard let upperIndex = route.firstIndex(where: { $0.date >= date }) else { return nil }
        let upper = route[upperIndex]
        if upper.date == date { return upper }
        guard upperIndex > route.startIndex else { return nil }
        let lower = route[route.index(before: upperIndex)]
        let interval = upper.date.timeIntervalSince(lower.date)
        guard interval > 0, interval <= maximumBoundaryInterpolationGap else { return nil }

        let progress = date.timeIntervalSince(lower.date) / interval
        return WorkoutRoutePoint(
            date: date,
            latitude: lower.latitude + (upper.latitude - lower.latitude) * progress,
            longitude: lower.longitude + (upper.longitude - lower.longitude) * progress,
            altitudeMeters: interpolate(lower.altitudeMeters, upper.altitudeMeters, progress: progress),
            speedMetersPerSecond: interpolate(lower.speedMetersPerSecond, upper.speedMetersPerSecond, progress: progress),
            horizontalAccuracyMeters: interpolate(lower.horizontalAccuracyMeters, upper.horizontalAccuracyMeters, progress: progress),
            verticalAccuracyMeters: interpolate(lower.verticalAccuracyMeters, upper.verticalAccuracyMeters, progress: progress)
        )
    }

    private static func interpolate(_ lower: Double?, _ upper: Double?, progress: Double) -> Double? {
        guard let lower, let upper else { return lower ?? upper }
        return lower + (upper - lower) * progress
    }
}
