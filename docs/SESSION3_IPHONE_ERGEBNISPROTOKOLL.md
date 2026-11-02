# Session 3 — iPhone-Geräteabnahme: Ergebnisprotokoll

**Unbenutzte Vorlage · 02.11.2026 · keine Geräteprüfung durchgeführt.**
Zum [Prüfplan](SESSION3_IPHONE_PRUEFPLAN.md). Pro Geräte-/OS-/Build-Kombination eine Kopie führen.
Erst nach Abgleich mit dem Stand nach dem UI-Umbau und gesonderter Ausführungsfreigabe verwenden.
Vorbelegte Quellenbefunde und Nutzerangaben sind keine Testergebnisse.

## 1. Freigabe und geprüfter Stand

| Feld | Eintrag |
|---|---|
| Protokoll-ID / Prüfdatum / prüfende Person | offen |
| Freigegebener Umfang / Auftrag / Datum | offen — aktuell nur Dokumentationsvorbereitung beauftragt |
| Stand nach UI-Umbau / Planabgleich durch / Datum | offen |
| Plan-Version / Commit der verwendeten Checkliste | offen |
| Tatsächlich geprüfter App-Commit / Branch | offen |
| Installierter App-Build / Installationsweg / Zuordnungsbeleg | offen |
| Ausgangspunkt der Dokumentationsrecherche | main: `5ece89434db008b9dac6cadae8a3928665cf0082`; noch kein Geräte-Prüfstand |
| Gerät | iPhone 17 laut Nutzerangabe vom 02.11.2026; am Gerät noch nicht bestätigt |
| Genaue Modellkennung / Display original oder ersetzt / Schutzglas | offen |
| iOS-Version | iOS 27 laut Nutzerangabe vom 02.11.2026; genaue Version und Build offen |
| Kamera-Profil / Testdaten in der App | offen |
| Externe Kamera, falls tatsächlich verwendet | offen; nicht mit dem ausgewählten App-Profil gleichsetzen |
| DIT-Referenzclip / Herkunft / Prüfsumme / Vergleichsaufbau | offen — Clip nicht im Repository vorhanden |
| Raumlicht / Temperatur / Blickwinkel / Abstand / Halterung | offen |
| Akkustand / Stromsparmodus / Ladezustand vor und nach Lauf | offen |
| Zeitnachweis: Stoppuhr/Video, Bildrate und Messunsicherheit | offen |

## 2. Einstellungen sichern und zurückstellen

Ausgangs- und Prüfwerte vor dem ersten Lauf erfassen. „Wiederhergestellt“ erst nach
tatsächlicher Kontrolle eintragen. Unterbrechungen bei Kontrollzentrum-/Einstellungsaufrufen
im Laufprotokoll markieren.

| Einstellung | Ursprünglich | Kontrollierter Prüfwert | Nach Abschluss / Beleg |
|---|---|---|---|
| Helligkeitsregler | offen | z.B. 30 %, Wiederholung 60 %; im Vollbild Maximum erwartet | nicht geprüft |
| Auto-Lock-Zeit | offen | 30 s, sofern einstellbar | nicht geprüft |
| True Tone | offen | aus | nicht geprüft |
| Night Shift einschliesslich Zeitplan | offen | aus | nicht geprüft |
| Auto-Helligkeit | offen | aus | nicht geprüft |
| Weisspunkt reduzieren / Farbfilter / Farbumkehr | offen | aus, sofern vorhanden | nicht geprüft |
| Stromsparmodus | offen | aus | nicht geprüft |
| Always-On | offen | aus, sofern vorhanden | nicht geprüft |
| Orientierungssperre | offen | O01: aus; sonst Prüfbedingung notieren | nicht geprüft |
| Sonstige wirksame Display-/Bedienungshilfen | offen | offen | nicht geprüft |

## 3. Laufregister und Checkliste

Statuswerte: **nicht durchgeführt**, **beobachtet** (noch keine Abnahme),
**bestanden** (nur benanntes Kriterium), **abweichend**, **blockiert**, **unterbrochen**.
Für „bestanden“ sind reale Ausführung, Datum, Ist-Wert und Beleg erforderlich.
Quellenprüfung oder Screenshot allein dürfen den Status nicht auf bestanden setzen.

Jeden Lauf mit eindeutiger Lauf-ID und Setting Legal/Full/P3 verbinden; U01–U05 und O01
jeweils für Armed und Running separat erfassen. Ein unterbrochener Lauf gilt nicht als
vollständiger 41-/99-s-Lauf. Keine Sammelfreigabe aus einem einzigen Durchgang ableiten.

