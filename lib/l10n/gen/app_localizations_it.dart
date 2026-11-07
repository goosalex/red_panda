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
  String get basketIn =>
      'Nel cestino da portare 🧺 Il panda te lo ricorda quando lasci questo posto.';

  @override
  String get basketOut => 'Tolto dal cestino da portare.';

  @override
  String get basketEmptyStatus =>
      'Il cestino è vuoto. Trascina qui le voci per ricordartele quando esci.';

  @override
  String get basketNeedsLocation =>
      'Red Panda ha bisogno della tua posizione per capire quando esci. Consentila in [Impostazioni](location).';

  @override
  String get basketWatching => 'In ascolto';

  @override
  String basketWatchingSince(String time) {
    return 'In ascolto (dalle $time)';
  }

  @override
  String basketReasonPlace(int radius) {
    return 'ricevi un promemoria quando ti allontani più di $radius m.';
  }

  @override
  String get basketReasonWifi => 'ricevi un promemoria quando perdi il Wi-Fi.';

  @override
  String basketReasonBoth(int radius) {
    return 'ricevi un promemoria quando ti allontani più di $radius m o perdi il Wi-Fi.';
  }

  @override
  String get basketNotWatching =>
      'Al momento non sono in ascolto. Tocca \"Controlla da qui\" per iniziare.';

  @override
  String basketSheetTitle(int count) {
    return '🧺 Cestino da portare · $count';
  }

  @override
  String get basketNeedsAlways =>
      'Per accorgersi che esci anche con Red Panda chiuso, imposta Posizione su \"Sempre\" in [Impostazioni](location).';

  @override
  String get basketWatchHere => 'Controlla da qui';

  @override
  String get openSettings => 'Apri Impostazioni';

  @override
  String get basketEmptyAction => 'Svuota il cestino';

  @override
  String get basketWatchingHere => 'In ascolto da qui 📍';

  @override
  String get noLocation => 'Impossibile ottenere la tua posizione.';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days giorni di fila! Il panda è fiero.',
      one: '1 giorno di fila! Il panda è fiero.',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return '+$earned 🎋 bambù per il panda ($balance nella scorta)';
  }

  @override
  String bambooFull(int cap) {
    return 'La scorta di bambù è piena ($cap). Rimanda qualcosa, o continua così!';
  }

  @override
  String get deleted => 'Eliminato';

  @override
  String get undo => 'Annulla';

  @override
  String get wokenUp => 'Svegliato in anticipo.';

  @override
  String nudgeAt(String time) {
    return 'Il panda ti darà un colpetto alle $time.';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'Bambù insufficiente per rimandare (servono $cost, ne hai $balance). Completa un\'attività per guadagnarne 🎋';
  }

  @override
  String snoozed(int cost) {
    return 'Rimandato a domani · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return 'Spostare così vicino alla scadenza costa $cost 🎋, e la scorta è vuota.';
  }

  @override
  String deadlineMoved(String when) {
    return 'Scadenza spostata: $when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return 'Scadenza spostata: $when · −$cost 🎋';
  }

  @override
  String get cancel => 'Annulla';

  @override
  String get set => 'Imposta';

  @override
  String get ok => 'OK';

  @override
  String get noCloudsYet =>
      'Ancora nessuna nuvola. Tocca \"+ categoria\" accanto al panda.';

  @override
  String get noCategory => 'Nessuna categoria';

  @override
  String filedUnder(String name) {
    return 'Archiviato in $name ☁️';
  }

  @override
  String get newCloud => 'Nuova nuvola categoria';

  @override
  String get rename => 'Rinomina';

  @override
  String get renameCloud => 'Rinomina nuvola';

  @override
  String get removeCloud => 'Rimuovi nuvola';

  @override
  String get removeCloudInfo => 'Le voci restano, solo senza categoria';

  @override
  String get cloudNameHint => 'es. Casa, Lavoro, Spesa';

  @override
  String get micNeeded =>
      'Red Panda ha bisogno del microfono. Consentilo in [Impostazioni](microphone).';

  @override
  String get recordFailed => 'Impossibile avviare la registrazione.';

  @override
  String get search => 'Cerca';

  @override
  String get closeSearch => 'Chiudi ricerca';

  @override
  String get settings => 'Impostazioni';

  @override
  String get newTextNote => 'Nuova nota di testo';

  @override
  String onlyCategory(String name) {
    return 'Solo $name';
  }

  @override
  String get onlyBasket => 'Solo il cestino da portare';

  @override
  String get emptyBasketList =>
      'Il cestino da portare è vuoto. Trascina le voci sul cestino per ricordartele quando esci.';

  @override
  String emptyCategoryDay(String name) {
    return 'Niente in $name. Trascina una voce sulla sua nuvola, o tocca il sole per vedere tutto.';
  }

  @override
  String emptyCategoryNight(String name) {
    return 'Niente in $name. Trascina una voce sulla sua nuvola, o tocca la luna per vedere tutto.';
  }

  @override
  String get noNotes =>
      'Ancora nessuna nota. Creane una dalla schermata di blocco o dal tasto Azione, oppure tocca +.';

  @override
  String get hideSnoozed => 'Nascondi rimandati';

  @override
  String showSnoozed(int count) {
    return '$count rimandati · mostra';
  }

  @override
  String get undoCheck => 'Togli la spunta';

  @override
  String get wakeUp => 'Sveglia';

  @override
  String streakChip(int days) {
    return '🔥 $days g';
  }

  @override
  String tickedToday(int count) {
    return '✓ $count oggi';
  }

  @override
  String get bambooTooltip =>
      'Bambù: lo guadagni completando attività, lo spendi per rimandare';

  @override
  String level(int level) {
    return 'Liv. $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 Il panda è triste: $count in ritardo';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ $count in scadenza oggi. Il panda tiene d\'occhio.';
  }

  @override
  String get recordVoice => 'Registra una nota vocale';

  @override
  String get stopVoice => 'Ferma e salva la nota vocale';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 fino a $time';
  }

  @override
  String get edit => 'Modifica';

  @override
  String get done => 'Fatto';

  @override
  String get tickOff => 'Spunta';

  @override
  String get inLeaveBasket => 'Nel cestino da portare';

  @override
  String daysLate(int days) {
    return '$days g di ritardo';
  }

  @override
  String get today => 'oggi';

  @override
  String daysShort(int days) {
    return '$days g';
  }

  @override
  String dueOn(String date) {
    return 'Scade: $date';
  }

  @override
  String get dragHint => 'Trascina per riordinare o su una nuvola categoria';

  @override
  String get noteHint => 'Nota';

  @override
  String get newNoteHint => 'Nuova nota';

  @override
  String get deadline => 'Scadenza';

  @override
  String get leaveBasket => 'Cestino da portare';

  @override
  String get leaveBasketTooltip => 'Ricordamelo quando lascio questo posto';

  @override
  String get save => 'Salva';

  @override
  String get add => 'Aggiungi';

  @override
  String get turnDial => 'Gira la rotella';

  @override
  String get clear => 'Cancella';

  @override
  String cloudSemantics(String name, int count) {
    return 'Categoria $name, $count aperte';
  }

  @override
  String get cloudHintShowAll => 'Tocca due volte per vedere tutto';

  @override
  String get cloudHintOnly =>
      'Tocca due volte per vedere solo questa categoria';

  @override
  String get addCategory => 'Aggiungi una categoria';

  @override
  String get plusCategory => '+ categoria';

  @override
  String get sun => 'Sole';

  @override
  String get moon => 'Luna';

  @override
  String get showsAllItems => 'Mostra tutte le voci';

  @override
  String get noDeadline => 'nessuna scadenza';

  @override
  String get tomorrow => 'domani';

  @override
  String inDays(int days) {
    return 'tra $days giorni';
  }

  @override
  String get noDate => 'nessuna data';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'giorni',
      one: 'giorno',
    );
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Cestino da portare, $count voci',
      one: 'Cestino da portare, 1 voce',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => ', in ascolto';

  @override
  String get basketHint =>
      'Rilascia qui le voci per ricordartele quando esci. Tocca due volte per filtrare.';

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
      'Con “Mentre usi l\'app”, iOS non dice nulla a Red Panda quando è chiusa, quindi il cestino potrebbe avvisarti solo con l\'app aperta. [“Sempre”](location) permette a iOS di svegliare Red Panda appena te ne vai.';

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
      '[Personalizza la schermata di blocco](lockScreenWidget) e tocca l\'area dei widget sotto l\'orologio (o la riga sopra) per aggiungere il widget di Red Panda con la tua prossima scadenza. Nella schermata Home [tieni premuto, tocca Modifica > Aggiungi widget](homeScreenWidget) e cerca “Red Panda”: i suoi pulsanti aggiungono una nota o mostrano il cestino del panda.';

  @override
  String get captureControlCentre => 'Centro di Controllo';

  @override
  String get captureControlCentreHow =>
      'Apri Centro di Controllo, tocca +, Aggiungi un controllo, cerca “Red Panda”.';

  @override
  String get captureActionButton => 'Tasto Azione';

  @override
  String get captureActionButtonHow =>
      '[Impostazioni > Tasto Azione > Controlli](actionButton), poi scegli Red Panda > Nota di testo, Nota vocale o Mostra il cestino del panda.';

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

  @override
  String get walkLocationTitle => 'Posizione: Sempre';

  @override
  String get walkMicrophoneTitle => 'Microfono e riconoscimento vocale';

  @override
  String get walkSiriTitle => 'Red Panda e Siri';

  @override
  String get walkActionButtonTitle => 'Red Panda sul tasto Azione';

  @override
  String get walkActionButtonNote =>
      'Sul tuo iPhone continua a scorrere fino a Controlli.';

  @override
  String walkSemantics(String path) {
    return 'Animazione del percorso in Impostazioni: $path';
  }

  @override
  String get walkLockScreenTitle => 'Red Panda sulla schermata di blocco';

  @override
  String get walkHomeScreenTitle => 'Red Panda nella schermata Home';

  @override
  String get walkLongPress => 'Tieni premuto';
}
