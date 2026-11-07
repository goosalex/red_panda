// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => '明日までスヌーズ';

  @override
  String get swipeSnoozeInfo => '明日の朝まで項目を隠します。竹を使います。';

  @override
  String get swipePostpone => '期限を1日延ばす';

  @override
  String get swipePostponeInfo => '期限が先なら無料、近いと竹を使います。';

  @override
  String get swipePin => '一番上に固定';

  @override
  String get swipePinInfo => '項目をリストの一番上に移動します。';

  @override
  String get swipeCategory => 'カテゴリへ移動';

  @override
  String get swipeCategoryInfo => '項目の雲を選びます。';

  @override
  String get swipeDeadline => '期限を設定';

  @override
  String get swipeDeadlineInfo => '今日から何日後かのダイヤルを開きます。';

  @override
  String get swipeRemindLater => '今日あとで通知';

  @override
  String get swipeRemindLaterInfo => '3時間後に一度だけお知らせします。';

  @override
  String get swipeDuplicate => '複製';

  @override
  String get swipeDuplicateInfo => '項目をコピーします。繰り返しの用事に便利です。';

  @override
  String get swipeBasket => 'お出かけかごに入れる';

  @override
  String get swipeBasketInfo => 'この場所やWi-Fiを離れるときにお知らせします。';

  @override
  String get swipeShare => '共有';

  @override
  String get swipeShareInfo => '項目をテキストとして共有します。';

  @override
  String get nagOff => 'オフ';

  @override
  String get nagGentle => '控えめ';

  @override
  String get nagNormal => 'ふつう';

  @override
  String get nagPersistent => 'しつこく';
}
