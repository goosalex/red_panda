import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/models/app_settings.dart';
import 'package:red_panda/platform/shortcuts_links.dart';
import 'package:red_panda/storage/note_store.dart';
import 'package:red_panda/ui/settings_screen.dart';

void main() {
  late Directory dir;
  late NoteStore store;
  late List<String> opened;
  late bool openWorks;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('red_panda_settings');
    store = await NoteStore.at(dir);
    opened = [];
    openWorks = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ShortcutsLinks.channel, (call) async {
      switch (call.method) {
        case 'openUrl':
          final url = (call.arguments as Map)['url'] as String;
          opened.add(url);
          return openWorks || url == ShortcutsLinks.app;
        case 'leaveBasketStatus':
          return {'armed': true, 'permission': 'whenInUse'};
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ShortcutsLinks.channel, null);
    dir.deleteSync(recursive: true);
  });

  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> pumpSettings(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(store: store)));
    await settle(tester);
  }

  test('basket summary', () {
    expect(basketSummary(const AppSettings()), '50 m · Wi-Fi');
    expect(basketSummary(const AppSettings(leaveOnWifi: false, leaveRadiusMeters: 1000)), '1 km');
    expect(basketSummary(const AppSettings(leaveOnWifi: false, leaveOnPlace: false)), 'Off');
  });

  testWidgets('every setting is one line until opened', (tester) async {
    await pumpSettings(tester);
    for (final row in tester.widgetList<ListTile>(find.byType(ListTile))) {
      expect(row.subtitle, isNull);
    }
    expect(find.text('Snooze until tomorrow'), findsOneWidget); // current value only
    expect(find.text('Moves the item to the top of the list.'), findsNothing);
  });

  testWidgets('swipe action is picked in a drawer and saved', (tester) async {
    await pumpSettings(tester);
    await tester.tap(find.text('Swipe right'));
    await settle(tester);
    expect(find.text('Moves the item to the top of the list.'), findsOneWidget);

    await tester.tap(find.text('Pin to top'));
    await settle(tester);
    expect(find.text('Moves the item to the top of the list.'), findsNothing);
    expect(find.text('Pin to top'), findsOneWidget);
    final saved = await tester.runAsync(store.loadSettings);
    expect(saved!.swipeAction, SwipeAction.pin);
  });

  testWidgets('leave basket page: radius drawer, permission, Shortcuts links', (tester) async {
    await pumpSettings(tester);
    await tester.tap(find.text('Leave basket'));
    await settle(tester);
    expect(find.text('While using'), findsOneWidget);

    await tester.tap(find.text('Radius'));
    await settle(tester);
    await tester.tap(find.text('200 m'));
    await settle(tester);
    expect((await tester.runAsync(store.loadSettings))!.leaveRadiusMeters, 200);

    await tester.tap(find.text('When I leave a Wi-Fi'));
    await settle(tester);
    expect(find.textContaining('tick "Leaves"'), findsOneWidget);
    await tester.tap(find.text('Open Shortcuts'));
    await settle(tester);
    expect(opened, [ShortcutsLinks.newAutomation]);

    await tester.pageBack();
    await settle(tester);
    expect(find.text('200 m · Wi-Fi'), findsOneWidget);
  });

  test('a failing Shortcuts link falls back to the app', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    openWorks = false;
    expect(await ShortcutsLinks.open(ShortcutsLinks.automations), isTrue);
    expect(opened, [ShortcutsLinks.automations, ShortcutsLinks.app]);
  });
}
