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
      'مع \"أثناء استخدام التطبيق\"، iOS ما بيقول لـ Red Panda شي بس يتسكّر، فالسلّة ما فيها تذكّرك إلا والتطبيق مفتوح. \"دائمًا\" بتخلّي iOS يفيّق Red Panda أول ما تطلع.';

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
      'خصّص شاشة القفل وكبوس على محل الأدوات تحت الساعة (أو السطر اللي فوقها) لتضيف أداة Red Panda مع أقرب موعد عندك. على الشاشة الرئيسية، اضغط مطوّل، كبوس \"تعديل\" > \"إضافة أداة\" ودوّر على \"Red Panda\": أزرارها بتضيف ملاحظة أو بتفرجيك سلّة الباندا.';

  @override
  String get captureControlCentre => 'مركز التحكم';

  @override
  String get captureControlCentreHow =>
      'افتح مركز التحكم، كبوس +، \"إضافة عنصر تحكم\"، ودوّر على \"Red Panda\".';

  @override
  String get captureActionButton => 'زر الإجراءات';

  @override
  String get captureActionButtonHow =>
      'الإعدادات > زر الإجراءات > عناصر التحكم، وبعدين اختار Red Panda > ملاحظة نصية، ملاحظة صوتية أو فرجيني سلّة الباندا.';

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
}
