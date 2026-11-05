import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../gamification/progress.dart';
import '../models/note.dart';
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

  Progress get _progress => Progress.from(_notes);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _reload(greet: true);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Notes captured from the Lock Screen land on disk while we are away.
    if (state == AppLifecycleState.resumed) _reload(greet: true);
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
          floatingActionButton: FloatingActionButton(
            onPressed: _addText,
            child: const Icon(Icons.add),
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
    final title = note.kind == NoteKind.voice
        ? 'Voice note${note.durationSeconds != null ? ' · ${note.durationSeconds!.round()} s' : ''}'
        : (note.text ?? '');
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
