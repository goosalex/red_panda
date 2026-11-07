import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/note.dart';

/// The leave basket next to the panda.
///
/// - Drag an item (by its handle) into the basket: it reminds you when you
///   leave this place or your Wi-Fi drops.
/// - Tap: show only the basket's items (tap again for all).
/// - Long-press: basket details (where it is armed, settings).
class LeaveBasketButton extends StatelessWidget {
  const LeaveBasketButton({
    super.key,
    required this.count,
    required this.armed,
    required this.selected,
    required this.onTap,
    required this.onLongPress,
    required this.onDropNote,
  });

  final int count;
  final bool armed;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final ValueChanged<Note> onDropNote;

  @override
  Widget build(BuildContext context) {
    return DragTarget<Note>(
      onWillAcceptWithDetails: (d) => !d.data.leaveBasket,
      onAcceptWithDetails: (d) {
        HapticFeedback.mediumImpact();
        onDropNote(d.data);
      },
      builder: (context, candidates, _) {
        final hovering = candidates.isNotEmpty;
        return Semantics(
          button: true,
          selected: selected,
          label: 'Leave basket, $count ${count == 1 ? 'item' : 'items'}${armed ? ', watching' : ''}',
          hint: 'Drop items here to be reminded when you leave. Double tap to filter.',
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              onTap();
            },
            onLongPress: onLongPress,
            child: AnimatedScale(
              scale: hovering ? 1.3 : (selected ? 1.12 : 1),
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutBack,
              child: SizedBox(
                width: 54,
                height: 48,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: CustomPaint(painter: BasketPainter(open: hovering, highlight: selected)),
                    ),
                    if (count > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9541E),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    if (armed)
                      const Positioned(
                        left: -2,
                        top: -2,
                        child: Icon(Icons.location_on, size: 14, color: Color(0xFF3B7D3B)),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// A small woven bamboo basket with a handle.
class BasketPainter extends CustomPainter {
  BasketPainter({this.open = false, this.highlight = false});
  final bool open;
  final bool highlight;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    const straw = Color(0xFFE2B66B);
    const dark = Color(0xFF8A5A2B);
    final outline = Paint()
      ..color = dark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeJoin = StrokeJoin.round;

    // Handle (tilts back when something hovers above, like opening).
    final handle = Path()
      ..moveTo(w * 0.2, h * 0.48)
      ..cubicTo(w * 0.22, open ? -h * 0.05 : h * 0.02, w * 0.78, open ? -h * 0.05 : h * 0.02, w * 0.8, h * 0.48);
    canvas.drawPath(
      handle,
      Paint()
        ..color = dark
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );

    // Body: a slightly flaring bowl.
    final body = Path()
      ..moveTo(w * 0.06, h * 0.45)
      ..lineTo(w * 0.94, h * 0.45)
      ..lineTo(w * 0.82, h * 0.95)
      ..quadraticBezierTo(w * 0.5, h * 1.02, w * 0.18, h * 0.95)
      ..close();
    if (highlight) {
      canvas.drawPath(
        body,
        Paint()
          ..color = const Color(0x66FFC94A)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5),
      );
    }
    canvas.drawPath(body, Paint()..color = straw);

    // Weave: horizontal bands and staggered vertical stitches.
    canvas.save();
    canvas.clipPath(body);
    final weave = Paint()
      ..color = dark.withValues(alpha: 0.45)
      ..strokeWidth = 1.1;
    for (var i = 1; i < 4; i++) {
      final y = h * (0.45 + i * 0.125);
      canvas.drawLine(Offset(0, y), Offset(w, y), weave);
      for (var x = (i.isEven ? 0.0 : 0.06) * w; x < w; x += w * 0.12) {
        canvas.drawLine(Offset(x, y - h * 0.11), Offset(x, y - h * 0.02), weave);
      }
    }
    canvas.restore();
    canvas.drawPath(body, outline);

    // Rim.
    final rim = RRect.fromRectAndRadius(
      Rect.fromLTWH(w * 0.02, h * 0.38, w * 0.96, h * 0.13),
      Radius.circular(h * 0.06),
    );
    canvas.drawRRect(rim, Paint()..color = Color.lerp(straw, dark, 0.25)!);
    canvas.drawRRect(rim, outline);

    // A bamboo leaf peeking out.
    final leaf = Path()
      ..moveTo(w * 0.62, h * 0.4)
      ..quadraticBezierTo(w * 0.78, h * 0.12, w * 0.92, h * 0.16)
      ..quadraticBezierTo(w * 0.8, h * 0.32, w * 0.62, h * 0.4);
    canvas.save();
    canvas.translate(0, open ? -h * 0.06 : 0);
    canvas.drawPath(leaf, Paint()..color = const Color(0xFF7DB85A));
    canvas.drawLine(
      Offset(w * 0.64, h * 0.39),
      Offset(w * 0.86, h * 0.2),
      Paint()
        ..color = const Color(0xFF4E8A36)
        ..strokeWidth = 0.8,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(BasketPainter old) => old.open != open || old.highlight != highlight;
}
