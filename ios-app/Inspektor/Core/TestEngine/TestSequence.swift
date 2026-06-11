import Foundation

struct TestSequence: Codable, Identifiable {
    let id: String
    let name: String
    let estimatedMinutes: Int
    let testIds: [String]
}

enum TestMode: String, CaseIterable, Identifiable {
    case quickCheck = "quick_check"
    case workshop   = "workshop"
    case custom     = "custom"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .quickCheck: "Quick-Check On-Set"
        case .workshop:   "Werkstatt-Diagnose"
        case .custom:     "Custom-Sequenz"
        }
    }

    var badge: String {
        switch self {
        case .quickCheck: "~7 MIN"
        case .workshop:   "~25 MIN"
        case .custom:     "VARIABEL"
        }
    }

    var description: String {
        switch self {
        case .quickCheck: "5 Sensor-Tests · Pixel-Vollfeld · Vollständiger Farb-Check"
        case .workshop:   "24 Tests inkl. ISO-Sweep, Graukeil, Color-Cast"
        case .custom:     "Eigene Test-Reihenfolge konfigurieren"
        }
    }

    // Only quickCheck has a sequence JSON in Session 2.
    var sequenceResourceName: String? {
        switch self {
        case .quickCheck: "quick_check"
        case .workshop, .custom: nil
        }
    }

    var isAvailable: Bool { self == .quickCheck }
}
