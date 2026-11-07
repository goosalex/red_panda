import SwiftUI
import UIKit
import WidgetKit

// Renders the Quick capture previews (assets/quick_capture/*.png) from the
// real widget views and glyphs. Not part of any target: see README.md.

@MainActor
enum PreviewRender {
  static func runIfAsked() {
    guard ProcessInfo.processInfo.arguments.contains("-renderPreviews") else { return }
    let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
      .appendingPathComponent("previews", isDirectory: true)
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let scenes: [(String, AnyView)] = [
      ("lock_screen", AnyView(LockScreenScene())),
      ("widgets", AnyView(WidgetsScene())),
      ("control_centre", AnyView(ControlCentreScene())),
      ("action_button", AnyView(ActionButtonScene())),
      ("siri", AnyView(SiriScene())),
    ]
    for (name, view) in scenes {
      let r = ImageRenderer(content: view.frame(width: 360, height: 160).clipped())
      r.scale = 3
      if let data = r.uiImage?.pngData() {
        try? data.write(to: dir.appendingPathComponent("\(name).png"))
      }
    }
    print("PREVIEWS: \(dir.path)")
  }
}

private let sample: PandaEntry = {
  let now = Date()
  return PandaEntry(
    date: now, mood: .curious, openCount: 4, overdueCount: 0, dueTodayCount: 1, doneTodayCount: 0,
    top: [
      PandaItem(title: "Buy bamboo", dueAt: now, daysLeft: 0, overdue: false),
      PandaItem(title: "Return library books", dueAt: now, daysLeft: 1, overdue: false),
      PandaItem(title: "Call Grandma", dueAt: nil, daysLeft: nil, overdue: false),
    ])
}()

private let cream = Color(red: 1.0, green: 0.96, blue: 0.90)

private struct Wallpaper: View {
  var body: some View {
    LinearGradient(
      colors: [Color(red: 0.85, green: 0.38, blue: 0.16), Color(red: 0.32, green: 0.12, blue: 0.20),
               Color(red: 0.10, green: 0.08, blue: 0.16)],
      startPoint: .topLeading, endPoint: .bottomTrailing)
  }
}

private struct Glyph: View {
  let name: String
  var size: CGFloat = 22
  var body: some View {
    Image(name).symbolRenderingMode(.hierarchical).font(.system(size: size))
  }
}

private struct LockButton: View {
  let glyph: String
  var body: some View {
    Glyph(name: glyph, size: 22)
      .foregroundStyle(.white)
      .frame(width: 50, height: 50)
      .background(Circle().fill(.black.opacity(0.35)))
  }
}

private struct LockScreenScene: View {
  var body: some View {
    ZStack {
      Wallpaper()
      VStack(spacing: 2) {
        Text("9:41").font(.system(size: 54, weight: .semibold, design: .rounded))
        PandaWidgetView(entry: sample, familyOverride: .accessoryRectangular)
          .frame(width: 160, height: 56)
      }
      .foregroundStyle(.white)
      .offset(y: -20)
      HStack {
        LockButton(glyph: "redpanda.note")
        Spacer()
        LockButton(glyph: "redpanda.voice")
      }
      .padding(.horizontal, 26)
      .frame(maxHeight: .infinity, alignment: .bottom)
      .padding(.bottom, 12)
    }
  }
}

private struct WidgetsScene: View {
  var body: some View {
    ZStack {
      Wallpaper()
      PandaWidgetView(entry: sample, familyOverride: .systemMedium)
        .padding(14)
        .frame(width: 338, height: 148)
        .background(RoundedRectangle(cornerRadius: 22, style: .continuous).fill(cream))
    }
  }
}

private struct ControlTile: View {
  let glyph: String
  let label: String
  var body: some View {
    VStack(spacing: 6) {
      Glyph(name: glyph, size: 24)
        .foregroundStyle(.white)
        .frame(width: 62, height: 62)
        .background(Circle().fill(.white.opacity(0.18)))
      Text(label).font(.caption2.weight(.medium)).foregroundStyle(.white.opacity(0.9))
    }
    .frame(width: 92)
  }
}

private struct ControlCentreScene: View {
  var body: some View {
    ZStack {
      Wallpaper().blur(radius: 18).overlay(Color.black.opacity(0.45))
      HStack(spacing: 12) {
        ControlTile(glyph: "redpanda.note", label: "Text note")
        ControlTile(glyph: "redpanda.voice", label: "Voice note")
        ControlTile(glyph: "redpanda.basket", label: "Panda's basket")
      }
    }
  }
}

private struct ActionButtonScene: View {
  var body: some View {
    ZStack(alignment: .top) {
      Wallpaper()
      HStack(spacing: 10) {
        Glyph(name: "redpanda.voice", size: 18).foregroundStyle(Color(red: 1, green: 0.55, blue: 0.3))
        Text("Voice note").font(.subheadline.weight(.semibold)).foregroundStyle(.white)
        Spacer(minLength: 0)
        Image(systemName: "waveform").foregroundStyle(Color(red: 1, green: 0.55, blue: 0.3))
      }
      .padding(.horizontal, 18)
      .frame(width: 230, height: 46)
      .background(Capsule().fill(.black))
      .padding(.top, 24)
      // The Action Button on the iPhone's left edge.
      RoundedRectangle(cornerRadius: 2)
        .fill(Color(red: 1, green: 0.55, blue: 0.3))
        .frame(width: 5, height: 34)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 70)
      Text("Press and hold the Action Button")
        .font(.footnote).foregroundStyle(.white.opacity(0.85))
        .frame(maxHeight: .infinity, alignment: .bottom)
        .padding(.bottom, 16)
    }
  }
}

private struct SiriScene: View {
  var body: some View {
    ZStack {
      Wallpaper().blur(radius: 10).overlay(Color.black.opacity(0.3))
      VStack(spacing: 10) {
        Text("“Note with Red Panda”")
          .font(.footnote).foregroundStyle(.white.opacity(0.85))
        HStack(spacing: 10) {
          Glyph(name: "redpanda.note", size: 22).foregroundStyle(Color(red: 0.80, green: 0.33, blue: 0.16))
          VStack(alignment: .leading, spacing: 2) {
            Text("RED PANDA").font(.caption2.weight(.semibold)).foregroundStyle(.secondary)
            Text("Saved. The panda is happy.").font(.subheadline.weight(.medium))
          }
          Spacer(minLength: 0)
        }
        .padding(12)
        .frame(width: 280)
        .background(RoundedRectangle(cornerRadius: 18, style: .continuous).fill(.white.opacity(0.92)))
        Circle()
          .fill(AngularGradient(colors: [.pink, .purple, .blue, .cyan, .orange, .pink], center: .center))
          .frame(width: 30, height: 30)
          .blur(radius: 1.5)
      }
    }
  }
}
