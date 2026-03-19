import Foundation

struct MarkdownTodoParser {

    func parse(filePath: String) -> DailyTodo? {
        guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            return nil
        }

        let lines = content.components(separatedBy: "\n")
        var date = ""
        var dayOfWeek = ""
        var sections: [TaskSection] = []
        var currentSectionType: SectionType?
        var currentTasks: [TaskItem] = []
        var inFrontmatter = false

        for (lineIndex, line) in lines.enumerated() {
            // Handle frontmatter
            if lineIndex == 0 && line.trimmingCharacters(in: .whitespaces) == "---" {
                inFrontmatter = true
                continue
            }
            if inFrontmatter {
                if line.trimmingCharacters(in: .whitespaces) == "---" {
                    inFrontmatter = false
                }
                continue
            }

            let trimmed = line.trimmingCharacters(in: .whitespaces)

            // Stop at memo section
            if trimmed.hasPrefix("## メモ・振り返り") {
                break
            }

            // Parse H1 for date and day of week
            if trimmed.hasPrefix("# ") && !trimmed.hasPrefix("## ") {
                let header = String(trimmed.dropFirst(2))
                parseH1(header, date: &date, dayOfWeek: &dayOfWeek)
                continue
            }

            // Parse H2 for section
            if trimmed.hasPrefix("## ") {
                // Save previous section
                if let sectionType = currentSectionType {
                    sections.append(TaskSection(type: sectionType, tasks: currentTasks))
                    currentTasks = []
                }
                let sectionName = String(trimmed.dropFirst(3))
                currentSectionType = SectionType.allCases.first { $0.rawValue == sectionName }
                continue
            }

            // Parse task lines
            if currentSectionType != nil {
                if let task = parseTaskLine(line: trimmed, lineIndex: lineIndex) {
                    currentTasks.append(task)
                }
            }
        }

        // Save last section
        if let sectionType = currentSectionType {
            sections.append(TaskSection(type: sectionType, tasks: currentTasks))
        }

        return DailyTodo(
            date: date,
            dayOfWeek: dayOfWeek,
            sections: sections,
            filePath: filePath
        )
    }

    private func parseH1(_ header: String, date: inout String, dayOfWeek: inout String) {
        // Expected format: "2026-03-19 (木)"
        let parts = header.trimmingCharacters(in: .whitespaces)
        if let parenRange = parts.range(of: "(") {
            date = String(parts[parts.startIndex..<parenRange.lowerBound]).trimmingCharacters(in: .whitespaces)
            // Extract "(木)" including parentheses
            let rest = String(parts[parenRange.lowerBound...])
            if let closeRange = rest.range(of: ")") {
                dayOfWeek = String(rest[rest.startIndex...closeRange.lowerBound])
            }
        } else {
            date = parts
        }
    }

    private func parseTaskLine(line: String, lineIndex: Int) -> TaskItem? {
        let isCompleted: Bool
        let content: String

        if line.hasPrefix("- [x] ") {
            isCompleted = true
            content = String(line.dropFirst(6))
        } else if line.hasPrefix("- [ ] ") {
            isCompleted = false
            content = String(line.dropFirst(6))
        } else {
            return nil
        }

        // Skip placeholder lines
        if content.contains("(完了したらここに移動)") {
            return nil
        }

        // Split by pipe to get display text and metadata
        let segments = content.components(separatedBy: " | ")
        let displayText = segments[0].trimmingCharacters(in: .whitespaces)

        // Skip empty tasks
        if displayText.isEmpty {
            return nil
        }

        // Extract linked file path from metadata
        var linkedFilePath: String?
        for segment in segments.dropFirst() {
            let trimmedSegment = segment.trimmingCharacters(in: .whitespaces)
            if trimmedSegment.hasPrefix("ディスパッチ: ") {
                linkedFilePath = String(trimmedSegment.dropFirst("ディスパッチ: ".count))
                    .trimmingCharacters(in: .whitespaces)
            } else if trimmedSegment.hasPrefix("手順: ") {
                linkedFilePath = String(trimmedSegment.dropFirst("手順: ".count))
                    .trimmingCharacters(in: .whitespaces)
            }
        }

        return TaskItem(
            isCompleted: isCompleted,
            displayText: displayText,
            lineIndex: lineIndex,
            linkedFilePath: linkedFilePath
        )
    }
}
