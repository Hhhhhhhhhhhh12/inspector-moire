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
