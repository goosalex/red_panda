import 'package:flutter/widgets.dart';

import 'gen/app_localizations.dart';

export 'gen/app_localizations.dart';

/// The app's languages: English (source), French, German, Spanish (Latin
/// American wording), Italian, Japanese and Arabic (Levantine wording).
const appLocales = [
  Locale('en'),
  Locale('fr'),
  Locale('de'),
  Locale('es'),
  Locale('it'),
  Locale('ja'),
  Locale('ar'),
];

extension L10nContext on BuildContext {
  /// The app texts in the current language. Falls back to English where no
  /// localizations are set up (widget tests that pump a bare MaterialApp).
  AppLocalizations get l10n => AppLocalizations.of(this) ?? lookupAppLocalizations(const Locale('en'));
}
