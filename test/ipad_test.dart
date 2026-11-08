import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/platform/device.dart';
import 'package:red_panda/ui/readable.dart';
import 'package:red_panda/ui/settings_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<EdgeInsets> insetsAt(WidgetTester tester, double width, {double min = 0}) async {
    late EdgeInsets e;
    await tester.pumpWidget(MediaQuery(
      data: MediaQueryData(size: Size(width, 1000)),
      child: Builder(builder: (c) {
        e = readableInsets(c, min: min);
        return const SizedBox();
      }),
    ));
    return e;
  }

  testWidgets('on an iPad text stays a readable column; on an iPhone nothing changes', (tester) async {
    expect((await insetsAt(tester, 1024)).left, (1024 - readableWidth) / 2); // iPad Pro 13", portrait
    expect((await insetsAt(tester, 1376)).horizontal, 1376 - readableWidth); // landscape
    expect((await insetsAt(tester, 390)).left, 0); // iPhone
    expect((await insetsAt(tester, 390, min: 16)).left, 16);
  });

  test('an iPad has no Action Button to set up', () async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
        const MethodChannel('red_panda/app_group'), (call) async => call.method == 'isPad' ? true : null);
    await Device.load();
    expect(Device.isPad, isTrue);
    expect(QuickCapturePage.spots, isNot(contains(CaptureSpot.actionButton)));
    expect(QuickCapturePage.spots, contains(CaptureSpot.lockScreen));
    Device.isPad = false;
    expect(QuickCapturePage.spots, contains(CaptureSpot.actionButton));
  });
}
