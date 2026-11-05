import ActivityKit
import AVFoundation
import Foundation
import Speech

enum VoiceRecorderError: Error, CustomLocalizedStringResourceConvertible {
  case couldNotStart
  case noMicrophonePermission
  case noLiveActivity

  var localizedStringResource: LocalizedStringResource {
    switch self {
    case .couldNotStart: return "Red Panda couldn't start recording."
    case .noMicrophonePermission: return "Open Red Panda once to allow the microphone."
    case .noLiveActivity: return "Allow Live Activities for Red Panda to record voice notes."
    }
  }
}

/// Microphone and Speech permission prompts only show while the app is in
/// front, so the app asks for both when it opens (see AppDelegate).
@MainActor
enum VoicePermissions {
  static func request() async {
    if AVAudioApplication.shared.recordPermission == .undetermined {
      _ = await AVAudioApplication.requestRecordPermission()
    }
  }
}

/// Records AAC/m4a into the App Group audio/ folder. Runs in the app process
/// (StartVoiceNoteIntent / StopVoiceNoteIntent are LiveActivityIntents).
@MainActor
final class VoiceRecorder {
  static let shared = VoiceRecorder()

  /// Set by the app to tell Flutter that recording started or stopped.
  static var onStateChanged: (() -> Void)?

  private var recorder: AVAudioRecorder?
  private var noteId: String?
  private(set) var startedAt: Date?

  var isRecording: Bool { recorder?.isRecording == true }

  /// [fromApp]: started with the app's mic button, so the app is in front:
  /// it may ask for the microphone, and the Live Activity is optional (it only
  /// shows the recording once you leave the app). From the control or Siri
  /// (AudioRecordingIntent) iOS requires the Live Activity.
  func start(fromApp: Bool = false) async throws {
    if isRecording { return }
    let id = NoteStore.newId()
    let start = Date()

    if fromApp { await VoicePermissions.request() }
    guard AVAudioApplication.shared.recordPermission == .granted else {
      throw VoiceRecorderError.noMicrophonePermission
    }
    // iOS kills an AudioRecordingIntent that records without a Live
    // Activity: start it before the microphone.
    let activity: Activity<VoiceActivityAttributes>? =
      ActivityAuthorizationInfo().areActivitiesEnabled
      ? try? Activity.request(
        attributes: VoiceActivityAttributes(noteId: id),
        content: .init(state: .init(startedAt: start), staleDate: nil))
      : nil
    if activity == nil && !fromApp {
      throw VoiceRecorderError.noLiveActivity
    }

    let r: AVAudioRecorder
    do {
      let session = AVAudioSession.sharedInstance()
      try session.setCategory(.record, mode: .default)
      try session.setActive(true)

      try NoteStore.ensureDirectories()
      let url = NoteStore.audioDir.appendingPathComponent("\(id).m4a")
      let settings: [String: Any] = [
        AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
        AVSampleRateKey: 44_100,
        AVNumberOfChannelsKey: 1,
        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
      ]
      r = try AVAudioRecorder(url: url, settings: settings)
      guard r.record() else { throw VoiceRecorderError.couldNotStart }
    } catch {
      try? AVAudioSession.sharedInstance().setActive(false)
      await endActivities()
      throw error
    }
    recorder = r
    noteId = id
    startedAt = start
    Self.onStateChanged?()
  }

  func stop() async throws {
    guard let r = recorder, let id = noteId else {
      await endActivities()
      return
    }
    let duration = r.currentTime
    r.stop()
    try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)

    let file = "\(id).m4a"
    try? FileManager.default.setAttributes(
      [.protectionKey: NoteStore.protection],
      ofItemAtPath: NoteStore.audioDir.appendingPathComponent(file).path)
    try NoteStore.write(
      StoredNote(
        id: id, createdAt: startedAt ?? Date(), kind: "voice",
        audioFile: file, durationSeconds: duration))

    recorder = nil
    noteId = nil
    startedAt = nil
    await endActivities()
    Self.onStateChanged?()

    // Turn the recording into text now if we may; if the phone is locked or
    // permission is still unknown, the app catches up the next time it opens.
    await Transcriber.transcribePending(askPermission: false)
  }

  private func endActivities() async {
    for activity in Activity<VoiceActivityAttributes>.activities {
      await activity.end(nil, dismissalPolicy: .immediate)
    }
  }
}

/// Speech to text for voice notes, with Apple's Speech framework: on the
/// device when the language supports it, otherwise Apple's speech servers.
/// A voice note with text == nil is waiting; "" means no words were heard.
@MainActor
enum Transcriber {
  /// Set by the app to tell Flutter to reload the list.
  static var onNotesChanged: (() -> Void)?
  private static var running = false

  /// Transcribes every waiting voice note. Returns how many were updated.
  /// Only asks for permission when [askPermission] (the app is in front).
  @discardableResult
  static func transcribePending(askPermission: Bool) async -> Int {
    if running { return 0 }
    running = true
    defer { running = false }
    guard await authorized(ask: askPermission) else { return 0 }

    var updated = 0
    for note in NoteStore.readAll() where note.kind == "voice" && note.text == nil {
      guard let file = note.audioFile else { continue }
      let url = NoteStore.audioDir.appendingPathComponent(file)
      guard FileManager.default.fileExists(atPath: url.path) else { continue }
      let text: String
      do {
        text = try await transcribe(url).trimmingCharacters(in: .whitespacesAndNewlines)
      } catch let error as NSError where error.domain == "kAFAssistantErrorDomain" && error.code == 1110 {
        text = ""  // no speech detected
      } catch {
        NSLog("RedPanda transcription failed for %@: %@", file, String(describing: error))
        continue  // locked, offline, recognizer busy: try again next time
      }
      // Re-read so a tick made in the app meanwhile isn't lost.
      var latest = NoteStore.read(id: note.id) ?? note
      latest.text = text
      if (try? NoteStore.write(latest)) != nil { updated += 1 }
    }
    if updated > 0 { onNotesChanged?() }
    return updated
  }

  private static func authorized(ask: Bool) async -> Bool {
    switch SFSpeechRecognizer.authorizationStatus() {
    case .authorized:
      return true
    case .notDetermined where ask:
      return await withCheckedContinuation { c in
        SFSpeechRecognizer.requestAuthorization { c.resume(returning: $0 == .authorized) }
      }
    default:
      return false
    }
  }

  private nonisolated static func transcribe(_ url: URL) async throws -> String {
    guard let recognizer = SFSpeechRecognizer(), recognizer.isAvailable else {
      throw TranscriberError.unavailable
    }
    let request = SFSpeechURLRecognitionRequest(url: url)
    request.shouldReportPartialResults = false
    request.addsPunctuation = true
    if recognizer.supportsOnDeviceRecognition { request.requiresOnDeviceRecognition = true }

    return try await withCheckedThrowingContinuation { c in
      var finished = false  // the handler can fire again after the final result
      _ = recognizer.recognitionTask(with: request) { result, error in
        guard !finished else { return }
        if let result, result.isFinal {
          finished = true
          c.resume(returning: result.bestTranscription.formattedString)
        } else if let error {
          finished = true
          c.resume(throwing: error)
        }
      }
    }
  }
}

enum TranscriberError: Error {
  case unavailable
}
