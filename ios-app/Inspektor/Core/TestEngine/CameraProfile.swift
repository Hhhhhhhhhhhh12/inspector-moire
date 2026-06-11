import Foundation

struct CameraProfile: Codable, Identifiable, Hashable {
    let id: String
    let manufacturer: String
    let model: String
    let sensorResolution: String
    let pixelPitchMicrons: Double
    let recommendedISO: [Int]
    let notes: String

    var isoDisplay: String {
        recommendedISO.map { "ISO \($0)" }.joined(separator: " · ")
    }
}
