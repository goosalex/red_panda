import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/ui/category_clouds.dart';

void main() {
  Future<SkyPainter> pumpSky(WidgetTester tester, DateTime now, {bool reduceMotion = false}) async {
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(disableAnimations: reduceMotion),
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SkyButton(onTap: () {}, filtered: false, now: now)),
      ),
    ));
    return tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((p) => p.painter)
        .whereType<SkyPainter>()
        .single;
  }

  testWidgets('stars twinkle around the moon at night', (tester) async {
    final p = await pumpSky(tester, DateTime(2026, 11, 7, 22));
    expect(p.day, isFalse);
    final before = p.twinkle.value;
    await tester.pump(const Duration(milliseconds: 700));
    expect(p.twinkle.value, isNot(before));
    expect(SkyPainter.stars.length, greaterThanOrEqualTo(4));
    await tester.pumpWidget(const SizedBox()); // stops the animation
  });

  testWidgets('no twinkling by day, or with Reduce Motion', (tester) async {
    var p = await pumpSky(tester, DateTime(2026, 11, 7, 12));
    expect(p.day, isTrue);
    expect(tester.hasRunningAnimations, isFalse);

    p = await pumpSky(tester, DateTime(2026, 11, 7, 23), reduceMotion: true);
    expect(p.day, isFalse);
    expect(tester.hasRunningAnimations, isFalse);
  });

  test('each star brightens and dims over the cycle', () {
    final values = [for (var t = 0.0; t < 1; t += 0.05) SkyPainter.brightness(0.3, t)];
    expect(values.reduce((a, b) => a < b ? a : b), lessThan(0.1));
    expect(values.reduce((a, b) => a > b ? a : b), greaterThan(0.9));
  });
}
