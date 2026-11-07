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

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsHeaderList => 'リスト';

  @override
  String get settingsHeaderReminders => 'リマインダー';

  @override
  String get settingsHeaderPanda => 'パンダ';

  @override
  String get settingsCloudSync => 'iCloud同期';

  @override
  String get settingsCloudNote =>
      'メモ、ボイスメモ、カテゴリ、竹は、同じAppleアカウントでサインインしているすべてのiPhoneとiPadにiCloud Drive経由で同期されます。設定は各デバイスに残ります。';

  @override
  String get settingsOn => 'オン';

  @override
  String get settingsOff => 'オフ';

  @override
  String get settingsSwipeRight => '右にスワイプ';

  @override
  String get settingsSwipeDrawerTitle => '項目を右にスワイプ';

  @override
  String get settingsSwipeDrawerNote => 'チェック済みの項目はいつでもチェックが外れ、スヌーズ中の項目は起きます。';

  @override
  String get settingsNag => 'しょんぼりパンダのリマインダー';

  @override
  String get settingsNagNote => '期限が近づくと、通知とウィジェットでせかします。';

  @override
  String get settingsQuietFrom => 'おやすみ開始';

  @override
  String get settingsQuietUntil => 'おやすみ終了';

  @override
  String get settingsLeaveBasket => 'お出かけかご';

  @override
  String get settingsBambooRules => '竹のルール';

  @override
  String settingsBambooMax(int cap) {
    return '最大$cap';
  }

  @override
  String get bambooTitle => '🎋 竹';

  @override
  String bambooRules(
    int perCompletion,
    int earlyBonus,
    int snoozeCost,
    int freeDays,
    int lateCost,
    int cap,
  ) {
    return '項目を1つ終えるごとにパンダに$perCompletion 🎋をあげます（期限日より前なら+$earlyBonus）。スヌーズは$snoozeCost 🎋かかります。期限の延期は$freeDays日前までは無料で、それ以降は$lateCost 🎋かかります。たくわえは最大$capです。';
  }

  @override
  String get settingsQuickCapture => 'クイックキャプチャ';

  @override
  String get settingsQuickCaptureValue => 'ロック画面、Siri…';

  @override
  String get settingsNews => '新機能';

  @override
  String newsVersion(String version) {
    return 'バージョン$version';
  }

  @override
  String newsVersionNew(String version) {
    return 'バージョン$version・新着';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => '未サインイン';

  @override
  String get cloudSyncing => '同期中…';

  @override
  String get cloudDownloading => 'ダウンロード中…';

  @override
  String get cloudFailed => '失敗、再試行中';

  @override
  String get basketTitle => '🧺 お出かけかご';

  @override
  String get basketNote => 'かごの項目は、入れた場所を離れたときやWi-Fiが切れたときにすぐお知らせします。';

  @override
  String get basketOnPlace => 'この場所を離れたとき';

  @override
  String get basketRadius => '半径';

  @override
  String get basketRadiusTitle => 'この距離より離れたら知らせる';

  @override
  String get basketRadiusNote =>
      'iPhoneの位置の精度は約100 mなので、半径が小さいと少し遅れて知らせることがあります。';

  @override
  String get basketOnWifi => 'Wi-Fiが切れたとき';

  @override
  String get basketLocationAccess => '位置情報へのアクセス';

  @override
  String get locationAlways => '常に';

  @override
  String get locationWhileUsing => '使用中のみ';

  @override
  String get locationNotAsked => '未確認';

  @override
  String get basketWhyAlways => '「常に」の理由';

  @override
  String get basketNoTracking => '追跡なし';

  @override
  String get basketHeaderShortcuts => 'ショートカットのオートメーション';

  @override
  String get basketShortcutsNote =>
      'Red PandaがWi-Fiの切断に気づけるのは、開いているときか使った直後だけです。ショートカットのオートメーションならいつでも検知でき、自宅などの決まった場所も見張れます。';

  @override
  String get automationWifi => 'Wi-Fiから離れたとき';

  @override
  String get automationPlace => 'ある場所を離れたとき';

  @override
  String get automationSetUp => '設定する';

  @override
  String get automationMine => 'マイオートメーション';

  @override
  String get shortcutsApp => 'ショートカット';

  @override
  String get shortcutsOpen => 'ショートカットを開く';

  @override
  String get shortcutsRemindAction => 'お出かけかごをお知らせ';

  @override
  String get guideOpenShortcuts =>
      '下の「ショートカットを開く」をタップすると、「新規オートメーション」の一覧が開きます。';

  @override
  String get guideWifiScroll => '下にスクロールして「Wi-Fi」をタップします。';

  @override
  String get guideWifiNetwork => 'ネットワークを選び、「切断」にチェックを入れて「接続」のチェックを外します。';

  @override
  String get guideRunImmediately => '「すぐに実行」を選んで「次へ」をタップします。';

  @override
  String get guidePlaceLeave => '「出発」をタップし、「場所」>「選択」で場所（自宅など）を選びます。';

  @override
  String guideAddAction(String action) {
    return '「新規の空のオートメーション」をタップし、「アクションを追加」で「お出かけかご」を検索して「$action」を選びます。';
  }

  @override
  String get guideDone => '「完了」をタップ。これでパンダがかごのことを知らせてくれます。';

  @override
  String get locationInfoTitle => '位置情報を「常に」にする理由';

  @override
  String get locationInfoLeaveTitle => '離れたことに気づくためだけ';

  @override
  String get locationInfoLeaveBody =>
      '「このAppの使用中のみ」では、閉じたあとiOSはRed Pandaに何も知らせないため、かごはアプリを開いている間しか知らせられません。「常に」なら、離れた瞬間にiOSがRed Pandaを起こします。';

  @override
  String get locationInfoBatteryTitle => 'バッテリーを消耗しません';

  @override
  String get locationInfoBatteryBody =>
      'Red Pandaはあなたを追いかけません。現在地をiOSに一度だけ尋ね、その周りに円を1つ描きます。iOSはもともと使っているモバイル通信とWi-Fiの電波でその円を見守り、境界を越えるまでRed Pandaは眠っています。そのあと円は消えます。';

  @override
  String get locationInfoPrivacyTitle => '位置情報はiPhoneの中だけ';

  @override
  String get locationInfoPrivacyBody =>
      'Red Pandaにはサーバーがなく、位置情報をどこにも送りません。保存するのは円の中心だけで、このデバイスの中に、通知が届くまでです。iCloud同期には含まれません。';

  @override
  String get locationInfoWifiTitle => 'Wi-Fiには位置情報は不要';

  @override
  String get locationInfoWifiBody => '「Wi-Fiが切れたとき」は位置情報へのアクセスなしで使えます。';

  @override
  String get captureLockScreen => 'ロック画面のボタン';

  @override
  String get captureLockScreenHow =>
      'ロック画面を長押しし、「カスタマイズ」>「ロック画面」をタップ。下部のコントロール枠をタップして、Red Panda >「テキストメモ」「ボイスメモ」「パンダのかごを表示」から選びます。';

  @override
  String get captureWidgets => 'ウィジェット';

  @override
  String get captureWidgetsHow =>
      'ロック画面をカスタマイズし、時計の下のウィジェット欄（またはその上の行）をタップすると、次の期限を表示するRed Pandaウィジェットを追加できます。ホーム画面では長押しして「編集」>「ウィジェットを追加」をタップし、「Red Panda」を検索。ボタンでメモを追加したり、パンダのかごを表示したりできます。';

  @override
  String get captureControlCentre => 'コントロールセンター';

  @override
  String get captureControlCentreHow =>
      'コントロールセンターを開き、＋をタップして「コントロールを追加」から「Red Panda」を検索します。';

  @override
  String get captureActionButton => 'アクションボタン';

  @override
  String get captureActionButtonHow =>
      '「設定」>「アクションボタン」>「コントロール」で、Red Panda >「テキストメモ」「ボイスメモ」「パンダのかごを表示」から選びます。';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      '「Red Pandaでメモ」「Red Pandaでボイスメモ」「Red Pandaのかごを見せて」と話しかけます。';

  @override
  String capturePreview(String spot) {
    return '$spotのプレビュー';
  }

  @override
  String get captureLinkMicrophone => 'マイクと音声認識';

  @override
  String get captureLinkSiri => 'Siriと検索';

  @override
  String get wifi => 'Wi-Fi';
}
