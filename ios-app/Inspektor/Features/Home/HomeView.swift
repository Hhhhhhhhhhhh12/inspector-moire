import SwiftUI

private struct MockSession: Identifiable {
    let id = UUID()
    let camera: String
    let dateLabel: String
    let testCount: Int
    let failCount: Int

    var summary: String {
        failCount == 0 ? "All Pass" : "\(failCount) Fail\(failCount > 1 ? "s" : "")"
    }

    var summaryColor: Color {
        failCount == 0 ? Color.green : Color(red: 1, green: 0.34, blue: 0.44)
    }
}

private let mockSessions: [MockSession] = [
    .init(camera: "ARRI Alexa 35",  dateLabel: "Gestern 14:32", testCount: 8, failCount: 1),
    .init(camera: "Sony Venice 2",  dateLabel: "Mo 22.05",      testCount: 7, failCount: 0),
    .init(camera: "RED Komodo",     dateLabel: "Fr 19.05",       testCount: 8, failCount: 2),
]

struct HomeView: View {
    @EnvironmentObject private var engine: TestEngine
    @EnvironmentObject private var setup: SessionSetupModel
    @State private var path: [AppNavigation] = []

    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                        newSessionButton
                        sessionHistory
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationBarHidden(true)
            .navigationDestination(for: AppNavigation.self) { destination in
                destinationView(destination)
                    .environmentObject(engine)
                    .environmentObject(setup)
            }
        }
    }

    // MARK: - Subviews

    private var header: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("Inspektor.")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(.white)
                    Text("CAMERA SENSOR QA")
                        .font(.system(size: 11, weight: .semibold))
                        .tracking(1.5)
                        .foregroundStyle(Color.appSecondary)
                }
                Spacer()
            }
            .padding(.top, 60)
            .padding(.bottom, 32)
        }
    }

    private var newSessionButton: some View {
        Button {
            setup.selectedProfile = nil
            setup.serialNumber = ""
            setup.lens = ""
            setup.operatorName = ""
            path = [.manufacturer]
        } label: {
            HStack {
                Image(systemName: "plus")
                    .fontWeight(.bold)
                Text("Neue Test-Session")
                    .fontWeight(.bold)
            }
            .font(.system(size: 16))
            .foregroundStyle(Color.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                LinearGradient(
                    colors: [Color.appAccent, Color(red: 0, green: 0.58, blue: 0.77)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }

    private var sessionHistory: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Letzte Sessions")
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Color.appSecondary)
                .padding(.top, 32)
                .padding(.bottom, 10)

            ForEach(mockSessions) { session in
                sessionRow(session)
            }
        }
    }

    private func sessionRow(_ session: MockSession) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(session.camera)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.white)
                Text("\(session.dateLabel) · \(session.testCount) Tests · \(session.summary)")
                    .font(.system(size: 12))
                    .foregroundStyle(session.failCount == 0 ? Color.appSecondary : session.summaryColor)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 14))
                .foregroundStyle(Color.white.opacity(0.25))
        }
        .padding(14)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
        .padding(.bottom, 8)
    }

    // MARK: - Navigation destinations

    @ViewBuilder
    private func destinationView(_ destination: AppNavigation) -> some View {
        switch destination {
        case .manufacturer:
            ManufacturerView(path: $path)
        case .model(let mfr):
            ModelView(path: $path, manufacturer: mfr)
        case .sessionDetails:
            SessionDetailsView(path: $path)
        case .modeSelection:
            ModeSelectionView(path: $path)
        case .preTestReminder:
            PreTestReminderView()
        }
    }
}
