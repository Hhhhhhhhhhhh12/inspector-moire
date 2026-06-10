import UIKit

// TODO (Session 2): Add heuristic self-test for True Tone / Night Shift detection.
@MainActor
final class DisplayManager {
    static let shared = DisplayManager()
    private var previousBrightness: CGFloat = 0.5

    private init() {}

    func setMaxBrightness() {
        previousBrightness = UIScreen.main.brightness
        UIScreen.main.brightness = 1.0
    }

    func restoreBrightness() {
        UIScreen.main.brightness = previousBrightness
    }

    func disableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = true
    }

    func enableAutoLock() {
        UIApplication.shared.isIdleTimerDisabled = false
    }
}
