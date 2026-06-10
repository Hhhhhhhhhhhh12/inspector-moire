import SwiftUI

@main
struct InspektorApp: App {
    @StateObject private var engine = TestEngine()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(engine)
                .onAppear {
                    engine.loadDefinitions()
                }
        }
    }
}
