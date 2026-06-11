import Foundation

@MainActor
final class SessionSetupModel: ObservableObject {
    @Published var selectedProfile: CameraProfile?
    @Published var serialNumber: String = ""
    @Published var lens: String = ""
    @Published var operatorName: String = ""
    @Published var selectedMode: TestMode = .quickCheck

    var isComplete: Bool { selectedProfile != nil }
}
