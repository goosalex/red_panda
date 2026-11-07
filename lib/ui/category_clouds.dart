import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/category.dart';
import '../models/note.dart';

/// Little clouds, one per category, hovering around the sleeping panda.
///
/// - Drag an item (by its handle) onto a cloud to file it there.
/// - Tap a cloud to show only its items; tap it again to show all.
/// - Long-press a cloud to rename or remove it; the small "+" cloud adds one.
class CategoryClouds extends StatefulWidget {
  const CategoryClouds({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelect,
    required this.onDropNote,
    required this.onAdd,
    required this.onEdit,
    this.counts = const {},
  });

  final List<Category> categories;
  final String? selectedId;
  final ValueChanged<String?> onSelect;
  final void Function(Note note, Category category) onDropNote;
  final VoidCallback onAdd;
  final ValueChanged<Category> onEdit;

  /// Open items per category id, shown as a tiny number on the cloud.
  final Map<String, int> counts;

  /// Where clouds float, as alignments inside the stage (panda in the middle,
  /// sun/moon in the top-right corner).
  static const slots = [
    Alignment(-0.96, -0.75),
    Alignment(0.66, -0.80),
    Alignment(-0.70, 0.70),
    Alignment(0.96, 0.15),
    Alignment(-0.98, 0.05),
    Alignment(0.62, 0.85),
    Alignment(-0.30, -0.98), // the "+" cloud when all others are used
  ];

  @override
  State<CategoryClouds> createState() => _CategoryCloudsState();
}

class _CategoryCloudsState extends State<CategoryClouds> with SingleTickerProviderStateMixin {
  late final AnimationController _bob =
      AnimationController(vsync: this, duration: const Duration(seconds: 6))..repeat();

  @override
  void dispose() {
    _bob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final still = MediaQuery.of(context).disableAnimations;
    final cats = widget.categories.take(Category.maxCount).toList();
    final children = <Widget>[];
    for (var i = 0; i < cats.length; i++) {
      final c = cats[i];
      children.add(_float(
        i,
        still,
        _Cloud(
          category: c,
          selected: widget.selectedId == c.id,
          dimmed: widget.selectedId != null && widget.selectedId != c.id,
          count: widget.counts[c.id] ?? 0,
          onTap: () {
            HapticFeedback.selectionClick();
            widget.onSelect(widget.selectedId == c.id ? null : c.id);
          },
          onLongPress: () => widget.onEdit(c),
          onDrop: (n) => widget.onDropNote(n, c),
        ),
      ));
    }
    if (cats.length < Category.maxCount) {
      children.add(_float(
        cats.length,
        still,
        _AddCloud(onTap: widget.onAdd, hint: cats.isEmpty),
      ));
    }
    return Stack(children: children);
  }

  Widget _float(int slot, bool still, Widget child) {
    final base = CategoryClouds.slots[slot % CategoryClouds.slots.length];
    return AnimatedBuilder(
      animation: _bob,
      builder: (context, child) {
        final t = still ? 0.0 : _bob.value * 2 * math.pi + slot * 1.3;
        return Align(
          alignment: base + Alignment(math.sin(t) * 0.025, math.cos(t * 0.8) * 0.06),
          child: child,
        );
      },
      child: Padding(padding: const EdgeInsets.all(6), child: child),
    );
  }
}

class _Cloud extends StatelessWidget {
  const _Cloud({
    required this.category,
    required this.selected,
    required this.dimmed,
    required this.count,
    required this.onTap,
    required this.onLongPress,
    required this.onDrop,
  });

