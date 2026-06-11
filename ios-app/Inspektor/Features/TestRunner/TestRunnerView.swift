import SwiftUI

struct TestRunnerView: View {
    @EnvironmentObject private var runner: SequenceRunner
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let test = runner.currentTest {
                testCanvas(for: test)
                    .id(runner.currentIndex)
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.35), value: runner.currentIndex)
            }
        }
        .ignoresSafeArea()
        .statusBarHidden(true)
        .persistentSystemOverlays(.hidden)
        .onAppear {
            DisplayManager.shared.setMaxBrightness()
            DisplayManager.shared.disableAutoLock()
            runner.start()
        }
        .onDisappear {
            DisplayManager.shared.restoreBrightness()
            DisplayManager.shared.enableAutoLock()
            runner.stop()
        }
        .onChange(of: runner.isRunning) { _, running in
            if !running { dismiss() }
        }
        .onTapGesture {
            // Tap aborts the sequence early.
            dismiss()
        }
    }

    @ViewBuilder
    private func testCanvas(for test: TestDefinition) -> some View {
        switch test.renderer {
        case .fullField:
            test.params.swiftUIColor
                .ignoresSafeArea()
        default:
            // TODO (Session 3): Metal renderer for splitQuadrants, grayWedge, etc.
            Color.black.ignoresSafeArea()
                .overlay {
                    Text(test.renderer.rawValue)
                        .font(.system(size: 14, design: .monospaced))
                        .foregroundStyle(.white.opacity(0.3))
                }
        }
    }
}
