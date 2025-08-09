# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Gureum (구름 입력기) is a Korean input method editor (IME) for macOS, built with Swift and Xcode. It supports various Korean keyboard layouts including Dubeolsik (2-set), Sebeolsik (3-set), and other variations, powered by libhangul.

## Development Setup

### Initial Setup
```bash
make init  # Sets up development environment, installs dependencies, and initializes submodules
open Gureum.xcodeproj  # Opens the main Xcode project
```

Required tools are installed automatically via `make init`:
- Xcode (not command line tools)
- Homebrew packages: `shellcheck`, `swiftformat`
- Ruby gem: `xcpretty`

### Submodule Management
The project uses git submodules for libhangul integration. If submodules fail to clone:
```bash
git submodule deinit -f --all
rm -rf .git/modules/*
git submodule update --init --recursive
```

## Build and Development Commands

### Building
- Build target: `Gureum` (builds the main input method)
- Debug builds enable Console.app logging
- **Never run the input method directly from Xcode** - always use the installation script

### Code Formatting
```bash
make format  # Runs swiftformat on Swift source files
```
Code formatting is enforced in CI - all changes must pass swiftformat checks.

### Testing and Installation
```bash
# Install debug build for testing
cd tools && ./install_debug.sh

# Run unit tests
# Use Cmd+U in Xcode or run specific test targets
```

After debug installation, configure the input method in System Preferences → Keyboard → Input Sources.

### Test Applications
- `OSXTestApp` target: Test preferences UI without system settings
- Test input method in: TextEdit.app, Terminal.app, Firefox.app

## Architecture

### Core Modules
- **OSXCore/**: Main input method logic
  - `InputController.swift`: Core input handling and event processing
  - `GureumComposer.swift`: Input source definitions and composition logic
  - `InputMethodServer.swift`: Low-level input method server and IOKit integration
  - `HangulComposer.swift`: Korean character composition
  - `RomanComposer.swift`: Latin character handling
  - `Configuration.swift`: Settings management

- **OSX/**: macOS application layer
  - `GureumAppDelegate.swift`: Main application delegate
  - `ConfigurationWindow.swift`: Preferences interface
  - Menu bar and system integration

- **Preferences/**: System Preferences pane
  - `GureumPreferencePane.swift`: Preference pane implementation

- **GureumTests/**: Unit tests

### Input Sources
Supports multiple keyboard layouts via `GureumInputSource` enum:
- Roman layouts: QWERTY, Dvorak, Colemak
- Korean layouts: 2-set, 3-set variants, Ahnmatae, Roman-Korean

### Data Files
- `OSXCore/data/keyboards/`: XML keyboard layout definitions
- `OSXCore/data/hanja/`: Chinese character data and conversion tables

## Project Structure

- `Gureum.xcodeproj`: Main Xcode project
- `libhangul-objc/`: Objective-C wrapper for libhangul (submodule)
- `hangeul/`: Custom Korean input processing library
- `tools/`: Build and deployment scripts
- Multiple targets for macOS app, preferences pane, and test applications

## Testing Requirements

Before committing:
1. Run unit tests (Cmd+U)
2. Test input method functionality in TextEdit and Terminal
3. Run `make format` for code style consistency
4. Verify builds pass in both Debug and Release configurations

## Notes

- Input method debugging is challenging - use logging via Console.app primarily
- The project separates concerns to avoid libhangul license propagation
- All Swift code should follow the project's swiftformat configuration
- Input methods require special installation procedures - never run directly from Xcode