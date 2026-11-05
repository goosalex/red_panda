import ActivityKit
import Foundation

/// Live Activity shown while a voice note is recording (required by iOS for
/// AudioRecordingIntent). UI lives in RedPandaControls/VoiceLiveActivity.swift.
struct VoiceActivityAttributes: ActivityAttributes {
  struct ContentState: Codable, Hashable {
    var startedAt: Date
  }

  var noteId: String
}
