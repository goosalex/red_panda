# Red Panda

Repo: https://github.com/goosalex/red_panda

Quick-capture notes for iPhone (Lock Screen control, Control Center, Action Button, Siri)
with a cheerful red panda mascot. Design doc: https://claude.ai/artifact/Lqv8riwdN7aw2CBStJLu8q

## Layout

| Path | What |
| --- | --- |
| `lib/` | Flutter app: note list, ticking off, streak/XP, bamboo, categories, deadlines |
| `lib/ui/panda/` | Panda stage: drawn placeholder poses (sleeping, curious, excited, sad); swap in image frames via `assets/panda/` |
| `lib/ui/mascot.dart` | Old face painter, still used for the app icon (`make icon`) |
| `lib/logic/`, `lib/gamification/` | List order and filters, bamboo stash (pure Dart, unit-tested) |
| `ios/Shared/` | Swift shared by app + extension: storage, App Intents, voice recorder |
| `ios/RedPandaControls/` | Widget extension: Lock Screen / Control Center controls, Live Activity |
| `ios/RedPandaShare/` | Share extension: shared text becomes items (`ios/Shared/SharedText.swift` splits it; check with `tool/share_text_check`) |
| `ios/Runner/LeaveBasket.swift` | Leave basket reminder: geofence (CLMonitor) and Wi-Fi drop, plus a Shortcuts action |
| `ios/Runner/` | Flutter host app; `AppDelegate.swift` exposes the App Group path to Dart |
| `scripts/setup_xcode_targets.rb` | Re-applies the Xcode target setup (already applied) |

Bundle ids: `ch.masdatos.redpanda`, `ch.masdatos.redpanda.controls`, `ch.masdatos.redpanda.share`; App Group `group.ch.masdatos.redpanda`.
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

## Data files (App Group container)

`notes/<id>.json` (schema shared with `ios/Shared/NoteStore.swift`), `categories.json`,
`settings.json`, `panda_state.json` (bamboo).

## Rive mascot contract (v0.1, unused since v0.2's panda stage)

State machine `Panda`; triggers `greet`, `celebrate`, `sad`; number `streak`.
Save the file as `assets/rive/red_panda.riv`.
