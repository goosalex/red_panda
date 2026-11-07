import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/models/category.dart';
import 'package:red_panda/models/note.dart';
import 'package:red_panda/storage/note_store.dart';
import 'package:red_panda/ui/home_screen.dart';

import 'compose_request_test.dart' show FakeNative;

void main() {
  late Directory dir;
  late NoteStore store;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('red_panda_home');
    store = await NoteStore.at(dir);
    FakeNative().install();
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

  Future<Note> add(WidgetTester tester, String text, {DateTime? due, String? cat}) async =>
      (await tester.runAsync(() => store.addText(text, dueAt: due, categoryId: cat)))!;

  Future<List<Note>> notes(WidgetTester tester) async => (await tester.runAsync(store.loadAll))!;

  testWidgets('only the check mark ticks an item off, and it earns bamboo', (tester) async {
    await add(tester, 'feed the panda');
    await pumpHome(tester);

    await tester.tap(find.text('feed the panda'));
    await settle(tester);
    expect((await notes(tester)).single.isDone, isFalse, reason: 'tapping the text does nothing');

    await tester.tap(find.byType(Checkbox));
    await settle(tester);
    expect((await notes(tester)).single.isDone, isTrue);
    final wallet = await tester.runAsync(store.loadWallet);
    expect(wallet!.balance, 4, reason: 'start stash 3 + 1 for the finished item');
  });

  testWidgets('long tap opens the editor and saves the new text', (tester) async {
    await add(tester, 'buy bamboo');
    await pumpHome(tester);

    await tester.longPress(find.text('buy bamboo'));
    await settle(tester);
    expect(find.widgetWithText(TextField, 'Note'), findsOneWidget);
    await tester.enterText(find.byType(TextField), 'buy fresh bamboo');
    await tester.tap(find.text('Save'));
    await settle(tester);
    expect((await notes(tester)).single.text, 'buy fresh bamboo');
  });

  testWidgets('swipe right un-ticks a done item and snoozes an open one', (tester) async {
    final done = await add(tester, 'done thing');
    await tester.runAsync(() => store.save(done.copyWith(doneAt: DateTime.now())));
    await add(tester, 'open thing');
    await pumpHome(tester);

    await tester.fling(find.text('done thing'), const Offset(500, 0), 1500);
    await settle(tester);
    expect((await notes(tester)).firstWhere((n) => n.text == 'done thing').isDone, isFalse);

    await tester.fling(find.text('open thing'), const Offset(500, 0), 1500);
    await settle(tester);
    final snoozed = (await notes(tester)).firstWhere((n) => n.text == 'open thing');
    expect(snoozed.isSnoozed(DateTime.now()), isTrue);
    expect(find.text('open thing'), findsNothing);
    expect((await tester.runAsync(store.loadWallet))!.balance, 1, reason: 'snooze cost 2 of 3');
  });

  testWidgets('tapping a cloud filters, the sun or moon shows everything again', (tester) async {
    await tester.runAsync(() => store.saveCategories(
        const [Category(id: 'w', name: 'Work', color: Color(0xFF8EC5FF))]));
    await add(tester, 'report', cat: 'w');
    await add(tester, 'groceries');
    await pumpHome(tester);
    expect(find.text('groceries'), findsOneWidget);

    await tester.tap(find.text('Work'));
    await settle(tester);
    expect(find.text('groceries'), findsNothing);
    expect(find.text('report'), findsOneWidget);

    await tester.tap(find.bySemanticsLabel(RegExp(r'^(Sun|Moon)$')));
    await settle(tester);
    expect(find.text('groceries'), findsOneWidget);
  });

  testWidgets('items with a deadline show the alarm clock and days left', (tester) async {
    await add(tester, 'tax return', due: endOfDayIn(3, DateTime.now()));
    await pumpHome(tester);
    expect(find.text('3d'), findsOneWidget);
  });

  testWidgets('the Undo bar after deleting goes away by itself after 5 s', (tester) async {
    await add(tester, 'old chore');
    await pumpHome(tester);
    await tester.drag(find.text('old chore'), const Offset(-600, 0));
    await settle(tester);
    expect(find.text('Undo'), findsOneWidget);

    // settle() took ~4 s: still there, gone a little after the 5 s.
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Undo'), findsOneWidget);
    await tester.pump(const Duration(seconds: 1));
    await settle(tester);
    expect(find.text('Undo'), findsNothing);
    expect(await notes(tester), isEmpty, reason: 'not undone: deleted for good');
  });
}