  final Category category;
  final bool selected;
  final bool dimmed;
  final int count;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<Note> onDrop;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Note>(
      onWillAcceptWithDetails: (d) => d.data.categoryId != category.id,
      onAcceptWithDetails: (d) {
        HapticFeedback.mediumImpact();
        onDrop(d.data);
      },
      builder: (context, candidates, _) {
        final hovering = candidates.isNotEmpty;
        return Semantics(
          button: true,
          selected: selected,
          label: 'Category ${category.name}, $count open',
          hint: selected ? 'Double tap to show all items' : 'Double tap to show only this category',
          child: GestureDetector(
            onTap: onTap,
            onLongPress: onLongPress,
            child: AnimatedScale(
              scale: hovering ? 1.25 : (selected ? 1.1 : 1),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: AnimatedOpacity(
                opacity: dimmed ? 0.45 : 1,
                duration: const Duration(milliseconds: 200),
                child: CustomPaint(
                  painter: CloudPainter(
                    color: category.color,
                    outline: selected || hovering ? const Color(0xFF3B1F14) : null,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          category.name,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF3B1F14),
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 4),
                          Text(
                            '$count',
                            style: const TextStyle(fontSize: 10, color: Color(0xAA3B1F14)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AddCloud extends StatelessWidget {
  const _AddCloud({required this.onTap, required this.hint});
  final VoidCallback onTap;
  final bool hint;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return Semantics(
      button: true,
      label: 'Add a category',
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          painter: CloudPainter(color: color.withValues(alpha: 0.8), dashed: true),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Text(
              hint ? '+ category' : '+',
              style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
            ),
          ),
        ),
      ),
    );
  }
}

/// A soft, puffy cloud filling its box (three bumps on top, flat-ish base).
class CloudPainter extends CustomPainter {
  CloudPainter({required this.color, this.outline, this.dashed = false});
  final Color color;
  final Color? outline;
  final bool dashed;

  Path _path(Size s) {
    final w = s.width, h = s.height;
    final base = Rect.fromLTWH(0, h * 0.35, w, h * 0.65);
    // One outline: union of the base and the bumps.
    return [
      Path()..addOval(Rect.fromCircle(center: Offset(w * 0.30, h * 0.42), radius: h * 0.30)),
      Path()..addOval(Rect.fromCircle(center: Offset(w * 0.58, h * 0.34), radius: h * 0.36)),
      Path()..addOval(Rect.fromCircle(center: Offset(w * 0.80, h * 0.50), radius: h * 0.24)),
    ].fold(Path()..addRRect(RRect.fromRectAndRadius(base, Radius.circular(h * 0.32))),
        (a, b) => Path.combine(PathOperation.union, a, b));
  }

  @override
  void paint(Canvas canvas, Size size) {
    final p = _path(size);
    canvas.drawShadow(p, const Color(0x55000000), 2, false);
    canvas.drawPath(p, Paint()..color = color);
    // A little highlight on the top bump.
    canvas.drawOval(
      Rect.fromCircle(center: Offset(size.width * 0.52, size.height * 0.24), radius: size.height * 0.08),
      Paint()..color = Colors.white.withValues(alpha: 0.5),
    );
    final o = outline;
    if (o != null || dashed) {
      canvas.drawPath(
        p,
        Paint()
          ..color = o ?? Colors.grey.withValues(alpha: 0.6)
          ..style = PaintingStyle.stroke
          ..strokeWidth = dashed ? 1 : 1.5,
      );
    }
  }

  @override
  bool shouldRepaint(CloudPainter old) =>
      old.color != color || old.outline != outline || old.dashed != dashed;
}

/// Sun by day, moon by night, in the corner of the stage. Tapping it clears
/// all filters and shows every item, by importance or deadline.
class SkyButton extends StatelessWidget {
  const SkyButton({super.key, required this.onTap, required this.filtered, this.now});
  final VoidCallback onTap;
  final bool filtered;
  final DateTime? now;

  static bool isDay(DateTime t) => t.hour >= 6 && t.hour < 19;

  @override
  Widget build(BuildContext context) {
    final day = isDay(now ?? DateTime.now());
    return Semantics(
      button: true,
      label: day ? 'Sun' : 'Moon',
      hint: 'Shows all items',
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: AnimatedScale(
          scale: filtered ? 1.15 : 1,
          duration: const Duration(milliseconds: 200),
          child: SizedBox.square(
            dimension: 44,
            child: CustomPaint(painter: _SkyPainter(day: day, glow: filtered)),
          ),
        ),
      ),
    );
  }
}

class _SkyPainter extends CustomPainter {
  _SkyPainter({required this.day, required this.glow});
  final bool day;
  final bool glow;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide * 0.24;
    if (glow) {
      canvas.drawCircle(
        c,
        r * 1.9,
        Paint()
          ..color = (day ? const Color(0xFFFFC94A) : const Color(0xFFBFD4FF)).withValues(alpha: 0.35)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
      );
    }
    if (day) {
      final ray = Paint()
        ..color = const Color(0xFFFFB627)
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round;
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        final d = Offset(math.cos(a), math.sin(a));
        canvas.drawLine(c + d * r * 1.35, c + d * r * 1.75, ray);
      }
      canvas.drawCircle(c, r, Paint()..color = const Color(0xFFFFC94A));
      // Sleepy cheeks.
      canvas.drawCircle(c + Offset(-r * 0.45, r * 0.25), r * 0.16, Paint()..color = const Color(0x66FF7A59));
      canvas.drawCircle(c + Offset(r * 0.45, r * 0.25), r * 0.16, Paint()..color = const Color(0x66FF7A59));
    } else {
      final moon = Path.combine(
        PathOperation.difference,
        Path()..addOval(Rect.fromCircle(center: c, radius: r * 1.15)),
        Path()..addOval(Rect.fromCircle(center: c + Offset(r * 0.6, -r * 0.35), radius: r)),
      );
      canvas.drawPath(moon, Paint()..color = const Color(0xFFF3E7B5));
      final star = Paint()..color = const Color(0xFFF3E7B5);
      canvas.drawCircle(c + Offset(r * 1.3, r * 0.9), 1.4, star);
      canvas.drawCircle(c + Offset(r * 0.9, -r * 1.4), 1.1, star);
    }
  }

  @override
  bool shouldRepaint(_SkyPainter old) => old.day != day || old.glow != glow;
}
