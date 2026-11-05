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

/// Text note control: opens the app on the compose sheet. Controls cannot ask
/// for parameter values, so CaptureTextNoteIntent fails there (error 2010);
/// it stays for Siri, Shortcuts and the Action Button, which can prompt.
/// Compiled into the app and the extension so the system runs it in the app.
struct OpenComposeIntent: AppIntent {
  static let title: LocalizedStringResource = "New text note"
  static let description = IntentDescription("Open Red Panda to write a text note.")
  static let openAppWhenRun: Bool = true
  static let isDiscoverable: Bool = false

  init() {}

  @MainActor
  func perform() async throws -> some IntentResult {
    ComposeRequest.request()
    return .result()
  }
}

/// Hand-off from OpenComposeIntent to the Flutter UI (see AppDelegate).
/// The flag covers a cold start, where the intent can run before Flutter is up;
/// Dart takes it on start/resume and whenever onRequest pings it.
@MainActor
enum ComposeRequest {
  private static var pending = false
  static var onRequest: (() -> Void)?

  static func request() {
    pending = true
    onRequest?()
  }

  /// Returns whether a compose request was waiting, and clears it.
  static func take() -> Bool {
    defer { pending = false }
    return pending
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
