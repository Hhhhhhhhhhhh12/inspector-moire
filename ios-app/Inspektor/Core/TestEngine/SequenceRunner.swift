import Foundation

@MainActor
final class SequenceRunner: ObservableObject {
    @Published private(set) var tests: [TestDefinition] = []
    @Published private(set) var currentIndex: Int = 0
    @Published private(set) var isRunning: Bool = false
    @Published private(set) var isPaused: Bool = false

    private var advanceTask: Task<Void, Never>?

    var currentTest: TestDefinition? {
        tests.indices.contains(currentIndex) ? tests[currentIndex] : nil
    }

    var progress: Double {
        tests.isEmpty ? 0 : Double(currentIndex + 1) / Double(tests.count)
    }

    func load(testIds: [String], definitions: [TestDefinition]) {
        tests = testIds.compactMap { id in definitions.first { $0.id == id } }
        currentIndex = 0
    }

    func start() {
        guard !tests.isEmpty else { return }
        isRunning = true
        scheduleAdvance()
    }

    func stop() {
        advanceTask?.cancel()
        isRunning = false
    }

    func pause() {
        isPaused = true
        advanceTask?.cancel()
    }

    func resume() {
        guard isRunning else { return }
        isPaused = false
        scheduleAdvance()
    }

    func next() {
        advanceTask?.cancel()
        if currentIndex < tests.count - 1 {
            currentIndex += 1
            if isRunning && !isPaused { scheduleAdvance() }
        } else {
            stop()
        }
    }

    func previous() {
        advanceTask?.cancel()
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        if isRunning && !isPaused { scheduleAdvance() }
    }

    private func scheduleAdvance() {
        guard let current = currentTest else { return }
        let duration = current.durationSeconds
        advanceTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            self?.next()
        }
    }
}
