# Inspektor

> iPhone-App zur sprachgesteuerten Vorbereitung von Kameratests an professionellen Cine-Kameras.

**Status:** Konzept-Phase · Pre-Production · Noch keine Entwicklung gestartet
**Plattform:** iOS 18+ (iPhone 14 Pro und neuer) · watchOS 11+
**Sprachen:** Deutsch · Englisch

---

## Worum geht es

Inspektor ist eine professionelle Sensor-Test-App für DITs, Kameraassistenz und Rental-Servicewerkstätten. Das iPhone wird vor die Cine-Kamera gehalten und zeigt eine definierte Sequenz von Testbildern (Vollflächen, Splits, Vignettierungs-Patterns, FPN-Tests). Der DIT steuert die App parallel per Sprachbefehl mit dem Wake-Word **„Inspektor"** oder über eine Apple-Watch-Companion-App mit Push-to-Talk.

**Kernbenefit:** Inspektor ersetzt den heute verbreiteten Notbehelf — einen MacBook-Bildschirm bewusst unscharf abzufilmen — durch eine professionelle, portable, dokumentierte und freihändig bedienbare Lösung. Quick-Checks gehen von 15 Minuten Aufbau auf 3-5 Minuten Sequenz-Lauf inklusive PDF-Report.

---

## Was kann die App

- **Sensor-Tests** (V1): Pixelfehler-Detektion (Vollflächen B/W/R/G/B/CMY), 4-Quadranten-Splits, vertikale/horizontale Streifen-Splits, Uniform White (Vignettierung), Uniform Black (FPN), 18% Grey (Uniformität), Color-Cast-Check, Graukeil-Treppe, Macbeth-Style-Patches.
- **Voice Assistant** (V1): Wake-Word „Inspektor" plus klares Befehls-Vokabular für Sequenz-Steuerung, Pass/Fail-Tagging und freie Notizen — komplett on-device, kein Cloud-Roundtrip.
- **Apple Watch Companion** (V1): Push-to-Talk, Test-Status, haptisches Feedback, Quick-Action-Buttons.
- **PDF-Reports** (V1): Vollständige Dokumentation mit Kamera-Meta, Test-Ergebnissen, Notizen, Zeitstempeln. Per AirDrop, Mail oder Cloud teilbar.
- **Tele-Modus** (V2): Optionale Optik-Tests bei langen Brennweiten mit ausreichend Abstand.
- **Display-Kalibrierung** (V2): Optionaler Zwei-iPhone-Workflow nach Apple-TV-Vorbild — ohne externe Hardware.

---

## Unterstützte Kameras (V1-Profile)

| Hersteller | Modelle |
|---|---|
| ARRI | Alexa 35 · Alexa Mini · Alexa Mini LF |
| RED | Komodo · V-Raptor · Helium |
| Sony | Venice 2 · FX9 · FX6 · FX3 |

Weitere Profile (Blackmagic, Phantom etc.) sind für V2 vorgesehen.

---

## Projekt-Struktur

```
Inspektor/
├── README.md                    ← dieses Dokument
├── UPLOAD_TO_GITHUB.md          ← Schritt-für-Schritt-Upload-Anleitung
├── .gitignore                   ← für künftige iOS/Swift-Entwicklung
├── docs/                        ← Konzept-Dokumente
│   ├── 01_Technisches_Konzept.docx
│   ├── 02_Kalibrierungs_Recherche.docx
│   ├── 03_Risiken_Annahmen.docx
│   └── 04_DIT_Fragebogen.docx
├── mockup/                      ← interaktiver UI-Mockup für Pitch
│   └── index.html
└── ios-app/                     ← künftige Xcode-Projektstruktur (leer)
    └── README.md
```

---

## Aktueller Stand und nächste Schritte

**Abgeschlossen:**
- [x] Konzept-Workshop und Scope-Definition
- [x] Recherche zu iPhone-Display-Charakteristiken und iOS-Restriktionen
- [x] Technisches Konzept-Dokument (Architektur, Datenmodell, Modul-Schätzung)
- [x] Risiken- und Annahmen-Liste zur DIT-Validierung
- [x] DIT-Fragebogen versendet
- [x] Interaktiver UI-Mockup (Quick-Check-Workflow) für Pitch

**Offen:**
- [ ] DIT-Antworten einarbeiten
- [ ] Pitch-Deck erstellen
- [ ] Pricing-Modell festlegen
- [ ] Entwickler-Auswahl
- [ ] V1-Entwicklungsstart

---

## Geschätzter Aufwand V1

Etwa **16 Wochen** (~4 Monate) Vollzeit-iOS-Entwicklung plus ~20 % Design und ~15 % QA. Detaillierte Modul-Aufschlüsselung im technischen Konzept-Dokument (`docs/01_Technisches_Konzept.docx`, Sektion 8).

---

## Mockup anschauen

Den interaktiven UI-Mockup öffnest du, indem du die Datei `mockup/index.html` im Browser öffnest. 13 Screens, klickbar mit den Pfeiltasten oder den Buttons. Zeigt den kompletten Quick-Check-Workflow inkl. Sprachsteuerung und Watch-Integration.

---

## Mitwirkende

- **Henneke H.** — Initiator, Konzept, Product Lead
- **DIT-Beratung** — externes Fach-Feedback (Set-Praxis, Kamera-Erfahrung)

---

## Lizenz

Noch nicht festgelegt. Standardmäßig „All rights reserved", bis eine bewusste Lizenz-Entscheidung getroffen wird.
