# Session-Anleitungen für Coding-Agenten

**Aktueller Stand:** Sessions **0–3 sind laut [IMPLEMENTATION_NOTES.md](../IMPLEMENTATION_NOTES.md) abgeschlossen**; die Swift-/Metal-Komponenten und die JSON-Sequenzen von Session 3 sind im Repository vorhanden. Die weiteren Sessions wurden **nicht** umgesetzt oder durch diese Dokumentation beauftragt. Vor einer neuen Aufgabe zuerst [CLAUDE.md](../CLAUDE.md) und den tatsächlichen Code lesen.

| Datei | Status | Inhalt |
|---|---|---|
| `03-metal-rec709-dit.md` | **abgeschlossen / historischer Umsetzungsauftrag** | Metal-Renderer, Rec.709, DIT-Sequenz; **nicht erneut ausführen** |
| `04-voice-layer.md` | offen / Planung | Voice-Layer mit „Inspector“-Wake-Word |
| `05-watch-companion.md` | offen / Planung | Apple Watch Companion |
| `06-persistence-pdf.md` | offen / Planung | SwiftData und PDF-Reports |
| `07-qa-testflight.md` | offen / Planung | QA, Onboarding, TestFlight |

Eine Planung in einem Prompt ist kein Nachweis für implementierte Funktionalität oder einen erfolgreichen Build. Die Dateinamen und Kennungen in noch nicht ausgeführten Anleitungen (z. B. zukünftiger Watch-Target-/Report-/App-Name) sind **Vorschläge**, keine genehmigten finalen Markenentscheidungen. Der App-Name ist laut [Markenwelt](../docs/BRAND_WORLD.md) offen.

## Vorgehen

- **Keine Session eigenmächtig starten.** Nur nach ausdrücklichem Auftrag die passende Anleitung verwenden; vorher Implementierungsnotizen und Quellcode auf bereits Erledigtes prüfen.
- Für jede Änderung einen eigenen Branch und Pull Request verwenden; `main` nicht direkt bearbeiten. Diff, tatsächliche Tests und erforderliche Freigabe vor einem möglichst als Squash ausgeführten Merge kontrollieren.
- Dokumentationskorrekturen erzeugen keine Berechtigung, Swift-Code, Sequenzen, Farbraumkonfiguration oder Branding zu ändern.
- Die alte [CLAUDE_CODE_HANDOVER.md](../CLAUDE_CODE_HANDOVER.md) enthält eine **überholte Session-Nummerierung** und dient nur als historische Referenz. Massgeblich ist diese Übersicht in Verbindung mit `IMPLEMENTATION_NOTES.md`.

**Bekannte notwendige Geräteprüfung:** Rec.709-Legal-Ausgabe und Clipping auf einem realen iPhone; die Simulator- bzw. Toolchain-Verfügbarkeit belegt diese Prüfung nicht.
