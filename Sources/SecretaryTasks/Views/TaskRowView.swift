import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let sectionColor: Color
    var isSelected: Bool = false
    let onToggle: () -> Void
    let onSelect: () -> Void

    @State private var isHovered = false
    @State private var checkScale: CGFloat = 1.0

    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            // Custom checkbox
            Button(action: {
                withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                    checkScale = 0.8
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.6)) {
                        checkScale = 1.0
                    }
                }
                onToggle()
            }) {
                ZStack {
                    if task.isCompleted {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .fill(sectionColor.opacity(0.5))
                            .frame(width: 16, height: 16)
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(.white)
                    } else {
                        RoundedRectangle(cornerRadius: 4, style: .continuous)
                            .stroke(sectionColor.opacity(0.4), lineWidth: 1.5)
                            .frame(width: 16, height: 16)
                    }
                }
                .scaleEffect(checkScale)
                .frame(width: 28, height: 28)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Task text
            if task.linkedFilePath != nil {
                Button(action: onSelect) {
                    HStack(spacing: 4) {
                        taskText
                        Spacer(minLength: 4)
                        Image(systemName: "arrow.up.right")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundColor(.white.opacity(isHovered ? 0.5 : 0.35))
                    }
                }
                .buttonStyle(.plain)
            } else {
                taskText
                Spacer()
            }
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 16)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(backgroundColor)
                .padding(.horizontal, 8)
        )
        .onHover { hovering in
            isHovered = hovering
        }
    }

    @ViewBuilder
    private var taskText: some View {
        if task.isCompleted {
            Text(task.displayText)
                .strikethrough(color: .gray.opacity(0.5))
                .foregroundColor(.white.opacity(0.3))
                .font(.system(size: 13))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(task.displayText)
                .foregroundColor(.white.opacity(0.9))
                .font(.system(size: 13))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.white.opacity(0.1)
        } else if isHovered {
            return Color.white.opacity(0.05)
        }
        return .clear
    }
}