| Lauf-ID | Prüfpunkt | Farbraum / Sequenz / Ausgangsphase | Datum / Beleg | Ist-Beobachtung | Status |
|---|---|---|---|---|---|
| — | P01–P06 Vorbereitung / ausführbaren Zielstand klären | — | — | — | nicht durchgeführt |
| — | A01 Armed 20 s | Legal / Quick / Armed | — | — | nicht durchgeführt |
| — | A02 Trigger und voller erster Hold | Legal / Quick / Armed → Running | — | — | nicht durchgeführt |
| — | Q01 Quick-Check 7 Schritte / 41 s | Legal / Quick | — | — | nicht durchgeführt |
| — | D01 DIT 13 Schritte / 99 s + Armed | Legal / DIT | — | — | nicht durchgeführt |
| — | A03 Tap-Abbruch und Neustart | Legal / Quick / Running | — | — | nicht durchgeführt |
| — | S01 Quick → DIT → Quick | Legal / 7–13–7 Schritte | — | — | nicht durchgeführt |
| — | F01 sechs Vollflächen visuell | Legal / Quick | — | — | nicht durchgeführt |
| — | F02 Full-Vergleich | Full / Quick | — | — | nicht durchgeführt |
| — | F03 P3-Vergleich | P3 / Quick | — | — | nicht durchgeführt |
| — | F04 zurück zu Legal / Kaltstart-Default | Legal / Quick | — | — | nicht durchgeführt |
| — | M01 physische Farbmessung / Wiederholung | Setting und DIT-Lauf je Messung | — | — | nicht durchgeführt |
| — | M02 Grenzstufen / Clipping-Nachweis | im Ausgangsstand fehlen Vergleichsstufen | — | Quellenbegrenzung, kein Gerätebefund | nicht durchgeführt |
| — | G01 Helligkeit / Auto-Lock / natürliches Ende | Legal / DIT | — | — | nicht durchgeführt |
| — | G02 Tap-Abbruch / andere Ausgangshelligkeit | Legal / Quick | — | — | nicht durchgeführt |
| — | G03 Armed 45 s / Rückkehr | Legal / Quick / Armed | — | — | nicht durchgeführt |
| — | U01 Kontrollzentrum, je Armed/Running | je eigener Lauf | — | — | nicht durchgeführt |
| — | U02 Home, je Armed/Running | je eigener Lauf | — | — | nicht durchgeführt |
| — | U03 manuelle Sperre, je Armed/Running | je eigener Lauf | — | — | nicht durchgeführt |
| — | U04 Systemunterbrechung, je Armed/Running | je eigener Lauf | — | — | nicht durchgeführt |
| — | U05 erzwungenes Ende, je Armed/Running | je eigener Lauf | — | — | nicht durchgeführt |
| — | O01 Rotation, je Armed/Running | je eigener Lauf | — | — | nicht durchgeführt |
| — | Z01 Ausgangseinstellungen wiederherstellen | alle geänderten iOS-Optionen | — | — | nicht durchgeführt |
| — | Z02 Bewertung / Z03 Übergabe | — | — | — | nicht durchgeführt |

### Zeitprotokoll — je regulärem Lauf kopieren

Lauf-ID / Sequenz / Farbraum: offen. Trigger-Zeitbasis und Unsicherheit: offen.
Bei Crossfade Wechselbeginn und stabile Zielfläche getrennt eintragen.
Nominalwerte stammen nur aus JSON. Vorbereitungs-/Armed-Zeit gehört nicht zur Sequenzdauer.

| Schritt | Quick: Farbe / nomineller Beginn | DIT: Farbe / nomineller Beginn | Ist: Wechselbeginn / stabil ab | Abweichung / Beleg |
|---|---|---|---|---|
| 1 | Grau / 0 s | Grau / 0 s | — | — |
| 2 | Weiss / 5 s | Rot / 17 s | — | — |
| 3 | Schwarz / 13 s | Grün / 29 s | — | — |
| 4 | Rot / 21 s | Blau / 37 s | — | — |
| 5 | Grün / 26 s | Rot / 49 s | — | — |
| 6 | Blau / 31 s | Weiss / 54 s | — | — |
| 7 | Grau / 36 s | Grün / 59 s | — | — |
| 8 | — | Schwarz / 64 s | — | — |
| 9 | — | Blau / 69 s | — | — |
| 10 | — | Weiss / 74 s | — | — |
| 11 | — | Grau / 79 s | — | — |
| 12 | — | Schwarz / 83 s | — | — |
| 13 | — | Grau / 89 s | — | — |
| Rückkehr | 41 s | 99 s | — | — |

Armed-Wartezeit tatsächlich: offen. Gesamtdauer / Drift: offen.
Vereinbarte Timing-Toleranz und Entscheider: offen. Reihenfolge vollständig: nicht geprüft.
Manuelle Auffälligkeitsschwelle des Plans (> 1 s) ist keine freigegebene Produkttoleranz.

### Unterbrechungs-/Wiederherstellungsprotokoll — je Fall kopieren

| Feld | Eintrag |
|---|---|
| Lauf-ID / U- oder O-ID / Armed oder Running / Setting | offen |
| Zeitpunkt, angezeigte Farbe und Overlay vor Eingriff | offen |
| Eingriff / Dauer / Zeitnachweis | offen |
| App-Zustand und Bild nach Rückkehr / unerwarteter Fortschritt | offen |
| Helligkeitsregler vorher / im Vollbild / ausserhalb danach | offen |
| Auto-Lock-Prüfung danach: Wartezeit / tatsächliche Sperre | offen |
| Frischer Quick-Check startet wieder bei Grau/Armed | nicht geprüft |
| Manuelle Wiederherstellung erforderlich / durchgeführt | offen |
| Befund-ID / Beleg / Bewertung durch | offen |

