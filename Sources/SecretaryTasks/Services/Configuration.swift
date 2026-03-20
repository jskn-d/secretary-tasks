import Foundation

@MainActor
class Configuration: ObservableObject {
    static let shared = Configuration()

    @Published var secretaryBaseDirectory: String {
        didSet { save() }
    }
    var todosDirectory: String { secretaryBaseDirectory + "/todos" }

    private static let configDir = NSHomeDirectory() + "/.config/secretary-tasks"
    private static let configPath = configDir + "/config.json"

    private init() {
        if let data = FileManager.default.contents(atPath: Self.configPath),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let base = json["secretaryBaseDirectory"] as? String {
            secretaryBaseDirectory = (base as NSString).expandingTildeInPath
        } else {
            secretaryBaseDirectory = NSHomeDirectory() + "/.secretary"
        }
    }

    func save() {
        let fm = FileManager.default
        try? fm.createDirectory(atPath: Self.configDir, withIntermediateDirectories: true)
        let dict: [String: Any] = ["secretaryBaseDirectory": secretaryBaseDirectory]
        if let data = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            fm.createFile(atPath: Self.configPath, contents: data)
        }
    }
}
