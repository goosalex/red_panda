import 'package:flutter/material.dart';

import '../gamification/bamboo.dart';
import '../l10n/l10n.dart';
import '../l10n/labels.dart';
import '../models/app_settings.dart';
import '../news.dart';
import '../platform/leave_basket.dart';
import '../platform/shortcuts_links.dart';
import '../storage/cloud_sync.dart';
import '../storage/note_store.dart';
import 'link_text.dart';
import 'walkthrough.dart';

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
    final l = context.l10n;
    final a = await showSettingsDrawer<SwipeAction>(
      context,
      title: l.settingsSwipeDrawerTitle,
      note: l.settingsSwipeDrawerNote,
      builder: (ctx) => [
        for (final a in SwipeAction.values)
          _ChoiceTile(
            selected: a == s.swipeAction,
            title: a.title(l),
            subtitle: a.info(l),
            onTap: () => Navigator.pop(ctx, a),
          ),
      ],
    );
    if (a != null) await _update(_s!.copyWith(swipeAction: a));
  }

  Future<void> _pickNag(AppSettings s) async {
    final l = context.l10n;
    final n = await showSettingsDrawer<NagIntensity>(
      context,
      title: l.settingsNag,
      note: l.settingsNagNote,
      builder: (ctx) => [
        for (final n in NagIntensity.values)
          _ChoiceTile(selected: n == s.nagIntensity, title: n.title(l), onTap: () => Navigator.pop(ctx, n)),
      ],
    );
    if (n != null) await _update(_s!.copyWith(nagIntensity: n));
  }

  Future<void> _pickCloud(AppSettings s) async {
    final l = context.l10n;
    final on = await showSettingsDrawer<bool>(
      context,
      title: l.settingsCloudSync,
      note: l.settingsCloudNote,
      builder: (ctx) => [
        _ChoiceTile(selected: s.icloudSync, title: l.settingsOn, onTap: () => Navigator.pop(ctx, true)),
        _ChoiceTile(selected: !s.icloudSync, title: l.settingsOff, onTap: () => Navigator.pop(ctx, false)),
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
        title: context.l10n.bambooTitle,
        builder: (ctx) => [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(bambooRulesText(ctx.l10n)),
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
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: s == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _Header(l.settingsHeaderList),
                ValueListenableBuilder(
                  valueListenable: cloud,
                  builder: (_, st, _) => SettingRow(
                    icon: Icons.cloud_outlined,
                    title: l.settingsCloudSync,
                    value: s.icloudSync ? st.label(l) : l.settingsOff,
                    warn: s.icloudSync && (st.state == CloudState.unavailable || st.state == CloudState.failed),
                    onTap: () => _pickCloud(s),
                  ),
                ),
                SettingRow(
                  icon: Icons.swipe_right_outlined,
                  title: l.settingsSwipeRight,
                  value: s.swipeAction.title(l),
                  onTap: () => _pickSwipe(s),
                ),
                _Header(l.settingsHeaderReminders),
                SettingRow(
                  icon: Icons.notifications_outlined,
                  title: l.settingsNag,
                  value: s.nagIntensity.title(l),
                  onTap: () => _pickNag(s),
                ),
                SettingRow(
                  icon: Icons.bedtime_outlined,
                  title: l.settingsQuietFrom,
                  value: hourLabel(s.quietStartHour),
                  onTap: () => _pickHour(s.quietStartHour, (h) => _s!.copyWith(quietStartHour: h)),
                ),
                SettingRow(
                  icon: Icons.wb_twilight_outlined,
                  title: l.settingsQuietUntil,
                  value: hourLabel(s.quietEndHour),
                  onTap: () => _pickHour(s.quietEndHour, (h) => _s!.copyWith(quietEndHour: h)),
                ),
                SettingRow(
                  icon: Icons.shopping_basket_outlined,
                  title: l.settingsLeaveBasket,
                  value: basketSummary(s, l),
                  page: true,
                  onTap: _openBasket,
                ),
                _Header(l.settingsHeaderPanda),
                SettingRow(
                  icon: Icons.grass_outlined,
                  title: l.settingsBambooRules,
                  value: l.settingsBambooMax(BambooWallet.cap),
                  onTap: _showBamboo,
                ),
                SettingRow(
                  icon: Icons.bolt_outlined,
                  title: l.settingsQuickCapture,
                  value: l.settingsQuickCaptureValue,
                  page: true,
                  onTap: _openQuickCapture,
                ),
                SettingRow(
                  icon: Icons.campaign_outlined,
                  title: l.settingsNews,
                  value: l.newsVersion(news.first.version),
                  page: true,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const NewsPage())),
                ),
              ],
            ),
    );
  }
}

