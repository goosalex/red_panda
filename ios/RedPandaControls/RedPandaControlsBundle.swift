import SwiftUI
import WidgetKit

@main
struct RedPandaControlsBundle: WidgetBundle {
  var body: some Widget {
    TextNoteControl()
    VoiceNoteControl()
    VoiceLiveActivity()
  }
}
