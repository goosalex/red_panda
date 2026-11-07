import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/models/app_settings.dart';
import 'package:red_panda/news.dart';
import 'package:red_panda/platform/shortcuts_links.dart';
import 'package:red_panda/storage/cloud_sync.dart';
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
        case 'openAppSettings':
          opened.add('app-settings');
          return null;
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

  Future<void> pumpSettings(WidgetTester tester, {CloudSyncController? cloud}) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(home: SettingsScreen(store: store, cloud: cloud)));
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

  testWidgets('iCloud sync row shows the status and switches off', (tester) async {
    final cloud = CloudSyncController(store, locate: () async => null);
    await tester.runAsync(() => cloud.run(enabled: true));
    await pumpSettings(tester, cloud: cloud);
    expect(find.text('Not signed in'), findsOneWidget);

    await tester.tap(find.text('iCloud sync'));
    await settle(tester);
    await tester.tap(find.text('Off'));
    await settle(tester);
    expect((await tester.runAsync(store.loadSettings))!.icloudSync, isFalse);
    expect(cloud.status.value.state, CloudState.off);
    expect(find.text('Off'), findsOneWidget);
  });

  testWidgets('location info explains "Always" without tracking', (tester) async {
    await pumpSettings(tester);
    await tester.tap(find.text('Leave basket'));
    await settle(tester);
    await tester.tap(find.text('Why "Always"?'));
    await settle(tester);
    expect(find.text('No battery drain'), findsOneWidget);
    expect(find.text('Your location stays on your iPhone'), findsOneWidget);
  });

  testWidgets('quick capture: preview image and settings links', (tester) async {
    await pumpSettings(tester);
    await tester.scrollUntilVisible(find.text('Quick capture'), 100);
    await tester.tap(find.text('Quick capture'));
    await settle(tester);
    expect(find.byType(Image), findsNothing); // collapsed: one line each

    await tester.tap(find.text('Siri'));
    await settle(tester);
    expect(find.bySemanticsLabel('Siri preview'), findsOneWidget);
    await tester.tap(find.text('Siri & Search'));
    await settle(tester);
    expect(opened, ['app-settings']);

    await tester.tap(find.text('Widgets'));
    await settle(tester);
    await tester.tap(find.text('Sad panda reminders'));
    await settle(tester);
    expect(find.text('Persistent'), findsOneWidget); // the reminders drawer
  });

  test('every quick capture preview exists', () {
    for (final spot in QuickCapturePage.spots) {
      expect(File('assets/quick_capture/${spot.image}.png').existsSync(), isTrue, reason: spot.image);
    }
  });

  testWidgets('news lists the newest version first with its PR', (tester) async {
    await pumpSettings(tester);
    await tester.scrollUntilVisible(find.text('News'), 100);
    expect(find.text('Version ${news.first.version}'), findsOneWidget);
    await tester.tap(find.text('News'));
    await settle(tester);
    expect(find.text('Version ${news.first.version} · new'), findsOneWidget);
    await tester.tap(find.text('PR #${news.first.pr}'));
    await settle(tester);
    expect(opened, [news.first.url]);
  });

  test('a failing Shortcuts link falls back to the app', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    openWorks = false;
    expect(await ShortcutsLinks.open(ShortcutsLinks.automations), isTrue);
    expect(opened, [ShortcutsLinks.automations, ShortcutsLinks.app]);
  });
}
