import SwiftUI

struct ModeSelectionView: View {
    @EnvironmentObject private var setup:    SessionSetupModel
    @EnvironmentObject private var settings: SettingsModel
    @Binding var path: [AppNavigation]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            VStack(alignment: .leading, spacing: 0) {
                Text("Welcher Test soll laufen?")
                    .font(.system(size: 12, weight: .semibold))
                    .tracking(1.0)
                    .foregroundStyle(Color.appSecondary)
                    .padding(.bottom, 14)
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                ForEach(TestMode.allCases) { mode in
                    modeCard(mode)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 10)
                }

                Spacer()

                Button {
                    path.append(.preTestReminder)
                } label: {
                    Text("Starten")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color.appAccent)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(!setup.selectedMode.isAvailable)
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Modus")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func modeCard(_ mode: TestMode) -> some View {
        let isSelected = setup.selectedMode == mode

        return Button {
            if mode.isAvailable { setup.selectedMode = mode }
        } label: {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text(mode.displayName)
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundStyle(mode.isAvailable ? .white : Color.appSecondary)
                        Text(mode.badge)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(isSelected ? Color.black : .white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 2)
                            .background(isSelected ? Color.appAccent : Color.appSecondary)
                            .clipShape(Capsule())
                    }
                    Text(mode.description)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appSecondary)
                        .multilineTextAlignment(.leading)
                    if !mode.isAvailable {
                        Text("Kommt in Session 3")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Color.appAccent.opacity(0.6))
                            .padding(.top, 2)
                    }
                }
                Spacer()
            }
            .padding(16)
            .background(isSelected
                ? Color.appAccent.opacity(0.1)
                : Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 14))
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(isSelected ? Color.appAccent : Color.appBorder, lineWidth: 1)
            )
        }
    }
}
