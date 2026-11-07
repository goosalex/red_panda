import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'walkthrough.dart';

/// Text whose `[words](walkthrough)` parts are blue links that play that
/// walkthrough of the iOS Settings app, e.g.
/// `Allow it in [Settings](microphone).` (see [Walkthrough] for the names).
class LinkText extends StatefulWidget {
  const LinkText(this.text, {super.key, this.style, this.textAlign, this.onLink});

  final String text;

  /// What a link does; by default it shows the walkthrough from here. A
  /// SnackBar sits above the Navigator, so it passes the screen's own.
  final void Function(Walkthrough)? onLink;
  final TextStyle? style;
  final TextAlign? textAlign;

  static final _link = RegExp(r'\[([^\]]+)\]\((\w+)\)');

  /// [text] without the link markup, e.g. for a semantics label or a test.
  static String plain(String text) => text.replaceAllMapped(_link, (m) => m[1]!);

  /// The walkthroughs [text] links to, in order.
  static List<String> targets(String text) => [for (final m in _link.allMatches(text)) m[2]!];

  @override
  State<LinkText> createState() => _LinkTextState();
}

class _LinkTextState extends State<LinkText> {
  final _recognizers = <TapGestureRecognizer>[];

  @override
  void dispose() {
    _drop();
    super.dispose();
  }

  void _drop() {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();
  }

  @override
  Widget build(BuildContext context) {
    _drop();
    final spans = <InlineSpan>[];
    var at = 0;
    for (final m in LinkText._link.allMatches(widget.text)) {
      if (m.start > at) spans.add(TextSpan(text: widget.text.substring(at, m.start)));
      final w = Walkthrough.byName(m[2]!);
      if (w == null) {
        spans.add(TextSpan(text: m[1]));
      } else {
        final r = TapGestureRecognizer()
          ..onTap = () => widget.onLink != null ? widget.onLink!(w) : showWalkthrough(context, w);
        _recognizers.add(r);
        spans.add(TextSpan(text: m[1], style: const TextStyle(color: linkBlue), recognizer: r));
      }
      at = m.end;
    }
    if (at < widget.text.length) spans.add(TextSpan(text: widget.text.substring(at)));
    return Text.rich(TextSpan(children: spans, style: widget.style), textAlign: widget.textAlign);
  }
}
