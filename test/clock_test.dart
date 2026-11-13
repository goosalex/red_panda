import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/platform/clock.dart';

void main() {
  test('without SHOT_TIME (every normal build) the app shows the real time', () {
    expect(clockOffset, Duration.zero);
    expect(clockNow().difference(DateTime.now()).inSeconds.abs(), lessThan(2));
  });
}
