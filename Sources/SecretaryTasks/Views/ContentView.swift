import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var completedExpanded = false

    var body: some View {
        HStack(spacing: 0) {
            taskListView
                .frame(width: 320)

            if let task = viewModel.selectedTask,
               task.linkedFilePath != nil,
               let content = viewModel.dispatchContentRaw {
                Rectangle()
                    .fill(Color.white.opacity(0.08))
                    .frame(width: 1)

                DispatchPreviewView(
                    fileName: task.linkedFilePath ?? "",
                    content: content,
                    onClose: {
                        viewModel.selectedTask = nil
                        viewModel.dispatchContentRaw = nil
                        notifyPanelResize(expanded: false)
                    }
                )
                .transition(.move(edge: .trailing))
            }
        }
        .background(VisualEffectView(material: .hudWindow, blendingMode: .behindWindow))
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .onChange(of: viewModel.selectedTask?.id) { _ in
            let expanded = viewModel.selectedTask?.linkedFilePath != nil && viewModel.dispatchContentRaw != nil
            notifyPanelResize(expanded: expanded)
        }
    }

    @ViewBuilder
    private var taskListView: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Date header
            if let todo = viewModel.dailyTodo {
                dateHeader(todo: todo)
            }

            if let todo = viewModel.dailyTodo {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 2) {
                        ForEach(Array(todo.sections.enumerated()), id: \.element.id) { index, section in
                            if !section.tasks.isEmpty {
                                if index > 0 && !isFirstVisibleSection(section, in: todo.sections) {
                                    Rectangle()
                                        .fill(Color.white.opacity(0.06))
                                        .frame(height: 1)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 4)
                                }

                                SectionView(
                                    section: section,
                                    isExpanded: completedExpanded,
                                    onToggleExpand: { completedExpanded.toggle() },
                                    onToggleTask: { task in viewModel.toggleTask(task) },
                                    onSelectTask: { task in
                                        if task.linkedFilePath != nil {
                                            if viewModel.selectedTask?.id == task.id {
                                                viewModel.selectedTask = nil
                                                viewModel.dispatchContentRaw = nil
                                            } else {
                                                viewModel.selectTask(task)
                                            }
                                        }
                                    },
                                    selectedTaskId: viewModel.selectedTask?.id
                                )
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            } else {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 8) {
                        Image(systemName: "tray")
                            .font(.system(size: 28))
                            .foregroundColor(.gray.opacity(0.5))
                        Text("No tasks for today")
                            .font(.system(size: 13))
                            .foregroundColor(.gray.opacity(0.6))
                    }
                    Spacer()
                }
                Spacer()
            }
        }
    }

    @ViewBuilder
    private func dateHeader(todo: DailyTodo) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 6) {
            Text(todo.dayOfWeek)
                .font(.system(size: 13))
                .foregroundColor(.white.opacity(0.4))
            Spacer()
            // Task count badge
            let remaining = todo.sections
                .filter { $0.type != .completed }
                .flatMap { $0.tasks }
                .filter { !$0.isCompleted }
                .count
            if remaining > 0 {
                Text("残 \(remaining)")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.white.opacity(0.35))
            }
            Text(formatDate(todo.date))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundColor(.white.opacity(0.9))
        }
        .padding(.horizontal, 16)
        .padding(.top, 14)
        .padding(.bottom, 10)
    }

    private func formatDate(_ dateStr: String) -> String {
        // "2026-03-21" → "3/21"
        let parts = dateStr.split(separator: "-")
        guard parts.count == 3,
              let month = Int(parts[1]),
              let day = Int(parts[2]) else { return dateStr }
        return "\(month)/\(day)"
    }

    private func isFirstVisibleSection(_ section: TaskSection, in sections: [TaskSection]) -> Bool {
        guard let first = sections.first(where: { !$0.tasks.isEmpty }) else { return false }
        return first.id == section.id
    }

    private func notifyPanelResize(expanded: Bool) {
        let width: CGFloat = expanded ? 720 : 320
        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.resizePanel(width: width)
        }
    }
}
