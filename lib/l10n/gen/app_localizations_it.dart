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

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get settingsHeaderList => 'Elenco';

  @override
  String get settingsHeaderReminders => 'Promemoria';

  @override
  String get settingsHeaderPanda => 'Panda';

  @override
  String get settingsCloudSync => 'Sincronizzazione iCloud';

  @override
  String get settingsCloudNote =>
      'Note, note vocali, categorie e bambù si sincronizzano tramite iCloud Drive su ogni iPhone e iPad collegato allo stesso Account Apple. Le impostazioni restano su ciascun dispositivo.';

  @override
  String get settingsOn => 'Attivato';

  @override
  String get settingsOff => 'Disattivato';

  @override
  String get settingsSwipeRight => 'Scorri a destra';

  @override
  String get settingsSwipeDrawerTitle => 'Scorri una voce a destra';

  @override
  String get settingsSwipeDrawerNote =>
      'Le voci spuntate perdono sempre la spunta; quelle rimandate si risvegliano.';

  @override
  String get settingsNag => 'Promemoria del panda triste';

  @override
  String get settingsNagNote =>
      'Notifiche e widget insistono man mano che le scadenze si avvicinano.';

  @override
  String get settingsQuietFrom => 'Silenzio dalle';

  @override
  String get settingsQuietUntil => 'Silenzio fino alle';

  @override
  String get settingsLeaveBasket => 'Cestino da portare';

  @override
  String get settingsBambooRules => 'Regole del bambù';

  @override
  String settingsBambooMax(int cap) {
    return 'Max $cap';
  }

  @override
  String get bambooTitle => '🎋 Bambù';

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
      other: '$freeDays giorni',
      one: '$freeDays giorno',
    );
    return 'Ogni voce completata dà al panda $perCompletion 🎋 (+$earlyBonus se finita prima del giorno di scadenza). Rimandare costa $snoozeCost 🎋; spostare una scadenza è gratis fino a $_temp0 prima, poi costa $lateCost 🎋. La scorta tiene al massimo $cap.';
  }

  @override
  String get settingsQuickCapture => 'Cattura rapida';

  @override
  String get settingsQuickCaptureValue => 'Schermata di blocco, Siri…';

  @override
  String get settingsNews => 'Novità';

  @override
  String newsVersion(String version) {
    return 'Versione $version';
  }

  @override
  String newsVersionNew(String version) {
    return 'Versione $version · nuova';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => 'Accesso non effettuato';

  @override
  String get cloudSyncing => 'Sincronizzazione…';

  @override
  String get cloudDownloading => 'Download…';

  @override
  String get cloudFailed => 'Non riuscita, riprovo';

  @override
  String get basketTitle => '🧺 Cestino da portare';

  @override
  String get basketNote =>
      'Le voci nel cestino te lo ricordano appena lasci il posto in cui ce le hai messe, o cade il Wi-Fi.';

  @override
  String get basketOnPlace => 'Quando lascio questo posto';

  @override
  String get basketRadius => 'Raggio';

  @override
  String get basketRadiusTitle => 'Avvisami quando sono più lontano di';

  @override
  String get basketRadiusNote =>
      'L\'iPhone ti localizza con una precisione di circa 100 m, quindi un raggio piccolo può scattare un po\' tardi.';

  @override
  String get basketOnWifi => 'Quando cade il mio Wi-Fi';

  @override
  String get basketLocationAccess => 'Accesso alla posizione';

  @override
  String get locationAlways => 'Sempre';

  @override
  String get locationWhileUsing => 'Mentre usi l\'app';

  @override
  String get locationNotAsked => 'Non ancora chiesto';

  @override
  String get basketWhyAlways => 'Perché “Sempre”?';

  @override
  String get basketNoTracking => 'Nessun tracciamento';

  @override
  String get basketHeaderShortcuts => 'Automazioni di Comandi rapidi';

  @override
  String get basketShortcutsNote =>
      'Red Panda si accorge che il Wi-Fi cade solo mentre è aperta o è stata appena usata. Un\'automazione di Comandi rapidi se ne accorge sempre e può tenere d\'occhio un posto fisso come casa.';

  @override
  String get automationWifi => 'Quando lascio una rete Wi-Fi';

  @override
  String get automationPlace => 'Quando lascio un posto';

  @override
  String get automationSetUp => 'Configura';

  @override
  String get automationMine => 'Le mie automazioni';

  @override
  String get shortcutsApp => 'Comandi rapidi';

  @override
  String get shortcutsOpen => 'Apri Comandi rapidi';

  @override
  String get shortcutsRemindAction => 'Ricordami il cestino da portare';

  @override
  String get guideOpenShortcuts =>
      'Tocca “Apri Comandi rapidi” qui sotto: si apre l\'elenco Nuova automazione.';

  @override
  String get guideWifiScroll => 'Scorri in basso e tocca Wi-Fi.';

  @override
  String get guideWifiNetwork =>
      'Scegli la tua rete, spunta “Si disconnette” e togli la spunta a “Si connette”.';

  @override
  String get guideRunImmediately =>
      'Scegli “Esegui immediatamente”, poi tocca Avanti.';

  @override
  String get guidePlaceLeave =>
      'Tocca Esci, poi Posizione > Scegli, e scegli il posto (ad es. casa).';

  @override
  String guideAddAction(String action) {
    return 'Tocca “Nuova automazione vuota”, poi Aggiungi azione, cerca “cestino da portare” e scegli “$action”.';
  }

  @override
  String get guideDone =>
      'Tocca Fine. Da ora il panda ti ricorda il tuo cestino.';

  @override
  String get locationInfoTitle => 'Perché la posizione “Sempre”?';

  @override
  String get locationInfoLeaveTitle => 'Solo per accorgersi che te ne vai';

  @override
  String get locationInfoLeaveBody =>
      'Con “Mentre usi l\'app”, iOS non dice nulla a Red Panda quando è chiusa, quindi il cestino potrebbe avvisarti solo con l\'app aperta. “Sempre” permette a iOS di svegliare Red Panda appena te ne vai.';

  @override
  String get locationInfoBatteryTitle => 'Nessun consumo di batteria';

  @override
  String get locationInfoBatteryBody =>
      'Red Panda non ti segue. Chiede a iOS una sola volta dove sei e ci disegna un cerchio intorno. iOS sorveglia quel cerchio con i segnali cellulari e Wi-Fi che usa comunque, e Red Panda dorme finché non ne attraversi il bordo. Poi il cerchio viene rimosso.';

  @override
  String get locationInfoPrivacyTitle =>
      'La tua posizione resta sul tuo iPhone';

  @override
  String get locationInfoPrivacyBody =>
      'Red Panda non ha server e non invia la tua posizione da nessuna parte. Resta salvato solo il centro del cerchio, su questo dispositivo, finché scatta il promemoria. La sincronizzazione iCloud non lo include mai.';

  @override
  String get locationInfoWifiTitle => 'Per il Wi-Fi non serve la posizione';

  @override
  String get locationInfoWifiBody =>
      '“Quando cade il mio Wi-Fi” funziona senza accesso alla posizione.';

  @override
  String get captureLockScreen => 'Pulsanti della schermata di blocco';

  @override
  String get captureLockScreenHow =>
      'Tieni premuto sulla schermata di blocco, tocca Personalizza > Schermata di blocco, tocca uno spazio per i controlli in basso e scegli Red Panda > Nota di testo, Nota vocale o Mostra il cestino del panda.';

  @override
  String get captureWidgets => 'Widget';

  @override
  String get captureWidgetsHow =>
      'Personalizza la schermata di blocco e tocca l\'area dei widget sotto l\'orologio (o la riga sopra) per aggiungere il widget di Red Panda con la tua prossima scadenza. Nella schermata Home tieni premuto, tocca Modifica > Aggiungi widget e cerca “Red Panda”: i suoi pulsanti aggiungono una nota o mostrano il cestino del panda.';

  @override
  String get captureControlCentre => 'Centro di Controllo';

  @override
  String get captureControlCentreHow =>
      'Apri Centro di Controllo, tocca +, Aggiungi un controllo, cerca “Red Panda”.';

  @override
  String get captureActionButton => 'Tasto Azione';

  @override
  String get captureActionButtonHow =>
      'Impostazioni > Tasto Azione > Controlli, poi scegli Red Panda > Nota di testo, Nota vocale o Mostra il cestino del panda.';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      'Di’ “Nota con Red Panda”, “Nota vocale con Red Panda” o “Mostra il mio cestino di Red Panda”.';

  @override
  String capturePreview(String spot) {
    return 'Anteprima: $spot';
  }

  @override
  String get captureLinkMicrophone => 'Microfono e riconoscimento vocale';

  @override
  String get captureLinkSiri => 'Siri e ricerca';

  @override
  String get wifi => 'Wi-Fi';
}
