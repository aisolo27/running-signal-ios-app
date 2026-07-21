import SwiftUI

struct AllRunsView: View {
    var store: RunningAnalysisStore
    @State private var searchText = ""
    @State private var selectedYear: Int?
    @State private var selectedCategory: WeeklyRunCategory?
    @State private var selectedEnvironment: RunEnvironment?
    @State private var collapsedMonthStarts: Set<Date> = []

    private var runs: [CanonicalWorkout] {
        V1WorkoutFilters.completedRuns(from: store.workouts)
    }

    private var years: [Int] {
        Array(Set(runs.map { Calendar.current.component(.year, from: $0.startDate) }))
            .sorted(by: >)
    }

    private var filteredRuns: [CanonicalWorkout] {
        RunHistoryFiltering.filtered(
            runs,
            selectedYear: selectedYear,
            selectedCategory: selectedCategory,
            selectedEnvironment: selectedEnvironment,
            searchText: searchText
        )
    }

    private var monthSections: [RunHistoryMonthSection] {
        RunHistoryMonthGrouping.sections(from: filteredRuns)
    }

    private var hasActiveFilters: Bool {
        selectedYear != nil || selectedCategory != nil || selectedEnvironment != nil
    }

    var body: some View {
        List {
            Section {
                RunHistorySearchField(text: $searchText)
                    .runControlListRow()

                RunHistoryFilterBar(
                    years: years,
                    selectedYear: $selectedYear,
                    selectedCategory: $selectedCategory,
                    selectedEnvironment: $selectedEnvironment
                )
                .runControlListRow()

                HStack {
                    Text(runCountText)
                        .font(.caption)
                        .foregroundStyle(RunSignalTextStyle.secondary)
                    Spacer()
                    if hasActiveFilters {
                        Button("Reset Filters") {
                            selectedYear = nil
                            selectedCategory = nil
                            selectedEnvironment = nil
                        }
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.cyan)
                        .accessibilityIdentifier("runs-clear-filters")
                    }
                }
                .runControlListRow()
            }

            if monthSections.isEmpty {
                Section {
                    EmptyStateView(
                        title: "No matching runs",
                        message: "Try another search, year, run type, or environment."
                    )
                    .runControlListRow()
                }
            } else {
                ForEach(monthSections) { section in
                    Section {
                        if !collapsedMonthStarts.contains(section.id) {
                            ForEach(section.workouts) { workout in
                                NavigationLink {
                                    WorkoutDetailView(store: store, workoutID: workout.id)
                                } label: {
                                    V1WorkoutRow(workout: workout)
                                }
                                .task {
                                    await store.hydrateCachedWorkoutPlanNameIfAvailable(for: workout.id)
                                }
                                .runCardListRow()
                            }
                        }
                    } header: {
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                if collapsedMonthStarts.contains(section.id) {
                                    collapsedMonthStarts.remove(section.id)
                                } else {
                                    collapsedMonthStarts.insert(section.id)
                                }
                            }
                        } label: {
                            HStack(spacing: 8) {
                                Image(
                                    systemName: collapsedMonthStarts.contains(section.id)
                                        ? "chevron.right"
                                        : "chevron.down"
                                )
                                .font(.caption.weight(.bold))
                                .frame(width: 12)

                                Text(section.title)
                                    .font(.headline)
                                Spacer()
                                Text("\(section.workouts.count)")
                                    .font(.caption.monospacedDigit())
                                    .foregroundStyle(RunSignalTextStyle.secondary)
                            }
                            .foregroundStyle(RunSignalTextStyle.prominentSecondary)
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .textCase(nil)
                        .padding(.top, 8)
                        .accessibilityLabel(
                            "\(section.title), \(section.workouts.count) runs, "
                                + (collapsedMonthStarts.contains(section.id) ? "collapsed" : "expanded")
                        )
                        .accessibilityHint(
                            collapsedMonthStarts.contains(section.id)
                                ? "Expands this month"
                                : "Collapses this month"
                        )
                    }
                }
            }
        }
        .navigationTitle("All Runs")
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
        .background(.background)
        .safeAreaInset(edge: .bottom) {
            Color.clear.frame(height: 84)
        }
        .refreshable {
            await store.refreshRunsListFromHealthKit()
        }
    }

    private var runCountText: String {
        "\(filteredRuns.count) \(filteredRuns.count == 1 ? "run" : "runs")"
    }
}

