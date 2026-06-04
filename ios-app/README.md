# iOS-App

Hier kommt später das eigentliche Xcode-Projekt rein, sobald die Entwicklung startet.

## Geplante Struktur

```
ios-app/
├── Inspektor.xcodeproj/
├── Inspektor/                    ← Haupt-App-Target
│   ├── App/
│   ├── Features/
│   │   ├── Home/
│   │   ├── CameraSelection/
│   │   ├── TestRunner/
│   │   ├── VoiceLayer/
│   │   └── Reporting/
│   ├── Core/
│   │   ├── TestEngine/
│   │   ├── DisplayManager/
│   │   └── SessionManager/
│   ├── Resources/
│   │   ├── CameraProfiles/      ← JSON-Profile pro Kamera
│   │   └── TestDefinitions/     ← JSON-Test-Definitionen
│   └── Assets.xcassets/
├── InspektorWatch/               ← Apple Watch Companion Target
└── InspektorTests/               ← Unit Tests
```

## Tech-Stack

- **UI:** SwiftUI (iOS 18+)
- **Rendering:** Metal + CAMetalLayer
- **Voice:** SFSpeechRecognizer (on-device)
- **Watch:** WatchConnectivity
- **Persistenz:** SwiftData
- **PDF:** PDFKit

Details siehe `../docs/01_Technisches_Konzept.docx`.
