import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/gamification/progress.dart';
import 'package:red_panda/models/note.dart';
import 'package:red_panda/storage/note_store.dart';

Note _done(DateTime d) =>
    Note(id: d.toIso8601String(), createdAt: d, kind: NoteKind.text, text: 'x', doneAt: d);

void main() {
  final now = DateTime(2026, 11, 5, 12);

  test('streak counts consecutive days ending today', () {
    final notes = [for (var i = 0; i < 3; i++) _done(now.subtract(Duration(days: i)))];
    final p = Progress.from(notes, now: now);
    expect(p.streakDays, 3);
    expect(p.isMilestone, isTrue);
    expect(p.tickedToday, 1);
    expect(p.xp, 30);
  });

  test('streak survives until today is ticked', () {
    final notes = [_done(now.subtract(const Duration(days: 1)))];
    expect(Progress.from(notes, now: now).streakDays, 1);
  });

  test('gap breaks the streak', () {
    final notes = [_done(now), _done(now.subtract(const Duration(days: 2)))];
    expect(Progress.from(notes, now: now).streakDays, 1);
  });

  test('store round-trips JSON written in the Swift schema', () async {
    final dir = await Directory.systemTemp.createTemp('rp');
    final store = await NoteStore.at(dir);
    // Same shape ios/Shared/NoteStore.swift writes.
    await File('${dir.path}/notes/a.json').writeAsString(
        '{"id":"a","createdAt":"2026-11-05T10:00:00Z","kind":"voice","audioFile":"a.m4a","durationSeconds":4.2}');
    await store.addText('hello');
    final notes = await store.loadAll();
    expect(notes.length, 2);
    expect(notes.firstWhere((n) => n.id == 'a').kind, NoteKind.voice);
    await dir.delete(recursive: true);
  });
}
