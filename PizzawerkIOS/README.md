# Pizzawerk iOS

SwiftUI/WKWebView-Version der Android-App.

## Funktionen
- Schwarzer oberer Sicherheitsbereich ohne Pizzawerk-Kopfzeile und ohne Menü-Schaltfläche.
- Untere Navigation: Start, Karten, Standorte, Social.
- Menükarten und Standorte auswählbar.
- Instagram und Facebook integriert.
- Neues Pizzawerk-App-Symbol in allen iOS-Größen.
- Live-Inhalte direkt von der Website.
- Tägliche Aktualisierungsanforderung ab 10:00 Uhr und sichere Aktualisierung beim nächsten Öffnen.

## Auf iPhone bauen
1. Projekt auf einem Mac mit Xcode 16 oder neuer öffnen.
2. Target `PizzawerkIOS` > Signing & Capabilities öffnen.
3. Eigenes Apple-Team auswählen und bei Bedarf Bundle-ID ändern.
4. iPhone anschließen und Run drücken.

Hinweis: iOS entscheidet selbst, wann Hintergrundaktualisierungen ausgeführt werden. Eine sekundengenaue Ausführung um 10:00 Uhr ist nicht garantiert; beim nächsten Öffnen nach 10:00 Uhr wird sicher neu geladen.

Visual in this file was generated with Microsoft Copilot.
