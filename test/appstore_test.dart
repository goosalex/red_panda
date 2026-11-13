import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// App Store Connect limits for the texts in appstore/metadata/
/// (written by tool/appstore/store_texts.py).
void main() {
  const limits = {
    'name': 30,
    'subtitle': 30,
    'keywords': 100,
    'promotional_text': 170,
    'description': 4000,
    'release_notes': 4000,
  };
  final locales = Directory('appstore/metadata').listSync().whereType<Directory>().toList();

  test('every App Store language has its texts within the limits', () {
    final names = locales.map((d) => d.uri.pathSegments[d.uri.pathSegments.length - 2]).toSet();
    expect(names, containsAll(['en-GB', 'en-US', 'fr-FR', 'de-DE', 'es-MX', 'it', 'ja', 'ar-SA']));
    for (final d in locales) {
      for (final MapEntry(key: field, value: max) in limits.entries) {
        final text = File('${d.path}/$field.txt').readAsStringSync().trim();
        expect(text, isNotEmpty, reason: '${d.path} $field');
        // Keywords: counted in bytes to be safe with Japanese and Arabic.
        final length = field == 'keywords' ? utf8.encode(text).length : text.characters;
        expect(length, lessThanOrEqualTo(max), reason: '${d.path} $field');
      }
      final keywords = File('${d.path}/keywords.txt').readAsStringSync().trim().split(',');
      expect(keywords.where((k) => k.toLowerCase().contains('red panda')), isEmpty, reason: d.path);
    }
  });

  test('the store links point at the pages in docs/', () {
    for (final d in locales) {
      for (final page in ['privacy', 'support']) {
        final url = File('${d.path}/${page}_url.txt').readAsStringSync().trim();
        final m = RegExp(r'^https://goosalex\.github\.io/red_panda/(\w+)/(\w+)/$').firstMatch(url);
        expect(m, isNotNull, reason: url);
        expect(File('docs/${m!.group(1)}/${m.group(2)}.md').existsSync(), isTrue, reason: url);
      }
    }
  });
}

extension on String {
  int get characters => runes.length;
}
