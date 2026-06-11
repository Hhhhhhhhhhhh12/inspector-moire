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
    // Primary color (all renderer types). Values 0.0–1.0, Rec.709-legal unless noted.
    let color:  [Double]?
    // Additional colors for multi-color renderers
    let color2: [Double]?
    let color3: [Double]?
    let color4: [Double]?
    // Color space hint stored in JSON; actual layer colorspace set by SettingsModel.
    let colorSpace:   String?
    // Renderer-specific parameters
    let stripeCount:  Int?     // splitStripes: number of stripes
    let wedgeSteps:   Int?     // grayWedge: number of steps
    let orientation:  String?  // splitStripes: "horizontal" (default) | "vertical"
    let markerText:   String?  // marker: text to overlay

    var swiftUIColor: Color {
        guard let c = color, c.count >= 4 else { return .white }
        return Color(.displayP3, red: c[0], green: c[1], blue: c[2], opacity: c[3])
    }
}

struct TestDefinition: Codable, Identifiable {
    let id:              String
    let name:            String
    let category:        String
    let renderer:        RendererType
    let params:          TestParams
    let durationSeconds: Int
    let voiceTriggers:   [String]
    let appliesTo:       [String]
}
