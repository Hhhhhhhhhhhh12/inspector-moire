import SwiftUI

struct ModelView: View {
    @EnvironmentObject private var engine: TestEngine
    @EnvironmentObject private var setup: SessionSetupModel
    @Binding var path: [AppNavigation]

    let manufacturer: String

    var body: some View {
        let profiles = engine.profiles(for: manufacturer)

        ZStack {
            Color.appBackground.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(profiles) { profile in
                        modelRow(profile, isSelected: setup.selectedProfile == profile)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)

                if let selected = setup.selectedProfile, profiles.contains(selected) {
                    Button {
                        path.append(.sessionDetails)
                    } label: {
                        Text("Weiter →")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)
                }
            }
        }
        .navigationTitle("Modell")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func modelRow(_ profile: CameraProfile, isSelected: Bool) -> some View {
        Button {
            setup.selectedProfile = profile
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Text(profile.model)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(.white)
                    Text("\(profile.notes) · \(profile.pixelPitchMicrons, specifier: "%.2f")µm Pitch")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appSecondary)
                }
                Spacer()
                if isSelected {
                    Circle()
                        .fill(Color.appAccent)
                        .frame(width: 10, height: 10)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14))
                        .foregroundStyle(Color.white.opacity(0.25))
                }
            }
            .padding(14)
            .background(isSelected
                ? Color.appAccent.opacity(0.1)
                : Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isSelected ? Color.appAccent : Color.appBorder, lineWidth: 1)
            )
        }
        .padding(.bottom, 8)
    }
}
