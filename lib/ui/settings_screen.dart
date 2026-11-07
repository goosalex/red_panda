import 'package:flutter/material.dart';

import '../gamification/bamboo.dart';
import '../models/app_settings.dart';
import '../news.dart';
import '../platform/leave_basket.dart';
import '../platform/shortcuts_links.dart';
import '../storage/cloud_sync.dart';
import '../storage/note_store.dart';

/// Settings: one line per setting. Choices open in a drawer (bottom sheet),
/// groups (leave basket, quick capture) on their own page.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.store, this.cloud});
  final NoteStore store;

  /// The home screen's iCloud sync (status, switching it on and off).
  final CloudSyncController? cloud;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  AppSettings? _s;

  @override
  void initState() {
    super.initState();
    widget.store.loadSettings().then((s) => mounted ? setState(() => _s = s) : null);
  }

  Future<void> _update(AppSettings s) async {
    setState(() => _s = s);
    await widget.store.saveSettings(s);
  }

  Future<void> _pickSwipe(AppSettings s) async {
    final a = await showSettingsDrawer<SwipeAction>(
      context,
      title: 'Swipe right on an item',
      note: 'Ticked-off items always un-tick; snoozed items wake up.',
      builder: (ctx) => [
        for (final a in SwipeAction.values)
          _ChoiceTile(
            selected: a == s.swipeAction,
            title: a.label,
            subtitle: a.description,
            onTap: () => Navigator.pop(ctx, a),
          ),
      ],
    );
    if (a != null) await _update(_s!.copyWith(swipeAction: a));
  }

  Future<void> _pickNag(AppSettings s) async {
    final n = await showSettingsDrawer<NagIntensity>(
      context,
      title: 'Sad panda reminders',
      note: 'Notifications and widgets nag you as deadlines come closer.',
      builder: (ctx) => [
        for (final n in NagIntensity.values)
          _ChoiceTile(selected: n == s.nagIntensity, title: n.label, onTap: () => Navigator.pop(ctx, n)),
      ],
    );
    if (n != null) await _update(_s!.copyWith(nagIntensity: n));
  }

  Future<void> _pickCloud(AppSettings s) async {
    final on = await showSettingsDrawer<bool>(
      context,
      title: 'iCloud sync',
      note: 'Notes, voice notes, categories and bamboo sync through your iCloud Drive to every '
          'iPhone and iPad signed in to the same Apple Account. Settings stay on each device.',
      builder: (ctx) => [
        _ChoiceTile(selected: s.icloudSync, title: 'On', onTap: () => Navigator.pop(ctx, true)),
        _ChoiceTile(selected: !s.icloudSync, title: 'Off', onTap: () => Navigator.pop(ctx, false)),
      ],
    );
    if (on == null) return;
    await _update(_s!.copyWith(icloudSync: on));
    await widget.cloud?.run(enabled: on);
  }

  Future<void> _pickHour(int current, AppSettings Function(int h) apply) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (t != null) await _update(apply(t.hour));
  }

  void _showBamboo() => showSettingsDrawer<void>(
        context,
        title: '🎋 Bamboo',
        builder: (_) => [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              'Every finished item feeds the panda ${BambooWallet.perCompletion} 🎋 '
              '(+${BambooWallet.earlyBonus} when done before its deadline day). '
              'Snoozing costs ${BambooWallet.snoozeCost} 🎋; postponing a deadline is free until '
              '${BambooWallet.freePostponeDays} days before it, then costs ${BambooWallet.latePostponeCost} 🎋. '
              'The stash holds at most ${BambooWallet.cap}.',
            ),
          ),
        ],
      );

  Future<void> _openBasket() async {
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => LeaveBasketSettingsPage(initial: _s!, onChanged: _update),
    ));
    if (mounted) setState(() {});
  }

  void _openQuickCapture() => Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => QuickCapturePage(
          onNagSettings: () => _pickNag(_s!),
          onBasketSettings: _openBasket,
        ),
      ));

  @override
  Widget build(BuildContext context) {
    final s = _s;
    final cloud = widget.cloud?.status ?? ValueNotifier(const CloudStatus(CloudState.off));
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const _Header('List'),
                ValueListenableBuilder(
                  valueListenable: cloud,
                  builder: (_, st, _) => SettingRow(
                    icon: Icons.cloud_outlined,
                    title: 'iCloud sync',
                    value: s.icloudSync ? st.label : 'Off',
                    warn: s.icloudSync && (st.state == CloudState.unavailable || st.state == CloudState.failed),
                    onTap: () => _pickCloud(s),
                  ),
                ),
                SettingRow(
                  icon: Icons.swipe_right_outlined,
                  title: 'Swipe right',
                  value: s.swipeAction.label,
                  onTap: () => _pickSwipe(s),
                ),
                const _Header('Reminders'),
                SettingRow(
                  icon: Icons.notifications_outlined,
                  title: 'Sad panda reminders',
                  value: s.nagIntensity.label,
                  onTap: () => _pickNag(s),
                ),
                SettingRow(
                  icon: Icons.bedtime_outlined,
                  title: 'Quiet from',
                  value: hourLabel(s.quietStartHour),
                  onTap: () => _pickHour(s.quietStartHour, (h) => _s!.copyWith(quietStartHour: h)),
                ),
                SettingRow(
                  icon: Icons.wb_twilight_outlined,
                  title: 'Quiet until',
                  value: hourLabel(s.quietEndHour),
                  onTap: () => _pickHour(s.quietEndHour, (h) => _s!.copyWith(quietEndHour: h)),
                ),
                SettingRow(
                  icon: Icons.shopping_basket_outlined,
                  title: 'Leave basket',
                  value: basketSummary(s),
                  page: true,
                  onTap: _openBasket,
                ),
                const _Header('Panda'),
                SettingRow(
                  icon: Icons.grass_outlined,
                  title: 'Bamboo rules',
                  value: 'Max ${BambooWallet.cap}',
                  onTap: _showBamboo,
                ),
                SettingRow(
                  icon: Icons.bolt_outlined,
                  title: 'Quick capture',
                  value: 'Lock Screen, Siri…',
                  page: true,
                  onTap: _openQuickCapture,
                ),
                SettingRow(
                  icon: Icons.campaign_outlined,
                  title: 'News',
                  value: 'Version ${news.first.version}',
                  page: true,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsPage())),
                ),
              ],
            ),
    );
  }
}

