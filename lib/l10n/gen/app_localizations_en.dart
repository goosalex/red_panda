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
  String get basketIn =>
      'In the leave basket 🧺 The panda reminds you when you leave this place.';

  @override
  String get basketOut => 'Out of the leave basket.';

  @override
  String get basketEmptyStatus =>
      'The basket is empty. Drag items into it to be reminded about them when you leave.';

  @override
  String get basketNeedsLocation =>
      'Red Panda needs your location to notice when you leave. Allow it in [Settings](location).';

  @override
  String get basketWatching => 'Watching';

  @override
  String basketWatchingSince(String time) {
    return 'Watching (since $time)';
  }

  @override
  String basketReasonPlace(int radius) {
    return 'you get a reminder when you move more than $radius m away.';
  }

  @override
  String get basketReasonWifi => 'you get a reminder when your Wi-Fi drops.';

  @override
  String basketReasonBoth(int radius) {
    return 'you get a reminder when you move more than $radius m away or your Wi-Fi drops.';
  }

  @override
  String get basketNotWatching =>
      'Not watching right now. Tap \"Watch from here\" to start.';

  @override
  String basketSheetTitle(int count) {
    return '🧺 Leave basket · $count';
  }

  @override
  String get basketNeedsAlways =>
      'To notice leaving while Red Panda is closed, set Location to \"Always\" in [Settings](location).';

  @override
  String get basketWatchHere => 'Watch from here';

  @override
  String get openSettings => 'Open Settings';

  @override
  String get basketEmptyAction => 'Empty the basket';

  @override
  String get basketWatchingHere => 'Watching from here 📍';

  @override
  String get noLocation => 'Couldn\'t get your location.';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days-day streak! The panda is proud.',
      one: '1-day streak! The panda is proud.',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return '+$earned 🎋 bamboo for the panda ($balance in the stash)';
  }

  @override
  String bambooFull(int cap) {
    return 'The bamboo stash is full ($cap). Snooze something, or keep going!';
  }

  @override
  String get deleted => 'Deleted';

  @override
  String get undo => 'Undo';

  @override
  String get wokenUp => 'Woken up early.';

  @override
  String nudgeAt(String time) {
    return 'The panda will nudge you at $time.';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'Not enough bamboo to snooze (needs $cost, you have $balance). Finish a task to earn some 🎋';
  }

  @override
  String snoozed(int cost) {
    return 'Snoozed until tomorrow · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return 'Postponing this close to the deadline costs $cost 🎋, and the stash is empty.';
  }

  @override
  String deadlineMoved(String when) {
    return 'Deadline moved to $when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return 'Deadline moved to $when · −$cost 🎋';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get set => 'Set';

  @override
  String get ok => 'OK';

  @override
  String get noCloudsYet =>
      'No clouds yet. Tap \"+ category\" next to the panda.';

  @override
  String get noCategory => 'No category';

  @override
  String filedUnder(String name) {
    return 'Filed under $name ☁️';
  }

  @override
  String get newCloud => 'New category cloud';

  @override
  String get rename => 'Rename';

  @override
  String get renameCloud => 'Rename cloud';

  @override
  String get removeCloud => 'Remove cloud';

  @override
  String get removeCloudInfo => 'Its items stay, just without a category';

  @override
  String get cloudNameHint => 'e.g. Home, Work, Shopping';

  @override
  String get micNeeded =>
      'Red Panda needs the microphone. Allow it in [Settings](microphone).';

  @override
  String get recordFailed => 'Couldn\'t start recording.';

  @override
  String get search => 'Search';

  @override
  String get closeSearch => 'Close search';

  @override
  String get settings => 'Settings';

  @override
  String get newTextNote => 'New text note';

  @override
  String onlyCategory(String name) {
    return 'Only $name';
  }

  @override
  String get onlyBasket => 'Only the leave basket';

  @override
  String get emptyBasketList =>
      'The leave basket is empty. Drag items onto the basket to be reminded about them when you leave.';

  @override
  String emptyCategoryDay(String name) {
    return 'Nothing in $name. Drag an item onto its cloud, or tap the sun to see everything.';
  }

  @override
  String emptyCategoryNight(String name) {
    return 'Nothing in $name. Drag an item onto its cloud, or tap the moon to see everything.';
  }

  @override
  String get noNotes =>
      'No notes yet. Capture one from the Lock Screen or the Action Button, or tap +.';

  @override
  String get noNotesPad =>
      'No notes yet. Capture one from the Lock Screen or Control Centre, or tap +.';

  @override
  String get hideSnoozed => 'Hide snoozed';

  @override
  String showSnoozed(int count) {
    return '$count snoozed · show';
  }

  @override
  String get undoCheck => 'Undo check';

  @override
  String get wakeUp => 'Wake up';

  @override
  String streakChip(int days) {
    return '🔥 ${days}d';
  }

  @override
  String tickedToday(int count) {
    return '✓ $count today';
  }

  @override
  String get bambooTooltip =>
      'Bamboo: earn it by finishing tasks, spend it on snoozes';

  @override
  String level(int level) {
    return 'Lv $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 The panda is sad: $count overdue';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ $count due today. The panda is watching.';
  }

  @override
  String get recordVoice => 'Record a voice note';

  @override
  String get stopVoice => 'Stop and save the voice note';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 until $time';
  }

  @override
  String get edit => 'Edit';

  @override
  String get done => 'Done';

  @override
  String get tickOff => 'Tick off';

  @override
  String get inLeaveBasket => 'In the leave basket';

  @override
  String daysLate(int days) {
    return '${days}d late';
  }

  @override
  String get today => 'today';

  @override
  String daysShort(int days) {
    return '${days}d';
  }

  @override
  String dueOn(String date) {
    return 'Due $date';
  }

  @override
  String get dragHint => 'Drag to reorder or onto a category cloud';

  @override
  String get noteHint => 'Note';

  @override
  String get newNoteHint => 'New note';

  @override
  String get deadline => 'Deadline';

  @override
  String get leaveBasket => 'Leave basket';

  @override
  String get leaveBasketTooltip => 'Remind me when I leave this place';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get turnDial => 'Turn the dial';

  @override
  String get clear => 'Clear';

  @override
  String cloudSemantics(String name, int count) {
    return 'Category $name, $count open';
  }

  @override
  String get cloudHintShowAll => 'Double tap to show all items';

  @override
  String get cloudHintOnly => 'Double tap to show only this category';

  @override
  String get addCategory => 'Add a category';

  @override
  String get plusCategory => '+ category';

  @override
  String get sun => 'Sun';

  @override
  String get moon => 'Moon';

  @override
  String get showsAllItems => 'Shows all items';

  @override
  String get noDeadline => 'no deadline';

  @override
  String get tomorrow => 'tomorrow';

  @override
  String inDays(int days) {
    return 'in $days days';
  }

  @override
  String get noDate => 'no date';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'days',
      one: 'day',
    );
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Leave basket, $count items',
      one: 'Leave basket, 1 item',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => ', watching';

  @override
  String get basketHint =>
      'Drop items here to be reminded when you leave. Double tap to filter.';

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
      'With \"While using\", iOS tells Red Panda nothing once it is closed, so the basket could only remind you while the app is open. [\"Always\"](location) lets iOS wake Red Panda the moment you leave.';

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
      '[Customise the Lock Screen](lockScreenWidget) and tap the widget area under the clock (or the line above it) to add the Red Panda widget with your next deadline. On the Home Screen, [long-press, tap Edit > Add Widget](homeScreenWidget) and search \"Red Panda\": its buttons add a note or show Panda\'s basket.';

  @override
  String get captureControlCentre => 'Control Centre';

  @override
  String get captureControlCentreHow =>
      'Open Control Centre, tap +, Add a Control, search \"Red Panda\".';

  @override
  String get captureActionButton => 'Action Button';

  @override
  String get captureActionButtonHow =>
      '[Settings > Action Button > Controls](actionButton), then choose Red Panda > Text note, Voice note or Show Panda\'s basket.';

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

  @override
  String get walkLocationTitle => 'Location: Always';

  @override
  String get walkMicrophoneTitle => 'Microphone & speech recognition';

  @override
  String get walkSiriTitle => 'Red Panda and Siri';

  @override
  String get walkActionButtonTitle => 'Red Panda on the Action Button';

  @override
  String get walkActionButtonNote =>
      'On your iPhone, keep swiping until you reach Controls.';

  @override
  String walkSemantics(String path) {
    return 'Animation of the way in Settings: $path';
  }

  @override
  String get walkLockScreenTitle => 'Red Panda on the Lock Screen';

  @override
  String get walkHomeScreenTitle => 'Red Panda on the Home Screen';

  @override
  String get walkLongPress => 'Long-press';

  @override
  String get settingsPrivacy => 'Privacy';

  @override
  String get settingsPrivacyValue => 'Nothing collected';

  @override
  String get privacyNothingTitle => 'Red Panda collects nothing';

  @override
  String get privacyNothingBody =>
      'No analytics, no advertising, no tracking and no account. Red Panda has no server of its own, so there is nowhere your data could go.';

  @override
  String get privacyNotesTitle => 'Your notes stay yours';

  @override
  String get privacyNotesBody =>
      'Notes and voice recordings are stored on this device. With iCloud sync on, they are copied to your own iCloud Drive, which only you can read.';

  @override
  String get privacyLocationTitle => 'Location only for the leave basket';

  @override
  String get privacyLocationBody =>
      'Red Panda never records where you go. It asks iOS once where the basket was filled, and iOS alone watches for you leaving. The location is never sent anywhere and never synced.';

  @override
  String get privacyVoiceTitle => 'Voice notes become text on your iPhone';

  @override
  String get privacyVoiceBody =>
      'Speech is recognised on the device wherever iOS supports it for your language. Otherwise iOS uses Apple\'s speech recognition, under Apple\'s privacy policy.';

  @override
  String get privacyOpenTitle => 'Open source';

  @override
  String get privacyOpenBody =>
      'Every line of Red Panda is public, so anyone can check these promises.';

  @override
  String get privacyPolicyLink => 'Full privacy policy';

  @override
  String get privacySourceLink => 'Source code on GitHub';
}
