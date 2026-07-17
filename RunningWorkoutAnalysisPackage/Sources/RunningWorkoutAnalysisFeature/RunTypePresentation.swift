import SwiftUI

enum RunTypeAccent: String, Equatable, Sendable {
    case green
    case orange
    case cyan
    case purple
    case pink
    case gray

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
}

extension RunType {
    var runSignalAccent: RunTypeAccent {
        switch visibleCategory {
        case .easy, .recovery:
            .green
        case .longRun:
            .orange
        case .interval:
            .cyan
        case .tempo, .threshold:
            .purple
        case .race:
            .pink
        case .progression, .hills, .unknown:
            .gray
        }
    }
}

extension WeeklyRunCategory {
    var runSignalAccent: RunTypeAccent {
        switch self {
        case .easy, .warmupCooldown:
            .green
        case .longRun:
            .orange
        case .interval:
            .cyan
        case .threshold:
            .purple
        case .race:
            .pink
        case .other:
            .gray
        }
    }
}

struct RunTypeTag: View {
    let runType: RunType

    private var category: RunType {
        runType.visibleCategory
    }

    private var tint: Color {
        category.runSignalAccent.color
    }

    var body: some View {
        Text(category.label)
            .font(.caption2.bold())
            .foregroundStyle(.primary)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(tint.opacity(0.16))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(tint.opacity(0.5), lineWidth: 1)
            }
            .accessibilityLabel("Run type \(category.label)")
    }
}
