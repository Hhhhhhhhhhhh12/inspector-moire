import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var settings: SettingsModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color.appBackground.ignoresSafeArea()
                List {
                    colorSpaceSection
                    infoSection
                }
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Fertig") { dismiss() }
                        .foregroundStyle(Color.appAccent)
                }
            }
        }
    }

    // MARK: - Sections

    private var colorSpaceSection: some View {
        Section {
            ForEach(RenderColorSpace.allCases) { cs in
                Button {
                    settings.colorSpace = cs
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(cs.displayName)
                                .foregroundStyle(.white)
                                .font(.system(size: 14))
                            if cs == .rec709Legal {
                                Text("Default — verifiziert gegen DIT-Referenzclip")
                                    .font(.system(size: 11))
                                    .foregroundStyle(Color.appSecondary)
                            }
                        }
                        Spacer()
                        if settings.colorSpace == cs {
                            Image(systemName: "checkmark")
                                .foregroundStyle(Color.appAccent)
                                .fontWeight(.semibold)
                        }
                    }
                }
                .listRowBackground(Color.appSurface)
            }
        } header: {
            Text("Farbraum")
                .foregroundStyle(Color.appSecondary)
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.2)
        } footer: {
            // swiftlint:disable:next line_length
            Text("Rec.709 Legal rendert Weiß als RGB(235,235,235) und Schwarz als RGB(16,16,16) — identisch zum DIT-Referenzclip. Color-Space-Verhalten im Simulator nicht vollständig überprüfbar → Real-Device-Test erforderlich.")
                .foregroundStyle(Color.appSecondary)
                .font(.system(size: 11))
        }
    }

    private var infoSection: some View {
        Section {
            HStack {
                Text("Version")
                    .foregroundStyle(.white)
                Spacer()
                Text("0.3.0 (Session 3)")
                    .foregroundStyle(Color.appSecondary)
            }
            .listRowBackground(Color.appSurface)
            .font(.system(size: 14))
        } header: {
            Text("Info")
                .foregroundStyle(Color.appSecondary)
                .font(.system(size: 11, weight: .semibold))
                .tracking(1.2)
        }
    }
}
