@preconcurrency import CoreLocation
import Foundation
#if os(iOS)
import MapKit
#endif

public enum WorkoutCityResolver {
    public static func cityName(for route: [WorkoutRoutePoint]) async -> String? {
        guard let point = representativePoint(in: route) else { return nil }
        let location = CLLocation(latitude: point.latitude, longitude: point.longitude)

#if os(iOS)
        guard let request = MKReverseGeocodingRequest(location: location) else { return nil }
        do {
            let mapItems = try await request.mapItems
            return mapItems.first?.addressRepresentations?.cityWithContext
                ?? mapItems.first?.addressRepresentations?.cityName
        } catch {
            return nil
        }
#else
        return await withCheckedContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { placemarks, _ in
                guard let placemark = placemarks?.first else {
                    continuation.resume(returning: nil)
                    return
                }

                let city = placemark.locality
                    ?? placemark.subAdministrativeArea
                    ?? placemark.administrativeArea
                let region = placemark.administrativeArea
                let value = [city, region]
                    .compactMap { $0 }
                    .reduce(into: [String]()) { result, component in
                        if !result.contains(component) {
                            result.append(component)
                        }
                    }
                    .joined(separator: ", ")
                continuation.resume(returning: value.isEmpty ? nil : value)
            }
        }
#endif
    }

    private static func representativePoint(in route: [WorkoutRoutePoint]) -> WorkoutRoutePoint? {
        guard !route.isEmpty else { return nil }
        return route[route.count / 2]
    }
}
