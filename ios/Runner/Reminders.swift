import Foundation
import UserNotifications
import WidgetKit

/// Nagging notifications for open to-dos (lib/platform/reminders.dart).
/// Every call to schedule() replaces all pending Red Panda notifications, so
/// the app reschedules on start, resume and whenever notes change.
enum Reminders {
  static let prefix = "ch.masdatos.redpanda.reminder."
  /// iOS keeps at most 64 pending requests per app; leave some headroom.
  static let maxPending = 60
  private static let nudgedKey = "redpanda.reminders.nudgedToday"

  struct Item {
    let id: String
    let title: String
    let dueAt: Date?
    let remindAt: Date?
  }

  /// Escalation levels; each has its own set of messages.
  enum Level: String {
    case remind, dayBefore, dueToday, overdue1, overdue2, overdue3, missYou
  }

  static func requestPermission() async -> Bool {
    let center = UNUserNotificationCenter.current()
    do {
      return try await center.requestAuthorization(options: [.alert, .sound, .badge])
    } catch {
      return false
    }
  }

  static func reloadWidgets() {
    WidgetCache.refresh()
    WidgetCenter.shared.reloadAllTimelines()
  }

  // MARK: - Channel arguments

  static func items(from raw: Any?) -> [Item] {
    guard let list = raw as? [[String: Any]] else { return [] }
    return list.compactMap { m in
      guard let id = m["id"] as? String else { return nil }
      return Item(
        id: id,
        title: (m["title"] as? String) ?? "",
        dueAt: parseDate(m["dueAt"]),
        remindAt: parseDate(m["remindAt"]))
    }
  }

  private static func parseDate(_ v: Any?) -> Date? {
    guard let s = v as? String else { return nil }
    let fractional = ISO8601DateFormatter()
    fractional.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    return fractional.date(from: s) ?? ISO8601DateFormatter().date(from: s)
  }

  // MARK: - Scheduling

  struct Planned {
    let id: String
    let itemId: String
    /// The "due today" nudge moved to now + 1 min.
    var immediate = false
    let date: Date
    let level: Level
    let title: String
    let body: String
  }

  static func schedule(
    _ items: [Item], intensity: Int, quietStartHour: Int, quietEndHour: Int
  ) async {
    // The "due today" nudge in a minute (app opened after 09:00) only once a
    // day per item, not after every schedule() call; a pending one is kept.
    let now = Date()
    let today = ISO8601DateFormatter.string(
      from: now, timeZone: .current, formatOptions: [.withFullDate])
    let defaults = UserDefaults.standard
    var nudged = defaults.dictionary(forKey: nudgedKey) as? [String: String] ?? [:]
    // Only for items still open (and nagged about): done ones lose their nudge.
    let openIds = Set(items.map(\.id))
    nudged = intensity >= 1 ? nudged.filter { $0.value == today && openIds.contains($0.key) } : [:]
    let keep = Set(nudged.keys.map { "\(prefix)\($0).\(Level.dueToday.rawValue)" })

    let center = UNUserNotificationCenter.current()
    let pending = await center.pendingNotificationRequests()
    let ours = pending.map(\.identifier).filter { $0.hasPrefix(prefix) && !keep.contains($0) }
    center.removePendingNotificationRequests(withIdentifiers: ours)
    let planned = plan(
      items, intensity: intensity, quietStartHour: quietStartHour,
      quietEndHour: quietEndHour, now: now, calendar: .current,
      alreadyNudgedToday: Set(nudged.keys))
    for p in planned where p.immediate { nudged[p.itemId] = today }
    defaults.set(nudged, forKey: nudgedKey)
    for p in planned {
      let content = UNMutableNotificationContent()
      content.title = "Red Panda"
      content.body = p.body
      content.sound = .default
      content.threadIdentifier = "red_panda.\(p.level == .missYou ? "missYou" : "todos")"
      let parts = Calendar.current.dateComponents(
        [.year, .month, .day, .hour, .minute, .second], from: p.date)
      let trigger = UNCalendarNotificationTrigger(dateMatching: parts, repeats: false)
      let request = UNNotificationRequest(identifier: p.id, content: content, trigger: trigger)
      do {
        try await center.add(request)
      } catch {
        NSLog("RedPanda reminder %@ not scheduled: %@", p.id, String(describing: error))
      }
    }
  }

