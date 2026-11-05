import ActivityKit
import AppIntents
import SwiftUI
import WidgetKit

struct VoiceLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: VoiceActivityAttributes.self) { context in
      HStack(spacing: 12) {
        Image(systemName: "mic.fill").foregroundStyle(.red)
        Text("Red Panda is listening")
        Spacer()
        ElapsedText(start: context.state.startedAt)
        Button(intent: StopVoiceNoteIntent()) {
          Label("Stop", systemImage: "stop.fill")
        }
        .tint(.red)
      }
      .padding()
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Image(systemName: "mic.fill").foregroundStyle(.red)
        }
        DynamicIslandExpandedRegion(.trailing) {
          ElapsedText(start: context.state.startedAt)
        }
        DynamicIslandExpandedRegion(.bottom) {
          Button(intent: StopVoiceNoteIntent()) {
            Label("Stop recording", systemImage: "stop.fill")
          }
          .tint(.red)
        }
      } compactLeading: {
        Image(systemName: "mic.fill").foregroundStyle(.red)
      } compactTrailing: {
        ElapsedText(start: context.state.startedAt).frame(maxWidth: 44)
      } minimal: {
        Image(systemName: "mic.fill").foregroundStyle(.red)
      }
    }
  }
}

private struct ElapsedText: View {
  let start: Date
  var body: some View {
    Text(timerInterval: start...Date.distantFuture, countsDown: false)
      .monospacedDigit()
  }
}
