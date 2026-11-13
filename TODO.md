# Red Panda — TODO

Everything below shipped in v0.2 as placeholder-art versions; the panda art is to be replaced with NovelAI frames via `assets/panda/<pose>.png` or `<pose>_<n>.png`.

## List interaction

- [x] Let the user re-order items up and down
- [x] Only check the box when really tapping the check mark
- [x] Long tap on an item opens the editor to modify its text

## Swipe actions

- [x] Left-to-right swipe: undo check (default on checked items)
- [x] Let the user configure the left-to-right swipe action in settings
- [x] Snooze: puts a task off (e.g. to tomorrow), paid for with bamboo, so the user only has a limited amount of snooze power (see Bamboo rewards)
- [x] Proposed further swipe actions to choose from:
  - Postpone deadline by one day (free while far from the deadline; costs bamboo when close)
  - Pin to top / mark as important
  - Move to category (pick a cloud)
  - Set or change the deadline (opens the "days from now" dial)
  - Remind me later today (one-off notification in a few hours)
  - Duplicate (for recurring chores)
  - Share the item as text
  - Delete, with an undo toast

## Deadlines

- [x] Time-constrain items with a small dial in "days from now"
- [x] Items with a deadline show a subtle little old-fashioned alarm clock symbol in the right gutter
- [x] Nag the user as time-constrained items come nearer to their deadline

## Nagging (widgets and notifications)

- [x] Persistent, gently guilt-tripping reminders in a Duolingo-like spirit, but with sad (cute) red pandas
  - Notifications whose tone escalates as deadlines approach or the list sits untouched
  - Home and lock screen widgets whose panda gets sadder the more is overdue, and cheers up when tasks are done
  - Respect quiet hours and let the user tune the intensity

## Bamboo rewards

- [x] Every completed task rewards some bamboo (or eggs, which red pandas also eat)
- [x] Bamboo is traded against snoozes; show the current stash somewhere near the panda
- [x] Balance: cap the stash and/or make bigger postponements cost more, so snoozing stays scarce

## Categories

- [x] Concept: a small cloud per category hovers around the sleeping red panda
  - Dragging an item onto a cloud classifies it
  - Tapping a cloud filters the visible items to that category
  - Tapping the sun / moon (according to daytime) clears all filters and shows all items, ordered by the importance the user gave them by dragging (if any), or by their deadline

## Panda mascot

- [x] Default panda sleeps curled up like a foxy bun, nose in the tail
- [x] While typing, the tail forms a question mark and the pointy ears focus on the user (wiggle with the motion sensor)
- [x] When an item is checked, the happy panda jumps up in the signature and celebrates

## Lock screen

- [x] Lock screen widgets can go anywhere, not just in the two small round slots at the bottom
  - v0.2: a widget for every slot iOS offers: the line above the clock, the widget row under it (round and rectangular), plus Home Screen small/medium. Free placement elsewhere is not possible on iOS.

## 0.2.1

- [x] Settings collapse to one line each; choices open in a drawer, the leave basket and quick capture on their own pages
- [x] Direct links into the Shortcuts app to wire Wi-Fi and location automations to "Remind me of my leave basket"

## 0.3.0

- [x] iCloud sync of notes, voice notes, categories and bamboo (Settings > iCloud sync; settings stay per device)
- [x] "Show Panda's basket" as a control (Lock Screen, Control Centre, Action Button), Siri phrase and Home Screen widget button, with a basket glyph
- [x] Text and voice note glyphs with a light grey panda behind them
- [x] Info (blue "i") on why the leave basket needs "Always" location, and why it costs no battery or privacy
- [x] Quick capture: settings links and a rendered preview for every spot
- [x] Settings > Panda > News with a one-line summary per version and a link to its PR

## 0.3.1

- [x] Fix: notes added via Share (and Siri / Action Button) now update the widgets' open count, also on the Lock Screen


## 0.3.2

- [x] Fix: the Undo bar after deleting (and other Undo bars) slides away after 5 seconds
- [x] Twinkling stars next to the moon at night (still with Reduce Motion)

## 0.4.0

- [x] All app texts in English, French, German, Spanish (Latin America), Italian, Japanese and Arabic (Levantine, right-to-left)
- [x] Widgets, controls, Siri phrases, notifications, share sheet and permission prompts translated too (iOS String Catalogs)
- [x] News entries in every language
- [ ] Quick capture preview images still show English text
- [ ] Shortcuts button names in the automation guides ("Leaves", "Run Immediately", …) checked against a localised iOS only by memory

## 0.5.0

