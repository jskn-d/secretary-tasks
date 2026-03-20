import SwiftUI

@main
struct SecretaryTasksApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("Secretary Tasks", systemImage: "checklist") {
            Button("Show/Hide") { appDelegate.togglePanel() }
            Divider()
            Button("Settings...") { appDelegate.openSettings() }
            Divider()
            Button("Quit") { NSApp.terminate(nil) }
        }
    }
}
