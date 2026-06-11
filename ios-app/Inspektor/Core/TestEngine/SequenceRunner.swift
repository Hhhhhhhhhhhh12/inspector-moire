import Foundation

enum SequencePhase: Equatable {
    case idle
    case armed    // first frame visible, timer not started — DIT sets slate
    case running
    case paused
    case done
}

@MainActor
final class SequenceRunner: ObservableObject {
    struct ResolvedTest {
        let definition: TestDefinition
        let duration:   Int  // effective seconds (step override or definition default)
    }

    @Published private(set) var resolvedTests: [ResolvedTest] = []
    @Published private(set) var currentIndex:  Int = 0
    @Published private(set) var phase: SequencePhase = .idle

    private var advanceTask: Task<Void, Never>?

    // MARK: - Accessors

    var currentTest: TestDefinition? {
        resolvedTests.indices.contains(currentIndex) ? resolvedTests[currentIndex].definition : nil
    }

    var currentDuration: Int {
        resolvedTests.indices.contains(currentIndex) ? resolvedTests[currentIndex].duration : 10
    }

    var progress: Double {
        resolvedTests.isEmpty ? 0 : Double(currentIndex + 1) / Double(resolvedTests.count)
    }

    // MARK: - Load

    func load(sequence: TestSequence, definitions: [TestDefinition]) {
        resolvedTests = sequence.resolvedSteps.compactMap { (id, override) in
            guard let def = definitions.first(where: { $0.id == id }) else { return nil }
            return ResolvedTest(definition: def, duration: override ?? def.durationSeconds)
        }
        currentIndex = 0
        phase = .idle
    }

    // Kept for backward compat (PreTestReminderView may still call this path)
    func load(testIds: [String], definitions: [TestDefinition]) {
        resolvedTests = testIds.compactMap { id in
            guard let def = definitions.first(where: { $0.id == id }) else { return nil }
            return ResolvedTest(definition: def, duration: def.durationSeconds)
        }
        currentIndex = 0
        phase = .idle
    }

    // MARK: - Pre-roll / start

    /// Show first frame immediately; timer waits for triggerStart().
    func arm() {
        guard !resolvedTests.isEmpty else { return }
        currentIndex = 0
        phase = .armed
    }

    /// Called by tap or voice "start" while armed — begins auto-advance.
    func triggerStart() {
        guard phase == .armed else { return }
        phase = .running
        scheduleAdvance()
    }

    // MARK: - Control

    func stop() {
        advanceTask?.cancel()
        phase = .done
    }

    func pause() {
        guard phase == .running else { return }
        phase = .paused
        advanceTask?.cancel()
    }

    func resume() {
        guard phase == .paused else { return }
        phase = .running
        scheduleAdvance()
    }

    func next() {
        advanceTask?.cancel()
        if currentIndex < resolvedTests.count - 1 {
            currentIndex += 1
            if phase == .running { scheduleAdvance() }
        } else {
            stop()
        }
    }

    func previous() {
        advanceTask?.cancel()
        guard currentIndex > 0 else { return }
        currentIndex -= 1
        if phase == .running { scheduleAdvance() }
    }

    // MARK: - Private

    private func scheduleAdvance() {
        let duration = currentDuration
        advanceTask = Task { [weak self] in
            try? await Task.sleep(for: .seconds(duration))
            guard !Task.isCancelled else { return }
            self?.next()
        }
    }
}
