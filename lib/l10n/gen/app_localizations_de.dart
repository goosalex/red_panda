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

  @override
  String get basketIn =>
      'Im Mitnehm-Korb 🧺 Der Panda erinnert dich, wenn du diesen Ort verlässt.';

  @override
  String get basketOut => 'Aus dem Mitnehm-Korb genommen.';

  @override
  String get basketEmptyStatus =>
      'Der Korb ist leer. Zieh Einträge hinein, damit du beim Losgehen an sie erinnert wirst.';

  @override
  String get basketNeedsLocation =>
      'Red Panda braucht deinen Standort, um zu merken, wann du gehst. Erlaube ihn in den Einstellungen.';

  @override
  String get basketWatching => 'Ich passe auf';

  @override
  String basketWatchingSince(String time) {
    return 'Ich passe auf (seit $time)';
  }

  @override
  String basketReasonPlace(int radius) {
    return 'du bekommst eine Erinnerung, sobald du dich mehr als $radius m entfernst.';
  }

  @override
  String get basketReasonWifi =>
      'du bekommst eine Erinnerung, wenn dein WLAN wegfällt.';

  @override
  String basketReasonBoth(int radius) {
    return 'du bekommst eine Erinnerung, sobald du dich mehr als $radius m entfernst oder dein WLAN wegfällt.';
  }

  @override
  String get basketNotWatching =>
      'Gerade passe ich nicht auf. Tippe auf „Ab hier aufpassen“, um zu starten.';

  @override
  String basketSheetTitle(int count) {
    return '🧺 Mitnehm-Korb · $count';
  }

  @override
  String get basketNeedsAlways =>
      'Damit Red Panda dein Losgehen auch geschlossen bemerkt, stell Ortungsdienste in den Einstellungen auf „Immer“.';

  @override
  String get basketWatchHere => 'Ab hier aufpassen';

  @override
  String get openSettings => 'Einstellungen öffnen';

  @override
  String get basketEmptyAction => 'Korb leeren';

  @override
  String get basketWatchingHere => 'Ich passe ab hier auf 📍';

  @override
  String get noLocation => 'Dein Standort ließ sich nicht ermitteln.';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage am Stück! Der Panda ist stolz.',
      one: '1 Tag am Stück! Der Panda ist stolz.',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return '+$earned 🎋 Bambus für den Panda ($balance im Vorrat)';
  }

  @override
  String bambooFull(int cap) {
    return 'Der Bambusvorrat ist voll ($cap). Schlummere etwas oder mach weiter!';
  }

  @override
  String get deleted => 'Gelöscht';

  @override
  String get undo => 'Widerrufen';

  @override
  String get wokenUp => 'Früher aufgeweckt.';

  @override
  String nudgeAt(String time) {
    return 'Der Panda stupst dich um $time an.';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'Nicht genug Bambus zum Schlummern (nötig: $cost, du hast $balance). Erledige eine Aufgabe, um welchen zu verdienen 🎋';
  }

  @override
  String snoozed(int cost) {
    return 'Bis morgen geschlummert · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return 'So kurz vor der Frist kostet Verschieben $cost 🎋, und der Vorrat ist leer.';
  }

  @override
  String deadlineMoved(String when) {
    return 'Frist verschoben: $when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return 'Frist verschoben: $when · −$cost 🎋';
  }

  @override
  String get cancel => 'Abbrechen';

  @override
  String get set => 'Festlegen';

  @override
  String get ok => 'OK';

  @override
  String get noCloudsYet =>
      'Noch keine Wolken. Tippe neben dem Panda auf „+ Kategorie“.';

  @override
  String get noCategory => 'Keine Kategorie';

  @override
  String filedUnder(String name) {
    return 'Abgelegt unter $name ☁️';
  }

  @override
  String get newCloud => 'Neue Kategorie-Wolke';

  @override
  String get rename => 'Umbenennen';

  @override
  String get renameCloud => 'Wolke umbenennen';

  @override
  String get removeCloud => 'Wolke entfernen';

  @override
  String get removeCloudInfo => 'Die Einträge bleiben, nur ohne Kategorie';

  @override
  String get cloudNameHint => 'z. B. Zuhause, Arbeit, Einkaufen';

  @override
  String get micNeeded =>
      'Red Panda braucht das Mikrofon. Erlaube es unter Einstellungen > Red Panda.';

  @override
  String get recordFailed => 'Aufnahme konnte nicht starten.';

  @override
  String get search => 'Suchen';

  @override
  String get closeSearch => 'Suche schließen';

  @override
  String get settings => 'Einstellungen';

  @override
  String get newTextNote => 'Neue Textnotiz';

  @override
  String onlyCategory(String name) {
    return 'Nur $name';
  }

  @override
  String get onlyBasket => 'Nur der Mitnehm-Korb';

  @override
  String get emptyBasketList =>
      'Der Mitnehm-Korb ist leer. Zieh Einträge auf den Korb, damit du beim Losgehen an sie erinnert wirst.';

  @override
  String emptyCategoryDay(String name) {
    return 'Nichts in $name. Zieh einen Eintrag auf die Wolke oder tippe auf die Sonne, um alles zu sehen.';
  }

  @override
  String emptyCategoryNight(String name) {
    return 'Nichts in $name. Zieh einen Eintrag auf die Wolke oder tippe auf den Mond, um alles zu sehen.';
  }

  @override
  String get noNotes =>
      'Noch keine Notizen. Halte eine über den Sperrbildschirm oder die Aktionstaste fest, oder tippe auf +.';

  @override
  String get hideSnoozed => 'Geschlummerte ausblenden';

  @override
  String showSnoozed(int count) {
    return '$count geschlummert · zeigen';
  }

  @override
  String get undoCheck => 'Abhaken rückgängig';

  @override
  String get wakeUp => 'Aufwecken';

  @override
  String streakChip(int days) {
    return '🔥 $days T';
  }

  @override
  String tickedToday(int count) {
    return '✓ $count heute';
  }

  @override
  String get bambooTooltip =>
      'Bambus: verdienst du mit erledigten Aufgaben, ausgeben kannst du ihn fürs Schlummern';

  @override
  String level(int level) {
    return 'Lv. $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 Der Panda ist traurig: $count überfällig';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ $count heute fällig. Der Panda passt auf.';
  }

  @override
  String get recordVoice => 'Sprachnotiz aufnehmen';

  @override
  String get stopVoice => 'Stoppen und Sprachnotiz sichern';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 bis $time';
  }

  @override
  String get edit => 'Bearbeiten';

  @override
  String get done => 'Erledigt';

  @override
  String get tickOff => 'Abhaken';

  @override
  String get inLeaveBasket => 'Im Mitnehm-Korb';

  @override
  String daysLate(int days) {
    return '$days T zu spät';
  }

  @override
  String get today => 'heute';

  @override
  String daysShort(int days) {
    return '$days T';
  }

  @override
  String dueOn(String date) {
    return 'Fällig: $date';
  }

  @override
  String get dragHint => 'Ziehen zum Umsortieren oder auf eine Kategorie-Wolke';

  @override
  String get noteHint => 'Notiz';

  @override
  String get newNoteHint => 'Neue Notiz';

  @override
  String get deadline => 'Frist';

  @override
  String get leaveBasket => 'Mitnehm-Korb';

  @override
  String get leaveBasketTooltip =>
      'Erinnere mich, wenn ich diesen Ort verlasse';

  @override
  String get save => 'Sichern';

  @override
  String get add => 'Hinzufügen';

  @override
  String get turnDial => 'Dreh am Rad';

  @override
  String get clear => 'Löschen';

  @override
  String cloudSemantics(String name, int count) {
    return 'Kategorie $name, $count offen';
  }

  @override
  String get cloudHintShowAll => 'Doppeltippen, um alles zu zeigen';

  @override
  String get cloudHintOnly => 'Doppeltippen, um nur diese Kategorie zu zeigen';

  @override
  String get addCategory => 'Kategorie hinzufügen';

  @override
  String get plusCategory => '+ Kategorie';

  @override
  String get sun => 'Sonne';

  @override
  String get moon => 'Mond';

  @override
  String get showsAllItems => 'Zeigt alle Einträge';

  @override
  String get noDeadline => 'keine Frist';

  @override
  String get tomorrow => 'morgen';

  @override
  String inDays(int days) {
    return 'in $days Tagen';
  }

  @override
  String get noDate => 'kein Datum';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Tage',
      one: 'Tag',
    );
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mitnehm-Korb, $count Einträge',
      one: 'Mitnehm-Korb, 1 Eintrag',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => ', passt auf';

  @override
  String get basketHint =>
      'Leg Einträge hier ab, um beim Losgehen erinnert zu werden. Doppeltippen zum Filtern.';
}
