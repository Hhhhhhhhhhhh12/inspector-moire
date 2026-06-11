import SwiftUI

struct SessionDetailsView: View {
    @EnvironmentObject private var setup: SessionSetupModel
    @Binding var path: [AppNavigation]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if let profile = setup.selectedProfile {
                        profileHeader(profile)
                    }

                    formField("Seriennummer", placeholder: "z.B. SXT-W 47114-A",
                              text: $setup.serialNumber, mono: true)
                    formField("Objektiv", placeholder: "z.B. Master Prime 50mm T1.3",
                              text: $setup.lens)
                    formField("Operator", placeholder: "Name",
                              text: $setup.operatorName)

                    Button {
                        path.append(.modeSelection)
                    } label: {
                        Text("Weiter →")
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(Color.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color.appAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                    .padding(.top, 28)
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func profileHeader(_ profile: CameraProfile) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("\(profile.manufacturer) \(profile.model)")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.white)
                Text("\(profile.sensorResolution) · \(profile.isoDisplay)")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.appSecondary)
            }
            Spacer()
        }
        .padding(14)
        .background(Color.appSurface)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
        .padding(.bottom, 24)
    }

    @ViewBuilder
    private func formField(_ label: String, placeholder: String,
                            text: Binding<String>, mono: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label.uppercased())
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.2)
                .foregroundStyle(Color.appSecondary)

            TextField(placeholder, text: text)
                .font(mono
                    ? .system(size: 14, design: .monospaced)
                    : .system(size: 14))
                .foregroundStyle(.white)
                .padding(14)
                .background(Color.appSurface)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.appBorder, lineWidth: 1))
        }
        .padding(.bottom, 16)
    }
}
