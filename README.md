# Inspektor — iOS-Prototyp für Kameratests

> Arbeitsname des iOS-Projekts. Die endgültige App-Benennung ist **offen**; die kreative Markenwelt „Inspector Moiré“ ist separat in [docs/BRAND_WORLD.md](docs/BRAND_WORLD.md) dokumentiert.

**Entwicklungsstand:** Sessions 0–3 laut [IMPLEMENTATION_NOTES.md](IMPLEMENTATION_NOTES.md) abgeschlossen (letzter dokumentierter Implementierungsstand: 11. Juni 2026); SwiftUI-App und Metal-Testbilddarstellung im Quellcode vorhanden. **Keine abgeschlossene iPhone-Geräteabnahme.**
**Plattform:** iOS 18+; Zielgeräte iPhone 14 Pro und neuer. Apple-Watch-Begleitung (watchOS 11+) ist geplant, noch nicht implementiert.
**Sprachen:** Deutsch und Englisch als Produktziel; die vorhandene Oberfläche verwendet überwiegend deutsche Texte.

## Ziel des Produkts

Die App soll DITs, Kameraassistenz und Rental-Servicewerkstätten bei Kameratests unterstützen: Das iPhone zeigt kontrollierte Testbilder vor einer Cine-Kamera, statt einen absichtlich unscharf dargestellten Laptop-Bildschirm zu verwenden. Freihändige Sprachsteuerung, Apple-Watch-Bedienung und PDF-Dokumentation gehören zur **geplanten** V1, nicht zum aktuellen Funktionsumfang. Zeitersparnis und Testqualität sind noch nicht in der Praxis belegt.

## Tatsächlich im Repository implementiert

- **SwiftUI-Flow:** Startseite, Hersteller- und Modellauswahl, Eingabe von Kamera-/Session-Details, Moduswahl, Vor-Test-Hinweise, Vollbild-Testansicht und Einstellungen. Die Startseiten-Historie enthält **Mock-Daten**, keine gespeicherten Sessions.
- **Kameraprofile:** zehn JSON-Profile für ARRI (3), RED (3) und Sony (4).
- **Sequenzsteuerung:** `SequenceRunner` mit Armed-/Pre-Roll-Zustand (erster Frame sichtbar, Timer startet per Tap), Auto-Advance sowie Methoden für Pause, Fortsetzen, Vor/Zurück und Stop. Die konkrete UI bindet noch nicht alle Steuerungsmethoden an.
- **Verfügbare Sequenzen:** Quick-Check mit **7 Schritten/41 Sekunden** und DIT-Referenz mit **13 Schritten/99 Sekunden**. Die beiden JSON-Dateien referenzieren vorhandene Test-IDs; Werkstatt- und Custom-Modus sind im Code als *nicht verfügbar* markiert.
- **Metal-Darstellung:** `MetalRenderer.swift`, `MetalView.swift` und `Shaders.metal` enthalten Implementierungen für Vollflächen, Quadranten, Streifen, Graukeil und Farbpatches; Marker-Text wird in SwiftUI überlagert. Im derzeitigen `test_definitions.json` sind **sechs konkrete Vollflächen-Tests** definiert (Grau 50 %, Weiss, Schwarz, Rot, Grün, Blau). Implementierte Shader-Modi bedeuten noch keinen vollständig bereitgestellten Testkatalog.
- **Farbraum:** `RenderColorSpace` bietet Rec.709 Legal (Default), Rec.709 Full und Display P3; `CAMetalLayer.colorspace` wird konfiguriert. Die im JSON hinterlegten Referenzwerte orientieren sich am DIT-Clip. Die **tatsächliche Display-Ausgabe** ist noch nicht auf einem iPhone farbmetrisch bzw. hinsichtlich Clipping geprüft.

Die Quellen für diese Einordnung sind die vorhandenen Swift-Dateien, `ios-app/Inspektor/Resources/` und [IMPLEMENTATION_NOTES.md](IMPLEMENTATION_NOTES.md). „Implementiert“ ist **nicht** gleich „auf einem echten Gerät validiert“.

## Prüfstand und offene Abnahmen

