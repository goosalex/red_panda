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
        // Called by Flutter on start/resume; may ask for Speech permission.
        Task { @MainActor in
          result(await Transcriber.transcribePending(askPermission: true))
        }
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
  }
}
