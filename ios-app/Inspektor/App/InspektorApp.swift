import SwiftUI

@main
struct InspektorApp: App {
    @StateObject private var engine = TestEngine()
    @StateObject private var setup  = SessionSetupModel()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(engine)
                .environmentObject(setup)
                .onAppear { engine.loadAll() }
        }
    }
}
