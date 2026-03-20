import SwiftUI

struct DispatchPreviewView: View {
    let fileName: String
    let content: String
    let onClose: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: "doc.text")
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.4))
                Text(shortFileName)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
                    .truncationMode(.middle)

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.gray.opacity(0.6))
                        .padding(4)
                        .background(Color.white.opacity(0.05))
                        .clipShape(Circle())
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)

            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)

            // Scrollable body
            ScrollView(.vertical, showsIndicators: false) {
                Text(MarkdownRenderer.render(content))
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.85))
                    .textSelection(.enabled)
                    .padding(14)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(width: 400)
    }

    private var shortFileName: String {
        (fileName as NSString).lastPathComponent
    }
}
