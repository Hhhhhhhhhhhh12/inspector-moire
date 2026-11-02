# Inspector Moiré — Projektkontext für Coding-Agenten

**Lesereihenfolge:** Zuerst `IMPLEMENTATION_NOTES.md` (tatsächlich dokumentierter Implementierungsverlauf), dann diese Datei, bei Bedarf `ios-app/README.md`, `prompts/README.md` und die konkrete Session-Anleitung. Ältere Pläne sind **keine** Belege für implementierten Code.

## Produkt und Namen

Das Projekt entwickelt ein professionelles iPhone-Testbild-Display für Tests an Cine-Kameras (ARRI, RED, Sony). Es soll den Behelf ersetzen, für Kameraaufnahmen einen unscharfen Laptop-Bildschirm zu verwenden. **Es erkennt oder vermisst Bildfehler derzeit nicht selbst**; ein interaktiver HTML-Mockup ist ebenfalls kein Funktionstest.

Die iOS-App und die Projektdateien tragen aktuell den **Arbeitsnamen „Inspektor“**. Die am 27. Oktober 2026 festgehaltene kreative Markenwelt **„Inspector Moiré“** ist in `docs/BRAND_WORLD.md` dokumentiert: weiblich gedachte Ermittlerin mit bewusstem Titel „Inspector“, Gegenspieler **La Chromatique** und **Das Zebra**. Der **finale App-Name, die Gestaltung und eine Integration in die UI sind offen**. Agenten dürfen daraus keine eigenständige Umbenennung, Funktionserweiterung oder gestalterische Freigabe ableiten.

## Entwicklungsstand auf main

| Session | Status | Tatsächlicher Stand |
|---|---|---|
| 0 | abgeschlossen (dokumentiert) | GitHub-Repository und Pages-Mockup |
| 1 | abgeschlossen (dokumentiert) | `Inspektor.xcodeproj`, SwiftUI/TestEngine-Grundgerüst |
| 2 | abgeschlossen (dokumentiert) | Kamera-/Modellauswahl, Navigation, Session-Details, Moduswahl, `SequenceRunner` |
| 3 | abgeschlossen (dokumentiert) | Metal-Renderer, Rec.709-/P3-Optionen, Quick-Check und DIT-Referenzsequenz, Pre-Roll |
| 4 | offen | Voice-Layer — nur UI-Stubs, kein `SFSpeechRecognizer`-Manager |
| 5 | offen | Apple Watch Companion — kein Watch-Target |
| 6 | offen | SwiftData-Persistenz und PDF-Reports — Historie derzeit Mock-Daten |
| 7 | offen | QA, Onboarding, TestFlight — keine vollständige Abnahme belegt |

**Implementiert ist nicht gleich geprüft.** Die Swift-Dateien und JSON-Ressourcen belegen die genannten Bestandteile, aber diese Statuskorrektur führt weder `xcodebuild` noch Simulator- oder iPhone-Tests durch. Keine unabhängige aktuelle Build-/CI-Bestätigung wird behauptet. In den JSON-Testdefinitionen stehen derzeit **sechs Vollflächen-Tests**; weitere Metal-Shader-Modi sind implementiert, aber kein vollständiger V1-Testkatalog. Quick-Check: **7 Schritte / 41 s**; DIT-Referenz: **13 Schritte / 99 s** (Ressourcenreferenzen und nominelle Dauern geprüft). Werkstatt und Custom sind deaktiviert.

**Offene reale Geräteabnahme:** Farbdarstellung eines iPhone 14 Pro oder neuer (Rec.709-Legal-Weiss 235/Schwarz 16, Clipping, Farbwiedergabe), Laufzeit/Sequenzablauf, Orientierung. Der Simulator bietet keine belastbare farbmetrische Validierung. Orientation Lock und Launch Screen sind weiterhin offen. Die Notizen zur Installation der Metal-Toolchain sind **kein** Ersatz für einen Geräte- oder QA-Nachweis.

