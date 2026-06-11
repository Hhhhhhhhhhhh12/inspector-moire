import SwiftUI

// Entry point renamed ManufacturerView — this file is kept for Xcode group membership.
// Content lives in ManufacturerView.swift / ModelView.swift / SessionDetailsView.swift

struct ManufacturerView: View {
    @EnvironmentObject private var engine: TestEngine
    @Binding var path: [AppNavigation]

    private let manufacturers = ["ARRI", "RED", "Sony"]

    var body: some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Hersteller wählen")
                        .font(.system(size: 12, weight: .semibold))
                        .tracking(1.2)
                        .foregroundStyle(Color.appSecondary)
                        .padding(.bottom, 12)

                    ForEach(manufacturers, id: \.self) { mfr in
                        manufacturerTile(mfr)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 8)
            }
        }
        .navigationTitle("Kamera")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    private func manufacturerTile(_ name: String) -> some View {
        let models = engine.profiles(for: name)
        let subtitle = models.map(\.model).joined(separator: ", ")

        return Button {
            path.append(.model(name))
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(name)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundStyle(.white)
                    Text(subtitle.isEmpty ? "Profile werden geladen …" : subtitle)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.appSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color.white.opacity(0.3))
            }
            .padding(18)
            .background(Color.appSurface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.appBorder, lineWidth: 1))
        }
        .padding(.bottom, 10)
    }
}
