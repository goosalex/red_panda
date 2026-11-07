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
}