**Vorbereitung der Geräteabnahme:** [Prüfplan](docs/SESSION3_IPHONE_PRUEFPLAN.md) und [leeres Ergebnisprotokoll](docs/SESSION3_IPHONE_ERGEBNISPROTOKOLL.md) beziehen sich auf den darin fixierten `main`-Stand. Es wurde dafür keine Geräteprüfung durchgeführt. Laut Nutzerhinweis läuft ein UI-Umbau; vor späterer Ausführung Plan und Bedienwege mit dessen Zielcommit abgleichen. Neue Tests, Builds und Geräteprüfungen bleiben gesondert freizugeben. Das Setting „Rec.709 Full Range“ verwendet im Ausgangscode dieselben RGB-Eingabewerte und dieselbe Farbraumzuordnung wie Legal; eine Range-Umskalierung ist nicht implementiert.

## Arbeitsregeln für Coding-Agenten

1. **Vor jeder Aufgabe** `IMPLEMENTATION_NOTES.md`, relevanten Swift-Code und die zugehörigen Ressourcen lesen; nach dem aktuellen Stand fragen, wenn Dokumentation und Code widersprechen. Keine früheren Sessions erneut ausführen.
2. `prompts/03-metal-rec709-dit.md` ist eine **historische Anweisung für die abgeschlossene Session 3**. Sessions 4–7 sind Pläne, **nicht** durch diesen Dokumentationsabgleich autorisiert. Nur auf ausdrücklichen Auftrag eine weitere Session starten.
3. **Git-Workflow:** `main` bleibt stabil. Für jede Änderung einen eigenen Branch erstellen; Änderungen als Pull Request mit Diff und geeigneter Prüfung vorlegen, grundsätzlich per Squash-Merge nach erforderlicher Freigabe. Nicht direkt auf `main` entwickeln.
4. Umfang der jeweiligen Aufgabe einhalten. Für eine reine Dokumentationsaufgabe **keine** Swift-/Metal-/JSON- oder Konfigurationsdateien ändern; keine impliziten Feature-, Marken- oder Farbraumentscheidungen.
5. Für künftige Entwicklungssessions: die passende `prompts/0N-*.md` lesen, Tests/Build nach tatsächlicher Ausführung dokumentieren, `IMPLEMENTATION_NOTES.md` mit Befunden ergänzen. Tests nie nur aus dem Vorhandensein von Quellcode ableiten.

## Technische Vorgaben — implementiert versus geplant

**Plattform:** Minimum iOS 18.0, Zielgeräte iPhone 14 Pro und neuer (OLED, Display P3). Watch-Companion (watchOS 11+) ist ein **geplantes** Ziel.

**Rendering (vorhandener Code, Ausgabe noch nicht am Gerät validiert):**
- Standardziel Rec.709 Legal Range: RGB-Weiss (235,235,235), Schwarz (16,16,16), DIT-Rot (232,16,16), laut referenzierten JSON-Werten.
- `CAMetalLayer.colorspace = CGColorSpace(name: CGColorSpace.itur_709)` für Rec.709; keine pauschale Gamma-Korrektur im Shader. Ausgabemessung auf echter Hardware erforderlich.
- Einstellungen für Rec.709 Full Range und Display P3 sind bereits in `RenderColorSpace` und `SettingsView` implementiert.
- Static Render-on-Demand über `MetalRenderer`/`MetalView`; Shader-Modi für fullField, splitQuadrants, splitStripes, grayWedge und colorPatches; Marker-Text als SwiftUI-Overlay.
- `SequenceRunner.arm()` zeigt das erste Bild, `triggerStart()` startet per Tap den Timer. Ein späterer Voice-Layer muss die **tatsächlich existierende** API verwenden, nicht erfundene Methoden.

