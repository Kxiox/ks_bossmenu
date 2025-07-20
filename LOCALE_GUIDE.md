# 🌍 Multi-Language Support

Das KS Boss Menu unterstützt automatisch mehrere Sprachen! Das System funktioniert sowohl in der Entwicklung als auch im produktiven Build und erkennt dynamisch alle verfügbaren Übersetzungsdateien.

## 📁 Verfügbare Sprachen

- **🇩🇪 Deutsch** (`de.json`) - Standard
- **🇬🇧 English** (`en.json`)
- **🇫🇷 Français** (`fr.json`) - Beispiel

## ✨ Neue Sprache hinzufügen (Development)

### Schritt 1: Übersetzungsdatei erstellen
Erstelle eine neue JSON-Datei im `vuejs/public/locales/` Ordner:

```
vuejs/public/locales/[sprachcode].json
```

## ✨ Neue Sprache hinzufügen (Production Build)

### Schritt 1: Übersetzungsdatei erstellen
Erstelle eine neue JSON-Datei im `html/locales/` Ordner:

```
html/locales/[sprachcode].json
```

Beispiele:
- `es.json` für Spanisch
- `it.json` für Italienisch  
- `nl.json` für Niederländisch
- `pl.json` für Polnisch

### Schritt 2: Übersetzungen kopieren
Kopiere den Inhalt einer bestehenden Datei (z.B. `de.json`) und übersetze alle Werte:

```json
{
    "pages": {
        "home": "Tu traducción aquí",
        "employees": "Tu traducción aquí",
        ...
    }
}
```

### Schritt 3: Aktualisieren (nur im Build)
Wenn du eine neue Sprache im Build hinzugefügt hast, aktualisiere die verfügbaren Sprachen:

```javascript
// In der Browser-Konsole:
refreshLocales()
```

### Schritt 4: Fertig! 🎉
Das System erkennt die neue Sprache automatisch. Kein Code-Update nötig!

## 🔧 Sprache wechseln (Entwicklung & Production)

### Browser-Konsole:
```javascript
// Verfügbare Sprachen anzeigen
getAvailableLocales()

// Aktuelle Sprache anzeigen  
getCurrentLocale()

// Sprache wechseln (Async - gibt Promise zurück)
await setLocale('es')  // Zu Spanisch wechseln
await setLocale('de')  // Zu Deutsch wechseln

// Verfügbare Sprachen neu laden (nach Hinzufügen neuer Dateien)
await refreshLocales()
```

### Über NUI-Message (für Server-Integration):
```javascript
// Von Lua/Server senden:
SendNUIMessage({
    action = 'setLocale',
    locale = 'es'
})
```

## 🏗️ Build-Integration

### Für Server-Owner (Production):
1. **Neue Sprache hinzufügen:**
   - Erstelle `html/locales/deinsprachcode.json`
   - Kopiere den Inhalt von `html/locales/de.json`
   - Übersetze alle Werte
   
2. **Sprache aktivieren:**
   ```lua
   -- In deinem Lua-Script:
   SendNUIMessage({
       action = 'setLocale',
       locale = 'es'  -- Deine neue Sprache
   })
   ```

3. **Automatisches Laden:** Das System lädt die neue Sprache automatisch!

### Für Resource-Entwickler:
- Das System funktioniert in **Development** und **Production**
- Dynamisches Laden über `fetch()` - funktioniert auch nach dem Build
- Vollständig kompatibel mit ESX/QB-Core Multi-Language-Systemen
- Keine Vite/Webpack-Konfiguration nötig

## 📦 Build-Prozess

1. **Development:** Dateien in `vuejs/public/locales/`
2. **Build:** Vite kopiert automatisch nach `html/locales/`
3. **Production:** Server-Owner können direkt in `html/locales/` neue Sprachen hinzufügen

## 📋 Vollständige Übersetzungsstruktur

Alle neuen Sprachen sollten diese Struktur haben:

```json
{
    "pages": { ... },
    "home": { ... },
    "employees": { ... },
    "salaries": { ... },
    "account": { ... },
    "bonus": { ... },
    "buttons": { ... },
    "notifies": {
        "account": { "deposit": {...}, "withdraw": {...} },
        "employees": { "promote": {...}, "demote": {...}, "fire": {...}, "add": {...} },
        "salaries": { "change": {...} },
        "bonus": { ... }
    }
}
```

## 🚀 Prioritätenreihenfolge

1. **Deutsch** (`de.json`) - Standard wenn verfügbar
2. **Englisch** (`en.json`) - Fallback wenn Deutsch nicht verfügbar
3. **Erste verfügbare Sprache** - Wenn weder Deutsch noch Englisch verfügbar

## 💡 Tipps

- **Sprachcodes:** Verwende ISO 639-1 Codes (de, en, fr, es, it, etc.)
- **Testing:** Teste deine Übersetzungen mit `await setLocale('deinsprachcode')`
- **Parameter:** Verwende `{parameter}` für dynamische Werte (z.B. `{amount}`, `{name}`)
- **Vorlage:** Kopiere eine bestehende Datei als Vorlage für Vollständigkeit
- **Hot-Add:** Neue Sprachen können auch zur Laufzeit hinzugefügt werden!
- **Cache:** Das System cached geladene Sprachen für bessere Performance

## 🚀 Unterstützte Sprachen (Auto-Discovery)

Das System sucht automatisch nach diesen Sprachcodes:
`de`, `en`, `fr`, `es`, `it`, `nl`, `pl`, `pt`, `ru`, `tr`, `cs`, `sk`, `hu`, `ro`, `bg`, `hr`, `sl`, `lv`, `lt`, `et`, `fi`, `sv`, `da`, `no`, `is`

Einfach eine entsprechende `.json` Datei erstellen und das System erkennt sie automatisch! ✨
