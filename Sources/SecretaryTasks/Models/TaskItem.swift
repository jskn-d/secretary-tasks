import Foundation

struct TaskItem: Identifiable {
    let id: UUID
    var isCompleted: Bool
    var displayText: String
    var lineIndex: Int
    var linkedFilePath: String?

    init(
        id: UUID = UUID(),
        isCompleted: Bool,
        displayText: String,
        lineIndex: Int,
        linkedFilePath: String? = nil
    ) {
        self.id = id
        self.isCompleted = isCompleted
        self.displayText = displayText
        self.lineIndex = lineIndex
        self.linkedFilePath = linkedFilePath
    }
}
