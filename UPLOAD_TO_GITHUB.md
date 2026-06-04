# Upload zu GitHub — Schritt-für-Schritt

Diese Anleitung führt dich ohne Terminal und ohne Git-Vorkenntnisse durch das Anlegen des öffentlichen Repos und den Upload des Inspektor-Ordners. Du brauchst nur einen Browser und einen GitHub-Account.

**Dauer:** ca. 5 Minuten.

---

## 1. GitHub-Account vorbereiten

Falls du noch keinen Account hast, öffne https://github.com/signup und erstelle einen kostenlosen Account. Notiere dir deinen **Username** — den brauchst du gleich.

Wichtig: **Niemals dein Passwort irgendwem schicken oder hier teilen.** Du loggst dich nur selbst im Browser ein.

---

## 2. Neues Repository anlegen

1. Öffne https://github.com im Browser und logge dich ein.
2. Klicke oben rechts auf das **+** Icon → **„New repository"**.
3. Fülle das Formular aus:

   - **Repository name:** `Inspektor`
   - **Description** (optional): `iPhone-App zur sprachgesteuerten Vorbereitung von Kameratests`
   - **Visibility:** ⚪ Public auswählen (so wie besprochen)
   - **Initialize this repository with:** Alle drei Häkchen leer lassen (kein README, kein .gitignore, keine License — die haben wir schon lokal)

4. Klicke unten auf **„Create repository"**.

Du landest auf einer leeren Repo-Seite mit Anleitungen. Die meisten ignorierst du — wir nutzen die einfachste Variante.

---

## 3. Dateien hochladen

Auf der frisch erstellten Repo-Seite siehst du oben einen Link **„uploading an existing file"** (oder klicke „Add file" → „Upload files"). Klicke ihn.

Du landest auf einer Upload-Seite mit einem großen gestrichelten Rahmen.

### So gehst du vor:

1. Öffne in einem zweiten Browser-Tab oder Finder/Explorer deinen lokalen Ordner `Inspektor`.
2. Wähle **alle Dateien und Unterordner** innerhalb von `Inspektor` aus (nicht den `Inspektor`-Ordner selbst).
   - Auf Mac: ⌘+A im Finder
   - Auf Windows: Strg+A im Explorer
3. Ziehe sie per Drag-&-Drop in den gestrichelten Rahmen auf der GitHub-Seite.
4. GitHub lädt sie hoch (Fortschrittsbalken erscheint). Das dauert je nach Verbindung 10-30 Sekunden.

### Wichtig: die versteckte `.gitignore`-Datei

Bei manchen Betriebssystemen sind versteckte Dateien (mit Punkt am Anfang, z. B. `.gitignore`) im Finder unsichtbar.

- **Auf Mac:** Drücke im Finder ⌘+Shift+. (Punkt) — versteckte Dateien werden sichtbar. Nochmal drücken blendet sie wieder aus.
- **Auf Windows:** Im Explorer → „Ansicht" → Häkchen bei „Ausgeblendete Elemente".

Stelle sicher, dass `.gitignore` mit hochgeladen wird, sonst landen später Build-Artefakte versehentlich im Repo.

---

## 4. Commit-Meldung schreiben

Unter dem Drag-&-Drop-Bereich gibt es zwei Eingabefelder:

- **Commit-Nachricht (oben):** z. B. `Initial commit – Konzept und Mockup`
- **Beschreibung (unten, optional):** kannst du leer lassen

Darunter:
- ⚪ **„Commit directly to the main branch"** ist die richtige Wahl.

Klicke **„Commit changes"**.

---

## 5. Fertig

Du landest jetzt auf der Repo-Übersicht und siehst alle deine Dateien und Ordner. Das `README.md` wird automatisch unten angezeigt.

**Die Repo-URL hat das Format:**

```
https://github.com/<dein-username>/Inspektor
```

Diese URL kannst du an deinen DIT, an potenzielle Entwickler oder an Pitch-Partner weitergeben.

---

## Bonus: Mockup direkt im Browser anzeigen

Damit dein UI-Mockup nicht nur als Quellcode im Repo liegt, sondern direkt im Browser läuft, kannst du **GitHub Pages** aktivieren:

1. Im Repo: **„Settings"** (oben rechts) → links **„Pages"**.
2. Bei **„Source"**: **„Deploy from a branch"** wählen.
3. Bei **„Branch"**: `main` → `/ (root)` → **„Save"**.
4. Nach 1-2 Minuten ist dein Mockup live unter:

```
https://<dein-username>.github.io/Inspektor/mockup/
```

Diese Live-URL ist perfekt für Pitches — Empfänger klicken einmal und sehen den interaktiven Mockup direkt im Browser, ohne etwas herunterladen zu müssen.

---

## Spätere Updates

Wenn du Dokumente aktualisierst (z. B. nach DIT-Feedback):

1. Im Repo zur Datei navigieren.
2. Auf das Stift-Symbol klicken (oben rechts).
3. Direkt im Browser bearbeiten **oder** die neue Version per Drag-&-Drop ersetzen (Datei löschen, dann neu hochladen).
4. „Commit changes" klicken.

Für komplexere Updates (mehrere Dateien gleichzeitig) lohnt sich später **GitHub Desktop** (https://desktop.github.com) — ein kostenloses Tool mit grafischer Oberfläche, das den Workflow stark vereinfacht. Aber für dieses Konzept-Stadium reicht der Browser-Upload völlig.

---

## Falls etwas schiefgeht

- **„File too large"-Fehler:** GitHub limitiert einzelne Dateien auf 100 MB. Unsere größte Datei ist unter 30 KB, also kein Problem.
- **Versehentlich was Falsches hochgeladen:** Im Repo zur Datei navigieren → Mülleimer-Symbol → „Commit changes". Weg.
- **Repo aus Versehen privat statt public erstellt:** Repo öffnen → „Settings" → ganz nach unten scrollen → „Change repository visibility" → „Make public".

---

**Viel Erfolg.** Wenn alles geklappt hat: Repo-URL mit mir teilen, dann können wir bei den nächsten Schritten (Pitch-Deck, DIT-Feedback einarbeiten) direkt darauf referenzieren.
