# Session 4 — Voice-Layer mit „Inspector"-Wake-Word

Vorbereitung: `CLAUDE.md` und `IMPLEMENTATION_NOTES.md` lesen.

## Aufgabe

On-device Spracherkennung implementieren, sodass der DIT die App freihändig steuern kann.

## Komponenten

### 1. VoiceManager (Core/VoiceLayer/VoiceManager.swift)

- `SFSpeechRecognizer` mit on-device-Modus (`requiresOnDeviceRecognition = true`).
- Locale umschaltbar zwischen `de-DE` und `en-US` über AppSettings.
- AVAudioEngine für kontinuierlichen Audio-Stream, solange App im Vordergrund.

### 2. State Machine

```
idle → listening → dictation → idle
       ↑                ↓
       └────────────────┘
```

- **idle:** Lauscht nur auf Wake Word „Inspector" (englisch) bzw. „Inspektor" (deutsch). Sehr geringer Compute-Bedarf.
- **listening:** Wake Word erkannt — 4-Sekunden-Fenster für Befehl aus definiertem Vokabular. UI-Sound bei Eintritt.
- **dictation:** Bei Befehl „Notiz" — freie Spracheingabe, bis 2 Sekunden Pause oder „fertig"/„stop" erkannt wird.

### 3. Befehls-Vokabular V1

| Kategorie | Befehle |
|---|---|
| Sequenz | start, stop, pause, weiter, nächster Test, zurück, wiederholen |
| Direkt-Tests | weiß, schwarz, rot, grün, blau, magenta, grau, splits, vignette |
| Bewertung | pass, fail, ok, problem |
| Notizen | notiz [freier Text bis Pause] |
| Anzeige | heller, dunkler, fullscreen, status, wieviel zeit |
| System | hilfe, abbrechen, report, beenden |

### 4. VoiceCommandHandler

Mapping von erkannten Befehlen auf existierende App-Aktionen:
- „nächster Test" → `SequenceRunner.next()`
- „start" → `SequenceRunner.startAfterPreRoll()` (löst Pre-Roll-Trigger aus Session 3 aus)
- „fail" → aktuellen Test als Fail markieren
- usw.

### 5. UI-Feedback

Kleines Voice-Indicator-Overlay wie im Mockup (`mockup/index.html`):
- Wave-Animation während Listening-State
- Aktueller State („Höre zu …" / „Befehl erkannt")
- Zuletzt erkannter Befehl als Transkript

### 6. Privacy

- Alle Audio-Daten bleiben on-device, kein Logging in Dateien, kein Cloud-Roundtrip.
- `Info.plist`:
  - `NSSpeechRecognitionUsageDescription`: „Inspector Moiré nutzt Spracherkennung für die freihändige Steuerung während Kameratests. Audio bleibt vollständig auf Ihrem Gerät."
  - `NSMicrophoneUsageDescription`: „Inspector Moiré verwendet das Mikrofon zur Erkennung des Wake-Wortes und der Befehle."
- Background-Audio-Capability in Xcode-Target-Settings aktivieren.

## Abschluss

- Build muss laufen.
- IMPLEMENTATION_NOTES.md mit dokumentierten Befehlen und State-Machine-Verhalten.
- Commit-Message: `Session 4 – Voice-Layer mit Inspector-Wake-Word`
- Push.
