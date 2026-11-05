import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart' as rive;

/// Input contract with the Rive file (see design doc, "Mascot pipeline"):
///   state machine  : [stateMachineName]
///   triggers       : greet, celebrate, sad
///   number         : streak
/// Drop the finished file at [riveAsset]; until then a drawn placeholder
/// panda with Flutter animations is shown.
const riveAsset = 'assets/rive/red_panda.riv';
const stateMachineName = 'Panda';

class MascotController extends ChangeNotifier {
  _MascotViewState? _view;

  void greet() => _view?._play(_Move.greet);
  void celebrate() => _view?._play(_Move.celebrate);
  void sad() => _view?._play(_Move.sad);

  int _streak = 0;
  set streak(int v) {
    _streak = v;
    _view?._setStreak(v);
  }
}

enum _Move { greet, celebrate, sad }

class MascotView extends StatefulWidget {
  const MascotView({super.key, required this.controller, this.size = 140});

  final MascotController controller;
  final double size;

  @override
  State<MascotView> createState() => _MascotViewState();
}

class _MascotViewState extends State<MascotView> with SingleTickerProviderStateMixin {
  late final AnimationController _anim =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  _Move _move = _Move.greet;

  rive.File? _file;
  rive.RiveWidgetController? _rive;

  @override
  void initState() {
    super.initState();
    widget.controller._view = this;
    _loadRive();
  }

  Future<void> _loadRive() async {
    try {
      await rootBundle.load(riveAsset); // throws if the asset is not bundled yet
      final file = await rive.File.asset(riveAsset, riveFactory: rive.Factory.rive);
      if (file == null || !mounted) return;
      setState(() {
        _file = file;
        _rive = rive.RiveWidgetController(
          file,
          stateMachineSelector: rive.StateMachineSelector.byName(stateMachineName),
        );
      });
      _setStreak(widget.controller._streak);
    } catch (_) {
      // No rig yet: keep the placeholder.
    }
  }

  void _play(_Move move) {
    final c = _rive;
    if (c != null) {
      // ignore: deprecated_member_use
      c.stateMachine.trigger(move.name)?.fire();
      return;
    }
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return;
    setState(() => _move = move);
    _anim.forward(from: 0);
  }

  void _setStreak(int v) {
    // ignore: deprecated_member_use
    _rive?.stateMachine.number('streak')?.value = v.toDouble();
  }

  @override
  void dispose() {
    if (widget.controller._view == this) widget.controller._view = null;
    _anim.dispose();
    _rive?.dispose();
    _file?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = _rive;
    return SizedBox.square(
      dimension: widget.size,
      child: c != null
          ? rive.RiveWidget(controller: c, fit: rive.Fit.contain)
          : AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                final t = Curves.easeOut.transform(_anim.value);
                final wave = math.sin(_anim.value * math.pi);
                double dy = 0, angle = 0, scale = 1;
                switch (_move) {
                  case _Move.greet:
                    angle = math.sin(_anim.value * math.pi * 3) * 0.12 * (1 - t);
                    scale = 1 + 0.06 * wave;
                  case _Move.celebrate:
                    dy = -widget.size * 0.25 * wave;
                    angle = 2 * math.pi * t;
                    scale = 1 + 0.1 * wave;
                  case _Move.sad:
                    dy = widget.size * 0.05 * wave;
                    scale = 1 - 0.05 * wave;
                }
                return Transform.translate(
                  offset: Offset(0, dy),
                  child: Transform.rotate(
                    angle: angle,
                    child: Transform.scale(scale: scale, child: child),
                  ),
                );
              },
              child: CustomPaint(painter: _PandaPainter()),
            ),
    );
  }
}

/// Original placeholder red panda face: round orange-red head, white cheek
/// and ear markings, dark eyes. Replaced by the Rive rig later.
class _PandaPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.shortestSide;
    final c = Offset(size.width / 2, size.height / 2);
    final fur = Paint()..color = const Color(0xFFD9541E);
    final dark = Paint()..color = const Color(0xFF3B1F14);
    final white = Paint()..color = const Color(0xFFFFF7EE);

    // Ears
    for (final sx in [-1.0, 1.0]) {
      final ear = c + Offset(sx * s * 0.30, -s * 0.30);
      canvas.drawCircle(ear, s * 0.15, fur);
      canvas.drawCircle(ear, s * 0.09, white);
    }
    // Head
    canvas.drawOval(Rect.fromCenter(center: c, width: s * 0.86, height: s * 0.76), fur);
    // Cheeks / muzzle
    for (final sx in [-1.0, 1.0]) {
      canvas.drawOval(
          Rect.fromCenter(center: c + Offset(sx * s * 0.18, s * 0.12), width: s * 0.30, height: s * 0.24),
          white);
      // Brows
      canvas.drawOval(
          Rect.fromCenter(center: c + Offset(sx * s * 0.16, -s * 0.15), width: s * 0.14, height: s * 0.07),
          white);
      // Eyes
      canvas.drawCircle(c + Offset(sx * s * 0.16, -s * 0.04), s * 0.055, dark);
      canvas.drawCircle(c + Offset(sx * s * 0.16 + s * 0.018, -s * 0.06), s * 0.016, white);
    }
    // Nose + mouth
    canvas.drawOval(Rect.fromCenter(center: c + Offset(0, s * 0.07), width: s * 0.09, height: s * 0.06), dark);
    final mouth = Paint()
      ..color = const Color(0xFF3B1F14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.018
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCenter(center: c + Offset(-s * 0.035, s * 0.13), width: s * 0.07, height: s * 0.06),
        0, math.pi, false, mouth);
    canvas.drawArc(Rect.fromCenter(center: c + Offset(s * 0.035, s * 0.13), width: s * 0.07, height: s * 0.06),
        0, math.pi, false, mouth);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
