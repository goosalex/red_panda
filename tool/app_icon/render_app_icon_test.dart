// Renders the app icon master (1024x1024) from the same painter the in-app
// placeholder mascot uses, so icon and mascot stay the same character.
// Run via `make icon` (tool/app_icon/make_icons.sh), not as part of `flutter test`.
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/ui/mascot.dart';

const background = Color(0xFFFFF4EC); // warm cream, matches the mascot's markings
const logical = 512.0; // rendered at 2x -> 1024 px

void main() {
  testWidgets('render app icon master', (tester) async {
    final out = Platform.environment['ICON_OUT'] ?? 'build/app_icon/icon_1024.png';
    final key = GlobalKey();
    // The face spans 0.45 above centre (ears) and 0.38 below (chin): nudge it
    // down a little so it sits optically centred, and leave a margin so the
    // ears clear iOS's rounded corners.
    const face = logical * 0.92;
    await tester.pumpWidget(Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.square(
            dimension: logical,
            child: ColoredBox(
              color: background,
              child: Center(
                child: Transform.translate(
                  offset: const Offset(0, face * 0.035),
                  child: MascotView(controller: MascotController(), size: face),
                ),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.pump();

    await tester.runAsync(() async {
      final ro = key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final img = await ro.toImage(pixelRatio: 1024 / logical);
      final png = await img.toByteData(format: ui.ImageByteFormat.png);
      File(out)
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(png!.buffer.asUint8List());
    });
  });
}
