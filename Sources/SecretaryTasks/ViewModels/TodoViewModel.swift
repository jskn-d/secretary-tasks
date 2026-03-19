import Foundation
import SwiftUI

@MainActor
class TodoViewModel: ObservableObject {
    @Published var dailyTodo: DailyTodo?
    @Published var selectedTask: TaskItem?
    @Published var dispatchContent: AttributedString?

    private let parser = MarkdownTodoParser()
    private let writer = MarkdownTodoWriter()
    private var fileWatcher: FileWatcher?
    private var isSelfTriggeredWrite = false

    func loadTodo() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())

        let filePath = Configuration.todosDirectory + "/" + todayString + ".md"

        guard FileManager.default.fileExists(atPath: filePath) else {
            dailyTodo = nil
            return
        }

        dailyTodo = parser.parse(filePath: filePath)
    }

    func toggleTask(_ task: TaskItem) {
        guard let filePath = dailyTodo?.filePath else { return }

        isSelfTriggeredWrite = true

        do {
            try writer.toggleTask(at: task.lineIndex, in: filePath)
        } catch {
            isSelfTriggeredWrite = false
            return
        }

        dailyTodo = parser.parse(filePath: filePath)
        isSelfTriggeredWrite = false
    }

    func startWatching() {
        fileWatcher = FileWatcher(directoryPath: Configuration.todosDirectory) { [weak self] in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                if self.isSelfTriggeredWrite {
                    return
                }
                self.loadTodo()
            }
        }
        fileWatcher?.start()
    }

    func selectTask(_ task: TaskItem) {
        selectedTask = task

        guard let linkedPath = task.linkedFilePath else {
            dispatchContent = nil
            return
        }

        let fullPath = Configuration.secretaryBaseDirectory + "/" + linkedPath

        guard let content = try? String(contentsOfFile: fullPath, encoding: .utf8) else {
            dispatchContent = nil
            return
        }

        dispatchContent = try? AttributedString(markdown: content)
    }
}
