import Foundation
import SwiftUI

enum RendererType: String, Codable {
    case fullField
    case splitQuadrants
    case splitStripes
    case grayWedge
    case colorPatches
    case marker
}

struct TestParams: Codable {
    let color: [Double]?
    let colorSpace: String?

    var swiftUIColor: Color {
        guard let c = color, c.count == 4 else { return .white }
        return Color(.displayP3, red: c[0], green: c[1], blue: c[2], opacity: c[3])
    }
}

struct TestDefinition: Codable, Identifiable {
    let id: String
    let name: String
    let category: String
    let renderer: RendererType
    let params: TestParams
    let durationSeconds: Int
    let voiceTriggers: [String]
    let appliesTo: [String]
}
