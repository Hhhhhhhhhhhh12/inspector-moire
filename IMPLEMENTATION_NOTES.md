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
