import AppIntents
import SwiftUI
import WidgetKit

// Lock Screen / Control Centre / Action Button controls (iOS 18).
// Glyphs: custom symbols in Assets.xcassets (tool/glyphs/make_glyphs.py),
// each with a small panda behind it so they don't pass for system controls.

struct TextNoteControl: ControlWidget {
  var body: some ControlWidgetConfiguration {
    StaticControlConfiguration(kind: "ch.masdatos.redpanda.control.text") {
      // Opens the app: controls can't prompt for the text (see OpenComposeIntent).
      ControlWidgetButton(action: OpenComposeIntent()) {
        Label("Text note", image: "redpanda.note")
      }
    }
    .displayName("Text note")
    .description("Open Red Panda to write a quick note.")
  }
}

struct VoiceNoteControl: ControlWidget {
  var body: some ControlWidgetConfiguration {
    StaticControlConfiguration(kind: "ch.masdatos.redpanda.control.voice") {
      ControlWidgetButton(action: StartVoiceNoteIntent()) {
        Label("Voice note", image: "redpanda.voice")
      }
    }
    .displayName("Voice note")
    .description("Record a quick voice note.")
  }
}

struct BasketControl: ControlWidget {
  var body: some ControlWidgetConfiguration {
    StaticControlConfiguration(kind: "ch.masdatos.redpanda.control.basket") {
      ControlWidgetButton(action: OpenBasketIntent()) {
        Label("Panda's basket", image: "redpanda.basket")
      }
    }
    .displayName("Show Panda's basket")
    .description("Open Red Panda on your leave basket.")
  }
}
