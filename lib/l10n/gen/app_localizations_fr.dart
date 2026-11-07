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

  @override
  String get basketIn =>
      'Dans le panier de départ 🧺 Le panda vous le rappelle quand vous quittez ce lieu.';

  @override
  String get basketOut => 'Retiré du panier de départ.';

  @override
  String get basketEmptyStatus =>
      'Le panier est vide. Glissez-y des éléments pour qu\'on vous les rappelle en partant.';

  @override
  String get basketNeedsLocation =>
      'Red Panda a besoin de votre position pour savoir quand vous partez. Autorisez-la dans Réglages.';

  @override
  String get basketWatching => 'Surveillance active';

  @override
  String basketWatchingSince(String time) {
    return 'Surveillance active (depuis $time)';
  }

  @override
  String basketReasonPlace(int radius) {
    return 'vous recevez un rappel dès que vous vous éloignez de plus de $radius m.';
  }

  @override
  String get basketReasonWifi =>
      'vous recevez un rappel quand votre Wi-Fi se coupe.';

  @override
  String basketReasonBoth(int radius) {
    return 'vous recevez un rappel dès que vous vous éloignez de plus de $radius m ou que votre Wi-Fi se coupe.';
  }

  @override
  String get basketNotWatching =>
      'Pas de surveillance pour l\'instant. Touchez « Surveiller d\'ici » pour commencer.';

  @override
  String basketSheetTitle(int count) {
    return '🧺 Panier de départ · $count';
  }

  @override
  String get basketNeedsAlways =>
      'Pour remarquer votre départ quand Red Panda est fermé, réglez Position sur « Toujours » dans Réglages.';

  @override
  String get basketWatchHere => 'Surveiller d\'ici';

  @override
  String get openSettings => 'Ouvrir Réglages';

  @override
  String get basketEmptyAction => 'Vider le panier';

  @override
  String get basketWatchingHere => 'Surveillance depuis ici 📍';

  @override
  String get noLocation => 'Impossible d\'obtenir votre position.';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours d\'affilée ! Le panda est fier.',
      one: '1 jour d\'affilée ! Le panda est fier.',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return '+$earned 🎋 bambou pour le panda ($balance en réserve)';
  }

  @override
  String bambooFull(int cap) {
    return 'La réserve de bambou est pleine ($cap). Reportez quelque chose, ou continuez !';
  }

  @override
  String get deleted => 'Supprimé';

  @override
  String get undo => 'Annuler';

  @override
  String get wokenUp => 'Réveillé plus tôt.';

  @override
  String nudgeAt(String time) {
    return 'Le panda vous fera signe à $time.';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'Pas assez de bambou pour reporter (il en faut $cost, vous en avez $balance). Terminez une tâche pour en gagner 🎋';
  }

  @override
  String snoozed(int cost) {
    return 'Reporté à demain · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return 'Repousser si près de l\'échéance coûte $cost 🎋, et la réserve est vide.';
  }

  @override
  String deadlineMoved(String when) {
    return 'Échéance déplacée : $when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return 'Échéance déplacée : $when · −$cost 🎋';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get set => 'Valider';

  @override
  String get ok => 'OK';

  @override
  String get noCloudsYet =>
      'Pas encore de nuages. Touchez « + catégorie » à côté du panda.';

  @override
  String get noCategory => 'Sans catégorie';

  @override
  String filedUnder(String name) {
    return 'Rangé dans $name ☁️';
  }

  @override
  String get newCloud => 'Nouveau nuage de catégorie';

  @override
  String get rename => 'Renommer';

  @override
  String get renameCloud => 'Renommer le nuage';

  @override
  String get removeCloud => 'Supprimer le nuage';

  @override
  String get removeCloudInfo =>
      'Ses éléments restent, simplement sans catégorie';

  @override
  String get cloudNameHint => 'p. ex. Maison, Travail, Courses';

  @override
  String get micNeeded =>
      'Red Panda a besoin du micro. Autorisez-le dans Réglages > Red Panda.';

  @override
  String get recordFailed => 'Impossible de démarrer l\'enregistrement.';

  @override
  String get search => 'Rechercher';

  @override
  String get closeSearch => 'Fermer la recherche';

  @override
  String get settings => 'Réglages';

  @override
  String get newTextNote => 'Nouvelle note';

  @override
  String onlyCategory(String name) {
    return 'Seulement $name';
  }

  @override
  String get onlyBasket => 'Seulement le panier de départ';

  @override
  String get emptyBasketList =>
      'Le panier de départ est vide. Glissez des éléments sur le panier pour qu\'on vous les rappelle en partant.';

  @override
  String emptyCategoryDay(String name) {
    return 'Rien dans $name. Glissez un élément sur son nuage, ou touchez le soleil pour tout voir.';
  }

  @override
  String emptyCategoryNight(String name) {
    return 'Rien dans $name. Glissez un élément sur son nuage, ou touchez la lune pour tout voir.';
  }

  @override
  String get noNotes =>
      'Pas encore de notes. Ajoutez-en une depuis l\'écran verrouillé ou le bouton Action, ou touchez +.';

  @override
  String get hideSnoozed => 'Masquer les reportés';

  @override
  String showSnoozed(int count) {
    return '$count reporté(s) · afficher';
  }

  @override
  String get undoCheck => 'Décocher';

  @override
  String get wakeUp => 'Réveiller';

  @override
  String streakChip(int days) {
    return '🔥 $days j';
  }

  @override
  String tickedToday(int count) {
    return '✓ $count aujourd\'hui';
  }

  @override
  String get bambooTooltip =>
      'Bambou : gagnez-en en terminant des tâches, dépensez-le pour reporter';

  @override
  String level(int level) {
    return 'Niv. $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 Le panda est triste : $count en retard';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ $count pour aujourd\'hui. Le panda vous a à l\'œil.';
  }

  @override
  String get recordVoice => 'Enregistrer une note vocale';

  @override
  String get stopVoice => 'Arrêter et enregistrer la note vocale';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 jusqu\'à $time';
  }

  @override
  String get edit => 'Modifier';

  @override
  String get done => 'Fait';

  @override
  String get tickOff => 'Cocher';

  @override
  String get inLeaveBasket => 'Dans le panier de départ';

  @override
  String daysLate(int days) {
    return '$days j de retard';
  }

  @override
  String get today => 'aujourd\'hui';

  @override
  String daysShort(int days) {
    return '$days j';
  }

  @override
  String dueOn(String date) {
    return 'Échéance : $date';
  }

  @override
  String get dragHint =>
      'Glissez pour réorganiser ou vers un nuage de catégorie';

  @override
  String get noteHint => 'Note';

  @override
  String get newNoteHint => 'Nouvelle note';

  @override
  String get deadline => 'Échéance';

  @override
  String get leaveBasket => 'Panier de départ';

  @override
  String get leaveBasketTooltip => 'Me le rappeler quand je quitte ce lieu';

  @override
  String get save => 'Enregistrer';

  @override
  String get add => 'Ajouter';

  @override
  String get turnDial => 'Tournez le cadran';

  @override
  String get clear => 'Effacer';

  @override
  String cloudSemantics(String name, int count) {
    return 'Catégorie $name, $count en cours';
  }

  @override
  String get cloudHintShowAll => 'Touchez deux fois pour tout afficher';

  @override
  String get cloudHintOnly =>
      'Touchez deux fois pour n\'afficher que cette catégorie';

  @override
  String get addCategory => 'Ajouter une catégorie';

  @override
  String get plusCategory => '+ catégorie';

  @override
  String get sun => 'Soleil';

  @override
  String get moon => 'Lune';

  @override
  String get showsAllItems => 'Affiche tous les éléments';

  @override
  String get noDeadline => 'sans échéance';

  @override
  String get tomorrow => 'demain';

  @override
  String inDays(int days) {
    return 'dans $days jours';
  }

  @override
  String get noDate => 'sans date';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'jours',
      one: 'jour',
    );
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Panier de départ, $count éléments',
      one: 'Panier de départ, 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => ', surveillance active';

  @override
  String get basketHint =>
      'Déposez des éléments ici pour un rappel au départ. Touchez deux fois pour filtrer.';
}
