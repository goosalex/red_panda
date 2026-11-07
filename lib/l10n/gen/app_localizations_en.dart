// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => 'Snooze until tomorrow';

  @override
  String get swipeSnoozeInfo =>
      'Hides the item until tomorrow morning. Costs bamboo.';

  @override
  String get swipePostpone => 'Postpone deadline by a day';

  @override
  String get swipePostponeInfo =>
      'Free while the deadline is far; costs bamboo when it is close.';

  @override
  String get swipePin => 'Pin to top';

  @override
  String get swipePinInfo => 'Moves the item to the top of the list.';

  @override
  String get swipeCategory => 'Move to category';

  @override
  String get swipeCategoryInfo => 'Pick a cloud for the item.';

  @override
  String get swipeDeadline => 'Set deadline';

  @override
  String get swipeDeadlineInfo => 'Opens the days-from-now dial.';

  @override
  String get swipeRemindLater => 'Remind me later today';

  @override
  String get swipeRemindLaterInfo => 'A one-off nudge in three hours.';

  @override
  String get swipeDuplicate => 'Duplicate';

  @override
  String get swipeDuplicateInfo =>
      'Copies the item, handy for recurring chores.';

  @override
  String get swipeBasket => 'Put in leave basket';

  @override
  String get swipeBasketInfo =>
      'Reminds you when you leave this place or your Wi-Fi.';

  @override
  String get swipeShare => 'Share';

  @override
  String get swipeShareInfo => 'Shares the item as text.';

  @override
  String get nagOff => 'Off';

  @override
  String get nagGentle => 'Gentle';

  @override
  String get nagNormal => 'Normal';

  @override
  String get nagPersistent => 'Persistent';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsHeaderList => 'List';

  @override
  String get settingsHeaderReminders => 'Reminders';

  @override
  String get settingsHeaderPanda => 'Panda';

  @override
  String get settingsCloudSync => 'iCloud sync';

  @override
  String get settingsCloudNote =>
      'Notes, voice notes, categories and bamboo sync through your iCloud Drive to every iPhone and iPad signed in to the same Apple Account. Settings stay on each device.';

  @override
  String get settingsOn => 'On';

  @override
  String get settingsOff => 'Off';

  @override
  String get settingsSwipeRight => 'Swipe right';

  @override
  String get settingsSwipeDrawerTitle => 'Swipe right on an item';

  @override
  String get settingsSwipeDrawerNote =>
      'Ticked-off items always un-tick; snoozed items wake up.';

  @override
  String get settingsNag => 'Sad panda reminders';

  @override
  String get settingsNagNote =>
      'Notifications and widgets nag you as deadlines come closer.';

  @override
  String get settingsQuietFrom => 'Quiet from';

  @override
  String get settingsQuietUntil => 'Quiet until';

  @override
  String get settingsLeaveBasket => 'Leave basket';

  @override
  String get settingsBambooRules => 'Bamboo rules';

  @override
  String settingsBambooMax(int cap) {
    return 'Max $cap';
  }

  @override
  String get bambooTitle => '🎋 Bamboo';

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
      other: '$freeDays days',
      one: '1 day',
    );
    return 'Every finished item feeds the panda $perCompletion 🎋 (+$earlyBonus when done before its deadline day). Snoozing costs $snoozeCost 🎋; postponing a deadline is free until $_temp0 before it, then costs $lateCost 🎋. The stash holds at most $cap.';
  }

  @override
  String get settingsQuickCapture => 'Quick capture';

  @override
  String get settingsQuickCaptureValue => 'Lock Screen, Siri…';

  @override
  String get settingsNews => 'News';

  @override
  String newsVersion(String version) {
    return 'Version $version';
  }

  @override
  String newsVersionNew(String version) {
    return 'Version $version · new';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => 'Not signed in';

  @override
  String get cloudSyncing => 'Syncing…';

  @override
  String get cloudDownloading => 'Downloading…';

  @override
  String get cloudFailed => 'Failed, retrying';

  @override
  String get basketTitle => '🧺 Leave basket';

  @override
  String get basketNote =>
      'Items in the basket remind you as soon as you leave the place where you put them in, or your Wi-Fi drops.';

  @override
  String get basketOnPlace => 'When I leave this place';

  @override
  String get basketRadius => 'Radius';

  @override
  String get basketRadiusTitle => 'Remind me when I am further away than';

  @override
  String get basketRadiusNote =>
      'iPhones place you to about 100 m, so a small radius may fire a little late.';

  @override
  String get basketOnWifi => 'When my Wi-Fi drops';

  @override
  String get basketLocationAccess => 'Location access';

  @override
  String get locationAlways => 'Always';

  @override
  String get locationWhileUsing => 'While using';

  @override
  String get locationNotAsked => 'Not asked yet';

  @override
  String get basketWhyAlways => 'Why \"Always\"?';

  @override
  String get basketNoTracking => 'No tracking';

  @override
  String get basketHeaderShortcuts => 'Shortcuts automations';

  @override
  String get basketShortcutsNote =>
      'Red Panda only notices a Wi-Fi drop while it is open or was just in use. A Shortcuts automation catches it any time, and can watch a fixed place like home.';

  @override
  String get automationWifi => 'When I leave a Wi-Fi';

  @override
  String get automationPlace => 'When I leave a place';

  @override
  String get automationSetUp => 'Set up';

  @override
  String get automationMine => 'My automations';

  @override
  String get shortcutsApp => 'Shortcuts';

  @override
  String get shortcutsOpen => 'Open Shortcuts';

  @override
  String get shortcutsRemindAction => 'Remind me of my leave basket';

  @override
  String get guideOpenShortcuts =>
      'Tap \"Open Shortcuts\" below: the New Automation list opens.';

  @override
  String get guideWifiScroll => 'Scroll down and tap Wi-Fi.';

  @override
  String get guideWifiNetwork =>
      'Choose your network, tick \"Leaves\" and untick \"Joins\".';

  @override
  String get guideRunImmediately => 'Pick \"Run Immediately\", then tap Next.';

  @override
  String get guidePlaceLeave =>
      'Tap Leave, then Location > Choose, and pick the place (e.g. home).';

  @override
  String guideAddAction(String action) {
    return 'Tap \"New Blank Automation\", then Add Action, search \"leave basket\" and pick \"$action\".';
  }

  @override
  String get guideDone =>
      'Tap Done. From now on the panda reminds you of your basket.';

  @override
  String get locationInfoTitle => 'Why \"Always\" location?';

  @override
  String get locationInfoLeaveTitle => 'Only to notice you leaving';

  @override
  String get locationInfoLeaveBody =>
      'With \"While using\", iOS tells Red Panda nothing once it is closed, so the basket could only remind you while the app is open. \"Always\" lets iOS wake Red Panda the moment you leave.';

  @override
  String get locationInfoBatteryTitle => 'No battery drain';

  @override
  String get locationInfoBatteryBody =>
      'Red Panda does not follow you. It asks iOS once for where you are and draws one circle around it. iOS watches that circle with the cell and Wi-Fi signals it uses anyway, and Red Panda sleeps until you cross the edge. Then the circle is removed.';

  @override
  String get locationInfoPrivacyTitle => 'Your location stays on your iPhone';

  @override
  String get locationInfoPrivacyBody =>
      'Red Panda has no server and sends your location nowhere. Only the circle\'s centre is kept, on this device, until the reminder fires. iCloud sync never includes it.';

  @override
  String get locationInfoWifiTitle => 'Wi-Fi needs no location';

  @override
  String get locationInfoWifiBody =>
      'The \"Wi-Fi drops\" trigger works without location access.';

  @override
  String get captureLockScreen => 'Lock Screen buttons';

  @override
  String get captureLockScreenHow =>
      'Long-press the Lock Screen, tap Customise > Lock Screen, tap a control slot at the bottom and pick Red Panda > Text note, Voice note or Show Panda\'s basket.';

  @override
  String get captureWidgets => 'Widgets';

  @override
  String get captureWidgetsHow =>
      'Customise the Lock Screen and tap the widget area under the clock (or the line above it) to add the Red Panda widget with your next deadline. On the Home Screen, long-press, tap Edit > Add Widget and search \"Red Panda\": its buttons add a note or show Panda\'s basket.';

  @override
  String get captureControlCentre => 'Control Centre';

  @override
  String get captureControlCentreHow =>
      'Open Control Centre, tap +, Add a Control, search \"Red Panda\".';

  @override
  String get captureActionButton => 'Action Button';

  @override
  String get captureActionButtonHow =>
      'Settings > Action Button > Controls, then choose Red Panda > Text note, Voice note or Show Panda\'s basket.';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      'Say \"Note with Red Panda\", \"Voice note with Red Panda\" or \"Show my Red Panda basket\".';

  @override
  String capturePreview(String spot) {
    return '$spot preview';
  }

  @override
  String get captureLinkMicrophone => 'Microphone & Speech access';

  @override
  String get captureLinkSiri => 'Siri & Search';

  @override
  String get wifi => 'Wi-Fi';
}
