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
      'Red Panda بدّه موقعك ليعرف إيمتى طلعت. اسمحله من الإعدادات.';

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
      'لحتى ينتبه Red Panda إنك طلعت وهو مسكّر، حطّ الموقع على \"دائماً\" من الإعدادات.';

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
      'Red Panda بدّه المايكروفون. اسمحله من الإعدادات > Red Panda.';

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
}
