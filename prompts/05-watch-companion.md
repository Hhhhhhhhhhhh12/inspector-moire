# Session 5 — Apple Watch Companion

Vorbereitung: `CLAUDE.md` und `IMPLEMENTATION_NOTES.md` lesen.

## Aufgabe

Watch-Begleitapp als primäres Eingabegerät während des Tests. Watch hat das Mikrofon nah am Mund und ein Display für visuelles Feedback, während das iPhone vor der Linse hängt.

## Komponenten

### 1. Watch-App-Target

Neues Watch-App-Target im Xcode-Projekt anlegen:
- Name: `InspectorMoireWatch`
- Minimum: watchOS 11.0
- Sprache: Swift, SwiftUI

### 2. WatchConnectivity (Core/WatchBridge/)

Bidirektionale Kommunikation iPhone ↔ Watch:

**Watch → iPhone:**
- PTT-Trigger (Krone-Press start, release)
- Tap-Befehle: Pass, Fail, Pause, Next, Previous, Note, Start-after-Pre-Roll

**iPhone → Watch:**
- Aktueller Test (Name, Index, Progress)
- Voice-Erkennungs-Feedback („Befehl erkannt: pass")
- Haptische Trigger
- Verbindungsstatus

### 3. Watch-Screens (nach mockup/index.html, Watch-Views)

**Hauptscreen während Test:**
- Test-Name (kompakt: „Uniform White")
- Progress „4/8" + Restzeit
- Progress-Bar
- Pass/Fail-Buttons (groß, klar trennbar)

**PTT-View (dedicated):**
- Großer Mikrofon-Indicator
- Hint: „Krone halten zum Sprechen"
- Letzter erkannter Befehl als Echo

**Idle-Screen (vor Test):**
- App-Name
- Verbindungsstatus
- „Start"-Button (für „Start-after-Pre-Roll"-Trigger)

### 4. Push-to-Talk

- Krone-Press hält Mikrofon offen, loslassen sendet Audio-Buffer ans iPhone zur Erkennung.
- Alternative: Watch macht eigene SFSpeechRecognizer-Erkennung und sendet nur Text-Befehl ans iPhone (geringere Latenz, aber doppelter Code).
- Entscheidung dokumentieren in IMPLEMENTATION_NOTES.md.

### 5. Haptik-Feedback

- Kurzer Tap (`.click`) bei Test-Wechsel
- Doppelter Tap (`.success`) bei erkanntem Voice-Befehl
- Langer Tap (`.notification`) bei Sequenz-Ende
- Warnung (`.failure`) bei Verbindungs-Abriss

## Abschluss

- Build auf Watch-Simulator laufen lassen.
- IMPLEMENTATION_NOTES.md mit Watch-iPhone-Protokoll-Beschreibung.
- Commit-Message: `Session 5 – Apple Watch Companion mit Push-to-Talk`
- Push.
