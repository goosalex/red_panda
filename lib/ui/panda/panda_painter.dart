import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The mascot's poses. `sleeping` is the default idle pose.
enum PandaPose { sleeping, curious, excited, sad }

// Palette (from the owner's reference still).
const _fur = Color(0xFFE0662A);
const _furDeep = Color(0xFFD9541E);
const _furLight = Color(0xFFEC7C3E);
const _cream = Color(0xFFFFF4EC);
const _limb = Color(0xFF4A2A20);
const _ink = Color(0xFF3B1F14);
const _tearMark = Color(0xFF8E2A1A);
const _gold = Color(0xFFE8A324);
const _pad = Color(0xFFE9A496);
const _blush = Color(0x66FF7272);
const _mouthIn = Color(0xFF6E1D14);
const _tongue = Color(0xFFF08A86);

/// Simplified chibi red panda drawn with vector paths.
///
/// Everything is laid out in a 200x200 design box that is scaled to fit
/// [size] and centred; the panda stands on the box's bottom edge (y ≈ 194).
/// Background stays transparent.
class PandaPainter extends CustomPainter {
  PandaPainter({required this.pose, this.phase = 0, this.earTilt = Offset.zero, this.blink = 0});

  final PandaPose pose;

  /// 0..1 looping idle phase (breathing, tail sway, hop).
  final double phase;

  /// -1..1 per axis; ears (and a little head tilt / gaze) follow it.
  final Offset earTilt;

  /// 0..1 eyelid closure for the awake poses.
  final double blink;

  static const double box = 200;
  static const double _line = 3.2;

  double get _wave => math.sin(phase * 2 * math.pi);

  @override
  void paint(Canvas canvas, Size size) {
    final s = math.min(size.width, size.height) / box;
    if (s <= 0) return;
    canvas.save();
    canvas.translate((size.width - box * s) / 2, (size.height - box * s) / 2);
    canvas.scale(s);
    switch (pose) {
      case PandaPose.sleeping:
        _sleeping(canvas);
      case PandaPose.curious:
        _curious(canvas);
      case PandaPose.excited:
        _excited(canvas);
      case PandaPose.sad:
        _sad(canvas);
    }
    canvas.restore();
  }

  // ---------------------------------------------------------------- poses

  void _sleeping(Canvas c) {
    final b = _wave; // breathing
    _shadow(c, const Offset(100, 194), 160);

    // Body: a round "bun", breathing from the ground up.
    c.save();
    c.translate(100, 196);
    c.scale(1 + 0.012 * b, 1 + 0.035 * b);
    c.translate(-100, -196);
    final body = Path()..addOval(Rect.fromCenter(center: const Offset(104, 156), width: 148, height: 80));
    _shape(c, body, _furPaint(body.getBounds()));
    c.restore();

    // Head resting low on the front of the bun.
    _head(c,
        at: Offset(70, 151 - 2.5 * b),
        scale: 0.74,
        angle: -0.16,
        eyes: _Eyes.closed,
        mouth: _Mouth.sleep,
        earL: -0.9,
        earR: 0.72);

    // Big ringed tail wrapping round the front; the nose is tucked into it.
    final tail = Path()
      ..moveTo(164, 142)
      ..cubicTo(194, 160, 190, 192, 150, 190)
      ..cubicTo(118, 189, 88, 186, 60, 184)
      ..cubicTo(40, 183, 24, 184, 16, 174);
    _tail(c, tail, maxR: 21, minR: 10);

    // Front paw hugging the tail.
    c.save();
    c.translate(114, 168 - b);
    _shape(c, Path()..addOval(Rect.fromCenter(center: Offset.zero, width: 20, height: 13)), _p(_limb));
    final toe = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;
    c.drawLine(const Offset(-3, 2), const Offset(-3, 5.5), toe);
    c.drawLine(const Offset(3, 2), const Offset(3, 5.5), toe);
    c.restore();

    // Floating z's.
    for (var i = 0; i < 3; i++) {
      final u = (phase + i / 3) % 1.0;
      final a = math.sin(u * math.pi);
      _zee(c, Offset(104 + 34 * u, 116 - 56 * u), 6 + 7 * u, a);
    }
  }

