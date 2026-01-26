# Changelog

All notable changes to Barly will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Sparkle framework for automatic updates
- DZFoundation dependency for debug logging
- SwiftFormat configuration and pre-commit hook
- README.md for GitHub
- MIT license

### Changed

- Replace `print()` statements with `DZLog()` (debug-only logging)

## [1.0.0] - 2025-12-14

### Added

- Initial release
- Status bar hide/show with expandable separator
- Global hotkey (Cmd+Option+B) to toggle visibility
- Auto-collapse with configurable delay (5s, 10s, 15s, 30s, 60s)
- Full expand mode (shows dock icon and clears menu bar)
- Hide/show notch on supported MacBook Pro and MacBook Air models
- Preferences window with status bar mock visualization
- Alert when separator is positioned incorrectly
- Support for MacBook Pro M5 (2025) model identifiers
- Localization for 12 languages:
  - English, German, French, Spanish, Italian, Dutch
  - Japanese, Korean, Portuguese, Brazilian Portuguese
  - Russian, Simplified Chinese
- App icons
- Clutter helper tool for testing
