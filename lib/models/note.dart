/// A captured note. Text notes and voice notes share one model; notes double
/// as to-dos that can be ticked off.
///
// On disk (App Group container, written by both Swift intents and Flutter):
//   notes/<id>.json   -> this model as JSON
//   audio/<id>.m4a    -> recording for voice notes
// The JSON schema must stay in sync with ios/Shared/NoteStore.swift.
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
  });

  final String id;
  final DateTime createdAt;
  final NoteKind kind;
  final String? text;

  /// File name relative to the container's audio/ folder.
  final String? audioFile;
  final double? durationSeconds;
  final DateTime? doneAt;

  bool get isDone => doneAt != null;

  Note copyWith({DateTime? doneAt, bool clearDone = false, String? text}) => Note(
        id: id,
        createdAt: createdAt,
        kind: kind,
        text: text ?? this.text,
        audioFile: audioFile,
        durationSeconds: durationSeconds,
        doneAt: clearDone ? null : (doneAt ?? this.doneAt),
      );

  factory Note.fromJson(Map<String, dynamic> j) => Note(
        id: j['id'] as String,
        createdAt: DateTime.parse(j['createdAt'] as String),
        kind: j['kind'] == 'voice' ? NoteKind.voice : NoteKind.text,
        text: j['text'] as String?,
        audioFile: j['audioFile'] as String?,
        durationSeconds: (j['durationSeconds'] as num?)?.toDouble(),
        doneAt: j['doneAt'] == null ? null : DateTime.parse(j['doneAt'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toUtc().toIso8601String(),
        'kind': kind.name,
        if (text != null) 'text': text,
        if (audioFile != null) 'audioFile': audioFile,
        if (durationSeconds != null) 'durationSeconds': durationSeconds,
        if (doneAt != null) 'doneAt': doneAt!.toUtc().toIso8601String(),
      };
}