String hourLabel(int h) => '${h.toString().padLeft(2, '0')}:00';

String radiusLabel(int m) => m >= 1000 ? '${m ~/ 1000} km' : '$m m';

/// One-line summary of the leave basket triggers, e.g. "50 m · Wi-Fi".
String basketSummary(AppSettings s) {
  final parts = [
    if (s.leaveOnPlace) radiusLabel(s.leaveRadiusMeters),
    if (s.leaveOnWifi) 'Wi-Fi',
  ];
  return parts.isEmpty ? 'Off' : parts.join(' · ');
}

/// Leave basket: triggers, radius, location access and Shortcuts automations.
class LeaveBasketSettingsPage extends StatefulWidget {
  const LeaveBasketSettingsPage({super.key, required this.initial, required this.onChanged});
  final AppSettings initial;
  final Future<void> Function(AppSettings) onChanged;

  @override
  State<LeaveBasketSettingsPage> createState() => _LeaveBasketSettingsPageState();
}

class _LeaveBasketSettingsPageState extends State<LeaveBasketSettingsPage> with WidgetsBindingObserver {
  late AppSettings _s = widget.initial;
  LeaveStatus? _status;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadStatus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // Back from the iOS Settings: the location permission may have changed.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) _loadStatus();
  }

  Future<void> _loadStatus() async {
    final st = await LeaveBasket.status();
    if (mounted) setState(() => _status = st);
  }

  Future<void> _set(AppSettings s) async {
    setState(() => _s = s);
    await widget.onChanged(s);
  }

  Future<void> _pickRadius() async {
    final m = await showSettingsDrawer<int>(
      context,
      title: 'Remind me when I am further away than',
      note: 'iPhones place you to about 100 m, so a small radius may fire a little late.',
      builder: (ctx) => [
        for (final m in AppSettings.leaveRadiusChoices)
          _ChoiceTile(
            selected: m == _s.leaveRadiusMeters,
            title: radiusLabel(m),
            onTap: () => Navigator.pop(ctx, m),
          ),
      ],
    );
    if (m != null) await _set(_s.copyWith(leaveRadiusMeters: m));
  }

  static String _permissionLabel(LocationPermission? p) => switch (p) {
        LocationPermission.always => 'Always',
        LocationPermission.whenInUse => 'While using',
        LocationPermission.denied => 'Off',
        LocationPermission.notDetermined => 'Not asked yet',
        _ => '—',
      };

  @override
  Widget build(BuildContext context) {
    final s = _s;
    final permission = _status?.permission;
    return Scaffold(
      appBar: AppBar(title: const Text('🧺 Leave basket')),
      body: ListView(
        children: [
          const _Note('Items in the basket remind you as soon as you leave the place where you put '
              'them in, or your Wi-Fi drops.'),
          SwitchListTile(
            secondary: const Icon(Icons.directions_walk),
            title: const Text('When I leave this place', maxLines: 1, overflow: TextOverflow.ellipsis),
            value: s.leaveOnPlace,
            onChanged: (v) => _set(s.copyWith(leaveOnPlace: v)),
          ),
          SettingRow(
            icon: Icons.radar,
            title: 'Radius',
            value: radiusLabel(s.leaveRadiusMeters),
            enabled: s.leaveOnPlace,
            onTap: _pickRadius,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wifi_off),
            title: const Text('When my Wi-Fi drops', maxLines: 1, overflow: TextOverflow.ellipsis),
            value: s.leaveOnWifi,
            onChanged: (v) => _set(s.copyWith(leaveOnWifi: v)),
          ),
          SettingRow(
            icon: Icons.location_on_outlined,
            title: 'Location access',
            value: _permissionLabel(permission),
            warn: s.leaveOnPlace && permission != null && permission != LocationPermission.always &&
                permission != LocationPermission.unknown,
            external: true,
            onTap: LeaveBasket.openSettings,
          ),
          SettingRow(
            icon: Icons.info,
            iconColor: Colors.blue,
            title: 'Why "Always"?',
            value: 'No tracking',
            onTap: () => showLocationInfo(context),
          ),
          const _Header('Shortcuts automations'),
          const _Note('Red Panda only notices a Wi-Fi drop while it is open or was just in use. A '
              'Shortcuts automation catches it any time, and can watch a fixed place like home.'),
          SettingRow(
            icon: Icons.wifi,
            title: 'When I leave a Wi-Fi',
            value: 'Set up',
            onTap: () => showAutomationGuide(context, AutomationGuide.wifi),
          ),
          SettingRow(
            icon: Icons.home_outlined,
            title: 'When I leave a place',
            value: 'Set up',
            onTap: () => showAutomationGuide(context, AutomationGuide.place),
          ),
          SettingRow(
            icon: Icons.checklist,
            title: 'My automations',
            value: 'Shortcuts',
            external: true,
            onTap: () => ShortcutsLinks.open(ShortcutsLinks.automations),
          ),
        ],
      ),
    );
  }
}