  /// The notifications to schedule, nearest first, at most [maxPending].
  /// intensity 0 = off, 1 gentle, 2 normal, 3 persistent.
  static func plan(
    _ items: [Item], intensity: Int, quietStartHour: Int, quietEndHour: Int,
    now: Date, calendar cal: Calendar, alreadyNudgedToday: Set<String> = []
  ) -> [Planned] {
    var out: [Planned] = []
    let earliest = now.addingTimeInterval(5)

    func at(_ day: Date, hour: Int) -> Date? {
      cal.date(bySettingHour: hour, minute: 0, second: 0, of: day)
    }
    func shifted(_ date: Date) -> Date {
      shiftOutOfQuietHours(date, start: quietStartHour, end: quietEndHour, calendar: cal)
    }
    func add(
      _ item: Item, _ level: Level, _ date: Date?, shift: Bool = true, notAfter: Date? = nil,
      immediate: Bool = false
    ) {
      guard var d = date else { return }
      if shift { d = shifted(d) }
      guard d > earliest else { return }
      if let limit = notAfter, d > limit { return }
      out.append(
        Planned(
          id: "\(prefix)\(item.id).\(level.rawValue)", itemId: item.id, immediate: immediate,
          date: d, level: level, title: item.title,
          body: message(level, title: item.title, key: item.id)))
    }

    for item in items {
      // An explicit "remind me at" fires at the chosen time, even in quiet
      // hours: the user picked it. Not tied to the nagging intensity.
      if let r = item.remindAt { add(item, .remind, r, shift: false) }

      guard intensity >= 1, let due = item.dueAt else { continue }
      let dueDay = cal.startOfDay(for: due)

      if due > now {
        // Deadline day 09:00, or in a minute if 09:00 has passed already.
        if let nine = at(dueDay, hour: 9) {
          if nine > now {
            add(item, .dueToday, nine, notAfter: due)
          } else if cal.isDate(now, inSameDayAs: dueDay), !alreadyNudgedToday.contains(item.id) {
            add(item, .dueToday, now.addingTimeInterval(60), notAfter: due, immediate: true)
          }
        }
        if intensity >= 2, let before = cal.date(byAdding: .day, value: -1, to: dueDay) {
          add(item, .dayBefore, at(before, hour: 18), notAfter: due)
        }
      }
      if intensity >= 3 {
        let levels: [Level] = [.overdue1, .overdue2, .overdue3]
        for (i, level) in levels.enumerated() {
          if let day = cal.date(byAdding: .day, value: i + 1, to: dueDay) {
            add(item, level, at(day, hour: 9))
          }
        }
      }
    }

    if intensity >= 2, !items.isEmpty,
      let day = cal.date(byAdding: .day, value: 2, to: cal.startOfDay(for: now)),
      let seven = at(day, hour: 19)
    {
      let d = shifted(seven)
      out.append(
        Planned(
          id: "\(prefix)missYou", itemId: "", date: d, level: .missYou, title: "",
          body: missYouMessage(count: items.count, key: "\(items.count)")))
    }

    out.sort { $0.date < $1.date }
    return Array(out.prefix(maxPending))
  }