String hourLabel(int h) => '${h.toString().padLeft(2, '0')}:00';

/// The bamboo rules drawer text, with the numbers from [BambooWallet].
String bambooRulesText(AppLocalizations l) => l.bambooRules(
      BambooWallet.perCompletion,
      BambooWallet.earlyBonus,
      BambooWallet.snoozeCost,
      BambooWallet.freePostponeDays,
      BambooWallet.latePostponeCost,
      BambooWallet.cap,
    );

String radiusLabel(int m) => m >= 1000 ? '${m ~/ 1000} km' : '$m m';

/// One-line summary of the leave basket triggers, e.g. "50 m · Wi-Fi".
String basketSummary(AppSettings s, AppLocalizations l) {
  final parts = [
    if (s.leaveOnPlace) radiusLabel(s.leaveRadiusMeters),
    if (s.leaveOnWifi) l.wifi,
  ];
  return parts.isEmpty ? l.settingsOff : parts.join(' · ');
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
    final l = context.l10n;
    final m = await showSettingsDrawer<int>(
      context,
      title: l.basketRadiusTitle,
      note: l.basketRadiusNote,
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

  static String _permissionLabel(LocationPermission? p, AppLocalizations l) => switch (p) {
        LocationPermission.always => l.locationAlways,
        LocationPermission.whenInUse => l.locationWhileUsing,
        LocationPermission.denied => l.settingsOff,
        LocationPermission.notDetermined => l.locationNotAsked,
        _ => '—',
      };

  @override
  Widget build(BuildContext context) {
    final s = _s;
    final permission = _status?.permission;
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.basketTitle)),
      body: ListView(
        children: [
          _Note(l.basketNote),
          SwitchListTile(
            secondary: const Icon(Icons.directions_walk),
            title: Text(l.basketOnPlace, maxLines: 1, overflow: TextOverflow.ellipsis),
            value: s.leaveOnPlace,
            onChanged: (v) => _set(s.copyWith(leaveOnPlace: v)),
          ),
          SettingRow(
            icon: Icons.radar,
            title: l.basketRadius,
            value: radiusLabel(s.leaveRadiusMeters),
            enabled: s.leaveOnPlace,
            onTap: _pickRadius,
          ),
          SwitchListTile(
            secondary: const Icon(Icons.wifi_off),
            title: Text(l.basketOnWifi, maxLines: 1, overflow: TextOverflow.ellipsis),
            value: s.leaveOnWifi,
            onChanged: (v) => _set(s.copyWith(leaveOnWifi: v)),
          ),
          SettingRow(
            icon: Icons.location_on_outlined,
            title: l.basketLocationAccess,
            value: _permissionLabel(permission, l),
            warn: s.leaveOnPlace && permission != null && permission != LocationPermission.always &&
                permission != LocationPermission.unknown,
            link: true,
            onTap: () => showWalkthrough(context, Walkthrough.location),
          ),
          SettingRow(
            icon: Icons.info,
            iconColor: Colors.blue,
            title: l.basketWhyAlways,
            value: l.basketNoTracking,
            onTap: () => showLocationInfo(context),
          ),
          _Header(l.basketHeaderShortcuts),
          _Note(l.basketShortcutsNote),
          SettingRow(
            icon: Icons.wifi,
            title: AutomationGuide.wifi.title(l),
            value: l.automationSetUp,
            onTap: () => showAutomationGuide(context, AutomationGuide.wifi),
          ),
          SettingRow(
            icon: Icons.home_outlined,
            title: AutomationGuide.place.title(l),
            value: l.automationSetUp,
            onTap: () => showAutomationGuide(context, AutomationGuide.place),
          ),
          SettingRow(
            icon: Icons.checklist,
            title: l.automationMine,
            value: l.shortcutsApp,
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
/// The steps name the Shortcuts app's buttons as iOS shows them in each
/// language.
enum AutomationGuide {
  wifi,
  place;

  String title(AppLocalizations l) => switch (this) {
        AutomationGuide.wifi => l.automationWifi,
        AutomationGuide.place => l.automationPlace,
      };

  List<String> steps(AppLocalizations l) => [
        l.guideOpenShortcuts,
        ...switch (this) {
          AutomationGuide.wifi => [l.guideWifiScroll, l.guideWifiNetwork],
          AutomationGuide.place => [l.guidePlaceLeave],
        },
        l.guideRunImmediately,
        // The action's name as Shortcuts shows it (ShortcutsLinks.remindAction
        // in English).
        l.guideAddAction(l.shortcutsRemindAction),
        l.guideDone,
      ];
}

Future<void> showAutomationGuide(BuildContext context, AutomationGuide g) => showSettingsDrawer<void>(
      context,
      title: g.title(context.l10n),
      builder: (ctx) => [
        for (final (i, step) in g.steps(ctx.l10n).indexed)
          ListTile(
            dense: true,
            leading: CircleAvatar(radius: 12, child: Text('${i + 1}', style: const TextStyle(fontSize: 12))),
            title: Text(step),
          ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: FilledButton.icon(
            icon: const Icon(Icons.open_in_new),
            label: Text(ctx.l10n.shortcutsOpen),
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
      title: context.l10n.locationInfoTitle,
      builder: (ctx) {
        final l = ctx.l10n;
        return [
          _InfoPoint(Icons.door_front_door_outlined, l.locationInfoLeaveTitle, l.locationInfoLeaveBody),
          _InfoPoint(Icons.battery_full, l.locationInfoBatteryTitle, l.locationInfoBatteryBody),
          _InfoPoint(Icons.lock_outline, l.locationInfoPrivacyTitle, l.locationInfoPrivacyBody),
          _InfoPoint(Icons.wifi_off, l.locationInfoWifiTitle, l.locationInfoWifiBody),
        ];
      },
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
        subtitle: LinkText(body),
      );
}

/// A quick-capture spot: where to add Red Panda, a preview of how it looks
/// there, and links to the settings it uses.
enum CaptureSpot {
  lockScreen(Icons.lock_outline, 'lock_screen', [CaptureLink.microphone]),
  widgets(Icons.widgets_outlined, 'widgets', [CaptureLink.nag, CaptureLink.basket]),
  controlCentre(Icons.tune, 'control_centre', [CaptureLink.microphone, CaptureLink.basket]),
  actionButton(Icons.radio_button_checked, 'action_button', [CaptureLink.microphone]),
  siri(Icons.record_voice_over_outlined, 'siri', [CaptureLink.siri]);

  const CaptureSpot(this.icon, this.image, [this.links = const []]);
  final IconData icon;

  /// Preview image in assets/quick_capture/ (rendered from the real widgets).
  final String image;
  final List<CaptureLink> links;

  String title(AppLocalizations l) => switch (this) {
        CaptureSpot.lockScreen => l.captureLockScreen,
        CaptureSpot.widgets => l.captureWidgets,
        CaptureSpot.controlCentre => l.captureControlCentre,
        CaptureSpot.actionButton => l.captureActionButton,
        CaptureSpot.siri => l.captureSiri,
      };

  /// How to add it, with the iOS names in [l]'s language.
  String how(AppLocalizations l) => switch (this) {
        CaptureSpot.lockScreen => l.captureLockScreenHow,
        CaptureSpot.widgets => l.captureWidgetsHow,
        CaptureSpot.controlCentre => l.captureControlCentreHow,
        CaptureSpot.actionButton => l.captureActionButtonHow,
        CaptureSpot.siri => l.captureSiriHow,
      };
}

enum CaptureLink {
  microphone(Icons.mic_none, external: true),
  siri(Icons.record_voice_over_outlined, external: true),
  nag(Icons.notifications_outlined),
  basket(Icons.shopping_basket_outlined);

  const CaptureLink(this.icon, {this.external = false});
  final IconData icon;

  /// Shows the way in the iOS Settings app (a walkthrough), not an in-app page.
  final bool external;

  String label(AppLocalizations l) => switch (this) {
        CaptureLink.microphone => l.captureLinkMicrophone,
        CaptureLink.siri => l.captureLinkSiri,
        CaptureLink.nag => l.settingsNag,
        CaptureLink.basket => l.settingsLeaveBasket,
      };
}

/// Where to put Red Panda's quick-capture buttons; one line each until opened.
class QuickCapturePage extends StatelessWidget {
  const QuickCapturePage({super.key, this.onNagSettings, this.onBasketSettings, this.open});

  /// A spot to show unfolded.
  final CaptureSpot? open;
  final VoidCallback? onNagSettings;
  final VoidCallback? onBasketSettings;

  static const spots = CaptureSpot.values;

  void _open(BuildContext context, CaptureLink l) {
    switch (l) {
      case CaptureLink.microphone:
        showWalkthrough(context, Walkthrough.microphone);
      case CaptureLink.siri:
        showWalkthrough(context, Walkthrough.siri);
      case CaptureLink.nag:
        onNagSettings?.call();
      case CaptureLink.basket:
        onBasketSettings?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsQuickCapture)),
      body: ListView(
        children: [
          for (final spot in spots)
            ExpansionTile(
              initiallyExpanded: spot == open,
              leading: Icon(spot.icon),
              title: Text(spot.title(l), maxLines: 1, overflow: TextOverflow.ellipsis),
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
                    semanticLabel: l.capturePreview(spot.title(l)),
                    errorBuilder: (_, _, _) => const SizedBox.shrink(),
                  ),
                ),
                const SizedBox(height: 10),
                LinkText(spot.how(l)),
                for (final link in spot.links)
                  TextButton.icon(
                    icon: Icon(link.icon, size: 18),
                    label: Text(link.label(l)),
                    iconAlignment: IconAlignment.start,
                    style: link.external ? TextButton.styleFrom(foregroundColor: linkBlue) : null,
                    onPressed: () => _open(context, link),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// What's new per version, with a link to each pull request; the lines in
/// the app's language (English where one is missing).
class NewsPage extends StatelessWidget {
  const NewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsNews)),
      body: ListView(
        children: [
          for (final (i, n) in news.indexed) ...[
            ListTile(
              title: Text(i == 0 ? l.newsVersionNew(n.version) : l.newsVersion(n.version),
                  style: Theme.of(context).textTheme.titleMedium),
              trailing: TextButton.icon(
                icon: const Icon(Icons.open_in_new, size: 16),
                label: Text(l.newsPr(n.pr)),
                onPressed: () => ShortcutsLinks.openExternal(n.url),
              ),
            ),
            for (final item in n.itemsIn(l.localeName))
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 16, 6),
                child: Text('• $item'),
              ),
          ],
        ],
      ),
    );
  }
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
    this.link = false,
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

  /// Plays a walkthrough of the iOS Settings: the title is a blue link.
  final bool link;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final valueStyle = TextStyle(color: warn ? scheme.error : scheme.onSurfaceVariant);
    return ListTile(
      enabled: enabled,
      leading: Icon(icon, color: enabled ? iconColor : null),
      title: Text(title,
          maxLines: 1, overflow: TextOverflow.ellipsis, style: link && enabled ? const TextStyle(color: linkBlue) : null),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 170),
            child: Text(value, style: valueStyle, maxLines: 1, overflow: TextOverflow.ellipsis),
          ),
          const SizedBox(width: 4),
          Icon(
            link
                ? Icons.play_circle_outline
                : external
                    ? Icons.open_in_new
                    : (page ? Icons.chevron_right : Icons.unfold_more),
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
