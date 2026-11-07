import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/platform/motion.dart';
import 'package:red_panda/platform/reminders.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('red_panda/app_group');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('schedule sends items as ISO-8601 maps', () async {
    final calls = <MethodCall>[];
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls.add(call);
      return null;
    });
    await Reminders.schedule([
      ReminderItem(
        id: 'a',
        title: 'Buy bamboo',
        dueAt: DateTime.utc(2026, 11, 7, 22, 59, 59),
      ),
      const ReminderItem(id: 'b', title: 'Call Grandma'),
    ], intensity: 2);
    expect(calls.single.method, 'scheduleReminders');
    expect(calls.single.arguments, {
      'items': [
        {'id': 'a', 'title': 'Buy bamboo', 'dueAt': '2026-11-07T22:59:59.000Z'},
        {'id': 'b', 'title': 'Call Grandma'},
      ],
      'intensity': 2,
      'quietStartHour': 22,
      'quietEndHour': 8,
    });
  });

  test('permission and reload map results', () async {
    messenger.setMockMethodCallHandler(channel, (call) async {
      if (call.method == 'requestNotificationPermission') return true;
      return null;
    });
    expect(await Reminders.requestPermission(), isTrue);
    await Reminders.reloadWidgets();
  });

  test('no native side: no exceptions', () async {
    expect(await Reminders.requestPermission(), isFalse);
    await Reminders.schedule(const [], intensity: 3);
    await Reminders.reloadWidgets();
    expect(await Motion.tilt().toList(), isEmpty);
  });
}
