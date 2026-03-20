import Foundation

struct Configuration {
    static let shared = Configuration()

    let secretaryBaseDirectory: String
    var todosDirectory: String { secretaryBaseDirectory + "/todos" }

    private init() {
        let configPath = NSHomeDirectory() + "/.config/secretary-tasks/config.json"
        if let data = FileManager.default.contents(atPath: configPath),
           let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
           let base = json["secretaryBaseDirectory"] as? String {
            secretaryBaseDirectory = (base as NSString).expandingTildeInPath
        } else {
            secretaryBaseDirectory = NSHomeDirectory() + "/.secretary"
        }
    }
}
