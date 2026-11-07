import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  private let motion = MotionStreamHandler()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Re-open the leave basket's location monitor: a "left the place" event
    // may be why iOS launched us in the background.
    LeaveBasket.shared.start()
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
      case "requestNotificationPermission":
        Task { @MainActor in result(await Reminders.requestPermission()) }
      case "scheduleReminders":
        // {items: [{id, title, dueAt?, remindAt?}] (ISO-8601), intensity,
        //  quietStartHour, quietEndHour}; see lib/platform/reminders.dart.
        let args = call.arguments as? [String: Any] ?? [:]
        let items = Reminders.items(from: args["items"])
        let intensity = (args["intensity"] as? Int) ?? 0
        let quietStart = (args["quietStartHour"] as? Int) ?? 22
        let quietEnd = (args["quietEndHour"] as? Int) ?? 8
        Task { @MainActor in
          await Reminders.schedule(
            items, intensity: intensity, quietStartHour: quietStart, quietEndHour: quietEnd)
          result(nil)
        }
      case "reloadWidgets":
        Reminders.reloadWidgets()
        result(nil)
      case "leaveBasketSync":
        // {titles, radius, onPlace, onWifi, rearmHere}; see lib/platform/leave_basket.dart.
        let args = call.arguments as? [String: Any] ?? [:]
        Task { @MainActor in
          result(
            await LeaveBasket.shared.sync(
              titles: args["titles"] as? [String] ?? [],
              radius: args["radius"] as? Int ?? 50,
              onPlace: args["onPlace"] as? Bool ?? true,
              onWifi: args["onWifi"] as? Bool ?? true,
              rearmHere: args["rearmHere"] as? Bool ?? false))
        }
      case "leaveBasketStatus":
        Task { @MainActor in result(LeaveBasket.shared.status()) }
      case "openAppSettings":
        Task { @MainActor in
          if let url = URL(string: UIApplication.openSettingsURLString) {
            await UIApplication.shared.open(url)
          }
          result(nil)
        }
      case "share":
        // {text}: the system share sheet for one item (swipe action "Share").
        let text = (call.arguments as? [String: Any])?["text"] as? String ?? ""
        Task { @MainActor in
          let scene = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first { $0.activationState == .foregroundActive }
          guard let root = scene?.keyWindow?.rootViewController else {
            result(FlutterError(code: "noWindow", message: nil, details: nil))
            return
          }
          var top = root
          while let presented = top.presentedViewController { top = presented }
          let sheet = UIActivityViewController(activityItems: [text], applicationActivities: nil)
          sheet.popoverPresentationController?.sourceView = top.view
          top.present(sheet, animated: true)
          result(nil)
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
    // Gravity tilt for the mascot's ears (lib/platform/motion.dart).
    FlutterEventChannel(
      name: "red_panda/motion",
      binaryMessenger: engineBridge.applicationRegistrar.messenger()
    ).setStreamHandler(motion)

    // App already running: tell Dart to take the request now.
    ComposeRequest.onRequest = { channel.invokeMethod("compose", arguments: nil) }
    Transcriber.onNotesChanged = { channel.invokeMethod("notesChanged", arguments: nil) }
    VoiceRecorder.onStateChanged = { channel.invokeMethod("recordingChanged", arguments: nil) }
  }
}
