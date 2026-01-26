# AGENTS.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

- **App**: Barly - macOS status bar management utility
- **Version**: 1.0
- **Bundle ID**: net.domzilla.barly
- **Deployment Target**: macOS 15.6 (Sequoia)
- **Swift Version**: 6.1
- **Dependencies**: None (pure SwiftUI + AppKit)

## Naming Convention

- **Menu Bar**: The left side of the top bar showing app menus (App Name, File, Edit, View, etc.)
- **Status Bar**: The right side of the top bar where icons live (system icons, third-party app icons)

## Project Structure

```
Barly/
├── src/
│   ├── Barly.xcodeproj/           # Xcode project
│   └── Barly/
│       ├── BarlyApp.swift         # @main entry point
│       ├── Classes/
│       │   ├── AppDelegate.swift
│       │   ├── Controllers/
│       │   │   ├── StatusBarController.swift
│       │   │   └── MenuController.swift
│       │   ├── Models/
│       │   │   └── Preferences.swift
│       │   ├── Utilities/
│       │   │   ├── HotkeyManager.swift
│       │   │   ├── DisplayModeManager.swift
│       │   │   ├── ActivationPolicyManager.swift
│       │   │   └── DeviceInformation.swift
│       │   └── Views/
│       │       ├── PreferencesView.swift
│       │       └── StatusBarMockView.swift
│       └── Ressources/            # Localization (12 languages)
├── tools/
│   └── Clutter/                   # Testing helper app
├── assets/                        # Icons and design files
├── AGENTS.md                      # This file
├── CLAUDE.md -> AGENTS.md         # Symlink
└── README.md                      # GitHub readme
```

## Build Commands

```bash
# Build from command line
xcodebuild -project src/Barly.xcodeproj -scheme Barly -configuration Debug build

# Run tests
xcodebuild -project src/Barly.xcodeproj -scheme Barly -configuration Debug test

# Clean build
xcodebuild -project src/Barly.xcodeproj -scheme Barly clean
```

Open `src/Barly.xcodeproj` in Xcode to build and run directly.

## Architecture

Barly is a macOS status bar management app that hides/shows status bar items. It uses SwiftUI with AppKit integration for status bar functionality.

### Core Flow

1. **BarlyApp** (`src/Barly/BarlyApp.swift`) - SwiftUI app entry point using `@NSApplicationDelegateAdaptor` to bridge to AppKit
2. **AppDelegate** (`src/Barly/Classes/AppDelegate.swift`) - Initializes `StatusBarController` and `HotkeyManager` on launch
3. **StatusBarController** (`src/Barly/Classes/Controllers/StatusBarController.swift`) - Core logic for the status bar items

### Status Bar Hide/Show Mechanism

The app uses two `NSStatusItem`s:
- **Arrow item** - Toggle button (right side), handles click events
- **Separator item** - Pipe icon that expands to hide items (left side)

Collapse works by setting the separator's length to 10,000 pixels, pushing other status bar items off-screen. The separator must be positioned to the LEFT of the arrow for this to work (validated via `isSeparatorValidPosition`). If the separator is in the wrong position, an alert is shown to the user explaining how to fix it.

### Key Components

| Component | Path | Description |
|-----------|------|-------------|
| **StatusBarController** | `Controllers/StatusBarController.swift` | Core hide/show logic, manages two NSStatusItems |
| **MenuController** | `Controllers/MenuController.swift` | Context menu, preferences window. Uses `NSMenuItemValidation` for notch toggle |
| **DisplayModeManager** | `Utilities/DisplayModeManager.swift` | Display mode switching for notch hiding. Detects lid closed state |
| **DeviceInformation** | `Utilities/DeviceInformation.swift` | Model identifier, notch detection (25+ Mac models) |
| **ActivationPolicyManager** | `Utilities/ActivationPolicyManager.swift` | Full expand feature (dock icon + empty menu bar) |
| **HotkeyManager** | `Utilities/HotkeyManager.swift` | Global hotkey (Cmd+Option+B) via Carbon API |
| **Preferences** | `Models/Preferences.swift` | UserDefaults keys and defaults |
| **PreferencesView** | `Views/PreferencesView.swift` | SwiftUI preferences window (640x420) |
| **StatusBarMockView** | `Views/StatusBarMockView.swift` | Visual mock with "Hidden"/"Shown" labels using PreferenceKey |

### Preferences

Stored via `@AppStorage`/`UserDefaults`:
- `isAutoCollapseEnabled` (default: true)
- `autoCollapseDelay` (default: 10 seconds)
- `isFullExpandEnabled` (default: true) - Shows dock icon and empty menu bar when expanded
- `showPreferencesOnLaunch` (default: true)

### Notch Support

`DeviceInformation.swift` contains a hardcoded list of Mac models with notches:
- MacBook Air 13"/15" (M2, M3, M4)
- MacBook Pro 14"/16" (M1 Pro/Max through M5)

The notch hide feature uses `DisplayModeManager` to switch to a 16:10 display mode that doesn't use the notch area.

### Localization

Localization files are in `src/Barly/Ressources/`. Supported languages:

| Language | Folder |
|----------|--------|
| English | `en.lproj` |
| German | `de.lproj` |
| French | `fr.lproj` |
| Spanish | `es.lproj` |
| Italian | `it.lproj` |
| Dutch | `nl.lproj` |
| Japanese | `ja.lproj` |
| Korean | `ko.lproj` |
| Portuguese | `pt.lproj` |
| Brazilian Portuguese | `pt-BR.lproj` |
| Russian | `ru.lproj` |
| Simplified Chinese | `zh-Hans.lproj` |

All user-facing strings use `String(localized:)` for localization support.

## Tools

### Clutter (`tools/Clutter/`)

Helper app for testing Barly with many menu bar and status bar items. Provides buttons to dynamically add/remove:
- Menu bar items ("Menu Item 1", "Menu Item 2", etc.) - adds to the app's main menu
- Status bar items (ladybug SF Symbol icons) - adds to the status bar

```bash
xcodebuild -project tools/Clutter/Clutter.xcodeproj -scheme Clutter -configuration Debug build
```

## Assets

Design assets are in `assets/`:
- `Icon_barly.png` - App icon (1024x1024)
- `collapse.pdf`, `expand.pdf` - Arrow icons for status bar
- `seprator.pdf` - Separator/pipe icon
- `Icon.psd` - Master Photoshop design file
