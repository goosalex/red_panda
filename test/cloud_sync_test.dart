import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_panda/l10n/l10n.dart';
import 'package:red_panda/storage/cloud_sync.dart';
import 'package:red_panda/storage/note_store.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late Directory tmp;
  late Directory phone; // this device's App Group folder
  late Directory cloud; // the iCloud folder
  late Directory ipad; // another device

  setUp(() {
    tmp = Directory.systemTemp.createTempSync('red_panda_cloud');
    phone = Directory('${tmp.path}/phone')..createSync();
    cloud = Directory('${tmp.path}/cloud')..createSync();
    ipad = Directory('${tmp.path}/ipad')..createSync();
  });
  tearDown(() => tmp.deleteSync(recursive: true));

  File f(Directory root, String path) => File('${root.path}/$path');

  void write(Directory root, String path, String text, {DateTime? at}) {
    final file = f(root, path)..parent.createSync(recursive: true);
    file.writeAsStringSync(text);
    if (at != null) file.setLastModifiedSync(at);
  }

  String? read(Directory root, String path) {
    final file = f(root, path);
    return file.existsSync() ? file.readAsStringSync() : null;
  }

  Future<SyncReport> sync(Directory device) => CloudSync(device, cloud).run();

  test('only notes, audio, categories and bamboo are synced', () {
    expect(CloudSync.tracks('notes/1.json'), isTrue);
    expect(CloudSync.tracks('audio/1.m4a'), isTrue);
    expect(CloudSync.tracks('categories.json'), isTrue);
    expect(CloudSync.tracks('panda_state.json'), isTrue);
    expect(CloudSync.tracks('settings.json'), isFalse);
    expect(CloudSync.tracks('widget_cache.json'), isFalse);
    expect(CloudSync.tracks('notes/1.json.tmp'), isFalse);
  });

  test('a note travels from one device to another', () async {
    write(phone, 'notes/a.json', '{"id":"a"}');
    write(phone, 'audio/a.m4a', 'sound');
    write(phone, 'settings.json', '{"mine":true}');
    final up = await sync(phone);
    expect(up.uploaded, containsAll(['notes/a.json', 'audio/a.m4a']));
    expect(read(cloud, 'settings.json'), isNull);

    final down = await sync(ipad);
    expect(down.changedHere, isTrue);
    expect(read(ipad, 'notes/a.json'), '{"id":"a"}');
    expect(read(ipad, 'audio/a.m4a'), 'sound');
  });

  test('first sync on a second device merges both sides', () async {
    write(phone, 'notes/a.json', 'A');
    await sync(phone);
    write(ipad, 'notes/b.json', 'B');
    await sync(ipad);
    await sync(phone);
    for (final d in [phone, ipad, cloud]) {
      expect(read(d, 'notes/a.json'), 'A');
      expect(read(d, 'notes/b.json'), 'B');
    }
  });

  test('a deletion on one device deletes it everywhere', () async {
    write(phone, 'notes/a.json', 'A');
    await sync(phone);
    await sync(ipad);

    f(ipad, 'notes/a.json').deleteSync();
    final r1 = await sync(ipad);
    expect(r1.deletedThere, ['notes/a.json']);
    expect(read(cloud, 'notes/a.json'), isNull);

    final r2 = await sync(phone);
    expect(r2.deletedHere, ['notes/a.json']);
    expect(read(phone, 'notes/a.json'), isNull);
  });

  test('an edit wins over the unchanged copy, both ways', () async {
    write(phone, 'notes/a.json', 'v1');
    await sync(phone);
    await sync(ipad);

    write(ipad, 'notes/a.json', 'v2 from iPad');
    await sync(ipad);
    final r = await sync(phone);
    expect(r.downloaded, ['notes/a.json']);
    expect(read(phone, 'notes/a.json'), 'v2 from iPad');

    write(phone, 'notes/a.json', 'v3 from phone');
    await sync(phone);
    await sync(ipad);
    expect(read(ipad, 'notes/a.json'), 'v3 from phone');
  });

  test('edited on both: the newer edit wins', () async {
    write(phone, 'categories.json', 'v1');
    await sync(phone);
    await sync(ipad);
    write(phone, 'categories.json', 'older', at: DateTime(2026, 1, 1, 9));
    write(ipad, 'categories.json', 'newer', at: DateTime(2026, 1, 1, 10));
    await sync(ipad);
    await sync(phone);
    expect(read(phone, 'categories.json'), 'newer');
  });

  test('a note edited here survives its deletion elsewhere', () async {
    write(phone, 'notes/a.json', 'v1');
    await sync(phone);
    await sync(ipad);
    f(ipad, 'notes/a.json').deleteSync();
    await sync(ipad);
    write(phone, 'notes/a.json', 'edited meanwhile');
    final r = await sync(phone);
    expect(r.uploaded, ['notes/a.json']);
    expect(read(cloud, 'notes/a.json'), 'edited meanwhile');
  });

  test('files iCloud has not downloaded yet are left alone', () async {
    write(phone, 'notes/a.json', 'A');
    await sync(phone);
    // iCloud evicted the file: only the placeholder is left.
    f(cloud, 'notes/a.json').deleteSync();
    write(cloud, 'notes/.a.json.icloud', 'placeholder');
    final r = await sync(phone);
    expect(r.pending, 1);
    expect(r.deletedHere, isEmpty);
    expect(read(phone, 'notes/a.json'), 'A');
  });

  test('an emptied iCloud folder never wipes this device', () async {
    write(phone, 'notes/a.json', 'A');
    await sync(phone);
    cloud.deleteSync(recursive: true);
    cloud.createSync();
    final r = await sync(phone);
    expect(r.deletedHere, isEmpty);
    expect(r.uploaded, ['notes/a.json']);
    expect(read(phone, 'notes/a.json'), 'A');
  });

  test('controller: signed out, synced, switched off', () async {
    final store = await NoteStore.at(phone);
    String? path;
    final c = CloudSyncController(store, locate: () async => path);

    expect(await c.run(enabled: true), isFalse);
    expect(c.status.value.state, CloudState.unavailable);
    expect(c.status.value.label(lookupAppLocalizations(const Locale('en'))), 'Not signed in');

    write(cloud, 'notes/b.json', 'B');
    path = cloud.path;
    expect(await c.run(enabled: true), isTrue);
    expect(c.status.value.state, CloudState.synced);
    expect(read(phone, 'notes/b.json'), 'B');

    await c.run(enabled: false);
    expect(c.status.value.label(lookupAppLocalizations(const Locale('en'))), 'Off');
    expect(f(phone, '.cloud_sync.json').existsSync(), isFalse);
  });

  test('fingerprints differ for different content', () {
    expect(CloudSync.fingerprint([1, 2, 3]), isNot(CloudSync.fingerprint([1, 2, 4])));
    expect(CloudSync.fingerprint([1, 2, 3]), CloudSync.fingerprint([1, 2, 3]));
  });
}
