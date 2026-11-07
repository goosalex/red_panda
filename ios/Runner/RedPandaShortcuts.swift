import AppIntents

/// Siri / Shortcuts phrases. App target only.
struct RedPandaShortcuts: AppShortcutsProvider {
  static var appShortcuts: [AppShortcut] {
    AppShortcut(
      intent: CaptureTextNoteIntent(),
      phrases: ["Note with \(.applicationName)", "New \(.applicationName) note"],
      shortTitle: "Text note",
      systemImageName: "square.and.pencil")
    AppShortcut(
      intent: StartVoiceNoteIntent(),
      phrases: ["Voice note with \(.applicationName)"],
      shortTitle: "Voice note",
      systemImageName: "mic")
    AppShortcut(
      intent: RemindLeaveBasketIntent(),
      phrases: ["Leave basket in \(.applicationName)", "What's in my \(.applicationName) basket"],
      shortTitle: "Leave basket",
      systemImageName: "basket")
  }
}
