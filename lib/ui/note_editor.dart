import 'package:flutter/material.dart';

import '../models/category.dart';
import '../models/note.dart';
import 'days_dial.dart';

/// Result of the compose / edit sheet.
class NoteDraft {
  const NoteDraft({required this.text, this.days, this.categoryId});
  final String text;

  /// Deadline in days from now, null for none.
  final int? days;
  final String? categoryId;
}

/// Bottom sheet to write a new note or edit an existing one (long tap):
/// text, a "days from now" deadline dial and the category.
///
/// [onTyping] fires with true when the user starts typing and false when the
/// sheet closes, so the panda can perk up and listen.
Future<NoteDraft?> showNoteEditor(
  BuildContext context, {
  Note? note,
  required List<Category> categories,
  String? initialCategoryId,
  bool showDeadline = true,
  ValueChanged<bool>? onTyping,
}) async {
  final result = await showModalBottomSheet<NoteDraft>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _NoteEditor(
      note: note,
      categories: categories,
      initialCategoryId: note?.categoryId ?? initialCategoryId,
      showDeadline: showDeadline,
      onTyping: onTyping,
    ),
  );
  onTyping?.call(false);
  return result;
}

class _NoteEditor extends StatefulWidget {
  const _NoteEditor({
    required this.note,
    required this.categories,
    required this.initialCategoryId,
    required this.showDeadline,
    required this.onTyping,
  });

  final Note? note;
  final List<Category> categories;
  final String? initialCategoryId;
  final bool showDeadline;
  final ValueChanged<bool>? onTyping;

  @override
  State<_NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<_NoteEditor> {
  late final _text = TextEditingController(text: widget.note?.title ?? '');
  late int? _days = widget.note == null ? null : _clampDays(widget.note!.daysLeft(DateTime.now()));
  late String? _categoryId = widget.initialCategoryId;
  late bool _showDial = widget.showDeadline && _days != null;
  bool _typing = false;

  static int? _clampDays(int? d) => d == null ? null : (d < 0 ? 0 : d);

  @override
  void initState() {
    super.initState();
    _text.addListener(() {
      if (!_typing && _text.text.isNotEmpty) {
        _typing = true;
        widget.onTyping?.call(true);
      }
    });
    // The panda listens as soon as the keyboard is up.
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onTyping?.call(true));
  }

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _submit() {
    final t = _text.text.trim();
    if (t.isEmpty) {
      Navigator.pop(context);
      return;
    }
    Navigator.pop(context, NoteDraft(text: t, days: _days, categoryId: _categoryId));
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.note != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _text,
            autofocus: true,
            minLines: 1,
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(hintText: editing ? 'Note' : 'New note'),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              if (widget.showDeadline)
                ActionChip(
                  avatar: Icon(_days == null ? Icons.alarm_add_outlined : Icons.alarm, size: 18),
                  label: Text(_days == null ? 'Deadline' : DaysDial.label(_days)),
                  onPressed: () => setState(() {
                    _showDial = !_showDial;
                    if (_showDial && _days == null) _days = 1;
                  }),
                ),
              const Spacer(),
              FilledButton(onPressed: _submit, child: Text(editing ? 'Save' : 'Add')),
            ],
          ),
          AnimatedSize(
            duration: const Duration(milliseconds: 200),
            child: !_showDial
                ? const SizedBox(width: double.infinity)
                : Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DaysDial(days: _days, onChanged: (d) => setState(() => _days = d)),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(DaysDial.label(_days), style: Theme.of(context).textTheme.titleMedium),
                            const Text('Turn the dial'),
                            TextButton(
                              onPressed: () => setState(() {
                                _days = null;
                                _showDial = false;
                              }),
                              child: const Text('Clear'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
          ),
          if (widget.categories.isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                for (final c in widget.categories)
                  ChoiceChip(
                    avatar: CircleAvatar(backgroundColor: c.color, radius: 6),
                    label: Text(c.name),
                    selected: _categoryId == c.id,
                    onSelected: (on) => setState(() => _categoryId = on ? c.id : null),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
