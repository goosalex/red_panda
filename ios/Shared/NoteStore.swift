import Foundation

/// Shared between the app (Runner) and the RedPandaControls extension.
/// JSON schema must match lib/models/note.dart.
enum AppGroup {
  static let identifier = "group.ch.masdatos.redpanda"

  static var containerURL: URL {
    if let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: identifier) {
      return url
    }
    // Missing entitlement (e.g. unsigned simulator build): fall back to Documents.
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
  }
}

struct StoredNote: Codable {
  var id: String
  var createdAt: Date
  var kind: String  // "text" | "voice"
  var text: String?
  var audioFile: String?
  var durationSeconds: Double?
  var doneAt: Date?
}

enum NoteStore {
  static var notesDir: URL { AppGroup.containerURL.appendingPathComponent("notes", isDirectory: true) }
  static var audioDir: URL { AppGroup.containerURL.appendingPathComponent("audio", isDirectory: true) }

  /// Readable only while unlocked, but files opened/created while unlocked-or-locked
  /// stay writable: lets intents save from the Lock Screen.
  static let protection = FileProtectionType.completeUnlessOpen

  static func ensureDirectories() throws {
    for dir in [notesDir, audioDir] {
      try FileManager.default.createDirectory(
        at: dir, withIntermediateDirectories: true,
        attributes: [.protectionKey: protection])
    }
  }

  static func newId() -> String {
    let ms = Int(Date().timeIntervalSince1970 * 1000)
    let hex = (0..<8).map { _ in String(format: "%02x", UInt8.random(in: 0...255)) }.joined()
    return "\(ms)-\(hex)"
  }

  static func write(_ note: StoredNote) throws {
    try ensureDirectories()
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let data = try encoder.encode(note)
    let url = notesDir.appendingPathComponent("\(note.id).json")
    try data.write(to: url, options: [.atomic, .completeFileProtectionUnlessOpen])
  }

  static func read(id: String) -> StoredNote? {
    decode(notesDir.appendingPathComponent("\(id).json"))
  }

  static func readAll() -> [StoredNote] {
    let files = (try? FileManager.default.contentsOfDirectory(
      at: notesDir, includingPropertiesForKeys: nil)) ?? []
    return files.filter { $0.pathExtension == "json" }.compactMap(decode)
      .sorted { $0.createdAt < $1.createdAt }
  }

  /// Dart writes dates with fractional seconds, Swift without: accept both.
  private static func decode(_ url: URL) -> StoredNote? {
    guard let data = try? Data(contentsOf: url) else { return nil }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .custom { d in
      let s = try d.singleValueContainer().decode(String.self)
      let fractional = ISO8601DateFormatter()
      fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
      if let date = fractional.date(from: s) ?? ISO8601DateFormatter().date(from: s) { return date }
      throw DecodingError.dataCorrupted(.init(codingPath: d.codingPath, debugDescription: "Bad date \(s)"))
    }
    return try? decoder.decode(StoredNote.self, from: data)
  }

  @discardableResult
  static func saveText(_ text: String) throws -> StoredNote {
    let note = StoredNote(id: newId(), createdAt: Date(), kind: "text", text: text)
    try write(note)
    return note
  }
}
