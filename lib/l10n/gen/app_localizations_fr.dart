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
      'Appuyez longuement sur l\'écran verrouillé, touchez Personnaliser > Écran verrouillé, touchez un emplacement de commande en bas et choisissez Red Panda > Note texte, Note vocale ou Voir le panier du panda.';

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
      'Réglages > Bouton Action > Commandes, puis choisissez Red Panda > Note texte, Note vocale ou Voir le panier du panda.';

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