  void _curious(Canvas c) {
    final tilt = Offset(earTilt.dx.clamp(-1.0, 1.0), earTilt.dy.clamp(-1.0, 1.0));
    // Idle twitch: one ear flicks briefly once per loop.
    final tw = _pulse(phase, 0.42, 0.05);
    _shadow(c, const Offset(96, 194), 130);

    c.save();
    c.translate(104, 178);
    c.rotate(0.04 * _wave);
    c.translate(-104, -178);
    // Question-mark tail: stem rises on the right, hook curls over the top.
    final tail = Path()
      ..moveTo(104, 178)
      ..cubicTo(140, 190, 178, 182, 180, 152)
      ..cubicTo(182, 128, 172, 108, 180, 88)
      ..cubicTo(186, 74, 194, 60, 190, 44)
      ..cubicTo(184, 24, 160, 16, 150, 30)
      ..cubicTo(145, 38, 148, 48, 154, 54);
    _tail(c, tail, maxR: 14, minR: 6);
    c.restore();

    _sittingBody(c, 82);
    final perk = -tilt.dy * 0.15;
    _head(c,
        at: const Offset(82, 80),
        angle: 0.1 * tilt.dx + 0.025 * _wave,
        eyes: _Eyes.open,
        mouth: _Mouth.smile,
        earL: -0.28 + 0.35 * tilt.dx - perk - 0.25 * tw,
        earR: 0.28 + 0.35 * tilt.dx + perk,
        earScale: 1.08,
        look: tilt,
        blink: blink);
  }

  void _excited(Canvas c) {
    // Five hops per loop.
    final hop = math.sin((phase * 5 % 1.0) * math.pi).abs();
    final lift = 12 * hop;
    _shadow(c, const Offset(100, 194), 104 - 26 * hop);

    c.save();
    c.translate(0, -lift);
    // Tail curling up behind on the right.
    final tail = Path()
      ..moveTo(108, 164)
      ..cubicTo(146, 182, 184, 166, 182, 132)
      ..cubicTo(180, 110, 166, 100, 168, 84)
      ..cubicTo(170, 72, 182, 68, 186, 76);
    _tail(c, tail, maxR: 16, minR: 7);

    // Legs: left planted, right lifted mid-hop.
    _limbTube(c, const Offset(90, 158), const Offset(87, 180), 11);
    _shape(c, Path()..addOval(Rect.fromCenter(center: const Offset(84, 186), width: 28, height: 15)), _p(_limb));
    _limbTube(c, const Offset(110, 158), Offset(121, 167 - 3 * hop), 11);
    c.save();
    c.translate(127, 170 - 3 * hop);
    c.rotate(-0.5);
    _shape(c, Path()..addOval(Rect.fromCenter(center: Offset.zero, width: 24, height: 14)), _p(_limb));
    c.drawCircle(const Offset(0, 0), 3.6, _p(_pad));
    c.restore();

    // Torso with dark chest.
    final torso = Path()..addOval(Rect.fromCenter(center: const Offset(100, 132), width: 64, height: 66));
    _shape(c, torso, _furPaint(torso.getBounds()), clipInner: (c) {
      c.drawOval(Rect.fromCenter(center: const Offset(100, 144), width: 38, height: 52), _p(_limb));
    });

    // Arms up at shoulder height, paw pads facing us.
    final wav = 3 * math.sin(phase * 10 * math.pi);
    for (final sx in [-1.0, 1.0]) {
      final paw = Offset(100 + sx * 46, 110 - wav * sx * 0.5 - 2 * hop);
      _limbTube(c, Offset(100 + sx * 20, 124), paw, 8.5);
      _pawPads(c, paw, 12.5);
    }

    _head(c,
        at: Offset(100, 62 + 2 * hop),
        scale: 0.92,
        angle: -0.05 + 0.03 * math.sin(phase * 10 * math.pi),
        eyes: _Eyes.sparkle,
        mouth: _Mouth.grin,
        earL: -0.32 - 0.1 * hop,
        earR: 0.32 + 0.1 * hop,
        earScale: 1.05,
        blink: blink);
    c.restore();

    // Twinkles.
    for (var i = 0; i < 3; i++) {
      final u = (phase * 2 + i / 3) % 1.0;
      final a = math.sin(u * math.pi);
      const spots = [Offset(28, 40), Offset(176, 30), Offset(24, 128)];
      _star(c, spots[i], 4 + 5 * a, _gold.withValues(alpha: a));
    }
  }

