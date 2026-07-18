#if os(iOS)
import MapKit
import Photos
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct RunShareSheet: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("RunSignal.TemperatureUnit") private var temperatureUnitRaw = TemperatureUnitPreference.system.rawValue

    let workout: CanonicalWorkout
    let presentation: WorkoutDetailPresentation
    let policy: RunDisplayPolicy

    @State private var template = RunShareTemplate.summary
    @State private var canvas = RunShareCanvas.story
    @State private var appearance = RunShareAppearance.darkCard
    @State private var routeStyle: RunShareRouteStyle
    @State private var selectedPage = 0
    @State private var mapImage: UIImage?
    @State private var isPreparing = false
    @State private var statusMessage: String?
    @State private var activityPayload: RunShareActivityPayload?
    @State private var photoAccessBlocked = false

    init(
        workout: CanonicalWorkout,
        presentation: WorkoutDetailPresentation,
        policy: RunDisplayPolicy
    ) {
        self.workout = workout
        self.presentation = presentation
        self.policy = policy
        _routeStyle = State(initialValue: (workout.evidence?.route.count ?? 0) >= 2 ? .routeShape : .none)
    }

    private var temperaturePreference: TemperatureUnitPreference {
        TemperatureUnitPreference(rawValue: temperatureUnitRaw) ?? .system
    }

    private var model: RunShareModel {
        RunShareModelBuilder.make(
            workout: workout,
            presentation: presentation,
            policy: policy,
            temperaturePreference: temperaturePreference
        )
    }

    private var pageCount: Int {
        model.pageCount(template: template, canvas: canvas)
    }

    private var hasRoute: Bool {
        !model.routePoints.isEmpty
    }

    private var previewScale: CGFloat {
        canvas == .story ? 0.57 : 0.84
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    preview

                    VStack(alignment: .leading, spacing: 14) {
                        optionSection("What to share") {
                            Picker("Template", selection: $template) {
                                ForEach(model.availableTemplates) { option in
                                    Label(option.title, systemImage: option.systemImage).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        optionSection("Format") {
                            Picker("Format", selection: $canvas) {
                                ForEach(RunShareCanvas.allCases) { option in
                                    Text(option.title).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        optionSection("Style") {
                            Picker("Style", selection: $appearance) {
                                ForEach(RunShareAppearance.allCases) { option in
                                    Text(option.title).tag(option)
                                }
                            }
                            .pickerStyle(.segmented)
                        }

                        if template == .summary {
                            optionSection("Route") {
                                Picker("Route", selection: $routeStyle) {
                                    ForEach(RunShareRouteStyle.allCases) { option in
                                        Text(option.title).tag(option)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .disabled(!hasRoute)

                                Text(routeHelpText)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                        }
                    }
                    .padding()
                    .background(.background)
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                    VStack(spacing: 10) {
                        Button {
                            Task { await saveToPhotos() }
                        } label: {
                            Label("Save to Photos", systemImage: "square.and.arrow.down")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isPreparing)
                        .accessibilityIdentifier("run-share-save-photos")

                        Button {
                            Task { await shareImages() }
                        } label: {
                            Label("Share…", systemImage: "square.and.arrow.up")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                        .disabled(isPreparing)
                        .accessibilityIdentifier("run-share-system-share")

                        if isPreparing {
                            ProgressView("Preparing \(pageCount == 1 ? "image" : "images")")
                                .font(.caption)
                        } else if let statusMessage {
                            Text(statusMessage)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .padding()
                .padding(.bottom, 32)
            }
            .navigationTitle("Share Run")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
        .presentationDetents([.large])
        .onChange(of: template) { _, _ in resetPage() }
        .onChange(of: canvas) { _, _ in resetPage() }
        .onChange(of: routeStyle) { _, newValue in
            if newValue != .map { mapImage = nil }
        }
        .task(id: mapTaskID) {
            guard routeStyle == .map, hasRoute else {
                mapImage = nil
                return
            }
            mapImage = try? await RunShareMapSnapshotter.snapshot(
                route: workout.evidence?.route ?? [],
                size: RunShareCardView.mapPointSize(canvas: canvas),
                accent: model.accent
            )
        }
        .sheet(item: $activityPayload) { payload in
            RunShareActivityView(images: payload.images)
        }
        .alert("Photos Access Needed", isPresented: $photoAccessBlocked) {
            Button("Not Now", role: .cancel) {}
            Button("Open Settings") {
                guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                UIApplication.shared.open(url)
            }
        } message: {
            Text("Allow RunSignal to add photos in Settings to save run images directly. You can still use Share without Photos access.")
        }
    }

    private var preview: some View {
        VStack(spacing: 10) {
            let size = canvas.pointSize
            RunShareCardView(
                model: model,
                template: template,
                canvas: canvas,
                appearance: appearance,
                routeStyle: effectiveRouteStyle,
                page: selectedPage,
                mapImage: mapImage
            )
            .frame(width: size.width, height: size.height)
            .scaleEffect(previewScale, anchor: .topLeading)
            .frame(width: size.width * previewScale, height: size.height * previewScale)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: .black.opacity(0.28), radius: 14, y: 8)
            .accessibilityIdentifier("run-share-preview")

            if pageCount > 1 {
                HStack(spacing: 14) {
                    Button {
                        selectedPage = max(0, selectedPage - 1)
                    } label: {
                        Image(systemName: "chevron.left")
                    }
                    .disabled(selectedPage == 0)

                    Text("Page \(selectedPage + 1) of \(pageCount)")
                        .font(.caption.monospacedDigit().bold())

                    Button {
                        selectedPage = min(pageCount - 1, selectedPage + 1)
                    } label: {
                        Image(systemName: "chevron.right")
                    }
                    .disabled(selectedPage >= pageCount - 1)
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var effectiveRouteStyle: RunShareRouteStyle {
        hasRoute ? routeStyle : .none
    }

    private var routeHelpText: String {
        guard hasRoute else { return "Apple Health did not provide route coordinates for this run." }
        switch routeStyle {
        case .routeShape:
            return "Shows only the route trace without streets, addresses, or map labels."
        case .map:
            return "Shows the route over an Apple map. Review the preview before sharing."
        case .none:
            return "The shared image will not include route information."
        }
    }

    private var mapTaskID: String {
        "\(routeStyle.rawValue)-\(canvas.rawValue)-\(workout.id)"
    }

    @ViewBuilder
    private func optionSection<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline.bold())
            content()
        }
    }

    private func resetPage() {
        selectedPage = 0
        statusMessage = nil
    }

    @MainActor
    private func preparedImages() async -> [UIImage] {
        isPreparing = true
        statusMessage = nil
        defer { isPreparing = false }

        var exportMap = mapImage
        if effectiveRouteStyle == .map, exportMap == nil {
            exportMap = try? await RunShareMapSnapshotter.snapshot(
                route: workout.evidence?.route ?? [],
                size: RunShareCardView.mapPointSize(canvas: canvas),
                accent: model.accent
            )
            mapImage = exportMap
        }

        return (0..<pageCount).compactMap { page in
            RunShareImageRenderer.render(
                model: model,
                template: template,
                canvas: canvas,
                appearance: appearance,
                routeStyle: effectiveRouteStyle,
                page: page,
                mapImage: exportMap
            )
        }
    }

    @MainActor
    private func saveToPhotos() async {
        let images = await preparedImages()
        guard images.count == pageCount else {
            statusMessage = "RunSignal could not render every page. Nothing was saved."
            return
        }

        switch await RunSharePhotoLibrarySaver.save(images: images, baseFilename: exportFilename) {
        case .saved(let count):
            statusMessage = count == 1 ? "Saved to Photos." : "Saved \(count) images to Photos."
        case .denied, .restricted:
            photoAccessBlocked = true
        case .failed(let message):
            statusMessage = message
        }
    }

    @MainActor
    private func shareImages() async {
        let images = await preparedImages()
        guard images.count == pageCount else {
            statusMessage = "RunSignal could not render every page for sharing."
            return
        }
        activityPayload = RunShareActivityPayload(images: images)
    }

    private var exportFilename: String {
        let day = ISO8601DateFormatter().string(from: workout.startDate).prefix(10)
        return "RunSignal-\(day)-\(template.rawValue)"
    }
}

struct RunShareCardView: View {
    let model: RunShareModel
    let template: RunShareTemplate
    let canvas: RunShareCanvas
    let appearance: RunShareAppearance
    let routeStyle: RunShareRouteStyle
    let page: Int
    let mapImage: UIImage?

    private var accent: Color { model.accent.color }
    private var foreground: Color { .white }
    private var secondary: Color { .white.opacity(0.72) }
    private var horizontalPadding: CGFloat { canvas == .story ? 24 : 20 }

    var body: some View {
        ZStack {
            background

            VStack(alignment: .leading, spacing: canvas == .story ? 16 : 11) {
                header

                switch template {
                case .summary:
                    summaryContent
                case .splits:
                    splitsContent
                case .workoutReps:
                    workoutRepsContent
                }

                Spacer(minLength: 4)
                footer
            }
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, canvas == .story ? 24 : 18)
        }
        .frame(width: canvas.pointSize.width, height: canvas.pointSize.height)
        .environment(\.colorScheme, .dark)
        .clipped()
    }

    @ViewBuilder
    private var background: some View {
        if appearance == .darkCard {
            LinearGradient(
                colors: [
                    Color(red: 0.018, green: 0.025, blue: 0.038),
                    accent.opacity(0.24),
                    Color(red: 0.025, green: 0.033, blue: 0.048)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        } else {
            Color.clear
        }
    }

    private var header: some View {
        sharePanel {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(model.runType.uppercased())
                        .font(.caption2.bold())
                        .foregroundStyle(accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(accent.opacity(0.16))
                        .clipShape(Capsule())
                    Spacer()
                    if let environment = model.environment {
                        Text(environment.uppercased())
                            .font(.caption2.bold())
                            .foregroundStyle(secondary)
                    }
                }

                Text(model.title)
                    .font(.system(size: canvas == .story ? 24 : 20, weight: .bold, design: .rounded))
                    .foregroundStyle(foreground)
                    .lineLimit(2)
                    .minimumScaleFactor(0.72)

                Text(model.date)
                    .font(.caption)
                    .foregroundStyle(secondary)
            }
        }
    }

    @ViewBuilder
    private var summaryContent: some View {
        if routeStyle != .none, !model.routePoints.isEmpty {
            sharePanel(padding: 10) {
                routeView
                    .frame(height: Self.mapPointSize(canvas: canvas).height)
            }
        }

        sharePanel {
            HStack(alignment: .top, spacing: 8) {
                shareMetric("Distance", model.distance, secondary: model.secondaryDistance)
                shareMetric("Time", model.duration)
                shareMetric("Pace", model.pace, secondary: model.secondaryPace)
            }
        }

        let details = [
            model.averageHeartRate.map { "HR \($0)" },
            model.weather,
            model.city
        ].compactMap { $0 }
        if !details.isEmpty {
            sharePanel {
                Text(details.joined(separator: "  ·  "))
                    .font(.caption.bold())
                    .foregroundStyle(secondary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
        }
    }

    private var splitsContent: some View {
        let rows = model.splitRows(page: page, canvas: canvas)
        return sharePanel(padding: 12) {
            VStack(alignment: .leading, spacing: canvas == .story ? 9 : 6) {
                HStack(alignment: .firstTextBaseline) {
                    Text(model.splitUnitTitle)
                        .font(.headline.bold())
                        .foregroundStyle(foreground)
                    Spacer()
                    if model.pageCount(template: .splits, canvas: canvas) > 1 {
                        Text("\(page + 1)/\(model.pageCount(template: .splits, canvas: canvas))")
                            .font(.caption.monospacedDigit().bold())
                            .foregroundStyle(secondary)
                    }
                }
                Text("Longer bar = faster · line = run average")
                    .font(.caption2)
                    .foregroundStyle(secondary)

                ForEach(rows) { row in
                    RunShareSplitRowView(row: row, accent: accent, compact: canvas == .post)
                }
            }
        }
    }

    private var workoutRepsContent: some View {
        let rows = model.workRows(page: page, canvas: canvas)
        return VStack(alignment: .leading, spacing: canvas == .story ? 12 : 8) {
            sharePanel(padding: 12) {
                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .firstTextBaseline) {
                        Text(model.workoutPrescription ?? "Workout Reps")
                            .font(.headline.bold())
                            .foregroundStyle(foreground)
                            .lineLimit(2)
                            .minimumScaleFactor(0.72)
                        Spacer()
                        if model.pageCount(template: .workoutReps, canvas: canvas) > 1 {
                            Text("\(page + 1)/\(model.pageCount(template: .workoutReps, canvas: canvas))")
                                .font(.caption.monospacedDigit().bold())
                                .foregroundStyle(secondary)
                        }
                    }
                    if let result = model.workoutResultSummary {
                        Text(result)
                            .font(.caption.bold())
                            .foregroundStyle(accent)
                            .lineLimit(2)
                            .minimumScaleFactor(0.78)
                    }
                    if let averagePace = model.averageWorkPace {
                        Text("Average Work Pace  \(averagePace)")
                            .font(.caption.monospacedDigit().bold())
                            .foregroundStyle(secondary)
                    }
                }
            }

            sharePanel(padding: canvas == .story ? 12 : 9) {
                VStack(spacing: canvas == .story ? 10 : 6) {
                    ForEach(rows) { row in
                        RunShareWorkRowView(row: row, accent: accent, compact: canvas == .post)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var routeView: some View {
        switch routeStyle {
        case .routeShape:
            RunShareRouteShape(points: model.routePoints, accent: accent)
        case .map:
            if let mapImage {
                Image(uiImage: mapImage)
                    .resizable()
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RunShareRouteShape(points: model.routePoints, accent: accent)
                    .overlay(alignment: .bottomTrailing) {
                        Text("Loading map")
                            .font(.caption2.bold())
                            .foregroundStyle(secondary)
                            .padding(8)
                    }
            }
        case .none:
            EmptyView()
        }
    }

    private var footer: some View {
        HStack(spacing: 7) {
            Image(systemName: "waveform.path.ecg")
                .foregroundStyle(accent)
            Text("RUNSIGNAL")
                .font(.system(size: 13, weight: .black, design: .rounded))
                .tracking(1.1)
                .foregroundStyle(foreground)
            Spacer()
            Text("Evidence from Apple Health")
                .font(.system(size: 8, weight: .semibold))
                .foregroundStyle(secondary)
        }
        .padding(.horizontal, 4)
    }

    private func shareMetric(_ label: String, _ value: String, secondary secondaryValue: String? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 8, weight: .bold))
                .foregroundStyle(secondary)
            Text(value)
                .font(.system(size: canvas == .story ? 20 : 17, weight: .bold, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(foreground)
                .lineLimit(1)
                .minimumScaleFactor(0.65)
            if let secondaryValue {
                Text("(\(secondaryValue))")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func sharePanel<Content: View>(
        padding: CGFloat = 14,
        @ViewBuilder content: () -> Content
    ) -> some View {
        content()
            .padding(padding)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(panelBackground)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay {
                RoundedRectangle(cornerRadius: 16)
                    .strokeBorder(.white.opacity(appearance == .transparentOverlay ? 0.16 : 0.08), lineWidth: 1)
            }
    }

    private var panelBackground: Color {
        appearance == .transparentOverlay
            ? .black.opacity(0.72)
            : .black.opacity(0.26)
    }

    static func mapPointSize(canvas: RunShareCanvas) -> CGSize {
        switch canvas {
        case .story: CGSize(width: 304, height: 200)
        case .post: CGSize(width: 312, height: 96)
        }
    }
}

private struct RunShareSplitRowView: View {
    let row: RunShareSplitRow
    let accent: Color
    let compact: Bool

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 1) {
                Text(row.label)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                if let distance = row.distance {
                    Text(distance)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.64))
                }
            }
            .frame(width: compact ? 37 : 43, alignment: .leading)

            GeometryReader { geometry in
                let averageX = geometry.size.width * row.normalizedAveragePace
                ZStack(alignment: .leading) {
                    Capsule().fill(.white.opacity(0.10))
                    Capsule()
                        .fill(accent.gradient)
                        .frame(width: max(6, geometry.size.width * row.normalizedPace))
                    Rectangle()
                        .fill(.white.opacity(0.85))
                        .frame(width: 1.5)
                        .offset(x: max(0, min(geometry.size.width - 1.5, averageX)))
                }
            }
            .frame(height: compact ? 9 : 11)

            VStack(alignment: .trailing, spacing: 1) {
                Text(row.pace)
                    .font(.caption.monospacedDigit().bold())
                    .foregroundStyle(.white)
                    .lineLimit(1)
                if let heartRate = row.heartRate {
                    Text(heartRate)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.64))
                }
            }
            .frame(width: compact ? 68 : 74, alignment: .trailing)
        }
    }
}

private struct RunShareWorkRowView: View {
    let row: RunShareWorkRow
    let accent: Color
    let compact: Bool

    private var statusColor: Color {
        switch row.status {
        case .onTarget: .green
        case .fast: .cyan
        case .slow: .orange
        case .shortened: .orange
        case .exactTarget: .blue
        case .noTarget: accent
        }
    }

    var body: some View {
        VStack(spacing: compact ? 3 : 5) {
            HStack(spacing: 7) {
                Text(row.label)
                    .font(.caption.bold())
                    .foregroundStyle(.white)
                    .frame(width: 24, alignment: .leading)
                Text(row.goal)
                    .font(.system(size: compact ? 9 : 10, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.7))
                    .frame(width: compact ? 47 : 55, alignment: .leading)
                    .lineLimit(1)

                GeometryReader { geometry in
                    let targetStart = row.targetStart.map { geometry.size.width * $0 }
                    let targetEnd = row.targetEnd.map { geometry.size.width * $0 }
                    let paceX = geometry.size.width * row.normalizedPace
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.10))
                        if let targetStart, let targetEnd {
                            let left = min(targetStart, targetEnd)
                            let width = max(3, abs(targetEnd - targetStart))
                            RoundedRectangle(cornerRadius: 3)
                                .fill(.green.opacity(0.34))
                                .frame(width: width, height: compact ? 10 : 12)
                                .offset(x: left)
                        }
                        Capsule()
                            .fill(accent.opacity(0.5))
                            .frame(width: max(4, paceX), height: 3)
                        Circle()
                            .fill(statusColor)
                            .overlay { Circle().stroke(.white.opacity(0.9), lineWidth: 1) }
                            .frame(width: compact ? 8 : 10, height: compact ? 8 : 10)
                            .offset(x: max(0, min(geometry.size.width - (compact ? 8 : 10), paceX - 4)))
                    }
                }
                .frame(height: compact ? 10 : 12)

                Text(row.pace)
                    .font(.system(size: compact ? 9 : 10, weight: .bold, design: .monospaced))
                    .foregroundStyle(.white)
                    .frame(width: compact ? 61 : 68, alignment: .trailing)
                    .lineLimit(1)
            }

            HStack(spacing: 5) {
                Spacer().frame(width: 31)
                Label(row.statusText, systemImage: row.status.symbol)
                    .font(.system(size: compact ? 8 : 9, weight: .bold))
                    .foregroundStyle(statusColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
                Spacer()
                if let heartRate = row.heartRate {
                    Text(heartRate)
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.62))
                }
            }
        }
    }
}

private struct RunShareRouteShape: View {
    let points: [RunShareRoutePoint]
    let accent: Color

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                guard let first = points.first else { return }
                var path = Path()
                path.move(to: CGPoint(x: first.x * size.width, y: first.y * size.height))
                for point in points.dropFirst() {
                    path.addLine(to: CGPoint(x: point.x * size.width, y: point.y * size.height))
                }
                context.stroke(
                    path,
                    with: .color(accent),
                    style: StrokeStyle(lineWidth: 4.5, lineCap: .round, lineJoin: .round)
                )

                if let finish = points.last {
                    let finishPoint = CGPoint(x: finish.x * size.width, y: finish.y * size.height)
                    let marker = Path(ellipseIn: CGRect(x: finishPoint.x - 5, y: finishPoint.y - 5, width: 10, height: 10))
                    context.fill(marker, with: .color(.white))
                    context.stroke(marker, with: .color(accent), lineWidth: 2)
                }
            }
            .padding(18)
            .background(
                RadialGradient(
                    colors: [accent.opacity(0.18), .clear],
                    center: .center,
                    startRadius: 8,
                    endRadius: max(geometry.size.width, geometry.size.height) * 0.68
                )
            )
        }
        .accessibilityHidden(true)
    }
}

private enum RunShareImageRenderer {
    @MainActor
    static func render(
        model: RunShareModel,
        template: RunShareTemplate,
        canvas: RunShareCanvas,
        appearance: RunShareAppearance,
        routeStyle: RunShareRouteStyle,
        page: Int,
        mapImage: UIImage?
    ) -> UIImage? {
        let size = canvas.pointSize
        let content = RunShareCardView(
            model: model,
            template: template,
            canvas: canvas,
            appearance: appearance,
            routeStyle: routeStyle,
            page: page,
            mapImage: mapImage
        )
        .frame(width: size.width, height: size.height)

        let renderer = ImageRenderer(content: content)
        renderer.proposedSize = ProposedViewSize(size)
        renderer.scale = 3
        renderer.isOpaque = appearance == .darkCard
        return renderer.uiImage
    }
}

private enum RunSharePhotoSaveResult: Equatable {
    case saved(Int)
    case denied
    case restricted
    case failed(String)
}

private enum RunSharePhotoLibrarySaver {
    @MainActor
    static func save(images: [UIImage], baseFilename: String) async -> RunSharePhotoSaveResult {
        let data = images.compactMap { $0.pngData() }
        guard data.count == images.count else {
            return .failed("RunSignal could not prepare the PNG images for Photos.")
        }

        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        let resolvedStatus: PHAuthorizationStatus
        if status == .notDetermined {
            resolvedStatus = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
        } else {
            resolvedStatus = status
        }

        switch resolvedStatus {
        case .authorized, .limited:
            break
        case .denied:
            return .denied
        case .restricted:
            return .restricted
        case .notDetermined:
            return .failed("Photos access was not determined. Try Save to Photos again.")
        @unknown default:
            return .failed("Photos returned an unknown authorization state.")
        }

        return await withCheckedContinuation { continuation in
            PHPhotoLibrary.shared().performChanges {
                for (index, pngData) in data.enumerated() {
                    let options = PHAssetResourceCreationOptions()
                    options.originalFilename = data.count == 1
                        ? "\(baseFilename).png"
                        : "\(baseFilename)-\(index + 1).png"
                    if #available(iOS 26.0, *) {
                        options.contentType = .png
                    } else {
                        options.uniformTypeIdentifier = UTType.png.identifier
                    }
                    PHAssetCreationRequest.forAsset()
                        .addResource(with: .photo, data: pngData, options: options)
                }
            } completionHandler: { success, error in
                if success {
                    continuation.resume(returning: .saved(data.count))
                } else {
                    continuation.resume(
                        returning: .failed(error?.localizedDescription ?? "Photos could not save the run images.")
                    )
                }
            }
        }
    }
}

private struct RunShareActivityPayload: Identifiable {
    let id = UUID()
    let images: [UIImage]
}

private struct RunShareActivityView: UIViewControllerRepresentable {
    let images: [UIImage]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: images, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

private enum RunShareMapSnapshotter {
    @MainActor
    static func snapshot(
        route: [WorkoutRoutePoint],
        size: CGSize,
        accent: RunShareAccent
    ) async throws -> UIImage {
        let coordinates = route
            .filter {
                $0.latitude.isFinite && $0.longitude.isFinite
                    && abs($0.latitude) <= 90 && abs($0.longitude) <= 180
            }
            .map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude) }
        guard coordinates.count >= 2 else { throw RunShareMapError.missingRoute }

        let options = MKMapSnapshotter.Options()
        options.region = region(for: coordinates)
        options.size = size
        options.traitCollection = UITraitCollection { traits in
            traits.userInterfaceStyle = .dark
            traits.displayScale = 3
        }
        let configuration = MKStandardMapConfiguration(elevationStyle: .flat, emphasisStyle: .muted)
        configuration.pointOfInterestFilter = .excludingAll
        options.preferredConfiguration = configuration

        let snapshotter = MKMapSnapshotter(options: options)
        let snapshotBox: RunShareMapSnapshotBox = try await withCheckedThrowingContinuation { continuation in
            snapshotter.start(with: .main) { snapshot, error in
                if let snapshot {
                    continuation.resume(returning: RunShareMapSnapshotBox(snapshot))
                } else {
                    continuation.resume(throwing: error ?? RunShareMapError.snapshotFailed)
                }
            }
        }
        let snapshot = snapshotBox.snapshot

        let format = UIGraphicsImageRendererFormat()
        format.scale = snapshot.image.scale
        format.opaque = true
        return UIGraphicsImageRenderer(size: snapshot.image.size, format: format).image { context in
            snapshot.image.draw(at: .zero)
            let path = UIBezierPath()
            for (index, coordinate) in coordinates.enumerated() {
                let point = snapshot.point(for: coordinate)
                if index == 0 { path.move(to: point) } else { path.addLine(to: point) }
            }
            path.lineWidth = 4.5
            path.lineCapStyle = .round
            path.lineJoinStyle = .round
            accent.uiColor.setStroke()
            path.stroke()

            if let finish = coordinates.last {
                let finishPoint = snapshot.point(for: finish)
                let rect = CGRect(x: finishPoint.x - 5, y: finishPoint.y - 5, width: 10, height: 10)
                UIColor.white.setFill()
                accent.uiColor.setStroke()
                let marker = UIBezierPath(ovalIn: rect)
                marker.lineWidth = 2
                marker.fill()
                marker.stroke()
            }
            _ = context
        }
    }

    private static func region(for coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let latitudes = coordinates.map(\.latitude)
        let longitudes = coordinates.map(\.longitude)
        let minLatitude = latitudes.min() ?? 0
        let maxLatitude = latitudes.max() ?? 0
        let minLongitude = longitudes.min() ?? 0
        let maxLongitude = longitudes.max() ?? 0
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
}

private enum RunShareMapError: Error {
    case missingRoute
    case snapshotFailed
}

private final class RunShareMapSnapshotBox: @unchecked Sendable {
    let snapshot: MKMapSnapshotter.Snapshot

    init(_ snapshot: MKMapSnapshotter.Snapshot) {
        self.snapshot = snapshot
    }
}

private extension RunShareAccent {
    var color: Color {
        switch self {
        case .green: .green
        case .orange: .orange
        case .cyan: .cyan
        case .purple: .purple
        case .pink: .pink
        case .gray: .gray
        }
    }

    var uiColor: UIColor {
        switch self {
        case .green: .systemGreen
        case .orange: .systemOrange
        case .cyan: .systemCyan
        case .purple: .systemPurple
        case .pink: .systemPink
        case .gray: .systemGray
        }
    }
}
#endif
