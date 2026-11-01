# iOS-App: vorhandener Prototyp

Die iOS-Entwicklung hat bereits begonnen. Das Xcode-Projekt liegt unter **`ios-app/Inspektor.xcodeproj`**, der Swift-Quellcode unter **`ios-app/Inspektor/`**. Der Projektname „Inspektor“ ist ein technischer Arbeitsname; ein endgültiger App-Name wurde noch nicht beschlossen (siehe [Markenwelt](../docs/BRAND_WORLD.md)).

## Aktueller Stand (Sessions 1–3)

- SwiftUI mit Navigation durch Hersteller, Kameramodell, Session-Details und Modusauswahl bis zur Testansicht.
- Zehn Kamera-Profile; Quick-Check (7 Schritte/41 s) und DIT-Referenz (13 Schritte/99 s) als JSON-Ressourcen.
- `SequenceRunner` mit Pre-Roll/Armed-State und zeitgesteuerten Sequenzen.
- `MetalRenderer`/`MetalView` mit Rec.709 Legal als Voreinstellung, Rec.709 Full und Display P3 als wählbaren Modi; mehrere Shader-Darstellungsarten. **Sechs Vollflächen-Tests sind konkret in JSON definiert.**
- Helligkeit und Auto-Lock werden bei der Vollbild-Testansicht durch `DisplayManager` gesteuert.

**Nicht implementiert:** Voice-Erkennung, Watch-Companion, SwiftData-Speicherung, PDF-Reports, echte Session-Historie und umfassende automatisierte Tests. Werkstatt- und Custom-Modus sind noch nicht verfügbar; UI-/Status-Stubs sind keine funktionalen Integrationen.

## Vorhandene Struktur

```text
ios-app/
├── README.md
├── project.yml                    # xcodegen-Projektdefinition
├── Inspektor.xcodeproj/
└── Inspektor/
    ├── App/                       # App-Einstieg, Navigation, Farben
    ├── Core/
    │   ├── DisplayManager/
    │   └── TestEngine/            # Modelle, Sequenzen, Metal und Shader
    ├── Features/
    │   ├── CameraSelection/
    │   ├── Home/
    │   ├── ModeSelection/
    │   ├── Settings/
    │   └── TestRunner/
    └── Resources/
        ├── CameraProfiles/
        ├── Sequences/
        └── TestDefinitions/
```

Das Xcode-Projekt wird gemäss `project.yml` mit **xcodegen** definiert (iOS 18.0, Swift 6, Bundle-ID-Platzhalter `com.inspektor.app`, Marketing-Version 0.3.0). Zum Öffnen unter macOS mit Xcode `ios-app/Inspektor.xcodeproj` verwenden; falls eine Neugenerierung benötigt wird, `xcodegen generate` im Verzeichnis `ios-app/` ausführen. Diese Anleitung behauptet **keinen in dieser Prüfung durchgeführten Build**.

## Prüfgrenzen

Die Implementierungsnotizen dokumentieren Session 3 als abgeschlossen und beschreiben DIT-Referenzwerte. **Offen bleibt insbesondere die Prüfung auf einem echten iPhone 14 Pro oder neuer:** Rec.709-Legal-Ausgabe, Weiss-/Schwarz-Clipping, tatsächliche Farbwiedergabe und der Testablauf. Ein Simulator ersetzt diese Messung nicht. Auch Orientation Lock und Launch Screen sind laut Notizen offen.

Für den verbindlichen Implementierungsverlauf siehe [IMPLEMENTATION_NOTES.md](../IMPLEMENTATION_NOTES.md); für geplante weitere Sessions [prompts/README.md](../prompts/README.md). Architektur- und Risikohintergrund: [technisches Konzept](../docs/01_Technisches_Konzept.docx).
