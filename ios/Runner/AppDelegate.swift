import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

    // Hands the shared App Group folder to Dart (lib/storage/note_store.dart).
    let channel = FlutterMethodChannel(
      name: "red_panda/app_group",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
    channel.setMethodCallHandler { call, result in
      switch call.method {
      case "takeCompose":
        // Set by the Text note control (OpenComposeIntent).
        result(ComposeRequest.take())
      case "transcribePending":
        // Called by Flutter on start/resume; asks for the microphone and
        // Speech permissions the first time (prompts need the app in front).
        Task { @MainActor in
          await VoicePermissions.request()
          result(await Transcriber.transcribePending(askPermission: true))
        }
      case "startRecording":
        // The app's mic button. Errors: "noMicrophonePermission", "failed".
        Task { @MainActor in
          do {
            try await VoiceRecorder.shared.start(fromApp: true)
            result(nil)
          } catch VoiceRecorderError.noMicrophonePermission {
            result(FlutterError(code: "noMicrophonePermission", message: nil, details: nil))
          } catch {
            result(FlutterError(code: "failed", message: String(describing: error), details: nil))
          }
        }
      case "stopRecording":
        // Saves the voice note; returns once it is transcribed (or skipped).
        Task { @MainActor in
          do {
            try await VoiceRecorder.shared.stop()
            result(nil)
          } catch {
            result(FlutterError(code: "failed", message: String(describing: error), details: nil))
          }
        }
      case "recordingStartedAt":
        // Milliseconds since 1970 while recording (also from the control), else nil.
        let recorder = VoiceRecorder.shared
        result(recorder.isRecording ? recorder.startedAt.map { Int($0.timeIntervalSince1970 * 1000) } : nil)
      case "containerPath":
        do {
          try NoteStore.ensureDirectories()
          result(AppGroup.containerURL.path)
        } catch {
          result(FlutterError(code: "io", message: error.localizedDescription, details: nil))
        }
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    // App already running: tell Dart to take the request now.
    ComposeRequest.onRequest = { channel.invokeMethod("compose", arguments: nil) }
    Transcriber.onNotesChanged = { channel.invokeMethod("notesChanged", arguments: nil) }
    VoiceRecorder.onStateChanged = { channel.invokeMethod("recordingChanged", arguments: nil) }
  }
}
