# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Mac Audio Keepalive is a macOS menu bar application that prevents optical/HDMI audio interfaces from shutting down during silent periods by continuously playing an inaudible tone. This solves audio dropout issues in hi-fi setups where the audio interface enters power-saving mode during short silences.

## Architecture

The application uses a minimal 3-component architecture:

**AppDelegate** (`AppDelegate.h/m`)
- Manages the macOS menu bar status item with icon and menu
- Creates and owns the WavePlayer instance on launch
- Handles menu actions: Donate, Check for Updates, Quit
- Entry point: `applicationDidFinishLaunching:`

**WavePlayer** (`WavePlayer.h/m`)
- Core audio generation using Core Audio's AudioQueue API
- Continuously generates near-silent audio signal to prevent interface shutdown
- Audio format: 44.1kHz, 8-bit, mono, signed integer PCM
- Uses double-buffering (2 buffers of 44100 samples each)
- Signal pattern: 1-value pulse every 200 samples, otherwise 0 (inaudible frequency)
- Volume: 1% (0.01) to ensure inaudibility
- Callback: `updateQueue()` re-enqueues buffers as they're consumed

**main.m**
- Standard macOS application entry point calling `NSApplicationMain()`

## Key Technical Details

### Audio Generation Strategy
The WavePlayer generates a repeating low-frequency pulse pattern that is:
- Mathematically present (prevents interface shutdown)
- Acoustically inaudible (volume 1%, sparse pulse pattern)
- Continuous (double-buffered queue never stops)

### Menu Bar Application
- `LSUIElement = true` in Info.plist makes this a menu-bar-only app (no dock icon)
- Uses template image for menu bar icon (adapts to light/dark mode)
- Simple menu: status display, external links, quit option

## Building and Running

This is a standard Xcode Objective-C project:

**Build**: Open `Mac Audio Keepalive.xcodeproj` in Xcode and build (⌘B)
**Run**: Build and run in Xcode (⌘R) or run the built .app bundle

The application appears only in the menu bar (no dock icon) and begins audio generation immediately on launch.

## Development Notes

- Uses manual reference counting (note commented `[super dealloc]` in WavePlayer)
- Application is codesigned with Developer ID for distribution
- Current version: 1.2
- No external dependencies beyond macOS frameworks (Cocoa, AudioToolbox)
- Audio buffer size matches sample rate (44100) for 1-second buffering

## Code Style

- Objective-C with unconventional spacing: `[ object method : param ]` instead of `[object method:param]`
- Maintain this spacing style for consistency with existing codebase
- C-style callback functions for AudioQueue integration (`updateQueue()`)