## 4. Farbmessung — nur ausfüllen, wenn tatsächlich durchgeführt

**Messtechnik derzeit offen/zurückgestellt.** Keine reine visuelle Prüfung als Messung eintragen.
Bei fehlender Ausrüstung M01 als blockiert kennzeichnen. M02 bleibt ohne passende Stufen blockiert.

| Voraussetzung | Eintrag |
|---|---|
| Messgerät / Modell / Software / Version | offen |
| Kalibrierung, Datum und OLED-/Displaykorrektur / Eignung | offen |
| Messposition / Winkel / Abstand / Apertur / Integrationszeit | offen |
| Messunsicherheit / Wiederholbarkeit / Dunkelabgleich | offen |
| Vereinbarte Ziele: Weisspunkt, Leuchtdichte, Transferfunktion, Farbabweichung / Toleranzen / DIT-Freigabe | offen |
| Ausreichend stabile Haltezeit ohne Overlay/Crossfade | nicht geprüft |
| Bei Kamera: Modell, ISO, Shutter, Blende, WB, LUT, Log/Rec.709, Range und Aufnahmeformat | offen |

Je Setting und Durchgang sechs Zeilen führen. Das Setting bezeichnet die Auswahl in der App;
die Zahlen aus JSON sind keine gemessenen Lichtwerte. Gleiche RGB-Zahlen in P3 definieren
nicht denselben Farbreiz wie in Rec.709.

| Lauf-ID / Setting / Durchgang | Fläche / Schritt / Zeitpunkt | x | y | Y (cd/m²) | Ziel / Abweichung / Unsicherheit | Rohdaten-Beleg / Status |
|---|---|---|---|---|---|---|
| — | Grau | — | — | — | — | nicht durchgeführt |
| — | Weiss | — | — | — | — | nicht durchgeführt |
| — | Schwarz | — | — | — | — | nicht durchgeführt |
| — | Rot | — | — | — | — | nicht durchgeführt |
| — | Grün | — | — | — | — | nicht durchgeführt |
| — | Blau | — | — | — | — | nicht durchgeführt |

Clippingbewertung: **kein Nachweis** — aktuelle App bietet keine benachbarten Grenzstufen.
Auch eine gemessene einzelne Weiss-/Schwarzfläche reicht dafür nicht.
Original-DIT-Clip tatsächlich verglichen / Methode / Ergebnis: nicht durchgeführt.

## 5. Befunde, Entscheidung und Übergabe

Für jede Abweichung: Befund-ID, Prüfpunkt/Lauf, Gerät/OS/Commit, erwartetes Kriterium,
beobachtetes Verhalten, genaue Reproschritte, Beleg, Auswirkung und zuständige Person erfassen.
Codeableitung, Nutzerbeobachtung und Messung als Belegarten unterscheiden.

| Befund-ID | Prüfpunkt / Lauf | Soll / Ist / Repro / Beleg | Auswirkung / zuständig / Status |
|---|---|---|---|
| — | — | Noch keine realen Gerätebefunde erhoben | offen |

Bekannte Quellenbegrenzungen K01–K09 stehen im Prüfplan. Sie sind keine neu ausgeführten
Fehlertests; hier auf deren IDs verweisen und verbleibende Abnahmehindernisse benennen.

| Entscheidungsbereich | Ergebnis / genauer Umfang | Entscheider / Datum / Beleg |
|---|---|---|
| Funktion / Ablauf / Sequenzwechsel | nicht durchgeführt | offen |
| Timing gegen vereinbarte Toleranz | nicht durchgeführt; Toleranz offen | offen |
| Visuelle Darstellung | nicht durchgeführt | offen |
| Physische Farbabnahme Legal / Full / P3 | nicht durchgeführt | offen |
| Clipping-/Grenzstufennachweis | nicht erbracht; Vergleichsstufen fehlen | offen |
| Helligkeit / Auto-Lock / Wiederherstellung / Unterbrechungen | nicht durchgeführt | offen |
| Orientierung | nicht durchgeführt | offen |
| Gesamtabnahme / Restpunkte / zulässiger Einsatzumfang | keine Geräteabnahme erteilt | offen |
| Dokumentations-PR / Merge-Freigabe | gesondert; wartet auf ausdrückliche Freigabe | offen |
| Veröffentlichung / TestFlight | durch diesen Auftrag nicht freigegeben | offen |

Abschliessend geänderte iOS-Einstellungen kontrollieren. Belege und offene Punkte am
verwendeten Protokoll ablegen; Version/Datei hier eintragen: offen.
Ein späterer Code-/UI-Umbau erfordert die Prüfung, welche Ergebnisse für den neuen Stand
weiter gelten. Freigaben niemals allein aus dem dokumentierten Abschluss von Session 3 ableiten.
