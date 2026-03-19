import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TodoViewModel
    @State private var completedExpanded = false

    var body: some View {
        HStack(spacing: 0) {
            // Left: Task list
            taskListView
                .frame(width: 320)

            // Right: Preview panel (when a task with linkedFilePath is selected)
            if let task = viewModel.selectedTask,
               task.linkedFilePath != nil,
               let content = viewModel.dispatchContentRaw {
                Divider()
                    .background(Color.gray.opacity(0.3))

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
        .background(Color.black.opacity(0.85))
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
                HStack {
                    Text("\(todo.date) \(todo.dayOfWeek)")
                        .font(.system(size: 15, weight: .bold))
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.top, 10)
                .padding(.bottom, 6)
            }

            if let todo = viewModel.dailyTodo {
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        ForEach(todo.sections) { section in
                            if !section.tasks.isEmpty {
                                SectionView(
                                    section: section,
                                    isExpanded: completedExpanded,
                                    onToggleExpand: { completedExpanded.toggle() },
                                    onToggleTask: { task in viewModel.toggleTask(task) },
                                    onSelectTask: { task in
                                        if task.linkedFilePath != nil {
                                            if viewModel.selectedTask?.id == task.id {
                                                // Re-tap same task: close preview
                                                viewModel.selectedTask = nil
                                                viewModel.dispatchContentRaw = nil
                                            } else {
                                                viewModel.selectTask(task)
                                            }
                                        }
                                    }
                                )
                            }
                        }
                    }
                    .padding(.bottom, 12)
                }
            } else {
                Spacer()
                HStack {
                    Spacer()
                    Text("No tasks for today")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                    Spacer()
                }
                Spacer()
            }
        }
    }

    private func notifyPanelResize(expanded: Bool) {
        let width: CGFloat = expanded ? 720 : 320
        if let appDelegate = NSApp.delegate as? AppDelegate {
            appDelegate.resizePanel(width: width)
        }
    }
}
