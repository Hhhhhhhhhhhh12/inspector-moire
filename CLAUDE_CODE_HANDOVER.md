# Claude Code — Übergabe

Dieses Dokument enthält die Prompts, mit denen du die Inspektor-iOS-App in Claude Code entwickeln lässt. Voraussetzung: Du hast das Repo lokal geklont, hast Claude Code installiert (`npm install -g @anthropic-ai/claude-code`) und Xcode auf einem Mac. Starte Claude Code im Repo-Root mit `claude`.

---

## So gehst du vor

Der Plan besteht aus mehreren Sessions. Jede Session hat einen klaren Scope und endet mit einem überprüfbaren Ergebnis. **Nicht alle Prompts in einer Session abarbeiten** — das führt zu schlechter Code-Qualität und schwer überprüfbarem Output.

Empfohlener Rhythmus:
- Eine Session pro Modul.
- Nach jeder Session den erzeugten Code lesen oder durch einen iOS-Entwickler reviewen lassen.
- Erst weitergehen, wenn das vorherige Modul stabil ist.

Reihenfolge: Session 1 (Setup) → Session 2 (Test-Engine) → Session 3 (Voice) → Session 4 (Watch) → Session 5 (Reporting).

---

## Session 1 — Projekt-Bootstrap und Test-Engine-Grundlage

Diese Session legt das Xcode-Projekt an und implementiert das Grundgerüst der Test-Engine, sodass du ein erstes Vollbild-Testbild auf dem iPhone sehen kannst.

**Prompt:**

```
Du übernimmst die iOS-Entwicklung des Projekts "Inspektor".

Bitte beginne damit, die folgenden Dokumente in dieser Reihenfolge zu lesen, um den vollständigen Kontext zu erhalten:

1. README.md (Projekt-Übersicht)
2. docs/01_Technisches_Konzept.docx (Architektur, Modul-Schätzung, Tech-Stack)
3. docs/03_Risiken_Annahmen.docx (offene Risiken, Annahmen, die noch validiert werden müssen)
4. mockup/index.html (visueller Referenz-Mockup für UI-Flow)

Falls du .docx-Dateien nicht direkt parsen kannst: konvertiere sie via "soffice --headless --convert-to txt docs/*.docx" oder nutze ein anderes Tool.

Aufgabe für diese Session:

Lege im Ordner ios-app/ ein neues Xcode-Projekt an mit folgenden Eigenschaften:

- Projektname: Inspektor
- Target: iOS 18.0 minimum
- Sprache: Swift
- Interface: SwiftUI
- Bundle-ID: com.inspektor.app (Platzhalter — kann später geändert werden)
- Keine Tests automatisch generieren, das machen wir später strukturiert
- Kein Core Data, kein CloudKit beim Setup — wir nutzen später SwiftData

Erstelle anschließend folgende Modul-Struktur unter ios-app/Inspektor/:

- App/ — App-Entry-Point (InspektorApp.swift)
- Features/Home/ — Startbildschirm
- Features/CameraSelection/ — Kamera-Auswahl
- Features/TestRunner/ — Test-Lauf-View
- Core/TestEngine/ — Test-Definitionen, Renderer, Sequenz-Logik
- Core/DisplayManager/ — Brightness, Wake-Lock, Selbsttest
- Resources/TestDefinitions/ — JSON-Test-Definitionen
- Resources/CameraProfiles/ — JSON-Kamera-Profile

Implementiere konkret:

1. App-Entry mit SwiftUI-Hauptview, die einen einzigen Button "Test starten" zeigt.
2. Eine TestEngine-Klasse, die mindestens den Renderer-Typ "fullField" unterstützt — also ein einfarbiges Vollbild rendern kann. Implementierung über SwiftUI (nicht Metal in dieser ersten Session — Metal kommt in Session 2).
3. Eine TestRunnerView, die per Button-Tap in den Fullscreen-Mode wechselt und ein weißes Vollbild anzeigt. Tap auf das Vollbild beendet den Test und kehrt zur Hauptview zurück.
4. DisplayManager mit zwei Funktionen: setMaxBrightness() und disableAutoLock(). Diese werden beim Start eines Tests aufgerufen.
5. Eine einzelne JSON-Datei test_definitions.json mit fünf Test-Definitionen (Vollfeld weiß, schwarz, rot, grün, blau) im Format aus dem technischen Konzept (Sektion 2.1).
6. Lade die JSON-Datei beim App-Start in die TestEngine.

Wichtige Constraints:

- Keine externen Dependencies (kein SPM, kein CocoaPods) in dieser Session.
- Code muss kompilieren — am Ende bitte "xcodebuild" oder Xcode-Build laufen lassen und Fehler beheben.
- Schreibe einen kurzen Implementierungs-Report (max. 300 Wörter) als IMPLEMENTATION_NOTES.md, der dokumentiert: was wurde gebaut, welche Design-Entscheidungen wurden getroffen, was ist noch nicht enthalten und gehört in spätere Sessions.

Was du NICHT tun sollst:

- Keine erfundenen Daten in Tests — wenn du keine echte iPhone-Hardware ansprechen kannst (du läufst ja in einer Sandbox), simuliere nicht. Markiere stattdessen offen als TODO.
- Keine Sprachsteuerung in dieser Session — kommt in Session 3.
- Keine Apple-Watch-Code in dieser Session — kommt in Session 4.
- Keine SwiftData-Persistenz in dieser Session — kommt in Session 5.

Bei Unklarheiten: stelle Rückfragen, bevor du baust. Lieber einmal nachfragen als am Konzept vorbeiarbeiten.
```

