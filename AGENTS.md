# Barly - AGENTS.md

## Project Overview

Barly - macOS status bar management utility


## Tech Stack
- **Language**: Swift 6.1
- **UI Framework**: SwiftUI + AppKit
- **IDE**: Xcode
- **Platforms**: macOS
- **Minimum Deployment**: macOS 15.6 (Sequoia)

## Style & Conventions (MANDATORY)
**Strictly follow** the Swift/SwiftUI style guide: `~/Agents/Style/swift-swiftui-style-guide.md`

## Changelog (MANDATORY)
**All important code changes** (fixes, additions, deletions, changes) have to written to CHANGELOG.md.
Changelog format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## Localization (MANDATORY)
**Strictly follow** the localization guide: `~/Agents/Guides/localization-guide.md`
- All user-facing strings must be localized
- Follow formality rules per language
- Consistency is paramount

## Additional Guides
- Modern SwiftUI patterns: `~/Agents/Guides/swift-modern-development-guide.md`
- Observable migration: `~/Agents/Guides/swift-observable-migration-guide.md`
- Swift 6 concurrency: `~/Agents/Guides/swift6-concurrency-guide.md`
- Swift 6 migration (compact): `~/Agents/Guides/swift6-migration-compact-guide.md`
- Swift 6 migration (full): `~/Agents/Guides/swift6-migration-full-guide.md`

## Logging (MANDATORY)
This project uses **DZFoundation** (`~/GIT/Libraries/DZFoundation`) for logging.

**All debug logging must use:**
- `DZLog("message")` — General debug output
- `DZErrorLog(error)` — Conditional error logging (only prints if error is non-nil)

```swift
import DZFoundation

DZLog("Starting fetch")       // 🔶 fetchData() 42: Starting fetch
DZErrorLog(error)             // ❌ MyFile.swift:45 fetchData() ERROR: Network unavailable
```

**Do NOT use:**
- `print()` for debug output
- `os.Logger` instances
- `NSLog`

Both functions are no-ops in release builds.

## API Documentation
Local Apple API documentation is available at:
`~/Agents/API Documentation/Apple/`

The `search` binary is located **inside** the documentation folder:
```bash
~/Agents/API\ Documentation/Apple/search --help  # Run once per session
~/Agents/API\ Documentation/Apple/search "view controller" --language swift
~/Agents/API\ Documentation/Apple/search "NSWindow" --type Class
```

## Xcode Project Files (CATASTROPHIC — DO NOT TOUCH)
- **NEVER edit Xcode project files** (`.xcodeproj`, `.xcworkspace`, `project.pbxproj`, `.xcsettings`, etc.)
- Editing these files will corrupt the project — this is **catastrophic and unrecoverable**
- Only the user edits project settings, build phases, schemes, and file references manually in Xcode
- If a file needs to be added to the project, **stop and tell the user** — do not attempt it yourself
- Use `xcodebuild` for building/testing only — never for project manipulation
- **Exception**: Only proceed if the user gives explicit permission for a specific edit
  
## File System Synchronized Groups (Xcode 16+)
This project uses **File System Synchronized Groups** (internally `PBXFileSystemSynchronizedRootGroup`), introduced in Xcode 16. This means:
- The `Classes/` and `Resources/` directories are **directly synchronized** with the file system
- **You CAN freely create, move, rename, and delete files** in these directories
- Xcode automatically picks up all changes — no project file updates needed
- This is different from legacy Xcode groups, which required manual project file edits

**Bottom line:** Modify source files in `Classes/` and `Resources/` freely. Just never touch the `.xcodeproj` files themselves.

## Code Formatting (MANDATORY)
**Always run SwiftFormat after a successful build:**
```bash
swiftformat .
```

SwiftFormat configuration is defined in `.swiftformat` at the project root. This enforces:
- 4-space indentation
- Explicit `self.` usage
- K&R brace style
- Trailing commas in collections
- Consistent wrapping rules

**Do not commit unformatted code.**

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

---

## Notes
- The style guide emphasizes native SwiftUI patterns over MVVM boilerplate
- Prefer `@Observable` (iOS 17+) over `ObservableObject`
- Use `async/await` and `.task` modifier for async work
- Avoid Combine unless specifically needed
- Use `DZLog`/`DZErrorLog` for all debug logging — never `print()`
- Always run `swiftformat .` after successful builds before committing