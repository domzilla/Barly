# Barly

A lightweight macOS utility that keeps your status bar tidy by hiding icons you don't need to see all the time.

## Features

- **One-Click Hide/Show** - Click the arrow in your status bar to instantly hide or reveal your icons
- **Global Hotkey** - Toggle with `Cmd + Option + B` from anywhere
- **Auto-Collapse** - Automatically hides icons after a configurable delay (5-60 seconds)
- **Full Expand Mode** - Temporarily shows dock icon and clears the menu bar for complete access
- **Hide the Notch** - On MacBook Pro models with a notch, switch to a display mode that hides it
- **12 Languages** - English, German, French, Spanish, Italian, Dutch, Japanese, Korean, Portuguese, Brazilian Portuguese, Russian, and Simplified Chinese

## How It Works

Barly adds two icons to your status bar:

1. **Separator** (`|`) - Drag this to choose which icons stay visible
2. **Arrow** (`<`/`>`) - Click to toggle between hidden and visible states

When collapsed, the separator expands to push other icons off-screen. Items to the left of the separator get hidden; items to the right stay visible.

## Requirements

- macOS 15.6 (Sequoia) or later
- Works on all Macs, with notch-hiding support for MacBook Pro 14" and 16" models

## Installation

### Download

Download the latest release from the [Releases](../../releases) page.

### Build from Source

```bash
git clone https://github.com/domzilla/barly.git
cd Barly
xcodebuild -project src/Barly.xcodeproj -scheme Barly -configuration Release build
```

Or open `src/Barly.xcodeproj` in Xcode and build directly.

## Usage

1. Launch Barly
2. **Position the separator**: Hold `Cmd` and drag the `|` icon to the left of any icons you want to hide
3. **Toggle visibility**: Click the arrow icon or press `Cmd + Option + B`
4. **Access menu**: Right-click the arrow for preferences and additional options

### Preferences

- **Auto-collapse delay** - How long to wait before automatically hiding icons (5s, 10s, 15s, 30s, 60s)
- **Enable auto-collapse** - Toggle automatic hiding on/off
- **Full expand mode** - When expanding, also show dock icon and clear menu bar
- **Show preferences on launch** - Display the preferences window when Barly starts

### Hide the Notch

On supported MacBook Pro models, right-click the arrow and select "Hide Notch" to switch to a display mode that doesn't use the notch area. This gives you a clean, rectangular display.

## Supported Mac Models (Notch Feature)

- MacBook Pro 14" and 16" (M1 Pro/Max, M2 Pro/Max, M3/Pro/Max, M4/Pro/Max, M5)
- MacBook Air 13" and 15" (M2, M3, M4)

## Localization

Barly is localized in 12 languages:

| Language | Code |
|----------|------|
| English | en |
| German | de |
| French | fr |
| Spanish | es |
| Italian | it |
| Dutch | nl |
| Japanese | ja |
| Korean | ko |
| Portuguese | pt |
| Brazilian Portuguese | pt-BR |
| Russian | ru |
| Simplified Chinese | zh-Hans |

## Privacy

Barly:
- Runs entirely on your Mac with no network connections
- Stores preferences locally using UserDefaults
- Does not collect any data

## Contributing

Contributions are welcome. Please open an issue to discuss significant changes before submitting a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

Built with SwiftUI and AppKit. No external dependencies.
