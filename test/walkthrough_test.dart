import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/l10n/l10n.dart';
import 'package:red_panda/ui/link_text.dart';
import 'package:red_panda/ui/walkthrough.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  final index = jsonDecode(File('assets/walkthroughs/walkthroughs.json').readAsStringSync()) as Map<String, dynamic>;

  test('every walkthrough is recorded in every app language (tool/walkthroughs/record.sh)', () {
    final lib = WalkLibrary(index);
    for (final w in Walkthrough.values) {
      for (final locale in appLocales) {
        final lang = locale.languageCode;
        expect(lib.languages(w), contains(lang), reason: '${w.name} has no $lang recording: run tool/walkthroughs/record.sh $lang');
        final frames = lib.frames(w, lang);
        expect(frames.length, greaterThanOrEqualTo(3), reason: '${w.name}/$lang');
        for (final f in frames) {
          expect(File(f.image).existsSync(), isTrue, reason: f.image);
          for (final o in [f.tap, f.press, f.swipeFrom, f.swipeTo].whereType<Offset>()) {
            expect(o.dx, inInclusiveRange(0, 1));
            expect(o.dy, inInclusiveRange(0, 1));
          }
        }
        // Every frame but the last shows where to tap or swipe; the last one the result.
        expect(frames.take(frames.length - 1).every((f) => f.acts), isTrue, reason: '${w.name}/$lang');
        expect(frames.last.acts, isFalse);
        expect(frames.where((f) => f.tap != null).every((f) => (f.label ?? '').isNotEmpty), isTrue);
      }
    }
  });

  test('links in the texts point to walkthroughs, the same ones in every language', () {
    final en = jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync()) as Map<String, dynamic>;
    final linked = {
      for (final e in en.entries)
        if (!e.key.startsWith('@') && LinkText.targets(e.value as String).isNotEmpty) e.key: LinkText.targets(e.value as String),
    };
    expect(linked.keys, containsAll(['basketNeedsLocation', 'basketNeedsAlways', 'micNeeded', 'captureActionButtonHow', 'captureWidgetsHow']));
    // Every walkthrough is linked from somewhere (or from a Settings row).
    final rows = {'location', 'microphone', 'siri'};
    expect({...linked.values.expand((t) => t), ...rows}, containsAll(Walkthrough.values.map((w) => w.name)));
    for (final targets in linked.values) {
      for (final t in targets) {
        expect(Walkthrough.byName(t), isNotNull, reason: t);
      }
    }
    for (final locale in appLocales) {
      final arb = jsonDecode(File('lib/l10n/app_${locale.languageCode}.arb').readAsStringSync()) as Map<String, dynamic>;
      for (final e in linked.entries) {
        expect(LinkText.targets(arb[e.key] as String), e.value, reason: '${e.key} in ${locale.languageCode}');
      }
    }
  });

  test('plain text drops the link markup', () {
    expect(LinkText.plain('Allow it in [Settings](microphone).'), 'Allow it in Settings.');
  });

  Widget app(Widget child, {Locale locale = const Locale('en')}) => MaterialApp(
        locale: locale,
        supportedLocales: appLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: child),
      );

  testWidgets('a blue link plays the walkthrough in the app language', (tester) async {
    await tester.pumpWidget(app(const LinkText('Erlaube es in den [Einstellungen](microphone).'), locale: const Locale('de')));
    expect(find.text('Erlaube es in den Einstellungen.', findRichText: true), findsOneWidget);
    await tester.tapOnText(find.textRange.ofSubstring('Einstellungen'));
    await tester.pump();
    await tester.runAsync(() => WalkLibrary.load());
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Mikrofon & Spracherkennung'), findsOneWidget);
    expect(find.byType(WalkthroughPlayer), findsOneWidget);
    expect(find.text('Einstellungen öffnen'), findsOneWidget);
    // The path is spelled out in the names German iOS uses.
    final path = WalkLibrary(index).frames(Walkthrough.microphone, 'de').first.label!;
    expect(find.textContaining(path, findRichText: true), findsOneWidget);
    // It keeps playing: next screenshot after one step.
    await tester.pump(WalkthroughPlayer.step);
    await tester.pump(const Duration(milliseconds: 400));
    expect(tester.takeException(), isNull);
  });

  test('a long press is named in the path in the app language', () {
    const f = WalkFrame(image: 'x', press: Offset(0.5, 0.5));
    expect(f.acts, isTrue);
    expect(f.name(lookupAppLocalizations(const Locale('de'))), 'Lange drücken');
  });

  test('the finger shows only in the middle of a frame', () {
    const f = WalkFrame(image: 'x', tap: Offset(0.5, 0.5));
    expect(TouchPainter(f, 0.1).shouldRepaint(TouchPainter(f, 0.5)), isTrue);
  });
}
