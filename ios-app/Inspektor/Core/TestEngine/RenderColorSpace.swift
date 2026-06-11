import CoreGraphics

enum RenderColorSpace: String, CaseIterable, Identifiable {
    case rec709Legal = "rec709Legal"
    case rec709Full  = "rec709Full"
    case displayP3   = "displayP3"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .rec709Legal: "Rec.709 Legal (16–235)"
        case .rec709Full:  "Rec.709 Full Range"
        case .displayP3:   "Display P3"
        }
    }

    var cgColorSpace: CGColorSpace? {
        switch self {
        case .rec709Legal, .rec709Full:
            return CGColorSpace(name: CGColorSpace.itur_709)
        case .displayP3:
            return CGColorSpace(name: CGColorSpace.displayP3)
        }
    }
}
