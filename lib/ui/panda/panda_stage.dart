/// The red panda mascot "stage" shown above the home list.
///
/// [PandaStage] is a full-width box whose height animates: at rest it is
/// [PandaStage.restingHeight]; on [PandaStageController.celebrate] it grows to
/// [PandaStage.celebrationHeight] (pushing the list below it down), the panda
/// stands up into its excited pose with a hop and a star burst, holds, then
/// the stage shrinks back and the panda returns to its idle pose.
///
/// Art: the panda is drawn by [PandaPainter] (vector placeholder). To replace
/// a pose with real artwork (e.g. NovelAI renders) add either
///   * `assets/panda/<pose>.png` (single still), or
///   * `assets/panda/<pose>_0.png`, `<pose>_1.png`, … (frames, played at
///     [artFps] in a loop),
/// where `<pose>` is a [PandaPose] name (`sleeping`, `curious`, `excited`,
/// `sad`), and list `assets/panda/` under `flutter: assets:` in pubspec.yaml.
/// Images should be square with a transparent background and the panda
/// standing on the bottom edge. Poses without images keep using the painter.
library;

import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'panda_painter.dart';

export 'panda_painter.dart' show PandaPose, PandaPainter;

/// Frame rate for image-frame poses (`assets/panda/<pose>_N.png`).
const artFps = 8;

class PandaStageController extends ChangeNotifier {
  PandaPose _idle = PandaPose.sleeping;
  bool _typing = false;
  _PandaStageState? _stage;

  /// What the panda returns to after an action (sleeping, or sad when items
  /// are overdue).
  PandaPose get idlePose => _idle;
  set idlePose(PandaPose p) {
    if (p == _idle) return;
    _idle = p;
    notifyListeners();
  }

  bool get isTyping => _typing;

  /// Curious pose until [stopTyping].
  void startTyping() {
    if (_typing) return;
    _typing = true;
    notifyListeners();
  }

  void stopTyping() {
    if (!_typing) return;
    _typing = false;
    notifyListeners();
  }

  /// Stand up and celebrate, then go back to [idlePose]. Calling it again
  /// while celebrating extends the celebration.
  void celebrate() => _stage?._celebrate();

  /// Small wake-up wiggle, then back to [idlePose].
  void greet() => _stage?._greet();

  bool get isCelebrating => _stage?._celebrating ?? false;

  void _changed() => notifyListeners();
}

class PandaStage extends StatefulWidget {
  const PandaStage({
    super.key,
    required this.controller,
    this.restingHeight = 150,
    this.celebrationHeight = 320,
    this.tilt,
    this.background,
    this.foreground,
    this.onTapPanda,
  });

  final PandaStageController controller;

  /// Stage height while idle.
  final double restingHeight;

  /// The stage grows to this height while celebrating.
  final double celebrationHeight;

  /// Motion-sensor tilt, roughly -1..1 per axis; ears follow it while curious.
  final Stream<Offset>? tilt;

  /// Filled behind the panda (e.g. category clouds).
  final Widget? background;

  /// Filled above the panda (e.g. sun/moon button). Only its hit-testable
  /// parts block taps on the panda.
  final Widget? foreground;

  final VoidCallback? onTapPanda;

  @override
  State<PandaStage> createState() => _PandaStageState();
}

class _PandaStageState extends State<PandaStage> with TickerProviderStateMixin {
  static const _loopPeriod = Duration(seconds: 4);
  static const _sitUp = Duration(milliseconds: 220);
  static const _hold = Duration(milliseconds: 2000);
  static const _shrink = Duration(milliseconds: 650);

  /// Idle loop: breathing, tail sway, blinks, hops.
  late final AnimationController _loop = AnimationController(vsync: this, duration: _loopPeriod);

  /// 0 = resting height, 1 = celebration height.
  late final AnimationController _height = AnimationController(vsync: this);

