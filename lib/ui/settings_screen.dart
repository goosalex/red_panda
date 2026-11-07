import 'package:flutter/material.dart';

import '../gamification/bamboo.dart';
import '../models/app_settings.dart';
import '../storage/note_store.dart';

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

  static int _nearestRadius(int m) => AppSettings.leaveRadiusChoices
      .reduce((a, b) => (a - m).abs() <= (b - m).abs() ? a : b);

  static String _radiusLabel(int m) => m >= 1000 ? '${m ~/ 1000} km' : '$m m';

  String _hour(int h) => '${h.toString().padLeft(2, '0')}:00';

  Future<void> _pickHour(int current, ValueChanged<int> onPicked) async {
    final t = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: current, minute: 0),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (t != null) onPicked(t.hour);
  }

  @override
  Widget build(BuildContext context) {
    final s = _s;
    final t = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Swipe right on an item', style: t.titleMedium),
                const Text('Ticked-off items always un-tick; snoozed items wake up.'),
                RadioGroup<SwipeAction>(
                  groupValue: s.swipeAction,
                  onChanged: (a) => a == null ? null : _update(s.copyWith(swipeAction: a)),
                  child: Column(
                    children: [
                      for (final a in SwipeAction.values)
                        RadioListTile<SwipeAction>(
                          value: a,
                          title: Text(a.label),
                          subtitle: Text(a.description),
                          dense: true,
                        ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                Text('Sad panda reminders', style: t.titleMedium),
                const Text('Notifications and widgets nag you as deadlines come closer.'),
                const SizedBox(height: 8),
                SegmentedButton<NagIntensity>(
                  segments: [
                    for (final n in NagIntensity.values) ButtonSegment(value: n, label: Text(n.label)),
                  ],
                  selected: {s.nagIntensity},
                  onSelectionChanged: (v) => _update(s.copyWith(nagIntensity: v.first)),
                ),
                const SizedBox(height: 4),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.bedtime_outlined),
                  title: const Text('Quiet hours'),
                  subtitle: Text('No nagging from ${_hour(s.quietStartHour)} to ${_hour(s.quietEndHour)}'),
                  trailing: Wrap(
                    spacing: 4,
                    children: [
                      OutlinedButton(
                        onPressed: () => _pickHour(s.quietStartHour, (h) => _update(s.copyWith(quietStartHour: h))),
                        child: Text(_hour(s.quietStartHour)),
                      ),
                      OutlinedButton(
                        onPressed: () => _pickHour(s.quietEndHour, (h) => _update(s.copyWith(quietEndHour: h))),
                        child: Text(_hour(s.quietEndHour)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 32),
                Text('🧺 Leave basket', style: t.titleMedium),
                const Text('Items in the basket remind you as soon as you leave the place where you '
                    'put them in, or your Wi-Fi drops.'),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('When I leave this place'),
                  subtitle: Text('More than ${s.leaveRadiusMeters} m away. Needs location "Always" to work '
                      'while Red Panda is closed.'),
                  value: s.leaveOnPlace,
                  onChanged: (v) => _update(s.copyWith(leaveOnPlace: v)),
                ),
                if (s.leaveOnPlace)
                  Row(
                    children: [
                      const Text('Radius'),
                      Expanded(
                        child: Slider(
                          value: AppSettings.leaveRadiusChoices.indexOf(_nearestRadius(s.leaveRadiusMeters)).toDouble(),
                          min: 0,
                          max: (AppSettings.leaveRadiusChoices.length - 1).toDouble(),
                          divisions: AppSettings.leaveRadiusChoices.length - 1,
                          label: _radiusLabel(s.leaveRadiusMeters),
                          onChanged: (v) => setState(
                              () => _s = s.copyWith(leaveRadiusMeters: AppSettings.leaveRadiusChoices[v.round()])),
                          onChangeEnd: (v) =>
                              _update(s.copyWith(leaveRadiusMeters: AppSettings.leaveRadiusChoices[v.round()])),
                        ),
                      ),
                      SizedBox(width: 56, child: Text(_radiusLabel(s.leaveRadiusMeters), textAlign: TextAlign.end)),
                    ],
                  ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('When my Wi-Fi drops'),
                  subtitle: const Text('Noticed while Red Panda is open or was just in use. For a '
                      'reliable trigger: Shortcuts > Automation > Wi-Fi > "Leaves", '
                      'run "Remind me of my leave basket" immediately.'),
                  value: s.leaveOnWifi,
                  onChanged: (v) => _update(s.copyWith(leaveOnWifi: v)),
                ),
                const Divider(height: 32),
                Text('Bamboo', style: t.titleMedium),
                const SizedBox(height: 4),
                Text(
                  'Every finished item feeds the panda ${BambooWallet.perCompletion} 🎋 '
                  '(+${BambooWallet.earlyBonus} when done before its deadline day). '
                  'Snoozing costs ${BambooWallet.snoozeCost} 🎋; postponing a deadline is free until '
                  '${BambooWallet.freePostponeDays} days before it, then costs ${BambooWallet.latePostponeCost} 🎋. '
                  'The stash holds at most ${BambooWallet.cap}.',
                ),
                const Divider(height: 32),
                Text('Quick capture', style: t.titleMedium),
                const SizedBox(height: 8),
                const _Step(
                  icon: Icons.lock_outline,
                  title: 'Lock Screen buttons',
                  body: 'Long-press the Lock Screen, tap Customize > Lock Screen, tap a control slot at the '
                      'bottom and pick Red Panda > Text note or Voice note.',
                ),
                const _Step(
                  icon: Icons.widgets_outlined,
                  title: 'Lock Screen and Home Screen widgets',
                  body: 'Customize the Lock Screen and tap the widget area under the clock (or the line '
                      'above it) to add the Red Panda widget with your next deadline. On the Home Screen, '
                      'long-press, tap Edit > Add Widget and search "Red Panda".',
                ),
                const _Step(
                  icon: Icons.tune,
                  title: 'Control Center',
                  body: 'Open Control Center, tap +, Add a Control, search "Red Panda".',
                ),
                const _Step(
                  icon: Icons.radio_button_checked,
                  title: 'Action Button',
                  body: 'Settings > Action Button > Controls, then choose Red Panda > Text note or Voice note.',
                ),
                const _Step(
                  icon: Icons.record_voice_over_outlined,
                  title: 'Siri',
                  body: 'Say "Note with Red Panda" or "Voice note with Red Panda".',
                ),
              ],
            ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.title, required this.body});
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(leading: Icon(icon), title: Text(title), subtitle: Text(body)),
      );
}
