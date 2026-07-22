import Charts
import MapKit
import SwiftUI

struct WorkoutPerformancePanel: View {
    let workout: CanonicalWorkout
    var achievements: [WorkoutRouteAchievement] = []
    let isLoading: Bool

    private var timeline: WorkoutPerformanceTimeline? {
        WorkoutPerformanceTimelineBuilder.make(workout: workout)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionHeader("Performance Details")

            if let timeline, timeline.route.count >= 2 || !timeline.visibleSeries.isEmpty {
                NavigationLink {
                    WorkoutPerformanceTimelineView(
                        workout: workout,
                        timeline: timeline,
                        achievements: achievements
                    )
                } label: {
                    HStack(spacing: 14) {
                        Image(systemName: "waveform.path.ecg.rectangle")
                            .font(.title2)
                            .foregroundStyle(.cyan)
                            .frame(width: 42, height: 42)
                            .background(.cyan.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Explore Your Run")
                                .font(.headline)
                                .foregroundStyle(.primary)
                            Text(summary(timeline))
                                .font(.caption)
                                .foregroundStyle(RunSignalTextStyle.secondary)
                                .fixedSize(horizontal: false, vertical: true)
                        }

                        Spacer(minLength: 6)
                        Image(systemName: "chevron.right")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .runSignalSurface()
                }
                .buttonStyle(.plain)
                .accessibilityIdentifier("performance-details-link")
            } else if isLoading {
                RoundedRectangle(cornerRadius: 16)
                    .fill(.thinMaterial)
                    .frame(height: 82)
                    .overlay { ProgressView("Loading performance data") }
                    .accessibilityIdentifier("performance-details-loading")
            } else {
                NoticeCard(
                    title: "Performance details unavailable",
                    message: "Apple Health did not provide enough detailed samples for this workout.",
                    systemImage: "waveform.path.ecg.rectangle",
                    tint: .secondary
                )
            }
        }
    }

    private func summary(_ timeline: WorkoutPerformanceTimeline) -> String {
        let count = timeline.visibleSeries.count
        if count == 0, timeline.route.count >= 2 {
            return "Explore the route from Start to Finish."
        }
        let metricText = count == 1 ? "1 synchronized metric" : "\(count) synchronized metrics"
        return timeline.route.count >= 2
            ? "Scrub the map and \(metricText) together."
            : "Scrub \(metricText) at any point in the run."
    }
}

struct WorkoutHeartRatePanel: View {
    let workout: CanonicalWorkout
    let profile: HeartRateZoneProfile

    @State private var analysis: HeartRateZoneAnalysis?
    @State private var presentedAnalysis: HeartRateZoneAnalysis?

    private var timeline: WorkoutPerformanceTimeline? {
        WorkoutPerformanceTimelineBuilder.make(workout: workout)
    }

    private var heartRateSeries: WorkoutTimelineSeries? {
        timeline?.series(for: .heartRate)
    }

    var body: some View {
        if workout.averageHeartRate != nil || heartRateSeries != nil {
            VStack(alignment: .leading, spacing: 12) {
                SectionHeader("Heart Rate")

                Button {
                    guard let analysis else { return }
                    presentedAnalysis = analysis
                } label: {
                    HStack(spacing: 14) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Average")
                                .font(.caption.weight(.medium))
                                .foregroundStyle(RunSignalTextStyle.secondary)
                            Text(RunFormatters.number(workout.averageHeartRate, suffix: " bpm"))
                                .font(.title2.bold().monospacedDigit())
                                .foregroundStyle(.red)
                        }

                        if let heartRateSeries {
                            HeartRateSparkline(series: heartRateSeries)
                                .frame(maxWidth: .infinity)
                        } else {
                            Spacer()
                        }

                        VStack(alignment: .trailing, spacing: 5) {
                            Image(systemName: "chevron.right")
                                .font(.subheadline.bold())
                            Text(analysis == nil ? "Loading zones" : "View zones")
                                .font(.caption2.weight(.semibold))
                        }
                        .foregroundStyle(analysis == nil ? Color.secondary : Color.red)
                    }
                    .padding()
                    .contentShape(Rectangle())
                    .runSignalSurface()
                }
                .buttonStyle(.plain)
                .disabled(analysis == nil)
                .accessibilityLabel("Heart Rate Zones")
                .accessibilityHint(analysis == nil ? "Zone analysis is loading" : "Opens detailed time in heart rate zones")
                .accessibilityIdentifier("heart-rate-zones-link")
            }
            .task(id: presentationID) {
                do {
                    let next = try await WorkoutViewComputation.heartRateZoneAnalysis(
                        workout: workout,
                        profile: profile
                    )
                    try Task.checkCancellation()
                    analysis = next
                } catch is CancellationError {
                    return
                } catch {
                    assertionFailure("Unexpected heart rate zone error: \(error)")
                }
            }
            .sheet(item: $presentedAnalysis) { analysis in
                HeartRateZoneDetailView(workout: workout, analysis: analysis)
            }
        }
    }

    private var presentationID: String {
        let loadedAt = workout.evidence?.loadedAt.timeIntervalSince1970 ?? 0
        return "\(loadedAt)|\(profile.id)"
    }
}

