# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Naming Convention

- **Menu Bar**: The left side of the top bar showing app menus (App Name, File, Edit, View, etc.)
- **Status Bar**: The right side of the top bar where icons live (system icons, third-party app icons)

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

Collapse works by setting the separator's length to 10,000 pixels, pushing other status bar items off-screen. The separator must be positioned to the LEFT of the arrow for this to work (validated via `isSeparatorValidPosition`).

### Key Components

- **MenuController** (`src/Barly/Classes/Controllers/MenuController.swift`) - Context menu and preferences window management
- **DisplayModeManager** (`src/Barly/Classes/Utilities/DisplayModeManager.swift`) - Display mode switching for notch hiding
- **ActivationPolicyManager** (`src/Barly/Classes/Utilities/ActivationPolicyManager.swift`) - Manages full expand feature (dock icon and empty menu bar)
- **HotkeyManager** (`src/Barly/Classes/Utilities/HotkeyManager.swift`) - Global hotkey (Cmd+Option+B) using Carbon API
- **Preferences** (`src/Barly/Classes/Models/Preferences.swift`) - UserDefaults keys and defaults
- **PreferencesView** (`src/Barly/Classes/Views/PreferencesView.swift`) - SwiftUI preferences window hosted in NSWindow

### Preferences

Stored via `@AppStorage`/`UserDefaults`:
- `isAutoCollapseEnabled` (default: true)
- `autoCollapseDelay` (default: 10 seconds)
- `isFullExpandEnabled` (default: true) - Shows dock icon and empty menu bar when expanded
- `showPreferencesOnLaunch` (default: true)

## Tools

### Clutter (`tools/Clutter/`)

Helper app for testing Barly with many menu bar and status bar items. Provides buttons to dynamically add/remove:
- Menu bar items ("Menu Item 1", "Menu Item 2", etc.) - adds to the app's main menu
- Status bar items (ladybug SF Symbol icons) - adds to the status bar

```bash
xcodebuild -project tools/Clutter/Clutter.xcodeproj -scheme Clutter -configuration Debug build
```
