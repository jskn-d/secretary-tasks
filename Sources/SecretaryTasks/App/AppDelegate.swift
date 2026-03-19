import AppKit
import SwiftUI

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {

    private var panel: FloatingPanel?
    private let viewModel = TodoViewModel()

    func applicationDidFinishLaunching(_ notification: Notification) {
        NSApp.setActivationPolicy(.accessory)
        setupPanel()
        viewModel.loadTodo()
        viewModel.startWatching()
        viewModel.startDateRolloverTimer()
    }

    private func setupPanel() {
        let panel = FloatingPanel(contentRect: NSRect(x: 0, y: 0, width: 320, height: 500))

        let contentView = ContentView()
            .environmentObject(viewModel)

        panel.contentView = NSHostingView(rootView: contentView)

        // Center on screen if no saved position
        if UserDefaults.standard.object(forKey: "windowOriginX") == nil {
            panel.center()
        }

        self.panel = panel
        panel.orderFront(nil)
    }

    func togglePanel() {
        guard let panel = panel else { return }
        if panel.isVisible {
            panel.orderOut(nil)
        } else {
            panel.orderFront(nil)
        }
    }

    func resizePanel(width: CGFloat) {
        guard let panel = panel else { return }
        var frame = panel.frame
        let oldWidth = frame.size.width
        frame.size.width = width
        // Keep right edge stationary if expanding, left edge if shrinking
        if width > oldWidth {
            // no origin change needed for left-anchored
        }
        panel.setFrame(frame, display: true, animate: true)
    }
}
