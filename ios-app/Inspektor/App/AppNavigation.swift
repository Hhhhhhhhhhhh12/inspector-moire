import Foundation

enum AppNavigation: Hashable {
    case manufacturer
    case model(String)        // manufacturer name
    case sessionDetails
    case modeSelection
    case preTestReminder
}
