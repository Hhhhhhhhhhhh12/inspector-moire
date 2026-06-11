# Implementation Notes

## Session 0 abgeschlossen — 2026-06-09

- **Repo-URL:** https://github.com/Hhhhhhhhhhhh12/inspector-moire
- **Pages-URL:** https://hhhhhhhhhhhh12.github.io/inspector-moire/mockup/
- **Default-Branch:** main
- **Commit-Hash:** 7978f7d

---

## Session 1 abgeschlossen — 2026-06-10

### Was wurde gebaut

Xcode-Projekt `ios-app/Inspektor.xcodeproj` mit `xcodegen` generiert (project.yml als Spec). Ziel: iOS 18.0, SwiftUI, Bundle-ID `com.inspektor.app`, Swift 6.

**Module:**
- `App/InspektorApp.swift` — App-Entry, instanziiert TestEngine und injiziert sie als EnvironmentObject
- `Features/Home/HomeView.swift` — Startbildschirm mit Button „Test starten"; öffnet TestRunnerView via fullScreenCover
- `Features/TestRunner/TestRunnerView.swift` — Vollbild-Testview; tap-to-dismiss; ruft DisplayManager beim Erscheinen/Verschwinden auf
- `Features/CameraSelection/CameraSelectionView.swift` — Stub für Session 3
- `Core/TestEngine/TestDefinition.swift` — Codable-Datenmodell (TestDefinition, TestParams, RendererType)
- `Core/TestEngine/TestEngine.swift` — ObservableObject; lädt JSON, verwaltet laufenden Test, liefert fullField-Farbe
- `Core/DisplayManager/DisplayManager.swift` — Singleton (@MainActor); setMaxBrightness(), disableAutoLock(), restore-Gegenstücke
- `Resources/TestDefinitions/test_definitions.json` — 5 fullField-Tests (weiß, schwarz, rot, grün, blau) im Konzept-Format (Sektion 2.1)

### Design-Entscheidungen

- **SwiftUI statt Metal** für Session 1: `Color(.displayP3, ...)` ist für einen SwiftUI-Prototyp ausreichend; Metal + CAMetalLayer kommen in Session 2 für präzises HDR-Rendering und volle Farbraum-Kontrolle.
- **Swift 6 Concurrency**: DisplayManager ist `@MainActor`, da UIScreen/UIApplication main-thread-only sind. TestEngine ist ebenfalls `@MainActor`.
- **TestEngine startet mit dem ersten Test** der JSON-Liste (Weiß) — Kamera-Auswahl und Sequenz-Navigation kommen in Session 3.
- Keine externen Dependencies; xcodegen ist Build-Tool, keine App-Dependency.

### Noch nicht enthalten (nächste Sessions)

- **Session 2:** Metal-Renderer für alle V1-Typen (splitQuadrants, splitStripes, grayWedge, colorPatches, marker); Launch Screen; App-Icon; Orientation Lock
- **Session 3:** Kamera-Auswahl (ARRI/RED/Sony Profile), Modus-Auswahl, Sequenz-Navigation, Voice Layer
- **Session 4:** Apple Watch Companion
- **Session 5:** SwiftData Persistenz, Session-Manager, PDF-Report
- Display-Selbsttest (True Tone / Night Shift Heuristik) — im DisplayManager als TODO markiert
- Build-Warnung „launch storyboard" — wird in Session 2 mit LaunchScreen-Einstellung in project.yml behoben

---

## Session 2 abgeschlossen — 2026-06-11

### Was wurde gebaut

Vollständiger Vor-Test-Flow als NavigationStack-Wizard, von Home bis zum Fullscreen-Test.

