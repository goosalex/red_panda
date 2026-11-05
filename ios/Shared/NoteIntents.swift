import AppIntents
import Foundation

/// Text note: system prompts for the text (type or dictate), works while locked.
struct CaptureTextNoteIntent: AppIntent {
  static let title: LocalizedStringResource = "Text note"
  static let description = IntentDescription("Capture a quick text note with Red Panda.")
  static let authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
  static let openAppWhenRun: Bool = false

  @Parameter(title: "Note", requestValueDialog: "What's the note?")
  var text: String

  init() {}

  func perform() async throws -> some IntentResult & ProvidesDialog {
    try NoteStore.saveText(text)
    return .result(dialog: "Saved. The panda is happy.")
  }
}

/// Voice note: starts recording + Live Activity; stop from the Live Activity.
struct StartVoiceNoteIntent: AudioRecordingIntent {
  static let title: LocalizedStringResource = "Voice note"
  static let description = IntentDescription("Record a quick voice note with Red Panda.")
  static let authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
  static let openAppWhenRun: Bool = false

  init() {}

  @MainActor
  func perform() async throws -> some IntentResult {
    try await VoiceRecorder.shared.start()
    return .result()
  }
}

struct StopVoiceNoteIntent: LiveActivityIntent {
  static let title: LocalizedStringResource = "Stop voice note"
  static let authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed
  static let isDiscoverable: Bool = false

  init() {}

  @MainActor
  func perform() async throws -> some IntentResult {
    try await VoiceRecorder.shared.stop()
    return .result()
  }
}
