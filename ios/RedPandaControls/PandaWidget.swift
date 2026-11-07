import AppIntents
import SwiftUI
import UIKit
import WidgetKit

// Lock Screen (inline above the clock, rectangular / circular below it) and
// Home Screen / StandBy widget: the panda's mood plus what is due next.
// Reloaded by the app via Reminders.reloadWidgets(). The Home Screen sizes
// carry quick actions: Panda's basket (small), plus text and voice note
// (medium).

enum PandaMood {
  case sleeping, curious, excited, sad

  var assetName: String {
    switch self {
    case .sleeping: return "PandaSleeping"
    case .curious: return "PandaCurious"
    case .excited: return "PandaExcited"
    case .sad: return "PandaSad"
    }
  }

  var headline: String {
    switch self {
    case .sleeping: return "The panda is napping"
    case .curious: return "The panda is curious"
    case .excited: return "The panda is thrilled!"
    case .sad: return "The panda is sad"
    }
  }

  var symbol: String {
    switch self {
    case .sleeping: return "moon.zzz.fill"
    case .curious: return "pawprint.fill"
    case .excited: return "sparkles"
    case .sad: return "cloud.rain.fill"
    }
  }
}

struct PandaItem: Hashable {
  let title: String
  let dueAt: Date?
  /// Calendar days until the deadline (0 today, negative overdue).
  let daysLeft: Int?
  let overdue: Bool

  var dueLabel: String? {
    guard let d = daysLeft else { return nil }
    switch d {
    case ..<0: return "\(-d) d overdue"
    case 0: return overdue ? "overdue" : "today"
    case 1: return "tomorrow"
    default: return "in \(d) d"
    }
  }
}

struct PandaEntry: TimelineEntry {
  let date: Date
  let mood: PandaMood
  let openCount: Int
  let overdueCount: Int
  let dueTodayCount: Int
  let doneTodayCount: Int
  /// Sorted: overdue first, then by deadline, rank, newest.
  let top: [PandaItem]

  var next: PandaItem? { top.first { $0.dueAt != nil } ?? top.first }

  var countsLine: String {
    if openCount == 0 { return doneTodayCount > 0 ? "All done today!" : "Nothing to do" }
    var s = "\(openCount) open"
    if overdueCount > 0 { s += " · \(overdueCount) overdue" }
    else if dueTodayCount > 0 { s += " · \(dueTodayCount) today" }
    return s
  }

  var inlineLine: String {
    if overdueCount > 0 { return "The panda is sad: \(overdueCount) overdue" }
    if dueTodayCount > 0 { return "🐾 \(dueTodayCount) due today" }
    if openCount > 0 { return "🐾 \(openCount) open" }
    return doneTodayCount > 0 ? "🐾 All done, happy panda" : "🐾 All clear"
  }

  static let placeholder = PandaEntry(
    date: Date(), mood: .curious, openCount: 3, overdueCount: 0, dueTodayCount: 1,
    doneTodayCount: 0,
    top: [
      PandaItem(title: "Buy bamboo", dueAt: Date(), daysLeft: 0, overdue: false),
      PandaItem(title: "Call Grandma", dueAt: nil, daysLeft: nil, overdue: false),
    ])

  static func make(notes: [StoredNote], at now: Date, calendar cal: Calendar = .current)
    -> PandaEntry
  {
    let today = cal.startOfDay(for: now)
    let open = notes.filter { n in
      n.doneAt == nil && !(n.snoozedUntil.map { $0 > now } ?? false)
    }
    let doneToday = notes.filter { n in n.doneAt.map { cal.isDate($0, inSameDayAs: now) } ?? false }

    func days(_ d: Date) -> Int {
      cal.dateComponents([.day], from: today, to: cal.startOfDay(for: d)).day ?? 0
    }
    let sorted = open.sorted { a, b in
      let ao = a.dueAt.map { $0 < now } ?? false
      let bo = b.dueAt.map { $0 < now } ?? false
      if ao != bo { return ao }
      switch (a.dueAt, b.dueAt) {
      case let (x?, y?) where x != y: return x < y
      case (.some, nil): return true
      case (nil, .some): return false
      default: break
      }
      switch (a.rank, b.rank) {
      case let (x?, y?) where x != y: return x < y
      case (.some, nil): return true
      case (nil, .some): return false
      default: break
      }
      return a.createdAt > b.createdAt
    }
    let items = sorted.map { n in
      PandaItem(
        title: title(of: n), dueAt: n.dueAt, daysLeft: n.dueAt.map(days),
        overdue: n.dueAt.map { $0 < now } ?? false)
    }
    let overdue = items.filter(\.overdue).count
    let dueToday = items.filter { !$0.overdue && $0.daysLeft == 0 }.count
    let dueSoon = items.contains { !$0.overdue && ($0.daysLeft ?? 99) <= 1 }

    let mood: PandaMood
    if overdue > 0 { mood = .sad }
    else if !doneToday.isEmpty { mood = .excited }
    else if dueSoon { mood = .curious }
    else { mood = .sleeping }

    return PandaEntry(
      date: now, mood: mood, openCount: items.count, overdueCount: overdue,
      dueTodayCount: dueToday, doneTodayCount: doneToday.count, top: Array(items.prefix(3)))
  }