**Neue Module:**
- `App/AppNavigation.swift` — `enum AppNavigation: Hashable` für typisierten NavigationStack-Pfad (5 Destinationen)
- `App/InspektorColors.swift` — Color-Extension mit Designsystem-Konstanten (appBackground, appAccent, appSecondary, appSurface, appBorder)
- `Core/TestEngine/CameraProfile.swift` — Codable/Hashable-Struct mit isoDisplay-Helper
- `Core/TestEngine/TestSequence.swift` — TestSequence-Struct + TestMode-Enum (quickCheck / workshop / custom)
- `Core/TestEngine/SequenceRunner.swift` — @MainActor ObservableObject; Auto-Advance via `Task.sleep`; next/previous/pause/resume/stop
- `Core/TestEngine/SessionSetupModel.swift` — @MainActor ObservableObject; akkumuliert Kamera-Profil, Seriennummer, Objektiv, Operator, Modus
- `Features/CameraSelection/CameraSelectionView.swift` → **ManufacturerView** (rewritten): 3 Hersteller-Tiles mit Modell-Vorschau
- `Features/CameraSelection/ModelView.swift` — Modell-Liste mit Selection-Highlight und Weiter-Button
- `Features/CameraSelection/SessionDetailsView.swift` — Formularfelder Seriennummer/Objektiv/Operator
- `Features/ModeSelection/ModeSelectionView.swift` — 3 Mode-Cards; workshop/custom als „kommt in Session 3" markiert
- `Features/TestRunner/PreTestReminderView.swift` — Status-Rows (Brightness ✓, Auto-Lock ✓, Voice-Stub, Watch-Stub); Deep-Link zu iOS-Settings; erstellt und lädt SequenceRunner
- `Features/TestRunner/TestRunnerView.swift` — komplett neu: konsumiert SequenceRunner per EnvironmentObject, .id()-basierte Opacity-Transition beim Test-Wechsel
- `Resources/CameraProfiles/camera_profiles.json` — 10 Profile (ARRI ×3, RED ×3, Sony ×4)
- `Resources/Sequences/quick_check.json` — 5 fullField-Tests als erste Sequenz

**Geänderte Module:**
- `Core/TestEngine/TestEngine.swift` — loadAll(), loadCameraProfiles(), profiles(for:), sequence(for:), generische load()-Hilfsmethode
- `App/InspektorApp.swift` — injiziert SessionSetupModel als zweites EnvironmentObject
- `ios-app/project.yml` — Resources-Pfad auf ganzes Resources/-Verzeichnis erweitert (schließt automatisch neue JSON-Dateien ein)

### Design-Entscheidungen

- **Typed NavigationStack** (`[AppNavigation]`) statt NavigationPath: ermöglicht programmatisches Zurücksetzen (`path = []`) nach Testabschluss ohne Wrapper-ViewModel.
- **SequenceRunner lebt in PreTestReminderView** als `@StateObject`, wird per `.fullScreenCover` als EnvironmentObject in TestRunnerView injiziert — klare Ownership-Kette, kein globaler State.
- **Auto-Advance** via `Task.sleep` (Swift Concurrency) statt `Timer`: passt zu @MainActor-Isolation, keine Retain-Cycle-Gefahr, sauber cancellierbar.
- **Test-Transition** über `.id(runner.currentIndex)` + `.transition(.opacity)` + `.animation(…)` — SwiftUI diffed identity, Crossfade ohne eigenen AnimationState.
- **Voice/Watch als Stubs** (`isVoiceReady = true` implizit via Statuszeile): klar als „Session 4" markiert, verhindert keine Nutzung.

### Noch nicht enthalten

- **Session 3:** Metal-Renderer (splitQuadrants, grayWedge, colorPatches, marker); Werkstatt- und Custom-Sequenz; LaunchScreen
- **Session 4:** Voice Layer (SFSpeechRecognizer, Wake-Word), Apple Watch Companion
- **Session 5:** SwiftData Persistenz, SessionManager, PDF-Report
- History-Tab (Tap auf Mock-Sessions in HomeView navigiert noch nirgendwo hin)
- Orientation Lock (Test sollte in Portrait locked sein)

---

## Session 3 abgeschlossen — 2026-06-11

### Was wurde gebaut

Metal-Renderer mit Rec.709-legal-Farbraum und DIT-Referenzsequenz.

**Neue Module:**
- `Core/TestEngine/Shaders.metal` — Vertex + Fragment-Shader für alle 6 Renderer-Typen: fullField, splitQuadrants, splitStripes (H/V), grayWedge, colorPatches. Marker-Typ liefert schwarzes fullField, Text-Overlay via SwiftUI.
- `Core/TestEngine/RenderColorSpace.swift` — Enum: rec709Legal (Default) / rec709Full / displayP3 mit CGColorSpace-Mapping.
- `Core/TestEngine/MetalRenderer.swift` — Baut RenderParams-Struct (80 Byte, exakt auf Metal-Layout ausgerichtet), erzeugt MTLRenderPipelineState, rendert on-demand per `render(test:onto:)`.
- `Core/TestEngine/MetalView.swift` — UIViewRepresentable-Wrapper: MetalUIView (CAMetalLayer als layerClass), re-rendert in layoutSubviews (drawable size) und updateUIView (test/colorspace change).
- `Core/TestEngine/SettingsModel.swift` — @MainActor ObservableObject mit `colorSpace: RenderColorSpace` (Standard: rec709Legal).
- `Features/Settings/SettingsView.swift` — Sheet mit Farbraum-Auswahl (3 Optionen) und Hinweis auf Real-Device-Validierung.

