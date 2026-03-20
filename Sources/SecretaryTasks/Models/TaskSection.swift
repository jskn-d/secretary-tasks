import Foundation
import SwiftUI

enum SectionType: String, CaseIterable {
    case carryOver = "持ち越し ⚠️"
    case highest = "最優先"
    case normal = "通常"
    case optional = "余裕があれば"
    case completed = "完了"

    var color: Color {
        switch self {
        case .carryOver: return Color(red: 0.4, green: 0.85, blue: 1.0)
        case .highest:   return Color(red: 0.9, green: 0.45, blue: 0.7)
        case .normal:    return Color(red: 0.5, green: 0.7, blue: 1.0)
        case .optional:  return Color(red: 0.6, green: 0.6, blue: 0.7)
        case .completed: return Color(red: 0.4, green: 0.4, blue: 0.45)
        }
    }
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
