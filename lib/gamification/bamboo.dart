import '../models/note.dart';

/// The bamboo stash: every completed item earns bamboo, snoozing and late
/// postponing cost bamboo. Stored in panda_state.json.
///
/// Each item pays out only once (ticking, unticking and re-ticking doesn't
/// farm bamboo), and the stash is capped so snooze power stays scarce.
class BambooWallet {
  const BambooWallet({this.balance = startBalance, this.rewardedIds = const {}});

  static const startBalance = 3;
  static const cap = 12;
  static const perCompletion = 1;

  /// Extra bamboo for finishing before the deadline day.
  static const earlyBonus = 1;

  static const snoozeCost = 2;
  static const latePostponeCost = 1;

  /// Postponing is free while the deadline is further away than this.
  static const freePostponeDays = 2;

  final int balance;
  final Set<String> rewardedIds;

  bool canAfford(int cost) => balance >= cost;

  /// Bamboo earned for completing [note] at [now] (0 if it was paid already).
  int rewardFor(Note note, DateTime now) {
    if (rewardedIds.contains(note.id)) return 0;
    final left = note.daysLeft(now);
    return perCompletion + (left != null && left > 0 ? earlyBonus : 0);
  }

  /// Returns the wallet after completing [note], and how much was added
  /// (can be less than the reward when the stash is full).
  (BambooWallet, int) complete(Note note, DateTime now) {
    final reward = rewardFor(note, now);
    if (reward == 0) return (this, 0);
    final next = (balance + reward).clamp(0, cap);
    return (
      BambooWallet(balance: next, rewardedIds: {...rewardedIds, note.id}),
      next - balance,
    );
  }

  /// Cost of postponing [note]'s deadline by a day at [now].
  static int postponeCost(Note note, DateTime now) {
    final left = note.daysLeft(now);
    return left == null || left > freePostponeDays ? 0 : latePostponeCost;
  }

  /// Null when the stash is too small.
  BambooWallet? spend(int cost) =>
      cost > balance ? null : BambooWallet(balance: balance - cost, rewardedIds: rewardedIds);

  /// Forgets rewards for deleted notes so the file doesn't grow forever.
  BambooWallet prune(Iterable<String> existingIds) {
    final keep = existingIds.toSet();
    return BambooWallet(balance: balance, rewardedIds: rewardedIds.where(keep.contains).toSet());
  }

  factory BambooWallet.fromJson(Map<String, dynamic> j) => BambooWallet(
        balance: (j['bamboo'] as int?) ?? startBalance,
        rewardedIds: ((j['rewardedIds'] as List?) ?? const []).cast<String>().toSet(),
      );

  Map<String, dynamic> toJson() => {'bamboo': balance, 'rewardedIds': rewardedIds.toList()};
}
