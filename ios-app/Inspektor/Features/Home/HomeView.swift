import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var engine: TestEngine
    @State private var selectedTest: TestDefinition?

    var body: some View {
        NavigationStack {
            VStack(spacing: 32) {
                Spacer()

                Text("Inspektor")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)

                Button("Test starten") {
                    selectedTest = engine.definitions.first
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(engine.definitions.isEmpty)

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            .navigationBarHidden(true)
        }
        .fullScreenCover(item: $selectedTest) { test in
            TestRunnerView(test: test)
                .environmentObject(engine)
        }
    }
}
