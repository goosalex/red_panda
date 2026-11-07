import '../models/app_settings.dart';
import 'l10n.dart';

/// Translated names of the settings enums (their `label` fields are the
/// English source).
extension SwipeActionText on SwipeAction {
  String title(AppLocalizations l) => switch (this) {
        SwipeAction.snooze => l.swipeSnooze,
        SwipeAction.postpone => l.swipePostpone,
        SwipeAction.pin => l.swipePin,
        SwipeAction.category => l.swipeCategory,
        SwipeAction.deadline => l.swipeDeadline,
        SwipeAction.remindLater => l.swipeRemindLater,
        SwipeAction.duplicate => l.swipeDuplicate,
        SwipeAction.basket => l.swipeBasket,
        SwipeAction.share => l.swipeShare,
      };

  String info(AppLocalizations l) => switch (this) {
        SwipeAction.snooze => l.swipeSnoozeInfo,
        SwipeAction.postpone => l.swipePostponeInfo,
        SwipeAction.pin => l.swipePinInfo,
        SwipeAction.category => l.swipeCategoryInfo,
        SwipeAction.deadline => l.swipeDeadlineInfo,
        SwipeAction.remindLater => l.swipeRemindLaterInfo,
        SwipeAction.duplicate => l.swipeDuplicateInfo,
        SwipeAction.basket => l.swipeBasketInfo,
        SwipeAction.share => l.swipeShareInfo,
      };
}

extension NagIntensityText on NagIntensity {
  String title(AppLocalizations l) => switch (this) {
        NagIntensity.off => l.nagOff,
        NagIntensity.gentle => l.nagGentle,
        NagIntensity.normal => l.nagNormal,
        NagIntensity.persistent => l.nagPersistent,
      };
}
