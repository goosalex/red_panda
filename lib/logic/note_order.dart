import '../models/note.dart';

/// What the list shows: open items first, done items after them.
///
/// Open items follow the user's manual order once they have dragged
/// anything (rank); unranked items sort by deadline (soonest first, none
/// last), then newest first. Snoozed items are hidden; [categoryId] filters
/// to one cloud; [query] searches the text.
List<Note> visibleNotes(
  List<Note> notes, {
  required DateTime now,
  String? categoryId,
  String query = '',
  bool showSnoozed = false,
}) {
  final q = query.trim().toLowerCase();
  final shown = notes.where((n) {
    if (!showSnoozed && !n.isDone && n.isSnoozed(now)) return false;
    if (categoryId != null && n.categoryId != categoryId) return false;
    if (q.isNotEmpty && !n.title.toLowerCase().contains(q)) return false;
    return true;
  }).toList();
  final open = shown.where((n) => !n.isDone).toList()..sort(compareOpen);
  final done = shown.where((n) => n.isDone).toList()..sort((a, b) => b.doneAt!.compareTo(a.doneAt!));
  return [...open, ...done];
}

int compareOpen(Note a, Note b) {
  // Ranked (manually ordered) items keep their order; any unranked newcomer
  // goes above them so a fresh capture is visible at the top.
  final ra = a.rank, rb = b.rank;
  if (ra != null && rb != null) {
    final c = ra.compareTo(rb);
    if (c != 0) return c;
  } else if (ra != null || rb != null) {
    return ra == null ? -1 : 1;
  }
  final da = a.dueAt, db = b.dueAt;
  if (da != null && db != null) {
    final c = da.compareTo(db);
    if (c != 0) return c;
  } else if (da != null || db != null) {
    return da != null ? -1 : 1;
  }
  return b.createdAt.compareTo(a.createdAt);
}

/// Moves [moved] to [toIndex] among the shown open items [visibleOpen]
/// (which may be filtered) and renumbers all open items [allOpen] so the
/// shown order becomes the stored order. Returns only the changed notes.
List<Note> reorder(List<Note> allOpen, List<Note> visibleOpen, Note moved, int toIndex) {
  final shown = [...visibleOpen]..removeWhere((n) => n.id == moved.id);
  final i = toIndex.clamp(0, shown.length);
  final full = [...allOpen]..sort(compareOpen);
  full.removeWhere((n) => n.id == moved.id);
  // Insert before the shown item that will follow it, or right after the
  // last shown item when it goes to the end.
  var at = full.length;
  if (i < shown.length) {
    at = full.indexWhere((n) => n.id == shown[i].id);
  } else if (shown.isNotEmpty) {
    at = full.indexWhere((n) => n.id == shown.last.id) + 1;
  }
  full.insert(at < 0 ? full.length : at, moved);
  final changed = <Note>[];
  for (var k = 0; k < full.length; k++) {
    final rank = k.toDouble();
    if (full[k].rank != rank) changed.add(full[k].copyWith(rank: rank));
  }
  return changed;
}

/// Rank that puts a note above everything in [notes] ("Pin to top").
double topRank(List<Note> notes) {
  final ranks = notes.map((n) => n.rank).whereType<double>();
  return ranks.isEmpty ? 0 : ranks.reduce((a, b) => a < b ? a : b) - 1;
}

/// Counts for the sad-panda nagging.
({int open, int overdue, int dueToday}) dueSummary(List<Note> notes, DateTime now) {
  var open = 0, overdue = 0, today = 0;
  for (final n in notes) {
    if (n.isDone || n.isSnoozed(now)) continue;
    open++;
    if (n.isOverdue(now)) {
      overdue++;
    } else if (n.daysLeft(now) == 0) {
      today++;
    }
  }
  return (open: open, overdue: overdue, dueToday: today);
}