**Geplante Architektur (nicht als Implementierungsstand ausgeben):**
- UI: SwiftUI (bereits vorhanden); Rendering: Metal / CAMetalLayer (bereits vorhanden).
- Voice: `SFSpeechRecognizer` mit on-device-Erkennung, englisches Wake-Word „Inspector“, deutscher Fallback „Inspektor“; deutsche und englische UI als Produktziel.
- Watch: WatchConnectivity.
- Persistenz: SwiftData; Berichte: PDFKit bzw. im Session-Prompt beschriebene PDF-Erzeugung.
- Privacy-Ziel: Audiodaten on-device, kein Logging/Cloud-Roundtrip; erforderliche Mikrofon- und Spracherkennungs-Berechtigungen erst mit Voice-Implementierung setzen. Background-Audio-Fähigkeit muss bei Umsetzung geprüft werden.

## Bestätigte DIT-Referenz und Zeitfenster

Der DIT lieferte einen 99-Sekunden-Testclip (1080p24, BT.709 10-bit). Die **in JSON implementierte** Referenzsequenz ist:

| Zeitfenster | Farbe (Rec.709 Legal) | Zweck |
|---|---|---|
| 0–17 s | Grey 50 % | Lead-In, Belichtung/Fokus/Klappe |
| 18–29 s | Rot (232,16,16) | Inspektion rot |
| 30–37 s | Grün (16,232,16) | Inspektion grün |
| 38–49 s | Blau (16,16,232) | Inspektion blau |
| 50–79 s | R/W/G/K/B/W je 5 s | Farbwechsel |
| 80–83 s | Grey 50 % | Übergang |
| 84–89 s | Schwarz (16,16,16) | FPN-Referenz |
| 90–99 s | Grey 50 % | Lead-Out |

Quelle im Repository: `ios-app/Inspektor/Resources/Sequences/dit_reference.json` sowie `IMPLEMENTATION_NOTES.md`. Zeitfenster sind die dokumentierte Clipstruktur; die Sequenz enthält 13 Schritte mit insgesamt 99 nominalen Sekunden, **nicht** einen neu gemessenen Lauf auf dem iPhone. Die genauen RGB-Werte belegen eine Konfiguration bzw. Clipreferenz, keine gemessene Display-Ausgabe.

## Tatsächliche Repository-Struktur (Auszug)

```text
.
├── README.md
├── CLAUDE.md
├── IMPLEMENTATION_NOTES.md
├── CLAUDE_CODE_HANDOVER.md          # historische Übergabe; alte Session-Nummerierung
├── UPLOAD_TO_GITHUB.md             # historische Erstanleitung
├── prompts/
│   ├── README.md
│   ├── 03-metal-rec709-dit.md       # bereits umgesetzt
│   ├── 04-voice-layer.md
│   ├── 05-watch-companion.md
│   ├── 06-persistence-pdf.md
│   └── 07-qa-testflight.md
├── docs/                            # Konzept-Dokumente + BRAND_WORLD.md
├── mockup/index.html
└── ios-app/
    ├── README.md
    ├── project.yml
    ├── Inspektor.xcodeproj/
    └── Inspektor/
        ├── App/
        ├── Core/
        │   ├── DisplayManager/
        │   └── TestEngine/
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

**Nicht vorhanden:** `ios-app/InspectorMoire/`, ein Watch-Target, SwiftData-Modelle, PDF-Report-Generator, eine `LICENSE`-Datei. Die Annahme, eine Lizenzdatei liege vor, ist falsch; ein öffentliches Nutzungsrecht folgt daraus nicht.

## Entscheidungen, die beim Menschen bleiben

Apple-Developer-Account und TestFlight-Setup, Bundle-ID-Registrierung, reales Geräte-/DIT-Feedback, finale App-Benennung und Branding, App-Icon, Pricing und Auswahl von Pilot-Testern. Ohne klare Freigabe keine Namens-, Marken- oder Umfangsänderung.
