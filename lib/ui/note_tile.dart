import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../models/category.dart';
import '../models/note.dart';

/// One item in the list.
///
/// Only the check mark ticks it off; a long tap opens the editor. The right
/// gutter shows a little alarm clock for deadlines and the drag handle,
/// which reorders the item or drops it onto a category cloud.
class NoteTile extends StatelessWidget {
  const NoteTile({
    super.key,
    required this.note,
    required this.now,
    required this.onToggle,
    required this.onEdit,
    this.category,
    this.onDragUpdate,
    this.onDragEnd,
  });

  final Note note;
  final DateTime now;
  final Category? category;
  final VoidCallback onToggle;
  final VoidCallback onEdit;
  final ValueChanged<DragUpdateDetails>? onDragUpdate;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final t = Theme.of(context).textTheme;
    final done = note.isDone;
    final snoozed = !done && note.isSnoozed(now);
    final subtitle = <InlineSpan>[
      if (category != null) ...[
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(color: category!.color, shape: BoxShape.circle),
          ),
        ),
        TextSpan(text: '${category!.name} · '),
      ],
      TextSpan(text: DateFormat('d MMM, HH:mm').format(note.createdAt.toLocal())),
      if (snoozed) TextSpan(text: ' · 💤 until ${DateFormat('EEE HH:mm').format(note.snoozedUntil!.toLocal())}'),
    ];
    return Semantics(
      onLongPressHint: 'Edit',
      child: InkWell(
        onLongPress: () {
          HapticFeedback.mediumImpact();
          onEdit();
        },
        child: Opacity(
          opacity: snoozed ? 0.55 : 1,
          child: Padding(
            padding: const EdgeInsets.only(left: 4, top: 4, bottom: 4),
            child: Row(
              children: [
                Checkbox(
                  value: done,
                  onChanged: (_) => onToggle(),
                  shape: const CircleBorder(),
                  semanticLabel: done ? 'Done' : 'Tick off',
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: t.bodyLarge?.copyWith(
                            decoration: done ? TextDecoration.lineThrough : null,
                            color: done ? scheme.onSurfaceVariant : null,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text.rich(TextSpan(children: subtitle),
                            style: t.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                      ],
                    ),
                  ),
                ),
                if (note.kind == NoteKind.voice)
                  Icon(Icons.mic_none, size: 18, color: scheme.onSurfaceVariant),
                if (note.leaveBasket && !done)
                  Padding(
                    padding: const EdgeInsets.only(left: 4),
                    child: Tooltip(
                      message: 'In the leave basket',
                      child: Icon(Icons.shopping_basket_outlined, size: 18, color: scheme.onSurfaceVariant),
                    ),
                  ),
                if (note.dueAt != null && !done) DeadlineBadge(note: note, now: now),
                if (!done)
                  _DragHandle(note: note, onDragUpdate: onDragUpdate, onDragEnd: onDragEnd)
                else
                  const SizedBox(width: 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// The subtle old-fashioned alarm clock in the right gutter, with days left.
class DeadlineBadge extends StatelessWidget {
  const DeadlineBadge({super.key, required this.note, required this.now});
  final Note note;
  final DateTime now;

  static String shortLabel(int days) => switch (days) {
        < 0 => '${-days}d late',
        0 => 'today',
        1 => '1d',
        _ => '${days}d',
      };

  @override
  Widget build(BuildContext context) {
    final days = note.daysLeft(now) ?? 0;
    final scheme = Theme.of(context).colorScheme;
    final color = days < 0
        ? scheme.error
        : days == 0
            ? const Color(0xFFE07A1F)
            : scheme.onSurfaceVariant.withValues(alpha: 0.7);
    return Tooltip(
      message: 'Due ${DateFormat('EEE d MMM').format(note.dueAt!.toLocal())}',
      child: Padding(
        padding: const EdgeInsets.only(left: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox.square(dimension: 18, child: CustomPaint(painter: AlarmClockPainter(color))),
            Text(shortLabel(days), style: TextStyle(fontSize: 9, color: color)),
          ],
        ),
      ),
    );
  }
}

/// A classic twin-bell alarm clock, drawn thin and small.
class AlarmClockPainter extends CustomPainter {
  AlarmClockPainter(this.color);
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(size.width / 2, size.height * 0.56);
    final line = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round;
    final fill = Paint()..color = color;
    final r = s * 0.34;
    // Bells.
    for (final sx in [-1.0, 1.0]) {
      canvas.drawArc(Rect.fromCircle(center: c + Offset(sx * r * 0.82, -r * 0.95), radius: r * 0.42),
          sx < 0 ? 3.4 : 4.6, 1.6, true, fill);
    }
    // Hammer + feet.
    canvas.drawLine(c + Offset(0, -r * 1.05), c + Offset(0, -r * 1.3), line);
    canvas.drawLine(c + Offset(-r * 0.6, r * 0.8), c + Offset(-r * 0.85, r * 1.15), line);
    canvas.drawLine(c + Offset(r * 0.6, r * 0.8), c + Offset(r * 0.85, r * 1.15), line);
    // Face and hands.
    canvas.drawCircle(c, r, line);
    canvas.drawLine(c, c + Offset(0, -r * 0.55), line);
    canvas.drawLine(c, c + Offset(r * 0.4, r * 0.15), line);
  }

  @override
  bool shouldRepaint(AlarmClockPainter old) => old.color != color;
}

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.note, this.onDragUpdate, this.onDragEnd});
  final Note note;
  final ValueChanged<DragUpdateDetails>? onDragUpdate;
  final VoidCallback? onDragEnd;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.8;
    final handle = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Icon(Icons.drag_indicator, color: Theme.of(context).colorScheme.onSurfaceVariant),
    );
    return Semantics(
      label: 'Drag to reorder or onto a category cloud',
      child: Draggable<Note>(
        data: note,
        dragAnchorStrategy: pointerDragAnchorStrategy,
        onDragStarted: HapticFeedback.selectionClick,
        onDragUpdate: onDragUpdate,
        onDragEnd: (_) => onDragEnd?.call(),
        onDraggableCanceled: (_, _) => onDragEnd?.call(),
        feedback: FractionalTranslation(
          translation: const Offset(-0.85, -0.5),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: width,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(note.title, maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.3, child: handle),
        child: handle,
      ),
    );
  }
}

