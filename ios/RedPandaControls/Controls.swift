import AppIntents
import SwiftUI
import WidgetKit

/// Lock Screen / Control Center / Action Button controls (iOS 18).
struct TextNoteControl: ControlWidget {
  var body: some ControlWidgetConfiguration {
    StaticControlConfiguration(kind: "ch.masdatos.redpanda.control.text") {
      // Opens the app: controls can't prompt for the text (see OpenComposeIntent).
      ControlWidgetButton(action: OpenComposeIntent()) {
        Label("Text note", systemImage: "square.and.pencil")
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
        Label("Voice note", systemImage: "mic.fill")
      }
    }
    .displayName("Voice note")
    .description("Record a quick voice note.")
  }
}
