# Session-Prompts für Claude Code

Pro Entwicklungssession eine eigene Markdown-Datei. Reihenfolge:

| Datei | Inhalt | Voraussetzung |
|---|---|---|
| `03-metal-rec709-dit.md` | Metal-Renderer, Rec.709-legal, DIT-Sequenz | Session 2 abgeschlossen |
| `04-voice-layer.md` | Voice-Layer mit „Inspector"-Wake-Word | Session 3 abgeschlossen |
| `05-watch-companion.md` | Apple Watch App | Session 4 abgeschlossen |
| `06-persistence-pdf.md` | SwiftData und PDF-Reports | Session 5 abgeschlossen |
| `07-qa-testflight.md` | QA, Onboarding, TestFlight | Session 6 abgeschlossen |

## So nutzt du sie

In Claude Code:

```
Lies prompts/03-metal-rec709-dit.md und führe es aus.
```

Claude Code liest beim Start automatisch `CLAUDE.md` für den Projekt-Kontext. Dort stehen die harten Constraints (Rec.709-legal, iOS 18+, Wake-Word usw.), die für alle Sessions gelten.

## Wer ergänzt diese Datei?

Sessions 0-2 sind abgeschlossen und im `IMPLEMENTATION_NOTES.md` dokumentiert — daher nicht mehr hier. Wenn nach Session 7 weitere Iterationen (V2-Features wie Tele-Modus, Display-Kalibrierung) gewünscht sind, kommen die als `08-*.md`, `09-*.md` etc. dazu.
