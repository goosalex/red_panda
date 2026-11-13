// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => 'أجّل لبكرا';

  @override
  String get swipeSnoozeInfo => 'بيخبّي الشغلة لبكرا الصبح. بتكلّف خيزران.';

  @override
  String get swipePostpone => 'أجّل الموعد يوم';

  @override
  String get swipePostponeInfo =>
      'ببلاش طالما الموعد بعيد، وبيكلّف خيزران لما يقرّب.';

  @override
  String get swipePin => 'ثبّت فوق';

  @override
  String get swipePinInfo => 'بينقل الشغلة لأول القائمة.';

  @override
  String get swipeCategory => 'انقل لتصنيف';

  @override
  String get swipeCategoryInfo => 'اختار غيمة للشغلة.';

  @override
  String get swipeDeadline => 'حطّ موعد';

  @override
  String get swipeDeadlineInfo => 'بيفتح دولاب الأيام من اليوم.';

  @override
  String get swipeRemindLater => 'ذكّرني بعدين اليوم';

  @override
  String get swipeRemindLaterInfo => 'تذكير مرة وحدة بعد تلت ساعات.';

  @override
  String get swipeDuplicate => 'اعمل نسخة';

  @override
  String get swipeDuplicateInfo => 'بينسخ الشغلة، منيح للشغلات اللي بتتكرر.';

  @override
  String get swipeBasket => 'حطّ بسلّة الطلعة';

  @override
  String get swipeBasketInfo => 'بيذكّرك لما تطلع من هالمحل أو من الواي فاي.';

  @override
  String get swipeShare => 'شارك';

  @override
  String get swipeShareInfo => 'بيشارك الشغلة كنص.';

  @override
  String get nagOff => 'مطفي';

  @override
  String get nagGentle => 'خفيف';

  @override
  String get nagNormal => 'عادي';

  @override
  String get nagPersistent => 'لحوح';

  @override
  String get basketIn =>
      'صارت بسلّة الطلعة 🧺 الباندا رح يذكّرك لما تطلع من هالمحل.';

  @override
  String get basketOut => 'طلعت من سلّة الطلعة.';

  @override
  String get basketEmptyStatus =>
      'السلّة فاضية. اسحب شغلات لجوّاها لتتذكّرها لما تطلع.';

  @override
  String get basketNeedsLocation =>
      'Red Panda بدّه موقعك ليعرف إيمتى طلعت. اسمحله من [الإعدادات](location).';

  @override
  String get basketWatching => 'عم راقب';

  @override
  String basketWatchingSince(String time) {
    return 'عم راقب (من الساعة $time)';
  }

  @override
  String basketReasonPlace(int radius) {
    return 'رح يوصلك تذكير لما تبعد أكتر من $radius م.';
  }

  @override
  String get basketReasonWifi => 'رح يوصلك تذكير لما ينقطع الواي فاي.';

  @override
  String basketReasonBoth(int radius) {
    return 'رح يوصلك تذكير لما تبعد أكتر من $radius م أو ينقطع الواي فاي.';
  }

  @override
  String get basketNotWatching =>
      'هلّق ما عم راقب. كبوس \"راقب من هون\" لتبلّش.';

  @override
  String basketSheetTitle(int count) {
    return '🧺 سلّة الطلعة · $count';
  }

  @override
  String get basketNeedsAlways =>
      'لحتى ينتبه Red Panda إنك طلعت وهو مسكّر، حطّ الموقع على \"دائمًا\" من [الإعدادات](location).';

  @override
  String get basketWatchHere => 'راقب من هون';

  @override
  String get openSettings => 'افتح الإعدادات';

  @override
  String get basketEmptyAction => 'فضّي السلّة';

  @override
  String get basketWatchingHere => 'عم راقب من هون 📍';

  @override
  String get noLocation => 'ما قدرت جيب موقعك.';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days يوم ورا بعض! الباندا فخور فيك.',
      few: '$days أيام ورا بعض! الباندا فخور فيك.',
      two: 'يومين ورا بعض! الباندا فخور فيك.',
      one: 'يوم ورا يوم! الباندا فخور فيك.',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return '+$earned 🎋 خيزران للباندا ($balance بالمخزن)';
  }

  @override
  String bambooFull(int cap) {
    return 'مخزن الخيزران مليان ($cap). أجّل شي، أو كفّي هيك!';
  }

  @override
  String get deleted => 'انمحت';

  @override
  String get undo => 'تراجع';

  @override
  String get wokenUp => 'فاق بكّير.';

  @override
  String nudgeAt(String time) {
    return 'الباندا رح ينكزك الساعة $time.';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'ما في خيزران كفاية لتأجّل (بدّك $cost، معك $balance). خلّص شغلة لتربح شوي 🎋';
  }

  @override
  String snoozed(int cost) {
    return 'تأجّلت لبكرا · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return 'التأجيل هالقد قريب من الموعد بيكلّف $cost 🎋، والمخزن فاضي.';
  }

  @override
  String deadlineMoved(String when) {
    return 'انتقل الموعد: $when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return 'انتقل الموعد: $when · −$cost 🎋';
  }

  @override
  String get cancel => 'إلغاء';

  @override
  String get set => 'تمام';

  @override
  String get ok => 'تمام';

  @override
  String get noCloudsYet => 'لسّا ما في غيوم. كبوس \"+ تصنيف\" جنب الباندا.';

  @override
  String get noCategory => 'بلا تصنيف';

  @override
  String filedUnder(String name) {
    return 'انحطّت تحت $name ☁️';
  }

  @override
  String get newCloud => 'غيمة تصنيف جديدة';

  @override
  String get rename => 'غيّر الاسم';

  @override
  String get renameCloud => 'غيّر اسم الغيمة';

  @override
  String get removeCloud => 'شيل الغيمة';

  @override
  String get removeCloudInfo => 'شغلاتها بتضلّ، بس بلا تصنيف';

  @override
  String get cloudNameHint => 'مثلاً: البيت، الشغل، المشتريات';

  @override
  String get micNeeded =>
      'Red Panda بدّه المايكروفون. اسمحله من [الإعدادات](microphone).';

  @override
  String get recordFailed => 'ما قدرت بلّش التسجيل.';

  @override
  String get search => 'دوّر';

  @override
  String get closeSearch => 'سكّر البحث';

  @override
  String get settings => 'الإعدادات';

  @override
  String get newTextNote => 'ملاحظة نصّية جديدة';

  @override
  String onlyCategory(String name) {
    return 'بس $name';
  }

  @override
  String get onlyBasket => 'بس سلّة الطلعة';

  @override
  String get emptyBasketList =>
      'سلّة الطلعة فاضية. اسحب شغلات عالسلّة لتتذكّرها لما تطلع.';

  @override
  String emptyCategoryDay(String name) {
    return 'ما في شي بـ$name. اسحب شغلة عالغيمة، أو كبوس عالشمس لتشوف كل شي.';
  }

  @override
  String emptyCategoryNight(String name) {
    return 'ما في شي بـ$name. اسحب شغلة عالغيمة، أو كبوس عالقمر لتشوف كل شي.';
  }

  @override
  String get noNotes =>
      'لسّا ما في ملاحظات. سجّل وحدة من شاشة القفل أو زر الإجراءات، أو كبوس +.';

  @override
  String get noNotesPad =>
      'لسّا ما في ملاحظات. سجّل وحدة من شاشة القفل أو مركز التحكم، أو كبوس +.';

  @override
  String get hideSnoozed => 'خبّي المؤجّلة';

  @override
  String showSnoozed(int count) {
    return '$count مؤجّلة · فرجيني';
  }

  @override
  String get undoCheck => 'شيل الصح';

  @override
  String get wakeUp => 'فيّق';

  @override
  String streakChip(int days) {
    return '🔥 $days يوم';
  }

  @override
  String tickedToday(int count) {
    return '✓ $count اليوم';
  }

  @override
  String get bambooTooltip =>
      'الخيزران: بتربحه لما تخلّص شغلات، وبتصرفه عالتأجيل';

  @override
  String level(int level) {
    return 'مستوى $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 الباندا زعلان: $count متأخرة';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ $count موعدها اليوم. الباندا عم يراقب.';
  }

  @override
  String get recordVoice => 'سجّل ملاحظة صوتية';

  @override
  String get stopVoice => 'وقّف واحفظ الملاحظة الصوتية';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 لـ$time';
  }

  @override
  String get edit => 'عدّل';

  @override
  String get done => 'خلصت';

  @override
  String get tickOff => 'حطّ صح';

  @override
  String get inLeaveBasket => 'بسلّة الطلعة';

  @override
  String daysLate(int days) {
    return 'متأخرة $days يوم';
  }

  @override
  String get today => 'اليوم';

  @override
  String daysShort(int days) {
    return '$days يوم';
  }

  @override
  String dueOn(String date) {
    return 'الموعد: $date';
  }

  @override
  String get dragHint => 'اسحب لترتّب أو لعند غيمة تصنيف';

  @override
  String get noteHint => 'ملاحظة';

  @override
  String get newNoteHint => 'ملاحظة جديدة';

  @override
  String get deadline => 'الموعد';

  @override
  String get leaveBasket => 'سلّة الطلعة';

  @override
  String get leaveBasketTooltip => 'ذكّرني لما إطلع من هالمحل';

  @override
  String get save => 'احفظ';

  @override
  String get add => 'زيد';

  @override
  String get turnDial => 'دوّر الدولاب';

  @override
  String get clear => 'امسح';

  @override
  String cloudSemantics(String name, int count) {
    return 'تصنيف $name، $count مفتوحة';
  }

  @override
  String get cloudHintShowAll => 'كبوس مرتين لتشوف كل الشغلات';

  @override
  String get cloudHintOnly => 'كبوس مرتين لتشوف بس هالتصنيف';

  @override
  String get addCategory => 'زيد تصنيف';

  @override
  String get plusCategory => '+ تصنيف';

  @override
  String get sun => 'الشمس';

  @override
  String get moon => 'القمر';

  @override
  String get showsAllItems => 'بيفرجيك كل الشغلات';

  @override
  String get noDeadline => 'بلا موعد';

  @override
  String get tomorrow => 'بكرا';

  @override
  String inDays(int days) {
    return 'بعد $days يوم';
  }

  @override
  String get noDate => 'بلا تاريخ';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'يوم',
      few: 'أيام',
      two: 'يومين',
      one: 'يوم',
    );
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'سلّة الطلعة، $count شغلة',
      few: 'سلّة الطلعة، $count شغلات',
      two: 'سلّة الطلعة، شغلتين',
      one: 'سلّة الطلعة، شغلة وحدة',
      zero: 'سلّة الطلعة، فاضية',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => '، عم راقب';

  @override
  String get basketHint =>
      'حطّ الشغلات هون لتتذكّرها لما تطلع. كبوس مرتين لتفلتر.';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsHeaderList => 'القائمة';

  @override
  String get settingsHeaderReminders => 'التذكيرات';

  @override
  String get settingsHeaderPanda => 'الباندا';

  @override
  String get settingsCloudSync => 'مزامنة iCloud';

  @override
  String get settingsCloudNote =>
      'الملاحظات والملاحظات الصوتية والفئات والخيزران بيتزامنوا عبر iCloud Drive على كل iPhone وiPad مسجّلين بنفس حساب Apple. الإعدادات بتضل على كل جهاز لحالو.';

  @override
  String get settingsOn => 'شغّال';

  @override
  String get settingsOff => 'مطفي';

  @override
  String get settingsSwipeRight => 'السحب لليمين';

  @override
  String get settingsSwipeDrawerTitle => 'اسحب شغلة لليمين';

  @override
  String get settingsSwipeDrawerNote =>
      'الشغلات المعلّمة دايمًا بتنشال علامتها، واللي مأجّلة بتفيق.';

  @override
  String get settingsNag => 'تذكيرات الباندا الزعلان';

  @override
  String get settingsNagNote =>
      'الإشعارات والأدوات بيزنّوا عليك كل ما قرّبت المواعيد.';

  @override
  String get settingsQuietFrom => 'هدوء من';

  @override
  String get settingsQuietUntil => 'هدوء لحد';

  @override
  String get settingsLeaveBasket => 'سلّة الطلعة';

  @override
  String get settingsBambooRules => 'قواعد الخيزران';

  @override
  String settingsBambooMax(int cap) {
    return 'الأقصى $cap';
  }

  @override
  String get bambooTitle => '🎋 خيزران';

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
      other: '$freeDays يوم',
      many: '$freeDays يوم',
      few: '$freeDays أيام',
      two: 'يومين',
      one: 'يوم واحد',
      zero: '$freeDays يوم',
    );
    return 'كل شغلة بتخلّصها بتطعمي الباندا $perCompletion 🎋 (+$earlyBonus إذا خلصت قبل يوم الموعد). التأجيل لبكرا بيكلّف $snoozeCost 🎋، وتأجيل الموعد ببلاش لحد $_temp0 قبلو، وبعدها بيكلّف $lateCost 🎋. المخزون بيساع $cap بالأكتر.';
  }

  @override
  String get settingsQuickCapture => 'تسجيل سريع';

  @override
  String get settingsQuickCaptureValue => 'شاشة القفل، Siri…';

  @override
  String get settingsNews => 'شو الجديد';

  @override
  String newsVersion(String version) {
    return 'النسخة $version';
  }

  @override
  String newsVersionNew(String version) {
    return 'النسخة $version · جديد';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => 'مش مسجّل دخول';

  @override
  String get cloudSyncing => 'عم يتزامن…';

  @override
  String get cloudDownloading => 'عم ينزّل…';

  @override
  String get cloudFailed => 'فشل، عم يجرّب كمان مرة';

  @override
  String get basketTitle => '🧺 سلّة الطلعة';

  @override
  String get basketNote =>
      'الشغلات اللي بالسلّة بتذكّرك أول ما تطلع من المحل اللي حطّيتها فيه، أو ينقطع الواي فاي.';

  @override
  String get basketOnPlace => 'لما إطلع من هالمحل';

  @override
  String get basketRadius => 'المسافة';

  @override
  String get basketRadiusTitle => 'ذكّرني لما صير أبعد من';

  @override
  String get basketRadiusNote =>
      'الـ iPhone بيعرف وينك بدقة حوالي 100 متر، فإذا المسافة زغيرة ممكن التذكير يتأخر شوي.';

  @override
  String get basketOnWifi => 'لما ينقطع الواي فاي';

  @override
  String get basketLocationAccess => 'الوصول للموقع';

  @override
  String get locationAlways => 'دائمًا';

  @override
  String get locationWhileUsing => 'أثناء الاستخدام';

  @override
  String get locationNotAsked => 'لسا ما انطلب';

  @override
  String get basketWhyAlways => 'ليش \"دائمًا\"؟';

  @override
  String get basketNoTracking => 'بلا تتبّع';

  @override
  String get basketHeaderShortcuts => 'أتمتة الاختصارات';

  @override
  String get basketShortcutsNote =>
      'Red Panda بينتبه إنو الواي فاي انقطع بس وهو مفتوح أو إذا لسا مستعملو. أتمتة بالاختصارات بتلقطو بأي وقت، وفيها تراقب محل ثابت متل البيت.';

  @override
  String get automationWifi => 'لما إطلع من شبكة واي فاي';

  @override
  String get automationPlace => 'لما إطلع من محل';

  @override
  String get automationSetUp => 'ظبّط';

  @override
  String get automationMine => 'الأتمتة تبعي';

  @override
  String get shortcutsApp => 'الاختصارات';

  @override
  String get shortcutsOpen => 'افتح الاختصارات';

  @override
  String get shortcutsRemindAction => 'ذكّرني بسلّة الطلعة';

  @override
  String get guideOpenShortcuts =>
      'كبوس \"افتح الاختصارات\" تحت: بتفتح قائمة \"أتمتة جديدة\".';

  @override
  String get guideWifiScroll => 'انزل لتحت وكبوس على Wi-Fi.';

  @override
  String get guideWifiNetwork =>
      'اختار الشبكة تبعك، علّم على \"قطع الاتصال\" وشيل العلامة عن \"الاتصال\".';

  @override
  String get guideRunImmediately =>
      'اختار \"تشغيل فورًا\"، وبعدين كبوس \"التالي\".';

  @override
  String get guidePlaceLeave =>
      'كبوس \"مغادرة\"، وبعدين \"الموقع\" > \"اختيار\"، واختار المحل (متل البيت).';

  @override
  String guideAddAction(String action) {
    return 'كبوس \"أتمتة فارغة جديدة\"، وبعدين \"إضافة إجراء\"، دوّر على \"سلّة الطلعة\" واختار \"$action\".';
  }

  @override
  String get guideDone => 'كبوس \"تم\". من هلق ورايح الباندا بيذكّرك بسلّتك.';

  @override
  String get locationInfoTitle => 'ليش الموقع \"دائمًا\"؟';

  @override
  String get locationInfoLeaveTitle => 'بس لينتبه إنك طلعت';

  @override
  String get locationInfoLeaveBody =>
      'مع \"أثناء استخدام التطبيق\"، iOS ما بيقول لـ Red Panda شي بس يتسكّر، فالسلّة ما فيها تذكّرك إلا والتطبيق مفتوح. [\"دائمًا\"](location) بتخلّي iOS يفيّق Red Panda أول ما تطلع.';

  @override
  String get locationInfoBatteryTitle => 'ما بياكل بطارية';

  @override
  String get locationInfoBatteryBody =>
      'Red Panda ما بيلحقك. بيسأل iOS مرة وحدة وينك وبيرسم دايرة حواليك. iOS بيراقب هالدايرة بإشارات الخلوي والواي فاي اللي بيستعملها أصلًا، وRed Panda بينام لحد ما تقطع الحد. بعدين بتنشال الدايرة.';

  @override
  String get locationInfoPrivacyTitle => 'موقعك بيضل على الـ iPhone تبعك';

  @override
  String get locationInfoPrivacyBody =>
      'Red Panda ما عندو سيرفر وما بيبعت موقعك لمحل. بس نص الدايرة بينحفظ، على هالجهاز، لحد ما يطلع التذكير. مزامنة iCloud ما بتاخدو أبدًا.';

  @override
  String get locationInfoWifiTitle => 'الواي فاي ما بدو موقع';

  @override
  String get locationInfoWifiBody =>
      '\"لما ينقطع الواي فاي\" بيشتغل بلا الوصول للموقع.';

  @override
  String get captureLockScreen => 'أزرار شاشة القفل';

  @override
  String get captureLockScreenHow =>
      'اضغط مطوّل على شاشة القفل، كبوس \"تخصيص\" > \"شاشة القفل\"، كبوس على محل تحكّم تحت واختار Red Panda > ملاحظة نصية، ملاحظة صوتية أو فرجيني سلّة الباندا.';

  @override
  String get captureWidgets => 'الأدوات';

  @override
  String get captureWidgetsHow =>
      '[خصّص شاشة القفل](lockScreenWidget) وكبوس على محل الأدوات تحت الساعة (أو السطر اللي فوقها) لتضيف أداة Red Panda مع أقرب موعد عندك. على الشاشة الرئيسية، [اضغط مطوّل، كبوس \"تعديل\" > \"إضافة أداة\"](homeScreenWidget) ودوّر على \"Red Panda\": أزرارها بتضيف ملاحظة أو بتفرجيك سلّة الباندا.';

  @override
  String get captureControlCentre => 'مركز التحكم';

  @override
  String get captureControlCentreHow =>
      'افتح مركز التحكم، كبوس +، \"إضافة عنصر تحكم\"، ودوّر على \"Red Panda\".';

  @override
  String get captureActionButton => 'زر الإجراءات';

  @override
  String get captureActionButtonHow =>
      '[الإعدادات > زر الإجراءات > عناصر التحكم](actionButton)، وبعدين اختار Red Panda > ملاحظة نصية، ملاحظة صوتية أو فرجيني سلّة الباندا.';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      'قول \"ملاحظة مع Red Panda\"، \"ملاحظة صوتية مع Red Panda\" أو \"فرجيني سلّة Red Panda\".';

  @override
  String capturePreview(String spot) {
    return 'معاينة $spot';
  }

  @override
  String get captureLinkMicrophone => 'الميكروفون والتعرّف على الكلام';

  @override
  String get captureLinkSiri => 'Siri والبحث';

  @override
  String get wifi => 'Wi-Fi';

  @override
  String get walkLocationTitle => 'الموقع: دائمًا';

  @override
  String get walkMicrophoneTitle => 'المايكروفون والتعرّف على الكلام';

  @override
  String get walkSiriTitle => 'Red Panda وSiri';

  @override
  String get walkActionButtonTitle => 'Red Panda على زر الإجراءات';

  @override
  String get walkActionButtonNote =>
      'عالآيفون، ضلّك اسحب لحتى توصل لعناصر التحكم.';

  @override
  String walkSemantics(String path) {
    return 'رسوم متحركة للطريق بالإعدادات: $path';
  }

  @override
  String get walkLockScreenTitle => 'Red Panda على شاشة القفل';

  @override
  String get walkHomeScreenTitle => 'Red Panda على الشاشة الرئيسية';

  @override
  String get walkLongPress => 'ضغط مطوّل';

  @override
  String get settingsPrivacy => 'الخصوصية';

  @override
  String get settingsPrivacyValue => 'ما في جمع بيانات';

  @override
  String get privacyNothingTitle => 'Red Panda ما بيجمع ولا شي';

  @override
  String get privacyNothingBody =>
      'ما في تحليلات ولا إعلانات ولا تتبّع ولا حساب. Red Panda ما إلو سيرفر خاص فيه، فبياناتك ما إلها وين تروح.';

  @override
  String get privacyNotesTitle => 'ملاحظاتك بتضل إلك';

  @override
  String get privacyNotesBody =>
      'الملاحظات والتسجيلات الصوتية بتنحفظ على هالجهاز. إذا شغّلت مزامنة iCloud، بتنسخ على iCloud Drive تبعك، وما حدا بيقدر يقراها غيرك.';

  @override
  String get privacyLocationTitle => 'الموقع بس لسلّة الطلعة';

  @override
  String get privacyLocationBody =>
      'Red Panda أبداً ما بيسجّل وين بتروح. بيسأل iOS مرة وحدة وين تعبّت السلة، و iOS لحالو بينتبه إذا طلعت. الموقع ما بينبعت لمكان وما بيتزامن أبداً.';

  @override
  String get privacyVoiceTitle => 'الملاحظات الصوتية بتصير نص على الآيفون تبعك';

  @override
  String get privacyVoiceBody =>
      'الكلام بيتعرّف عليه على الجهاز إذا iOS بيدعم هالشي للغتك. غير هيك، iOS بيستعمل التعرّف على الكلام من Apple، حسب سياسة الخصوصية تبع Apple.';

  @override
  String get privacyOpenTitle => 'مفتوح المصدر';

  @override
  String get privacyOpenBody =>
      'كل سطر من Red Panda منشور، فأي حدا فيه يتأكد من هالوعود.';

  @override
  String get privacyPolicyLink => 'سياسة الخصوصية كاملة';

  @override
  String get privacySourceLink => 'الكود المصدري على GitHub';
}