| Bereich | Nachgewiesener Stand | Noch offen |
|---|---|---|
| Quellcode und Projektstruktur | Xcode-Projekt, SwiftUI-Views, Metal-Komponenten und JSON-Ressourcen sind auf `main` vorhanden | Erneuter unabhängiger iOS-Build und UI-/Funktionstest sind nicht durch diese Dokumentationsprüfung nachgewiesen |
| Sequenzressourcen | JSON-Referenzen und nominelle Dauern von 41/99 Sekunden anhand des Repository-Inhalts abgeglichen | Timing und Darstellung im realen Ablauf auf einem iPhone |
| Rec.709 / DIT | Werte und Konfiguration sind implementiert und in den Implementierungsnotizen gegen die DIT-Referenz dokumentiert | Physische iPhone-Prüfung der Display-Ausgabe (insbesondere Legal-Weiss 235 und Legal-Schwarz 16, Farbwiedergabe/Clipping); Simulator genügt nicht |
| Gerät und UX | Quellimplementierung vorhanden | Real-Device-Abnahme, Orientation Lock und Launch Screen |
| Erweiterungen | Architektur und Session-Prompts vorhanden | Voice-Layer, Apple Watch, SwiftData-Persistenz, PDF-Reports, umfassende QA und TestFlight |

**Wichtig:** Eine erfolgreich eingerichtete Metal-Toolchain (siehe Implementierungsnotizen) ist kein Nachweis für einen neuen erfolgreichen Build oder eine bestandene Geräteprüfung. Der aktuelle Dokumentationsabgleich führt keine neue Entwicklungssession aus.

## Geplante Produktfunktionen (nicht als geliefert verstehen)

- Erweiterter V1-Testkatalog: zusätzliche Vollflächen/Splits, Uniformität, FPN, Graukeil, Farbfelder und weitere Sensor-Testmuster.
- Sprachassistent mit on-device-Erkennung, geplantes Wake-Word „Inspector“ (Fallback „Inspektor“), Befehlen, Bewertung und Notizen.
- Apple-Watch-Companion mit Push-to-Talk, Status und Haptik.
- Persistente Sessions, Bewertungen/Notizen und teilbare PDF-Reports.
- Perspektivisch V2: Tele-Modus sowie optionale Display-Kalibrierung.

Die vorgesehene Architektur nutzt SwiftUI/Metal; SFSpeechRecognizer, WatchConnectivity, SwiftData und PDFKit sind für spätere Module vorgesehen. Die Aufwandsschätzung von etwa 16 Wochen V1-Vollzeitentwicklung zuzüglich Design/QA stammt aus der **Konzeptphase** und ist keine aktuelle Restaufwandsprognose.

## Unterstützte Kamera-Profile im aktuellen JSON

| Hersteller | Modelle |
|---|---|
| ARRI | Alexa 35 · Alexa Mini · Alexa Mini LF |
| RED | Komodo · V-Raptor · Helium |
| Sony | Venice 2 · FX9 · FX6 · FX3 |

## Repository

```text
.
├── README.md
├── CLAUDE.md                   # aktuelle Agentenhinweise
├── IMPLEMENTATION_NOTES.md    # dokumentierte Sessions 0–3
├── CLAUDE_CODE_HANDOVER.md    # historische Übergabe
├── UPLOAD_TO_GITHUB.md        # historische Erst-Upload-Anleitung
├── docs/
│   ├── 01_Technisches_Konzept.docx
│   ├── 02_Kalibrierungs_Recherche.docx
│   ├── 03_Risiken_Annahmen.docx
│   ├── 04_DIT_Fragebogen.docx
│   └── BRAND_WORLD.md
├── mockup/index.html
├── prompts/                    # Session-Pläne; 03 bereits umgesetzt
└── ios-app/
    ├── README.md
    ├── project.yml
    ├── Inspektor.xcodeproj/
    └── Inspektor/
        ├── App/
        ├── Core/               # TestEngine, DisplayManager
        ├── Features/
        └── Resources/          # JSON-Profile, Sequenzen, Testdefinitionen
```

Technische Details und Projektöffnung: [ios-app/README.md](ios-app/README.md). Session-Planung und Status: [prompts/README.md](prompts/README.md).

## Mockup

Der interaktive, klickbare [HTML-Mockup](mockup/index.html) ist ein **Konzept-/Pitch-Artefakt**, kein Nachweis für bereits verfügbare App-Funktionen. Er ist auch über [GitHub Pages](https://hhhhhhhhhhhh12.github.io/inspector-moire/mockup/) erreichbar.

## Mitarbeit und Lizenz

- **Henneke H.** — Initiator, Konzept, Product Lead
- **DIT-Beratung** — externes Fach-Feedback (Set-Praxis, Kamera-Erfahrung)

Eine öffentliche Lizenzdatei ist derzeit nicht vorhanden. Bis zu einer ausdrücklichen Lizenzentscheidung werden keine Nutzungsrechte eingeräumt; „All rights reserved“.
