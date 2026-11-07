// Renders each mascot pose to transparent PNGs for the iOS widget asset
// catalog (base 120x120 pt, @2x and @3x). Run via tool/panda_art/make_widget_art.sh,
// not as part of `flutter test`. Output dir: $PANDA_OUT (default build/panda_art).
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/ui/panda/panda_painter.dart';

const points = 120.0;

/// Loop phases picked for a still frame that reads well (z's visible,
/// mid-hop, ...).
const stillPhase = {
  PandaPose.sleeping: 0.15,
  PandaPose.curious: 0.0,
  PandaPose.excited: 0.1,
  PandaPose.sad: 0.0,
};

void main() {
  testWidgets('render panda poses', (tester) async {
    final out = Platform.environment['PANDA_OUT'] ?? 'build/panda_art';
    final scales = (Platform.environment['PANDA_SCALES'] ?? '2,3').split(',').map(int.parse);
    for (final pose in PandaPose.values) {
      final key = GlobalKey();
      await tester.pumpWidget(Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.square(
            dimension: points,
            // The sleeping bun only fills the lower part of the box: lift it
            // so it sits centred in the widget.
            child: Transform.translate(
              offset: Offset(0, pose == PandaPose.sleeping ? -points * 0.14 : 0),
              child: CustomPaint(painter: PandaPainter(pose: pose, phase: stillPhase[pose]!)),
            ),
          ),
        ),
      ));
      await tester.pump();
      for (final scale in scales) {
        await tester.runAsync(() async {
          final ro = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final img = await ro.toImage(pixelRatio: scale.toDouble());
          final png = await img.toByteData(format: ui.ImageByteFormat.png);
          File('$out/${pose.name}@${scale}x.png')
            ..parent.createSync(recursive: true)
            ..writeAsBytesSync(png!.buffer.asUint8List());
        });
      }
    }
  });
}
