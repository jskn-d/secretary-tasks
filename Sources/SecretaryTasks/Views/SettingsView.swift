import SwiftUI

struct SettingsView: View {
    @ObservedObject var configuration: Configuration
    @State private var pathText: String = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Settings")
                .font(.headline)

            VStack(alignment: .leading, spacing: 6) {
                Text("Secretary Directory")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                HStack(spacing: 8) {
                    TextField("~/.secretary", text: $pathText)
                        .textFieldStyle(.roundedBorder)

                    Button("Browse...") {
                        let panel = NSOpenPanel()
                        panel.canChooseFiles = false
                        panel.canChooseDirectories = true
                        panel.allowsMultipleSelection = false
                        if panel.runModal() == .OK, let url = panel.url {
                            pathText = url.path
                        }
                    }
                }

                Text("Folder containing the `todos/` directory.")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            HStack {
                Spacer()
                Button("Apply") {
                    let trimmed = pathText.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty {
                        configuration.secretaryBaseDirectory = (trimmed as NSString).expandingTildeInPath
                    }
                }
                .keyboardShortcut(.return)
            }
        }
        .padding(20)
        .frame(width: 420)
        .onAppear {
            pathText = configuration.secretaryBaseDirectory
        }
    }
}