/// Step-by-step wiring of a Shortcuts personal automation to Red Panda's
/// "Remind me of my leave basket" action.
enum AutomationGuide {
  wifi('When I leave a Wi-Fi', [
    'Tap "Open Shortcuts" below: the New Automation list opens.',
    'Scroll down and tap Wi-Fi.',
    'Choose your network, tick "Leaves" and untick "Joins".',
    'Pick "Run Immediately", then tap Next.',
  ]),
  place('When I leave a place', [
    'Tap "Open Shortcuts" below: the New Automation list opens.',
    'Tap Leave, then Location > Choose, and pick the place (e.g. home).',
    'Pick "Run Immediately", then tap Next.',
  ]);

  const AutomationGuide(this.title, this.triggerSteps);
  final String title;
  final List<String> triggerSteps;

  List<String> get steps => [
        ...triggerSteps,
        'Tap "New Blank Automation", then Add Action, search "leave basket" and pick '
            '"${ShortcutsLinks.remindAction}".',
        'Tap Done. From now on the panda reminds you of your basket.',
      ];
}

Future<void> showAutomationGuide(BuildContext context, AutomationGuide g) => showSettingsDrawer<void>(
      context,
      title: g.title,
      builder: (ctx) => [
        for (final (i, step) in g.steps.indexed)
          ListTile(
            dense: true,
            leading: CircleAvatar(radius: 12, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
            title: Text(step),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: const Text('Open Shortcuts'),
            onPressed: () {
              Navigator.pop(ctx);
              ShortcutsLinks.open(ShortcutsLinks.newAutomation);
            },
          ),
        ),
      ],
    );

