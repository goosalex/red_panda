import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/models/note.dart';
import 'package:red_panda/platform/compose_requests.dart';
import 'package:red_panda/storage/note_store.dart';
import 'package:red_panda/ui/home_screen.dart';

/// Native side of the 'red_panda/app_group' channel: one pending flag.
class FakeNative {
  bool pending = false;
  int takes = 0;
  int transcribeCalls = 0;

  void install() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(ComposeRequests.channel, (call) async {
      if (call.method == 'takeCompose') {
        takes++;
        final p = pending;
        pending = false;
        return p;
      }
      if (call.method == 'transcribePending') {
        transcribeCalls++;
        return 0;
      }
      return null;
    });
  }

  /// Simulates OpenComposeIntent while the app is running.
  Future<void> ping() async {
    pending = true;
    await send('compose');
  }

  Future<void> send(String method) =>
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.handlePlatformMessage(
        ComposeRequests.channel.name,
        ComposeRequests.channel.codec.encodeMethodCall(MethodCall(method)),
        (_) {},
      );
}

void main() {
  late Directory dir;
  late NoteStore store;
  late FakeNative native;

  setUp(() async {
    dir = Directory.systemTemp.createTempSync('red_panda_test');
    store = await NoteStore.at(dir);
    native = FakeNative()..install();
  });

  tearDown(() => dir.deleteSync(recursive: true));

  /// NoteStore does real file IO: alternate real time and frames until settled.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 30; i++) {
      await tester.runAsync(() => Future<void>.delayed(const Duration(milliseconds: 10)));
      await tester.pump(const Duration(milliseconds: 100));
    }
  }

  Future<void> pumpHome(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home: HomeScreen(store: store)));
    await settle(tester);
  }

  testWidgets('no request: no compose sheet', (tester) async {
    await pumpHome(tester);
    expect(native.takes, greaterThan(0));
    expect(find.widgetWithText(TextField, 'New note'), findsNothing);
  });

  testWidgets('request waiting at start (cold launch) opens the sheet', (tester) async {
    native.pending = true;
    await pumpHome(tester);
    expect(find.widgetWithText(TextField, 'New note'), findsOneWidget);
    expect(native.pending, isFalse);
  });

  testWidgets('request while running opens the sheet once, and saves the note', (tester) async {
    await pumpHome(tester);
    await native.ping();
    await settle(tester);
    expect(find.widgetWithText(TextField, 'New note'), findsOneWidget);

    await native.ping(); // second tap while the sheet is open: no second sheet
    await settle(tester);
    expect(find.widgetWithText(TextField, 'New note'), findsOneWidget);
    expect(native.pending, isFalse, reason: 'request taken, not left to reopen later');

    await tester.enterText(find.byType(TextField), 'buy bamboo');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await settle(tester);

    final notes = await tester.runAsync(store.loadAll);
    expect(notes!.map((n) => n.text), ['buy bamboo']);
  });

  Note voice(String id, {String? text}) => Note(
        id: id,
        createdAt: DateTime(2026, 11, 5, 9),
        kind: NoteKind.voice,
        audioFile: '$id.m4a',
        durationSeconds: 4,
        text: text,
      );

  testWidgets('voice notes show their transcript once native writes it', (tester) async {
    tester.view.physicalSize = const Size(800, 2400); // whole list on screen
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.runAsync(() async {
      await store.save(voice('a', text: 'call the vet about bamboo'));
      await store.save(voice('b', text: ''));
      await store.save(voice('c'));
    });
    await pumpHome(tester);
    expect(native.transcribeCalls, 1, reason: 'asks native to catch up on start');
    expect(find.text('call the vet about bamboo'), findsOneWidget);
    expect(find.text('Voice note · 4 s (no words heard)'), findsOneWidget);
    expect(find.text('Voice note · 4 s'), findsOneWidget);

    // Native finished 'c' and pings: the list reloads.
    await tester.runAsync(() => store.save(voice('c', text: 'water the plants')));
    await native.send('notesChanged');
    await settle(tester);
    expect(find.text('water the plants'), findsOneWidget);
    expect(find.text('Voice note · 4 s'), findsNothing);
  });
}