  void _sad(Canvas c) {
    final sniff = _pulse(phase, 0.3, 0.06);
    _shadow(c, const Offset(96, 194), 130);

    // Limp tail lying on the ground.
    final tail = Path()
      ..moveTo(112, 180)
      ..cubicTo(136, 192, 160, 190, 176, 186)
      ..cubicTo(184, 184, 188, 182, 190, 178);
    _tail(c, tail, maxR: 12, minR: 8);

    _sittingBody(c, 90);
    _head(c,
        at: Offset(90, 85 + 1.2 * sniff),
        angle: 0.07 + 0.015 * _wave,
        eyes: _Eyes.teary,
        mouth: _Mouth.frown,
        earL: -1.25 - 0.05 * _wave,
        earR: 1.25 + 0.05 * _wave,
        look: const Offset(0, 0.35),
        blink: blink * 0.6,
        worried: true);
  }

  // ---------------------------------------------------------------- parts

  /// Sitting body (curious / sad): haunches, round torso, front paws down.
  void _sittingBody(Canvas c, double cx) {
    for (final sx in [-1.0, 1.0]) {
      _shape(c, Path()..addOval(Rect.fromCenter(center: Offset(cx + sx * 30, 172), width: 40, height: 36)), _p(_limb));
    }
    final torso = Path()..addOval(Rect.fromCenter(center: Offset(cx, 150), width: 72, height: 76));
    _shape(c, torso, _furPaint(torso.getBounds()));
    for (final sx in [-1.0, 1.0]) {
      _limbTube(c, Offset(cx + sx * 13, 160), Offset(cx + sx * 14, 184), 9.5);
      _shape(c, Path()..addOval(Rect.fromCenter(center: Offset(cx + sx * 14, 188), width: 22, height: 12)), _p(_limb));
      _shape(c, Path()..addOval(Rect.fromCenter(center: Offset(cx + sx * 40, 189), width: 24, height: 11)), _p(_limb));
    }
  }

  static final Path _headShape = () {
    final oval = Path()..addOval(Rect.fromCenter(center: Offset.zero, width: 112, height: 90));
    final tufts = Path()
      ..moveTo(-50, 2)
      ..quadraticBezierTo(-66, 20, -61, 31)
      ..quadraticBezierTo(-52, 29, -42, 35)
      ..close()
      ..moveTo(50, 2)
      ..quadraticBezierTo(66, 20, 61, 31)
      ..quadraticBezierTo(52, 29, 42, 35)
      ..close();
    return Path.combine(PathOperation.union, oval, tufts);
  }();

