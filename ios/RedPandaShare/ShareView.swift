import SwiftUI

/// Colours of the app's warm theme.
enum PandaColor {
  static let cream = Color(red: 1, green: 0xF4 / 255, blue: 0xEC / 255)  // #FFF4EC
  static let orange = Color(red: 0xD9 / 255, green: 0x54 / 255, blue: 0x1E / 255)  // #D9541E
  static let ink = Color(red: 0x3B / 255, green: 0x24 / 255, blue: 0x18 / 255)
  static let card = Color.white.opacity(0.85)
}

struct ShareView: View {
  @ObservedObject var model: ShareModel

  var body: some View {
    VStack(spacing: 0) {
      header
      switch model.phase {
      case .loading:
        Spacer()
        ProgressView().tint(PandaColor.orange)
        Spacer()
      case .empty:
        emptyState
      case .ready:
        itemList
        footer
      case .added:
        added
      }
    }
    .foregroundStyle(PandaColor.ink)
    .background(PandaColor.cream.ignoresSafeArea())
    .animation(.easeOut(duration: 0.2), value: model.phase)
  }

  private var header: some View {
    HStack {
      if model.phase != .added {
        Button("Cancel") { model.cancel() }
          .foregroundStyle(PandaColor.orange)
      }
      Spacer()
    }
    .overlay(
      Text("Add to Red Panda").font(.headline)
    )
    .padding(.horizontal, 20)
    .padding(.vertical, 14)
  }

  private var itemList: some View {
    ScrollView {
      VStack(spacing: 8) {
        ForEach($model.entries) { $entry in
          EntryRow(entry: $entry)
        }
      }
      .padding(.horizontal, 16)
      .padding(.vertical, 4)
    }
  }

  private var footer: some View {
    VStack(spacing: 12) {
      Toggle(isOn: $model.leaveBasket) {
        VStack(alignment: .leading, spacing: 2) {
          Label("Put in leave basket", systemImage: "basket")
            .font(.body.weight(.medium))
          Text("Reminds you when you leave this place")
            .font(.caption)
            .foregroundStyle(PandaColor.ink.opacity(0.6))
        }
      }
      .tint(PandaColor.orange)
      .padding(14)
      .background(PandaColor.card, in: RoundedRectangle(cornerRadius: 14))

      if let error = model.error {
        Text(error).font(.footnote).foregroundStyle(.red)
      }

      Button {
        model.add()
      } label: {
        Text(addTitle)
          .font(.headline)
          .frame(maxWidth: .infinity)
          .padding(.vertical, 14)
          .background(
            PandaColor.orange.opacity(model.selectedCount == 0 ? 0.35 : 1),
            in: RoundedRectangle(cornerRadius: 14))
          .foregroundStyle(.white)
      }
      .disabled(model.selectedCount == 0)
    }
    .padding(16)
  }

  private var addTitle: String {
    let n = model.selectedCount
    return n == 1 ? "Add 1 item" : "Add \(n) items"
  }

  private var emptyState: some View {
    VStack(spacing: 16) {
      Spacer()
      Image(systemName: "tray")
        .font(.system(size: 40))
        .foregroundStyle(PandaColor.orange)
      Text("Nothing to add").font(.title3.weight(.semibold))
      Text("Share some text or a link to make a to-do.")
        .font(.subheadline)
        .foregroundStyle(PandaColor.ink.opacity(0.6))
      Button("Close") { model.cancel() }
        .font(.headline)
        .padding(.horizontal, 32)
        .padding(.vertical, 12)
        .background(PandaColor.orange, in: Capsule())
        .foregroundStyle(.white)
      Spacer()
    }
    .padding()
  }

  private var added: some View {
    VStack(spacing: 12) {
      Spacer()
      Image(systemName: "checkmark.circle.fill")
        .font(.system(size: 56))
        .foregroundStyle(PandaColor.orange)
      Text("Added ✓").font(.title2.weight(.semibold))
      Spacer()
    }
    .frame(maxWidth: .infinity)
    .transition(.scale.combined(with: .opacity))
  }
}

private struct EntryRow: View {
  @Binding var entry: ShareEntry

  var body: some View {
    HStack(alignment: .top, spacing: 12) {
      Button {
        entry.included.toggle()
      } label: {
        Image(systemName: entry.included ? "checkmark.square.fill" : "square")
          .font(.title3)
          .foregroundStyle(entry.included ? PandaColor.orange : PandaColor.ink.opacity(0.35))
      }
      .buttonStyle(.plain)
      .accessibilityLabel(entry.included ? "Included" : "Not included")

      TextField("To-do", text: $entry.text, axis: .vertical)
        .lineLimit(1...6)
        .opacity(entry.included ? 1 : 0.45)
    }
    .padding(12)
    .background(Color.white.opacity(entry.included ? 0.85 : 0.5), in: RoundedRectangle(cornerRadius: 12))
  }
}