  /// Star burst + big jump when the panda stands up.
  late final AnimationController _burst =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));

  late final AnimationController _hello =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 1100));

  final _tilt = ValueNotifier<Offset>(Offset.zero);
  StreamSubscription<Offset>? _tiltSub;
  final _timers = <Timer>[];

  PandaPose? _action; // pose forced by celebrate()
  bool _celebrating = false;
  bool _greeting = false;
  bool _reduceMotion = false;
  Map<PandaPose, List<String>> _art = const {};

  @override
  void initState() {
    super.initState();
    _attach(widget.controller);
    _listenTilt();
    _hello.addStatusListener((s) {
      if (s == AnimationStatus.completed && _greeting) setState(() => _greeting = false);
    });
    _loadArt.then((art) {
      if (mounted && art.isNotEmpty) setState(() => _art = art);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reduceMotion = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    if (_reduceMotion) {
      _loop.stop();
      _loop.value = 0;
    } else if (!_loop.isAnimating) {
      _loop.repeat();
    }
  }

  @override
  void didUpdateWidget(PandaStage old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _detach(old.controller);
      _attach(widget.controller);
    }
    if (old.tilt != widget.tilt) _listenTilt();
  }

  @override
  void dispose() {
    _detach(widget.controller);
    _cancelTimers();
    _tiltSub?.cancel();
    _tilt.dispose();
    _loop.dispose();
    _height.dispose();
    _burst.dispose();
    _hello.dispose();
    super.dispose();
  }

  void _attach(PandaStageController c) {
    c._stage = this;
    c.addListener(_onController);
  }

  void _detach(PandaStageController c) {
    if (c._stage == this) c._stage = null;
    c.removeListener(_onController);
  }

  void _onController() {
    if (mounted) setState(() {});
  }

  void _listenTilt() {
    _tiltSub?.cancel();
    _tiltSub = widget.tilt?.listen((t) {
      final target = Offset(t.dx.clamp(-1.0, 1.0), t.dy.clamp(-1.0, 1.0));
      _tilt.value = Offset.lerp(_tilt.value, target, 0.35)!;
    });
  }

  // ------------------------------------------------------------ actions

  void _later(Duration d, VoidCallback f) {
    late final Timer t;
    t = Timer(d, () {
      _timers.remove(t);
      if (mounted) f();
    });
    _timers.add(t);
  }

  void _cancelTimers() {
    for (final t in _timers) {
      t.cancel();
    }
    _timers.clear();
  }

  void _setCelebrating(bool v) {
    if (_celebrating == v) return;
    _celebrating = v;
    widget.controller._changed();
  }

  void _setAction(PandaPose? p) {
    if (mounted) setState(() => _action = p);
  }

  void _celebrate() {
    _cancelTimers();
    _greeting = false;
    _setCelebrating(true);
    if (_reduceMotion) {
      _setAction(PandaPose.excited);
      _later(const Duration(milliseconds: 1500), () {
        _setAction(null);
        _setCelebrating(false);
      });
      return;
    }

    final grow = (450 * (1 - _height.value)).round().clamp(1, 450);
    _height.animateTo(1, duration: Duration(milliseconds: grow), curve: Curves.easeOutCubic);

    void standUp() {
      _setAction(PandaPose.excited);
      _burst.forward(from: 0);
    }

    if (_action == PandaPose.excited) {
      standUp();
    } else {
      _setAction(PandaPose.curious); // sit up first
      _later(_sitUp, standUp);
    }

    _later(_hold, () {
      // Sit back down (briefly, when going back to sleep) while shrinking.
      final sleepy = widget.controller.idlePose == PandaPose.sleeping;
      _setAction(sleepy ? PandaPose.curious : null);
      if (sleepy) _later(const Duration(milliseconds: 320), () => _setAction(null));
      _height.animateTo(0, duration: _shrink, curve: Curves.easeInOutCubic);
      _later(_shrink, () => _setCelebrating(false));
    });
  }

  void _greet() {
    if (_celebrating) return;
    setState(() => _greeting = true);
    if (_reduceMotion) {
      _later(const Duration(milliseconds: 900), () => setState(() => _greeting = false));
    } else {
      _hello.forward(from: 0);
    }
  }

  PandaPose get _pose {
    final c = widget.controller;
    if (_action != null) return _action!;
    if (c._typing) return PandaPose.curious;
    if (_greeting && c.idlePose == PandaPose.sleeping) return PandaPose.curious;
    return c.idlePose;
  }

  // ------------------------------------------------------------ art seam

  static Future<Map<PandaPose, List<String>>>? _artProbe;

  static Future<Map<PandaPose, List<String>>> get _loadArt => _artProbe ??= () async {
        Future<bool> has(String asset) async {
          try {
            await rootBundle.load(asset);
            return true;
          } catch (_) {
            return false;
          }
        }

        final art = <PandaPose, List<String>>{};
        for (final pose in PandaPose.values) {
          final still = 'assets/panda/${pose.name}.png';
          if (await has(still)) {
            art[pose] = [still];
            continue;
          }
          final frames = <String>[];
          while (frames.length < 240 && await has('assets/panda/${pose.name}_${frames.length}.png')) {
            frames.add('assets/panda/${pose.name}_${frames.length}.png');
          }
          if (frames.isNotEmpty) art[pose] = frames;
        }
        return art;
      }();

  // ------------------------------------------------------------ build

  static double _pulse(double phase, double at, double w) {
    final d = (phase - at).abs();
    return d >= w ? 0 : 1 - d / w;
  }

  Widget _figure(PandaPose pose, double dim) {
    return AnimatedBuilder(
      key: ValueKey(pose),
      animation: Listenable.merge([_loop, _tilt, _burst, _hello]),
      builder: (context, _) {
        final phase = _loop.value;
        final frames = _art[pose];
        Widget art;
        if (frames != null && frames.isNotEmpty) {
          final i = (phase * _loopPeriod.inMilliseconds / 1000 * artFps).floor() % frames.length;
          art = Image.asset(frames[i], fit: BoxFit.contain, alignment: Alignment.bottomCenter, gaplessPlayback: true);
        } else {
          art = CustomPaint(
            size: Size.square(dim),
            painter: PandaPainter(
              pose: pose,
              phase: phase,
              earTilt: pose == PandaPose.curious ? _tilt.value : Offset.zero,
              blink: pose == PandaPose.sleeping ? 0 : _pulse(phase, 0.72, 0.025),
            ),
          );
        }

        // Big jump as he stands up, and the greeting wiggle.
        var dy = 0.0;
        if (pose == PandaPose.excited && _burst.isAnimating) {
          final j = (_burst.value / 0.4).clamp(0.0, 1.0);
          dy = -math.sin(j * math.pi) * dim * 0.08;
        }
        final h = _hello.value;
        final wiggle = _greeting ? math.sin(h * math.pi * 4) * 0.07 * (1 - h) : 0.0;
        final pop = _greeting ? 1 + 0.05 * math.sin(h * math.pi) : 1.0;
        return Transform.translate(
          offset: Offset(0, dy),
          child: Transform(
            alignment: Alignment.bottomCenter,
            transform: Matrix4.identity()
              ..rotateZ(wiggle)
              ..scaleByDouble(pop, pop, 1, 1),
            child: art,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pose = _pose;
    return AnimatedBuilder(
      animation: _height,
      builder: (context, _) {
        final h = lerpDouble(widget.restingHeight, widget.celebrationHeight, _height.value)!;
        return SizedBox(
          height: h,
          width: double.infinity,
          child: LayoutBuilder(builder: (context, box) {
            final dim = math.max(0.0, math.min(h * 0.96, box.maxWidth));
            return Stack(
              clipBehavior: Clip.none,
              children: [
                if (widget.background != null) Positioned.fill(child: widget.background!),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onTapPanda,
                    child: SizedBox.square(
                      dimension: dim,
                      child: Stack(
                        clipBehavior: Clip.none,
                        fit: StackFit.expand,
                        children: [
                          IgnorePointer(
                            child: CustomPaint(painter: _BurstPainter(_burst)),
                          ),
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: _reduceMotion ? 0 : 260),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, anim) => FadeTransition(
                              opacity: anim,
                              child: ScaleTransition(
                                alignment: Alignment.bottomCenter,
                                scale: Tween(begin: 0.92, end: 1.0).animate(anim),
                                child: child,
                              ),
                            ),
                            layoutBuilder: (current, previous) => Stack(
                              fit: StackFit.expand,
                              children: [...previous, ?current],
                            ),
                            child: _figure(pose, dim),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                if (widget.foreground != null) Positioned.fill(child: widget.foreground!),
              ],
            );
          }),
        );
      },
    );
  }
}

/// Little star burst around the panda when he stands up.
class _BurstPainter extends CustomPainter {
  _BurstPainter(this.t) : super(repaint: t);

  final Animation<double> t;

  static const _colors = [Color(0xFFE8A324), Color(0xFFFFE27A), Color(0xFFFF9BA8), Color(0xFFFFF4EC)];

  @override
  void paint(Canvas canvas, Size size) {
    final v = t.value;
    if (v <= 0 || v >= 1) return;
    final s = size.shortestSide;
    final centre = Offset(size.width / 2, size.height * 0.42);
    final e = Curves.easeOutCubic.transform(v);
    final fade = 1 - Curves.easeIn.transform(v);
    for (var i = 0; i < 12; i++) {
      final a = i / 12 * 2 * math.pi + 0.2;
      final d = s * (0.22 + (i.isEven ? 0.36 : 0.28) * e);
      final p = centre + Offset(math.cos(a), math.sin(a) * 0.8) * d;
      final r = s * (i.isEven ? 0.035 : 0.024) * (0.4 + 0.6 * math.sin(math.pi * math.min(1.0, v * 1.6)));
      final paint = Paint()..color = _colors[i % _colors.length].withValues(alpha: fade);
      final star = Path()
        ..moveTo(p.dx, p.dy - r)
        ..quadraticBezierTo(p.dx, p.dy, p.dx + r, p.dy)
        ..quadraticBezierTo(p.dx, p.dy, p.dx, p.dy + r)
        ..quadraticBezierTo(p.dx, p.dy, p.dx - r, p.dy)
        ..quadraticBezierTo(p.dx, p.dy, p.dx, p.dy - r)
        ..close();
      canvas.drawPath(star, paint);
    }
  }

  @override
  bool shouldRepaint(_BurstPainter old) => old.t != t;
}
