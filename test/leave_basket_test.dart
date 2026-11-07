import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/logic/note_order.dart';
import 'package:red_panda/models/app_settings.dart';
import 'package:red_panda/models/note.dart';
import 'package:red_panda/platform/compose_requests.dart';
import 'package:red_panda/storage/note_store.dart';
import 'package:red_panda/ui/home_screen.dart';

final now = DateTime(2026, 11, 7, 12);

Note n(String id, {bool basket = false, DateTime? done, DateTime? snoozed}) => Note(
      id: id,
      createdAt: now,
      kind: NoteKind.text,
      text: id,
      leaveBasket: basket,
      doneAt: done,
      snoozedUntil: snoozed,
    );

void main() {
  group('model', () {
    test('leaveBasket round-trips and is omitted when false', () {
      expect(Note.fromJson(n('a', basket: true).toJson()).leaveBasket, isTrue);
      expect(n('a').toJson().containsKey('leaveBasket'), isFalse);
      expect(Note.fromJson({'id': 'x', 'createdAt': '2026-11-01T10:00:00Z', 'kind': 'text'}).leaveBasket, isFalse);
    });

    test('basket titles skip done and snoozed items', () {
      final notes = [
        n('keys', basket: true),
        n('done', basket: true, done: now),
        n('later', basket: true, snoozed: now.add(const Duration(hours: 2))),
        n('other'),
      ];
      expect(basketTitles(notes, now), ['keys']);
      expect(visibleNotes(notes, now: now, basketOnly: true).map((e) => e.id), ['keys', 'done']);
    });

    test('settings defaults and JSON', () {
      const s = AppSettings();
      expect(s.leaveRadiusMeters, 50);
      expect(s.leaveOnPlace && s.leaveOnWifi, isTrue);
      final back = AppSettings.fromJson(s.copyWith(leaveRadiusMeters: 200, leaveOnWifi: false).toJson());
      expect(back.leaveRadiusMeters, 200);
      expect(back.leaveOnWifi, isFalse);
    });
  });

  group('home screen', () {
    late Directory dir;
    late NoteStore store;
    late List<Map<Object?, Object?>> syncs;

    setUp(() async {
      dir = Directory.systemTemp.createTempSync('red_panda_basket');
      store = await NoteStore.at(dir);
      syncs = [];
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(ComposeRequests.channel, (call) async {
        switch (call.method) {
          case 'takeCompose':
            return false;
          case 'leaveBasketSync':
            final args = call.arguments as Map<Object?, Object?>;
            syncs.add(args);
            return {'armed': (args['titles'] as List).isNotEmpty, 'permission': 'always'};
        }
        return null;
      });
    });

    tearDown(() => dir.deleteSync(recursive: true));

    Future<void> settle(WidgetTester tester) async {
      for (var i = 0; i < 40; i++) {
        await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
        await tester.pump(const Duration(milliseconds: 100));
      }
    }

    Future<void> pumpHome(WidgetTester tester) async {
      tester.view.physicalSize = const Size(1170, 2532);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(MaterialApp(home: HomeScreen(store: store)));
      await settle(tester);
    }

    testWidgets('editor toggle puts an item in the basket and arms the reminder', (tester) async {
      await tester.runAsync(() => store.addText('take the parcel'));
      await pumpHome(tester);
      expect(syncs.last['titles'], isEmpty);

      await tester.longPress(find.text('take the parcel'));
      await settle(tester);
      await tester.tap(find.text('Leave basket'));
      await tester.pump();
      await tester.tap(find.text('Save'));
      await settle(tester);

      final saved = (await tester.runAsync(store.loadAll))!.single;
      expect(saved.leaveBasket, isTrue);
      expect(syncs.last['titles'], ['take the parcel']);
      expect(syncs.last['radius'], 50);
      expect(find.bySemanticsLabel(RegExp(r'^Leave basket, 1 item, watching')), findsOneWidget);
    });

    testWidgets('dragging an item onto the basket, then filtering by it', (tester) async {
      await tester.runAsync(() => store.addText('milk'));
      await tester.runAsync(() => store.addText('keys'));
      await pumpHome(tester);

      final handle = find.descendant(
        of: find.ancestor(of: find.text('keys'), matching: find.byType(Row)).first,
        matching: find.byIcon(Icons.drag_indicator),
      );
      final basket = find.bySemanticsLabel(RegExp(r'^Leave basket'));
      final gesture = await tester.startGesture(tester.getCenter(handle));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveTo(tester.getCenter(basket), timeStamp: const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.moveTo(tester.getCenter(basket) + const Offset(1, 1));
      await tester.pump(const Duration(milliseconds: 50));
      await gesture.up();
      await settle(tester);

      final notes = (await tester.runAsync(store.loadAll))!;
      expect(notes.firstWhere((x) => x.text == 'keys').leaveBasket, isTrue);
      expect(notes.firstWhere((x) => x.text == 'milk').leaveBasket, isFalse);

      await tester.tap(basket);
      await settle(tester);
      expect(find.text('milk'), findsNothing);
      expect(find.text('Only the leave basket'), findsOneWidget);
    });
  });
}