- [x] References to iOS Settings are blue links (basket sheet, microphone message, leave basket, "Why Always?", Quick capture)
- [x] Each link plays a walkthrough: real screenshots of the Settings app with blue tap pulses, recorded per language (tool/walkthroughs)
- [ ] Re-record the walkthroughs whenever a language is added or iOS renames a Settings screen (lib/l10n/README.md)
- [ ] The simulator's Action Button carousel has fewer pages than an iPhone; the walkthrough says to keep swiping

## 0.7.1: move to os-mas-datos

The repository moves from goosalex to os-mas-datos (Mas Datos GmbH). GitHub redirects the repository's
web and git links, but **not GitHub Pages**: goosalex.github.io/red_panda stops working at the transfer,
so this release (all links now point to os-mas-datos) is merged only after the transfer.

Before the transfer
- [x] os-mas-datos has no repository called red_panda (it would block the transfer)
- [x] No forks, webhooks, deploy keys, Actions secrets or branch protection to carry over
- [x] Links in the app, docs/, appstore/metadata/, tests and tools point to os-mas-datos (this PR)
- [ ] Optional: add the LICENSE now, naming Mas Datos GmbH
- [ ] Don't enter URLs in App Store Connect yet

Transfer
- [ ] goosalex: Settings > General > Danger Zone > Transfer ownership > `os-mas-datos`
- [ ] os-mas-datos: accept the email from GitHub (valid for one day)

After the transfer
- [ ] Access: check that goosalex can still push and merge; otherwise os-mas-datos invites goosalex
      (Settings > Collaborators), or `gh auth login` as os-mas-datos
- [ ] GitHub Pages: Settings > Pages still deploys `main` `/docs`; check https://os-mas-datos.github.io/red_panda/
- [ ] Xcode Cloud: give its GitHub app access to os-mas-datos/red_panda (install it on os-mas-datos) and
      reconnect the repository in App Store Connect > Xcode Cloud > Settings > Repositories
- [ ] Merge this PR; its push to main must start the TestFlight build (proves Xcode Cloud is reconnected)
- [ ] Local checkout: `git remote set-url origin https://github.com/os-mas-datos/red_panda`
- [ ] goosalex never creates a new repository called red_panda: it would break the redirect that older
      builds' News links rely on
- [ ] App Store Connect: privacy, support and marketing URLs from appstore/metadata/

## 0.7.0

- [x] Privacy manifests (PrivacyInfo.xcprivacy) for the app and both extensions: no tracking, no collected data; reasons for UserDefaults (CA92.1) and file dates (C617.1, iCloud sync)
- [x] Settings > Panda > Privacy: what Red Panda does with your data, with links to the policy and the source code
- [x] Privacy policy and support pages in docs/ (GitHub Pages), in all 7 languages
- [x] App Store texts in appstore/metadata/, App Privacy and review answers in appstore/README.md
- [x] App Store screenshots for the 6.9" iPhone and the 13" iPad, per language (tool/screenshots): list, leave basket, voice note, Settings, Privacy
- [ ] Screenshots show no typed note: the simulator keyboard follows the Mac's layout, not the screenshot language
- [x] Turn on GitHub Pages (main, /docs) so the privacy and support links work
- [ ] Fill in App Store Connect from appstore/README.md and submit for review

## 0.6.2

- [x] iOS 26 controls showed no glyph: tool/glyphs/make_glyphs.py wrote a hand-made template that Xcode compiled as template version 0 (Regular-M only, partly bitmaps). It now writes an SF Symbols 6 variable template (Ultralight-S, Regular-S, Black-S, "Template v.6.0"), compiled as interpolatable vector glyphs with hierarchical layers
- [ ] Confirm the glyphs on an iOS 26 iPhone via TestFlight

## 0.6.1

- [x] iOS 26: Lock Screen controls (Text note, Panda's basket) showed no glyph and did nothing. The open-app intents now declare `supportedModes` (`.foreground(.immediate)`), which replaced `openAppWhenRun` in iOS 26
- [x] Confirmed on an iOS 26 iPhone via TestFlight: the buttons work again, but still showed no glyph (fixed in 0.6.2)

## 0.6.0

- [x] Native iPad app (iPhone and iPad device family for the app and its extensions): iPhone point sizes, only Dynamic Type scales text
- [x] Readable column (700 pt, centred) for the notes list, progress header and Settings; lists still scroll from the margins
- [x] No Action Button on iPad: hidden in Quick capture and in the empty-list hint
- [ ] Walkthroughs are recorded on an iPhone; iPad Settings looks different (sidebar)

## 0.5.1

- [x] Walkthroughs for the widgets: Lock Screen (long-press › Customise › Lock Screen › Add Widget › Red Panda) and Home Screen (long-press › Edit › Add Widget › Red Panda), linked from Quick capture › Widgets
