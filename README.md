# Red Panda

Repo: https://github.com/goosalex/red_panda

Quick-capture notes for iPhone (Lock Screen control, Control Center, Action Button, Siri)
with a cheerful red panda mascot. Design doc: https://claude.ai/artifact/Lqv8riwdN7aw2CBStJLu8q

## Layout

| Path | What |
| --- | --- |
| `lib/` | Flutter app: note list, ticking off, streak/XP, mascot, confetti |
| `lib/ui/mascot.dart` | Mascot. Uses `assets/rive/red_panda.riv` if present, else a drawn placeholder |
| `ios/Shared/` | Swift shared by app + extension: storage, App Intents, voice recorder |
| `ios/RedPandaControls/` | Widget extension: Lock Screen / Control Center controls, Live Activity |
| `ios/Runner/` | Flutter host app; `AppDelegate.swift` exposes the App Group path to Dart |
| `scripts/setup_xcode_targets.rb` | Re-applies the Xcode target setup (already applied) |

Bundle ids: `ch.masdatos.redpanda`, `ch.masdatos.redpanda.controls`; App Group `group.ch.masdatos.redpanda`.
Minimum iOS 18.

## First build on the Mac

```sh
make setup          # creates ios/Flutter/Signing.xcconfig -> set DEVELOPMENT_TEAM
make check          # analyze + tests
make sim            # simulator build, no signing
make run-device     # iPhone 17 Pro over USB/Wi-Fi
```

The first signed build registers the App IDs and App Group on the team automatically
(automatic signing). If Xcode complains, open `ios/Runner.xcworkspace` once, select the
Runner and RedPandaControls targets > Signing & Capabilities, and pick the team.

## Release

`make ipa` then `make upload` (App Store Connect API key, see Makefile), or open the ipa in Transporter.

## Rive mascot contract

State machine `Panda`; triggers `greet`, `celebrate`, `sad`; number `streak`.
Save the file as `assets/rive/red_panda.riv`.