/// Why the leave basket asks for "Always" location access, and why that
/// costs neither battery nor privacy.
Future<void> showLocationInfo(BuildContext context) => showSettingsDrawer<void>(
      context,
      title: 'Why "Always" location?',
      builder: (_) => const [
        _InfoPoint(Icons.door_front_door_outlined, 'Only to notice you leaving',
            'With "While using", iOS tells Red Panda nothing once it is closed, so the basket could only '
                'remind you while the app is open. "Always" lets iOS wake Red Panda the moment you leave.'),
        _InfoPoint(Icons.battery_full, 'No battery drain',
            'Red Panda does not follow you. It asks iOS once for where you are and draws one circle '
                'around it. iOS watches that circle with the cell and Wi-Fi signals it uses anyway, and '
                'Red Panda sleeps until you cross the edge. Then the circle is removed.'),
        _InfoPoint(Icons.lock_outline, 'Your location stays on your iPhone',
            'Red Panda has no server and sends your location nowhere. Only the circle\'s centre is '
                'kept, on this device, until the reminder fires. iCloud sync never includes it.'),
        _InfoPoint(Icons.wifi_off, 'Wi-Fi needs no location',
            'The "Wi-Fi drops" trigger works without location access.'),
      ],
    );

class _InfoPoint extends StatelessWidget {
  const _InfoPoint(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(body),
      );
}

/// A quick-capture spot: where to add Red Panda, a preview of how it looks
/// there, and links to the settings it uses.
class CaptureSpot {
  const CaptureSpot(this.icon, this.title, this.how, this.image, [this.links = const []]);
  final IconData icon;
  final String title;
  final String how;

  /// Preview image in assets/quick_capture/ (rendered from the real widgets).
  final String image;
  final List<CaptureLink> links;
}

enum CaptureLink {
  microphone('Microphone & Speech access', Icons.mic_none, external: true),
  siri('Siri & Search', Icons.record_voice_over_outlined, external: true),
  nag('Sad panda reminders', Icons.notifications_outlined),
  basket('Leave basket', Icons.shopping_basket_outlined);

  const CaptureLink(this.label, this.icon, {this.external = false});
  final String label;
  final IconData icon;

  /// Opens Red Panda's page in the iOS Settings app (not an in-app page).
  final bool external;
}

/// Where to put Red Panda's quick-capture buttons; one line each until opened.
class QuickCapturePage extends StatelessWidget {
  const QuickCapturePage({super.key, this.onNagSettings, this.onBasketSettings, this.open});

  /// Title of a spot to show unfolded.
  final String? open;
  final VoidCallback? onNagSettings;
  final VoidCallback? onBasketSettings;

  static const spots = [
    CaptureSpot(
      Icons.lock_outline,
      'Lock Screen buttons',
      'Long-press the Lock Screen, tap Customise > Lock Screen, tap a control slot at the bottom and '
          "pick Red Panda > Text note, Voice note or Show Panda's basket.",
      'lock_screen',
      [CaptureLink.microphone],
    ),
    CaptureSpot(
      Icons.widgets_outlined,
      'Widgets',
      'Customise the Lock Screen and tap the widget area under the clock (or the line above it) to add '
          'the Red Panda widget with your next deadline. On the Home Screen, long-press, tap Edit > '
          "Add Widget and search \"Red Panda\": its buttons add a note or show Panda's basket.",
      'widgets',
      [CaptureLink.nag, CaptureLink.basket],
    ),
    CaptureSpot(
      Icons.tune,
      'Control Centre',
      'Open Control Centre, tap +, Add a Control, search "Red Panda".',
      'control_centre',
      [CaptureLink.microphone, CaptureLink.basket],
    ),
    CaptureSpot(
      Icons.radio_button_checked,
      'Action Button',
      "Settings > Action Button > Controls, then choose Red Panda > Text note, Voice note or Show "
          "Panda's basket.",
      'action_button',
      [CaptureLink.microphone],
    ),
    CaptureSpot(
      Icons.record_voice_over_outlined,
      'Siri',
      'Say "Note with Red Panda", "Voice note with Red Panda" or "Show my Red Panda basket".',
      'siri',
      [CaptureLink.siri],
    ),
  ];

