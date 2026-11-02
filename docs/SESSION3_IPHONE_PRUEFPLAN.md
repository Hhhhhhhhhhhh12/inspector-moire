# Session 3 — iPhone-Geräteabnahme: Prüfplan

**Stand: 02.11.2026 · nur Vorbereitung · keine Geräteprüfung durchgeführt.**

Grundlage ist `main` bei [`5ece89434db008b9dac6cadae8a3928665cf0082`](https://github.com/Hhhhhhhhhhhh12/inspector-moire/commit/5ece89434db008b9dac6cadae8a3928665cf0082).
Session 3 bleibt als implementiert dokumentiert; eine Geräte- oder Farbabnahme folgt daraus nicht.
Dieser Plan beginnt keine neue Entwicklungssession und ändert weder Rendering noch Ressourcen.

**Zeitpunkt:** Laut Nutzerhinweis wird die App gerade umgestaltet. Die praktische Abnahme ist
für den Stand nach diesem Umbau vorgesehen. Dessen Branch/Commit wurde hier nicht abgeglichen.
Vor Ausführung Bedienwege, Renderer, Sequenzen und Lebenszyklus gegen den tatsächlich zu
prüfenden Commit abgleichen und den Plan gegebenenfalls aktualisieren. Die nachfolgenden
Bedienwege beschreiben ausschliesslich den oben genannten Ausgangsstand.

## 1. Auftrag, Zuständigkeit und offene Voraussetzungen

Verantwortlich für Vorbereitung: Dokumentationsauftrag. Für Ausführung und Beurteilung:
benannte prüfende Person, für Farbabnahme zusätzlich DIT/Messverantwortliche.
Der aktuelle Auftrag autorisiert nur Dokumentation, Quellen-/Diffprüfung und einen Pull Request.
Build, Installation, Simulator, Laufzeit- und Geräteprüfungen benötigen einen gesonderten Auftrag.
Ein Merge wartet ebenfalls auf Freigabe.

| Voraussetzung / Frage vor späterer Ausführung | Aktueller Stand |
|---|---|
| Welches reale Gerät und welche OS-Version? | **iPhone 17, iOS 27** laut Nutzerangabe vom 02.11.2026; genaue Modellkennung, OS-Build und Displayzustand noch im Protokoll ergänzen |
| Welcher Stand nach dem UI-Umbau wird abgenommen? | Offen: Commit, App-Build und Zuordnung des installierten Builds zum Quellstand |
| Ist ein installierter, eindeutig zugeordneter Build vorhanden? | Offen; Anzeige „0.3.0 (Session 3)“ allein belegt keinen Commit |
| Welche Messtechnik und Software sind vorhanden? | Offen / für spätere Messplanung zurückgestellt; keine Ausrüstung voraussetzen oder Beschaffung ableiten |
| Ist der originale DIT-Clip verfügbar, mit welcher Version/Prüfsumme? | Im Repository nicht enthalten; Quelle und aktuelle Verfügbarkeit offen |
| Welche Ziel-Leuchtdichte, Transferfunktion und Farbtoleranzen gelten? | Vor farbmetrischer Abnahme mit DIT festlegen; keine Grenzwerte aus App-Bezeichnungen ableiten |
| Welche Timing-Toleranz wird für den Einsatzzweck verlangt? | Offen; nominale Sekundenwerte sind kein Nachweis für Frame-Synchronität |

Zielgeräte: iPhone 14 Pro oder neuer gemäss Projektziel, iOS mindestens 18 gemäss Projekt.
Ergebnisse gelten ausschliesslich für die tatsächlich protokollierte Geräte-/OS-/Build-Kombination.
Eine Prüfung des iPhone 17 validiert nicht automatisch alle anderen Modelle.

## 2. Was der Ausgangsstand tatsächlich bereitstellt

| Quelle | Für die Prüfung relevante Feststellung aus dem Quellcode |
|---|---|
| [RenderColorSpace.swift](../ios-app/Inspektor/Core/TestEngine/RenderColorSpace.swift), [SettingsModel.swift](../ios-app/Inspektor/Core/TestEngine/SettingsModel.swift) | Legal ist Standard. Legal und Full setzen beide `itur_709`; P3 setzt `displayP3`. Auswahl nur im Arbeitsspeicher, keine persistente Einstellung |
| [MetalRenderer.swift](../ios-app/Inspektor/Core/TestEngine/MetalRenderer.swift), [Shaders.metal](../ios-app/Inspektor/Core/TestEngine/Shaders.metal) | `bgra8Unorm`, Vollflächen geben JSON-Farbwerte weiter; keine vom Setting abhängige Legal-/Full-Umskalierung. Der DIT-Quellclip ist laut Notizen 10-bit; das belegt keine 10-bit-App-Ausgabe |
| [Testdefinitionen](../ios-app/Inspektor/Resources/TestDefinitions/test_definitions.json) | Sechs Vollflächen. Keine 0/255-Vergleichsflächen, Near-Black-/Near-White-Stufen oder per UI aufrufbaren Graukeile |
| [SequenceRunner.swift](../ios-app/Inspektor/Core/TestEngine/SequenceRunner.swift) | `arm()`: erstes Grau ohne laufenden Timer. `triggerStart()`: erste volle Haltezeit beginnt. Auto-Advance über `Task.sleep`, keine Zeitcode-/Kamerasynchronisation |
| [TestRunnerView.swift](../ios-app/Inspektor/Features/TestRunner/TestRunnerView.swift) | Armed: „Tap to Start“. Erster Tap startet; Tap während des Laufs beendet. Ende führt zurück. Wechsel enthält eine 0,3-s-Opacity-Animation; deren sichtbares Verhalten ist zu prüfen |
| [DisplayManager.swift](../ios-app/Inspektor/Core/DisplayManager/DisplayManager.swift) | Beim Erscheinen Helligkeit speichern/auf 1,0 setzen und Idle-Timer deaktivieren; beim Verschwinden Helligkeit zurücksetzen und Idle-Timer aktivieren. Keine gesicherte Wiederherstellung bei jedem Unterbrechungspfad |
| App/Runner/DisplayManager | Keine explizite Behandlung von `scenePhase` für Pause, Hintergrund oder Wiederanlauf in den gelesenen Dateien |

**Konsequenz für alternative Farbräume:** Das Setting „Rec.709 Full Range“ macht aus den
vorhandenen 16/235-orientierten Werten keine 0/255-Testbilder. Für Legal und Full ist bei
gleichen Bedingungen dieselbe Ausgabe zu erwarten (Quellcodeableitung, noch nicht am Gerät
beobachtet). P3 verwendet dieselben Zahlen mit anderer Farbraumzuordnung; eine sichtbare
Änderung ist weder zwingend noch schon ein Fehler. Keine P3-Abnahme anhand eines Rec.709-Looks.

## 3. Aussagekraft: Sehen, Kamera und Messgerät

| Verfahren | Damit erfassbar | Damit nicht nachgewiesen |
|---|---|---|
| Visuelle Prüfung direkt am iPhone | Richtige Farbreihenfolge, grobe Farbstiche, fehlende Flächen, Overlays, auffällige Helligkeitssprünge | Exakte RGB-Ausgabe, Weisspunkt, Leuchtdichte, Transferfunktion, Farbtoleranzen oder Clippingfreiheit |
| Externe Videoaufnahme / Stoppuhr | Ablauf, Wechselzeitpunkte und Rückkehr; mit dokumentierter Zeitbasis | Kalibrierte Farbe; automatische Kameraanpassungen können Fehler vortäuschen |
| Cine-Kamera + Waveform | Verhalten der gesamten Aufnahme-Kette, insbesondere kameraeigene Übersteuerung | Isolierte Kalibrierung des iPhone-Displays oder direkte Gleichheit mit den JSON-Codewerten |
| Geeignetes Colorimeter oder Spektroradiometer | Physische Leuchtdichte und Chromatizität im dokumentierten Messaufbau | Ohne Zieldefinition, passende Korrektur/Kalibrierung und Messunsicherheit keine pauschale Rec.709-/P3-Konformität |

Chromatizität (`x/y`) beschreibt die Farbe unabhängig von ihrer Helligkeit; `Y` in cd/m²
die Leuchtdichte. Clipping bedeutet, dass verschiedene Eingangsstufen auf denselben Grenzwert
fallen und Details verlorengehen. Eine einzelne Schwarz- oder Weissfläche kann das nicht ausschliessen.

**Legal-Codewerte sind keine Lichtmesswerte:** BT.709 nennt für digitale RGB-/Y-Signale
nominal Schwarz 16 und Weiss 235 bei 8 bit, 64/940 bei 10 bit. Daraus folgt nicht, dass eine
abfotografierte Fläche diese Zahlen in einer Kamera-Waveform zeigen muss. Hier gehen normierte
RGB-Werte in einen Metal-Layer; dessen Farbraumzuordnung und die anschliessende Darstellung
müssen als eigene Kette beurteilt werden. Die Notiz „16 nicht als reines Schwarz / 235 nicht
als Clipping“ ist ein offener Prüfverdacht, kein bereits belegtes Ergebnis und keine universelle
Umrechnungsvorschrift. Quellen: [BT.709-6, Abschnitt 4.6](https://www.itu.int/dms_pubrec/itu-r/rec/bt/R-REC-BT.709-6-201506-I%21%21PDF-E.pdf),
[Apple: CAMetalLayer.colorspace](https://developer.apple.com/documentation/quartzcore/cametallayer/colorspace).

Screenshots, Simulatorbilder, Startseiten-Einträge „All Pass“ (Mock-Daten) und UI-Häkchen
in „Bereit“ gelten nicht als Geräte- oder Messnachweise.

## 4. Vorbereitung am später freigegebenen Gerät

Eine Kopie des [Ergebnisprotokolls](SESSION3_IPHONE_ERGEBNISPROTOKOLL.md) pro Geräte-/Build-Kombination führen.
Checkboxen bedeuten „Arbeitsschritt erledigt“, nicht automatisch „bestanden“.

- [ ] **P01 — Stand festlegen:** Umbau abgeschlossen bzw. Zielstand ausdrücklich benannt,
      Plan abgeglichen, Ausführungsumfang freigegeben, installierten Build/Commit dokumentiert.
      Wenn Herkunft unklar: Prüfung blockiert, nicht anhand der Versionsanzeige raten.
- [ ] **P02 — Ausgangswerte sichern:** Helligkeitsregler fotografieren/notieren, Auto-Lock-Zeit,
      True Tone, Night Shift samt Zeitplan, Auto-Helligkeit, Weisspunkt reduzieren,
      Farbfilter/Umkehren, Stromsparmodus, Always-On und Orientierungssperre protokollieren.
      Nur vorhandene Optionen erfassen; Menübezeichnungen am konkreten iOS prüfen.
- [ ] **P03 — Reproduzierbare Bedingungen:** True Tone/Night Shift (auch Zeitplan),
      Auto-Helligkeit und farbverändernde Bedienungshilfen für den kontrollierten Lauf ausschalten;
      Stromsparmodus und Always-On für den Sperrvergleich ausschalten. Auto-Lock auf **30 s**,
      Helligkeit vor jedem Eintritt z.B. auf **30 %** setzen. Diese Werte sind Prüfbedingungen,
      keine Produkteinstellungen. Kann eine benötigte Option nicht geändert werden: protokollieren.
- [ ] **P04 — Aufbau:** Ruhiger Raum, konstantes Umgebungslicht, sauberes Display,
      fester Blick-/Messwinkel und Abstand. Akku-/Ladezustand und Gerätetemperatur notieren.
      Bei sichtbarer thermischer Abdunklung Lauf abbrechen, Ursache notieren und nach Abkühlung
      separat wiederholen; nicht durch längeres Erhitzen provozieren.
- [ ] **P05 — Zeitnachweis:** Externe Stoppuhr oder Aufnahme mit bekannter Bildrate/Zeitbasis
      bereitstellen; nicht auf dem PrüfiPhone zwischen Timer und App wechseln.
      Bildschirmaufnahme/Screenshots ersetzen keine optische Messung.
- [ ] **P06 — Weg zur Sequenz:** Startseite → Zahnrad → „Rec.709 Legal (16–235)“ → „Fertig“.
      „Neue Test-Session“ → Hersteller → Kameramodell → Weiter → Details → „Weiter →“ →
      „Quick-Check On-Set“ oder „DIT-Referenzsequenz“ → „Starten“ → „Bereit“ →
      „Sequenz starten“. Für reine Ablaufprüfung Profil und Testdaten notieren;
      damit wird keine externe Kamera geprüft. Werkstatt/Custom bleiben deaktiviert.

Apple beschreibt die Eingriffe von True Tone, Night Shift und Auto-Helligkeit sowie deren
Bedienwege unter [Helligkeit/Farbtemperatur](https://support.apple.com/en-us/109351);
thermische Abdunklung unter [Temperaturmanagement](https://support.apple.com/en-us/118431).
100 % Reglerstellung garantiert weder eine feste Leuchtdichte noch maximale HDR-Leuchtdichte.

## 5. Ausführbare Checkliste

### A. Armed / Pre-Roll und regulärer Ablauf

- [ ] **A01 — Armed:** Quick-Check öffnen und **20 s nicht berühren**. Grau mit
      „Tap to Start“ bleibt sichtbar, kein automatischer Wechsel; Display bleibt an.
      Diese Wartezeit gehört nicht zu den 41 s. Die Ready-Häkchen allein genügen nicht.
- [ ] **A02 — Trigger:** Einmal tippen, diesen Moment als **t = 0** markieren.
      Overlay verschwindet; Grau bleibt jetzt weitere 5 s. Kein weiterer Tap während
      des regulären Laufs: er würde abbrechen.
- [ ] **Q01 — Quick-Check:** Alle sieben Schritte gegen die folgende Tabelle beobachten,
      tatsächliche Wechselzeiten und Rückkehr zu „Bereit“ eintragen. Reihenfolge vollständig,
      kein hängen gebliebenes Bild, kein „Tap to Start“ während des Laufs.
- [ ] **D01 — DIT:** Von „Bereit“ per Zurück zu „Modus“, DIT wählen → „Starten“ →
      „Sequenz starten“. Wieder 20 s Armed prüfen; einmal tippen und 13 Schritte
      sowie Rückkehr gegen die Tabelle erfassen. Vorbereitungszeit nicht mitmessen.
- [ ] **A03 — Abbruch:** Separaten Quick-Check starten; z.B. bei t ≈ 7 s auf Weiss
      einmal tippen. Vollbild muss schliessen; abgebrochener Lauf zählt nicht als 41-s-Ergebnis.
      Danach neu öffnen: wieder Grau/Armed, erster Tap beginnt bei Schritt 1.
- [ ] **S01 — Sequenzwechsel:** Quick-Check → DIT → Quick-Check jeweils über „Modus“
      auswählen und durchführen. Jedes Mal bei Schritt 1 starten, richtige 7/13/7-Schrittfolge,
      keine alten Timer oder Bilder nach Rückkehr. Modus ausdrücklich wählen:
      „Neue Test-Session“ setzt `selectedMode` im Ausgangscode nicht zurück.

Die Intervalle unten sind **[Start, Ende)** ab Trigger: z.B. [17,29) beginnt bei t = 17 s,
nicht bei t = 18 s. Sie sind aus den JSON-Haltezeiten aufsummiert; ältere
Clip-Zeitfenster in `CLAUDE.md` sind dafür keine präzise Stoppuhrvorlage.
`estimatedMinutes` und die 10-s-Defaults der Definitionen ersetzen die Schritt-Overrides nicht.

| Quick-Schritt | Inhalt | Dauer | Nominal ab Trigger |
|---|---|---|---|
| 1 | Grau | 5 s | [0,5) s |
| 2 | Weiss | 8 s | [5,13) s |
| 3 | Schwarz | 8 s | [13,21) s |
| 4 | Rot | 5 s | [21,26) s |
| 5 | Grün | 5 s | [26,31) s |
| 6 | Blau | 5 s | [31,36) s |
| 7 | Grau | 5 s | [36,41) s |
| Ende | Rückkehr zu „Bereit“ | — | nominal t = 41 s |

| DIT-Schritt | Inhalt | Dauer | Nominal ab Trigger |
|---|---|---|---|
| 1 | Grau Lead-In | 17 s | [0,17) s |
| 2 | Rot | 12 s | [17,29) s |
| 3 | Grün | 8 s | [29,37) s |
| 4 | Blau | 12 s | [37,49) s |
| 5 | Rot | 5 s | [49,54) s |
| 6 | Weiss | 5 s | [54,59) s |
| 7 | Grün | 5 s | [59,64) s |
| 8 | Schwarz | 5 s | [64,69) s |
| 9 | Blau | 5 s | [69,74) s |
| 10 | Weiss | 5 s | [74,79) s |
| 11 | Grau | 4 s | [79,83) s |
| 12 | Schwarz | 6 s | [83,89) s |
| 13 | Grau Lead-Out | 10 s | [89,99) s |
| Ende | Rückkehr zu „Bereit“ | — | nominal t = 99 s |

**Timing beurteilen:** Trigger, erkennbare Wechsel und Rückkehr mit Messunsicherheit erfassen;
bei Crossfade Beginn und Ende statt eines erfundenen harten Frames notieren. Abweichungen
über 1 s dienen hier nur als manuelle Auffälligkeitsschwelle für einen Befund, nicht als
freigegebene Produkttoleranz. Rohwerte und Gesamtdrift immer festhalten. Bis zur vereinbarten
Timing-Toleranz lautet die Bewertung „beobachtet“, nicht „framegenau bestanden“.
Reihenfolge und Vollständigkeit können unabhängig davon beurteilt werden.

### B. Rec.709 Legal, Schwarz/Weiss und Alternativen

| Vollfläche | JSON-RGB, normiert (Alpha 1) | Ungefähre 8-bit-Entsprechung |
|---|---|---|
| Grau „50 %“ | 0,4941 / 0,4941 / 0,4941 | 126 / 126 / 126 |
| Weiss | 0,9216 / 0,9216 / 0,9216 | 235 / 235 / 235 |
| Schwarz | 0,0627 / 0,0627 / 0,0627 | 16 / 16 / 16 |
| Rot | 0,9098 / 0,0627 / 0,0627 | 232 / 16 / 16 |
| Grün | 0,0627 / 0,9098 / 0,0627 | 16 / 232 / 16 |
| Blau | 0,0627 / 0,0627 / 0,9098 | 16 / 16 / 232 |

Dies sind gerundete JSON-Eingabewerte, keine gemessenen Display-Codewerte.
„50 %“ ist der Testname, keine Zusicherung von 50 % physischer Leuchtdichte.

- [ ] **F01 — Legal visuell:** Im regulären Quick-Check jede stabile Vollfläche betrachten.
      Grau/Weiss auf Farbstich, Schwarz auf Aufhellung/fehlende Fläche, R/G/B auf Verwechslung
      und Übergänge auf Fremdframes/Overlays prüfen. Eindrücke mit Zeitpunkt notieren;
      „unauffällig“ bestätigt nur diesen visuellen Umfang.
- [ ] **F02 — Full-Vergleich:** Nach Rückkehr bis Home zurückgehen, Zahnrad → „Rec.709 Full Range“.
      Quick-Check unter denselben Bedingungen wiederholen. Auswahlmarkierung, Reihenfolge und
      beobachtete Unterschiede erfassen. Keine 0/255-Endpunkte erwarten; keine Differenz ist
      mit dem Quellstand vereinbar. Full-Range-Funktion bleibt als eigener offener Punkt bestehen.
- [ ] **F03 — P3-Vergleich:** Gleiches Vorgehen mit „Display P3“. Sechs stabile Flächen erfassen,
      Auswahlwechsel und neue Darstellung prüfen. Farbveränderungen sachlich protokollieren;
      R/G/B-Zahlen unter anderer Farbraumzuordnung sind kein identischer Farbzielwert.
- [ ] **F04 — Rückkehr Legal:** Wieder Legal wählen und Quick-Check wiederholen; keine alte
      P3-Darstellung oder falsche Auswahlmarkierung. Einstellungen erneut öffnen und Auswahl
      kontrollieren. Nach kaltem App-Neustart ist Legal als Default zu erwarten;
      Persistenz einer vorherigen Wahl ist derzeit nicht implementiert.
- [ ] **M01 — Nur bei geeigneter Messtechnik und freigegebenem Messumfang:** Modell, Software,
      Kalibrierung/Displaykorrektur, Messgeometrie, Messunsicherheit und vorab vereinbarte
      Zielwerte dokumentieren. Je Setting im laufenden DIT-Durchgang stabile Grau/W/K/R/G/B-
      Abschnitte messen und `x/y/Y` mit Zeitpunkt protokollieren; Wiederholungsmessung in
      einem zweiten identischen Durchgang. Nicht in Overlay oder Crossfade messen.
      Messintegration muss in die stabile Haltezeit passen; sonst Messung als blockiert
      kennzeichnen. Es gibt aktuell keine UI zum Pausieren oder freien Halten einer Farbe.
- [ ] **M02 — Clipping-/Schwarz-/Weiss-Nachweis einordnen:** Leuchtdichte der vorhandenen
      Schwarz- und Weissflächen kann gemessen werden. Ein belastbarer Nachweis zur
      Unterscheidung benachbarter Grenzstufen ist mit diesen sechs Flächen **blockiert**:
      passende Referenzstufen fehlen. Benötigt würden im selben, gesondert freigegebenen
      Renderpfad kontrollierte 0/255- und nahe 16/235 liegende Stufen sowie vereinbarte Ziele.
      Hier keine JSON-/Codeänderung oder Entwicklung dafür vornehmen. Ein Muster aus einer
      anderen App darf nur deren eigenen Ausgabepfad charakterisieren.

Ohne Messgerät: M01 als „blockiert — Messtechnik fehlt/ungeklärt“, nicht bestanden oder
stillschweigend erledigt markieren. Auch mit Messgerät bleiben M02 und die Farbabnahme offen,
solange Vergleichsstufen bzw. Ziele/Toleranzen fehlen. Bei Kamera-Waveform zusätzlich
Kamera, ISO, Shutter, Blende, Weissabgleich, Log/Rec.709, LUT, Signalrange und Aufnahmeformat
festhalten. Überbelichtung zunächst als Befund der gesamten Aufnahmekette behandeln.

### C. Helligkeit, Auto-Lock und Wiederherstellung

- [ ] **G01 — Reguläres Ende:** Vor Eintritt 30-%-Reglerstellung dokumentieren.
      Armed/Vollbild setzt den Regler auf Maximum; dies separat am Regler prüfen.
      Das Öffnen des Kontrollzentrums ist eine Unterbrechung: dafür eigenen Lauf verwenden,
      nicht den Farbmess-/Timing-Lauf. Beim unberührten DIT-Lauf muss das Display länger
      als die eingestellten 30 s anbleiben. Nach natürlichem Ende den vorherigen
      Helligkeitsregler vergleichen, dann ausserhalb des Vollbilds ohne Eingabe beobachten,
      ob Auto-Lock wieder greift. Sperrzeit notieren; bei Always-On nicht nur „schwarz“ bewerten.
- [ ] **G02 — Tap-Abbruch und Wiederholung:** G01 für Tap-Abbruch wiederholen, dann mit
      anderer Ausgangshelligkeit (z.B. 60 %) erneut. Rückkehr muss jeweils den unmittelbar
      vorherigen Wert herstellen. Nach jedem Ende/Abbruch Auto-Lock erneut beobachten.
      Kontrollzentrum schliessen, dann die Wartezeit neu beginnen.
- [ ] **G03 — Längeres Armed:** Separaten Lauf 45 s Armed stehen lassen. Kein Sequenzwechsel,
      keine automatische Sperre; anschliessend erst starten und per zweitem Tap abbrechen,
      Helligkeits-/Sperrverhalten nach Rückkehr dokumentieren.
      Es gibt keinen besonderen Armed-Abbruchknopf im Ausgangsstand.

Reglervergleich belegt keine exakte Leuchtdichte. Der Code stellt die gespeicherte Helligkeit
und `isIdleTimerDisabled = false` her; er speichert keinen früheren Idle-Timer-Bool-Wert.
Die systemweite Auto-Lock-Zeit wird nicht von der App geändert.

### D. Unterbrechungen und Orientierung

Jeden Fall als separaten Lauf prüfen, jeweils einmal in **Armed** und einmal in **Running**
(z.B. Quick-Check bei t ≈ 7 s). Zeit, Bild und Zustand vor/bei/nach der Unterbrechung erfassen.
Nach Rückkehr Phase/Bild/Overlay, unerwarteten Fortschritt, Helligkeit und Auto-Lock prüfen;
anschliessend geordnet beenden und frischen Quick-Check ab Schritt 1 versuchen.

| ID | Konkreter Eingriff | Zusätzlich festhalten |
|---|---|---|
| U01 | Kontrollzentrum öffnen, ca. 5 s warten, schliessen | Überlagerung, Reglerwert, Weiterlauf/Rückkehr |
| U02 | Zum Home-Bildschirm, 10 s warten, App wieder öffnen | Sprung im Ablauf, schwarzes/stales Bild, wiederholtes Armed |
| U03 | Seitentaste sperren, 10 s warten, entsperren | Wiederanlauf und tatsächliche Sperre; Idle-Timer verhindert keine manuelle Sperre |
| U04 | Systemunterbrechung z.B. eingehender Anruf, falls separat organisierbar | Art/Dauer, Vorher-/Nachherzustand; ohne Möglichkeit „blockiert“, keine echte Notrufhandlung |
| U05 | App über App-Umschalter ausdrücklich beenden und neu öffnen | Helligkeit ausserhalb der App zuerst prüfen; Kaltstart muss wieder bedienbar sein. Keine persistente laufende Session erwarten |
| O01 | Portrait → Landscape → Portrait, ohne Display zu berühren | Vollflächenabdeckung, Aussparungen/Systemleisten, Neuzeichnen, Timing; System-Orientierungssperre für diesen Fall aus, danach zurückstellen |

Eine automatische Pause/Fortsetzung bei Unterbrechungen ist im Ausgangscode nicht spezifiziert.
Daher Ist-Verhalten erfassen und DIT-Entscheidung offenhalten; nicht „Pause funktioniert“ behaupten.
Nach Hintergrundwechsel oder erzwungenem Beenden ist `onDisappear` als Wiederherstellungsnachweis
nicht ausreichend. Bleiben Helligkeit oder Sperrverhalten verändert, Befund samt Repro erfassen,
manuell auf dokumentierte Ausgangswerte zurückstellen und den betroffenen Lauf als unterbrochen
kennzeichnen. U05 ist kein regulärer Abschluss und ersetzt G01/G02 nicht.

## 6. Bekannte offene Punkte und Abschlussgrenze

| ID | Offener Gegenstand | Umgang in dieser Abnahmevorbereitung |
|---|---|---|
| K01 | Geräte-Farbabnahme fehlt; Ziel-Leuchtdichte/Transferfunktion/Toleranzen und Messtechnik offen | Keine farbmetrische Freigabe aus visueller Unauffälligkeit |
| K02 | Legal/Full identische Farbraumzuordnung ohne Range-Umskalierung | Auswahl prüfen; tatsächliche Full-Range-Funktion nicht als geliefert abnehmen |
| K03 | Nur sechs Vollflächen; keine Grenzstufen oder frei bedienbaren Shader-Muster | Clippingfreiheit und vollständiger Shader-Katalog bleiben offen |
| K04 | Unterbrechungsverhalten und Wiederherstellung nicht über alle Pfade abgesichert | U01–U05 liefern Befunde, keine aus dem Code erfundene Zusicherung |
| K05 | Orientation Lock und Launch Screen laut Notizen offen | O01 dokumentiert Ist; keine automatische Korrektur. Launch Screen nicht durch diese Liste abgenommen |
| K06 | Voice/Watch Stubs; Pause/Resume/Vor/Zurück ohne UI, Werkstatt/Custom deaktiviert | Nicht als bedienbare Prüfschritte vorgeben; keine neue Entwicklungssession |
| K07 | Historie ist Mock, keine Speicherung/PDF-Ergebnisse | Ergebnisprotokoll extern führen; App-Häkchen/„All Pass“ nicht übernehmen |
| K08 | Original-DIT-Clip nicht im Repo; 10-bit-Referenz versus 8-bit-Renderziel | Ohne Original keine neue 1:1-Clip-Verifikation behaupten |
| K09 | App-Umbau läuft laut Nutzerhinweis; Zielstand dieser Abnahme noch offen | Vor Ausführung Plan mit Zielcommit abgleichen; alte Ergebnisse nicht pauschal übertragen |

- [ ] **Z01 — Abschluss:** Alle für den Lauf veränderten iOS-Einstellungen aus P02
      wiederherstellen, auch Helligkeit und Auto-Lock. Offene Abweichungen dokumentieren.
- [ ] **Z02 — Bewertung:** Pro Prüfpunkt tatsächlichen Status, Umfang, Messmethode und Beleg
      eintragen. Befunde mit Repro und zuständiger Person führen. Nicht ausgeführte oder
      unterbrochene Prüfungen bleiben sichtbar. Abnahmeentscheidung mit Datum/Name gesondert.
- [ ] **Z03 — Übergabe:** Funktions-/Ablaufprüfung, Timing, Farbmessung, visuelle Abnahme,
      Integration und Veröffentlichung getrennt ausweisen. Plan-PR ist keine Geräteabnahme.
      Merge dieses Dokumentations-PR erst nach ausdrücklicher Freigabe.

## 7. Quellen und Nachweisgrenze

Repository-Lesestand: ausschliesslich der oben fixierte Commit. Relative Links zeigen bei
späterer Nutzung den jeweiligen Checkout; für den ursprünglichen Beleg denselben Pfad unter
dem [fixierten Quellbaum](https://github.com/Hhhhhhhhhhhh12/inspector-moire/tree/5ece89434db008b9dac6cadae8a3928665cf0082) verwenden.

- [IMPLEMENTATION_NOTES.md](../IMPLEMENTATION_NOTES.md): dokumentierter Abschluss von Session 3 und offene Geräteprüfungen.
- [CLAUDE.md](../CLAUDE.md), [iOS-README](../ios-app/README.md):
  Implementierungsstand, Plattform und Grenzen.
- [Historischer Session-3-Auftrag](../prompts/03-metal-rec709-dit.md): Soll-/Clipkontext,
  kein neuer Ausführungsauftrag und kein Messnachweis.
- [Quick-Check JSON](../ios-app/Inspektor/Resources/Sequences/quick_check.json),
  [DIT JSON](../ios-app/Inspektor/Resources/Sequences/dit_reference.json):
  Reihenfolgen und nominelle Haltezeiten.
- Weitere konkrete Code-/Ressourcenquellen sind in Abschnitt 2 verlinkt;
  [HomeView](../ios-app/Inspektor/Features/Home/HomeView.swift),
  [PreTestReminderView](../ios-app/Inspektor/Features/TestRunner/PreTestReminderView.swift),
  [Modusmodell](../ios-app/Inspektor/Core/TestEngine/TestSequence.swift) und
  [TestEngine](../ios-app/Inspektor/Core/TestEngine/TestEngine.swift) belegen die beschriebenen Bediengrenzen.
- Externe Primärquellen für die Methodik sind bei den jeweiligen Aussagen verlinkt;
  Stand des Quellenabrufs 02.11.2026.

**Für die Erstellung wurde ausschliesslich der Quellen-/Dokumentationsdiff geprüft.
Kein Build, Testlauf, Simulator, iPhone-Lauf oder Messgerät wurde dafür ausgeführt.**
