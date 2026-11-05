import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../models/note.dart';

/// Reads and writes notes in the shared App Group container, so notes saved
/// by the Lock Screen / Action Button intents (Swift) show up here.
class NoteStore {
  NoteStore._(this.root);

  static const _channel = MethodChannel('red_panda/app_group');

  final Directory root;
  Directory get _notesDir => Directory('${root.path}/notes');
  Directory get audioDir => Directory('${root.path}/audio');

  /// Uses the App Group container on iOS; falls back to the app's documents
  /// folder (tests, simulator without entitlements).
  static Future<NoteStore> open() async {
    String? path;
    try {
      path = await _channel.invokeMethod<String>('containerPath');
    } on MissingPluginException {
      path = null;
    } on PlatformException {
      path = null;
    }
    path ??= (await getApplicationDocumentsDirectory()).path;
    return NoteStore.at(Directory(path));
  }

  static Future<NoteStore> at(Directory dir) async {
    final store = NoteStore._(dir);
    await store._notesDir.create(recursive: true);
    await store.audioDir.create(recursive: true);
    return store;
  }

  Future<List<Note>> loadAll() async {
    final notes = <Note>[];
    await for (final f in _notesDir.list()) {
      if (f is! File || !f.path.endsWith('.json')) continue;
      try {
        notes.add(Note.fromJson(jsonDecode(await f.readAsString()) as Map<String, dynamic>));
      } catch (_) {
        // Half-written or corrupt file: skip, never crash the list.
      }
    }
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return notes;
  }

  Future<void> save(Note note) async {
    final f = File('${_notesDir.path}/${note.id}.json');
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(jsonEncode(note.toJson()), flush: true);
    await tmp.rename(f.path);
  }

  Future<void> delete(Note note) async {
    final f = File('${_notesDir.path}/${note.id}.json');
    if (await f.exists()) await f.delete();
    if (note.audioFile != null) {
      final a = File('${audioDir.path}/${note.audioFile}');
      if (await a.exists()) await a.delete();
    }
  }

  Future<Note> addText(String text) async {
    final note = Note(id: newId(), createdAt: DateTime.now(), kind: NoteKind.text, text: text);
    await save(note);
    return note;
  }

  static String newId() {
    final r = Random.secure();
    final bytes = List<int>.generate(8, (_) => r.nextInt(256));
    return '${DateTime.now().millisecondsSinceEpoch}-${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }
}
