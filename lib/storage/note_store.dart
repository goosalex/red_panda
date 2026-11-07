import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

import '../gamification/bamboo.dart';
import '../models/app_settings.dart';
import '../models/category.dart';
import '../models/note.dart';

/// Reads and writes notes in the shared App Group container, so notes saved
/// by the Lock Screen / Action Button intents (Swift) show up here.
///
/// Besides notes/: categories.json (clouds), settings.json (preferences) and
/// panda_state.json (bamboo stash).
class NoteStore {
  NoteStore._(this.root);

  static const _channel = MethodChannel('red_panda/app_group');

  final Directory root;

  /// Called after notes, categories or the bamboo stash changed on disk
  /// (iCloud sync picks the change up).
  void Function()? onChanged;
  Directory get _notesDir => Directory('${root.path}/notes');
  Directory get audioDir => Directory('${root.path}/audio');
  File get _categoriesFile => File('${root.path}/categories.json');
  File get _settingsFile => File('${root.path}/settings.json');
  File get _stateFile => File('${root.path}/panda_state.json');

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
    await _writeJson(File('${_notesDir.path}/${note.id}.json'), note.toJson());
    onChanged?.call();
  }

  Future<void> saveAll(Iterable<Note> notes) async {
    for (final n in notes) {
      await save(n);
    }
  }

  Future<void> delete(Note note, {bool keepAudio = false}) async {
    final f = File('${_notesDir.path}/${note.id}.json');
    if (await f.exists()) await f.delete();
    if (!keepAudio && note.audioFile != null) {
      final a = File('${audioDir.path}/${note.audioFile}');
      if (await a.exists()) await a.delete();
    }
    onChanged?.call();
  }

  Future<Note> addText(String text, {DateTime? dueAt, String? categoryId}) async {
    final note = Note(
      id: newId(),
      createdAt: DateTime.now(),
      kind: NoteKind.text,
      text: text,
      dueAt: dueAt,
      categoryId: categoryId,
    );
    await save(note);
    return note;
  }

  Future<List<Category>> loadCategories() async {
    final j = await _readJson(_categoriesFile);
    final list = (j?['categories'] as List?) ?? const [];
    return [
      for (final c in list)
        if (c is Map<String, dynamic>) Category.fromJson(c),
    ];
  }

  Future<void> saveCategories(List<Category> categories) async {
    await _writeJson(_categoriesFile, {'categories': [for (final c in categories) c.toJson()]});
    onChanged?.call();
  }

  Future<AppSettings> loadSettings() async {
    final j = await _readJson(_settingsFile);
    return j == null ? const AppSettings() : AppSettings.fromJson(j);
  }

  Future<void> saveSettings(AppSettings s) => _writeJson(_settingsFile, s.toJson());

  Future<BambooWallet> loadWallet() async {
    final j = await _readJson(_stateFile);
    return j == null ? const BambooWallet() : BambooWallet.fromJson(j);
  }

  Future<void> saveWallet(BambooWallet w) async {
    await _writeJson(_stateFile, w.toJson());
    onChanged?.call();
  }

  Future<Map<String, dynamic>?> _readJson(File f) async {
    try {
      if (!await f.exists()) return null;
      return jsonDecode(await f.readAsString()) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<void> _writeJson(File f, Map<String, dynamic> json) async {
    final tmp = File('${f.path}.tmp');
    await tmp.writeAsString(jsonEncode(json), flush: true);
    await tmp.rename(f.path);
  }

  static String newId() {
    final r = Random.secure();
    final bytes = List<int>.generate(8, (_) => r.nextInt(256));
    return '${DateTime.now().millisecondsSinceEpoch}-${bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join()}';
  }
}
