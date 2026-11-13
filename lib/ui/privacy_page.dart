import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../platform/shortcuts_links.dart';
import 'readable.dart';

/// Settings > Panda > Privacy: what Red Panda does (and never does) with your
/// data, readable offline, with links to the full policy and the source code.
/// Keep it in line with `docs/<lang>/privacy.md` and ios/*/PrivacyInfo.xcprivacy.
class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  static const sourceUrl = 'https://github.com/os-mas-datos/red_panda';

  /// The privacy policy on GitHub Pages (docs/), in [lang] where it exists.
  static String policyUrl(String lang) =>
      'https://os-mas-datos.github.io/red_panda/${appLocales.any((l) => l.languageCode == lang) ? lang : 'en'}/privacy/';

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(title: Text(l.settingsPrivacy)),
      body: ListView(
        padding: readableInsets(context).copyWith(bottom: 32),
        children: [
          _Point(Icons.visibility_off_outlined, l.privacyNothingTitle, l.privacyNothingBody),
          _Point(Icons.sticky_note_2_outlined, l.privacyNotesTitle, l.privacyNotesBody),
          _Point(Icons.location_on_outlined, l.privacyLocationTitle, l.privacyLocationBody),
          _Point(Icons.mic_none, l.privacyVoiceTitle, l.privacyVoiceBody),
          _Point(Icons.code, l.privacyOpenTitle, l.privacyOpenBody),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.policy_outlined, color: Colors.blue),
            title: Text(l.privacyPolicyLink, style: const TextStyle(color: Colors.blue)),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => ShortcutsLinks.openExternal(policyUrl(lang)),
          ),
          ListTile(
            leading: const Icon(Icons.code, color: Colors.blue),
            title: Text(l.privacySourceLink, style: const TextStyle(color: Colors.blue)),
            trailing: const Icon(Icons.open_in_new, size: 18),
            onTap: () => ShortcutsLinks.openExternal(sourceUrl),
          ),
        ],
      ),
    );
  }
}

class _Point extends StatelessWidget {
  const _Point(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) => ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        subtitle: Text(body),
      );
}
