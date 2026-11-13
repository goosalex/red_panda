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
      'Red Panda braucht deinen Standort, um zu merken, wann du gehst. Erlaube ihn in den [Einstellungen](location).';

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
      'Damit Red Panda dein Losgehen auch geschlossen bemerkt, stell Ortungsdienste in den [Einstellungen](location) auf „Immer“.';

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
      'Red Panda braucht das Mikrofon. Erlaube es in den [Einstellungen](microphone).';

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
  String get noNotesPad =>
      'Noch keine Notizen. Halte eine über den Sperrbildschirm oder das Kontrollzentrum fest, oder tippe auf +.';

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

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsHeaderList => 'Liste';

  @override
  String get settingsHeaderReminders => 'Erinnerungen';

  @override
  String get settingsHeaderPanda => 'Panda';

  @override
  String get settingsCloudSync => 'iCloud-Sync';

  @override
  String get settingsCloudNote =>
      'Notizen, Sprachnotizen, Kategorien und Bambus werden über dein iCloud Drive mit jedem iPhone und iPad synchronisiert, das mit demselben Apple Account angemeldet ist. Einstellungen bleiben auf jedem Gerät.';

  @override
  String get settingsOn => 'An';

  @override
  String get settingsOff => 'Aus';

  @override
  String get settingsSwipeRight => 'Nach rechts wischen';

  @override
  String get settingsSwipeDrawerTitle => 'Eintrag nach rechts wischen';

  @override
  String get settingsSwipeDrawerNote =>
      'Abgehakte Einträge werden immer wieder offen; schlummernde wachen auf.';

  @override
  String get settingsNag => 'Traurige-Panda-Erinnerungen';

  @override
  String get settingsNagNote =>
      'Mitteilungen und Widgets drängeln, je näher die Fristen rücken.';

  @override
  String get settingsQuietFrom => 'Ruhe ab';

  @override
  String get settingsQuietUntil => 'Ruhe bis';

  @override
  String get settingsLeaveBasket => 'Mitnehm-Korb';

  @override
  String get settingsBambooRules => 'Bambus-Regeln';

  @override
  String settingsBambooMax(int cap) {
    return 'Max. $cap';
  }

  @override
  String get bambooTitle => '🎋 Bambus';

  @override
  String bambooRules(
    int perCompletion,
    int earlyBonus,
    int snoozeCost,
    int freeDays,
    int lateCost,
    int cap,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      freeDays,
      locale: localeName,
      other: '$freeDays Tage',
      one: '$freeDays Tag',
    );
    return 'Jeder erledigte Eintrag füttert den Panda mit $perCompletion 🎋 (+$earlyBonus, wenn er vor dem Fristtag fertig ist). Schlummern kostet $snoozeCost 🎋; eine Frist zu verschieben ist bis $_temp0 vorher kostenlos, danach kostet es $lateCost 🎋. Der Vorrat fasst höchstens $cap.';
  }

  @override
  String get settingsQuickCapture => 'Schnell notieren';

  @override
  String get settingsQuickCaptureValue => 'Sperrbildschirm, Siri …';

  @override
  String get settingsNews => 'Neuigkeiten';

  @override
  String newsVersion(String version) {
    return 'Version $version';
  }

  @override
  String newsVersionNew(String version) {
    return 'Version $version · neu';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => 'Nicht angemeldet';

  @override
  String get cloudSyncing => 'Synchronisiert …';

  @override
  String get cloudDownloading => 'Lädt …';

  @override
  String get cloudFailed => 'Fehlgeschlagen, neuer Versuch';

  @override
  String get basketTitle => '🧺 Mitnehm-Korb';

  @override
  String get basketNote =>
      'Einträge im Korb erinnern dich, sobald du den Ort verlässt, an dem du sie hineingelegt hast, oder dein WLAN wegfällt.';

  @override
  String get basketOnPlace => 'Wenn ich diesen Ort verlasse';

  @override
  String get basketRadius => 'Radius';

  @override
  String get basketRadiusTitle => 'Erinnere mich, wenn ich weiter weg bin als';

  @override
  String get basketRadiusNote =>
      'Das iPhone ortet dich auf etwa 100 m genau, ein kleiner Radius kann also etwas spät auslösen.';

  @override
  String get basketOnWifi => 'Wenn mein WLAN wegfällt';

  @override
  String get basketLocationAccess => 'Standortzugriff';

  @override
  String get locationAlways => 'Immer';

  @override
  String get locationWhileUsing => 'Beim Verwenden';

  @override
  String get locationNotAsked => 'Noch nicht gefragt';

  @override
  String get basketWhyAlways => 'Warum „Immer“?';

  @override
  String get basketNoTracking => 'Kein Tracking';

  @override
  String get basketHeaderShortcuts => 'Kurzbefehle-Automationen';

  @override
  String get basketShortcutsNote =>
      'Red Panda merkt einen WLAN-Abbruch nur, solange die App offen ist oder gerade benutzt wurde. Eine Kurzbefehle-Automation erkennt ihn jederzeit und kann einen festen Ort wie dein Zuhause beobachten.';

  @override
  String get automationWifi => 'Wenn ich ein WLAN verlasse';

  @override
  String get automationPlace => 'Wenn ich einen Ort verlasse';

  @override
  String get automationSetUp => 'Einrichten';

  @override
  String get automationMine => 'Meine Automationen';

  @override
  String get shortcutsApp => 'Kurzbefehle';

  @override
  String get shortcutsOpen => 'Kurzbefehle öffnen';

  @override
  String get shortcutsRemindAction => 'An meinen Mitnehm-Korb erinnern';

  @override
  String get guideOpenShortcuts =>
      'Tippe unten auf „Kurzbefehle öffnen“: Die Liste „Neue Automation“ öffnet sich.';

  @override
  String get guideWifiScroll => 'Scrolle nach unten und tippe auf „WLAN“.';

  @override
  String get guideWifiNetwork =>
      'Wähle dein Netzwerk, hake „Trennt“ an und „Verbindet“ ab.';

  @override
  String get guideRunImmediately =>
      'Wähle „Sofort ausführen“ und tippe dann auf „Weiter“.';

  @override
  String get guidePlaceLeave =>
      'Tippe auf „Verlassen“, dann „Ort“ > „Auswählen“, und wähle den Ort (z. B. Zuhause).';

  @override
  String guideAddAction(String action) {
    return 'Tippe auf „Neue leere Automation“, dann „Aktion hinzufügen“, suche nach „Mitnehm-Korb“ und wähle „$action“.';
  }

  @override
  String get guideDone =>
      'Tippe auf „Fertig“. Ab jetzt erinnert dich der Panda an deinen Korb.';

  @override
  String get locationInfoTitle => 'Warum Standort „Immer“?';

  @override
  String get locationInfoLeaveTitle => 'Nur, um zu merken, dass du gehst';

  @override
  String get locationInfoLeaveBody =>
      'Mit „Beim Verwenden der App“ sagt iOS Red Panda nichts mehr, sobald die App zu ist – der Korb könnte dich nur bei offener App erinnern. Mit [„Immer“](location) weckt iOS Red Panda, sobald du gehst.';

  @override
  String get locationInfoBatteryTitle => 'Kein Akkuverbrauch';

  @override
  String get locationInfoBatteryBody =>
      'Red Panda verfolgt dich nicht. Die App fragt iOS einmal, wo du bist, und zieht einen Kreis darum. iOS beobachtet diesen Kreis mit den Mobilfunk- und WLAN-Signalen, die es sowieso nutzt, und Red Panda schläft, bis du den Rand überquerst. Dann wird der Kreis entfernt.';

  @override
  String get locationInfoPrivacyTitle =>
      'Dein Standort bleibt auf deinem iPhone';

  @override
  String get locationInfoPrivacyBody =>
      'Red Panda hat keinen Server und schickt deinen Standort nirgendwohin. Nur der Mittelpunkt des Kreises wird auf diesem Gerät gespeichert, bis die Erinnerung kommt. Die iCloud-Sync nimmt ihn nie mit.';

  @override
  String get locationInfoWifiTitle => 'WLAN braucht keinen Standort';

  @override
  String get locationInfoWifiBody =>
      '„Wenn mein WLAN wegfällt“ funktioniert ohne Standortzugriff.';

  @override
  String get captureLockScreen => 'Sperrbildschirm-Tasten';

  @override
  String get captureLockScreenHow =>
      'Sperrbildschirm lange drücken, auf „Anpassen“ > „Sperrbildschirm“ tippen, unten auf einen Platz für Steuerelemente tippen und Red Panda > Textnotiz, Sprachnotiz oder Pandas Korb zeigen wählen.';

  @override
  String get captureWidgets => 'Widgets';

  @override
  String get captureWidgetsHow =>
      '[Passe den Sperrbildschirm an](lockScreenWidget) und tippe auf den Widget-Bereich unter der Uhr (oder die Zeile darüber), um das Red Panda-Widget mit deiner nächsten Frist hinzuzufügen. Auf dem Home-Bildschirm [lange drücken, „Bearbeiten“ > „Widget hinzufügen“ tippen](homeScreenWidget) und nach „Red Panda“ suchen: Seine Tasten fügen eine Notiz hinzu oder zeigen Pandas Korb.';

  @override
  String get captureControlCentre => 'Kontrollzentrum';

  @override
  String get captureControlCentreHow =>
      'Öffne das Kontrollzentrum, tippe auf +, dann „Steuerelement hinzufügen“ und suche nach „Red Panda“.';

  @override
  String get captureActionButton => 'Aktionstaste';

  @override
  String get captureActionButtonHow =>
      '[Einstellungen > Aktionstaste > Steuerelemente](actionButton), dann Red Panda > Textnotiz, Sprachnotiz oder Pandas Korb zeigen wählen.';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      'Sag „Notiz mit Red Panda“, „Sprachnotiz mit Red Panda“ oder „Zeig meinen Red Panda-Korb“.';

  @override
  String capturePreview(String spot) {
    return 'Vorschau: $spot';
  }

  @override
  String get captureLinkMicrophone => 'Mikrofon & Spracherkennung';

  @override
  String get captureLinkSiri => 'Siri & Suchen';

  @override
  String get wifi => 'WLAN';

  @override
  String get walkLocationTitle => 'Standort: Immer';

  @override
  String get walkMicrophoneTitle => 'Mikrofon & Spracherkennung';

  @override
  String get walkSiriTitle => 'Red Panda und Siri';

  @override
  String get walkActionButtonTitle => 'Red Panda auf der Aktionstaste';

  @override
  String get walkActionButtonNote =>
      'Auf deinem iPhone wischst du weiter, bis Steuerelemente kommt.';

  @override
  String walkSemantics(String path) {
    return 'Animation des Wegs in den Einstellungen: $path';
  }

  @override
  String get walkLockScreenTitle => 'Red Panda auf dem Sperrbildschirm';

  @override
  String get walkHomeScreenTitle => 'Red Panda auf dem Home-Bildschirm';

  @override
  String get walkLongPress => 'Lange drücken';

  @override
  String get settingsPrivacy => 'Datenschutz';

  @override
  String get settingsPrivacyValue => 'Nichts wird erfasst';

  @override
  String get privacyNothingTitle => 'Red Panda erfasst nichts';

  @override
  String get privacyNothingBody =>
      'Keine Analyse, keine Werbung, kein Tracking und kein Konto. Red Panda hat keinen eigenen Server, deine Daten können also nirgendwohin.';

  @override
  String get privacyNotesTitle => 'Deine Notizen bleiben deine';

  @override
  String get privacyNotesBody =>
      'Notizen und Sprachaufnahmen werden auf diesem Gerät gespeichert. Mit iCloud-Sync werden sie in dein eigenes iCloud Drive kopiert, das nur du lesen kannst.';

  @override
  String get privacyLocationTitle => 'Standort nur für den Mitnehm-Korb';

  @override
  String get privacyLocationBody =>
      'Red Panda zeichnet nie auf, wohin du gehst. Es fragt iOS einmal, wo der Korb gefüllt wurde, und nur iOS achtet darauf, wann du gehst. Der Standort wird nie verschickt und nie synchronisiert.';

  @override
  String get privacyVoiceTitle =>
      'Sprachnotizen werden auf deinem iPhone zu Text';

  @override
  String get privacyVoiceBody =>
      'Sprache wird auf dem Gerät erkannt, wo iOS das für deine Sprache kann. Sonst nutzt iOS die Spracherkennung von Apple, gemäß der Datenschutzrichtlinie von Apple.';

  @override
  String get privacyOpenTitle => 'Open Source';

  @override
  String get privacyOpenBody =>
      'Jede Zeile von Red Panda ist öffentlich, so kann jede und jeder diese Versprechen prüfen.';

  @override
  String get privacyPolicyLink => 'Vollständige Datenschutzerklärung';

  @override
  String get privacySourceLink => 'Quellcode auf GitHub';
}
