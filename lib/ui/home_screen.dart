import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../gamification/progress.dart';
import '../models/note.dart';
import '../platform/compose_requests.dart';
import '../platform/voice_recording.dart';
import '../storage/note_store.dart';
import 'confetti.dart';
import 'mascot.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.store});
  final NoteStore store;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  final _mascot = MascotController();
  final _confetti = GlobalKey<ConfettiState>();
  List<Note> _notes = const [];
  String _query = '';
  bool _searching = false;
  bool _composing = false;

  /// Set while a voice note records (from the mic button or the control).
  DateTime? _recordingSince;
  bool _recordBusy = false;
  Timer? _ticker;

  Progress get _progress => Progress.from(_notes);

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

  /// Opens the compose sheet if the Text note control asked for it.
  Future<void> _checkCompose() async {
    // Always take (clear) the request, so a tap while the sheet is already
    // open doesn't reopen it later.
    final wanted = await ComposeRequests.take();
    if (wanted && !_composing && mounted) await _addText();
  }

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
      } else {
        _setRecording(null);
        HapticFeedback.lightImpact();
        await VoiceRecording.stop();
        await _reload();
        _mascot.celebrate();
      }
    } on RecordingException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.error == RecordingError.noMicrophonePermission
            ? 'Red Panda needs the microphone. Allow it in Settings > Red Panda.'
            : "Couldn't start recording."),
      ));
    } finally {
      if (mounted) setState(() => _recordBusy = false);
    }
  }

  Future<void> _reload({bool greet = false}) async {
    final notes = await widget.store.loadAll();
    if (!mounted) return;
    setState(() => _notes = notes);
    _mascot.streak = _progress.streakDays;
    if (greet) _mascot.greet();
  }

  Future<void> _toggle(Note n) async {
    final before = _progress.streakDays;
    final updated = n.isDone ? n.copyWith(clearDone: true) : n.copyWith(doneAt: DateTime.now());
    await widget.store.save(updated);
    await _reload();
    if (updated.isDone) {
      HapticFeedback.mediumImpact();
      SystemSound.play(SystemSoundType.click);
      _mascot.celebrate();
      _confetti.currentState?.burst();
      final p = _progress;
      if (p.streakDays != before && p.isMilestone && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${p.streakDays}-day streak! The panda is proud.')),
        );
      }
    }
  }

  Future<void> _delete(Note n) async {
    await widget.store.delete(n);
    await _reload();
  }

  Future<void> _addText() async {
    if (_composing) return;
    _composing = true;
    try {
      await _composeAndSave();
    } finally {
      _composing = false;
    }
  }

  Future<void> _composeAndSave() async {
    final ctl = TextEditingController();
    final text = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(ctx).viewInsets.bottom + 16),
        child: TextField(
          controller: ctl,
          autofocus: true,
          minLines: 1,
          maxLines: 5,
          textInputAction: TextInputAction.done,
          decoration: const InputDecoration(hintText: 'New note'),
          onSubmitted: (v) => Navigator.pop(ctx, v),
        ),
      ),
    );
    if (text == null || text.trim().isEmpty) return;
    await widget.store.addText(text.trim());
    await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final p = _progress;
    final visible = _query.isEmpty
        ? _notes
        : _notes.where((n) => (n.text ?? '').toLowerCase().contains(_query.toLowerCase())).toList();
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
                onPressed: () => setState(() {
                  _searching = !_searching;
                  _query = '';
                }),
              ),
              IconButton(
                icon: const Icon(Icons.settings_outlined),
                onPressed: () => Navigator.push(
                    context, MaterialPageRoute(builder: (_) => const SettingsScreen())),
              ),
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _RecordButton(
                  since: _recordingSince,
                  busy: _recordBusy,
                  onPressed: _toggleRecording,
                ),
                FloatingActionButton(
                  heroTag: 'add',
                  tooltip: 'New text note',
                  onPressed: _addText,
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          body: RefreshIndicator(
            onRefresh: _reload,
            child: ListView(
              padding: const EdgeInsets.only(bottom: 96),
              children: [
                const SizedBox(height: 8),
                Center(
                  child: GestureDetector(onTap: _mascot.greet, child: MascotView(controller: _mascot)),
                ),
                _ProgressHeader(progress: p),
                if (visible.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'No notes yet. Capture one from the Lock Screen or the Action Button, or tap +.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                for (final n in visible)
                  Dismissible(
                    key: ValueKey(n.id),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red.shade400,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 24),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (_) => _delete(n),
                    child: _NoteTile(note: n, onToggle: () => _toggle(n)),
                  ),
              ],
            ),
          ),
        ),
        Positioned.fill(child: Confetti(key: _confetti)),
      ],
    );
  }
}

class _ProgressHeader extends StatelessWidget {
  const _ProgressHeader({required this.progress});
  final Progress progress;

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('🔥 ${progress.streakDays}-day streak', style: t.titleSmall),
              Text('${progress.tickedToday} done today', style: t.titleSmall),
              Text('Level ${progress.level}', style: t.titleSmall),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(value: progress.levelFraction, minHeight: 8),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note, required this.onToggle});
  final Note note;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final time = DateFormat('d MMM, HH:mm').format(note.createdAt.toLocal());
    final length = note.durationSeconds != null ? ' · ${note.durationSeconds!.round()} s' : '';
    final words = note.text ?? '';
    final title = note.kind == NoteKind.text
        ? words
        : words.isNotEmpty
            ? words
            : note.text == null
                ? 'Voice note$length'
                : 'Voice note$length (no words heard)';
    return ListTile(
      leading: Checkbox(value: note.isDone, onChanged: (_) => onToggle()),
      title: Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: note.isDone ? const TextStyle(decoration: TextDecoration.lineThrough) : null,
      ),
      subtitle: Text(time),
      // TODO(voice): audio playback row (e.g. just_audio) for voice notes.
      trailing: note.kind == NoteKind.voice ? const Icon(Icons.mic_none) : null,
      onTap: onToggle,
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
