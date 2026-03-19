import SwiftUI

struct SectionView: View {
    let section: TaskSection
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    let onToggleTask: (TaskItem) -> Void
    let onSelectTask: (TaskItem) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            // Section header
            if section.type == .completed {
                Button(action: onToggleExpand) {
                    HStack(spacing: 4) {
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 10))
                            .foregroundColor(.gray)
                        Text("\(section.title) (\(section.tasks.count))")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(sectionColor)
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                }
                .buttonStyle(.plain)
            } else {
                Text(section.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(sectionColor)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
            }

            // Tasks
            if section.type != .completed || isExpanded {
                ForEach(section.tasks) { task in
                    TaskRowView(
                        task: task,
                        onToggle: { onToggleTask(task) },
                        onSelect: { onSelectTask(task) }
                    )
                }
            }
        }
    }

    private var sectionColor: Color {
        switch section.type {
        case .carryOver:
            return .orange
        case .highest:
            return .red
        case .normal:
            return .white
        case .optional:
            return .gray
        case .completed:
            return .gray
        }
    }
}