/// Wraps an open item so a dragged item can be dropped above or below it.
class ReorderTarget extends StatefulWidget {
  const ReorderTarget({super.key, required this.note, required this.onDrop, required this.child});
  final Note note;

  /// Called with the dropped note and whether it goes below [note].
  final void Function(Note dropped, bool below) onDrop;
  final Widget child;

  @override
  State<ReorderTarget> createState() => _ReorderTargetState();
}

class _ReorderTargetState extends State<ReorderTarget> {
  bool _below = false;

  bool _isBelow(Offset global) {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return false;
    return box.globalToLocal(global).dy > box.size.height / 2;
  }

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return DragTarget<Note>(
      onWillAcceptWithDetails: (d) => d.data.id != widget.note.id,
      onMove: (d) {
        final b = _isBelow(d.offset);
        if (b != _below) setState(() => _below = b);
      },
      onAcceptWithDetails: (d) {
        HapticFeedback.lightImpact();
        widget.onDrop(d.data, _isBelow(d.offset));
      },
      builder: (context, candidates, _) {
        final active = candidates.isNotEmpty;
        return Stack(
          children: [
            widget.child,
            if (active)
              Positioned(
                left: 16,
                right: 16,
                top: _below ? null : 0,
                bottom: _below ? 0 : null,
                child: Container(
                  height: 3,
                  decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
                ),
              ),
          ],
        );
      },
    );
  }
}
