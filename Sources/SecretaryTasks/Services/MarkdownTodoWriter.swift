import Foundation

struct MarkdownTodoWriter {

    enum WriteError: Error {
        case fileReadFailed
        case lineIndexOutOfRange
        case lineNotATask
        case writeFailed
    }

    func toggleTask(at lineIndex: Int, in filePath: String) throws {
        guard let content = try? String(contentsOfFile: filePath, encoding: .utf8) else {
            throw WriteError.fileReadFailed
        }

        var lines = content.components(separatedBy: "\n")

        guard lineIndex >= 0 && lineIndex < lines.count else {
            throw WriteError.lineIndexOutOfRange
        }

        let line = lines[lineIndex]
        let trimmed = line.trimmingCharacters(in: .whitespaces)

        if trimmed.hasPrefix("- [ ] ") {
            lines[lineIndex] = line.replacingOccurrences(of: "- [ ] ", with: "- [x] ")
        } else if trimmed.hasPrefix("- [x] ") {
            lines[lineIndex] = line.replacingOccurrences(of: "- [x] ", with: "- [ ] ")
        } else {
            throw WriteError.lineNotATask
        }

        let newContent = lines.joined(separator: "\n")
        let url = URL(fileURLWithPath: filePath)

        do {
            try newContent.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw WriteError.writeFailed
        }
    }
}
