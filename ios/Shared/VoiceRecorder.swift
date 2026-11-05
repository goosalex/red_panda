import ActivityKit
import AVFoundation
import Foundation

enum VoiceRecorderError: Error {
  case couldNotStart
}

/// Records AAC/m4a into the App Group audio/ folder. Runs in the app process
/// (AudioRecordingIntent / LiveActivityIntent are executed by the app).
@MainActor
final class VoiceRecorder {
  static let shared = VoiceRecorder()

  private var recorder: AVAudioRecorder?
  private var noteId: String?
  private var startedAt: Date?

  var isRecording: Bool { recorder?.isRecording == true }

  func start() async throws {
    if isRecording { return }
    let id = NoteStore.newId()
    let start = Date()

    // iOS requires a Live Activity while an AudioRecordingIntent records.
    if ActivityAuthorizationInfo().areActivitiesEnabled {
      _ = try? Activity.request(
        attributes: VoiceActivityAttributes(noteId: id),
        content: .init(state: .init(startedAt: start), staleDate: nil))
    }

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
    let r = try AVAudioRecorder(url: url, settings: settings)
    guard r.record() else {
      await endActivities()
      throw VoiceRecorderError.couldNotStart
    }
    recorder = r
    noteId = id
    startedAt = start
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
  }

  private func endActivities() async {
    for activity in Activity<VoiceActivityAttributes>.activities {
      await activity.end(nil, dismissalPolicy: .immediate)
    }
  }
}