  /// Same as Note.title in lib/models/note.dart.
  static func title(of n: StoredNote) -> String {
    let words = (n.text ?? "").trimmingCharacters(in: .whitespacesAndNewlines)
    if n.kind == "text" || !words.isEmpty { return words.isEmpty ? "Untitled note" : words }
    return "Voice note"
  }
}

struct PandaProvider: TimelineProvider {
  func placeholder(in context: Context) -> PandaEntry { .placeholder }

  func getSnapshot(in context: Context, completion: @escaping (PandaEntry) -> Void) {
    if context.isPreview && WidgetCache.notes().isEmpty {
      completion(.placeholder)
    } else {
      completion(PandaEntry.make(notes: WidgetCache.notes(), at: Date()))
    }
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<PandaEntry>) -> Void) {
    let notes = WidgetCache.notes()
    let now = Date()
    let cal = Calendar.current
    var dates: Set<Date> = [now]
    if let midnight = cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now)) {
      dates.insert(midnight)
    }
    // When the next deadline passes (mood turns sad) and the next snooze ends.
    let upcoming = notes.filter { $0.doneAt == nil }
      .flatMap { [$0.dueAt, $0.snoozedUntil] }
      .compactMap { $0 }
      .filter { $0 > now }
    if let next = upcoming.min() { dates.insert(next.addingTimeInterval(1)) }

    let entries = dates.sorted().map { PandaEntry.make(notes: notes, at: $0) }
    let refresh = now.addingTimeInterval(3600)
    completion(Timeline(entries: entries, policy: .after(refresh)))
  }
}

struct PandaWidget: Widget {
  static let kind = "ch.masdatos.redpanda.widget.panda"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: Self.kind, provider: PandaProvider()) { entry in
      PandaWidgetView(entry: entry)
    }
    .configurationDisplayName("Red Panda")
    .description("How the panda feels about your to-dos, and what's due next.")
    .supportedFamilies([
      .accessoryInline, .accessoryRectangular, .accessoryCircular, .systemSmall, .systemMedium,
    ])
  }
}

// MARK: - Views

private let pandaRed = Color(red: 0.80, green: 0.33, blue: 0.16)
private let cream = Color(red: 1.0, green: 0.96, blue: 0.90)

struct PandaWidgetView: View {
  @Environment(\.widgetFamily) private var environmentFamily
  let entry: PandaEntry
  /// Renders a given size outside WidgetKit (tool/previews).
  var familyOverride: WidgetFamily? = nil
  private var family: WidgetFamily { familyOverride ?? environmentFamily }

  var body: some View {
    content.containerBackground(for: .widget) {
      switch family {
      case .systemSmall, .systemMedium: cream
      default: Color.clear
      }
    }
  }

  @ViewBuilder private var content: some View {
    switch family {
    case .accessoryInline: inline
    case .accessoryCircular: circular
    case .accessoryRectangular: rectangular
    case .systemMedium: medium
    default: small
    }
  }

  // Line above the clock: one text plus an optional image.
  private var inline: some View {
    Text(entry.inlineLine)
  }

  private var circular: some View {
    ZStack {
      AccessoryWidgetBackground()
      VStack(spacing: 0) {
        Image(systemName: entry.overdueCount > 0 ? "alarm.fill" : entry.mood.symbol)
          .font(.system(size: 16, weight: .semibold))
          .widgetAccentable()
        Text("\(entry.overdueCount > 0 ? entry.overdueCount : entry.openCount)")
          .font(.system(size: 20, weight: .bold, design: .rounded))
          .minimumScaleFactor(0.6)
        if entry.overdueCount > 0 {
          Text("late").font(.system(size: 9, weight: .medium))
        }
      }
    }
  }

