import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../platform/leave_basket.dart';

/// Short animations of the way to Red Panda's settings in the iOS Settings
/// app: real screenshots of the Settings app in each app language, with blue
/// pulses where to tap.
///
/// Recorded by tool/walkthroughs/record.sh into assets/walkthroughs/. When a
/// language is added to the app, record it there too: a test checks that every
/// walkthrough exists in every language.
enum Walkthrough {
  /// Privacy & Security > Location Services > Red Panda > Always.
  location,

  /// Privacy & Security > Microphone and Speech Recognition > Red Panda.
  microphone,

  /// Apple Intelligence & Siri > Apps > Red Panda.
  siri,

  /// Action Button > Controls > Red Panda > Text note.
  actionButton;

  String title(AppLocalizations l) => switch (this) {
        location => l.walkLocationTitle,
        microphone => l.walkMicrophoneTitle,
        siri => l.walkSiriTitle,
        actionButton => l.walkActionButtonTitle,
      };

  /// Whether "Open Settings" (Red Panda's page in Settings) helps here.
  bool get opensSettings => this != actionButton;

  static Walkthrough? byName(String name) => values.where((w) => w.name == name).firstOrNull;
}

/// One screenshot of a walkthrough: where the finger taps or swipes
/// (fractions of the screen) and the name of what it taps.
class WalkFrame {
  const WalkFrame({required this.image, this.tap, this.swipeFrom, this.swipeTo, this.label});

  factory WalkFrame.fromJson(Map<String, dynamic> j) {
    Offset? at(Object? o) => o is Map ? Offset((o['x'] as num).toDouble(), (o['y'] as num).toDouble()) : null;
    final swipe = j['swipe'] as Map?;
    return WalkFrame(
      image: 'assets/walkthroughs/${j['image']}',
      tap: at(j['tap']),
      swipeFrom: at(swipe?['from']),
      swipeTo: at(swipe?['to']),
      label: j['label'] as String?,
    );
  }

  final String image;
  final Offset? tap;
  final Offset? swipeFrom;
  final Offset? swipeTo;
  final String? label;

  bool get isSwipe => swipeFrom != null && swipeTo != null;
}

/// The recorded walkthroughs, from assets/walkthroughs/walkthroughs.json.
class WalkLibrary {
  WalkLibrary(this._index);

  static const asset = 'assets/walkthroughs/walkthroughs.json';
  static Future<WalkLibrary>? _loaded;

  static Future<WalkLibrary> load([AssetBundle? bundle]) =>
      _loaded ??= (bundle ?? rootBundle).loadString(asset).then((s) => WalkLibrary(jsonDecode(s) as Map<String, dynamic>));

  final Map<String, dynamic> _index;

  /// The frames in [lang], or in English if that language is missing.
  List<WalkFrame> frames(Walkthrough w, String lang) {
    final byLang = (_index[w.name] as Map<String, dynamic>?) ?? const {};
    final list = (byLang[lang] ?? byLang['en']) as List<dynamic>? ?? const [];
    return [for (final f in list) WalkFrame.fromJson(f as Map<String, dynamic>)];
  }

  /// Languages [w] was recorded in.
  Set<String> languages(Walkthrough w) => ((_index[w.name] as Map<String, dynamic>?) ?? const {}).keys.toSet();
}

