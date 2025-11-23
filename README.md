# Mac Audio Keepalive

Optical/HDMI Audio Port Keepalive for MacOS

Do you use HDMI or Optical cable to connect your mac and your amplifier? Do you experience one second silences in high fidelity music, lost words and lost sounds in movies? Well, it's not your nor your hardware's fault - it's an energy saving feature of these audio interfaces. And Mac Audio Keepalive is the solution for you!!!

Mac Audio Keepalive generates an absolutely unhearable tone that prevents your optical audio output to shut down at short silences/musical breaks, so you can enjoy an uninterrupted hi-fi audio stream. Enjoy!

## Attribution

This is an educational fork of [milgra/macaudiokeepalive](https://github.com/milgra/macaudiokeepalive) with v2.0 enhancements. Original concept and v1.x implementation by Milan Toth.

**Status**: 🎓 Educational fork for study purposes - No binary releases available yet.

Download the original compiled application from Milan's [homepage](http://milgra.com/mac-audio-keepalive.html)

---

## What's New in Version 2.0

- **Interval-based scheduling**: Configure audio pulses at regular intervals (5-30 minutes) instead of continuous playback
- **User preferences**: Persistent settings via NSUserDefaults
- **Preferences UI**: Easy configuration through preferences window
- **Dual audio modes**: Choose between Continuous (original behavior) or Interval-based
- **Enhanced architecture**: Modular design with AudioController, AudioScheduler, and SettingsManager components

### Version 1.2 (Original)
- New icon
- New menu items
- Developer ID signed trusted app

---

## Building

This is a standard Xcode Objective-C project:

1. Open `Mac Audio Keepalive.xcodeproj` in Xcode
2. Build with ⌘B
3. Run with ⌘R

The application appears only in the menu bar (no dock icon).

See [CLAUDE.md](CLAUDE.md) for detailed architecture and development information