  /// Moves [date] to quietEnd:00 when it falls into the quiet hours
  /// (start..<end, wrapping past midnight when start > end).
  static func shiftOutOfQuietHours(_ date: Date, start: Int, end: Int, calendar cal: Calendar)
    -> Date
  {
    guard start != end, (0...23).contains(start), (0...23).contains(end) else { return date }
    let hour = cal.component(.hour, from: date)
    let quiet = start < end ? (hour >= start && hour < end) : (hour >= start || hour < end)
    guard quiet else { return date }
    var day = cal.startOfDay(for: date)
    // Evening part of a quiet span that wraps midnight: the end is tomorrow.
    if start > end && hour >= start {
      day = cal.date(byAdding: .day, value: 1, to: day) ?? day
    }
    return cal.date(bySettingHour: end, minute: 0, second: 0, of: day) ?? date
  }

  // MARK: - Messages

  private static func pick(_ options: [String], key: String) -> String {
    // Stable per item and level (Swift's hashValue changes per launch).
    let n = key.unicodeScalars.reduce(0) { ($0 &* 31 &+ Int($1.value)) & 0x7fff_ffff }
    return options[n % options.count]
  }

  /// The messages are looked up in Localizable.xcstrings in the app's current
  /// language; every language keeps the same number of options per level, so
  /// pick() chooses the same slot everywhere.
  static func message(_ level: Level, title rawTitle: String, key: String) -> String {
    let t = rawTitle.trimmingCharacters(in: .whitespacesAndNewlines)
    let short = t.count > 80 ? String(t.prefix(79)) + "…" : t
    let title =
      t.isEmpty
      ? String(localized: "that little to-do", comment: "Reminder text for a to-do without a title")
      : String(localized: "“\(short)”", comment: "A to-do's title quoted inside a reminder")
    let options: [String]
    switch level {
    case .remind:
      options = [
        String(localized: "The panda tugs your sleeve: \(title) 🐾"),
        String(localized: "Psst! The red panda remembered for you: \(title)"),
        String(localized: "A fluffy tail swishes past with a note: \(title)"),
      ]
    case .dayBefore:
      options = [
        String(localized: "Tomorrow’s the day for \(title). The red panda is already a tiny bit nervous 🐾"),
        String(localized: "The red panda peeks over your shoulder: \(title) is due tomorrow."),
        String(localized: "Heads up from the bamboo grove: \(title) is due tomorrow 🎋"),
      ]
    case .dueToday:
      options = [
        String(localized: "The red panda is staring at your list with big sad eyes 🥺 \(title) is due today."),
        String(localized: "\(title) is due today. The panda has stopped chewing its bamboo to watch."),
        String(localized: "Today’s the day! The red panda believes in you: \(title) 🐾"),
        String(localized: "A small paw taps your screen: \(title) is due today."),
      ]
    case .overdue1:
      options = [
        String(localized: "A tiny sniffle from the bamboo grove… \(title) is overdue 🥺"),
        String(localized: "The red panda waited all day for \(title). It’s still waiting."),
        String(localized: "\(title) slipped past its deadline. The panda’s ears have drooped a little."),
      ]
    case .overdue2:
      options = [
        String(localized: "The red panda has curled up in a sad little ball. \(title) is two days late 😢"),
        String(localized: "Two days now. The panda keeps checking for \(title) and sighing softly."),
        String(localized: "The bamboo has gone untouched. The panda is too worried about \(title) to eat 🎋"),
      ]
    case .overdue3:
      options = [
        String(localized: "The red panda has written \(title) on a leaf and is holding it up with trembling paws 🥺"),
        String(localized: "Day three. The panda is sitting by the window, hoping you’ll come back for \(title)."),
        String(localized: "The panda’s tail has stopped swishing. Only you can fix \(title) 💔"),
      ]
    case .missYou:
      options = [missYouMessage(count: 1, key: key)]
    }
    return pick(options, key: key + level.rawValue)
  }

  static func missYouMessage(count: Int, key: String) -> String {
    pick(
      [
        String(localized: "The red panda misses you 🥺 \(count) things are still waiting in the bamboo grove."),
        String(localized: "It’s awfully quiet without you. The panda has been guarding your list: \(count) things are waiting."),
        String(localized: "The red panda keeps peeking at the door. \(count) things are still on your list 🐾"),
      ], key: key)
  }
}
