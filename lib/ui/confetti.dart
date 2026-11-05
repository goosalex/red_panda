import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Lightweight confetti burst drawn with a CustomPainter. Call [burst] on the
/// key's state; respects Reduce Motion.
class Confetti extends StatefulWidget {
  const Confetti({super.key});

  @override
  ConfettiState createState() => ConfettiState();
}

class ConfettiState extends State<Confetti> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1400));
  final _rng = math.Random();
  List<_Piece> _pieces = const [];

  static const _colors = [
    Color(0xFFD9541E),
    Color(0xFFFFB347),
    Color(0xFF6CC3A0),
    Color(0xFF6FA8FF),
    Color(0xFFF26B8A),
  ];

  void burst() {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return;
    setState(() {
      _pieces = List.generate(60, (_) {
        final a = -math.pi / 2 + (_rng.nextDouble() - 0.5) * math.pi * 0.9;
        final v = 0.6 + _rng.nextDouble() * 0.7;
        return _Piece(
          vx: math.cos(a) * v,
          vy: math.sin(a) * v,
          spin: (_rng.nextDouble() - 0.5) * 12,
          color: _colors[_rng.nextInt(_colors.length)],
        );
      });
    });
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => IgnorePointer(
        child: AnimatedBuilder(
          animation: _c,
          builder: (context, _) => CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_pieces, _c.value, _c.isAnimating),
          ),
        ),
      );
}

class _Piece {
  const _Piece({required this.vx, required this.vy, required this.spin, required this.color});
  final double vx, vy, spin;
  final Color color;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.pieces, this.t, this.active);
  final List<_Piece> pieces;
  final double t;
  final bool active;

  @override
  void paint(Canvas canvas, Size size) {
    if (!active) return;
    final origin = Offset(size.width / 2, size.height * 0.35);
    final scale = size.shortestSide;
    final paint = Paint();
    for (final p in pieces) {
      final x = origin.dx + p.vx * scale * t;
      final y = origin.dy + p.vy * scale * t + 0.9 * scale * t * t; // gravity
      paint.color = p.color.withValues(alpha: (1 - t).clamp(0, 1));
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(p.spin * t);
      canvas.drawRect(const Rect.fromLTWH(-4, -2, 8, 4), paint);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}
