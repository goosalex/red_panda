import AppIntents
import Foundation
import WidgetKit

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
    let note = try NoteStore.saveText(text)
    WidgetCache.didSave([note])
    WidgetCenter.shared.reloadAllTimelines()
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
  #if compiler(>=6.2)
  /// iOS 26 replaces openAppWhenRun, which fails when the intent runs in the
  /// controls extension (on iOS 26 the Lock Screen controls showed no glyph
  /// and did nothing). Brings the app forward right away instead.
  @available(iOS 26.0, *)
  static var supportedModes: IntentModes { .foreground(.immediate) }
  #endif
  static let isDiscoverable: Bool = false

  init() {}

  @MainActor
  func perform() async throws -> some IntentResult {
    ComposeRequest.request()
    return .result()
  }
}

/// Panda's basket control and widget button: opens the app showing only the
/// leave basket's items. Compiled into the app and the extension, like
/// OpenComposeIntent.
struct OpenBasketIntent: AppIntent {
  static let title: LocalizedStringResource = "Show Panda's basket"
  static let description = IntentDescription("Open Red Panda on your leave basket.")
  static let openAppWhenRun: Bool = true
  #if compiler(>=6.2)
  /// iOS 26 replaces openAppWhenRun, which fails when the intent runs in the
  /// controls extension (on iOS 26 the Lock Screen controls showed no glyph
  /// and did nothing). Brings the app forward right away instead.
  @available(iOS 26.0, *)
  static var supportedModes: IntentModes { .foreground(.immediate) }
  #endif

  init() {}

  @MainActor
  func perform() async throws -> some IntentResult {
    ComposeRequest.requestBasket()
    return .result()
  }
}

/// Hand-off from OpenComposeIntent / OpenBasketIntent to the Flutter UI
/// (see AppDelegate).
/// The flag covers a cold start, where the intent can run before Flutter is up;
/// Dart takes it on start/resume and whenever onRequest pings it.
@MainActor
enum ComposeRequest {
  private static var pending = false
  private static var pendingBasket = false
  static var onRequest: (() -> Void)?

  static func request() {
    pending = true
    onRequest?()
  }

  static func requestBasket() {
    pendingBasket = true
    onRequest?()
  }

  /// Returns whether a basket request was waiting, and clears it.
  static func takeBasket() -> Bool {
    defer { pendingBasket = false }
    return pendingBasket
  }

  /// Returns whether a compose request was waiting, and clears it.
  static func take() -> Bool {
    defer { pending = false }
    return pending
  }
}

/// Voice note: starts recording + Live Activity; stop from the Live Activity.
/// LiveActivityIntent makes the system run perform() in the app's process:
/// in the controls extension it can't start the Live Activity iOS requires
/// while recording, and the system kills it.
struct StartVoiceNoteIntent: AudioRecordingIntent, LiveActivityIntent {
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
