# Barly

A lightweight macOS utility that keeps your status bar tidy by hiding icons you don't need to see all the time.

## Features

- **One-Click Hide/Show** - Click the arrow to toggle visibility
- **Global Hotkey** - `Cmd + Option + B` from anywhere
- **Auto-Collapse** - Automatically hides after a delay
- **Hide the Notch** - Switch to a notchless display mode on supported Macs

## Requirements

- macOS 15.6 or later

## Installation

Download the latest release from the [Releases](../../releases) page.

Or build from source:

```bash
git clone https://github.com/domzilla/Barly.git
cd barly
xcodebuild -project src/Barly.xcodeproj -scheme Barly -configuration Release build
```

## Usage

1. Hold `Cmd` and drag the `|` separator to choose which icons to hide
2. Click the arrow or press `Cmd + Option + B` to toggle
3. Right-click for preferences

## License

MIT - see [LICENSE](LICENSE)
