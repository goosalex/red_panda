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
}