private struct HeartRateSparkline: View {
    let series: WorkoutTimelineSeries

    var body: some View {
        Chart(series.buckets) { bucket in
            LineMark(
                x: .value("Time", bucket.offsetSeconds),
                y: .value("Heart rate", bucket.median)
            )
            .interpolationMethod(.linear)
            .foregroundStyle(.red)
            .lineStyle(StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
        }
        .chartXAxis(.hidden)
        .chartYAxis(.hidden)
        .chartYScale(domain: series.yDomain)
        .frame(width: 90, height: 42)
        .accessibilityHidden(true)
    }
}

struct WorkoutPerformanceTimelineView: View {
    let workout: CanonicalWorkout
    let timeline: WorkoutPerformanceTimeline
    var achievements: [WorkoutRouteAchievement] = []

    @Environment(\.runDisplayPolicy) private var runDisplayPolicy
    @State private var selectedIndex: Int?

    private var selection: WorkoutTimelineSelection? {
        timeline.selection(at: selectedIndex)
    }

    private var displayedDistanceMeters: Double? {
        guard let selection else { return workout.distanceMeters }
        return selection.distanceMeters
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 16) {
                selectionHeader

                if timeline.route.count >= 2 {
                    SynchronizedWorkoutRouteMap(
                        route: timeline.route,
                        selectedRoutePointIndex: selection?.routePointIndex,
                        achievements: achievements
                    )
                }

                ForEach(timeline.visibleSeries) { series in
                    WorkoutTimelineTrack(
                        series: series,
                        durationSeconds: timeline.durationSeconds,
                        bucketSeconds: timeline.bucketSeconds,
                        selectedIndex: $selectedIndex,
                        selectedBucket: series.bucket(at: selectedIndex ?? -1)
                    )
                }

                if timeline.cadenceWasWithheld {
                    NoticeCard(
                        title: "Cadence detail hidden",
                        message: "Apple Health only provided sparse cadence samples, so RunSignal is not drawing a line that could imply continuous data.",
                        systemImage: "figure.run",
                        tint: .teal
                    )
                }

                Text(timeline.visibleSeries.isEmpty ? routeOnlyExplanation : metricExplanation)
                    .font(.caption)
                    .foregroundStyle(RunSignalTextStyle.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .padding(.bottom, 30)
        }
        .navigationTitle("Performance Details")
        .runSignalInlineNavigationTitle()
        .sensoryFeedback(.selection, trigger: selectedIndex)
        .accessibilityIdentifier("performance-details-screen")
    }

    private var selectionHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 4) {
                Text(selection == nil ? "Entire Run" : "Selected Time")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(RunSignalTextStyle.secondary)
                Text(RunFormatters.duration(selection?.offsetSeconds ?? timeline.durationSeconds))
                    .font(.title.bold().monospacedDigit())
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 4) {
                Text(selection == nil ? "Total Distance" : "Distance")
                    .font(.caption.weight(.medium))
                    .foregroundStyle(RunSignalTextStyle.secondary)
                Text(RunFormatters.compactDistance(displayedDistanceMeters, policy: runDisplayPolicy))
                    .font(.title3.bold().monospacedDigit())
                    .foregroundStyle(.cyan)
            }
        }
        .padding()
        .runSignalSurface()
    }

    private var metricExplanation: String {
        "Tap or drag horizontally across any metric to inspect the same moment everywhere. Swipe vertically to keep scrolling. A metric may show No Data when Apple Health did not record a sample at that point."
    }

    private var routeOnlyExplanation: String {
        "Apple Health supplied the route but did not retain detailed metric samples for this workout."
    }
}

private struct WorkoutTimelineTrack: View {
    let series: WorkoutTimelineSeries
    let durationSeconds: Double
    let bucketSeconds: Double
    @Binding var selectedIndex: Int?
    let selectedBucket: WorkoutTimelineBucket?

    @Environment(\.runDisplayPolicy) private var runDisplayPolicy

