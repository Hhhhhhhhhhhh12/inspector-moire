import Foundation
import SwiftUI

@MainActor
final class TestEngine: ObservableObject {
    @Published private(set) var definitions: [TestDefinition] = []
    @Published private(set) var cameraProfiles: [CameraProfile] = []

    func loadAll() {
        loadDefinitions()
        loadCameraProfiles()
    }

    func profiles(for manufacturer: String) -> [CameraProfile] {
        cameraProfiles.filter { $0.manufacturer == manufacturer }
    }

    func sequence(for mode: TestMode) -> TestSequence? {
        guard let name = mode.sequenceResourceName,
              let url = Bundle.main.url(forResource: name, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(TestSequence.self, from: data)
    }

    private func loadDefinitions() {
        definitions = load("test_definitions", as: [TestDefinition].self) ?? []
    }

    private func loadCameraProfiles() {
        cameraProfiles = load("camera_profiles", as: [CameraProfile].self) ?? []
    }

    private func load<T: Decodable>(_ resource: String, as type: T.Type) -> T? {
        guard let url = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: url) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
}