  void _head(
    Canvas c, {
    required Offset at,
    double scale = 1,
    double angle = 0,
    required _Eyes eyes,
    required _Mouth mouth,
    required double earL,
    required double earR,
    double earScale = 1,
    Offset look = Offset.zero,
    double blink = 0,
    bool worried = false,
  }) {
    c.save();
    c.translate(at.dx, at.dy);
    c.rotate(angle);
    c.scale(scale);

    // Ears (bases hidden under the head).
    for (final sx in [-1.0, 1.0]) {
      c.save();
      c.translate(sx * 33, -24);
      c.rotate(sx < 0 ? earL : earR);
      c.scale(earScale);
      final ear = Path()
        ..moveTo(-17, 10)
        ..cubicTo(-20, -8, -9, -29, 0, -32)
        ..cubicTo(9, -29, 20, -8, 17, 10)
        ..close();
      _shape(c, ear, _p(_furDeep));
      final inner = Path()
        ..moveTo(-10, 6)
        ..cubicTo(-12, -6, -6, -21, 0, -23)
        ..cubicTo(6, -21, 12, -6, 10, 6)
        ..close();
      c.drawPath(inner, _p(_cream));
      c.restore();
    }

    final head = _headShape;
    c.drawPath(head, _furPaint(const Rect.fromLTRB(-60, -45, 60, 45)));
    c.save();
    c.clipPath(head);
    // Cream muzzle + cheeks.
    final cream = _p(_cream);
    c.drawOval(Rect.fromCenter(center: const Offset(0, 22), width: 50, height: 34), cream);
    for (final sx in [-1.0, 1.0]) {
      c.drawOval(Rect.fromCenter(center: Offset(sx * 34, 20), width: 48, height: 34), cream);
    }
    // Tear marks from the eyes down across the cheeks.
    final mark = Paint()
      ..color = _tearMark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.5
      ..strokeCap = StrokeCap.round;
    for (final sx in [-1.0, 1.0]) {
      c.drawPath(
          Path()
            ..moveTo(sx * 21, 4)
            ..quadraticBezierTo(sx * 21, 20, sx * 30, 33),
          mark);
      c.drawOval(Rect.fromCenter(center: Offset(sx * 41, 19), width: 14, height: 8), _p(_blush));
    }
    c.restore();
    c.drawPath(head, _outline);

    // Brows (cream), tilted up in the middle when worried.
    for (final sx in [-1.0, 1.0]) {
      c.save();
      c.translate(sx * 22, worried ? -26 : -25);
      c.rotate(worried ? sx * 0.38 : sx * -0.08);
      c.drawOval(Rect.fromCenter(center: Offset.zero, width: 20, height: 10), cream);
      c.restore();
    }

    for (final sx in [-1.0, 1.0]) {
      _eye(c, Offset(sx * 23, -4), sx, eyes, look, blink);
    }

    // Nose.
    final nose = Path()
      ..moveTo(-7.5, 8)
      ..quadraticBezierTo(0, 4.5, 7.5, 8)
      ..quadraticBezierTo(6, 14, 0, 15.5)
      ..quadraticBezierTo(-6, 14, -7.5, 8)
      ..close();
    c.drawPath(nose, _p(_ink));
    c.drawOval(Rect.fromCenter(center: const Offset(-2, 8.3), width: 4.5, height: 2), _p(const Color(0xB3FFFFFF)));

    _mouth(c, mouth);
    c.restore();
  }

