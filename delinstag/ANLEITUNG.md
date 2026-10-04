# Delinstag online stellen

Die App liegt in diesem Ordner (`delinstag/`). Sie besteht aus einer einzigen Webseite (`index.html`) plus Icons.
Die Daten liegen in eurem Supabase-Projekt `wdsxvrrilkpulldldyps`. Nur Linus und Delisa kommen rein.

Dauer: etwa 15 Minuten. Reihenfolge einhalten.

---

## 1. Datenbank einrichten (Supabase, 3 Minuten)

1. Öffne https://supabase.com/dashboard/project/wdsxvrrilkpulldldyps/sql/new
2. Kopiere den kompletten Inhalt von `schema.sql` hinein.
3. Ersetze die zwei Platzhalter durch eure echten Adressen:
   - `DEINE-EMAIL@example.com` → deine E-Mail
   - `DELISAS-EMAIL@example.com` → Delisas E-Mail
4. Klick auf **Run**. Unten muss „Success. No rows returned“ stehen.

## 2. Website online stellen (Netlify, 5 Minuten, kostenlos)

1. Geh auf https://app.netlify.com und melde dich mit **GitHub** an.
2. **Add new project → Import an existing project → GitHub** → Repo `veganer-ern-hrungsplan` auswählen.
3. Einstellungen:
   - **Branch to deploy:** `main` (oder der Branch, auf dem der Ordner `delinstag/` liegt)
   - **Base directory:** `delinstag`
   - **Build command:** leer lassen
   - **Publish directory:** `delinstag`
4. **Deploy** klicken. Nach einer Minute bekommst du eine Adresse wie `https://irgendwas-123.netlify.app`.
5. Optional schöner machen: **Site configuration → Change site name** → z. B. `delinstag` → Adresse wird `https://delinstag.netlify.app`.

Jede Änderung, die auf GitHub landet, geht danach automatisch online.

## 3. Supabase sagen, wo die Website liegt (2 Minuten)

Sonst führen die Bestätigungs-Mails ins Leere.

1. Öffne https://supabase.com/dashboard/project/wdsxvrrilkpulldldyps/auth/url-configuration
2. **Site URL:** deine Netlify-Adresse eintragen, z. B. `https://delinstag.netlify.app`
3. **Redirect URLs → Add URL:** dieselbe Adresse noch mal, mit `/**` am Ende, z. B. `https://delinstag.netlify.app/**`
4. Speichern.

Wichtig: Unter **Authentication → Sign In / Providers → Email** muss **„Confirm email“ eingeschaltet** bleiben (ist Standard).
Das verhindert, dass sich jemand mit eurer Adresse ein Konto anlegt.

## 4. Konten anlegen (je 1 Minute)

Jeder von euch, auf dem eigenen Handy:

1. Website öffnen → **„Erstes Mal? Konto erstellen“**
2. Eigene E-Mail (genau die aus Schritt 1) und ein Passwort (mind. 6 Zeichen) eingeben.
3. Bestätigungs-Mail öffnen und den Link anklicken. (Absender ist Supabase; ggf. im Spam schauen.)
4. Zurück auf der Website anmelden. Fertig, ihr bleibt eingeloggt.

## 5. Tür zumachen (optional, empfohlen)

Wenn ihr beide ein Konto habt:
**Authentication → Sign In / Providers → „Allow new users to sign up“ ausschalten.**
Dann kann niemand mehr ein neues Konto anlegen. (Auch ohne diesen Schritt sieht ein fremdes Konto nichts. Das regelt die Datenbank.)

## 6. Als App auf den Home-Bildschirm

- **iPhone (Safari):** Teilen-Symbol → **Zum Home-Bildschirm**
- **Android (Chrome):** Menü ⋮ → **App installieren** / **Zum Startbildschirm hinzufügen**

Dann habt ihr ein Delinstag-Icon (blau-grünes Herz) und die Seite öffnet sich wie eine App.

---

### Wenn etwas nicht klappt

| Meldung | Lösung |
|---|---|
| „Kein Zugang“ | Die E-Mail steht nicht (oder anders geschrieben) in `schema.sql`. Adresse korrigieren, Skript erneut ausführen. |
| „Bitte zuerst den Link in der Bestätigungs-Mail anklicken“ | Mail suchen (Spam), Link anklicken. |
| Bestätigungs-Link öffnet eine falsche Seite | Schritt 3 prüfen. |
| „Zu viele Versuche“ | Supabase verschickt ohne eigenen Mail-Server nur wenige Mails pro Stunde. Kurz warten. |
| „Keine Verbindung“ | Schritt 1 wiederholen, dann Seite neu laden. |

### Gut zu wissen
- Der Schlüssel `sb_publishable_…` in `index.html` ist öffentlich gedacht. Der Schutz kommt von den Datenbank-Regeln in `schema.sql`.
- Den **Secret key / service_role key** niemals in die Website oder ins Repo schreiben.
- Die Daten aus der claude.ai-Version werden nicht automatisch übernommen. Ihr startet mit leeren Listen.