---

## Session 2 — Metal-Renderer und vollständiger Test-Katalog

Diese Session ersetzt den SwiftUI-Renderer durch Metal für volle Display-Kontrolle und HDR-Rendering, und implementiert alle Test-Typen aus dem Konzept.

**Prompt:**

```
Fortsetzung von Session 1. Bitte zuerst IMPLEMENTATION_NOTES.md aus der letzten Session lesen, dann diese Aufgabe:

1. Implementiere einen Metal-basierten Renderer in Core/TestEngine/MetalRenderer.swift. Er soll eine CAMetalLayer in einer SwiftUI-View hosten und mindestens diese Renderer-Typen unterstützen (siehe technisches Konzept Sektion 2.1):

   - fullField (einfarbig, konfigurierbarer Color-Space: sRGB oder displayP3)
   - splitQuadrants (4 Felder, frei konfigurierbar)
   - splitStripes (horizontal/vertikal, n Streifen)
   - grayWedge (Graukeil mit n Stufen)
   - colorPatches (Patch-Raster, n×m)
   - marker (großer Text auf Schwarz)

2. Aktiviere HDR-Rendering wo unterstützt (CAMetalLayer.wantsExtendedDynamicRangeContent).

3. Erweitere test_definitions.json um alle Tests aus dem Konzept (Sektion 2.2):
   Pixel-Tests in 8 Farben, 4-Quadranten-Splits in zwei Orientierungen, Stripes vertikal/horizontal, Uniform White/Grey/Black, Graukeil 21 Stufen, Color-Cast 8 Farben, Macbeth-Style 24 Patches, Marker-Frame.

4. Implementiere die SequenceRunner-Klasse in Core/TestEngine/SequenceRunner.swift, die eine Liste von Tests nacheinander für eine konfigurierbare Dauer abspielt und Marker-Frames dazwischen einfügt.

5. Implementiere die "Quick-Check"-Sequenz aus dem Konzept (Sektion 2.3) als JSON in Resources/Sequences/quick_check.json.

6. Erweitere die Haupt-UI:
   - Home-Screen mit Liste vergangener Sessions (Stub-Daten reichen)
   - Modus-Auswahl (Quick / Full / Custom)
   - TestRunnerView startet die Quick-Check-Sequenz

Code muss kompilieren und auf dem iPhone-Simulator laufen. Aktualisiere IMPLEMENTATION_NOTES.md.
```

---

## Session 3 — Voice-Layer mit „Inspektor"-Wake-Word

```
Fortsetzung des Inspektor-Projekts. Bitte zuerst IMPLEMENTATION_NOTES.md lesen.

Implementiere den Voice-Layer in Core/VoiceLayer/ nach dem Konzept aus docs/01_Technisches_Konzept.docx, Sektion 4:

1. VoiceManager-Klasse, die mit SFSpeechRecognizer on-device-Erkennung macht (locale: de-DE und en-US umschaltbar).

2. State Machine mit drei Zuständen: idle, listening, dictation. Idle lauscht permanent auf "Inspektor", bei Erkennung wechselt zu listening (4-Sek-Window für Befehl), bei Befehl "Notiz" wechselt zu dictation für freie Sprache.

3. Befehls-Vokabular V1 implementieren (Sektion 4.2 des Konzepts): start, stop, pause, weiter, nächster Test, zurück, wiederholen, weiß/schwarz/rot/grün/blau/magenta/grau, splits, vignette, pass, fail, ok, problem, notiz, heller, dunkler, status, hilfe, abbrechen, report, beenden.

4. Befehle werden an einen VoiceCommandHandler weitergeleitet, der sie auf existierende App-Aktionen mapped (z. B. "nächster Test" → SequenceRunner.next()).

5. UI-Feedback: kleines Voice-Indicator-Overlay (wie im mockup/index.html), das den aktuellen State zeigt und erkannte Befehle kurz einblendet.

6. Privacy: alle Audio-Daten bleiben on-device, kein Cloud-Roundtrip, kein Aufnehmen von Audio in Dateien. Info.plist mit NSSpeechRecognitionUsageDescription und NSMicrophoneUsageDescription befüllen.

Background-Audio-Capability aktivieren, damit der Voice-Layer während Tests aktiv bleibt.

Aktualisiere IMPLEMENTATION_NOTES.md mit dokumentierten Befehlen und State-Machine-Diagramm.
```

