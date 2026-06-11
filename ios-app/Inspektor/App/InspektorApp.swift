import SwiftUI

@main
struct InspektorApp: App {
    @StateObject private var engine   = TestEngine()
    @StateObject private var setup    = SessionSetupModel()
    @StateObject private var settings = SettingsModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(engine)
                .environmentObject(setup)
                .environmentObject(settings)
                .onAppear { engine.loadAll() }
        }
    }
}
