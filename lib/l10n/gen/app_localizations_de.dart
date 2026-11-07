// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => 'Bis morgen schlummern';

  @override
  String get swipeSnoozeInfo =>
      'Blendet den Eintrag bis morgen früh aus. Kostet Bambus.';

  @override
  String get swipePostpone => 'Frist um einen Tag verschieben';

  @override
  String get swipePostponeInfo =>
      'Kostenlos, solange die Frist weit weg ist; kostet Bambus, wenn sie nah ist.';

  @override
  String get swipePin => 'Oben anheften';

  @override
  String get swipePinInfo => 'Schiebt den Eintrag an den Anfang der Liste.';

  @override
  String get swipeCategory => 'In Kategorie verschieben';

  @override
  String get swipeCategoryInfo => 'Wähle eine Wolke für den Eintrag.';

  @override
  String get swipeDeadline => 'Frist setzen';

  @override
  String get swipeDeadlineInfo => 'Öffnet die Tage-Drehscheibe.';

  @override
  String get swipeRemindLater => 'Später heute erinnern';

  @override
  String get swipeRemindLaterInfo => 'Ein einmaliger Stups in drei Stunden.';

  @override
  String get swipeDuplicate => 'Duplizieren';

  @override
  String get swipeDuplicateInfo =>
      'Kopiert den Eintrag, praktisch für wiederkehrende Aufgaben.';

  @override
  String get swipeBasket => 'In den Mitnehm-Korb legen';

  @override
  String get swipeBasketInfo =>
      'Erinnert dich, wenn du diesen Ort oder dein WLAN verlässt.';

  @override
  String get swipeShare => 'Teilen';

  @override
  String get swipeShareInfo => 'Teilt den Eintrag als Text.';

  @override
  String get nagOff => 'Aus';

  @override
  String get nagGentle => 'Sanft';

  @override
  String get nagNormal => 'Normal';

  @override
  String get nagPersistent => 'Hartnäckig';
}
