/// A captured note. Text notes and voice notes share one model; notes double
/// as to-dos that can be ticked off.
///
// On disk (App Group container, written by both Swift intents and Flutter):
//   notes/<id>.json   -> this model as JSON
//   audio/<id>.m4a    -> recording for voice notes
// The JSON schema must stay in sync with ios/Shared/NoteStore.swift
// (StoredNote): Swift rewrites notes (e.g. transcripts) and would drop
// fields it doesn't know.
enum NoteKind { text, voice }

class Note {
  Note({
    required this.id,
    required this.createdAt,
    required this.kind,
    this.text,
    this.audioFile,
    this.durationSeconds,
    this.doneAt,
    this.rank,
    this.dueAt,
    this.categoryId,
    this.snoozedUntil,
    this.remindAt,
  });

  final String id;
  final DateTime createdAt;
  final NoteKind kind;
  final String? text;

  /// File name relative to the container's audio/ folder.
  final String? audioFile;
  final double? durationSeconds;
  final DateTime? doneAt;

  /// Manual order set by dragging; lower is higher up. Null until the user
  /// first reorders.
  final double? rank;

  /// Deadline: the end of the chosen day (local time).
  final DateTime? dueAt;

  /// Category (cloud) id, see models/category.dart.
  final String? categoryId;

  /// Hidden from the list until then (paid for with bamboo).
  final DateTime? snoozedUntil;

  /// One-off "remind me later" notification time.
  final DateTime? remindAt;

  bool get isDone => doneAt != null;

  bool isSnoozed(DateTime now) => snoozedUntil != null && snoozedUntil!.isAfter(now);

  bool isOverdue(DateTime now) => !isDone && dueAt != null && dueAt!.isBefore(now);

  /// Calendar days until the deadline (0 = today, negative = overdue).
  /// Null without a deadline.
  int? daysLeft(DateTime now) {
    final d = dueAt?.toLocal();
    if (d == null) return null;
    final today = DateTime.utc(now.year, now.month, now.day);
    return DateTime.utc(d.year, d.month, d.day).difference(today).inDays;
  }

  /// Display text, also for voice notes without a transcript.
  String get title {
    final words = text ?? '';
    if (kind == NoteKind.text || words.isNotEmpty) return words;
    final length = durationSeconds != null ? ' · ${durationSeconds!.round()} s' : '';
    return text == null ? 'Voice note$length' : 'Voice note$length (no words heard)';
  }

  Note copyWith({
    DateTime? doneAt,
    bool clearDone = false,
    String? text,
    double? rank,
    DateTime? dueAt,
    bool clearDue = false,
    String? categoryId,
    bool clearCategory = false,
    DateTime? snoozedUntil,
    bool clearSnooze = false,
    DateTime? remindAt,
    bool clearRemind = false,
  }) =>
      Note(
        id: id,
        createdAt: createdAt,
        kind: kind,
        text: text ?? this.text,
        audioFile: audioFile,
        durationSeconds: durationSeconds,
        doneAt: clearDone ? null : (doneAt ?? this.doneAt),
        rank: rank ?? this.rank,
        dueAt: clearDue ? null : (dueAt ?? this.dueAt),
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        snoozedUntil: clearSnooze ? null : (snoozedUntil ?? this.snoozedUntil),
        remindAt: clearRemind ? null : (remindAt ?? this.remindAt),
      );

  /// A fresh copy (new id, not done, no snooze) for "Duplicate".
  Note duplicate(String newId, DateTime now) => Note(
        id: newId,
        createdAt: now,
        kind: NoteKind.text,
        text: title,
        rank: rank == null ? null : rank! + 0.5,
        dueAt: dueAt,
        categoryId: categoryId,
      );

  static DateTime? _date(Object? v) => v == null ? null : DateTime.parse(v as String);
  static String _iso(DateTime d) => d.toUtc().toIso8601String();

  factory Note.fromJson(Map<String, dynamic> j) => Note(
        id: j['id'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        kind: j['kind'] == 'voice' ? NoteKind.voice : NoteKind.text,
        text: j['text'] as String?,
        audioFile: j['audioFile'] as String?,
        durationSeconds: (j['durationSeconds'] as num?)?.toDouble(),
        doneAt: _date(j['doneAt']),
        rank: (j['rank'] as num?)?.toDouble(),
        dueAt: _date(j['dueAt']),
        categoryId: j['categoryId'] as String?,
        snoozedUntil: _date(j['snoozedUntil']),
        remindAt: _date(j['remindAt']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': _iso(createdAt),
        'kind': kind.name,
        if (text != null) 'text': text,
        if (audioFile != null) 'audioFile': audioFile,
        if (durationSeconds != null) 'durationSeconds': durationSeconds,
        if (doneAt != null) 'doneAt': _iso(doneAt!),
        if (rank != null) 'rank': rank,
        if (dueAt != null) 'dueAt': _iso(dueAt!),
        if (categoryId != null) 'categoryId': categoryId,
        if (snoozedUntil != null) 'snoozedUntil': _iso(snoozedUntil!),
        if (remindAt != null) 'remindAt': _iso(remindAt!),
      };
}

/// Deadline instant for "in [days] days": the end of that local calendar day.
DateTime endOfDayIn(int days, DateTime now) =>
    DateTime(now.year, now.month, now.day + days, 23, 59, 59);