  private var rectangular: some View {
    VStack(alignment: .leading, spacing: 1) {
      HStack(spacing: 4) {
        Image(systemName: entry.mood.symbol)
        Text(entry.overdueCount > 0 ? "The panda is sad" : "Red Panda")
      }
      .font(.headline)
      .widgetAccentable()
      Text(entry.countsLine).font(.caption)
      if let next = entry.next {
        HStack(spacing: 3) {
          if next.dueLabel != nil { Image(systemName: "alarm") }
          Text(next.title).lineLimit(1)
          if let label = next.dueLabel { Text("· \(label)").layoutPriority(1) }
        }
        .font(.caption)
      }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }

  private var small: some View {
    VStack(alignment: .leading, spacing: 4) {
      HStack(alignment: .top) {
        PandaImage(mood: entry.mood).frame(width: 56, height: 56)
        Spacer(minLength: 0)
        if entry.overdueCount > 0 {
          Image(systemName: "alarm.fill").foregroundStyle(pandaRed)
        }
        QuickButton(intent: OpenBasketIntent(), glyph: "redpanda.basket", label: "Panda's basket")
      }
      Text(entry.mood.headline)
        .font(.caption.weight(.semibold)).foregroundStyle(pandaRed).lineLimit(1)
        .minimumScaleFactor(0.8)
      Text(entry.countsLine).font(.caption2).foregroundStyle(.secondary)
      Spacer(minLength: 0)
      if let next = entry.next {
        ItemRow(item: next, compact: true)
      }
    }
    .foregroundStyle(.black)
    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
  }

  private var medium: some View {
    HStack(spacing: 10) {
      VStack(spacing: 4) {
        PandaImage(mood: entry.mood).frame(width: 74, height: 74)
        Text(entry.mood.headline)
          .font(.caption2.weight(.semibold)).foregroundStyle(pandaRed)
          .multilineTextAlignment(.center).lineLimit(2).minimumScaleFactor(0.8)
      }
      .frame(width: 84)
      VStack(alignment: .leading, spacing: 6) {
        Text(entry.countsLine).font(.subheadline.weight(.semibold))
        if entry.top.isEmpty {
          Text("Nothing on your list. The panda is having a lovely nap.")
            .font(.caption).foregroundStyle(.secondary)
        }
        ForEach(entry.top, id: \.self) { item in
          ItemRow(item: item, compact: false)
        }
        Spacer(minLength: 0)
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      VStack(spacing: 6) {
        QuickButton(intent: OpenComposeIntent(), glyph: "redpanda.note", label: "Text note")
        QuickButton(intent: StartVoiceNoteIntent(), glyph: "redpanda.voice", label: "Voice note")
        QuickButton(intent: OpenBasketIntent(), glyph: "redpanda.basket", label: "Panda's basket")
      }
    }
    .foregroundStyle(.black)
  }
}

/// Round quick-action button on the Home Screen widget.
private struct QuickButton<I: AppIntent>: View {
  let intent: I
  let glyph: String
  let label: String

  var body: some View {
    Button(intent: intent) {
      Image(glyph)
        .symbolRenderingMode(.hierarchical)
        .font(.system(size: 16, weight: .regular))
        .foregroundStyle(pandaRed)
        .frame(width: 30, height: 30)
        .background(Circle().fill(pandaRed.opacity(0.14)))
    }
    .buttonStyle(.plain)
    .accessibilityLabel(label)
  }
}

private struct ItemRow: View {
  let item: PandaItem
  let compact: Bool

  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      if compact {
        Text(item.title).font(.caption.weight(.medium)).lineLimit(2)
        if let label = item.dueLabel { due(label) }
      } else {
        HStack(spacing: 4) {
          Image(systemName: item.overdue ? "exclamationmark.circle.fill" : "circle")
            .font(.caption).foregroundStyle(item.overdue ? pandaRed : .secondary)
          Text(item.title).font(.caption.weight(.medium)).lineLimit(1)
          Spacer(minLength: 4)
          if let label = item.dueLabel { due(label) }
        }
      }
    }
  }

  private func due(_ label: String) -> some View {
    Label(label, systemImage: "alarm")
      .font(.caption2)
      .foregroundStyle(item.overdue ? pandaRed : .secondary)
      .labelStyle(.titleAndIcon)
      .lineLimit(1)
  }
}

/// The mood artwork from the extension's asset catalog; a paw print until
/// the images exist.
private struct PandaImage: View {
  let mood: PandaMood

  var body: some View {
    if let image = UIImage(named: mood.assetName) {
      Image(uiImage: image).resizable().scaledToFit()
    } else {
      Image(systemName: mood == .sad ? "pawprint" : "pawprint.fill")
        .resizable().scaledToFit().padding(8)
        .foregroundStyle(pandaRed)
    }
  }
}
