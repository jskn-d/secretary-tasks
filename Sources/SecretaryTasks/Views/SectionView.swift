import SwiftUI

struct SectionView: View {
    let section: TaskSection
    let isExpanded: Bool
    let onToggleExpand: () -> Void
    let onToggleTask: (TaskItem) -> Void
    let onSelectTask: (TaskItem) -> Void
    var selectedTaskId: UUID?

    private var sectionColor: Color { section.type.color }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Section header
            if section.type == .completed {
                Button(action: onToggleExpand) {
                    HStack(spacing: 0) {
                        RoundedRectangle(cornerRadius: 1)
                            .fill(sectionColor)
                            .frame(width: 2, height: 14)
                            .padding(.trailing, 8)
                        Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.trailing, 4)
                        Text(section.title)
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(sectionColor)
                        Text("\(section.tasks.count)")
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .foregroundColor(sectionColor.opacity(0.6))
                            .padding(.leading, 4)
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 5)
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 0) {
                    RoundedRectangle(cornerRadius: 1)
                        .fill(sectionColor)
                        .frame(width: 2, height: 14)
                        .padding(.trailing, 8)
                    Text(sectionLabel)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(sectionColor)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 5)
            }

            // Tasks
            if section.type != .completed || isExpanded {
                VStack(spacing: 0) {
                    ForEach(section.tasks) { task in
                        TaskRowView(
                            task: task,
                            sectionColor: sectionColor,
                            isSelected: selectedTaskId == task.id,
                            onToggle: { onToggleTask(task) },
                            onSelect: { onSelectTask(task) }
                        )
                    }
                }
            }
        }
    }

    private var sectionLabel: String {
        switch section.type {
        case .carryOver: return "持ち越し ⚠️"
        case .highest: return "最優先"
        case .normal: return "通常"
        case .optional: return "余裕があれば"
        case .completed: return section.title
        }
    }
}