    private var displayedValue: String {
        guard selectedIndex != nil else { return formatted(series.average) }
        guard let selectedBucket else { return "No Data" }
        if selectedBucket.minimum != selectedBucket.maximum {
            return "\(formatted(selectedBucket.minimum))–\(formatted(selectedBucket.maximum))"
        }
        return formatted(selectedBucket.median)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(series.metric.title)
                    .font(.headline)
                Spacer()
                Text(displayedValue)
                    .font(.headline.monospacedDigit())
                    .foregroundStyle(selectedBucket == nil && selectedIndex != nil ? Color.secondary : series.metric.color)
                    .multilineTextAlignment(.trailing)
                    .minimumScaleFactor(0.7)
            }

            Chart {
                ForEach(series.buckets) { bucket in
                    RectangleMark(
                        xStart: .value("Start", bucket.startOffsetSeconds),
                        xEnd: .value("End", bucket.endOffsetSeconds),
                        yStart: .value("Baseline", series.yDomain.lowerBound),
                        yEnd: .value("Value", clipped(bucket.median))
                    )
                    .foregroundStyle(series.metric.color.opacity(0.72))
                }

                if let selectedIndex {
                    let x = min((Double(selectedIndex) + 0.5) * bucketSeconds, durationSeconds)
                    RuleMark(x: .value("Selected time", x))
                        .foregroundStyle(.primary.opacity(0.8))
                        .lineStyle(StrokeStyle(lineWidth: 1.5))
                }
            }
            .chartXScale(domain: 0...durationSeconds)
            .chartYScale(domain: series.yDomain)
            .chartXAxis(.hidden)
            .chartYAxis(.hidden)
            .frame(height: 96)
            .chartOverlay { proxy in
                GeometryReader { geometry in
                    if let plotFrame = proxy.plotFrame {
                        let frame = geometry[plotFrame]
                        Rectangle()
                            .fill(.clear)
                            .contentShape(Rectangle())
                            .simultaneousGesture(
                                SpatialTapGesture()
                                    .onEnded { value in
                                        updateSelection(at: value.location, frame: frame, proxy: proxy)
                                    }
                            )
                            .simultaneousGesture(
                                DragGesture(minimumDistance: 10)
                                    .onChanged { value in
                                        guard WorkoutTimelineInteractionPolicy.shouldScrub(
                                            horizontalTranslation: value.translation.width,
                                            verticalTranslation: value.translation.height
                                        ) else { return }
                                        updateSelection(at: value.location, frame: frame, proxy: proxy)
                                    }
                            )
                    }
                }
            }

            if series.hasClippedValues {
                Label("Extreme values remain selectable without compressing the chart.", systemImage: "arrow.up.and.down")
                    .font(.caption2)
                    .foregroundStyle(RunSignalTextStyle.secondary)
            }
        }
        .padding()
        .runSignalSurface()
        .accessibilityElement(children: .combine)
        .accessibilityLabel(series.metric.title)
        .accessibilityValue(displayedValue)
        .accessibilityHint("Swipe up or down to move through the synchronized workout timeline.")
        .accessibilityAdjustableAction { direction in
            let bucketCount = max(1, Int(ceil(durationSeconds / bucketSeconds)))
            switch direction {
            case .increment:
                selectedIndex = min((selectedIndex ?? -1) + 1, bucketCount - 1)
            case .decrement:
                selectedIndex = max((selectedIndex ?? bucketCount) - 1, 0)
            @unknown default:
                break
            }
        }
        .accessibilityIdentifier("performance-metric-\(series.metric.rawValue)")
    }

    private func updateSelection(
        at location: CGPoint,
        frame: CGRect,
        proxy: ChartProxy
    ) {
        let x = location.x - frame.origin.x
        guard x >= 0, x <= frame.width,
              let offset: Double = proxy.value(atX: x) else { return }
        let fraction = min(max(offset / durationSeconds, 0), 0.999_999)
        let bucketCount = max(1, Int(ceil(durationSeconds / bucketSeconds)))
        selectedIndex = min(Int(fraction * Double(bucketCount)), bucketCount - 1)
    }

    private func clipped(_ value: Double) -> Double {
        min(max(value, series.yDomain.lowerBound), series.yDomain.upperBound)
    }

    private func formatted(_ value: Double?) -> String {
        guard let value, value.isFinite else { return "No Data" }
        switch series.metric {
        case .elevation:
            return RunFormatters.number(value, suffix: " m")
        case .heartRate:
            return RunFormatters.number(value, suffix: " bpm")
        case .pace:
            return RunFormatters.pace(value, policy: runDisplayPolicy)
        case .power:
            return RunFormatters.number(value, suffix: " W")
        case .cadence:
            return RunFormatters.number(value, suffix: " spm")
        case .verticalOscillation:
            return RunFormatters.number(value, suffix: " cm", decimals: 1)
        case .groundContactTime:
            return RunFormatters.number(value, suffix: " ms")
        case .strideLength:
            return RunFormatters.number(value, suffix: " m", decimals: 2)
        }
    }
}

