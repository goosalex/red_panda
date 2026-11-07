import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../gamification/bamboo.dart';
import '../gamification/progress.dart';
import '../logic/note_order.dart';
import '../models/app_settings.dart';
import '../models/category.dart';
import '../models/note.dart';
import '../platform/compose_requests.dart';
import '../platform/leave_basket.dart';
import '../platform/motion.dart';
import '../platform/reminders.dart';
import '../platform/share.dart';
import '../platform/voice_recording.dart';
import '../storage/note_store.dart';
import 'category_clouds.dart';
import 'confetti.dart';
import 'days_dial.dart';
import 'leave_basket_button.dart';
import 'note_editor.dart';
import 'note_tile.dart';
import 'panda/panda_stage.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});
  final NoteStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _stage = PandaStageController();
  final _confetti = GlobalKey<ConfettiState>();
  final _scroll = ScrollController();
  final _listKey = GlobalKey();

  List<Note> _notes = const [];
  List<Category> _categories = const [];
  AppSettings _settings = const AppSettings();
  BambooWallet _wallet = const BambooWallet();

  String? _filterId;
  bool _basketOnly = false;
  LeaveStatus _leave = const LeaveStatus();
  String _query = '';
  bool _searching = false;
  bool _showSnoozed = false;
  bool _composing = false;
  Stream<Offset>? _tilt;
  Timer? _autoScroll;
  Timer? _nagDebounce;

  /// Set while a voice note records (from the mic button or the control).
  DateTime? _recordingSince;
  bool _recordBusy = false;
  Timer? _ticker;

  Progress get _progress => Progress.from(_notes);
  List<Note> get _open => _notes.where((n) => !n.isDone).toList();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ComposeRequests.listen(_checkCompose,
        onNotesChanged: _reload, onRecordingChanged: _syncRecording);
    _syncRecording();
    _reload(greet: true).then((_) => _checkCompose());
    Transcripts.transcribePending();
  }

  @override
  void dispose() {
    ComposeRequests.stopListening();
    _ticker?.cancel();
    _autoScroll?.cancel();
    _nagDebounce?.cancel();
    _scroll.dispose();
    _stage.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Notes captured from the Lock Screen land on disk while we are away.
    if (state == AppLifecycleState.resumed) {
      _reload(greet: true);
      _checkCompose();
      _syncRecording();
      Transcripts.transcribePending();
    }
  }

  // ---------------------------------------------------------------- loading

  Future<void> _reload({bool greet = false}) async {
    final store = widget.store;
    final results = await Future.wait([
      store.loadAll(),
      store.loadCategories(),
      store.loadSettings(),
      store.loadWallet(),
    ]);
    if (!mounted) return;
    final notes = results[0] as List<Note>;
    final categories = results[1] as List<Category>;
    setState(() {
      _notes = notes;
      _categories = categories;
      _settings = results[2] as AppSettings;
      _wallet = results[3] as BambooWallet;
      if (_filterId != null && !categories.any((c) => c.id == _filterId)) _filterId = null;
    });
    _updateMood();
    if (greet) _stage.greet();
    _scheduleNag();
    _syncBasket();
  }

  /// Hands the open basket items to the native leave reminder: arms it at
  /// the current place when the basket gets its first item, disarms it when
  /// the basket is empty.
  Future<void> _syncBasket({bool rearmHere = false}) async {
    final status = await LeaveBasket.sync(
      titles: basketTitles(_notes, DateTime.now()),
      radiusMeters: _settings.leaveRadiusMeters,
      onPlace: _settings.leaveOnPlace,
      onWifi: _settings.leaveOnWifi,
      rearmHere: rearmHere,
    );
    if (mounted) setState(() => _leave = status);
  }

  Future<void> _toggleBasket(Note n) async {
    final into = !n.leaveBasket;
    await widget.store.save(n.copyWith(leaveBasket: into));
    if (into) await _ensureNotifications();
    await _reload();
    _say(into
        ? 'In the leave basket 🧺 The panda reminds you when you leave this place.'
        : 'Out of the leave basket.');
  }

  Future<void> _basketSheet() async {
    final s = _settings;
    final count = basketTitles(_notes, DateTime.now()).length;
    final l = _leave;
    final triggers = [
      if (s.leaveOnPlace) 'you move more than ${s.leaveRadiusMeters} m away',
      if (s.leaveOnWifi) 'your Wi-Fi drops',
    ].join(' or ');
    final String status;
    if (count == 0) {
      status = 'The basket is empty. Drag items into it to be reminded about them when you leave.';
    } else if (s.leaveOnPlace &&
        (l.permission == LocationPermission.denied || l.permission == LocationPermission.notDetermined)) {
      status = 'Red Panda needs your location to notice when you leave. Allow it in Settings.';
    } else if (l.armed) {
      final at = l.armedAt == null ? '' : ' (since ${TimeOfDay.fromDateTime(l.armedAt!).format(context)})';
      status = 'Watching$at: you get a reminder when $triggers.';
    } else {
      status = 'Not watching right now. Tap "Watch from here" to start.';
    }
    final needsAlways = s.leaveOnPlace && count > 0 && l.permission == LocationPermission.whenInUse;
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('🧺 Leave basket · $count', style: Theme.of(ctx).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(status),
              if (needsAlways) ...[
                const SizedBox(height: 8),
                const Text('To notice leaving while Red Panda is closed, set Location to "Always" in Settings.'),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (count > 0)
                    FilledButton.icon(
                      icon: const Icon(Icons.my_location),
                      label: const Text('Watch from here'),
                      onPressed: () => Navigator.pop(ctx, 'here'),
                    ),
                  if (needsAlways ||
                      l.permission == LocationPermission.denied)
                    OutlinedButton(
                      onPressed: () => Navigator.pop(ctx, 'settings'),
                      child: const Text('Open Settings'),
                    ),
                  if (count > 0)
                    TextButton(
                      onPressed: () => Navigator.pop(ctx, 'empty'),
                      child: const Text('Empty the basket'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
    switch (action) {
      case 'here':
        await _syncBasket(rearmHere: true);
        _say(_leave.armed ? 'Watching from here 📍' : "Couldn't get your location.");
      case 'settings':
        await LeaveBasket.openSettings();
      case 'empty':
        await widget.store.saveAll([
          for (final n in _notes)
            if (n.leaveBasket) n.copyWith(leaveBasket: false),
        ]);
        await _reload();
    }
  }

  /// Idle panda: sleeps, or sits there sad while something is overdue.
  void _updateMood() {
    final s = dueSummary(_notes, DateTime.now());
    _stage.idlePose = s.overdue > 0 ? PandaPose.sad : PandaPose.sleeping;
  }

  /// Hands the open items to the native reminder scheduler and refreshes the
  /// widgets (debounced: reloads come in bursts).
  void _scheduleNag() {
    _nagDebounce?.cancel();
    _nagDebounce = Timer(const Duration(milliseconds: 400), () {
      final now = DateTime.now();
      final items = [
        for (final n in _notes)
          if (!n.isDone && !n.isSnoozed(now))
            ReminderItem(id: n.id, title: n.title, dueAt: n.dueAt, remindAt: n.remindAt),
      ];
      Reminders.schedule(items,
          intensity: _settings.nagIntensity.index,
          quietStartHour: _settings.quietStartHour,
          quietEndHour: _settings.quietEndHour);
      Reminders.reloadWidgets();
    });
  }

  /// Asks for notification permission the first time a deadline or
  /// reminder is set (not on first launch, when it would be out of context).
  Future<void> _ensureNotifications() async {
    if (_settings.nagIntensity == NagIntensity.off) return;
    await Reminders.requestPermission();
  }

  Future<void> _saveWallet(BambooWallet w) async {
    setState(() => _wallet = w);
    await widget.store.saveWallet(w);
  }

  void _say(String text, {SnackBarAction? action}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(text), action: action));
  }

  // ---------------------------------------------------------- compose / edit

  /// Opens the compose sheet if the Text note control asked for it.
  Future<void> _checkCompose() async {
    // Always take (clear) the request, so a tap while the sheet is already
    // open doesn't reopen it later.
    final wanted = await ComposeRequests.take();
    if (wanted && !_composing && mounted) await _addText();
  }

  void _onTyping(bool typing) {
    if (typing) {
      _tilt ??= Motion.tilt().asBroadcastStream();
      setState(() {});
      _stage.startTyping();
    } else {
      _stage.stopTyping();
      setState(() => _tilt = null);
    }
  }

  Future<void> _addText() async {
    if (_composing) return;
    _composing = true;
    try {
      final draft = await showNoteEditor(
        context,
        categories: _categories,
        initialCategoryId: _filterId,
        initialLeaveBasket: _basketOnly,
        onTyping: _onTyping,
      );
      if (draft == null) return;
      final due = draft.days == null ? null : endOfDayIn(draft.days!, DateTime.now());
      final added = await widget.store.addText(draft.text, dueAt: due, categoryId: draft.categoryId);
      if (draft.leaveBasket) await widget.store.save(added.copyWith(leaveBasket: true));
      if (due != null) await _ensureNotifications();
      await _reload();
    } finally {
      _composing = false;
    }
  }

  Future<void> _edit(Note n) async {
    final now = DateTime.now();
    final before = n.daysLeft(now);
    final draft = await showNoteEditor(
      context,
      note: n,
      categories: _categories,
      onTyping: _onTyping,
    );
    if (draft == null) return;
    var updated = n.copyWith(
      text: draft.text,
      categoryId: draft.categoryId,
      clearCategory: draft.categoryId == null,
      leaveBasket: draft.leaveBasket,
    );
    if (draft.days == null) {
      updated = updated.copyWith(clearDue: true);
    } else if (draft.days != (before != null && before < 0 ? 0 : before)) {
      updated = updated.copyWith(dueAt: endOfDayIn(draft.days!, now));
      await _ensureNotifications();
    }
    await widget.store.save(updated);
    await _reload();
  }

  // ------------------------------------------------------------ ticking off

  Future<void> _toggle(Note n) async {
    final now = DateTime.now();
    if (n.isDone) {
      await widget.store.save(n.copyWith(clearDone: true));
      HapticFeedback.lightImpact();
      await _reload();
      return;
    }
    final before = _progress.streakDays;
    final done = n.copyWith(doneAt: now, clearRemind: true);
    await widget.store.save(done);
    final owed = _wallet.rewardFor(n, now);
    final (wallet, earned) = _wallet.complete(n, now);
    if (earned > 0 || wallet != _wallet) await _saveWallet(wallet);
    await _reload();
    HapticFeedback.mediumImpact();
    SystemSound.play(SystemSoundType.click);
    _stage.celebrate();
    _confetti.currentState?.burst();
    final p = _progress;
    if (p.streakDays != before && p.isMilestone) {
      _say('${p.streakDays}-day streak! The panda is proud.');
    } else if (earned > 0) {
      _say('+$earned 🎋 bamboo for the panda (${_wallet.balance} in the stash)');
    } else if (owed > 0) {
      _say('The bamboo stash is full (${BambooWallet.cap}). Snooze something, or keep going!');
    }
  }

  Future<void> _delete(Note n) async {
    setState(() => _notes = _notes.where((x) => x.id != n.id).toList());
    await widget.store.delete(n, keepAudio: true);
    var undone = false;
    if (!mounted) return;
    final ctl = ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar();
    final bar = ctl.showSnackBar(SnackBar(
      content: const Text('Deleted'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          undone = true;
          await widget.store.save(n);
          await _reload();
        },
      ),
    ));
    await bar.closed;
    if (!undone) {
      await widget.store.delete(n); // now also the recording
      await _reload();
    }
  }

  // ----------------------------------------------------------- swipe right

  /// Left-to-right swipe. Always returns false: the row springs back, and
  /// items that leave the list (snooze) are gone after the reload.
  Future<bool> _swipeRight(Note n) async {
    final now = DateTime.now();
    if (n.isDone) {
      await _toggle(n); // undo check
      return false;
    }
    if (n.isSnoozed(now)) {
      await widget.store.save(n.copyWith(clearSnooze: true));
      await _reload();
      _say('Woken up early.');
      return false;
    }
    switch (_settings.swipeAction) {
      case SwipeAction.snooze:
        await _snooze(n);
      case SwipeAction.postpone:
        await _postpone(n);
      case SwipeAction.pin:
        await widget.store.save(n.copyWith(rank: topRank(_open)));
        await _reload();
      case SwipeAction.category:
        await _pickCategory(n);
      case SwipeAction.deadline:
        await _pickDeadline(n);
      case SwipeAction.remindLater:
        final at = now.add(const Duration(hours: 3));
        final time = TimeOfDay.fromDateTime(at).format(context);
        await widget.store.save(n.copyWith(remindAt: at));
        await _ensureNotifications();
        await _reload();
        _say('The panda will nudge you at $time.');
      case SwipeAction.duplicate:
        await widget.store.save(n.duplicate(NoteStore.newId(), now));
        await _reload();
      case SwipeAction.share:
        await NoteShare.share(n.title);
      case SwipeAction.basket:
        await _toggleBasket(n);
    }
    return false;
  }

  Future<void> _snooze(Note n) async {
    final paid = _wallet.spend(BambooWallet.snoozeCost);
    if (paid == null) {
      _stage.greet();
      _say('Not enough bamboo to snooze (needs ${BambooWallet.snoozeCost}, you have '
          '${_wallet.balance}). Finish a task to earn some 🎋');
      return;
    }
    final now = DateTime.now();
    final until = DateTime(now.year, now.month, now.day + 1, _settings.quietEndHour);
    await widget.store.save(n.copyWith(snoozedUntil: until));
    await _saveWallet(paid);
    _say(
      'Snoozed until tomorrow · −${BambooWallet.snoozeCost} 🎋',
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () async {
          await widget.store.save(n.copyWith(clearSnooze: true));
          await _saveWallet(_wallet.spend(-BambooWallet.snoozeCost) ?? _wallet);
          await _reload();
        },
      ),
    );
    await _reload();
  }

  Future<void> _postpone(Note n) async {
    final now = DateTime.now();
    final cost = BambooWallet.postponeCost(n, now);
    final paid = _wallet.spend(cost);
    if (paid == null) {
      _say('Postponing this close to the deadline costs $cost 🎋, and the stash is empty.');
      return;
    }
    final base = n.dueAt == null || n.dueAt!.isBefore(now) ? endOfDayIn(0, now) : n.dueAt!.toLocal();
    final due = DateTime(base.year, base.month, base.day + 1, 23, 59, 59);
    await widget.store.save(n.copyWith(dueAt: due));
    if (cost > 0) await _saveWallet(paid);
    await _reload();
    _say('Deadline moved to ${DaysDial.label(n.copyWith(dueAt: due).daysLeft(now))}'
        '${cost > 0 ? ' · −$cost 🎋' : ''}');
  }

  Future<void> _pickDeadline(Note n) async {
    final now = DateTime.now();
    final start = n.daysLeft(now);
    int? days = start == null ? 1 : (start < 0 ? 0 : start);
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          title: Text(DaysDial.label(days)),
          content: Center(
            heightFactor: 1,
            child: DaysDial(days: days, size: 160, onChanged: (d) => setLocal(() => days = d)),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
            FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Set')),
          ],
        ),
      ),
    );
    if (ok != true) return;
    await widget.store.save(days == null ? n.copyWith(clearDue: true) : n.copyWith(dueAt: endOfDayIn(days!, now)));
    if (days != null) await _ensureNotifications();
    await _reload();
  }

  Future<void> _pickCategory(Note n) async {
    if (_categories.isEmpty) {
      _say('No clouds yet. Tap "+ category" next to the panda.');
      return;
    }
    final picked = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final c in _categories)
              ListTile(
                leading: CircleAvatar(backgroundColor: c.color, radius: 10),
                title: Text(c.name),
                selected: n.categoryId == c.id,
                onTap: () => Navigator.pop(ctx, c.id),
              ),
            ListTile(
              leading: const Icon(Icons.cloud_off_outlined),
              title: const Text('No category'),
              onTap: () => Navigator.pop(ctx, ''),
            ),
          ],
        ),
      ),
    );
    if (picked == null) return;
    await widget.store.save(picked.isEmpty ? n.copyWith(clearCategory: true) : n.copyWith(categoryId: picked));
    await _reload();
  }

  // ------------------------------------------------------- drag and drop

  Future<void> _dropOnItem(Note dropped, Note target, bool below, List<Note> visibleOpen) async {
    final shown = visibleOpen.where((n) => n.id != dropped.id).toList();
    final i = shown.indexWhere((n) => n.id == target.id);
    if (i < 0) return;
    final changed = reorder(_open, visibleOpen, dropped, below ? i + 1 : i);
    if (changed.isEmpty) return;
    // Show the new order right away, then persist.
    final byId = {for (final c in changed) c.id: c};
    setState(() => _notes = [for (final n in _notes) byId[n.id] ?? n]);
    await widget.store.saveAll(changed);
  }

  Future<void> _dropOnCloud(Note n, Category c) async {
    await widget.store.save(n.copyWith(categoryId: c.id));
    await _reload();
    _say('Filed under ${c.name} ☁️');
  }

  /// Scrolls the list while an item is dragged near its top or bottom edge.
  void _onDragUpdate(DragUpdateDetails d) {
    final box = _listKey.currentContext?.findRenderObject() as RenderBox?;
    if (box == null || !_scroll.hasClients) return;
    final y = box.globalToLocal(d.globalPosition).dy;
    const edge = 56.0;
    double speed = 0;
    if (y < edge && y > -edge) speed = -(edge - y) / 4;
    if (y > box.size.height - edge) speed = (y - (box.size.height - edge)) / 4;
    _autoScroll?.cancel();
    if (speed == 0) return;
    _autoScroll = Timer.periodic(const Duration(milliseconds: 16), (_) {
      final p = _scroll.position;
      final next = (p.pixels + speed).clamp(p.minScrollExtent, p.maxScrollExtent);
      if (next == p.pixels) return _autoScroll?.cancel();
      _scroll.jumpTo(next);
    });
  }

  void _onDragEnd() => _autoScroll?.cancel();

  // ------------------------------------------------------------ categories

  Future<void> _addCategory() async {
    final name = await _askName(title: 'New category cloud');
    if (name == null) return;
    final used = _categories.map((c) => c.color).toSet();
    final color = Category.palette.firstWhere((c) => !used.contains(c), orElse: () => Category.palette.first);
    final cats = [..._categories, Category(id: NoteStore.newId(), name: name, color: color)];
    await widget.store.saveCategories(cats);
    await _reload();
  }

  Future<void> _editCategory(Category c) async {
    final action = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(title: Text(c.name, style: Theme.of(ctx).textTheme.titleMedium)),
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Rename'),
              onTap: () => Navigator.pop(ctx, 'rename'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                spacing: 12,
                children: [
                  for (final (i, color) in Category.palette.indexed)
                    GestureDetector(
                      onTap: () => Navigator.pop(ctx, 'color$i'),
                      child: CircleAvatar(
                        backgroundColor: color,
                        radius: 16,
                        child: color == c.color ? const Icon(Icons.check, size: 16, color: Colors.black54) : null,
                      ),
                    ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Remove cloud'),
              subtitle: const Text('Its items stay, just without a category'),
              onTap: () => Navigator.pop(ctx, 'delete'),
            ),
          ],
        ),
      ),
    );
    if (action == null) return;
    var cats = [..._categories];
    if (action == 'rename') {
      final name = await _askName(title: 'Rename cloud', initial: c.name);
      if (name == null) return;
      cats = [for (final x in cats) x.id == c.id ? x.copyWith(name: name) : x];
    } else if (action.startsWith('color')) {
      final color = Category.palette[int.parse(action.substring(5))];
      cats = [for (final x in cats) x.id == c.id ? x.copyWith(color: color) : x];
    } else if (action == 'delete') {
      cats.removeWhere((x) => x.id == c.id);
      await widget.store.saveAll([
        for (final n in _notes)
          if (n.categoryId == c.id) n.copyWith(clearCategory: true),
      ]);
    }
    await widget.store.saveCategories(cats);
    await _reload();
  }

  Future<String?> _askName({required String title, String initial = ''}) async {
    final ctl = TextEditingController(text: initial);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctl,
          autofocus: true,
          maxLength: 14,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'e.g. Home, Work, Shopping'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, ctl.text), child: const Text('OK')),
        ],
      ),
    );
    ctl.dispose();
    final t = name?.trim();
    return t == null || t.isEmpty ? null : t;
  }

  // -------------------------------------------------------------- recording

  /// Mirrors the native recorder: it can also be started by the Voice note
  /// control and stopped from the Live Activity.
  Future<void> _syncRecording() async {
    final since = await VoiceRecording.startedAt();
    if (!mounted) return;
    _setRecording(since);
    if (since == null) _reload();
  }

  void _setRecording(DateTime? since) {
    _ticker?.cancel();
    _ticker = since == null
        ? null
        : Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
    setState(() => _recordingSince = since);
  }

  Future<void> _toggleRecording() async {
    if (_recordBusy) return;
    setState(() => _recordBusy = true);
    try {
      if (_recordingSince == null) {
        await VoiceRecording.start();
        HapticFeedback.mediumImpact();
        _setRecording(DateTime.now());
        _stage.startTyping(); // the panda listens
      } else {
        _setRecording(null);
        _stage.stopTyping();
        HapticFeedback.lightImpact();
        await VoiceRecording.stop();
        await _reload();
        _stage.greet();
      }
    } on RecordingException catch (e) {
      _stage.stopTyping();
      _say(e.error == RecordingError.noMicrophonePermission
          ? 'Red Panda needs the microphone. Allow it in Settings > Red Panda.'
          : "Couldn't start recording.");
    } finally {
      if (mounted) setState(() => _recordBusy = false);
    }
  }

  // ----------------------------------------------------------------- build

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final p = _progress;
    final visible = visibleNotes(_notes,
        now: now, categoryId: _filterId, query: _query, showSnoozed: _showSnoozed, basketOnly: _basketOnly);
    final basketCount = basketTitles(_notes, now).length;
    final visibleOpen = visible.where((n) => !n.isDone).toList();
    final snoozedCount = _notes.where((n) => !n.isDone && n.isSnoozed(now)).length;
    final summary = dueSummary(_notes, now);
    final counts = <String, int>{};
    for (final n in _notes) {
      if (!n.isDone && n.categoryId != null) counts[n.categoryId!] = (counts[n.categoryId!] ?? 0) + 1;
    }
    final catById = {for (final c in _categories) c.id: c};
    final filter = _filterId == null ? null : catById[_filterId];

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: _searching
                ? TextField(
                    autofocus: true,
                    decoration: const InputDecoration(hintText: 'Search', border: InputBorder.none),
                    onChanged: (v) => setState(() => _query = v),
                  )
                : const Text('Red Panda'),
            actions: [
              IconButton(
                icon: Icon(_searching ? Icons.close : Icons.search),
                tooltip: _searching ? 'Close search' : 'Search',
                onPressed: () => setState(() {
                  _searching = !_searching;
                  _query = '';
                }),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                tooltip: 'Settings',
                onPressed: () async {
                  await Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SettingsScreen(store: widget.store)));
                  await _reload();
                },
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RecordButton(since: _recordingSince, busy: _recordBusy, onPressed: _toggleRecording),
                FloatingActionButton(
                  heroTag: 'add',
                  tooltip: 'New text note',
                  onPressed: _addText,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          body: Column(
            children: [
              PandaStage(
                controller: _stage,
                restingHeight: 150,
                celebrationHeight: 320,
                tilt: _tilt,
                onTapPanda: _stage.greet,
                background: CategoryClouds(
                  categories: _categories,
                  selectedId: _filterId,
                  counts: counts,
                  onSelect: (id) => setState(() => _filterId = id),
                  onDropNote: _dropOnCloud,
                  onAdd: _addCategory,
                  onEdit: _editCategory,
                ),
                foreground: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: SkyButton(
                          filtered: _filterId != null || _basketOnly || _query.isNotEmpty || _showSnoozed,
                          onTap: () => setState(() {
                            _filterId = null;
                            _basketOnly = false;
                            _showSnoozed = false;
                          }),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 12, 8),
                        child: LeaveBasketButton(
                          count: basketCount,
                          armed: _leave.armed && basketCount > 0,
                          selected: _basketOnly,
                          onTap: () => setState(() => _basketOnly = !_basketOnly),
                          onLongPress: _basketSheet,
                          onDropNote: _toggleBasket,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _ProgressHeader(progress: p, bamboo: _wallet.balance, overdue: summary.overdue, dueToday: summary.dueToday),
              if (filter != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InputChip(
                    avatar: CircleAvatar(backgroundColor: filter.color, radius: 8),
                    label: Text('Only ${filter.name}'),
                    onDeleted: () => setState(() => _filterId = null),
                  ),
                ),
              if (_basketOnly)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: InputChip(
                    avatar: const Icon(Icons.shopping_basket_outlined, size: 18),
                    label: const Text('Only the leave basket'),
                    onPressed: _basketSheet,
                    onDeleted: () => setState(() => _basketOnly = false),
                  ),
                ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: _reload,
                  child: ListView(
                    key: _listKey,
                    controller: _scroll,
                    padding: const EdgeInsets.only(bottom: 96),
                    children: [
                      if (visible.isEmpty)
                        Padding(
                          padding: const EdgeInsets.all(32),
                          child: Text(
                            _basketOnly
                                ? 'The leave basket is empty. Drag items onto the basket to be reminded '
                                    'about them when you leave.'
                                : filter != null
                                ? 'Nothing in ${filter.name}. Drag an item onto its cloud, or tap the '
                                    '${SkyButton.isDay(now) ? 'sun' : 'moon'} to see everything.'
                                : 'No notes yet. Capture one from the Lock Screen or the Action Button, or tap +.',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      for (final n in visible)
                        _wrapOpen(
                          n,
                          visibleOpen,
                          Dismissible(
                            key: ValueKey(n.id),
                            background: _SwipeBackground.right(
                                n.isDone ? null : (n.isSnoozed(now) ? null : _settings.swipeAction),
                                undo: n.isDone),
                            secondaryBackground: const _SwipeBackground.delete(),
                            confirmDismiss: (dir) async =>
                                dir == DismissDirection.endToStart ? true : _swipeRight(n),
                            onDismissed: (dir) {
                              if (dir == DismissDirection.endToStart) _delete(n);
                            },
                            child: NoteTile(
                              note: n,
                              now: now,
                              category: catById[n.categoryId],
                              onToggle: () => _toggle(n),
                              onEdit: () => _edit(n),
                              onDragUpdate: _onDragUpdate,
                              onDragEnd: _onDragEnd,
                            ),
                          ),
                        ),
                      if (snoozedCount > 0)
                        Center(
                          child: TextButton.icon(
                            icon: const Text('💤'),
                            label: Text(_showSnoozed ? 'Hide snoozed' : '$snoozedCount snoozed · show'),
                            onPressed: () => setState(() => _showSnoozed = !_showSnoozed),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(child: IgnorePointer(child: Confetti(key: _confetti))),
      ],
    );
  }

  Widget _wrapOpen(Note n, List<Note> visibleOpen, Widget child) {
    if (n.isDone) return child;
    return ReorderTarget(
      key: ValueKey('drop-${n.id}'),
      note: n,
      onDrop: (dropped, below) => _dropOnItem(dropped, n, below, visibleOpen),
      child: child,
    );
  }
}

class _SwipeBackground extends StatelessWidget {
  const _SwipeBackground.right(this.action, {this.undo = false}) : delete = false;
  const _SwipeBackground.delete()
      : action = null,
        undo = false,
        delete = true;

  final SwipeAction? action;
  final bool undo;
  final bool delete;

  static IconData _icon(SwipeAction? a) => switch (a) {
        null => Icons.wb_sunny_outlined,
        SwipeAction.snooze => Icons.snooze,
        SwipeAction.postpone => Icons.update,
        SwipeAction.pin => Icons.push_pin_outlined,
        SwipeAction.category => Icons.cloud_outlined,
        SwipeAction.deadline => Icons.alarm_add_outlined,
        SwipeAction.remindLater => Icons.notifications_active_outlined,
        SwipeAction.duplicate => Icons.copy_outlined,
        SwipeAction.share => Icons.ios_share,
        SwipeAction.basket => Icons.shopping_basket_outlined,
      };

  @override
  Widget build(BuildContext context) {
    if (delete) {
      return Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      );
    }
    final label = undo ? 'Undo check' : (action == null ? 'Wake up' : action!.label);
    return Container(
      color: undo ? Colors.blueGrey.shade400 : const Color(0xFF6BAF5B),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      child: Row(
        children: [
          Icon(undo ? Icons.undo : _icon(action), color: Colors.white),
          const SizedBox(width: 8),
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({
    required this.progress,
    required this.bamboo,
    required this.overdue,
    required this.dueToday,
  });
  final Progress progress;
  final int bamboo;
  final int overdue;
  final int dueToday;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🔥 ${progress.streakDays}d', style: t.titleSmall),
              Text('✓ ${progress.tickedToday} today', style: t.titleSmall),
              Tooltip(
                message: 'Bamboo: earn it by finishing tasks, spend it on snoozes',
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, a) => ScaleTransition(scale: a, child: child),
                  child: Text('🎋 $bamboo', key: ValueKey(bamboo), style: t.titleSmall),
                ),
              ),
              Text('Lv ${progress.level}', style: t.titleSmall),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: progress.levelFraction, minHeight: 6),
          ),
          if (overdue > 0 || dueToday > 0)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                overdue > 0
                    ? '🥺 The panda is sad: $overdue overdue'
                    : '⏰ $dueToday due today. The panda is watching.',
                style: t.bodySmall?.copyWith(color: overdue > 0 ? scheme.error : scheme.onSurfaceVariant),
              ),
            ),
        ],
      ),
    );
  }
}

/// Mic button: tap to record a voice note, tap again to stop and save it.
class _RecordButton extends StatelessWidget {
  const _RecordButton({required this.since, required this.busy, required this.onPressed});
  final DateTime? since;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final s = since;
    if (s == null) {
      return FloatingActionButton(
        heroTag: 'record',
        tooltip: 'Record a voice note',
        onPressed: busy ? null : onPressed,
        child: const Icon(Icons.mic),
      );
    }
    final elapsed = DateTime.now().difference(s);
    final seconds = elapsed.inSeconds.clamp(0, 359999);
    final label = '${seconds ~/ 60}:${(seconds % 60).toString().padLeft(2, '0')}';
    return FloatingActionButton.extended(
      heroTag: 'record',
      tooltip: 'Stop and save the voice note',
      backgroundColor: Colors.red.shade600,
      foregroundColor: Colors.white,
      onPressed: busy ? null : onPressed,
      icon: const Icon(Icons.stop),
      label: Text(label, style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()])),
    );
  }
}
