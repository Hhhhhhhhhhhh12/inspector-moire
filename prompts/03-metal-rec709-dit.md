# Session 3 — Metal-Renderer mit Rec.709-legal + DIT-Referenzsequenz

Vorbereitung: `CLAUDE.md` und `IMPLEMENTATION_NOTES.md` lesen.

## Aufgabe

Eigentlicher Rendering-Kern. Vom DIT haben wir einen echten Referenz-Testclip bekommen, dessen Struktur und Color-Space wir 1:1 nachbilden.

## Wichtige Erkenntnisse aus dem DIT-Referenz-Testclip

Quelle: `RGB-TESTCLIP-h265.MOV`, 1080p24, BT.709 10-bit, vom DIT geliefert.

### A) Color-Space

Cine-Kameras erwarten Rec.709-legal-range (16-235 für Luma, statt 0-255 Full-Range). Im DIT-Clip ist „Rot" RGB(232, 0, 3), nicht (255, 0, 0). Renderer muss daher:

- Standardmäßig in Rec.709-legal rendern (Werte 16-235 statt 0-255).
- Auf Wunsch (Setting) auch Full-Range Rec.709 oder Display P3 erlauben.
- Color-Space via `CAMetalLayer.colorspace = CGColorSpace(name: CGColorSpace.itur_709)` setzen, NICHT in Shader-Math drauf addieren.

### B) Hold-Zeiten

Der DIT lässt jede Vollfarbe 8-12 Sekunden stehen, nicht 3-5. Standard `defaultDurationSeconds` in Test-Definitionen daher auf **10 Sekunden** setzen, nicht 5.

### C) DIT-Referenzsequenz

Exakte Nachbildung des Clips, anzulegen als `Resources/Sequences/dit_reference.json`:

| Schritt | Inhalt | Dauer |
|---|---|---|
| 1 | Grey 50% | 17 s (Lead-In für Belichtungs-Setup, Fokus, Klappe) |
| 2 | Red | 12 s |
| 3 | Green | 8 s |
| 4 | Blue | 12 s |
| 5 | Red | 5 s |
| 6 | White | 5 s |
| 7 | Green | 5 s |
| 8 | Black | 5 s |
| 9 | Blue | 5 s |
| 10 | White | 5 s |
| 11 | Grey 50% | 4 s |
| 12 | Black | 6 s |
| 13 | Grey 50% | 10 s (Lead-Out) |

Gesamt: ca. 99 Sekunden, identisch zum DIT-Clip.

### D) Pre-Roll

Vor jeder Sequenz die App den ersten Frame (50% Grey) bereits zeigen, aber im „armed"-State bleiben, bis der DIT per Sprachbefehl „Inspector — start" oder Tap auf den Bildschirm tatsächlich startet. So hat er Zeit, den Slate zu setzen.

## Konkrete Schritte

### 1. MetalRenderer (Core/TestEngine/MetalRenderer.swift)

- CAMetalLayer in SwiftUI-View via UIViewRepresentable
- Color-Space-Konfiguration: BT.709-legal (`CGColorSpace(name: CGColorSpace.itur_709)`) als Default, Display P3 als Option
- HDR-Rendering optional (`wantsExtendedDynamicRangeContent`), default off für Rec.709-Kompatibilität
- Renderer-Typen:
  - `fullField` (Rec.709-legal, RGB-Werte aus JSON werden roh durchgereicht, kein Gamma-Korrektur-Magic)
  - `splitQuadrants`
  - `splitStripes` (horizontal/vertikal, n Streifen)
  - `grayWedge` (n Stufen)
  - `colorPatches` (n×m)
  - `marker` (Großtext auf Schwarz)

### 2. test_definitions.json erweitern

Alle Tests aus Konzept-Sektion 2.2 mit korrekten Rec.709-legal-Werten:
- White: RGB(235, 235, 235)
- Black: RGB(16, 16, 16)
- Red: RGB(232, 16, 16) bzw. exakt nach BT.709-Matrix
- usw. — Werte aus dem DIT-Clip verifizieren

### 3. dit_reference.json

Wie oben beschrieben in `Resources/Sequences/` anlegen.

### 4. quick_check.json überarbeiten

Kürzere Variante der DIT-Sequenz (ca. 45 Sekunden), für On-Set-Schnellchecks.

### 5. SequenceRunner um Pre-Roll-Phase erweitern

Erstes Frame ist Lead-In-Grau, Timer startet erst auf Trigger (Tap oder Voice-Befehl).

### 6. TestRunnerView umstellen

Mit MetalRenderer statt SwiftUI-Color rendern.

### 7. Settings (Features/Settings/SettingsView.swift)

Toggle:
- „Rec.709 legal range" (default on)
- „Full Range"
- „Display P3"

## Abschluss

- Build muss laufen.
- IMPLEMENTATION_NOTES.md mit Color-Space-Entscheidungen dokumentieren.
- Commit-Message: `Session 3 – Metal-Renderer mit Rec.709-legal und DIT-Referenzsequenz`
- Push.

## Wichtig

Falls die Color-Space-Konfiguration sich im Simulator nicht überprüfen lässt: dokumentiere das als offenen Punkt für Real-Device-Test, mache nicht raten.
