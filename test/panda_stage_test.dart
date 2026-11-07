import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/ui/panda/panda_stage.dart';

void main() {
  Widget host(PandaStageController c, {bool reduceMotion = false}) => MediaQuery(
        data: MediaQueryData(disableAnimations: reduceMotion),
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Column(children: [
            PandaStage(key: const Key('stage'), controller: c, restingHeight: 150, celebrationHeight: 320),
            const Expanded(child: SizedBox()),
          ]),
        ),
      );

  double stageHeight(WidgetTester t) => t.getSize(find.byKey(const Key('stage'))).height;

  testWidgets('celebrate grows the stage, then returns to resting height', (tester) async {
    final c = PandaStageController();
    await tester.pumpWidget(host(c));
    expect(stageHeight(tester), 150);
    expect(c.isCelebrating, isFalse);

    c.celebrate();
    await tester.pump();
    expect(c.isCelebrating, isTrue);
    await tester.pump(const Duration(milliseconds: 600));
    expect(stageHeight(tester), greaterThan(150));
    expect(stageHeight(tester), closeTo(320, 0.5));

    // A second call mid-celebration extends it without a jump in height.
    c.celebrate();
    await tester.pump(const Duration(milliseconds: 16));
    expect(stageHeight(tester), closeTo(320, 0.5));

    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(stageHeight(tester), 150);
    expect(c.isCelebrating, isFalse);
  });

  testWidgets('reduced motion swaps the pose without resizing', (tester) async {
    final c = PandaStageController();
    await tester.pumpWidget(host(c, reduceMotion: true));
    c.celebrate();
    await tester.pump(const Duration(milliseconds: 300));
    expect(stageHeight(tester), 150);
    expect(c.isCelebrating, isTrue);
    await tester.pump(const Duration(seconds: 2));
    expect(c.isCelebrating, isFalse);
  });

  Iterable<PandaPose> shownPoses(WidgetTester t) => t
      .widgetList<CustomPaint>(find.byType(CustomPaint))
      .map((w) => w.painter)
      .whereType<PandaPainter>()
      .map((p) => p.pose);

  Future<void> settle(WidgetTester t) async {
    for (var i = 0; i < 10; i++) {
      await t.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('poses follow typing, idle pose and celebration', (tester) async {
    final c = PandaStageController();
    await tester.pumpWidget(host(c));
    expect(shownPoses(tester), [PandaPose.sleeping]);

    c.startTyping();
    await settle(tester);
    expect(shownPoses(tester), [PandaPose.curious]);

    c.stopTyping();
    c.idlePose = PandaPose.sad;
    await settle(tester);
    expect(shownPoses(tester), [PandaPose.sad]);

    c.celebrate();
    await settle(tester);
    expect(shownPoses(tester), [PandaPose.excited]);

    c.greet();
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(shownPoses(tester), [PandaPose.sad]);
    expect(tester.takeException(), isNull);
  });

  testWidgets('each pose paints without exceptions', (tester) async {
    for (final pose in PandaPose.values) {
      for (final phase in [0.0, 0.33, 0.72]) {
        await tester.pumpWidget(Center(
          child: SizedBox.square(
            dimension: 120,
            child: CustomPaint(
              painter: PandaPainter(pose: pose, phase: phase, earTilt: const Offset(0.8, -0.5), blink: phase),
            ),
          ),
        ));
        expect(tester.takeException(), isNull);
      }
    }
  });
}
