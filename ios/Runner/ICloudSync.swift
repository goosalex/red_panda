import Foundation

/// The native half of iCloud sync (lib/storage/cloud_sync.dart does the
/// merging): finds Red Panda's iCloud Drive folder, asks iCloud to download
/// files that are only placeholders, and pings Dart when files change there.
///
/// The folder lives in the app's own ubiquity container and is not listed
/// in the Files app (no NSUbiquitousContainers entry in Info.plist).
@MainActor
final class ICloudSync {
  static let shared = ICloudSync()
  nonisolated static let containerId = "iCloud.ch.masdatos.redpanda"

  /// Called (debounced) when iCloud changed something in the folder.
  static var onChanged: (() -> Void)?

  private var query: NSMetadataQuery?
  private var observers: [NSObjectProtocol] = []
  private var ping: Task<Void, Never>?

  /// Documents/RedPanda in the container, created if needed, or nil when the
  /// user is signed out of iCloud or iCloud Drive is off for Red Panda.
  func folder() async -> String? {
    let url: URL? = await Task.detached {
      // Apple: may block, never call on the main thread.
      guard
        let container = FileManager.default.url(forUbiquityContainerIdentifier: Self.containerId)
      else { return nil }
      let dir = container.appendingPathComponent("Documents/RedPanda", isDirectory: true)
      do {
        for sub in ["", "notes", "audio"] {
          try FileManager.default.createDirectory(
            at: dir.appendingPathComponent(sub, isDirectory: true),
            withIntermediateDirectories: true)
        }
      } catch {
        return nil
      }
      Self.downloadPlaceholders(in: dir)
      return dir
    }.value
    if url != nil { watch() }
    return url?.path
  }

  func stop() {
    query?.stop()
    query = nil
    observers.forEach(NotificationCenter.default.removeObserver)
    observers = []
  }

  /// Files another device uploaded arrive as placeholders: start the
  /// downloads; Dart syncs them on a later run (cloudChanged).
  nonisolated private static func downloadPlaceholders(in dir: URL) {
    let fm = FileManager.default
    let keys: [URLResourceKey] = [.ubiquitousItemDownloadingStatusKey]
    guard let items = fm.enumerator(at: dir, includingPropertiesForKeys: keys) else { return }
    for case let url as URL in items {
      let status = try? url.resourceValues(forKeys: Set(keys)).ubiquitousItemDownloadingStatus
      let placeholder = url.lastPathComponent.hasPrefix(".") && url.pathExtension == "icloud"
      if placeholder || (status != nil && status != .current) {
        try? fm.startDownloadingUbiquitousItem(at: url)
      }
    }
  }

  /// Watches the folder for uploads from other devices and finished downloads.
  private func watch() {
    guard query == nil else { return }
    let q = NSMetadataQuery()
    q.searchScopes = [NSMetadataQueryUbiquitousDocumentsScope]
    q.predicate = NSPredicate(format: "%K LIKE '*'", NSMetadataItemFSNameKey)
    let center = NotificationCenter.default
    for name in [Notification.Name.NSMetadataQueryDidFinishGathering, .NSMetadataQueryDidUpdate] {
      observers.append(
        center.addObserver(forName: name, object: q, queue: .main) { _ in
          Task { @MainActor in ICloudSync.shared.changed() }
        })
    }
    q.start()
    query = q
  }

  private func changed() {
    ping?.cancel()
    ping = Task {
      try? await Task.sleep(for: .seconds(1))
      guard !Task.isCancelled else { return }
      Self.onChanged?()
    }
  }
}
