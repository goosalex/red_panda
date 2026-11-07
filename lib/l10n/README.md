# App texts

`app_en.arb` is the source; `app_fr`, `app_de`, `app_es` (Latin American
wording, used for every Spanish locale), `app_it`, `app_ja` and `app_ar`
(Levantine wording, used for every Arabic locale, right-to-left) must have
every key. `flutter gen-l10n` (or any build) writes `gen/`.

Use `context.l10n.someKey` (lib/l10n/l10n.dart). Native texts (widgets,
controls, notifications, Siri phrases, share extension, permission prompts)
live in the String Catalogs under ios/.
