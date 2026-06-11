import SwiftUI

struct TestRunnerView: View {
    @EnvironmentObject private var runner:   SequenceRunner
    @EnvironmentObject private var settings: SettingsModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let test = runner.currentTest {
                testCanvas(for: test)
                    .id(runner.currentIndex)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.3), value: runner.currentIndex)

                if test.renderer == .marker {
                    markerOverlay(test.params.markerText ?? test.name)
                }
            }

            if runner.phase == .armed {
                armOverlay
            }
        }
        .ignoresSafeArea()
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .onAppear {
            DisplayManager.shared.setMaxBrightness()
            DisplayManager.shared.disableAutoLock()
            runner.arm()
        }
        .onDisappear {
            DisplayManager.shared.restoreBrightness()
            DisplayManager.shared.enableAutoLock()
            if runner.phase != .done { runner.stop() }
        }
        .onChange(of: runner.phase) { _, phase in
            if phase == .done { dismiss() }
        }
        .onTapGesture {
            switch runner.phase {
            case .armed:   runner.triggerStart()
            case .running: dismiss()
            default:       dismiss()
            }
        }
    }

    // MARK: - Sub-views

    @ViewBuilder
    private func testCanvas(for test: TestDefinition) -> some View {
        MetalView(test: test, colorSpace: settings.colorSpace)
            .ignoresSafeArea()
    }

    // Monospace text overlay for marker frames (test name on black bg).
    // The black bg is rendered by Metal (fullField mode fallback); text is SwiftUI.
    private func markerOverlay(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 44, weight: .bold, design: .monospaced))
            .tracking(2)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(32)
    }

    // Minimal tap-to-start prompt shown during armed (pre-roll) state.
    // Disappears as soon as the sequence starts — no overlay during actual tests.
    private var armOverlay: some View {
        VStack {
            Spacer()
            Text("Tap to Start")
                .font(.system(size: 13, weight: .semibold, design: .monospaced))
                .tracking(1.5)
                .foregroundStyle(Color.white.opacity(0.35))
                .padding(.bottom, 48)
        }
    }
}
