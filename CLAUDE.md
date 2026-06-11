# Inspector Moiré — Kontext für Claude Code

Diese Datei wird beim Start jeder Claude-Code-Session automatisch geladen. Sie enthält den Projekt-Kontext, harte Constraints und Verweise auf die Session-Prompts.

---

## Projekt in zwei Sätzen

Inspector Moiré ist eine professionelle iPhone-App, die als sprachgesteuertes Testbild-Display für Kameratests an Cine-Kameras (ARRI, RED, Sony) dient. Sie ersetzt den heute verbreiteten Notbehelf, einen MacBook-Bildschirm bewusst unscharf abzufilmen.

---

## Aktueller Stand

| Session | Status | Inhalt |
|---|---|---|
| 0 | abgeschlossen | Git-Repo + GitHub Pages |
| 1 | abgeschlossen | Xcode-Projekt + TestEngine-Grundgerüst |
| 2 | abgeschlossen | SwiftUI-Navigation + Kamera-Profile + Modus-Auswahl |
| 3 | offen | Metal-Renderer mit Rec.709-legal + DIT-Referenzsequenz |
| 4 | offen | Voice-Layer mit „Inspector"-Wake-Word |
| 5 | offen | Apple Watch Companion |
| 6 | offen | Persistenz und PDF-Reports |
| 7 | offen | QA und TestFlight-Vorbereitung |

Tatsächlicher Stand pro Modul: siehe `IMPLEMENTATION_NOTES.md` im Repo-Root.

---

## Wie du als Claude Code arbeitest

1. Beim Start: lies zuerst `IMPLEMENTATION_NOTES.md` — dort steht, was die vorigen Sessions wirklich gebaut haben (nicht nur was geplant war).
2. Wenn der Nutzer „führe Session N aus" sagt: lies `prompts/0N-*.md` und arbeite es Schritt für Schritt ab.
3. Wenn unklar: zurückfragen, nicht raten.
4. Am Sessions-Ende immer: Build prüfen, `IMPLEMENTATION_NOTES.md` erweitern, committen und pushen.

---

## Harte Constraints (gelten projektweit)

**Plattform:**
- Minimum iOS 18.0
- Ziel-Geräte: iPhone 14 Pro und neuer (OLED, Display P3, A16 Bionic+)
- Watch-Companion: watchOS 11+

**Color-Space (entscheidend für korrekte Kamera-Aufnahmen):**
- Default-Render-Target ist Rec.709-legal-range (16-235 statt 0-255).
- Weiß ist RGB(235, 235, 235), nicht (255, 255, 255).
- Schwarz ist RGB(16, 16, 16), nicht (0, 0, 0).
- Rot in der DIT-Referenz ist RGB(232, 16, 16) — Werte aus realem DIT-Testclip verifiziert.
- Color-Space wird via `CAMetalLayer.colorspace = CGColorSpace(name: CGColorSpace.itur_709)` gesetzt, NICHT in Shader-Math eingerechnet.
- Settings-Option für Full-Range (0-255) und Display P3 verfügbar machen, aber Rec.709-legal bleibt Default.

**Sprache und Sprachsteuerung:**
- UI: Deutsch + Englisch
- Wake Word: „Inspector" (englisch). Fallback: „Inspektor" (deutsch).
- Spracherkennung: on-device via `SFSpeechRecognizer`, kein Cloud-Roundtrip.

**Architektur:**
- UI: SwiftUI
- Rendering: Metal (CAMetalLayer)
- Persistenz: SwiftData
- Voice: SFSpeechRecognizer
- Watch-Bridge: WatchConnectivity
- PDF: PDFKit

**Privacy:**
- Audio-Daten bleiben on-device, kein Logging, keine Cloud.
- Berechtigungen: NSSpeechRecognitionUsageDescription, NSMicrophoneUsageDescription.
- Background-Audio-Capability für Voice-Wake-Word.

---

## Repository-Struktur

```
.
├── CLAUDE.md                       ← du liest gerade
├── README.md                       ← Projekt-Übersicht für Menschen
├── LICENSE                         ← "All rights reserved" (proprietär)
├── IMPLEMENTATION_NOTES.md         ← was jede Session tatsächlich gebaut hat
├── CLAUDE_CODE_HANDOVER.md         ← alte Übersicht, ersetzt durch prompts/
├── prompts/                        ← eine .md pro Session
│   ├── 03-metal-rec709-dit.md
│   ├── 04-voice-layer.md
│   ├── 05-watch-companion.md
│   ├── 06-persistence-pdf.md
│   └── 07-qa-testflight.md
├── docs/                           ← Konzept-Dokumente (.docx)
│   ├── 01_Technisches_Konzept.docx
│   ├── 02_Kalibrierungs_Recherche.docx
│   ├── 03_Risiken_Annahmen.docx
│   └── 04_DIT_Fragebogen.docx
├── mockup/                         ← interaktiver UI-Mockup (HTML)
│   └── index.html
└── ios-app/                        ← Xcode-Projekt
    └── InspectorMoire/
        ├── App/
        ├── Features/
        ├── Core/
        └── Resources/
```

---

## DIT-Referenz-Testclip (wichtigster Validierungs-Input)

Der DIT hat einen 99-Sekunden-Referenz-Testclip geschickt (1080p24, BT.709 10-bit). Strukturanalyse:

| Zeitfenster | Farbe (Rec.709-legal) | Bedeutung |
|---|---|---|
| 0-17 s | Grey 50% | Lead-In für Belichtungs-Setup, Fokus, Klappe |
| 18-29 s | Red (232, 16, 16) | Pixel-Inspektion rot (12 s Hold) |
| 30-37 s | Green (16, 232, 16) | Pixel-Inspektion grün (8 s Hold) |
| 38-49 s | Blue (16, 16, 232) | Pixel-Inspektion blau (12 s Hold) |
| 50-79 s | R/W/G/K/B/W je 5 s | Schnellere Variation |
| 80-83 s | Grey 50% | Übergang |
| 84-89 s | Black (16, 16, 16) | FPN-Referenz |
| 90-99 s | Grey 50% | Lead-Out / Sign-off |

Diese Sequenz ist als `dit_reference.json` in `Resources/Sequences/` als Standard-Sequenz hinterlegt (kommt in Session 3).

---

## Was nur der Mensch entscheidet

- Apple Developer Account (99 USD/Jahr) und TestFlight-Setup
- Bundle-ID-Registrierung
- App-Icon-Design und finales Branding
- Pricing-Modell
- Einladung von Pilot-Testern
