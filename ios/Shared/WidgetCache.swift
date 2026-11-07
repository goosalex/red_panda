import Foundation

/// Notes files are only readable while the phone is unlocked
/// (completeUnlessOpen), but Lock Screen widgets often refresh while locked.
/// Whoever reads the notes successfully (the app on reloadWidgets, or the
/// widget itself) keeps a copy here that stays readable after the first unlock.
enum WidgetCache {
  static var url: URL { AppGroup.containerURL.appendingPathComponent("widget_cache.json") }

  /// Notes for the widget: live when readable, else the last good copy.
  static func notes() -> [StoredNote] {
    let files = ((try? FileManager.default.contentsOfDirectory(
      at: NoteStore.notesDir, includingPropertiesForKeys: nil)) ?? [])
      .filter { $0.pathExtension == "json" }
    let live = NoteStore.readAll()
    if live.count == files.count {
      save(live)
      return live
    }
    // Some files couldn't be read (locked): prefer the cache.
    return load() ?? live
  }

  /// Rewrites the cache from the live notes (called by the app).
  static func refresh() {
    _ = notes()
  }

  private static func save(_ notes: [StoredNote]) {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    guard let data = try? encoder.encode(notes) else { return }
    try? data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
  }

  private static func load() -> [StoredNote]? {
    guard let data = try? Data(contentsOf: url) else { return nil }
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return try? decoder.decode([StoredNote].self, from: data)
  }
}
