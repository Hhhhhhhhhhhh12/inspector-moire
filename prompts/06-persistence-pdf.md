# Session 6 — Persistenz und PDF-Reports

Vorbereitung: `CLAUDE.md` und `IMPLEMENTATION_NOTES.md` lesen.

## Aufgabe

Test-Sessions persistent speichern und als professionellen PDF-Report exportierbar machen — für Rental, Insurance, DOP-Dokumentation.

## Komponenten

### 1. SwiftData-Schema

Modelle in `Core/Persistence/Models/`:

**Session**
- id (UUID)
- startedAt, endedAt (Date)
- cameraProfile (CameraProfile-Referenz)
- operator (String)
- mode (Enum: quick/full/custom)
- status (Enum: inProgress/completed/aborted)
- colorSpaceUsed (String — "rec709-legal" / "rec709-full" / "display-p3")

**CameraProfile**
- id, manufacturer, model
- sensorResolution, pixelPitchMicrons, recommendedISO

**TestResult**
- id, sessionId
- testId (Referenz auf Test-Definition)
- startedAt, durationSeconds
- verdict (Enum: pass/fail/notRated)
- notes (Relationship)

**Note**
- id, testResultId
- timestamp, content
- source (Enum: voice/touch)

**Report**
- id, sessionId
- generatedAt, pdfURL
- sharedTo (optional)

**AppSettings**
- voiceEnabled, wakeWordEnabled, language
- defaultColorSpace, watchPairingState

### 2. Session-Manager (Core/Persistence/SessionManager.swift)

- `startSession(camera:operator:mode:)` → erzeugt neue Session
- `recordTestResult(testId:verdict:)` → speichert pro Test
- `addNote(testResultId:content:source:)` → fügt Notiz hinzu
- `endSession()` → markiert als completed, triggert Report-Generation

### 3. PDF-Report (Core/Reporting/PDFReportGenerator.swift)

Template SwiftUI-basiert (rendert SwiftUI-Views in PDF via `ImageRenderer`). Inhalt:

**Header:**
- Logo/Titel „Inspector Moiré Camera Test Report"
- Kamera: Hersteller, Modell, Seriennummer
- Objektiv, Operator
- Datum, Start- und Endzeit
- Modus (Quick/Full/Custom)
- Color-Space (welche Renderer-Konfiguration war aktiv)

**Summary:**
- Tests gesamt
- Pass / Fail / Not Rated
- Anzahl Notizen
- Total Duration

**Test-Details (pro Test):**
- Index + Name
- Verdict (farbig)
- Notizen mit Zeitstempel

**Footer:**
- App-Version, Datum der Generation
- Disclaimer

### 4. Share-Sheet

`UIActivityViewController` für PDF-Versand:
- AirDrop, Mail, Cloud (iCloud Drive, Files), Drittanbieter

### 5. Home-Screen live

Sessions-Liste aus SwiftData live (nicht mehr Stub aus Session 2):
- Filter nach Datum, Kamera, Operator
- Tap auf Session öffnet Detail-View mit Test-Liste und „Report neu generieren"-Option

## Abschluss

- Build muss laufen.
- Testen: komplette Quick-Check-Sequenz durchspielen, Notiz hinzufügen, PDF generieren, im Simulator-File-Browser ansehen.
- IMPLEMENTATION_NOTES.md mit SwiftData-Schema und PDF-Template-Beschreibung.
- Commit-Message: `Session 6 – SwiftData-Persistenz und PDF-Reports`
- Push.
