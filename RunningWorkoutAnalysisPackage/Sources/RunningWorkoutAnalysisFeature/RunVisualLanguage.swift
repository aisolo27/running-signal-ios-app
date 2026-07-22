import SwiftUI

struct WorkoutCategoryBackdrop: View {
    let runType: RunType

    private var tint: Color {
        runType.runSignalAccent.color
    }

    var body: some View {
        LinearGradient(
            colors: [
                tint.opacity(0.15),
                tint.opacity(0.035),
                Color.clear
            ],
            startPoint: .top,
            endPoint: .center
        )
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

struct WorkoutCategoryEdgeFrame: View {
    let runType: RunType

    private var tint: Color {
        runType.runSignalAccent.color
    }

    var body: some View {
        HStack(spacing: 0) {
            edge
            Spacer(minLength: 0)
            edge
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var edge: some View {
        LinearGradient(
            colors: [
                tint.opacity(0.9),
                tint.opacity(0.42),
                tint.opacity(0.68)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(width: 3)
        .shadow(color: tint.opacity(0.5), radius: 7)
    }
}

extension View {
    func runSignalSurface(cornerRadius: CGFloat = 16) -> some View {
        self
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
    }
}
