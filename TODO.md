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
