# Barly - AGENTS.md

## Project Overview
Barly - macOS status bar management utility

## Tech Stack
- **Language**: Swift
- **UI Framework**: AppKit + SwiftUI (views only)
- **IDE**: Xcode
- **Platforms**: macOS

## Guides (MANDATORY)
Read `~/Agents/Guides/xcode-project-guide.md` in full before planning or editing anything.

Read these in full before touching the matching code:
- Swift style (`.swift`): `~/Agents/Style/swift-swiftui-style-guide.md`
- Accessibility (UI code, XIBs, storyboards): `~/Agents/Guides/accessibility-guide.md`

## Naming Convention
- **Menu Bar**: The left side of the top bar showing app menus (App Name, File, Edit, View, etc.)
- **Status Bar**: The right side of the top bar where icons live (system icons, third-party app icons)

## Build Commands
```bash
# Build from command line
xcodebuild -project src/Barly.xcodeproj -scheme Barly -configuration Debug build

# Clean build
xcodebuild -project src/Barly.xcodeproj -scheme Barly clean
```

Open `src/Barly.xcodeproj` in Xcode to build and run directly.

## Testing (MANDATORY)
No test targets exist in this project.

## Architecture
Barly is a macOS status bar management app that hides/shows status bar items. It uses a native AppKit lifecycle (`main.swift` + `NSApplication`) with SwiftUI for views only (hosted via `NSHostingController`).

### Core Flow

1. **main.swift** (`src/Barly/Classes/main.swift`) - Native AppKit entry point, creates `NSApplication` and sets `AppDelegate`
2. **AppDelegate** (`src/Barly/Classes/AppDelegate.swift`) - Initializes `StatusBarController` and `HotkeyManager` on launch
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
