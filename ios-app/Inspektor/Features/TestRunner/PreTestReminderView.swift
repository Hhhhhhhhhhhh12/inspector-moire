import SwiftUI
import UIKit

struct PreTestReminderView: View {
    @EnvironmentObject private var engine: TestEngine
    @EnvironmentObject private var setup: SessionSetupModel
    @StateObject private var runner = SequenceRunner()
    @State private var showingTestRunner = false

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        statusRows
                        reminderTip
                        Spacer(minLength: 32)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }

                startButton
                    .padding(.horizontal, 20)
                    .padding(.bottom, 32)
            }
        }
        .navigationTitle("Bereit")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .onAppear { prepareRunner() }
        .fullScreenCover(isPresented: $showingTestRunner) {
            TestRunnerView()
                .environmentObject(runner)
        }
    }

    // MARK: - Subviews

    private var statusRows: some View {
        VStack(spacing: 0) {
            statusRow(icon: "✓", title: "Display-Helligkeit",
                      subtitle: "Auto-Set auf 100%")
            statusRow(icon: "✓", title: "Auto-Lock deaktiviert",
                      subtitle: "Display bleibt an")
            statusRow(icon: "✓", title: "Voice-Layer bereit",
                      subtitle: "Stub — aktiv in Session 4",
                      isStub: true)
            statusRow(icon: "✓", title: "Apple Watch",
                      subtitle: "Stub — aktiv in Session 4",
                      isStub: true)
        }
    }

    private func statusRow(icon: String, title: String,
                            subtitle: String, isStub: Bool = false) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 6)
                    .fill(isStub
                        ? Color.appSecondary.opacity(0.15)
                        : Color.appAccent.opacity(0.15))
                    .frame(width: 24, height: 24)
                Text(icon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(isStub ? Color.appSecondary : Color.appAccent)
            }
            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 13))
                    .foregroundStyle(isStub ? Color.appSecondary : .white)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(Color.appSecondary)
            }
            Spacer()
        }
        .padding(.vertical, 10)
    }

    private var reminderTip: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("True Tone und Night Shift in den iOS-Einstellungen deaktivieren für maximale Konsistenz.")
                .font(.system(size: 11))
                .foregroundStyle(Color(red: 1, green: 0.71, blue: 0.16))
                .padding(12)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(red: 1, green: 0.71, blue: 0.16).opacity(0.08))
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(red: 1, green: 0.71, blue: 0.16).opacity(0.3),
                                lineWidth: 1)
                )

            Button {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            } label: {
                Text("iOS-Einstellungen öffnen")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Color.appAccent)
            }
        }
        .padding(.top, 16)
    }

    private var startButton: some View {
        Button {
            showingTestRunner = true
        } label: {
            Text("Sequenz starten")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(Color.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(runner.tests.isEmpty
                    ? Color.appSecondary
                    : Color.appAccent)
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .disabled(runner.tests.isEmpty)
    }

    // MARK: - Setup

    private func prepareRunner() {
        guard let sequence = engine.sequence(for: setup.selectedMode) else { return }
        runner.load(testIds: sequence.testIds, definitions: engine.definitions)
    }
}
