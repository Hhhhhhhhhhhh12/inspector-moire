import SwiftUI

struct TestRunnerView: View {
    @EnvironmentObject private var engine: TestEngine
    @Environment(\.dismiss) private var dismiss

    let test: TestDefinition

    var body: some View {
        ZStack {
            if engine.isRunning {
                fullScreenTestView
            }
        }
        .ignoresSafeArea()
        .onAppear {
            DisplayManager.shared.setMaxBrightness()
            DisplayManager.shared.disableAutoLock()
            engine.start(test: test)
        }
        .onDisappear {
            DisplayManager.shared.restoreBrightness()
            DisplayManager.shared.enableAutoLock()
            engine.stop()
        }
    }

    @ViewBuilder
    private var fullScreenTestView: some View {
        switch test.renderer {
        case .fullField:
            engine.fullFieldView(for: test)
                .ignoresSafeArea()
                .onTapGesture { endTest() }
        default:
            // TODO (Session 2): Implement remaining renderer types with Metal.
            Color.black
                .ignoresSafeArea()
                .onTapGesture { endTest() }
                .overlay {
                    Text("Renderer \(test.renderer.rawValue) — kommt in Session 2")
                        .foregroundStyle(.white)
                }
        }
    }

    private func endTest() {
        dismiss()
    }
}
