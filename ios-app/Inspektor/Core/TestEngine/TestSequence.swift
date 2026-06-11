import Foundation

struct SequenceStep: Codable {
    let testId:           String
    let durationOverride: Int?
}

struct TestSequence: Codable, Identifiable {
    let id:               String
    let name:             String
    let estimatedMinutes: Int
    // Simple format (Session 1/2 compat): list of test IDs, no duration override.
    let testIds:          [String]?
    // Rich format: steps with optional per-step duration override.
    let steps:            [SequenceStep]?

    // Unified accessor — returns (testId, effectiveDuration override or nil)
    var resolvedSteps: [(String, Int?)] {
        if let steps { return steps.map { ($0.testId, $0.durationOverride) } }
        return (testIds ?? []).map { ($0, nil) }
    }
}

enum TestMode: String, CaseIterable, Identifiable {
    case quickCheck  = "quick_check"
    case ditReference = "dit_reference"
    case workshop    = "workshop"
    case custom      = "custom"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .quickCheck:   "Quick-Check On-Set"
        case .ditReference: "DIT-Referenzsequenz"
        case .workshop:     "Werkstatt-Diagnose"
        case .custom:       "Custom-Sequenz"
        }
    }

    var badge: String {
        switch self {
        case .quickCheck:   "~41 SEK"
        case .ditReference: "~99 SEK"
        case .workshop:     "~25 MIN"
        case .custom:       "VARIABEL"
        }
    }

    var description: String {
        switch self {
        case .quickCheck:   "7 Schritte · Grey Lead-In · R/G/B/W/K"
        case .ditReference: "13 Schritte · 1:1 DIT-Referenzclip (BT.709 10-bit)"
        case .workshop:     "24 Tests inkl. ISO-Sweep, Graukeil, Color-Cast"
        case .custom:       "Eigene Test-Reihenfolge konfigurieren"
        }
    }

    var sequenceResourceName: String? {
        switch self {
        case .quickCheck:   "quick_check"
        case .ditReference: "dit_reference"
        case .workshop, .custom: nil
        }
    }

    var isAvailable: Bool {
        switch self {
        case .quickCheck, .ditReference: true
        case .workshop, .custom:         false
        }
    }
}
