/// What's new, newest first: Settings > Panda > News. Keep each line short;
/// add an entry (and bump pubspec.yaml) with every pull request.
class NewsEntry {
  const NewsEntry(this.version, this.pr, this.items);
  final String version;
  final int pr;
  final List<String> items;

  String get url => 'https://github.com/goosalex/red_panda/pull/$pr';
}

const news = [
  NewsEntry('0.3.2', 6, [
    'The Undo bar goes away after 5 seconds',
    'Twinkling stars next to the moon',
  ]),
  NewsEntry('0.3.1', 5, [
    'Widgets count notes shared from other apps straight away',
  ]),
  NewsEntry('0.3.0', 4, [
    'iCloud sync across your devices',
    "Panda's basket: control, Siri and widget button",
    'Panda glyphs on the note and voice buttons',
    'Why "Always" location is needed, explained',
    'Quick capture: previews and settings links',
    'This News page',
  ]),
  NewsEntry('0.2.1', 3, [
    'One-line settings',
    'Shortcuts links for Wi-Fi and place automations',
  ]),
  NewsEntry('0.2.0', 2, [
    'Share text into Red Panda',
    'Leave basket reminders',
  ]),
];
