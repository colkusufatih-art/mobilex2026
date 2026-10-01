# Crealogix Mobile Banking App 2025

Eine vollständige Flutter Mobile Banking App mit Material 3 Design System, implementiert nach Figma Designs.

## 🎯 Projektübersicht

Dieses Projekt implementiert exakt die Designs aus Figma mit:
- Material 3 Design System
- Komponentenbibliothek mit Varianten
- Material 3 Symbol Icons
- Theme-Support (Light & Dark Mode)
- Clean Architecture Struktur

## 📐 Design-System Mapping

### Farben (aus Figma Variables)
Alle Farben wurden 1:1 aus Figma übernommen:

- **Primary Dark Yellow**: `#FFA814`
- **Primary Light Grey**: `#F2F2F2`
- **Primary Dark Steelblue**: `#134561`
- **Secondary Steelblue**: `#417691`
- **Secondary Dark Pink**: `#990061`
- **Secondary Orange**: `#EF7C00`
- **Secondary Skyblue**: `#5BC5F2`
- **Secondary Prussian Blue**: `#00255C`
- **Greys Dark Grey**: `#333333`
- **Greys Mid Grey**: `#888888`

**Light Background**: `#FAFAFA`  
**Dark Background**: `#2B2B2B`

### Typografie
- **Font Family**: Open Sans (Google Fonts)
- **Regular**: 400
- **Bold**: 700
- **Titel**: 28px (Regular/Bold)
- **Body**: 16px
- **Button**: 16px Bold

### Spacing
Alle Abstände entsprechen exakt den Figma Messungen:
- Status Bar: 59px
- Image Section: 436px
- Button Primary: 56px Höhe
- Button Secondary: 35px Höhe
- Bottom Sheet: 236px Höhe

### Border Radius
- Buttons: 8px
- Icon Buttons: 8px
- Bottom Sheet Handle: 4px
- PIN Dots: 100px (circle)

## 🏗️ Projektstruktur

```
mobilex2025/
├── lib/
│   ├── main.dart                    # Entry point
│   ├── app.dart                     # MaterialApp & Theme
│   ├── core/
│   │   ├── theme/
│   │   │   ├── color_schemes.dart   # Figma Farben → ColorScheme
│   │   │   ├── typography.dart      # TextTheme aus Figma
│   │   │   ├── spacing.dart        # Abstände als const Werte
│   │   │   ├── radius.dart         # BorderRadius Tokens
│   │   │   └── elevation.dart      # Material elevations
│   │   ├── icons/
│   │   │   └── m3_icons.dart        # Material 3 Icons Wrapper
│   │   └── utils/
│   ├── ui/
│   │   ├── components/
│   │   │   ├── buttons/
│   │   │   │   ├── app_filled_button.dart      # Primary Button
│   │   │   │   ├── app_outlined_button.dart    # Secondary Button
│   │   │   │   └── pin_number_button.dart      # PIN Keyboard Button
│   │   │   ├── app_bar/
│   │   │   │   └── app_status_bar.dart         # Status Bar Component
│   │   │   └── cards/
│   │   │       ├── pin_dots.dart                # PIN Dots Indicator
│   │   │       └── app_bottom_sheet.dart       # Bottom Sheet Component
│   │   └── layout/
│   ├── features/
│   │   ├── splash/
│   │   │   └── presentation/
│   │   │       └── splash_screen.dart
│   │   ├── sign_up/
│   │   │   └── presentation/
│   │   │       └── sign_up_screen.dart
│   │   ├── login/
│   │   │   └── presentation/
│   │   │       └── login_existing_user_screen.dart
│   │   └── pin/
│   │       └── presentation/
│   │           └── pin_screen.dart
│   └── routing/
│       └── app_router.dart          # GoRouter Configuration
├── assets/
│   ├── images/
│   ├── icons/
│   └── img/                         # Figma exported assets
└── pubspec.yaml
```

## 📱 Implementierte Screens

### 1. Splash Screen
- **Figma Frame**: Splashscreen (7:942)
- **Features**: Logo zentriert, 3 Sekunden Wartezeit
- **Asset**: CLX_Login_215x55-LM.png / CLX_Login_215x55-DM.png

### 2. Sign Up Screen
- **Figma Frame**: Sign up (23:4450)
- **Features**: Building background, Welcome text, Get started button
- **Asset**: building.png

### 3. Login Existing User Screen
- **Figma Frame**: Login – Existing User (23:4482)
- **Features**: Personalized welcome, User name, Login button
- **Text**: "Welcome Reto Haldner"

### 4. PIN Screen
- **Figma Frame**: PIN (11:641)
- **Features**: 6-digit PIN entry, Number keyboard, FaceID option, PIN forgotten link
- **Components**: PIN Dots, Number buttons

## 🎨 Komponenten

### Buttons
- **AppFilledButton**: Primary action button (56px height, #333333 background)
- **AppOutlinedButton**: Secondary action button (35px height, transparent border)
- **PinNumberButton**: Numeric keyboard button (93x64px)

### Cards
- **PinDots**: Indicator für PIN-Eingabe-Progress
- **AppBottomSheet**: Bottom sheet mit Handle und Liste

### App Bar
- **AppStatusBar**: Status Bar mit Zeit und Icons

## 🚀 Verwendung

### Installation
```bash
cd mobilex2025
flutter pub get
flutter run
```

### Navigation
Die App verwendet GoRouter für Navigation:
- `/splash` - Splash Screen
- `/sign-up` - Sign Up Screen
- `/login` - Login Screen
- `/pin` - PIN Entry Screen

### Theme Switching
Das Theme passt sich automatisch an die Systemeinstellungen an (Light/Dark Mode).

## 📦 Dependencies

- **material_symbols_icons**: Material 3 Symbol Icons
- **google_fonts**: Open Sans Font Family
- **go_router**: Navigation
- **gap**: Spacing utilities
- **flutter_svg**: SVG support
- **intl**: Internationalization

## 🎯 Komponenten-Varianten

Alle Komponenten folgen Figma-Varianten:

### Button Variants
- Size: 56px (primary), 35px (secondary)
- Variant: filled, outlined
- State: enabled, disabled, loading

### PIN Dot Variants
- Active: #FFA814
- Inactive: #DADADA
- Size: 12x12px

### Icon Variants
- Size: 24px (standard), 16px (status), 20px (battery)
- Material 3 Symbols throughout

## ✅ Validierung

Alle folgenden Aspekte wurden 1:1 aus Figma übernommen:
- ✅ Hex-Werte der Farben stimmen überein
- ✅ Schriftgrößen, Gewichte, Line-Heights exakt
- ✅ Spacing/Padding/Borders/Radius identisch
- ✅ Komponenten-States/Varianten vorhanden
- ✅ Material 3 Icons verwendet
- ✅ Assets registriert
- ✅ Screens über Routen erreichbar

## 📝 Nächste Schritte

Für vollständige Funktion:
- Backend-Integration
- State Management (Provider/Riverpod)
- Authentication Logic
- Additional Screens aus Figma
- Animationen & Transitions

## 📄 Lizenz

Copyright © 2025 Crealogix
