// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => 'Reporter à demain';

  @override
  String get swipeSnoozeInfo =>
      'Masque l\'élément jusqu\'à demain matin. Coûte du bambou.';

  @override
  String get swipePostpone => 'Repousser l\'échéance d\'un jour';

  @override
  String get swipePostponeInfo =>
      'Gratuit tant que l\'échéance est loin ; coûte du bambou quand elle approche.';

  @override
  String get swipePin => 'Épingler en haut';

  @override
  String get swipePinInfo => 'Place l\'élément en haut de la liste.';

  @override
  String get swipeCategory => 'Déplacer vers une catégorie';

  @override
  String get swipeCategoryInfo => 'Choisissez un nuage pour l\'élément.';

  @override
  String get swipeDeadline => 'Fixer une échéance';

  @override
  String get swipeDeadlineInfo => 'Ouvre le cadran des jours à venir.';

  @override
  String get swipeRemindLater => 'Me le rappeler plus tard';

  @override
  String get swipeRemindLaterInfo => 'Un rappel unique dans trois heures.';

  @override
  String get swipeDuplicate => 'Dupliquer';

  @override
  String get swipeDuplicateInfo =>
      'Copie l\'élément, pratique pour les tâches récurrentes.';

  @override
  String get swipeBasket => 'Mettre dans le panier de départ';

  @override
  String get swipeBasketInfo =>
      'Vous le rappelle quand vous quittez ce lieu ou votre Wi-Fi.';

  @override
  String get swipeShare => 'Partager';

  @override
  String get swipeShareInfo => 'Partage l\'élément sous forme de texte.';

  @override
  String get nagOff => 'Désactivé';

  @override
  String get nagGentle => 'Doux';

  @override
  String get nagNormal => 'Normal';

  @override
  String get nagPersistent => 'Insistant';
}
