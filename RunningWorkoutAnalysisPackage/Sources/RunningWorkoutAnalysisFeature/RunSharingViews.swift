#if os(iOS)
import Photos
import SwiftUI
import UIKit
import UniformTypeIdentifiers

struct RunShareSheet: View {
    @Environment(\.dismiss) private var dismiss

    let workout: CanonicalWorkout
    let presentation: WorkoutDetailPresentation
    let policy: RunDisplayPolicy

    @State private var template = RunShareTemplate.summary
    @State private var selectedPage = 0
    @State private var previewImage: UIImage?
    @State private var isPreparing = false
    @State private var statusMessage: String?
    @State private var activityPayload: RunShareActivityPayload?
    @State private var photoAccessBlocked = false

    private var model: RunShareModel {
        RunShareModelBuilder.make(
            workout: workout,
            presentation: presentation,
            policy: policy
        )
    }

    private var canvas: RunShareCanvas {
        RunShareCanvas.defaultCanvas(for: template)
    }

    private var pageCount: Int {
        model.pageCount(template: template, canvas: canvas)
    }

    private var isFullList: Bool {
        canvas == .fullList
    }

    private var previewSize: CGSize {
        if isFullList {
            return CGSize(width: 205, height: 440)
        }
        let scale: CGFloat = 0.57
        return CGSize(width: canvas.pointSize.width * scale, height: canvas.pointSize.height * scale)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 18) {
                    preview

                    VStack(alignment: .leading, spacing: 8) {
                        Text("What to share")
                            .font(.subheadline.bold())
                        Picker("Template", selection: $template) {
                            ForEach(model.availableTemplates) { option in
                                Text(option.title).tag(option)
                            }
                        }
                        .pickerStyle(.segmented)
                        .accessibilityIdentifier("run-share-template-picker")
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
        .task(id: previewTaskID) {
            previewImage = RunShareImageRenderer.render(
                model: model,
                template: template,
                canvas: canvas,
                page: selectedPage,
                scale: 1
            )
        }
        .sheet(item: $activityPayload, onDismiss: {
            activityPayload = nil
        }) { payload in
            RunShareActivityView(urls: payload.files.urls)
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
            if isFullList, let previewImage {
                let renderedHeight = previewSize.width * previewImage.size.height / max(1, previewImage.size.width)
                ScrollView(.vertical) {
                    Image(uiImage: previewImage)
                        .resizable()
                        .interpolation(.high)
                        .frame(
                            width: previewSize.width,
                            height: renderedHeight
                        )
                }
                .scrollIndicators(.visible)
                .frame(
                    width: previewSize.width,
                    height: min(previewSize.height, max(220, renderedHeight))
                )
                .background(.black.opacity(0.35))
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.28), radius: 14, y: 8)
                .accessibilityIdentifier("run-share-preview")
                .accessibilityLabel("Scrollable full list preview")
            } else {
                Group {
                    if let previewImage {
                        Image(uiImage: previewImage)
                            .resizable()
                            .interpolation(.high)
                            .aspectRatio(contentMode: .fit)
                    } else {
                        ProgressView("Preparing preview")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.black.opacity(0.35))
                    }
                }
                .frame(width: previewSize.width, height: previewSize.height)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .black.opacity(0.28), radius: 14, y: 8)
                .accessibilityIdentifier("run-share-preview")
            }

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

    private var previewTaskID: String {
        "\(template.rawValue)-\(selectedPage)"
    }

    private func resetPage() {
        selectedPage = 0
        statusMessage = nil
    }

    @MainActor
    private func preparedPNGFiles() async -> RunSharePreparedFiles? {
        isPreparing = true
        statusMessage = nil
        defer { isPreparing = false }

        do {
            return try RunSharePreparedFiles.make(
                pageCount: pageCount,
                baseFilename: exportFilename
            ) { page in
                guard let image = RunShareImageRenderer.render(
                    model: model,
                    template: template,
                    canvas: canvas,
                    page: page,
                    scale: RunShareLayout.exportScale
                ), let data = image.pngData() else {
                    throw RunSharePreparationError.renderFailed
                }
                return data
            }
        } catch {
            return nil
        }
    }

    @MainActor
    private func saveToPhotos() async {
        guard let files = await preparedPNGFiles(), files.urls.count == pageCount else {
            statusMessage = "RunSignal could not render every page. Nothing was saved."
            return
        }

        let saveResult = await RunSharePhotoLibrarySaver.save(urls: files.urls)
        withExtendedLifetime(files) {}
        switch saveResult {
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
        guard let files = await preparedPNGFiles(), files.urls.count == pageCount else {
            statusMessage = "RunSignal could not render every page for sharing."
            return
        }
        activityPayload = RunShareActivityPayload(files: files)
    }

    private var exportFilename: String {
        let day = ISO8601DateFormatter().string(from: workout.startDate).prefix(10)
        return "Run-\(day)-\(template.rawValue)"
    }
}

struct RunShareCardView: View {
    let model: RunShareModel
    let template: RunShareTemplate
    let canvas: RunShareCanvas
    let page: Int

