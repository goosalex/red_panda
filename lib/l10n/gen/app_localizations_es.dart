// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Red Panda';

  @override
  String get swipeSnooze => 'Posponer hasta mañana';

  @override
  String get swipeSnoozeInfo =>
      'Oculta el elemento hasta mañana en la mañana. Cuesta bambú.';

  @override
  String get swipePostpone => 'Aplazar la fecha límite un día';

  @override
  String get swipePostponeInfo =>
      'Gratis mientras la fecha está lejos; cuesta bambú cuando se acerca.';

  @override
  String get swipePin => 'Fijar arriba';

  @override
  String get swipePinInfo => 'Mueve el elemento al principio de la lista.';

  @override
  String get swipeCategory => 'Mover a categoría';

  @override
  String get swipeCategoryInfo => 'Elige una nube para el elemento.';

  @override
  String get swipeDeadline => 'Poner fecha límite';

  @override
  String get swipeDeadlineInfo => 'Abre el selector de días a partir de hoy.';

  @override
  String get swipeRemindLater => 'Recordarme más tarde hoy';

  @override
  String get swipeRemindLaterInfo => 'Un recordatorio único en tres horas.';

  @override
  String get swipeDuplicate => 'Duplicar';

  @override
  String get swipeDuplicateInfo =>
      'Copia el elemento, útil para tareas que se repiten.';

  @override
  String get swipeBasket => 'Poner en la canasta de salida';

  @override
  String get swipeBasketInfo =>
      'Te lo recuerda cuando sales de este lugar o de tu Wi-Fi.';

  @override
  String get swipeShare => 'Compartir';

  @override
  String get swipeShareInfo => 'Comparte el elemento como texto.';

  @override
  String get nagOff => 'Desactivado';

  @override
  String get nagGentle => 'Suave';

  @override
  String get nagNormal => 'Normal';

  @override
  String get nagPersistent => 'Insistente';

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get settingsHeaderList => 'Lista';

  @override
  String get settingsHeaderReminders => 'Recordatorios';

  @override
  String get settingsHeaderPanda => 'Panda';

  @override
  String get settingsCloudSync => 'Sincronización con iCloud';

  @override
  String get settingsCloudNote =>
      'Las notas, notas de voz, categorías y el bambú se sincronizan por tu iCloud Drive con cada iPhone y iPad que use la misma cuenta de Apple. La configuración se queda en cada dispositivo.';

  @override
  String get settingsOn => 'Activado';

  @override
  String get settingsOff => 'Desactivado';

  @override
  String get settingsSwipeRight => 'Deslizar a la derecha';

  @override
  String get settingsSwipeDrawerTitle => 'Deslizar un elemento a la derecha';

  @override
  String get settingsSwipeDrawerNote =>
      'Los elementos marcados siempre se desmarcan; los pospuestos se despiertan.';

  @override
  String get settingsNag => 'Recordatorios del panda triste';

  @override
  String get settingsNagNote =>
      'Las notificaciones y los widgets te insisten a medida que se acercan las fechas límite.';

  @override
  String get settingsQuietFrom => 'Silencio desde';

  @override
  String get settingsQuietUntil => 'Silencio hasta';

  @override
  String get settingsLeaveBasket => 'Canasta de salida';

  @override
  String get settingsBambooRules => 'Reglas del bambú';

  @override
  String settingsBambooMax(int cap) {
    return 'Máx. $cap';
  }

  @override
  String get bambooTitle => '🎋 Bambú';

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
      other: '$freeDays días',
      one: '$freeDays día',
    );
    return 'Cada elemento terminado le da al panda $perCompletion 🎋 (+$earlyBonus si lo terminas antes del día límite). Posponer cuesta $snoozeCost 🎋; mover una fecha límite es gratis hasta $_temp0 antes, luego cuesta $lateCost 🎋. La reserva guarda como máximo $cap.';
  }

  @override
  String get settingsQuickCapture => 'Captura rápida';

  @override
  String get settingsQuickCaptureValue => 'Pantalla bloqueada, Siri…';

  @override
  String get settingsNews => 'Novedades';

  @override
  String newsVersion(String version) {
    return 'Versión $version';
  }

  @override
  String newsVersionNew(String version) {
    return 'Versión $version · nuevo';
  }

  @override
  String newsPr(int pr) {
    return 'PR #$pr';
  }

  @override
  String get cloudNotSignedIn => 'Sin sesión iniciada';

  @override
  String get cloudSyncing => 'Sincronizando…';

  @override
  String get cloudDownloading => 'Descargando…';

  @override
  String get cloudFailed => 'Falló, reintentando';

  @override
  String get basketTitle => '🧺 Canasta de salida';

  @override
  String get basketNote =>
      'Los elementos de la canasta te avisan en cuanto sales del lugar donde los pusiste o se cae tu Wi-Fi.';

  @override
  String get basketOnPlace => 'Cuando salga de este lugar';

  @override
  String get basketRadius => 'Radio';

  @override
  String get basketRadiusTitle => 'Avísame cuando esté a más de';

  @override
  String get basketRadiusNote =>
      'El iPhone te ubica con unos 100 m de precisión, así que un radio pequeño puede avisar un poco tarde.';

  @override
  String get basketOnWifi => 'Cuando se caiga mi Wi-Fi';

  @override
  String get basketLocationAccess => 'Acceso a la ubicación';

  @override
  String get locationAlways => 'Siempre';

  @override
  String get locationWhileUsing => 'Al usar la app';

  @override
  String get locationNotAsked => 'Aún no se pidió';

  @override
  String get basketWhyAlways => '¿Por qué “Siempre”?';

  @override
  String get basketNoTracking => 'Sin rastreo';

  @override
  String get basketHeaderShortcuts => 'Automatizaciones de Atajos';

  @override
  String get basketShortcutsNote =>
      'Red Panda solo nota que se cae el Wi-Fi mientras está abierta o se acaba de usar. Una automatización de Atajos lo detecta en cualquier momento y puede vigilar un lugar fijo, como tu casa.';

  @override
  String get automationWifi => 'Cuando salga de una red Wi-Fi';

  @override
  String get automationPlace => 'Cuando salga de un lugar';

  @override
  String get automationSetUp => 'Configurar';

  @override
  String get automationMine => 'Mis automatizaciones';

  @override
  String get shortcutsApp => 'Atajos';

  @override
  String get shortcutsOpen => 'Abrir Atajos';

  @override
  String get shortcutsRemindAction => 'Recordarme mi canasta de salida';

  @override
  String get guideOpenShortcuts =>
      'Toca “Abrir Atajos” abajo: se abre la lista Nueva automatización.';

  @override
  String get guideWifiScroll => 'Desplázate hacia abajo y toca Wi-Fi.';

  @override
  String get guideWifiNetwork =>
      'Elige tu red, marca “Se desconecta” y desmarca “Se conecta”.';

  @override
  String get guideRunImmediately =>
      'Elige “Ejecutar de inmediato” y luego toca Siguiente.';

  @override
  String get guidePlaceLeave =>
      'Toca Salir, luego Ubicación > Elegir, y elige el lugar (por ejemplo, casa).';

  @override
  String guideAddAction(String action) {
    return 'Toca “Nueva automatización en blanco”, luego Agregar acción, busca “canasta de salida” y elige “$action”.';
  }

  @override
  String get guideDone =>
      'Toca OK. Desde ahora el panda te recuerda tu canasta.';

  @override
  String get locationInfoTitle => '¿Por qué la ubicación “Siempre”?';

  @override
  String get locationInfoLeaveTitle => 'Solo para notar que te vas';

  @override
  String get locationInfoLeaveBody =>
      'Con “Al usar la app”, iOS no le avisa nada a Red Panda cuando está cerrada, así que la canasta solo podría avisarte con la app abierta. “Siempre” deja que iOS despierte a Red Panda en cuanto te vas.';

  @override
  String get locationInfoBatteryTitle => 'No gasta batería';

  @override
  String get locationInfoBatteryBody =>
      'Red Panda no te sigue. Le pregunta a iOS una sola vez dónde estás y dibuja un círculo alrededor. iOS vigila ese círculo con las señales celulares y Wi-Fi que usa de todos modos, y Red Panda duerme hasta que cruzas el borde. Luego se borra el círculo.';

  @override
  String get locationInfoPrivacyTitle => 'Tu ubicación se queda en tu iPhone';

  @override
  String get locationInfoPrivacyBody =>
      'Red Panda no tiene servidor y no envía tu ubicación a ningún lado. Solo se guarda el centro del círculo, en este dispositivo, hasta que salta el aviso. La sincronización con iCloud nunca lo incluye.';

  @override
  String get locationInfoWifiTitle => 'El Wi-Fi no necesita ubicación';

  @override
  String get locationInfoWifiBody =>
      '“Cuando se caiga mi Wi-Fi” funciona sin acceso a la ubicación.';

  @override
  String get captureLockScreen => 'Botones de la pantalla bloqueada';

  @override
  String get captureLockScreenHow =>
      'Mantén presionada la pantalla bloqueada, toca Personalizar > Pantalla bloqueada, toca un espacio de control abajo y elige Red Panda > Nota de texto, Nota de voz o Ver la canasta del panda.';

  @override
  String get captureWidgets => 'Widgets';

  @override
  String get captureWidgetsHow =>
      'Personaliza la pantalla bloqueada y toca la zona de widgets bajo el reloj (o la línea de arriba) para agregar el widget de Red Panda con tu próxima fecha límite. En la pantalla de inicio, mantén presionado, toca Editar > Agregar widget y busca “Red Panda”: sus botones agregan una nota o muestran la canasta del panda.';

  @override
  String get captureControlCentre => 'Centro de control';

  @override
  String get captureControlCentreHow =>
      'Abre el Centro de control, toca +, Agregar un control y busca “Red Panda”.';

  @override
  String get captureActionButton => 'Botón de acción';

  @override
  String get captureActionButtonHow =>
      'Configuración > Botón de acción > Controles, luego elige Red Panda > Nota de texto, Nota de voz o Ver la canasta del panda.';

  @override
  String get captureSiri => 'Siri';

  @override
  String get captureSiriHow =>
      'Di “Nota con Red Panda”, “Nota de voz con Red Panda” o “Muestra mi canasta de Red Panda”.';

  @override
  String capturePreview(String spot) {
    return 'Vista previa: $spot';
  }

  @override
  String get captureLinkMicrophone => 'Micrófono y reconocimiento de voz';

  @override
  String get captureLinkSiri => 'Siri y Buscar';

  @override
  String get wifi => 'Wi-Fi';
}
