import Foundation

@MainActor
final class SettingsModel: ObservableObject {
    @Published var colorSpaceRaw: String = RenderColorSpace.rec709Legal.rawValue

    var colorSpace: RenderColorSpace {
        get { RenderColorSpace(rawValue: colorSpaceRaw) ?? .rec709Legal }
        set { colorSpaceRaw = newValue.rawValue }
    }
}