    private var accent: Color { model.accent.color }
    private var cardSize: CGSize { model.pointSize(template: template, canvas: canvas, page: page) }

    var body: some View {
        Group {
            switch template {
            case .summary:
                summaryContent
            case .splits:
                splitsContent
            case .workoutReps:
                workoutRepsContent
            }
        }
        .frame(width: cardSize.width, height: cardSize.height)
        .environment(\.colorScheme, .dark)
        .clipped()
    }

    private var summaryContent: some View {
        VStack(spacing: 22) {
            shareMetric("Distance", model.distance)
            shareMetric("Pace", model.pace)
            shareMetric("Time", model.duration)

            if !model.routePoints.isEmpty {
                RunShareRouteShape(
                    points: model.routePoints,
                    accent: accent,
                    showsBackdrop: false
                )
                .frame(width: 220, height: 170)
            }
        }
        .padding(30)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private var splitsContent: some View {
        let rows = model.splitRows(page: page, canvas: canvas)
        return VStack(spacing: 18) {
            splitHeading
            VStack(spacing: 0) {
                ForEach(rows) { row in
                    RunShareSplitRowView(row: row)
                        .frame(height: RunShareLayout.fullListSplitRowHeightPoints)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 28)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private var splitHeading: some View {
        VStack(spacing: 3) {
            Text(model.splitUnitTitle.uppercased())
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundStyle(.white)
            if model.pageCount(template: .splits, canvas: canvas) > 1 {
                Text("PAGE \(page + 1) OF \(model.pageCount(template: .splits, canvas: canvas))")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundStyle(.white.opacity(0.78))
            }
        }
        .shadow(color: .black.opacity(0.82), radius: 1.2, y: 0.8)
    }

    private var workoutRepsContent: some View {
        let rows = model.workRows(page: page, canvas: canvas)
        return VStack(spacing: 14) {
            workoutRepsHeading
                .frame(height: 90)

            VStack(spacing: 0) {
                ForEach(rows) { row in
                    RunShareWorkRowView(
                        row: row,
                        accent: accent
                    )
                    .frame(height: RunShareLayout.fullListWorkoutRowHeightPoints)
                }
            }
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 22)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .shadow(color: .black.opacity(0.82), radius: 1.2, y: 0.8)
    }

    private var workoutRepsHeading: some View {
        VStack(spacing: 5) {
            Text(model.workoutPrescription ?? "Workout Reps")
                .font(.system(size: 24, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .lineLimit(1)
                .minimumScaleFactor(0.76)

            if let result = model.workoutResultSummary {
                Text(result)
                    .font(.system(size: 13, weight: .semibold, design: .default))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .lineLimit(1)
                    .minimumScaleFactor(0.68)
            }

            HStack(spacing: 12) {
                if let averagePace = model.averageWorkPace {
                    Text("AVG  \(averagePace)")
                        .foregroundStyle(accent)
                }
                if let target = model.workoutTarget {
                    Text("TARGET  \(target)")
                        .foregroundStyle(.white.opacity(0.9))
                }
            }
            .font(.system(size: 11, weight: .bold, design: .default).monospacedDigit())
            .lineLimit(1)
            .minimumScaleFactor(0.66)

            if model.pageCount(template: .workoutReps, canvas: canvas) > 1 {
                Text("PAGE \(page + 1) OF \(model.pageCount(template: .workoutReps, canvas: canvas))")
                    .font(.system(size: 9, weight: .semibold, design: .default))
                    .foregroundStyle(.white.opacity(0.78))
            }
        }
    }

    private func shareMetric(_ label: String, _ value: String) -> some View {
        VStack(spacing: 1) {
            Text(label)
                .font(.system(size: 13, weight: .semibold, design: .default))
                .foregroundStyle(.white.opacity(0.9))
            Text(value)
                .font(.system(size: 40, weight: .bold, design: .default))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity)
        .shadow(color: .black.opacity(0.84), radius: 1.35, y: 0.9)
    }
}

private struct RunShareSplitRowView: View {
    let row: RunShareSplitRow

    var body: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 1) {
                Text(row.label)
                    .font(.system(size: 17, weight: .bold, design: .default))
                    .foregroundStyle(.white)
                if let distance = row.distance {
                    Text(distance)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(.white.opacity(0.82))
                }
            }
            .frame(width: 100, alignment: .leading)

            Spacer(minLength: 8)

            Text(row.pace)
                .font(.system(size: 21, weight: .bold, design: .default).monospacedDigit())
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .shadow(color: .black.opacity(0.84), radius: 1.25, y: 0.8)
    }
}

private struct RunShareWorkRowView: View {
    let row: RunShareWorkRow
    let accent: Color

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
        HStack(spacing: 10) {
            Text(row.label)
                .font(.system(size: 18, weight: .bold, design: .default))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.9)
                .frame(
                    width: RunShareLayout.fullListWorkoutLabelWidthPoints,
                    alignment: .leading
                )

            VStack(alignment: .leading, spacing: 2) {
                Text(row.goal)
                    .font(.system(size: 13, weight: .semibold, design: .default))
                    .foregroundStyle(.white.opacity(0.9))
                    .lineLimit(1)
                Label(row.statusText, systemImage: row.status.symbol)
                    .font(.system(size: 11, weight: .semibold, design: .default))
                    .foregroundStyle(statusColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }

            Spacer(minLength: 6)

            VStack(alignment: .trailing, spacing: 2) {
                Text(row.pace)
                    .font(
                        .system(
                            size: 20,
                            weight: .bold,
                            design: .default
                        )
                        .monospacedDigit()
                    )
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
        }
    }
}

private struct RunShareRouteShape: View {
    let points: [RunShareRoutePoint]
    let accent: Color
    let showsBackdrop: Bool

    var body: some View {
        GeometryReader { geometry in
            Canvas { context, size in
                let fittedPoints = RunShareRouteLayout.fittedPoints(points, in: size, inset: 18)
                guard let first = fittedPoints.first else { return }
                var path = Path()
                path.move(to: first)
                for point in fittedPoints.dropFirst() {
                    path.addLine(to: point)
                }
                context.stroke(
                    path,
                    with: .color(accent),
                    style: StrokeStyle(lineWidth: 4.5, lineCap: .round, lineJoin: .round)
                )

                if let finishPoint = fittedPoints.last {
                    let marker = Path(ellipseIn: CGRect(x: finishPoint.x - 5, y: finishPoint.y - 5, width: 10, height: 10))
                    context.fill(marker, with: .color(.white))
                    context.stroke(marker, with: .color(accent), lineWidth: 2)
                }
            }
            .background(
                RadialGradient(
                    colors: showsBackdrop ? [accent.opacity(0.18), .clear] : [.clear, .clear],
                    center: .center,
                    startRadius: 8,
                    endRadius: max(geometry.size.width, geometry.size.height) * 0.68
                )
            )
        }
        .accessibilityHidden(true)
    }
}

enum RunShareImageRenderer {
    @MainActor
    static func render(
        model: RunShareModel,
        template: RunShareTemplate,
        canvas: RunShareCanvas,
        page: Int,
        scale: CGFloat = RunShareLayout.exportScale
    ) -> UIImage? {
        let size = model.pointSize(template: template, canvas: canvas, page: page)
        let content = RunShareCardView(
            model: model,
            template: template,
            canvas: canvas,
            page: page
        )
        .frame(width: size.width, height: size.height)

        let renderer = ImageRenderer(content: content)
        renderer.proposedSize = ProposedViewSize(size)
        renderer.scale = scale
        renderer.isOpaque = false
        return renderer.uiImage
    }
}

private enum RunSharePreparationError: Error {
    case renderFailed
}

private final class RunSharePreparedFiles {
    let urls: [URL]
    private let directoryURL: URL

    private init(urls: [URL], directoryURL: URL) {
        self.urls = urls
        self.directoryURL = directoryURL
    }

    deinit {
        try? FileManager.default.removeItem(at: directoryURL)
    }

    @MainActor
    static func make(
        pageCount: Int,
        baseFilename: String,
        renderPNG: (Int) throws -> Data
    ) throws -> RunSharePreparedFiles {
        let directoryURL = FileManager.default.temporaryDirectory
            .appendingPathComponent("RunSignal-Share-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(
            at: directoryURL,
            withIntermediateDirectories: true
        )

        do {
            var urls: [URL] = []
            urls.reserveCapacity(pageCount)
            for page in 0..<pageCount {
                let filename = pageCount == 1
                    ? "\(baseFilename).png"
                    : "\(baseFilename)-\(page + 1).png"
                let url = directoryURL.appendingPathComponent(filename)
                let pngData = try autoreleasepool { try renderPNG(page) }
                try pngData.write(to: url, options: .atomic)
                urls.append(url)
            }
            return RunSharePreparedFiles(urls: urls, directoryURL: directoryURL)
        } catch {
            try? FileManager.default.removeItem(at: directoryURL)
            throw error
        }
    }
}

private enum RunSharePhotoSaveResult: Equatable, Sendable {
    case saved(Int)
    case denied
    case restricted
    case failed(String)
}

private enum RunSharePhotoLibrarySaver {
    static func save(urls: [URL]) async -> RunSharePhotoSaveResult {
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
                for url in urls {
                    let options = PHAssetResourceCreationOptions()
                    options.originalFilename = url.lastPathComponent
                    if #available(iOS 26.0, *) {
                        options.contentType = .png
                    } else {
                        options.uniformTypeIdentifier = UTType.png.identifier
                    }
                    PHAssetCreationRequest.forAsset()
                        .addResource(with: .photo, fileURL: url, options: options)
                }
            } completionHandler: { success, error in
                if success {
                    continuation.resume(returning: .saved(urls.count))
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
    let files: RunSharePreparedFiles
}

private struct RunShareActivityView: UIViewControllerRepresentable {
    let urls: [URL]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: urls, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
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
