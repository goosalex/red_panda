/// What a left-to-right swipe does on an open item. On ticked-off items the
/// swipe always undoes the check.
enum SwipeAction {
  snooze('Snooze until tomorrow', 'Hides the item until tomorrow morning. Costs bamboo.'),
  postpone('Postpone deadline by a day', 'Free while the deadline is far; costs bamboo when it is close.'),
  pin('Pin to top', 'Moves the item to the top of the list.'),
  category('Move to category', 'Pick a cloud for the item.'),
  deadline('Set deadline', 'Opens the days-from-now dial.'),
  remindLater('Remind me later today', 'A one-off nudge in three hours.'),
  duplicate('Duplicate', 'Copies the item, handy for recurring chores.'),
  share('Share', 'Shares the item as text.');

  const SwipeAction(this.label, this.description);
  final String label;
  final String description;
}

/// How hard the sad pandas nag (notifications and widgets).
enum NagIntensity {
  off('Off'),
  gentle('Gentle'),
  normal('Normal'),
  persistent('Persistent');

  const NagIntensity(this.label);
  final String label;
}

/// User preferences, stored in settings.json in the App Group container.
class AppSettings {
  const AppSettings({
    this.swipeAction = SwipeAction.snooze,
    this.nagIntensity = NagIntensity.normal,
    this.quietStartHour = 22,
    this.quietEndHour = 8,
  });

  final SwipeAction swipeAction;
  final NagIntensity nagIntensity;
  final int quietStartHour;
  final int quietEndHour;

  AppSettings copyWith({
    SwipeAction? swipeAction,
    NagIntensity? nagIntensity,
    int? quietStartHour,
    int? quietEndHour,
  }) =>
      AppSettings(
        swipeAction: swipeAction ?? this.swipeAction,
        nagIntensity: nagIntensity ?? this.nagIntensity,
        quietStartHour: quietStartHour ?? this.quietStartHour,
        quietEndHour: quietEndHour ?? this.quietEndHour,
      );

  static T _enum<T extends Enum>(List<T> values, Object? name, T fallback) =>
      values.where((v) => v.name == name).firstOrNull ?? fallback;

  factory AppSettings.fromJson(Map<String, dynamic> j) => AppSettings(
        swipeAction: _enum(SwipeAction.values, j['swipeAction'], SwipeAction.snooze),
        nagIntensity: _enum(NagIntensity.values, j['nagIntensity'], NagIntensity.normal),
        quietStartHour: (j['quietStartHour'] as int?) ?? 22,
        quietEndHour: (j['quietEndHour'] as int?) ?? 8,
      );

  Map<String, dynamic> toJson() => {
        'swipeAction': swipeAction.name,
        'nagIntensity': nagIntensity.name,
        'quietStartHour': quietStartHour,
        'quietEndHour': quietEndHour,
      };
}