  void _open(BuildContext context, CaptureLink l) {
    switch (l) {
      case CaptureLink.microphone || CaptureLink.siri:
        LeaveBasket.openSettings();
      case CaptureLink.nag:
        onNagSettings?.call();
      case CaptureLink.basket:
        onBasketSettings?.call();
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Quick capture')),
        body: ListView(
          children: [
            for (final spot in spots)
              ExpansionTile(
                initiallyExpanded: spot.title == open,
                leading: Icon(spot.icon),
                title: Text(spot.title, maxLines: 1, overflow: TextOverflow.ellipsis),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                expandedCrossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/quick_capture/${spot.image}.png',
                      height: 150,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      semanticLabel: '${spot.title} preview',
                      errorBuilder: (_, _, _) => const SizedBox.shrink(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(spot.how),
                  for (final l in spot.links)
                    TextButton.icon(
                      icon: Icon(l.icon, size: 18),
                      label: Text(l.label),
                      iconAlignment: IconAlignment.start,
                      onPressed: () => _open(context, l),
                    ),
                ],
              ),
          ],
        ),
      );
}

/// What's new per version, with a link to each pull request.
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('News')),
        body: ListView(
          children: [
            for (final (i, n) in news.indexed) ...[
              ListTile(
                title: Text('Version ${n.version}${i == 0 ? ' · new' : ''}',
                    style: Theme.of(context).textTheme.titleMedium),
                trailing: TextButton.icon(
                  icon: const Icon(Icons.open_in_new, size: 16),
                  label: Text('PR #${n.pr}'),
                  onPressed: () => ShortcutsLinks.openExternal(n.url),
                ),
              ),
              for (final item in n.items)
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 16, 6),
                  child: Text('• $item'),
                ),
            ],
          ],
        ),
      );
}

/// A one-line setting: title on the left, current value and a chevron (or
/// an open-elsewhere arrow) on the right.
class SettingRow extends StatelessWidget {
  const SettingRow({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
    this.page = false,
    this.external = false,
    this.enabled = true,
    this.warn = false,
    this.iconColor,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String value;
  final VoidCallback onTap;

  /// Opens a page (chevron) rather than a drawer.
  final bool page;

  /// Leaves the app (iOS Settings, Shortcuts).
  final bool external;
  final bool enabled;
  final bool warn;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final valueStyle = TextStyle(color: warn ? scheme.error : scheme.onSurfaceVariant);
    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: enabled ? iconColor : null),
      title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 170),
            child: Text(value, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 4),
          Icon(
            external ? Icons.open_in_new : (page ? Icons.chevron_right : Icons.unfold_more),
            size: 18,
            color: scheme.onSurfaceVariant,
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}

/// A drawer from the bottom with a title, an optional note and [builder]'s
/// children; pops with the picked value.
Future<T?> showSettingsDrawer<T>(
  BuildContext context, {
  required String title,
  String? note,
  required List<Widget> Function(BuildContext) builder,
}) =>
    showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(ctx).height * 0.8),
          child: ListView(
            shrinkWrap: true,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
                child: Text(title, style: Theme.of(ctx).textTheme.titleMedium),
              ),
              if (note != null) _Note(note),
              ...builder(ctx),
            ],
          ),
        ),
      ),
    );

class _ChoiceTile extends StatelessWidget {
  const _ChoiceTile({required this.selected, required this.title, this.subtitle, required this.onTap});
  final bool selected;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
        dense: subtitle != null,
        selected: selected,
        leading: Icon(selected ? Icons.radio_button_checked : Icons.radio_button_unchecked),
        title: Text(title),
        subtitle: subtitle == null ? null : Text(subtitle!),
        onTap: onTap,
      );
}

class _Header extends StatelessWidget {
  const _Header(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
        child: Text(text,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Theme.of(context).colorScheme.primary)),
      );
}

class _Note extends StatelessWidget {
  const _Note(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
        child: Text(text, style: Theme.of(context).textTheme.bodySmall),
      );
}
