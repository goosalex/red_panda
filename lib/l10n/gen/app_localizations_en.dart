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
      'Red Panda needs your location to notice when you leave. Allow it in Settings.';

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
      'To notice leaving while Red Panda is closed, set Location to \"Always\" in Settings.';

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
      'Red Panda needs the microphone. Allow it in Settings > Red Panda.';

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
}