---

## Session 4 — Apple Watch Companion

```
Fortsetzung. Bitte IMPLEMENTATION_NOTES.md lesen.

Implementiere die Apple-Watch-Companion-App nach Konzept (Sektion 5):

1. Neues Watch-App-Target im Xcode-Projekt anlegen (Name: InspektorWatch).
2. WatchConnectivity-basierte Kommunikation zwischen iPhone und Watch:
   - Watch → iPhone: Push-to-Talk-Trigger, Tap-Befehle (Pass, Fail, Pause, Next, Note)
   - iPhone → Watch: aktueller Test, Progress, Voice-Erkennung-Feedback, haptische Trigger
3. Watch-Screens nach Mockup (mockup/index.html, Watch-Views): Hauptscreen mit Test-Name + Progress + Pass/Fail-Buttons, dediziertes PTT-View.
4. Push-to-Talk: Krone-Press hält Mikrofon offen, loslassen sendet Audio-Buffer ans iPhone zur Erkennung (oder, alternativ: erkennt auf der Watch und sendet Text).
5. Haptik-Feedback: kurzer Tap bei Test-Wechsel, doppelter Tap bei erkanntem Voice-Befehl, langer Tap bei Sequenz-Ende.

Code muss auf Watch-Simulator laufen. Aktualisiere IMPLEMENTATION_NOTES.md.
```

---

## Session 5 — Persistenz und PDF-Reports

```
Fortsetzung. IMPLEMENTATION_NOTES.md lesen.

Implementiere Session-Persistenz und Report-Generierung:

1. SwiftData-Schema nach Konzept (Sektion 6): Session, CameraProfile, TestResult, Note, Report, AppSettings.
2. Session-Manager, der den kompletten Test-Lauf aufzeichnet — welcher Test wann, mit welchem Verdict, welcher Notiz.
3. PDF-Report-Generierung via PDFKit, Template SwiftUI-basiert. Inhalt: Header mit Kamera-Meta, Operator, Zeitstempel; Summary-Tabelle Pass/Fail/Notes; Detail-Liste mit allen Tests und Notizen mit Zeitstempeln.
4. Share-Sheet, das den PDF teilen lässt (AirDrop, Mail, Cloud).
5. Home-Screen: Liste vergangener Sessions ist jetzt aus SwiftData live, nicht mehr Stub.

Aktualisiere IMPLEMENTATION_NOTES.md.
```

---

## Session 6 — QA, Beta-Vorbereitung, App-Store-Connect

```
Fortsetzung. IMPLEMENTATION_NOTES.md lesen.

Bereite die App für eine TestFlight-Beta vor:

1. Code-Review: alle Module durchgehen, TODOs auflisten, kritische Bugs fixen.
2. Unit-Tests für TestEngine, SequenceRunner, VoiceCommandHandler.
3. Onboarding-Screen für Erst-Nutzer (Display-Selbsttest, Berechtigungen, Watch-Pairing).
4. Bug-Report-Funktion (sendet Diagnose-Daten via Mail-Sheet an Entwickler).
5. App-Store-Metadaten: Beschreibung, Keywords, Kategorie (Photo & Video), Privacy-Erklärung (NUR on-device, keine Cloud).
6. App-Icon-Slots als Platzhalter, falls Branding noch fehlt.

Zum Schluss: Build-Konfiguration für TestFlight prüfen (Signing, Provisioning-Profile, App-Store-Connect-Verbindung). Aktualisiere IMPLEMENTATION_NOTES.md mit Beta-Release-Checkliste.
```

---

## Tipps für die Arbeit mit Claude Code

- **Eine Aufgabe pro Session.** Verlangst du zuviel auf einmal, leidet die Code-Qualität.
- **Lass Claude Code Fragen stellen.** Wenn ein Prompt mehrdeutig ist, soll Code lieber zurückfragen als raten.
- **Lies IMPLEMENTATION_NOTES.md zwischen den Sessions.** Da steht, was wirklich passiert ist (nicht nur was angekündigt war).
- **Build nach jeder Session.** Wenn der Code nicht baut, ist die Session nicht abgeschlossen.
- **Halte Sessions kurz.** 30-60 Minuten pro Session — danach Kontext-Müdigkeit.
- **Commit nach jeder Session.** Im Repo dokumentieren, damit du jederzeit zu einem funktionierenden Stand zurück kannst.

---

## Wenn du Hilfe brauchst

Schritte, die der Code-Agent NICHT alleine machen kann und die du selbst tun musst:
- Apple Developer Account anlegen (99 €/Jahr) für TestFlight und App-Store
- Bundle-ID und App-Store-Connect-Eintrag erstellen
- Pilot-Tester einladen
- App-Icon-Design und Branding finalisieren

Für jeden dieser Schritte gibt es klare Apple-Dokumentation. Falls du daran nicht weiterkommst, kannst du auch dafür einen separaten Prompt in Claude Code starten („erkläre mir Schritt für Schritt, wie ich …").
