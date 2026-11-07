import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/gamification/bamboo.dart';
import 'package:red_panda/logic/note_order.dart';
import 'package:red_panda/models/app_settings.dart';
import 'package:red_panda/models/note.dart';

final now = DateTime(2026, 11, 7, 12);

Note n(String id,
        {int ageMin = 0, double? rank, int? dueIn, String? cat, DateTime? done, DateTime? snoozed}) =>
    Note(
      id: id,
      createdAt: now.subtract(Duration(minutes: ageMin)),
      kind: NoteKind.text,
      text: id,
      rank: rank,
      dueAt: dueIn == null ? null : endOfDayIn(dueIn, now),
      categoryId: cat,
      doneAt: done,
      snoozedUntil: snoozed,
    );

List<String> ids(List<Note> l) => l.map((e) => e.id).toList();

void main() {
  group('Note JSON', () {
    test('round-trips the v0.2 fields', () {
      final a = n('a', rank: 2, dueIn: 3, cat: 'c1', snoozed: now.add(const Duration(hours: 5)))
          .copyWith(remindAt: now.add(const Duration(hours: 3)));
      final b = Note.fromJson(a.toJson());
      expect(b.rank, 2);
      expect(b.dueAt, a.dueAt!.toUtc());
      expect(b.categoryId, 'c1');
      expect(b.snoozedUntil, a.snoozedUntil!.toUtc());
      expect(b.remindAt, a.remindAt!.toUtc());
    });

    test('reads v0.1 notes without the new fields', () {
      final j = {'id': 'x', 'createdAt': '2026-11-01T10:00:00Z', 'kind': 'text', 'text': 'hi'};
      final note = Note.fromJson(j);
      expect(note.rank, isNull);
      expect(note.dueAt, isNull);
      expect(note.toJson().keys, isNot(contains('rank')));
    });

    test('daysLeft counts calendar days', () {
      expect(n('a', dueIn: 0).daysLeft(now), 0);
      expect(n('a', dueIn: 1).daysLeft(now), 1);
      expect(n('a', dueIn: 10).daysLeft(now), 10);
      expect(n('a', dueIn: -2).daysLeft(now), -2);
      expect(n('a', dueIn: -2).isOverdue(now), isTrue);
      expect(n('a', dueIn: 0).isOverdue(now), isFalse);
    });
  });

  group('visibleNotes', () {
    test('open by deadline then newest, done last, snoozed hidden', () {
      final notes = [
        n('old', ageMin: 50),
        n('new', ageMin: 1),
        n('due5', dueIn: 5),
        n('due1', dueIn: 1),
        n('done', done: now),
        n('zz', snoozed: now.add(const Duration(hours: 1))),
      ];
      expect(ids(visibleNotes(notes, now: now)), ['due1', 'due5', 'new', 'old', 'done']);
      expect(ids(visibleNotes(notes, now: now, showSnoozed: true)), contains('zz'));
    });

    test('manual rank wins; unranked newcomers go on top', () {
      final notes = [n('a', rank: 1), n('b', rank: 0), n('c', dueIn: 0), n('fresh')];
      expect(ids(visibleNotes(notes, now: now)), ['c', 'fresh', 'b', 'a']);
    });

    test('filters by category and query', () {
      final notes = [n('milk', cat: 'shop'), n('report', cat: 'work'), n('bread', cat: 'shop')];
      expect(ids(visibleNotes(notes, now: now, categoryId: 'shop')).toSet(), {'milk', 'bread'});
      expect(ids(visibleNotes(notes, now: now, query: 'REP')), ['report']);
    });
  });

  group('reorder', () {
    test('moves an item and renumbers everything', () {
      final open = [n('a', rank: 0), n('b', rank: 1), n('c', rank: 2)];
      final changed = reorder(open, open, open[2], 0);
      final byId = {for (final c in changed) c.id: c.rank};
      expect(byId, {'c': 0, 'a': 1, 'b': 2});
    });

    test('keeps hidden (filtered) items in place', () {
      final all = [n('a', rank: 0, cat: 'x'), n('h', rank: 1, cat: 'y'), n('b', rank: 2, cat: 'x')];
      final shown = [all[0], all[2]];
      // Drag b above a while only category x is shown.
      final changed = reorder(all, shown, all[2], 0);
      final merged = {for (final x in all) x.id: x, for (final c in changed) c.id: c};
      final order = merged.values.toList()..sort((p, q) => p.rank!.compareTo(q.rank!));
      expect(ids(order), ['b', 'a', 'h']);
    });

    test('topRank goes above everything', () {
      expect(topRank([n('a', rank: 3), n('b', rank: -1)]), -2);
      expect(topRank([n('a')]), 0);
    });
  });

  group('BambooWallet', () {
    test('pays once per item, with an early bonus, capped', () {
      var w = const BambooWallet(balance: 0);
      var (w2, earned) = w.complete(n('a', dueIn: 3), now);
      expect(earned, 2);
      (w2, earned) = w2.complete(n('a', dueIn: 3), now);
      expect(earned, 0, reason: 're-ticking does not pay again');
      (w2, earned) = w2.complete(n('b'), now);
      expect(earned, 1);
      w = BambooWallet(balance: BambooWallet.cap);
      (w2, earned) = w.complete(n('c'), now);
      expect(w2.balance, BambooWallet.cap);
      expect(earned, 0);
    });

    test('spending and postpone cost', () {
      const w = BambooWallet(balance: 1);
      expect(w.spend(BambooWallet.snoozeCost), isNull);
      expect(w.spend(1)!.balance, 0);
      expect(BambooWallet.postponeCost(n('far', dueIn: 10), now), 0);
      expect(BambooWallet.postponeCost(n('near', dueIn: 1), now), BambooWallet.latePostponeCost);
      expect(BambooWallet.postponeCost(n('none'), now), 0);
    });

    test('JSON and pruning', () {
      final w = BambooWallet(balance: 4, rewardedIds: const {'a', 'gone'}).prune(['a', 'b']);
      final back = BambooWallet.fromJson(w.toJson());
      expect(back.balance, 4);
      expect(back.rewardedIds, {'a'});
    });
  });

  test('settings survive unknown values', () {
    final s = AppSettings.fromJson({'swipeAction': 'teleport', 'nagIntensity': 'gentle'});
    expect(s.swipeAction, SwipeAction.snooze);
    expect(s.nagIntensity, NagIntensity.gentle);
  });

  test('dueSummary counts overdue and today', () {
    final s = dueSummary([n('a', dueIn: -1), n('b', dueIn: 0), n('c', dueIn: 3), n('d', done: now)], now);
    expect(s.open, 3);
    expect(s.overdue, 1);
    expect(s.dueToday, 1);
  });
}
