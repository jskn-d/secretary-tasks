import Foundation
import SwiftUI

@MainActor
class TodoViewModel: ObservableObject {
    @Published var dailyTodo: DailyTodo?
    @Published var selectedTask: TaskItem?
    @Published var dispatchContentRaw: String?

    private let parser = MarkdownTodoParser()
    private let writer = MarkdownTodoWriter()
    private var fileWatcher: FileWatcher?
    private var isSelfTriggeredWrite = false
    private var dateRolloverTimer: Timer?
    private var currentDateString: String = ""

    func loadTodo() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let todayString = dateFormatter.string(from: Date())
        currentDateString = todayString

        let filePath = Configuration.shared.todosDirectory + "/" + todayString + ".md"

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
        fileWatcher = FileWatcher(directoryPath: Configuration.shared.todosDirectory) { [weak self] in
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
            dispatchContentRaw = nil
            return
        }

        let fullPath = Configuration.shared.secretaryBaseDirectory + "/" + linkedPath

        guard let content = try? String(contentsOfFile: fullPath, encoding: .utf8) else {
            dispatchContentRaw = nil
            return
        }

        dispatchContentRaw = content
    }

    func startDateRolloverTimer() {
        dateRolloverTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self = self else { return }
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let now = dateFormatter.string(from: Date())
                if now != self.currentDateString {
                    self.selectedTask = nil
                    self.dispatchContentRaw = nil
                    self.loadTodo()
                }
            }
        }
    }
}
