import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import 'note_store.dart';

/// iCloud sync: mirrors the notes, voice recordings, categories and the
/// bamboo stash between the App Group container and Red Panda's own iCloud
/// Drive folder (hidden from the Files app). iCloud moves the files between
/// devices; this decides, file by file, which side is newer.
///
/// Three-way: `.cloud_sync.json` remembers each file as it was after the last
/// sync, so a file missing on one side is either new on the other (copy it)
/// or deleted here (delete it there too). Edited on both sides: the newer one
/// wins. Settings stay per device.
class CloudSync {
  CloudSync(this.local, this.remote);

  final Directory local;
  final Directory remote;

  static const _baseName = '.cloud_sync.json';
  File get _baseFile => File('${local.path}/$_baseName');

  /// Synced paths, relative to both roots.
  static bool tracks(String path) =>
      (path.startsWith('notes/') && path.endsWith('.json')) ||
      (path.startsWith('audio/') && !path.endsWith('.tmp')) ||
      path == 'categories.json' ||
      path == 'panda_state.json';

  Future<SyncReport> run() async {
    final base = await _readBase();
    final mine = await _scan(local, placeholders: false);
    final theirs = await _scan(remote, placeholders: true);
    final report = SyncReport();

    // Every sync leaves a marker in the iCloud folder. Without it, after
    // earlier syncs, the folder was reset (or is not there yet): nothing
    // missing there counts as deleted, so this device uploads, never wipes.
    final remoteReset = base.isNotEmpty && !await _hasMarker();

    final next = <String, String>{};
    final paths = {...base.keys, ...mine.keys, ...theirs.keys};
    for (final p in paths) {
      final l = mine[p];
      final r = theirs[p];
      final b = remoteReset ? null : base[p];
      if (r != null && r.pending) {
        // Still downloading: decide on the next run.
        report.pending++;
        if (base[p] != null) next[p] = base[p]!;
        continue;
      }
      if (l == null && r == null) continue;
      if (l != null && r != null) {
        if (l.sig == r.sig) {
          next[p] = l.sig;
        } else if (l.sig == b) {
          await _copy(remote, local, p);
          report.downloaded.add(p);
          next[p] = r.sig;
        } else if (r.sig == b || !r.modified.isAfter(l.modified)) {
          await _copy(local, remote, p);
          report.uploaded.add(p);
          next[p] = l.sig;
        } else {
          await _copy(remote, local, p);
          report.downloaded.add(p);
          next[p] = r.sig;
        }
      } else if (l != null) {
        if (b == l.sig) {
          await _delete(local, p); // Deleted on another device.
          report.deletedHere.add(p);
        } else {
          await _copy(local, remote, p);
          report.uploaded.add(p);
          next[p] = l.sig;
        }
      } else {
        if (b == r!.sig) {
          await _delete(remote, p); // Deleted here.
          report.deletedThere.add(p);
        } else {
          await _copy(remote, local, p);
          report.downloaded.add(p);
          next[p] = r.sig;
        }
      }
    }
    await _writeBase(next);
    if (!await _hasMarker()) await File('${remote.path}/$_marker').writeAsString('Red Panda iCloud sync');
    return report;
  }

  static const _marker = 'redpanda.sync';

  Future<bool> _hasMarker() async =>
      await File('${remote.path}/$_marker').exists() ||
      await File('${remote.path}/.$_marker.icloud').exists();

  /// Forgets what was synced (when sync is switched off), so switching it on
  /// again merges both sides instead of replaying deletions.
  Future<void> forget() async {
    if (await _baseFile.exists()) await _baseFile.delete();
  }

  Future<Map<String, _Entry>> _scan(Directory root, {required bool placeholders}) async {
    final out = <String, _Entry>{};
    if (!await root.exists()) return out;
    for (final sub in ['', 'notes/', 'audio/']) {
      final dir = Directory('${root.path}/$sub');
      if (!await dir.exists()) continue;
      await for (final f in dir.list()) {
        if (f is! File) continue;
        final name = f.uri.pathSegments.last;
        // iOS keeps a not-yet-downloaded iCloud file as ".name.icloud".
        if (placeholders && name.startsWith('.') && name.endsWith('.icloud')) {
          final p = '$sub${name.substring(1, name.length - '.icloud'.length)}';
          if (tracks(p)) out[p] = _Entry.waiting;
          continue;
        }
        if (name.startsWith('.')) continue; // Our temp files, iCloud's own.
        final p = '$sub$name';
        if (!tracks(p) || out[p] != null) continue;
        out[p] = _Entry(fingerprint(await f.readAsBytes()), await f.lastModified());
      }
    }
    return out;
  }

  Future<void> _copy(Directory from, Directory to, String p) async {
    final src = File('${from.path}/$p');
    final dst = File('${to.path}/$p');
    await dst.parent.create(recursive: true);
    // Write next to the target, then rename: never a half-written note.
    final tmp = File('${dst.parent.path}/.${dst.uri.pathSegments.last}.sync');
    await tmp.writeAsBytes(await src.readAsBytes(), flush: true);
    await tmp.rename(dst.path);
    await dst.setLastModified(await src.lastModified());
  }