**Neue Sequenzen:**
- `Resources/Sequences/dit_reference.json` — 13 Schritte, 99 Sekunden, 1:1 aus DIT-Referenzclip (BT.709 10-bit, geliefert vom DIT). Sequenz verifiziert gegen CLAUDE.md-Tabelle.
- `Resources/Sequences/quick_check.json` — 7 Schritte, ~41 Sekunden (Grey Lead-In → W/K/R/G/B → Grey Lead-Out).

**Geänderte Module:**
- `Core/TestEngine/TestDefinition.swift` — TestParams um color2/3/4, stripeCount, wedgeSteps, orientation, markerText erweitert (alle optional, rückwärtskompatibel).
- `Core/TestEngine/TestSequence.swift` — SequenceStep-Struct (testId + durationOverride) + TestMode um `.ditReference` erweitert; beide Formate (testIds-Liste und steps-Array) unterstützt.
- `Core/TestEngine/SequenceRunner.swift` — SequencePhase-Enum (idle/armed/running/paused/done); ResolvedTest-Struct (Definition + effektive Dauer); arm()/triggerStart() für Pre-Roll-Verhalten (DIT setzt Klappe während Lead-In-Grau).
- `Features/TestRunner/TestRunnerView.swift` — nutzt MetalView statt SwiftUI-Color; zeigt „Tap to Start"-Overlay im armed-State; Tap im running-State bricht ab.
- `Resources/TestDefinitions/test_definitions.json` — Rec.709-legal-Werte (verifiziert gegen DIT-Clip): White (235/255), Black (16/255), Red (232/255, 16/255, 16/255), Green (16/255, 232/255, 16/255), Blue (16/255, 16/255, 232/255), neu: Grey50 (126/255). durationSeconds auf 10 s erhöht.
- `App/InspektorApp.swift` + `Features/Home/HomeView.swift` + `Features/TestRunner/PreTestReminderView.swift` — SettingsModel als EnvironmentObject injiziert; Settings-Gear-Button in HomeView.

### Design-Entscheidungen

- **RenderParams als Plain Struct** (keine SIMD-Typen): tuple `(Float, Float, Float, Float)` garantiert identisches Speicherlayout zum Metal `float4` ohne Alignment-Überraschungen in Swift 6.
- **Render-on-demand** statt DisplayLink: Testbilder sind statisch — ein Aufruf pro Test-Wechsel reicht. Kein 60-fps-Loop nötig, kein CPU-Wakeup zwischen Tests.
- **CAMetalLayer.colorspace = itur_709** wird gesetzt, keine Gamma-Korrektur im Shader. Werte aus JSON gehen 1:1 ins Framebuffer. Der Kompositor übernimmt die Umrechnung auf die Display-Gamut.
- **Marker-Renderer**: Metal rendert legal-black Hintergrund, Text wird als SwiftUI-Overlay eingeblendet. Da der Marker ein Trennframe ist (kein Sensor-Test), ist ein SwiftUI-Overlay hier vertretbar.
- **Pre-Roll / armed-State**: SequenceRunner.arm() zeigt ersten Frame (Grey50), Timer startet erst auf Tap oder späteres Voice-Kommando. DIT hat so Zeit, Klappe zu setzen.

### Offene Punkte (Real-Device-Tests)

- **Color-Space-Verifikation nur auf echtem Gerät**: Simulator verwendet Mac-Farbmanagement und simuliert itur_709 nicht korrekt. Auf iPhone 14 Pro+ muss verifiziert werden, dass RGB(235,235,235) nicht als Clipping erscheint und RGB(16,16,16) nicht als reines Schwarz.
- **Metal-Download**: Metal Toolchain (688 MB) war nicht installiert, wurde via `xcodebuild -downloadComponent MetalToolchain` nachgeladen. Build-Umgebung ist jetzt vollständig.
- **Orientation Lock** und LaunchScreen noch offen.

### Nächste Sessions

- **Session 4:** Voice-Layer (`SFSpeechRecognizer`, Wake-Word „Inspector", Active-Test-Modus ohne Wake-Word, Emergency-Befehle)
- **Session 5:** Apple Watch Companion (WatchConnectivity, PTT, Haptik)
- **Session 6:** SwiftData-Persistenz, SessionManager, PDF-Report
