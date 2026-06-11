# Session 7 — QA und TestFlight-Vorbereitung

Vorbereitung: `CLAUDE.md` und `IMPLEMENTATION_NOTES.md` lesen.

## Aufgabe

App für eine TestFlight-Beta-Phase vorbereiten. Code-Qualität sicherstellen, Onboarding bauen, App-Store-Metadaten erstellen.

## Komponenten

### 1. Code-Review aller Module

- TODO-Liste extrahieren (`grep -r "TODO" ios-app/`)
- Kritische Bugs identifizieren und fixen
- Code-Duplikation entfernen
- Konsistente Naming-Konvention (z. B. View-Suffixe)

### 2. Unit-Tests

Mindestens diese Test-Suites in `InspectorMoireTests/`:
- **TestEngineTests** — Test-Definition-Laden, Renderer-Selection, Color-Space-Conversion
- **SequenceRunnerTests** — Pre-Roll, Auto-Advance, next/previous/pause/repeat
- **VoiceCommandHandlerTests** — Vokabular-Mapping, State Machine
- **SessionManagerTests** — SwiftData-Operationen, Session-Lifecycle
- **PDFReportTests** — Generation aus Mock-Session

Ziel: alle Tests grün, `xcodebuild test` läuft durch.

### 3. Onboarding (Features/Onboarding/OnboardingFlow.swift)

Erst-Nutzer-Flow:
- Willkommen + Kurz-Pitch
- Display-Selbsttest (App zeigt fünf Vollflächen, Nutzer bestätigt visuell keine eigenen Defekte)
- Berechtigungs-Requests: Mikrofon, Spracherkennung
- Watch-Pairing-Hinweis (mit Skip-Option)
- iOS-Settings-Check: Hinweis True Tone / Night Shift deaktivieren

### 4. Bug-Report-Funktion

In Settings: „Bug melden"-Button öffnet `MFMailComposeViewController` mit:
- App-Version, iOS-Version, Gerät pre-filled
- Letzte 50 Log-Zeilen attached
- Empfänger-Mail-Adresse als Konstante (TODO: vor Release durch echte Support-Adresse ersetzen)

### 5. App-Store-Metadaten

In `marketing/AppStore.md`:
- App-Name: Inspector Moiré
- Untertitel (max 30 Zeichen): „Pro Camera Sensor Tests"
- Beschreibung (max 4000 Zeichen, deutsch und englisch)
- Keywords (kommasepariert, max 100 Zeichen): cinema, camera, dit, sensor, test, arri, red, sony
- Kategorie: Photo & Video (Primary), Utilities (Secondary)
- Altersfreigabe: 4+
- Privacy-Erklärung: alle Daten on-device, keine Cloud, keine Tracking, kein Account
- Screenshots-Liste (welche Screens, welche Geräte) — Placeholder-Bezeichnungen

### 6. App-Icon-Platzhalter

In `Assets.xcassets/AppIcon.appiconset/`:
- Alle benötigten Größen als einfaches Platzhalter-Icon (z. B. dunkler Hintergrund + Buchstabe „M")
- Markierung im Code (`// TODO: Replace with final icon design`)

### 7. Build-Konfiguration für TestFlight

- Signing-Configuration prüfen (Automatic Signing OK für Beta)
- Provisioning Profile-Setup-Notiz in IMPLEMENTATION_NOTES.md
- Build-Number und Version-String setzen
- Archive-Build laufen lassen (`xcodebuild archive`)
- Prüfen, dass Archive-Inhalt für App Store Connect Upload bereit ist

## Abschluss

- Alle Tests grün.
- Archive-Build erfolgreich.
- IMPLEMENTATION_NOTES.md abschließen mit Beta-Release-Checkliste (was muss der Mensch noch tun, bevor TestFlight-Submission möglich ist).
- Commit-Message: `Session 7 – QA, Onboarding, TestFlight-Vorbereitung`
- Push.

## Was nach dieser Session der Mensch tut

- Apple Developer Account anlegen (99 USD/Jahr)
- Bundle-ID `com.inspectormoire.app` (oder gewünschte ID) registrieren
- App-Store-Connect-Eintrag erstellen
- Archive im Xcode-Organizer auswählen und an App Store Connect uploaden
- Pilot-Tester (DIT, Rental-Partner) per TestFlight einladen
- App-Icon-Design beauftragen oder selbst gestalten
- Finales Branding (Logo, Marken-Anmeldung wenn gewünscht)