  Future<void> _delete(Directory root, String p) async {
    final f = File('${root.path}/$p');
    if (await f.exists()) await f.delete();
  }

  Future<Map<String, String>> _readBase() async {
    try {
      final j = jsonDecode(await _baseFile.readAsString()) as Map<String, dynamic>;
      return (j['files'] as Map<String, dynamic>).cast<String, String>();
    } catch (_) {
      return {};
    }
  }

  Future<void> _writeBase(Map<String, String> files) async {
    final tmp = File('${_baseFile.path}.tmp');
    await tmp.writeAsString(jsonEncode({'files': files}), flush: true);
    await tmp.rename(_baseFile.path);
  }

  /// FNV-1a (64 bit) of the bytes plus their length: tells files apart.
  static String fingerprint(List<int> bytes) {
    var h = 0xcbf29ce484222325;
    for (final b in bytes) {
      h ^= b;
      h = (h * 0x100000001b3) & 0xFFFFFFFFFFFFFFFF;
    }
    return '${bytes.length}-${h.toUnsigned(64).toRadixString(16)}';
  }
}

class _Entry {
  _Entry(this.sig, this.modified) : pending = false;
  _Entry._waiting()
      : sig = '',
        modified = DateTime.fromMillisecondsSinceEpoch(0),
        pending = true;

  /// A file iCloud has not downloaded yet.
  static final waiting = _Entry._waiting();

  final String sig;
  final DateTime modified;
  final bool pending;
}

class SyncReport {
  final uploaded = <String>[];
  final downloaded = <String>[];
  final deletedHere = <String>[];
  final deletedThere = <String>[];
  int pending = 0;

  /// Whether the app has to reload what it shows.
  bool get changedHere => downloaded.isNotEmpty || deletedHere.isNotEmpty;

  @override
  String toString() => 'up ${uploaded.length}, down ${downloaded.length}, '
      'deleted here ${deletedHere.length}, there ${deletedThere.length}, pending $pending';
}

enum CloudState { off, unavailable, syncing, synced, failed }

@immutable
class CloudStatus {
  const CloudStatus(this.state, {this.at, this.pending = 0});
  final CloudState state;
  final DateTime? at;
  final int pending;

  /// Short status for the Settings row, in [l]'s language.
  String label(AppLocalizations l) => switch (state) {
        CloudState.off => l.settingsOff,
        CloudState.unavailable => l.cloudNotSignedIn,
        CloudState.syncing => l.cloudSyncing,
        CloudState.synced => pending > 0 ? l.cloudDownloading : l.settingsOn,
        CloudState.failed => l.cloudFailed,
      };
}

/// Runs [CloudSync] when asked (start, resume, after edits, iCloud changes),
/// one run at a time, and publishes [status].
class CloudSyncController {
  CloudSyncController(this.store, {Future<String?> Function()? locate})
      : _locate = locate ?? _nativeLocate;

  final NoteStore store;
  final Future<String?> Function() _locate;
  final status = ValueNotifier(const CloudStatus(CloudState.off));

  static const channel = MethodChannel('red_panda/app_group');

  bool _running = false;
  bool _again = false;

  /// Syncs if [enabled]; returns whether notes on this device changed.
  Future<bool> run({required bool enabled}) async {
    if (!enabled) {
      if (status.value.state != CloudState.off) {
        status.value = const CloudStatus(CloudState.off);
        await CloudSync(store.root, store.root).forget();
        await _nativeStop();
      }
      return false;
    }
    if (_running) {
      _again = true;
      return false;
    }
    _running = true;
    var changed = false;
    try {
      do {
        _again = false;
        final path = await _locate();
        if (path == null) {
          status.value = const CloudStatus(CloudState.unavailable);
          break;
        }
        if (status.value.state != CloudState.synced) status.value = const CloudStatus(CloudState.syncing);
        final report = await CloudSync(store.root, Directory(path)).run();
        changed |= report.changedHere;
        status.value = CloudStatus(CloudState.synced, at: DateTime.now(), pending: report.pending);
      } while (_again);
    } catch (e) {
      debugPrint('iCloud sync failed: $e');
      status.value = CloudStatus(CloudState.failed, at: DateTime.now());
    } finally {
      _running = false;
    }
    return changed;
  }

  /// Folder in the iCloud container (null when signed out of iCloud or
  /// iCloud Drive is off). Also starts downloads and change notifications.
  static Future<String?> _nativeLocate() async {
    try {
      return await channel.invokeMethod<String>('cloudContainer');
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }

  static Future<void> _nativeStop() async {
    try {
      await channel.invokeMethod<void>('cloudStop');
    } on MissingPluginException {
      // Tests.
    } on PlatformException {
      // Nothing to stop.
    }
  }
}
