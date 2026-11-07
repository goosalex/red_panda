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
  String get basketNeedsLocation => '出かけたことに気づくには位置情報が必要です。「設定」で許可してください。';

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
      'Red Pandaを閉じていても気づけるように、「設定」で位置情報を「常に」にしてください。';

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
  String get micNeeded => 'マイクが必要です。「設定」>「Red Panda」で許可してください。';

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
}
