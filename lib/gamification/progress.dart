import '../models/note.dart';
import '../platform/clock.dart';

/// Gentle progress: streak of consecutive days with at least one tick,
/// today's count, and an XP/level bar. Derived from the notes, no extra state.
class Progress {
  const Progress({
    required this.streakDays,
    required this.tickedToday,
    required this.xp,
  });

  static const xpPerTick = 10;
  static const xpPerLevel = 100;
  static const milestones = [3, 7, 30];

  final int streakDays;
  final int tickedToday;
  final int xp;

  int get level => xp ~/ xpPerLevel + 1;
  double get levelFraction => (xp % xpPerLevel) / xpPerLevel;
  bool get isMilestone => milestones.contains(streakDays);

  factory Progress.from(List<Note> notes, {DateTime? now}) {
    now ??= clockNow();
    final days = <DateTime>{};
    var ticked = 0;
    for (final n in notes) {
      final d = n.doneAt?.toLocal();
      if (d == null) continue;
      ticked++;
      days.add(DateTime(d.year, d.month, d.day));
    }
    final today = DateTime(now.year, now.month, now.day);
    // A streak survives until the end of today even if nothing is ticked yet.
    var cursor = days.contains(today) ? today : today.subtract(const Duration(days: 1));
    var streak = 0;
    while (days.contains(cursor)) {
      streak++;
      cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    }
    final todayCount = notes.where((n) {
      final d = n.doneAt?.toLocal();
      return d != null && DateTime(d.year, d.month, d.day) == today;
    }).length;
    return Progress(streakDays: streak, tickedToday: todayCount, xp: ticked * xpPerTick);
  }
}
