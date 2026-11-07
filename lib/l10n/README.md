# App texts

`app_en.arb` is the source; `app_fr`, `app_de`, `app_es` (Latin American
wording, used for every Spanish locale), `app_it`, `app_ja` and `app_ar`
(Levantine wording, used for every Arabic locale, right-to-left) must have
every key. `flutter gen-l10n` (or any build) writes `gen/`.

Use `context.l10n.someKey` (lib/l10n/l10n.dart). Native texts (widgets,
controls, notifications, Siri phrases, share extension, permission prompts)
live in the String Catalogs under ios/.

## Adding a language

1. Add it to `appLocales` (lib/l10n/l10n.dart), add `app_<lang>.arb` with every
   key, and add it to every String Catalog under ios/ and to
   `CFBundleLocalizations`.
2. **Record the Settings walkthroughs in it.** Blue links such as
   `[Settings](microphone)` in the texts play short animations of the way
   through the iOS Settings app, recorded in each language so the names match
   what the user sees. Add the language to `record.sh`'s default list and the
   locale table in `tool/walkthroughs/Walkthroughs/Recorder.swift`, then run
   `flutter build ios --simulator --debug` and `tool/walkthroughs/record.sh <lang>`.
   `test/walkthrough_test.dart` fails until every walkthrough exists in every
   app language. Re-record all languages when iOS renames a Settings screen.
3. Keep the link markup: the same `[…](walkthrough)` links in every language.