  void _eye(Canvas c, Offset at, double sx, _Eyes kind, Offset look, double blink) {
    final ink = _p(_ink);
    if (kind == _Eyes.closed || blink > 0.9) {
      // Peaceful closed eye: a soft "‿" with a tiny lash.
      final line = Paint()
        ..color = _ink
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.4
        ..strokeCap = StrokeCap.round;
      c.drawPath(
          Path()
            ..moveTo(at.dx - 9, at.dy)
            ..quadraticBezierTo(at.dx, at.dy + 8, at.dx + 9, at.dy),
          line);
      c.drawLine(Offset(at.dx + sx * 9, at.dy), Offset(at.dx + sx * 12, at.dy - 2.5), line..strokeWidth = 2.4);
      return;
    }
    const w = 23.0, h = 26.0;
    c.save();
    c.translate(at.dx, at.dy);
    if (blink > 0) c.scale(1, 1 - blink);
    final r = Rect.fromCenter(center: Offset.zero, width: w, height: h);
    c.drawOval(r.inflate(1.8), ink);
    c.drawOval(
        r,
        Paint()
          ..shader = const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF2F4A17), Color(0xFF86B934), Color(0xFFE2E05C)],
            stops: [0.15, 0.6, 1],
          ).createShader(r));
    final lk = Offset(look.dx.clamp(-1.0, 1.0) * 2.5, look.dy.clamp(-1.0, 1.0) * 2);
    final big = kind == _Eyes.sparkle || kind == _Eyes.teary;
    c.drawOval(Rect.fromCenter(center: lk + const Offset(0, -1.5), width: w * (big ? 0.68 : 0.6), height: h * (big ? 0.7 : 0.64)),
        _p(const Color(0xFF1C0F09)));
    if (kind == _Eyes.teary) {
      c.save();
      c.clipPath(Path()..addOval(r));
      c.drawRect(Rect.fromLTRB(-w, h * 0.16, w, h), _p(const Color(0x7AA9DDF8)));
      c.restore();
    }
    final hi = _p(const Color(0xFFFFFFFF));
    c.drawCircle(lk + Offset(w * 0.17, -h * 0.2), w * (big ? 0.24 : 0.2), hi);
    c.drawCircle(lk + Offset(-w * 0.2, h * 0.2), w * 0.09, hi);
    if (kind == _Eyes.sparkle) _star(c, lk + Offset(-w * 0.16, -h * 0.12), 3.2, const Color(0xFFFFFFFF));
    if (kind == _Eyes.teary) c.drawCircle(lk + Offset(w * 0.02, h * 0.28), w * 0.07, hi);
    c.restore();

    if (kind == _Eyes.teary) {
      // A glossy tear welling at the outer corner.
      final tc = Offset(at.dx + sx * 12, at.dy + 12 + 2 * _pulse(phase, 0.6, 0.2));
      final drop = Path()
        ..moveTo(tc.dx, tc.dy - 6)
        ..quadraticBezierTo(tc.dx + 4.5, tc.dy, tc.dx, tc.dy + 3.5)
        ..quadraticBezierTo(tc.dx - 4.5, tc.dy, tc.dx, tc.dy - 6)
        ..close();
      c.drawPath(drop, _p(const Color(0xE69ED6F7)));
      c.drawPath(drop, Paint()
        ..color = const Color(0xFF4E8CB8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2);
      c.drawCircle(tc + const Offset(-1, -0.5), 1.1, _p(const Color(0xFFFFFFFF)));
    }
  }

  void _mouth(Canvas c, _Mouth kind) {
    final line = Paint()
      ..color = _ink
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    switch (kind) {
      case _Mouth.smile:
      case _Mouth.sleep:
        final k = kind == _Mouth.sleep ? 0.8 : 1.0;
        c.drawLine(const Offset(0, 15), Offset(0, 15 + 3 * k), line);
        c.drawArc(Rect.fromCenter(center: Offset(-4.5 * k, 18 * k + 15 * (1 - k)), width: 9 * k, height: 8 * k), 0, math.pi,
            false, line);
        c.drawArc(Rect.fromCenter(center: Offset(4.5 * k, 18 * k + 15 * (1 - k)), width: 9 * k, height: 8 * k), 0, math.pi,
            false, line);
      case _Mouth.grin:
        final m = Path()
          ..moveTo(-14, 17)
          ..quadraticBezierTo(-7, 20, 0, 16.5)
          ..quadraticBezierTo(7, 20, 14, 17)
          ..cubicTo(12, 34, -12, 34, -14, 17)
          ..close();
        c.drawPath(m, _p(_mouthIn));
        c.save();
        c.clipPath(m);
        c.drawOval(Rect.fromCenter(center: const Offset(0, 31), width: 18, height: 12), _p(_tongue));
        c.restore();
        final fang = _p(const Color(0xFFFFFFFF));
        for (final sx in [-1.0, 1.0]) {
          c.drawPath(
              Path()
                ..moveTo(sx * 10.5, 18)
                ..lineTo(sx * 6, 18.5)
                ..lineTo(sx * 8.4, 23)
                ..close(),
              fang);
        }
        c.drawPath(m, line);
      case _Mouth.frown:
        c.drawLine(const Offset(0, 15), const Offset(0, 18), line);
        c.drawPath(
            Path()
              ..moveTo(-8, 25)
              ..quadraticBezierTo(-4, 19, 0, 21)
              ..quadraticBezierTo(4, 19, 8, 25),
            line);
    }
  }

  /// Bushy ringed tail along [path]: thick in the middle, dark tip.
  void _tail(Canvas c, Path path, {required double maxR, required double minR}) {
    double r(double t) {
      final r = minR + (maxR - minR) * math.sin(math.pi * (0.12 + 0.8 * t));
      return t < 0.85 ? r : r * (1 - (t - 0.85) / 0.15 * 0.4);
    }

    _tube(c, path, r, (t) {
      if (t > 0.91) return _limb;
      final u = t * 6.5 % 1.0;
      if (u < 0.5) return _fur;
      if (u < 0.62) return _cream;
      return _gold;
    });
  }

  void _limbTube(Canvas c, Offset a, Offset b, double r) {
    _tube(c, Path()..moveTo(a.dx, a.dy)..lineTo(b.dx, b.dy), (_) => r, (_) => _limb);
  }

  /// Draws a variable-width tube as overlapping discs: an ink pass for the
  /// outline, then a colour pass, which gives one clean outline around it.
  void _tube(Canvas c, Path path, double Function(double t) radius, Color Function(double t) color) {
    final samples = <(Offset, double, double)>[];
    final metrics = path.computeMetrics().toList();
    final total = metrics.fold<double>(0, (a, m) => a + m.length);
    if (total <= 0) return;
    var acc = 0.0;
    for (final m in metrics) {
      for (double d = 0; d <= m.length; d += 1) {
        final t = (acc + d) / total;
        samples.add((m.getTangentForOffset(d)!.position, radius(t), t));
      }
      acc += m.length;
    }
    final ink = _p(_ink);
    for (final s in samples) {
      c.drawCircle(s.$1, s.$2 + _line / 2, ink);
    }
    final fill = Paint();
    for (final s in samples) {
      c.drawCircle(s.$1, s.$2, fill..color = color(s.$3));
    }
  }

  void _pawPads(Canvas c, Offset at, double r) {
    c.drawCircle(at, r + _line / 2, _p(_ink));
    c.drawCircle(at, r, _p(_limb));
    final pad = _p(_pad);
    c.drawOval(Rect.fromCenter(center: at + Offset(0, r * 0.25), width: r * 0.95, height: r * 0.75), pad);
    for (final dx in [-0.5, 0.0, 0.5]) {
      c.drawCircle(at + Offset(dx * r, -r * (0.42 + (dx == 0 ? 0.1 : 0))), r * 0.2, pad);
    }
  }

  void _shadow(Canvas c, Offset at, double w) {
    c.drawOval(Rect.fromCenter(center: at, width: w, height: w * 0.09), _p(const Color(0x1F3B1F14)));
  }

  void _zee(Canvas c, Offset at, double s, double alpha) {
    if (alpha <= 0.02) return;
    c.drawPath(
        Path()
          ..moveTo(at.dx - s / 2, at.dy - s / 2)
          ..lineTo(at.dx + s / 2, at.dy - s / 2)
          ..lineTo(at.dx - s / 2, at.dy + s / 2)
          ..lineTo(at.dx + s / 2, at.dy + s / 2),
        Paint()
          ..color = const Color(0xFF7A5A8C).withValues(alpha: alpha * 0.85)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.4
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);
  }

  void _star(Canvas c, Offset at, double r, Color color) {
    if (r <= 0 || color.a <= 0.02) return;
    final p = Path()..moveTo(at.dx, at.dy - r);
    p
      ..quadraticBezierTo(at.dx, at.dy, at.dx + r, at.dy)
      ..quadraticBezierTo(at.dx, at.dy, at.dx, at.dy + r)
      ..quadraticBezierTo(at.dx, at.dy, at.dx - r, at.dy)
      ..quadraticBezierTo(at.dx, at.dy, at.dx, at.dy - r)
      ..close();
    c.drawPath(p, _p(color));
  }

  // --------------------------------------------------------------- helpers

  static Paint _p(Color c) => Paint()..color = c;

  static final Paint _outline = Paint()
    ..color = _ink
    ..style = PaintingStyle.stroke
    ..strokeWidth = _line
    ..strokeJoin = StrokeJoin.round;

  static Paint _furPaint(Rect r) => Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [_furLight, _fur, _furDeep],
    ).createShader(r);

  void _shape(Canvas c, Path p, Paint fill, {void Function(Canvas c)? clipInner}) {
    c.drawPath(p, fill);
    if (clipInner != null) {
      c.save();
      c.clipPath(p);
      clipInner(c);
      c.restore();
    }
    c.drawPath(p, _outline);
  }

  /// Triangular bump 0..1..0 centred on [at] with half-width [w] in loop phase.
  static double _pulse(double phase, double at, double w) {
    final d = (phase - at).abs();
    return d >= w ? 0 : 1 - d / w;
  }

  @override
  bool shouldRepaint(PandaPainter old) =>
      old.pose != pose || old.phase != phase || old.earTilt != earTilt || old.blink != blink;
}

enum _Eyes { open, closed, sparkle, teary }

enum _Mouth { smile, sleep, grin, frown }
