import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A small round dial to pick a deadline in "days from now".
///
/// Turn the knob clockwise: one full turn is [daysPerTurn] days and it keeps
/// counting on further turns up to [maxDays]. Turning back below zero clears
/// the deadline (null). Each day clicks with a light haptic tick.
class DaysDial extends StatefulWidget {
  const DaysDial({
    super.key,
    required this.days,
    required this.onChanged,
    this.size = 120,
    this.daysPerTurn = 14,
    this.maxDays = 99,
  });

  /// Null = no deadline.
  final int? days;
  final ValueChanged<int?> onChanged;
  final double size;
  final int daysPerTurn;
  final int maxDays;

  @override
  State<DaysDial> createState() => _DaysDialState();

  static String label(int? days) => switch (days) {
        null => 'no deadline',
        0 => 'today',
        1 => 'tomorrow',
        _ => 'in $days days',
      };
}

class _DaysDialState extends State<DaysDial> {
  /// Continuous position in days (fractional while dragging); -1 = none.
  late double _pos = (widget.days ?? -1).toDouble();
  double? _lastAngle;

  @override
  void didUpdateWidget(DaysDial old) {
    super.didUpdateWidget(old);
    if (_lastAngle == null && widget.days != old.days) _pos = (widget.days ?? -1).toDouble();
  }

  double _angleOf(Offset local) {
    final c = Offset(widget.size / 2, widget.size / 2);
    final d = local - c;
    return math.atan2(d.dy, d.dx);
  }

  void _drag(Offset local) {
    final a = _angleOf(local);
    final last = _lastAngle;
    _lastAngle = a;
    if (last == null) return;
    var delta = a - last;
    if (delta > math.pi) delta -= 2 * math.pi;
    if (delta < -math.pi) delta += 2 * math.pi;
    final before = _value(_pos);
    setState(() {
      _pos = (_pos + delta / (2 * math.pi) * widget.daysPerTurn).clamp(-1.0, widget.maxDays.toDouble());
    });
    final after = _value(_pos);
    if (after != before) {
      HapticFeedback.selectionClick();
      widget.onChanged(after);
    }
  }

  int? _value(double pos) => pos < -0.5 ? null : pos.round().clamp(0, widget.maxDays);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final days = _value(_pos);
    return Semantics(
      label: 'Deadline',
      value: DaysDial.label(days),
      increasedValue: DaysDial.label((days ?? -1) + 1),
      decreasedValue: DaysDial.label(days == null || days == 0 ? null : days - 1),
      onIncrease: () => _step(1),
      onDecrease: () => _step(-1),
      child: GestureDetector(
        onPanStart: (d) => _lastAngle = _angleOf(d.localPosition),
        onPanUpdate: (d) => _drag(d.localPosition),
        onPanEnd: (_) => setState(() {
          _lastAngle = null;
          _pos = (days ?? -1).toDouble(); // snap to the whole day
        }),
        onTap: () => _step(1),
        child: SizedBox.square(
          dimension: widget.size,
          child: CustomPaint(
            painter: _DialPainter(
              pos: _pos,
              daysPerTurn: widget.daysPerTurn,
              track: scheme.surfaceContainerHighest,
              fill: scheme.primary,
              knob: scheme.onPrimary,
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    days == null ? '–' : '$days',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                  ),
                  Text(
                    days == null ? 'no date' : (days == 1 ? 'day' : 'days'),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _step(int by) {
    final now = _value(_pos);
    final next = now == null ? (by > 0 ? 0 : null) : (now + by < 0 ? null : (now + by).clamp(0, widget.maxDays));
    setState(() => _pos = (next ?? -1).toDouble());
    HapticFeedback.selectionClick();
    widget.onChanged(next);
  }
}

class _DialPainter extends CustomPainter {
  _DialPainter({
    required this.pos,
    required this.daysPerTurn,
    required this.track,
    required this.fill,
    required this.knob,
  });

  final double pos;
  final int daysPerTurn;
  final Color track, fill, knob;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    final r = size.shortestSide / 2 - 8;
    final stroke = size.shortestSide * 0.09;
    final base = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    canvas.drawCircle(c, r, base);
    // Day ticks.
    final tick = Paint()
      ..color = fill.withValues(alpha: 0.35)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < daysPerTurn; i++) {
      final a = -math.pi / 2 + i / daysPerTurn * 2 * math.pi;
      final dir = Offset(math.cos(a), math.sin(a));
      canvas.drawLine(c + dir * (r - stroke * 0.9), c + dir * (r - stroke * 1.4), tick);
    }
    if (pos < 0) return;
    final turns = pos / daysPerTurn;
    final arc = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = stroke;
    final rect = Rect.fromCircle(center: c, radius: r);
    // Completed turns as a full (darker) ring, the rest as an arc.
    if (turns >= 1) canvas.drawCircle(c, r, arc..color = Color.lerp(fill, Colors.black, 0.15)!);
    canvas.drawArc(rect, -math.pi / 2, (turns % 1) * 2 * math.pi + 0.0001, false, arc..color = fill);
    final a = -math.pi / 2 + (turns % 1) * 2 * math.pi;
    final k = c + Offset(math.cos(a), math.sin(a)) * r;
    canvas.drawCircle(k, stroke * 0.75, Paint()..color = fill);
    canvas.drawCircle(k, stroke * 0.38, Paint()..color = knob);
  }

  @override
  bool shouldRepaint(_DialPainter old) => old.pos != pos || old.fill != fill || old.track != track;
}
