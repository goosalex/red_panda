import SwiftUI
import UIKit
import UniformTypeIdentifiers
import WidgetKit

/// Principal class of the share extension (NSExtensionPrincipalClass, no storyboard):
/// hosts the SwiftUI sheet and finishes the extension request.
final class ShareViewController: UIViewController {
  private let model = ShareModel()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = UIColor(red: 1, green: 0xF4 / 255, blue: 0xEC / 255, alpha: 1)

    model.finish = { [weak self] in
      self?.extensionContext?.completeRequest(returningItems: nil)
    }
    model.cancel = { [weak self] in
      self?.extensionContext?.cancelRequest(
        withError: NSError(domain: NSCocoaErrorDomain, code: NSUserCancelledError))
    }

    let host = UIHostingController(rootView: ShareView(model: model))
    host.view.backgroundColor = .clear
    addChild(host)
    host.view.frame = view.bounds
    host.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(host.view)
    host.didMove(toParent: self)

    let inputItems = extensionContext?.inputItems.compactMap { $0 as? NSExtensionItem } ?? []
    Task { await model.load(from: inputItems) }
  }
}

/// One parsed to-do in the sheet.
struct ShareEntry: Identifiable {
  let id = UUID()
  var text: String
  var included = true
}

@MainActor
final class ShareModel: ObservableObject {
  enum Phase { case loading, ready, empty, added }

  @Published var phase: Phase = .loading
  @Published var entries: [ShareEntry] = []
  @Published var leaveBasket = false
  @Published var error: String?

  var finish: () -> Void = {}
  var cancel: () -> Void = {}

  var selectedCount: Int {
    entries.filter { $0.included && !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }.count
  }

  func load(from items: [NSExtensionItem]) async {
    let texts = await SharedContent.items(from: items)
    entries = texts.map { ShareEntry(text: $0) }
    phase = entries.isEmpty ? .empty : .ready
  }

  func add() {
    let texts = entries.filter(\.included)
      .map { $0.text.trimmingCharacters(in: .whitespacesAndNewlines) }
      .filter { !$0.isEmpty }
    guard !texts.isEmpty else { return }
    // Unranked notes are listed newest first: the first shared item gets the newest
    // timestamp so the list shows the shared order. Whole seconds, because
    // NoteStore.write encodes dates without fractional seconds.
    let now = Date()
    var saved: [StoredNote] = []
    do {
      for (i, text) in texts.enumerated() {
        var note = StoredNote(
          id: NoteStore.newId(), createdAt: now.addingTimeInterval(-Double(i)),
          kind: "text", text: text)
        if leaveBasket { note.leaveBasket = true }
        try NoteStore.write(note)
        saved.append(note)
      }
    } catch {
      self.error = "Couldn't save: \(error.localizedDescription)"
      return
    }
    // Cache first: the reload may only run once the iPhone is locked again.
    WidgetCache.didSave(saved)
    WidgetCenter.shared.reloadAllTimelines()
    phase = .added
    Task {
      try? await Task.sleep(for: .milliseconds(600))
      finish()
    }
  }
}

/// Reads the shared content: plain text first, then other text (rich text, HTML),
/// then a web URL (page title + URL as one item). Main actor: rich-text/HTML import
/// must run on the main thread.
@MainActor
enum SharedContent {
  static func items(from extensionItems: [NSExtensionItem]) async -> [String] {
    var links: [(URL, NSExtensionItem)] = []
    var plainLinks: [URL] = []

    for type in [UTType.plainText, UTType.text] {
      for item in extensionItems {
        for provider in item.attachments ?? [] where provider.hasItemConformingToTypeIdentifier(type.identifier) {
          guard let text = await loadText(provider, type: type) else { continue }
          // Some apps share a page as plain text holding just its URL.
          if let url = singleWebURL(text) { plainLinks.append(url); continue }
          let items = SharedText.items(from: text)
          if !items.isEmpty { return items }
        }
      }
    }

    for item in extensionItems {
      for provider in item.attachments ?? [] where provider.hasItemConformingToTypeIdentifier(UTType.url.identifier) {
        if let url = await loadURL(provider), !url.isFileURL { links.append((url, item)) }
      }
    }
    if let (url, item) = links.first {
      return [linkItem(url, title: title(of: item))]
    }
    if let url = plainLinks.first {
      return [linkItem(url, title: extensionItems.lazy.compactMap(title(of:)).first)]
    }
    // Last resort: text the host put on the item itself.
    for item in extensionItems {
      if let text = item.attributedContentText?.string {
        let items = SharedText.items(from: text)
        if !items.isEmpty { return items }
      }
    }
    return []
  }

  private static func linkItem(_ url: URL, title: String?) -> String {
    let link = url.absoluteString
    guard let title, !title.isEmpty, title != link else { return link }
    let name = String(SharedText.items(from: title).joined(separator: " ").prefix(300))
    return name.isEmpty ? link : "\(name) \(link)"
  }

  private static func title(of item: NSExtensionItem) -> String? {
    for s in [item.attributedContentText?.string, item.attributedTitle?.string] {
      if let t = s?.trimmingCharacters(in: .whitespacesAndNewlines), !t.isEmpty, singleWebURL(t) == nil {
        return t
      }
    }
    return nil
  }

  private static func singleWebURL(_ text: String) -> URL? {
    let t = text.trimmingCharacters(in: .whitespacesAndNewlines)
    guard !t.contains(where: { $0.isWhitespace }), let url = URL(string: t),
          let scheme = url.scheme?.lowercased(), ["http", "https"].contains(scheme), url.host != nil
    else { return nil }
    return url
  }

  /// A loaded attachment, converted to Sendable values in the provider's callback.
  private enum Loaded: Sendable {
    case string(String)
    case data(Data)
    case url(URL)
  }

  private static func load(_ provider: NSItemProvider, type: UTType) async -> Loaded? {
    await withCheckedContinuation { continuation in
      provider.loadItem(forTypeIdentifier: type.identifier, options: nil) { value, _ in
        let loaded: Loaded? = switch value {
        case let s as String: .string(s)
        case let a as NSAttributedString: .string(a.string)
        case let url as URL: .url(url)
        case let data as Data: .data(data)
        default: nil
        }
        continuation.resume(returning: loaded)
      }
    }
  }

  private static func loadText(_ provider: NSItemProvider, type: UTType) async -> String? {
    switch await load(provider, type: type) {
    case .string(let s): return s
    case .url(let url) where url.isFileURL: return try? String(contentsOf: url, encoding: .utf8)
    case .data(let data):
      // Rich text / HTML (main thread, which this enum is isolated to).
      if let a = try? NSAttributedString(data: data, options: [:], documentAttributes: nil) {
        return a.string
      }
      return String(data: data, encoding: .utf8)
    default: return nil
    }
  }

  private static func loadURL(_ provider: NSItemProvider) async -> URL? {
    switch await load(provider, type: .url) {
    case .url(let url): return url
    case .string(let s): return URL(string: s)
    case .data(let data): return URL(dataRepresentation: data, relativeTo: nil)
    case nil: return nil
    }
  }
}
