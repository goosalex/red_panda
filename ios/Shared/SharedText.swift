import Foundation

/// Turns text shared into Red Panda (Share Extension) into to-do items.
/// Pure Foundation so it compiles in the app, the extensions and a macOS test harness
/// (tool/share_text_check).
///
/// Rules:
///  - Line endings are normalised and the text trimmed.
///  - Paragraphs are separated by blank (or whitespace-only) lines.
///  - A paragraph with bullet lines (-, *, +, •, ◦, ▪, ‣, –, —, "1." / "1)", "- [ ]",
///    "- [x]", "☐", "☑", "✓" …) yields one item per bullet, marker stripped. Non-bullet
///    lines right after a bullet are continuation text of that bullet. Non-bullet lines
///    before the first bullet are a heading (dropped) when they end with ":", else an item.
///  - Without bullets anywhere, several paragraphs give one item each; a single paragraph
///    gives one item. Single newlines inside an item are joined with a space.
///  - When the text has bullets, a bullet-less paragraph ending with ":" is a heading too.
///  - Items are trimmed, runs of whitespace collapsed, empty items dropped; at most
///    `maxItems` items of at most `maxItemLength` characters.
enum SharedText {
  static let maxItems = 100
  static let maxItemLength = 1000

  static func items(from text: String) -> [String] {
    let normalised = text
      .replacingOccurrences(of: "\r\n", with: "\n")
      .replacingOccurrences(of: "\r", with: "\n")
      .replacingOccurrences(of: "\u{2028}", with: "\n")
      .replacingOccurrences(of: "\u{2029}", with: "\n\n")
      .trimmingCharacters(in: .whitespacesAndNewlines)
    guard !normalised.isEmpty else { return [] }

    let paragraphs = splitParagraphs(normalised)
    let hasBullets = paragraphs.contains { $0.contains { bulletContent($0) != nil } }

    var raw: [String] = []
    for paragraph in paragraphs {
      if paragraph.contains(where: { bulletContent($0) != nil }) {
        raw += bulletItems(paragraph)
      } else if hasBullets && isHeading(paragraph.last ?? "") {
        continue
      } else {
        raw.append(paragraph.joined(separator: " "))
      }
    }

    var result: [String] = []
    for item in raw {
      let clean = collapse(item)
      guard !clean.isEmpty else { continue }
      result.append(clean.count > maxItemLength ? String(clean.prefix(maxItemLength)) : clean)
      if result.count == maxItems { break }
    }
    return result
  }

  /// Paragraphs as arrays of trimmed, non-empty lines.
  private static func splitParagraphs(_ text: String) -> [[String]] {
    var paragraphs: [[String]] = []
    var current: [String] = []
    for line in text.components(separatedBy: "\n") {
      if line.trimmingCharacters(in: .whitespaces).isEmpty {
        if !current.isEmpty { paragraphs.append(current); current = [] }
      } else {
        current.append(line)
      }
    }
    if !current.isEmpty { paragraphs.append(current) }
    return paragraphs
  }

  private static func bulletItems(_ lines: [String]) -> [String] {
    var items: [String] = []
    var preamble: [String] = []
    var current: String?
    func flushPreamble() {
      if !preamble.isEmpty { items.append(preamble.joined(separator: " ")); preamble = [] }
    }
    for line in lines {
      if let content = bulletContent(line) {
        if let c = current { items.append(c) } else { flushPreamble() }
        current = content
      } else if let c = current {
        current = c + " " + line.trimmingCharacters(in: .whitespaces)
      } else if isHeading(line) {
        flushPreamble()
      } else {
        preamble.append(line.trimmingCharacters(in: .whitespaces))
      }
    }
    flushPreamble()
    if let c = current { items.append(c) }
    return items
  }

  private static func isHeading(_ line: String) -> Bool {
    let t = line.trimmingCharacters(in: .whitespaces)
    return t.hasSuffix(":") || t.hasSuffix("：")
  }

  /// Dash-like markers need a following space ("-5 °C", "*bold*" aren't bullets).
  private static let spacedMarkers: Set<Character> = ["-", "*", "+", "–", "—"]
  private static let glyphMarkers: Set<Character> = ["•", "◦", "▪", "‣", "·", "●", "○", "■", "□", "▫", "▸", "►", "➤", "→"]
  private static let checkMarks: Set<Character> = ["☐", "☑", "☒", "✓", "✔", "✗", "✘", "⬜", "✅"]

  /// The line's text without its bullet marker, or nil when it isn't a bullet line.
  static func bulletContent(_ line: String) -> String? {
    var s = Substring(line.trimmingCharacters(in: .whitespaces))
    guard let first = s.first else { return nil }

    if spacedMarkers.contains(first) {
      let rest = s.dropFirst()
      guard rest.isEmpty || rest.first!.isWhitespace else { return nil }
      s = rest
    } else if glyphMarkers.contains(first) || checkMarks.contains(first) {
      s = s.dropFirst()
    } else if let rest = stripCheckbox(s) {
      return String(rest).trimmingCharacters(in: .whitespaces)
    } else if let rest = stripNumber(s) {
      s = rest
    } else {
      return nil
    }
    s = s.drop(while: { $0.isWhitespace })
    // "- [ ] task", "- [x] task", "• ☐ task"
    if let rest = stripCheckbox(s) {
      s = rest
    } else if let c = s.first, checkMarks.contains(c) {
      s = s.dropFirst()
    }
    return String(s).trimmingCharacters(in: .whitespaces)
  }

  /// "[ ]", "[x]", "[X]", "[✓]" at the start, followed by space or end.
  private static func stripCheckbox(_ s: Substring) -> Substring? {
    let chars = Array(s.prefix(3))
    guard chars.count == 3, chars[0] == "[", chars[2] == "]",
          [" ", "x", "X", "✓", "✔", "-", "/"].contains(chars[1]) else { return nil }
    let rest = s.dropFirst(3)
    guard rest.isEmpty || rest.first!.isWhitespace else { return nil }
    return rest
  }

  /// "1." / "12)" followed by whitespace (so "3.5 kg" and "1.2.3" aren't bullets).
  private static func stripNumber(_ s: Substring) -> Substring? {
    let digits = s.prefix(while: { $0.isASCII && $0.isNumber })
    guard (1...3).contains(digits.count) else { return nil }
    let rest = s.dropFirst(digits.count)
    guard let p = rest.first, p == "." || p == ")" else { return nil }
    let after = rest.dropFirst()
    guard after.isEmpty || after.first!.isWhitespace else { return nil }
    return after
  }

  private static func collapse(_ s: String) -> String {
    s.split(whereSeparator: { $0.isWhitespace }).joined(separator: " ")
  }
}
