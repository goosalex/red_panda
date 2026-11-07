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
