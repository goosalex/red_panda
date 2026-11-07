// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => 'Rimanda a domani';

  @override
  String get swipeSnoozeInfo =>
      'Nasconde la voce fino a domani mattina. Costa bambù.';

  @override
  String get swipePostpone => 'Sposta la scadenza di un giorno';

  @override
  String get swipePostponeInfo =>
      'Gratis finché la scadenza è lontana; costa bambù quando è vicina.';

  @override
  String get swipePin => 'Fissa in alto';

  @override
  String get swipePinInfo => 'Sposta la voce in cima alla lista.';

  @override
  String get swipeCategory => 'Sposta in categoria';

  @override
  String get swipeCategoryInfo => 'Scegli una nuvola per la voce.';

  @override
  String get swipeDeadline => 'Imposta scadenza';

  @override
  String get swipeDeadlineInfo => 'Apre la rotella dei giorni da oggi.';

  @override
  String get swipeRemindLater => 'Ricordamelo più tardi';

  @override
  String get swipeRemindLaterInfo => 'Un promemoria unico tra tre ore.';

  @override
  String get swipeDuplicate => 'Duplica';

  @override
  String get swipeDuplicateInfo =>
      'Copia la voce, comodo per le faccende ricorrenti.';

  @override
  String get swipeBasket => 'Metti nel cestino da portare';

  @override
  String get swipeBasketInfo =>
      'Te lo ricorda quando lasci questo posto o il tuo Wi-Fi.';

  @override
  String get swipeShare => 'Condividi';

  @override
  String get swipeShareInfo => 'Condivide la voce come testo.';

  @override
  String get nagOff => 'Disattivato';

  @override
  String get nagGentle => 'Delicato';

  @override
  String get nagNormal => 'Normale';

  @override
  String get nagPersistent => 'Insistente';
}
