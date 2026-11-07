import 'package:flutter/material.dart';

import '../gamification/bamboo.dart';
import '../models/app_settings.dart';
import '../platform/leave_basket.dart';
import '../platform/shortcuts_links.dart';
import '../storage/note_store.dart';

/// Settings: one line per setting. Choices open in a drawer (bottom sheet),
/// groups (leave basket, quick capture) on their own page.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key, required this.store});
  final NoteStore store;

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

  @override
  Widget build(BuildContext context) {
    final s = _s;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                const _Header('List'),
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
                  onTap: () => Navigator.of(context)
                      .push(MaterialPageRoute(builder: (_) => const QuickCapturePage())),
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

/// Where to put Red Panda's quick-capture buttons; one line each until opened.
class QuickCapturePage extends StatelessWidget {
  const QuickCapturePage({super.key});

  static const _steps = [
    (
      Icons.lock_outline,
      'Lock Screen buttons',
      'Long-press the Lock Screen, tap Customise > Lock Screen, tap a control slot at the bottom and '
          'pick Red Panda > Text note or Voice note.',
    ),
    (
      Icons.widgets_outlined,
      'Widgets',
      'Customise the Lock Screen and tap the widget area under the clock (or the line above it) to add '
          'the Red Panda widget with your next deadline. On the Home Screen, long-press, tap Edit > '
          'Add Widget and search "Red Panda".',
    ),
    (Icons.tune, 'Control Centre', 'Open Control Centre, tap +, Add a Control, search "Red Panda".'),
    (
      Icons.radio_button_checked,
      'Action Button',
      'Settings > Action Button > Controls, then choose Red Panda > Text note or Voice note.',
    ),
    (Icons.record_voice_over_outlined, 'Siri', 'Say "Note with Red Panda" or "Voice note with Red Panda".'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Quick capture')),
        body: ListView(
          children: [
            for (final (icon, title, body) in _steps)
              ExpansionTile(
                leading: Icon(icon),
                title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                childrenPadding: const EdgeInsets.fromLTRB(72, 0, 16, 12),
                expandedAlignment: Alignment.centerLeft,
                children: [Text(body)],
              ),
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
  });

  final IconData icon;
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
      leading: Icon(icon),
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
