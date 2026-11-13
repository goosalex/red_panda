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
  String get basketIn => 'お出かけかごに入れました 🧺 この場所を離れるとパンダがお知らせします。';

  @override
  String get basketOut => 'お出かけかごから出しました。';

  @override
  String get basketEmptyStatus => 'かごは空です。項目をドラッグして入れると、出かけるときにお知らせします。';

  @override
  String get basketNeedsLocation =>
      '出かけたことに気づくには位置情報が必要です。「[設定](location)」で許可してください。';

  @override
  String get basketWatching => '見守り中';

  @override
  String basketWatchingSince(String time) {
    return '見守り中（$timeから）';
  }

  @override
  String basketReasonPlace(int radius) {
    return '$radius m以上離れるとお知らせします。';
  }

  @override
  String get basketReasonWifi => 'Wi-Fiが切れるとお知らせします。';

  @override
  String basketReasonBoth(int radius) {
    return '$radius m以上離れるか、Wi-Fiが切れるとお知らせします。';
  }

  @override
  String get basketNotWatching => '今は見守っていません。「ここから見守る」をタップして開始します。';

  @override
  String basketSheetTitle(int count) {
    return '🧺 お出かけかご · $count';
  }

  @override
  String get basketNeedsAlways =>
      'Red Pandaを閉じていても気づけるように、「[設定](location)」で位置情報を「常に」にしてください。';

  @override
  String get basketWatchHere => 'ここから見守る';

  @override
  String get openSettings => '設定を開く';

  @override
  String get basketEmptyAction => 'かごを空にする';

  @override
  String get basketWatchingHere => 'ここから見守り中 📍';

  @override
  String get noLocation => '現在地を取得できませんでした。';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days日連続！パンダは誇らしげです。',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return 'パンダに竹 +$earned 🎋（たくわえ $balance）';
  }

  @override
  String bambooFull(int cap) {
    return '竹のたくわえがいっぱいです（$cap）。何かをスヌーズするか、そのまま続けましょう！';
  }

  @override
  String get deleted => '削除しました';

  @override
  String get undo => '取り消す';

  @override
  String get wokenUp => '早めに起こしました。';

  @override
  String nudgeAt(String time) {
    return 'パンダが$timeにお知らせします。';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'スヌーズするには竹が足りません（必要 $cost、手持ち $balance）。タスクを終えて竹をもらいましょう 🎋';
  }

  @override
  String snoozed(int cost) {
    return '明日までスヌーズ · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return '期限直前の延期には竹が$cost🎋必要ですが、たくわえが空です。';
  }

  @override
  String deadlineMoved(String when) {
    return '期限を変更しました：$when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return '期限を変更しました：$when · −$cost 🎋';
  }

  @override
  String get cancel => 'キャンセル';

  @override
  String get set => '設定';

  @override
  String get ok => 'OK';

  @override
  String get noCloudsYet => 'まだ雲がありません。パンダの横の「+ カテゴリ」をタップしてください。';

  @override
  String get noCategory => 'カテゴリなし';

  @override
  String filedUnder(String name) {
    return '$nameに入れました ☁️';
  }

  @override
  String get newCloud => '新しいカテゴリの雲';

  @override
  String get rename => '名前を変更';

  @override
  String get renameCloud => '雲の名前を変更';

  @override
  String get removeCloud => '雲を削除';

  @override
  String get removeCloudInfo => '項目はそのまま、カテゴリなしになります';

  @override
  String get cloudNameHint => '例：家、仕事、買い物';

  @override
  String get micNeeded => 'マイクが必要です。「[設定](microphone)」で許可してください。';

  @override
  String get recordFailed => '録音を開始できませんでした。';

  @override
  String get search => '検索';

  @override
  String get closeSearch => '検索を閉じる';

  @override
  String get settings => '設定';

  @override
  String get newTextNote => '新しいテキストメモ';

  @override
  String onlyCategory(String name) {
    return '$nameのみ';
  }

  @override
  String get onlyBasket => 'お出かけかごのみ';

  @override
  String get emptyBasketList => 'お出かけかごは空です。項目をかごにドラッグすると、出かけるときにお知らせします。';

  @override
  String emptyCategoryDay(String name) {
    return '$nameには何もありません。項目を雲にドラッグするか、太陽をタップしてすべて表示します。';
  }

  @override
  String emptyCategoryNight(String name) {
    return '$nameには何もありません。項目を雲にドラッグするか、月をタップしてすべて表示します。';
  }

  @override
  String get noNotes => 'まだメモがありません。ロック画面やアクションボタンから記録するか、+ をタップしてください。';

  @override
  String get noNotesPad => 'まだメモがありません。ロック画面やコントロールセンターから記録するか、+ をタップしてください。';

  @override
  String get hideSnoozed => 'スヌーズ中を隠す';

  @override
  String showSnoozed(int count) {
    return 'スヌーズ中 $count · 表示';
  }

  @override
  String get undoCheck => 'チェックを外す';

  @override
  String get wakeUp => '起こす';

  @override
  String streakChip(int days) {
    return '🔥 $days日';
  }

  @override
  String tickedToday(int count) {
    return '✓ 今日 $count';
  }

  @override
  String get bambooTooltip => '竹：タスクを終えると増え、スヌーズで使います';

  @override
  String level(int level) {
    return 'Lv $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 パンダが悲しんでいます：期限切れ $count';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ 今日が期限 $count。パンダが見ています。';
  }

  @override
  String get recordVoice => 'ボイスメモを録音';

  @override
  String get stopVoice => '停止してボイスメモを保存';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 $timeまで';
  }

  @override
  String get edit => '編集';

  @override
  String get done => '完了';

  @override
  String get tickOff => 'チェック';

  @override
  String get inLeaveBasket => 'お出かけかごの中';

  @override
  String daysLate(int days) {
    return '$days日遅れ';
  }

  @override
  String get today => '今日';

  @override
  String daysShort(int days) {
    return '$days日';
  }

  @override
  String dueOn(String date) {
    return '期限：$date';
  }

  @override
  String get dragHint => 'ドラッグで並べ替え、またはカテゴリの雲へ';

  @override
  String get noteHint => 'メモ';

  @override
  String get newNoteHint => '新しいメモ';

  @override
  String get deadline => '期限';

  @override
  String get leaveBasket => 'お出かけかご';

  @override
  String get leaveBasketTooltip => 'この場所を離れるときにお知らせ';

  @override
  String get save => '保存';

  @override
  String get add => '追加';

  @override
  String get turnDial => 'ダイヤルを回す';

  @override
  String get clear => 'クリア';

  @override
  String cloudSemantics(String name, int count) {
    return 'カテゴリ $name、未完了 $count';
  }

  @override
  String get cloudHintShowAll => 'ダブルタップですべて表示';

  @override
  String get cloudHintOnly => 'ダブルタップでこのカテゴリのみ表示';

  @override
  String get addCategory => 'カテゴリを追加';

  @override
  String get plusCategory => '+ カテゴリ';

  @override
  String get sun => '太陽';

  @override
  String get moon => '月';

  @override
  String get showsAllItems => 'すべての項目を表示';

  @override
  String get noDeadline => '期限なし';

  @override
  String get tomorrow => '明日';

  @override
  String inDays(int days) {
    return '$days日後';
  }

  @override
  String get noDate => '日付なし';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(days, locale: localeName, other: '日');
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'お出かけかご、$count項目',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => '、見守り中';

  @override
  String get basketHint => 'ここに項目を置くと出かけるときにお知らせします。ダブルタップで絞り込み。';

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
      '「このAppの使用中のみ」では、閉じたあとiOSはRed Pandaに何も知らせないため、かごはアプリを開いている間しか知らせられません。[「常に」](location)なら、離れた瞬間にiOSがRed Pandaを起こします。';

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
      '[ロック画面をカスタマイズ](lockScreenWidget)し、時計の下のウィジェット欄（またはその上の行）をタップすると、次の期限を表示するRed Pandaウィジェットを追加できます。ホーム画面では[長押しして「編集」>「ウィジェットを追加」をタップ](homeScreenWidget)し、「Red Panda」を検索。ボタンでメモを追加したり、パンダのかごを表示したりできます。';

  @override
  String get captureControlCentre => 'コントロールセンター';

  @override
  String get captureControlCentreHow =>
      'コントロールセンターを開き、＋をタップして「コントロールを追加」から「Red Panda」を検索します。';

  @override
  String get captureActionButton => 'アクションボタン';

  @override
  String get captureActionButtonHow =>
      '[「設定」>「アクションボタン」>「コントロール」](actionButton)で、Red Panda >「テキストメモ」「ボイスメモ」「パンダのかごを表示」から選びます。';

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

  @override
  String get walkLocationTitle => '位置情報：常に';

  @override
  String get walkMicrophoneTitle => 'マイクと音声認識';

  @override
  String get walkSiriTitle => 'Red PandaとSiri';

  @override
  String get walkActionButtonTitle => 'アクションボタンにRed Panda';

  @override
  String get walkActionButtonNote => 'iPhoneでは「コントロール」が出るまでスワイプを続けてください。';

  @override
  String walkSemantics(String path) {
    return '設定での手順のアニメーション：$path';
  }

  @override
  String get walkLockScreenTitle => 'ロック画面にRed Panda';

  @override
  String get walkHomeScreenTitle => 'ホーム画面にRed Panda';

  @override
  String get walkLongPress => '長押し';

  @override
  String get settingsPrivacy => 'プライバシー';

  @override
  String get settingsPrivacyValue => '収集なし';

  @override
  String get privacyNothingTitle => 'Red Panda は何も収集しません';

  @override
  String get privacyNothingBody =>
      '分析、広告、トラッキング、アカウントはありません。Red Panda には独自のサーバーがないため、データが送られる先はどこにもありません。';

  @override
  String get privacyNotesTitle => 'メモはあなただけのもの';

  @override
  String get privacyNotesBody =>
      'メモと音声録音はこのデバイスに保存されます。iCloud 同期をオンにすると、あなただけが読めるあなた自身の iCloud Drive にコピーされます。';

  @override
  String get privacyLocationTitle => '位置情報はお出かけかごのためだけ';

  @override
  String get privacyLocationBody =>
      'Red Panda はあなたの行き先を記録しません。かごに入れた場所を iOS に一度だけ尋ね、離れたかどうかは iOS だけが見守ります。位置情報が送信されたり同期されたりすることはありません。';

  @override
  String get privacyVoiceTitle => '音声メモは iPhone 上でテキストに';

  @override
  String get privacyVoiceBody =>
      'お使いの言語で iOS が対応していれば、音声はデバイス上で認識されます。対応していない場合は、Apple のプライバシーポリシーのもとで Apple の音声認識が使われます。';

  @override
  String get privacyOpenTitle => 'オープンソース';

  @override
  String get privacyOpenBody => 'Red Panda のコードはすべて公開されているので、誰でもこの約束を確かめられます。';

  @override
  String get privacyPolicyLink => 'プライバシーポリシー全文';

  @override
  String get privacySourceLink => 'GitHub のソースコード';
}
