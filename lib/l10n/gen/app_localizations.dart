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

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsHeaderList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get settingsHeaderList;

  /// No description provided for @settingsHeaderReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsHeaderReminders;

  /// No description provided for @settingsHeaderPanda.
  ///
  /// In en, this message translates to:
  /// **'Panda'**
  String get settingsHeaderPanda;

  /// No description provided for @settingsCloudSync.
  ///
  /// In en, this message translates to:
  /// **'iCloud sync'**
  String get settingsCloudSync;

  /// No description provided for @settingsCloudNote.
  ///
  /// In en, this message translates to:
  /// **'Notes, voice notes, categories and bamboo sync through your iCloud Drive to every iPhone and iPad signed in to the same Apple Account. Settings stay on each device.'**
  String get settingsCloudNote;

  /// No description provided for @settingsOn.
  ///
  /// In en, this message translates to:
  /// **'On'**
  String get settingsOn;

  /// No description provided for @settingsOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get settingsOff;

  /// No description provided for @settingsSwipeRight.
  ///
  /// In en, this message translates to:
  /// **'Swipe right'**
  String get settingsSwipeRight;

  /// No description provided for @settingsSwipeDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Swipe right on an item'**
  String get settingsSwipeDrawerTitle;

  /// No description provided for @settingsSwipeDrawerNote.
  ///
  /// In en, this message translates to:
  /// **'Ticked-off items always un-tick; snoozed items wake up.'**
  String get settingsSwipeDrawerNote;

  /// No description provided for @settingsNag.
  ///
  /// In en, this message translates to:
  /// **'Sad panda reminders'**
  String get settingsNag;

  /// No description provided for @settingsNagNote.
  ///
  /// In en, this message translates to:
  /// **'Notifications and widgets nag you as deadlines come closer.'**
  String get settingsNagNote;

  /// No description provided for @settingsQuietFrom.
  ///
  /// In en, this message translates to:
  /// **'Quiet from'**
  String get settingsQuietFrom;

  /// No description provided for @settingsQuietUntil.
  ///
  /// In en, this message translates to:
  /// **'Quiet until'**
  String get settingsQuietUntil;

  /// No description provided for @settingsLeaveBasket.
  ///
  /// In en, this message translates to:
  /// **'Leave basket'**
  String get settingsLeaveBasket;

  /// No description provided for @settingsBambooRules.
  ///
  /// In en, this message translates to:
  /// **'Bamboo rules'**
  String get settingsBambooRules;

  /// No description provided for @settingsBambooMax.
  ///
  /// In en, this message translates to:
  /// **'Max {cap}'**
  String settingsBambooMax(int cap);

  /// No description provided for @bambooTitle.
  ///
  /// In en, this message translates to:
  /// **'🎋 Bamboo'**
  String get bambooTitle;

  /// No description provided for @bambooRules.
  ///
  /// In en, this message translates to:
  /// **'Every finished item feeds the panda {perCompletion} 🎋 (+{earlyBonus} when done before its deadline day). Snoozing costs {snoozeCost} 🎋; postponing a deadline is free until {freeDays, plural, =1{1 day} other{{freeDays} days}} before it, then costs {lateCost} 🎋. The stash holds at most {cap}.'**
  String bambooRules(
    int perCompletion,
    int earlyBonus,
    int snoozeCost,
    int freeDays,
    int lateCost,
    int cap,
  );

  /// No description provided for @settingsQuickCapture.
  ///
  /// In en, this message translates to:
  /// **'Quick capture'**
  String get settingsQuickCapture;

  /// No description provided for @settingsQuickCaptureValue.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen, Siri…'**
  String get settingsQuickCaptureValue;

  /// No description provided for @settingsNews.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get settingsNews;

  /// No description provided for @newsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String newsVersion(String version);

  /// No description provided for @newsVersionNew.
  ///
  /// In en, this message translates to:
  /// **'Version {version} · new'**
  String newsVersionNew(String version);

  /// No description provided for @newsPr.
  ///
  /// In en, this message translates to:
  /// **'PR #{pr}'**
  String newsPr(int pr);

  /// No description provided for @cloudNotSignedIn.
  ///
  /// In en, this message translates to:
  /// **'Not signed in'**
  String get cloudNotSignedIn;

  /// No description provided for @cloudSyncing.
  ///
  /// In en, this message translates to:
  /// **'Syncing…'**
  String get cloudSyncing;

  /// No description provided for @cloudDownloading.
  ///
  /// In en, this message translates to:
  /// **'Downloading…'**
  String get cloudDownloading;

  /// No description provided for @cloudFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed, retrying'**
  String get cloudFailed;

  /// No description provided for @basketTitle.
  ///
  /// In en, this message translates to:
  /// **'🧺 Leave basket'**
  String get basketTitle;

  /// No description provided for @basketNote.
  ///
  /// In en, this message translates to:
  /// **'Items in the basket remind you as soon as you leave the place where you put them in, or your Wi-Fi drops.'**
  String get basketNote;

  /// No description provided for @basketOnPlace.
  ///
  /// In en, this message translates to:
  /// **'When I leave this place'**
  String get basketOnPlace;

  /// No description provided for @basketRadius.
  ///
  /// In en, this message translates to:
  /// **'Radius'**
  String get basketRadius;

  /// No description provided for @basketRadiusTitle.
  ///
  /// In en, this message translates to:
  /// **'Remind me when I am further away than'**
  String get basketRadiusTitle;

  /// No description provided for @basketRadiusNote.
  ///
  /// In en, this message translates to:
  /// **'iPhones place you to about 100 m, so a small radius may fire a little late.'**
  String get basketRadiusNote;

  /// No description provided for @basketOnWifi.
  ///
  /// In en, this message translates to:
  /// **'When my Wi-Fi drops'**
  String get basketOnWifi;

  /// No description provided for @basketLocationAccess.
  ///
  /// In en, this message translates to:
  /// **'Location access'**
  String get basketLocationAccess;

  /// No description provided for @locationAlways.
  ///
  /// In en, this message translates to:
  /// **'Always'**
  String get locationAlways;

  /// No description provided for @locationWhileUsing.
  ///
  /// In en, this message translates to:
  /// **'While using'**
  String get locationWhileUsing;

  /// No description provided for @locationNotAsked.
  ///
  /// In en, this message translates to:
  /// **'Not asked yet'**
  String get locationNotAsked;

  /// No description provided for @basketWhyAlways.
  ///
  /// In en, this message translates to:
  /// **'Why \"Always\"?'**
  String get basketWhyAlways;

  /// No description provided for @basketNoTracking.
  ///
  /// In en, this message translates to:
  /// **'No tracking'**
  String get basketNoTracking;

  /// No description provided for @basketHeaderShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts automations'**
  String get basketHeaderShortcuts;

  /// No description provided for @basketShortcutsNote.
  ///
  /// In en, this message translates to:
  /// **'Red Panda only notices a Wi-Fi drop while it is open or was just in use. A Shortcuts automation catches it any time, and can watch a fixed place like home.'**
  String get basketShortcutsNote;

  /// No description provided for @automationWifi.
  ///
  /// In en, this message translates to:
  /// **'When I leave a Wi-Fi'**
  String get automationWifi;

  /// No description provided for @automationPlace.
  ///
  /// In en, this message translates to:
  /// **'When I leave a place'**
  String get automationPlace;

  /// No description provided for @automationSetUp.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get automationSetUp;

  /// No description provided for @automationMine.
  ///
  /// In en, this message translates to:
  /// **'My automations'**
  String get automationMine;

  /// No description provided for @shortcutsApp.
  ///
  /// In en, this message translates to:
  /// **'Shortcuts'**
  String get shortcutsApp;

  /// No description provided for @shortcutsOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Shortcuts'**
  String get shortcutsOpen;

  /// No description provided for @shortcutsRemindAction.
  ///
  /// In en, this message translates to:
  /// **'Remind me of my leave basket'**
  String get shortcutsRemindAction;

  /// No description provided for @guideOpenShortcuts.
  ///
  /// In en, this message translates to:
  /// **'Tap \"Open Shortcuts\" below: the New Automation list opens.'**
  String get guideOpenShortcuts;

  /// No description provided for @guideWifiScroll.
  ///
  /// In en, this message translates to:
  /// **'Scroll down and tap Wi-Fi.'**
  String get guideWifiScroll;

  /// No description provided for @guideWifiNetwork.
  ///
  /// In en, this message translates to:
  /// **'Choose your network, tick \"Leaves\" and untick \"Joins\".'**
  String get guideWifiNetwork;

  /// No description provided for @guideRunImmediately.
  ///
  /// In en, this message translates to:
  /// **'Pick \"Run Immediately\", then tap Next.'**
  String get guideRunImmediately;

  /// No description provided for @guidePlaceLeave.
  ///
  /// In en, this message translates to:
  /// **'Tap Leave, then Location > Choose, and pick the place (e.g. home).'**
  String get guidePlaceLeave;

  /// No description provided for @guideAddAction.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New Blank Automation\", then Add Action, search \"leave basket\" and pick \"{action}\".'**
  String guideAddAction(String action);

  /// No description provided for @guideDone.
  ///
  /// In en, this message translates to:
  /// **'Tap Done. From now on the panda reminds you of your basket.'**
  String get guideDone;

  /// No description provided for @locationInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Why \"Always\" location?'**
  String get locationInfoTitle;

  /// No description provided for @locationInfoLeaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Only to notice you leaving'**
  String get locationInfoLeaveTitle;

  /// No description provided for @locationInfoLeaveBody.
  ///
  /// In en, this message translates to:
  /// **'With \"While using\", iOS tells Red Panda nothing once it is closed, so the basket could only remind you while the app is open. \"Always\" lets iOS wake Red Panda the moment you leave.'**
  String get locationInfoLeaveBody;

  /// No description provided for @locationInfoBatteryTitle.
  ///
  /// In en, this message translates to:
  /// **'No battery drain'**
  String get locationInfoBatteryTitle;

  /// No description provided for @locationInfoBatteryBody.
  ///
  /// In en, this message translates to:
  /// **'Red Panda does not follow you. It asks iOS once for where you are and draws one circle around it. iOS watches that circle with the cell and Wi-Fi signals it uses anyway, and Red Panda sleeps until you cross the edge. Then the circle is removed.'**
  String get locationInfoBatteryBody;

  /// No description provided for @locationInfoPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your location stays on your iPhone'**
  String get locationInfoPrivacyTitle;

  /// No description provided for @locationInfoPrivacyBody.
  ///
  /// In en, this message translates to:
  /// **'Red Panda has no server and sends your location nowhere. Only the circle\'s centre is kept, on this device, until the reminder fires. iCloud sync never includes it.'**
  String get locationInfoPrivacyBody;

  /// No description provided for @locationInfoWifiTitle.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi needs no location'**
  String get locationInfoWifiTitle;

  /// No description provided for @locationInfoWifiBody.
  ///
  /// In en, this message translates to:
  /// **'The \"Wi-Fi drops\" trigger works without location access.'**
  String get locationInfoWifiBody;

  /// No description provided for @captureLockScreen.
  ///
  /// In en, this message translates to:
  /// **'Lock Screen buttons'**
  String get captureLockScreen;

  /// No description provided for @captureLockScreenHow.
  ///
  /// In en, this message translates to:
  /// **'Long-press the Lock Screen, tap Customise > Lock Screen, tap a control slot at the bottom and pick Red Panda > Text note, Voice note or Show Panda\'s basket.'**
  String get captureLockScreenHow;

  /// No description provided for @captureWidgets.
  ///
  /// In en, this message translates to:
  /// **'Widgets'**
  String get captureWidgets;

  /// No description provided for @captureWidgetsHow.
  ///
  /// In en, this message translates to:
  /// **'Customise the Lock Screen and tap the widget area under the clock (or the line above it) to add the Red Panda widget with your next deadline. On the Home Screen, long-press, tap Edit > Add Widget and search \"Red Panda\": its buttons add a note or show Panda\'s basket.'**
  String get captureWidgetsHow;

  /// No description provided for @captureControlCentre.
  ///
  /// In en, this message translates to:
  /// **'Control Centre'**
  String get captureControlCentre;

  /// No description provided for @captureControlCentreHow.
  ///
  /// In en, this message translates to:
  /// **'Open Control Centre, tap +, Add a Control, search \"Red Panda\".'**
  String get captureControlCentreHow;

  /// No description provided for @captureActionButton.
  ///
  /// In en, this message translates to:
  /// **'Action Button'**
  String get captureActionButton;

  /// No description provided for @captureActionButtonHow.
  ///
  /// In en, this message translates to:
  /// **'Settings > Action Button > Controls, then choose Red Panda > Text note, Voice note or Show Panda\'s basket.'**
  String get captureActionButtonHow;

  /// No description provided for @captureSiri.
  ///
  /// In en, this message translates to:
  /// **'Siri'**
  String get captureSiri;

  /// No description provided for @captureSiriHow.
  ///
  /// In en, this message translates to:
  /// **'Say \"Note with Red Panda\", \"Voice note with Red Panda\" or \"Show my Red Panda basket\".'**
  String get captureSiriHow;

  /// No description provided for @capturePreview.
  ///
  /// In en, this message translates to:
  /// **'{spot} preview'**
  String capturePreview(String spot);

  /// No description provided for @captureLinkMicrophone.
  ///
  /// In en, this message translates to:
  /// **'Microphone & Speech access'**
  String get captureLinkMicrophone;

  /// No description provided for @captureLinkSiri.
  ///
  /// In en, this message translates to:
  /// **'Siri & Search'**
  String get captureLinkSiri;

  /// No description provided for @wifi.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi'**
  String get wifi;
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
