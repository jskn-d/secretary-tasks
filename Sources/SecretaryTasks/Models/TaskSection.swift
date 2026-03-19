import Foundation

enum SectionType: String, CaseIterable {
    case carryOver = "持ち越し ⚠️"
    case highest = "最優先"
    case normal = "通常"
    case optional = "余裕があれば"
    case completed = "完了"
}

struct TaskSection: Identifiable {
    let id: UUID
    let type: SectionType
    var tasks: [TaskItem]

    var title: String { type.rawValue }

    init(id: UUID = UUID(), type: SectionType, tasks: [TaskItem] = []) {
        self.id = id
        self.type = type
        self.tasks = tasks
    }
}
