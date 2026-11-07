import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Red Panda'**
  String get appTitle;

  /// No description provided for @swipeSnooze.
  ///
  /// In en, this message translates to:
  /// **'Snooze until tomorrow'**
  String get swipeSnooze;

  /// No description provided for @swipeSnoozeInfo.
  ///
  /// In en, this message translates to:
  /// **'Hides the item until tomorrow morning. Costs bamboo.'**
  String get swipeSnoozeInfo;

  /// No description provided for @swipePostpone.
  ///
  /// In en, this message translates to:
  /// **'Postpone deadline by a day'**
  String get swipePostpone;

  /// No description provided for @swipePostponeInfo.
  ///
  /// In en, this message translates to:
  /// **'Free while the deadline is far; costs bamboo when it is close.'**
  String get swipePostponeInfo;

  /// No description provided for @swipePin.
  ///
  /// In en, this message translates to:
  /// **'Pin to top'**
  String get swipePin;

  /// No description provided for @swipePinInfo.
  ///
  /// In en, this message translates to:
  /// **'Moves the item to the top of the list.'**
  String get swipePinInfo;

  /// No description provided for @swipeCategory.
  ///
  /// In en, this message translates to:
  /// **'Move to category'**
  String get swipeCategory;

  /// No description provided for @swipeCategoryInfo.
  ///
  /// In en, this message translates to:
  /// **'Pick a cloud for the item.'**
  String get swipeCategoryInfo;

  /// No description provided for @swipeDeadline.
  ///
  /// In en, this message translates to:
  /// **'Set deadline'**
  String get swipeDeadline;

  /// No description provided for @swipeDeadlineInfo.
  ///
  /// In en, this message translates to:
  /// **'Opens the days-from-now dial.'**
  String get swipeDeadlineInfo;

  /// No description provided for @swipeRemindLater.
  ///
  /// In en, this message translates to:
  /// **'Remind me later today'**
  String get swipeRemindLater;

  /// No description provided for @swipeRemindLaterInfo.
  ///
  /// In en, this message translates to:
  /// **'A one-off nudge in three hours.'**
  String get swipeRemindLaterInfo;

  /// No description provided for @swipeDuplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get swipeDuplicate;

  /// No description provided for @swipeDuplicateInfo.
  ///
  /// In en, this message translates to:
  /// **'Copies the item, handy for recurring chores.'**
  String get swipeDuplicateInfo;

  /// No description provided for @swipeBasket.
  ///
  /// In en, this message translates to:
  /// **'Put in leave basket'**
  String get swipeBasket;

  /// No description provided for @swipeBasketInfo.
  ///
  /// In en, this message translates to:
  /// **'Reminds you when you leave this place or your Wi-Fi.'**
  String get swipeBasketInfo;

  /// No description provided for @swipeShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get swipeShare;

  /// No description provided for @swipeShareInfo.
  ///
  /// In en, this message translates to:
  /// **'Shares the item as text.'**
  String get swipeShareInfo;

  /// No description provided for @nagOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get nagOff;

  /// No description provided for @nagGentle.
  ///
  /// In en, this message translates to:
  /// **'Gentle'**
  String get nagGentle;

  /// No description provided for @nagNormal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get nagNormal;

  /// No description provided for @nagPersistent.
  ///
  /// In en, this message translates to:
  /// **'Persistent'**
  String get nagPersistent;

  /// No description provided for @basketIn.
  ///
  /// In en, this message translates to:
  /// **'In the leave basket 🧺 The panda reminds you when you leave this place.'**
  String get basketIn;

  /// No description provided for @basketOut.
  ///
  /// In en, this message translates to:
  /// **'Out of the leave basket.'**
  String get basketOut;

  /// No description provided for @basketEmptyStatus.
  ///
  /// In en, this message translates to:
  /// **'The basket is empty. Drag items into it to be reminded about them when you leave.'**
  String get basketEmptyStatus;

  /// No description provided for @basketNeedsLocation.
  ///
  /// In en, this message translates to:
  /// **'Red Panda needs your location to notice when you leave. Allow it in Settings.'**
  String get basketNeedsLocation;

  /// No description provided for @basketWatching.
  ///
  /// In en, this message translates to:
  /// **'Watching'**
  String get basketWatching;

  /// No description provided for @basketWatchingSince.
  ///
  /// In en, this message translates to:
  /// **'Watching (since {time})'**
  String basketWatchingSince(String time);

  /// No description provided for @basketReasonPlace.
  ///
  /// In en, this message translates to:
  /// **'you get a reminder when you move more than {radius} m away.'**
  String basketReasonPlace(int radius);

  /// No description provided for @basketReasonWifi.
  ///
  /// In en, this message translates to:
  /// **'you get a reminder when your Wi-Fi drops.'**
  String get basketReasonWifi;

  /// No description provided for @basketReasonBoth.
  ///
  /// In en, this message translates to:
  /// **'you get a reminder when you move more than {radius} m away or your Wi-Fi drops.'**
  String basketReasonBoth(int radius);

  /// No description provided for @basketNotWatching.
  ///
  /// In en, this message translates to:
  /// **'Not watching right now. Tap \"Watch from here\" to start.'**
  String get basketNotWatching;

  /// No description provided for @basketSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'🧺 Leave basket · {count}'**
  String basketSheetTitle(int count);

  /// No description provided for @basketNeedsAlways.
  ///
  /// In en, this message translates to:
  /// **'To notice leaving while Red Panda is closed, set Location to \"Always\" in Settings.'**
  String get basketNeedsAlways;

  /// No description provided for @basketWatchHere.
  ///
  /// In en, this message translates to:
  /// **'Watch from here'**
  String get basketWatchHere;

  /// No description provided for @openSettings.
  ///
  /// In en, this message translates to:
  /// **'Open Settings'**
  String get openSettings;

  /// No description provided for @basketEmptyAction.
  ///
  /// In en, this message translates to:
  /// **'Empty the basket'**
  String get basketEmptyAction;

  /// No description provided for @basketWatchingHere.
  ///
  /// In en, this message translates to:
  /// **'Watching from here 📍'**
  String get basketWatchingHere;

  /// No description provided for @noLocation.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location.'**
  String get noLocation;

  /// No description provided for @streakPraise.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{1-day streak! The panda is proud.} other{{days}-day streak! The panda is proud.}}'**
  String streakPraise(int days);

  /// No description provided for @bambooEarned.
  ///
  /// In en, this message translates to:
  /// **'+{earned} 🎋 bamboo for the panda ({balance} in the stash)'**
  String bambooEarned(int earned, int balance);

  /// No description provided for @bambooFull.
  ///
  /// In en, this message translates to:
  /// **'The bamboo stash is full ({cap}). Snooze something, or keep going!'**
  String bambooFull(int cap);

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @wokenUp.
  ///
  /// In en, this message translates to:
  /// **'Woken up early.'**
  String get wokenUp;

  /// No description provided for @nudgeAt.
  ///
  /// In en, this message translates to:
  /// **'The panda will nudge you at {time}.'**
  String nudgeAt(String time);

  /// No description provided for @snoozeTooPoor.
  ///
  /// In en, this message translates to:
  /// **'Not enough bamboo to snooze (needs {cost}, you have {balance}). Finish a task to earn some 🎋'**
  String snoozeTooPoor(int cost, int balance);

  /// No description provided for @snoozed.
  ///
  /// In en, this message translates to:
  /// **'Snoozed until tomorrow · −{cost} 🎋'**
  String snoozed(int cost);

  /// No description provided for @postponeTooPoor.
  ///
  /// In en, this message translates to:
  /// **'Postponing this close to the deadline costs {cost} 🎋, and the stash is empty.'**
  String postponeTooPoor(int cost);

  /// No description provided for @deadlineMoved.
  ///
  /// In en, this message translates to:
  /// **'Deadline moved to {when}'**
  String deadlineMoved(String when);

  /// No description provided for @deadlineMovedCost.
  ///
  /// In en, this message translates to:
  /// **'Deadline moved to {when} · −{cost} 🎋'**
  String deadlineMovedCost(String when, int cost);

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @set.
  ///
  /// In en, this message translates to:
  /// **'Set'**
  String get set;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @noCloudsYet.
  ///
  /// In en, this message translates to:
  /// **'No clouds yet. Tap \"+ category\" next to the panda.'**
  String get noCloudsYet;

  /// No description provided for @noCategory.
  ///
  /// In en, this message translates to:
  /// **'No category'**
  String get noCategory;

  /// No description provided for @filedUnder.
  ///
  /// In en, this message translates to:
  /// **'Filed under {name} ☁️'**
  String filedUnder(String name);

  /// No description provided for @newCloud.
  ///
  /// In en, this message translates to:
  /// **'New category cloud'**
  String get newCloud;

  /// No description provided for @rename.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get rename;

  /// No description provided for @renameCloud.
  ///
  /// In en, this message translates to:
  /// **'Rename cloud'**
  String get renameCloud;

  /// No description provided for @removeCloud.
  ///
  /// In en, this message translates to:
  /// **'Remove cloud'**
  String get removeCloud;

  /// No description provided for @removeCloudInfo.
  ///
  /// In en, this message translates to:
  /// **'Its items stay, just without a category'**
  String get removeCloudInfo;

  /// No description provided for @cloudNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Home, Work, Shopping'**
  String get cloudNameHint;

  /// No description provided for @micNeeded.
  ///
  /// In en, this message translates to:
  /// **'Red Panda needs the microphone. Allow it in Settings > Red Panda.'**
  String get micNeeded;

  /// No description provided for @recordFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t start recording.'**
  String get recordFailed;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @closeSearch.
  ///
  /// In en, this message translates to:
  /// **'Close search'**
  String get closeSearch;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @newTextNote.
  ///
  /// In en, this message translates to:
  /// **'New text note'**
  String get newTextNote;

  /// No description provided for @onlyCategory.
  ///
  /// In en, this message translates to:
  /// **'Only {name}'**
  String onlyCategory(String name);

  /// No description provided for @onlyBasket.
  ///
  /// In en, this message translates to:
  /// **'Only the leave basket'**
  String get onlyBasket;

  /// No description provided for @emptyBasketList.
  ///
  /// In en, this message translates to:
  /// **'The leave basket is empty. Drag items onto the basket to be reminded about them when you leave.'**
  String get emptyBasketList;

  /// No description provided for @emptyCategoryDay.
  ///
  /// In en, this message translates to:
  /// **'Nothing in {name}. Drag an item onto its cloud, or tap the sun to see everything.'**
  String emptyCategoryDay(String name);

  /// No description provided for @emptyCategoryNight.
  ///
  /// In en, this message translates to:
  /// **'Nothing in {name}. Drag an item onto its cloud, or tap the moon to see everything.'**
  String emptyCategoryNight(String name);

  /// No description provided for @noNotes.
  ///
  /// In en, this message translates to:
  /// **'No notes yet. Capture one from the Lock Screen or the Action Button, or tap +.'**
  String get noNotes;

  /// No description provided for @hideSnoozed.
  ///
  /// In en, this message translates to:
  /// **'Hide snoozed'**
  String get hideSnoozed;

  /// No description provided for @showSnoozed.
  ///
  /// In en, this message translates to:
  /// **'{count} snoozed · show'**
  String showSnoozed(int count);

  /// No description provided for @undoCheck.
  ///
  /// In en, this message translates to:
  /// **'Undo check'**
  String get undoCheck;

  /// No description provided for @wakeUp.
  ///
  /// In en, this message translates to:
  /// **'Wake up'**
  String get wakeUp;

  /// No description provided for @streakChip.
  ///
  /// In en, this message translates to:
  /// **'🔥 {days}d'**
  String streakChip(int days);

  /// No description provided for @tickedToday.
  ///
  /// In en, this message translates to:
  /// **'✓ {count} today'**
  String tickedToday(int count);

  /// No description provided for @bambooTooltip.
  ///
  /// In en, this message translates to:
  /// **'Bamboo: earn it by finishing tasks, spend it on snoozes'**
  String get bambooTooltip;

  /// No description provided for @level.
  ///
  /// In en, this message translates to:
  /// **'Lv {level}'**
  String level(int level);

  /// No description provided for @pandaSadOverdue.
  ///
  /// In en, this message translates to:
  /// **'🥺 The panda is sad: {count} overdue'**
  String pandaSadOverdue(int count);

  /// No description provided for @dueTodayWatching.
  ///
  /// In en, this message translates to:
  /// **'⏰ {count} due today. The panda is watching.'**
  String dueTodayWatching(int count);

  /// No description provided for @recordVoice.
  ///
  /// In en, this message translates to:
  /// **'Record a voice note'**
  String get recordVoice;

  /// No description provided for @stopVoice.
  ///
  /// In en, this message translates to:
  /// **'Stop and save the voice note'**
  String get stopVoice;

  /// No description provided for @snoozedUntil.
  ///
  /// In en, this message translates to:
  /// **' · 💤 until {time}'**
  String snoozedUntil(String time);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @tickOff.
  ///
  /// In en, this message translates to:
  /// **'Tick off'**
  String get tickOff;

  /// No description provided for @inLeaveBasket.
  ///
  /// In en, this message translates to:
  /// **'In the leave basket'**
  String get inLeaveBasket;

  /// No description provided for @daysLate.
  ///
  /// In en, this message translates to:
  /// **'{days}d late'**
  String daysLate(int days);

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'today'**
  String get today;

  /// No description provided for @daysShort.
  ///
  /// In en, this message translates to:
  /// **'{days}d'**
  String daysShort(int days);

  /// No description provided for @dueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String dueOn(String date);

  /// No description provided for @dragHint.
  ///
  /// In en, this message translates to:
  /// **'Drag to reorder or onto a category cloud'**
  String get dragHint;

  /// No description provided for @noteHint.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteHint;

  /// No description provided for @newNoteHint.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get newNoteHint;

  /// No description provided for @deadline.
  ///
  /// In en, this message translates to:
  /// **'Deadline'**
  String get deadline;

  /// No description provided for @leaveBasket.
  ///
  /// In en, this message translates to:
  /// **'Leave basket'**
  String get leaveBasket;

  /// No description provided for @leaveBasketTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remind me when I leave this place'**
  String get leaveBasketTooltip;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @turnDial.
  ///
  /// In en, this message translates to:
  /// **'Turn the dial'**
  String get turnDial;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @cloudSemantics.
  ///
  /// In en, this message translates to:
  /// **'Category {name}, {count} open'**
  String cloudSemantics(String name, int count);

  /// No description provided for @cloudHintShowAll.
  ///
  /// In en, this message translates to:
  /// **'Double tap to show all items'**
  String get cloudHintShowAll;

  /// No description provided for @cloudHintOnly.
  ///
  /// In en, this message translates to:
  /// **'Double tap to show only this category'**
  String get cloudHintOnly;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add a category'**
  String get addCategory;

  /// No description provided for @plusCategory.
  ///
  /// In en, this message translates to:
  /// **'+ category'**
  String get plusCategory;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sun'**
  String get sun;

  /// No description provided for @moon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get moon;

  /// No description provided for @showsAllItems.
  ///
  /// In en, this message translates to:
  /// **'Shows all items'**
  String get showsAllItems;

  /// No description provided for @noDeadline.
  ///
  /// In en, this message translates to:
  /// **'no deadline'**
  String get noDeadline;

  /// No description provided for @tomorrow.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get tomorrow;

  /// No description provided for @inDays.
  ///
  /// In en, this message translates to:
  /// **'in {days} days'**
  String inDays(int days);

  /// No description provided for @noDate.
  ///
  /// In en, this message translates to:
  /// **'no date'**
  String get noDate;

  /// No description provided for @dayUnit.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, =1{day} other{days}}'**
  String dayUnit(int days);

  /// No description provided for @basketSemantics.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{Leave basket, 1 item} other{Leave basket, {count} items}}'**
  String basketSemantics(int count);

  /// No description provided for @basketWatchingSuffix.
  ///
  /// In en, this message translates to:
  /// **', watching'**
  String get basketWatchingSuffix;

  /// No description provided for @basketHint.
  ///
  /// In en, this message translates to:
  /// **'Drop items here to be reminded when you leave. Double tap to filter.'**
  String get basketHint;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
