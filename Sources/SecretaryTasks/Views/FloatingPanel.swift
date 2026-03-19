import AppKit

class FloatingPanel: NSPanel {

    init(contentRect: NSRect) {
        super.init(
            contentRect: contentRect,
            styleMask: [.nonactivatingPanel, .fullSizeContentView, .borderless],
            backing: .buffered,
            defer: false
        )

        level = .floating
        isMovableByWindowBackground = true
        hasShadow = true
        hidesOnDeactivate = false
        isOpaque = false
        backgroundColor = .clear
        collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        appearance = NSAppearance(named: .darkAqua)

        // Restore saved position
        if let x = UserDefaults.standard.object(forKey: "windowOriginX") as? CGFloat,
           let y = UserDefaults.standard.object(forKey: "windowOriginY") as? CGFloat {
            setFrameOrigin(NSPoint(x: x, y: y))
        }
    }

    override func setFrame(_ frameRect: NSRect, display displayFlag: Bool, animate animateFlag: Bool) {
        super.setFrame(frameRect, display: displayFlag, animate: animateFlag)
        savePosition()
    }

    override func setFrame(_ frameRect: NSRect, display flag: Bool) {
        super.setFrame(frameRect, display: flag)
        savePosition()
    }

    override func setFrameOrigin(_ point: NSPoint) {
        super.setFrameOrigin(point)
        savePosition()
    }

    private func savePosition() {
        UserDefaults.standard.set(frame.origin.x, forKey: "windowOriginX")
        UserDefaults.standard.set(frame.origin.y, forKey: "windowOriginY")
    }
}