/// Shows [w] in a sheet, with "Open Settings" where that helps.
Future<void> showWalkthrough(BuildContext context, Walkthrough w) {
  final lang = Localizations.localeOf(context).languageCode;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (ctx) {
      final l = ctx.l10n;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(w.title(l), style: Theme.of(ctx).textTheme.titleMedium, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              FutureBuilder<WalkLibrary>(
                future: WalkLibrary.load(DefaultAssetBundle.of(ctx)),
                builder: (_, snap) => snap.hasData
                    ? WalkthroughPlayer(frames: snap.data!.frames(w, lang))
                    : const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
              ),
              if (w == Walkthrough.actionButton) ...[
                const SizedBox(height: 6),
                Text(l.walkActionButtonNote,
                    textAlign: TextAlign.center, style: Theme.of(ctx).textTheme.bodySmall),
              ],
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (w.opensSettings) ...[
                    FilledButton.icon(
                      icon: const Icon(Icons.open_in_new, size: 18),
                      label: Text(l.openSettings),
                      onPressed: () {
                        Navigator.pop(ctx);
                        LeaveBasket.openSettings();
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                  TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l.ok)),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// Plays [frames] in a loop: each screenshot, then blue pulses where to tap
/// (or a blue dot gliding along a swipe), then the next one. The path so far
/// is spelled out above, in the names iOS uses in this language.
class WalkthroughPlayer extends StatefulWidget {
  const WalkthroughPlayer({super.key, required this.frames});

  final List<WalkFrame> frames;

  /// Time per screenshot; the last one (the result) stays a little longer.
  static const step = Duration(milliseconds: 2200);

  @override
  State<WalkthroughPlayer> createState() => _WalkthroughPlayerState();
}

class _WalkthroughPlayerState extends State<WalkthroughPlayer> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(vsync: this, duration: WalkthroughPlayer.step)
    ..addStatusListener(_next);
  int _i = 0;
  bool _cached = false;

  @override
  void initState() {
    super.initState();
    if (widget.frames.isNotEmpty) _c.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cached) return;
    _cached = true;
    for (final f in widget.frames) {
      precacheImage(AssetImage(f.image), context).ignore();
    }
  }

  void _next(AnimationStatus s) {
    if (s != AnimationStatus.completed || !mounted) return;
    setState(() => _i = (_i + 1) % widget.frames.length);
    final last = _i == widget.frames.length - 1;
    _c.duration = WalkthroughPlayer.step * (last ? 1.4 : 1);
    _c.forward(from: 0);
  }

  void _jump(int i) {
    setState(() => _i = i);
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final frames = widget.frames;
    if (frames.isEmpty) return const SizedBox.shrink();
    final calm = MediaQuery.disableAnimationsOf(context);
    final frame = frames[_i];
    final screenH = MediaQuery.sizeOf(context).height;
    final phoneH = (screenH * 0.5).clamp(260.0, 500.0);
    final steps = [for (final f in frames) f.label].whereType<String>().toList();
    final current = frames.take(_i + 1).where((f) => f.label != null).length - 1;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _Path(steps: steps, current: _i == frames.length - 1 ? steps.length : current, onTap: (n) {
          var seen = -1;
          for (final (i, f) in frames.indexed) {
            if (f.label != null && ++seen == n) return _jump(i);
          }
        }),
        const SizedBox(height: 10),
        Semantics(
          label: context.l10n.walkSemantics(steps.join(' › ')),
          image: true,
          child: ExcludeSemantics(
            child: Container(
              height: phoneH,
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(34)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(29),
                child: AspectRatio(
                  aspectRatio: 1206 / 2622,
                  child: AnimatedSwitcher(
                    duration: calm ? Duration.zero : const Duration(milliseconds: 280),
                    child: Stack(
                      key: ValueKey(_i),
                      fit: StackFit.expand,
                      children: [
                        Image.asset(frame.image, fit: BoxFit.cover, gaplessPlayback: true),
                        AnimatedBuilder(
                          animation: _c,
                          builder: (_, _) => CustomPaint(painter: TouchPainter(frame, _c.value, calm: calm)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// The path as tappable steps: "Settings › Privacy & Security › …", the
/// current one in bold blue.
class _Path extends StatelessWidget {
  const _Path({required this.steps, required this.current, required this.onTap});

  final List<String> steps;
  final int current;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.bodyMedium!;
    return Text.rich(
      TextSpan(children: [
        for (final (i, s) in steps.indexed) ...[
          if (i > 0) TextSpan(text: ' › ', style: TextStyle(color: base.color?.withValues(alpha: 0.5))),
          TextSpan(
            text: s,
            style: TextStyle(
              color: i <= current ? linkBlue : base.color?.withValues(alpha: 0.6),
              fontWeight: i == current ? FontWeight.w600 : FontWeight.normal,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => onTap(i),
          ),
        ],
      ]),
      textAlign: TextAlign.center,
    );
  }
}

/// iOS link blue.
const linkBlue = Color(0xFF007AFF);

/// Draws the finger: during the middle of a frame, a blue dot with two rings
/// pulsing out of it (a tap) or gliding from start to end (a swipe).
class TouchPainter extends CustomPainter {
  TouchPainter(this.frame, this.t, {this.calm = false});

  final WalkFrame frame;

  /// Progress through the frame, 0…1.
  final double t;

  /// Reduce Motion: a still dot and ring instead of pulses and gliding.
  final bool calm;

  static const _start = 0.3, _end = 0.9;

  @override
  void paint(Canvas canvas, Size size) {
    if (t < _start || t > _end) return;
    final p = (t - _start) / (_end - _start);
    final fill = Paint()..color = linkBlue.withValues(alpha: 0.45);
    final r = size.width * 0.045;
    if (frame.isSwipe) {
      final a = Offset(frame.swipeFrom!.dx * size.width, frame.swipeFrom!.dy * size.height);
      final b = Offset(frame.swipeTo!.dx * size.width, frame.swipeTo!.dy * size.height);
      final at = calm ? b : Offset.lerp(a, b, Curves.easeInOut.transform(p))!;
      canvas.drawLine(a, at, Paint()
        ..color = linkBlue.withValues(alpha: 0.25)
        ..strokeWidth = r * 1.4
        ..strokeCap = StrokeCap.round);
      canvas.drawCircle(at, r, fill);
      return;
    }
    final tap = frame.tap;
    if (tap == null) return;
    final c = Offset(tap.dx * size.width, tap.dy * size.height);
    final ring = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = r * 0.28;
    if (calm) {
      canvas.drawCircle(c, r, fill);
      canvas.drawCircle(c, r * 1.8, ring..color = linkBlue.withValues(alpha: 0.6));
      return;
    }
    // The dot presses in, then two rings spread out of it.
    canvas.drawCircle(c, r * (0.85 + 0.15 * (1 - (p * 2 - 1).abs())), fill);
    for (final delay in const [0.0, 0.35]) {
      final q = ((p - delay) / 0.65).clamp(0.0, 1.0);
      if (q <= 0 || q >= 1) continue;
      canvas.drawCircle(c, r * (1 + 1.6 * q), ring..color = linkBlue.withValues(alpha: 0.7 * (1 - q)));
    }
  }

  @override
  bool shouldRepaint(TouchPainter old) => old.t != t || old.frame != frame || old.calm != calm;
}