enum WorkoutTimelineInteractionPolicy {
    static func shouldScrub(
        horizontalTranslation: CGFloat,
        verticalTranslation: CGFloat
    ) -> Bool {
        abs(horizontalTranslation) > abs(verticalTranslation)
    }
}

private struct SynchronizedWorkoutRouteMap: View {
    let route: [WorkoutRoutePoint]
    let selectedRoutePointIndex: Int?
    let achievements: [WorkoutRouteAchievement]

    private var coordinates: [CLLocationCoordinate2D] {
        route.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
    }

    private var selectedCoordinate: CLLocationCoordinate2D? {
        guard let selectedRoutePointIndex, coordinates.indices.contains(selectedRoutePointIndex) else { return nil }
        return coordinates[selectedRoutePointIndex]
    }

    private var completedCoordinates: [CLLocationCoordinate2D] {
        guard let selectedRoutePointIndex else { return [] }
        return Array(coordinates.prefix(min(selectedRoutePointIndex + 1, coordinates.count)))
    }

    var body: some View {
        Map(initialPosition: .region(region)) {
            MapPolyline(coordinates: coordinates)
                .stroke(.secondary.opacity(0.42), lineWidth: 4)

            if completedCoordinates.count >= 2 {
                MapPolyline(coordinates: completedCoordinates)
                    .stroke(.cyan, lineWidth: 5)
            }

            if let start = coordinates.first {
                Annotation("Start", coordinate: start) {
                    RouteEndpointLabel(title: "Start", color: .green)
                }
            }

            if let finish = coordinates.last {
                Annotation("Finish", coordinate: finish) {
                    RouteEndpointLabel(title: "Finish", color: .red)
                }
            }

            if let selectedCoordinate {
                Annotation("Selected point", coordinate: selectedCoordinate) {
                    Circle()
                        .fill(.cyan)
                        .frame(width: 14, height: 14)
                        .overlay { Circle().stroke(.white, lineWidth: 3) }
                        .shadow(radius: 3)
                }
            }

            ForEach(achievements) { achievement in
                Annotation(achievement.title, coordinate: coordinate(for: achievement.marker)) {
                    Image(systemName: "medal.fill")
                        .font(.caption.bold())
                        .foregroundStyle(achievementColor(achievement.lifetimeRank))
                        .padding(5)
                        .background(.regularMaterial, in: Circle())
                }
            }
        }
        .frame(height: 250)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        }
        .accessibilityLabel("Synchronized workout route map")
        .accessibilityValue(selectedRoutePointIndex == nil ? "Entire route" : "Selected point on route")
        .accessibilityIdentifier("performance-route-map")
    }

    private var region: MKCoordinateRegion {
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)
        guard let minLatitude = latitudes.min(), let maxLatitude = latitudes.max(),
              let minLongitude = longitudes.min(), let maxLongitude = longitudes.max() else {
            return MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            )
        }
        return MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: (minLatitude + maxLatitude) / 2,
                longitude: (minLongitude + maxLongitude) / 2
            ),
            span: MKCoordinateSpan(
                latitudeDelta: max((maxLatitude - minLatitude) * 1.35, 0.005),
                longitudeDelta: max((maxLongitude - minLongitude) * 1.35, 0.005)
            )
        )
    }

    private func coordinate(for point: WorkoutRoutePoint) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: point.latitude, longitude: point.longitude)
    }

    private func achievementColor(_ rank: Int) -> Color {
        switch rank {
        case 1: Color(red: 0.96, green: 0.74, blue: 0.12)
        case 2: Color(red: 0.72, green: 0.75, blue: 0.79)
        case 3: Color(red: 0.72, green: 0.42, blue: 0.20)
        default: .secondary
        }
    }
}

private struct RouteEndpointLabel: View {
    let title: String
    let color: Color

    var body: some View {
        HStack(spacing: 4) {
            Circle().fill(color).frame(width: 7, height: 7)
            Text(title)
                .font(.caption2.bold())
        }
        .foregroundStyle(.primary)
        .padding(.horizontal, 7)
        .padding(.vertical, 5)
        .background(.regularMaterial, in: Capsule())
        .overlay { Capsule().strokeBorder(color.opacity(0.7), lineWidth: 1) }
    }
}

private extension WorkoutTimelineMetric {
    var color: Color {
        switch self {
        case .elevation: .green
        case .heartRate: .red
        case .pace: .cyan
        case .power: .mint
        case .cadence: .teal
        case .verticalOscillation: .indigo
        case .groundContactTime: .orange
        case .strideLength: .blue
        }
    }
}