struct RunHistoryMonthSection: Identifiable, Equatable {
    let monthStart: Date
    let workouts: [CanonicalWorkout]

    var id: Date { monthStart }

    var title: String {
        monthStart.formatted(.dateTime.month(.wide).year())
    }
}

enum RunHistoryMonthGrouping {
    static func sections(
        from workouts: [CanonicalWorkout],
        calendar: Calendar = .current
    ) -> [RunHistoryMonthSection] {
        Dictionary(grouping: workouts) { workout in
            let components = calendar.dateComponents([.year, .month], from: workout.startDate)
            return calendar.date(from: components) ?? workout.startDate
        }
        .map { monthStart, workouts in
            RunHistoryMonthSection(
                monthStart: monthStart,
                workouts: workouts.sorted { $0.startDate > $1.startDate }
            )
        }
        .sorted { $0.monthStart > $1.monthStart }
    }
}

private struct RunHistorySearchField: View {
    @Binding var text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(RunSignalTextStyle.secondary)
            TextField("Search runs", text: $text)
                .textFieldStyle(.plain)
                .accessibilityIdentifier("runs-search-field")
            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(RunSignalTextStyle.secondary)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Clear run search")
            }
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 44)
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        }
    }
}

private struct RunHistoryFilterBar: View {
    let years: [Int]
    @Binding var selectedYear: Int?
    @Binding var selectedCategory: WeeklyRunCategory?
    @Binding var selectedEnvironment: RunEnvironment?

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LazyHStack(spacing: 8) {
                Menu {
                    Button("All Years") { selectedYear = nil }
                    Divider()
                    ForEach(years, id: \.self) { year in
                        Button(String(year)) { selectedYear = year }
                    }
                } label: {
                    RunHistoryFilterChipLabel(
                        title: selectedYear.map(String.init) ?? "All Years",
                        systemImage: "calendar",
                        isSelected: selectedYear != nil
                    )
                }

                Menu {
                    Button("All Types") { selectedCategory = nil }
                    Divider()
                    ForEach(WeeklyRunCategory.allCases) { category in
                        Button(category.label) { selectedCategory = category }
                    }
                } label: {
                    RunHistoryFilterChipLabel(
                        title: selectedCategory?.label ?? "All Types",
                        systemImage: "line.3.horizontal.decrease.circle",
                        isSelected: selectedCategory != nil,
                        tint: selectedCategory?.runSignalAccent.color ?? .cyan
                    )
                }

                Menu {
                    Button("All Environments") { selectedEnvironment = nil }
                    Divider()
                    Button("Outdoor") { selectedEnvironment = .outdoor }
                    Button("Indoor") { selectedEnvironment = .indoor }
                } label: {
                    RunHistoryFilterChipLabel(
                        title: selectedEnvironment?.label ?? "All Environments",
                        systemImage: "figure.run",
                        isSelected: selectedEnvironment != nil
                    )
                }
                .accessibilityIdentifier("runs-environment-filter")
            }
        }
    }
}

private struct RunHistoryFilterChipLabel: View {
    let title: String
    let systemImage: String
    let isSelected: Bool
    var tint: Color = .cyan

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isSelected ? tint : RunSignalTextStyle.prominentSecondary)
            .padding(.horizontal, 12)
            .frame(minHeight: 38)
            .background(isSelected ? tint.opacity(0.16) : Color.primary.opacity(0.07))
            .clipShape(Capsule())
            .overlay {
                Capsule()
                    .strokeBorder(
                        isSelected ? tint.opacity(0.55) : Color.primary.opacity(0.1),
                        lineWidth: 1
                    )
            }
    }
}

extension View {
    func runCardListRow() -> some View {
        listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }

    func runControlListRow() -> some View {
        listRowInsets(EdgeInsets(top: 5, leading: 16, bottom: 5, trailing: 16))
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}
