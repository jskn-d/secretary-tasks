import SwiftUI

struct TaskRowView: View {
    let task: TaskItem
    let onToggle: () -> Void
    let onSelect: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            // Checkbox
            Button(action: onToggle) {
                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 14))
                    .foregroundColor(task.isCompleted ? .green : .gray)
            }
            .buttonStyle(.plain)

            // Task text
            if task.linkedFilePath != nil {
                Button(action: onSelect) {
                    taskText
                }
                .buttonStyle(.plain)
            } else {
                taskText
            }

            Spacer()
        }
        .padding(.vertical, 2)
        .padding(.horizontal, 8)
    }

    @ViewBuilder
    private var taskText: some View {
        if task.isCompleted {
            Text(task.displayText)
                .strikethrough()
                .foregroundColor(.gray.opacity(0.6))
                .font(.system(size: 13))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        } else {
            Text(task.displayText)
                .foregroundColor(.white)
                .font(.system(size: 13))
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
