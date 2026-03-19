import Foundation
import SwiftUI

struct MarkdownRenderer {

    static func render(_ markdown: String) -> AttributedString {
        // Use Swift's built-in markdown parser
        if let result = try? AttributedString(markdown: markdown, options: .init(interpretedSyntax: .inlineOnlyPreservingWhitespace)) {
            return result
        }

        // Fallback: return plain text
        return AttributedString(markdown)
    }
}
