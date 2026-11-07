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

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get settingsHeaderList => 'Liste';

  @override
  String get settingsHeaderReminders => 'Rappels';

  @override
  String get settingsHeaderPanda => 'Panda';

  @override
  String get settingsCloudSync => 'Synchro iCloud';

  @override
  String get settingsCloudNote =>
      'Les notes, notes vocales, catégories et le bambou se synchronisent via votre iCloud Drive sur chaque iPhone et iPad connecté au même compte Apple. Les réglages restent propres à chaque appareil.';

  @override
  String get settingsOn => 'Activé';

  @override
  String get settingsOff => 'Désactivé';

  @override
  String get settingsSwipeRight => 'Balayer à droite';

  @override
  String get settingsSwipeDrawerTitle => 'Balayer un élément vers la droite';

  @override
  String get settingsSwipeDrawerNote =>
      'Les éléments cochés se décochent toujours ; les éléments reportés se réveillent.';

  @override
  String get settingsNag => 'Rappels du panda triste';

  @override
  String get settingsNagNote =>
      'Notifications et widgets insistent à mesure que les échéances approchent.';

  @override
  String get settingsQuietFrom => 'Silence à partir de';

  @override
  String get settingsQuietUntil => 'Silence jusqu\'à';

  @override
  String get settingsLeaveBasket => 'Panier de départ';

  @override
  String get settingsBambooRules => 'Règles du bambou';

  @override
  String settingsBambooMax(int cap) {
    return 'Max $cap';
  }

  @override
  String get bambooTitle => '🎋 Bambou';

  @override
  String bambooRules(
    int perCompletion,
    int earlyBonus,
    int snoozeCost,
    int freeDays,
    int lateCost,
    int cap,
  ) {
    String _temp0 = intl.Intl.pluralLogic(
      freeDays,
      locale: localeName,
      other: '$freeDays jours',
      one: '$freeDays jour',
    );
    return 'Chaque élément terminé donne $perCompletion 🎋 au panda (+$earlyBonus s\'il est fini avant le jour de l\'échéance). Reporter coûte $snoozeCost 🎋 ; décaler une échéance est gratuit jusqu\'à $_temp0 avant, puis coûte $lateCost 🎋. La réserve contient au plus $cap.';
  }

  @override
  String get settingsQuickCapture => 'Capture rapide';

  @override
  String get settingsQuickCaptureValue => 'Écran verrouillé, Siri…';

  @override
  String get settingsNews => 'Nouveautés';

  @override
  String newsVersion(String version) {
    return 'Version $version';
  }

  @override
  String newsVersionNew(String version) {
    return 'Version $version · nouveau';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => 'Non connecté';

  @override
  String get cloudSyncing => 'Synchronisation…';

  @override
  String get cloudDownloading => 'Téléchargement…';

  @override
  String get cloudFailed => 'Échec, nouvel essai';

  @override
  String get basketTitle => '🧺 Panier de départ';

  @override
  String get basketNote =>
      'Les éléments du panier vous font signe dès que vous quittez l\'endroit où vous les y avez mis, ou que votre Wi-Fi décroche.';

  @override
  String get basketOnPlace => 'Quand je quitte ce lieu';

  @override
  String get basketRadius => 'Rayon';

  @override
  String get basketRadiusTitle => 'Me prévenir quand je suis à plus de';

  @override
  String get basketRadiusNote =>
      'L\'iPhone vous situe à environ 100 m près : un petit rayon peut se déclencher un peu tard.';

  @override
  String get basketOnWifi => 'Quand mon Wi-Fi décroche';

  @override
  String get basketLocationAccess => 'Accès à la position';

  @override
  String get locationAlways => 'Toujours';

  @override
  String get locationWhileUsing => 'Pendant l\'utilisation';

  @override
  String get locationNotAsked => 'Pas encore demandé';

  @override
  String get basketWhyAlways => 'Pourquoi « Toujours » ?';

  @override
  String get basketNoTracking => 'Aucun suivi';

  @override
  String get basketHeaderShortcuts => 'Automatisations Raccourcis';

  @override
  String get basketShortcutsNote =>
      'Red Panda ne remarque une coupure du Wi-Fi que s\'il est ouvert ou vient d\'être utilisé. Une automatisation Raccourcis la détecte à tout moment et peut surveiller un lieu fixe comme la maison.';

  @override
  String get automationWifi => 'Quand je quitte un Wi-Fi';

  @override
  String get automationPlace => 'Quand je quitte un lieu';

  @override
  String get automationSetUp => 'Configurer';

  @override
  String get automationMine => 'Mes automatisations';

  @override
  String get shortcutsApp => 'Raccourcis';

  @override
  String get shortcutsOpen => 'Ouvrir Raccourcis';

  @override
  String get shortcutsRemindAction => 'Me rappeler mon panier de départ';

  @override
  String get guideOpenShortcuts =>
      'Touchez « Ouvrir Raccourcis » ci-dessous : la liste Nouvelle automatisation s\'ouvre.';

  @override
  String get guideWifiScroll => 'Faites défiler vers le bas et touchez Wi-Fi.';

  @override
  String get guideWifiNetwork =>
      'Choisissez votre réseau, cochez « Se déconnecte » et décochez « Se connecte ».';

  @override
  String get guideRunImmediately =>
      'Choisissez « Exécuter immédiatement », puis touchez Suivant.';

  @override
  String get guidePlaceLeave =>
      'Touchez Quitter, puis Lieu > Choisir, et choisissez l\'endroit (par ex. domicile).';

  @override
  String guideAddAction(String action) {
    return 'Touchez « Nouvelle automatisation vierge », puis Ajouter une action, cherchez « panier de départ » et choisissez « $action ».';
  }

  @override
  String get guideDone =>
      'Touchez OK. Désormais, le panda vous rappelle votre panier.';

  @override
  String get locationInfoTitle => 'Pourquoi la position « Toujours » ?';

  @override
  String get locationInfoLeaveTitle => 'Seulement pour voir que vous partez';

  @override
  String get locationInfoLeaveBody =>
      'Avec « Lorsque l\'app est active », iOS ne dit plus rien à Red Panda une fois l\'app fermée : le panier ne pourrait vous prévenir que l\'app ouverte. « Toujours » permet à iOS de réveiller Red Panda dès que vous partez.';

  @override
  String get locationInfoBatteryTitle => 'Pas de batterie vidée';

  @override
  String get locationInfoBatteryBody =>
      'Red Panda ne vous suit pas. Il demande une seule fois à iOS où vous êtes et trace un cercle autour. iOS surveille ce cercle avec les signaux cellulaires et Wi-Fi qu\'il utilise de toute façon, et Red Panda dort jusqu\'à ce que vous en franchissiez le bord. Le cercle est alors supprimé.';

  @override
  String get locationInfoPrivacyTitle =>
      'Votre position reste sur votre iPhone';

  @override
  String get locationInfoPrivacyBody =>
      'Red Panda n\'a pas de serveur et n\'envoie votre position nulle part. Seul le centre du cercle est gardé, sur cet appareil, jusqu\'au rappel. La synchro iCloud ne l\'inclut jamais.';

  @override
  String get locationInfoWifiTitle => 'Le Wi-Fi se passe de la position';

  @override
  String get locationInfoWifiBody =>
      '« Quand mon Wi-Fi décroche » fonctionne sans accès à la position.';

  @override
  String get captureLockScreen => 'Boutons de l\'écran verrouillé';

  @override
  String get captureLockScreenHow =>
      'Appuyez longuement sur l\'écran verrouillé, touchez Personnaliser > Écran verrouillé, touchez un emplacement de commande en bas et choisissez Red Panda > Note texte, Note vocale ou Afficher le panier du panda.';

  @override
  String get captureWidgets => 'Widgets';

  @override
  String get captureWidgetsHow =>
      'Personnalisez l\'écran verrouillé et touchez la zone des widgets sous l\'heure (ou la ligne au-dessus) pour ajouter le widget Red Panda avec votre prochaine échéance. Sur l\'écran d\'accueil, appuyez longuement, touchez Modifier > Ajouter un widget et cherchez « Red Panda » : ses boutons ajoutent une note ou montrent le panier du panda.';

  @override
  String get captureControlCentre => 'Centre de contrôle';

  @override
  String get captureControlCentreHow =>
      'Ouvrez le Centre de contrôle, touchez +, Ajouter une commande, cherchez « Red Panda ».';

  @override
  String get captureActionButton => 'Bouton Action';

  @override
  String get captureActionButtonHow =>
      'Réglages > Bouton Action > Commandes, puis choisissez Red Panda > Note texte, Note vocale ou Afficher le panier du panda.';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      'Dites « Note avec Red Panda », « Note vocale avec Red Panda » ou « Montre mon panier Red Panda ».';

  @override
  String capturePreview(String spot) {
    return 'Aperçu : $spot';
  }

  @override
  String get captureLinkMicrophone => 'Micro et reconnaissance vocale';

  @override
  String get captureLinkSiri => 'Siri et recherche';

  @override
  String get wifi => 'Wi-Fi';
}
