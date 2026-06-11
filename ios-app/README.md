# iOS-App

Hier kommt später das eigentliche Xcode-Projekt rein, sobald die Entwicklung startet.

## Geplante Struktur

```
ios-app/
├── Inspector Moiré.xcodeproj/
├── Inspector Moiré/                    ← Haupt-App-Target
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
├── Inspector MoiréWatch/               ← Apple Watch Companion Target
└── Inspector MoiréTests/               ← Unit Tests
```

## Tech-Stack

- **UI:** SwiftUI (iOS 18+)
- **Rendering:** Metal + CAMetalLayer
- **Voice:** SFSpeechRecognizer (on-device)
- **Watch:** WatchConnectivity
- **Persistenz:** SwiftData
- **PDF:** PDFKit

Details siehe `../docs/01_Technisches_Konzept.docx`.
