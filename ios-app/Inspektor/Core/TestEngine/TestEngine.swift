import Foundation
import SwiftUI

@MainActor
final class TestEngine: ObservableObject {
    @Published private(set) var definitions: [TestDefinition] = []
    @Published private(set) var currentTest: TestDefinition?
    @Published private(set) var isRunning = false

    func loadDefinitions() {
        guard let url = Bundle.main.url(forResource: "test_definitions", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            return
        }
        definitions = (try? JSONDecoder().decode([TestDefinition].self, from: data)) ?? []
    }

    func start(test: TestDefinition) {
        currentTest = test
        isRunning = true
    }

    func stop() {
        isRunning = false
        currentTest = nil
    }

    // Returns the SwiftUI view content for a fullField renderer.
    func fullFieldView(for test: TestDefinition) -> Color {
        test.params.swiftUIColor
    }
}
