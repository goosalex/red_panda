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
  String get basketIn =>
      'En la canasta de salida 🧺 El panda te lo recuerda cuando salgas de este lugar.';

  @override
  String get basketOut => 'Fuera de la canasta de salida.';

  @override
  String get basketEmptyStatus =>
      'La canasta está vacía. Arrastra elementos para que te los recuerde al salir.';

  @override
  String get basketNeedsLocation =>
      'Red Panda necesita tu ubicación para saber cuándo sales. Permítela en Configuración.';

  @override
  String get basketWatching => 'Vigilando';

  @override
  String basketWatchingSince(String time) {
    return 'Vigilando (desde las $time)';
  }

  @override
  String basketReasonPlace(int radius) {
    return 'recibes un recordatorio cuando te alejes más de $radius m.';
  }

  @override
  String get basketReasonWifi =>
      'recibes un recordatorio cuando se pierda tu Wi-Fi.';

  @override
  String basketReasonBoth(int radius) {
    return 'recibes un recordatorio cuando te alejes más de $radius m o se pierda tu Wi-Fi.';
  }

  @override
  String get basketNotWatching =>
      'No estoy vigilando ahora. Toca \"Vigilar desde aquí\" para empezar.';

  @override
  String basketSheetTitle(int count) {
    return '🧺 Canasta de salida · $count';
  }

  @override
  String get basketNeedsAlways =>
      'Para notar que sales con Red Panda cerrado, pon la Ubicación en \"Siempre\" en Configuración.';

  @override
  String get basketWatchHere => 'Vigilar desde aquí';

  @override
  String get openSettings => 'Abrir Configuración';

  @override
  String get basketEmptyAction => 'Vaciar la canasta';

  @override
  String get basketWatchingHere => 'Vigilando desde aquí 📍';

  @override
  String get noLocation => 'No se pudo obtener tu ubicación.';

  @override
  String streakPraise(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '¡Racha de $days días! El panda está orgulloso.',
      one: '¡Racha de 1 día! El panda está orgulloso.',
    );
    return '$_temp0';
  }

  @override
  String bambooEarned(int earned, int balance) {
    return '+$earned 🎋 bambú para el panda ($balance en la reserva)';
  }

  @override
  String bambooFull(int cap) {
    return 'La reserva de bambú está llena ($cap). ¡Pospón algo o sigue así!';
  }

  @override
  String get deleted => 'Eliminado';

  @override
  String get undo => 'Deshacer';

  @override
  String get wokenUp => 'Despertado antes de tiempo.';

  @override
  String nudgeAt(String time) {
    return 'El panda te avisará a las $time.';
  }

  @override
  String snoozeTooPoor(int cost, int balance) {
    return 'No alcanza el bambú para posponer (necesitas $cost, tienes $balance). Termina una tarea para ganar más 🎋';
  }

  @override
  String snoozed(int cost) {
    return 'Pospuesto hasta mañana · −$cost 🎋';
  }

  @override
  String postponeTooPoor(int cost) {
    return 'Aplazar tan cerca de la fecha límite cuesta $cost 🎋, y la reserva está vacía.';
  }

  @override
  String deadlineMoved(String when) {
    return 'Fecha límite movida: $when';
  }

  @override
  String deadlineMovedCost(String when, int cost) {
    return 'Fecha límite movida: $when · −$cost 🎋';
  }

  @override
  String get cancel => 'Cancelar';

  @override
  String get set => 'Listo';

  @override
  String get ok => 'Aceptar';

  @override
  String get noCloudsYet =>
      'Aún no hay nubes. Toca \"+ categoría\" junto al panda.';

  @override
  String get noCategory => 'Sin categoría';

  @override
  String filedUnder(String name) {
    return 'Guardado en $name ☁️';
  }

  @override
  String get newCloud => 'Nueva nube de categoría';

  @override
  String get rename => 'Cambiar nombre';

  @override
  String get renameCloud => 'Cambiar nombre de la nube';

  @override
  String get removeCloud => 'Quitar nube';

  @override
  String get removeCloudInfo =>
      'Sus elementos se quedan, solo que sin categoría';

  @override
  String get cloudNameHint => 'p. ej. Casa, Trabajo, Compras';

  @override
  String get micNeeded =>
      'Red Panda necesita el micrófono. Permítelo en Configuración > Red Panda.';

  @override
  String get recordFailed => 'No se pudo iniciar la grabación.';

  @override
  String get search => 'Buscar';

  @override
  String get closeSearch => 'Cerrar búsqueda';

  @override
  String get settings => 'Configuración';

  @override
  String get newTextNote => 'Nueva nota de texto';

  @override
  String onlyCategory(String name) {
    return 'Solo $name';
  }

  @override
  String get onlyBasket => 'Solo la canasta de salida';

  @override
  String get emptyBasketList =>
      'La canasta de salida está vacía. Arrastra elementos a la canasta para que te los recuerde al salir.';

  @override
  String emptyCategoryDay(String name) {
    return 'Nada en $name. Arrastra un elemento a su nube o toca el sol para ver todo.';
  }

  @override
  String emptyCategoryNight(String name) {
    return 'Nada en $name. Arrastra un elemento a su nube o toca la luna para ver todo.';
  }

  @override
  String get noNotes =>
      'Aún no hay notas. Crea una desde la pantalla bloqueada o el botón de acción, o toca +.';

  @override
  String get hideSnoozed => 'Ocultar pospuestos';

  @override
  String showSnoozed(int count) {
    return '$count pospuestos · ver';
  }

  @override
  String get undoCheck => 'Desmarcar';

  @override
  String get wakeUp => 'Despertar';

  @override
  String streakChip(int days) {
    return '🔥 $days d';
  }

  @override
  String tickedToday(int count) {
    return '✓ $count hoy';
  }

  @override
  String get bambooTooltip =>
      'Bambú: lo ganas terminando tareas y lo gastas en posponer';

  @override
  String level(int level) {
    return 'Nv. $level';
  }

  @override
  String pandaSadOverdue(int count) {
    return '🥺 El panda está triste: $count atrasados';
  }

  @override
  String dueTodayWatching(int count) {
    return '⏰ $count vencen hoy. El panda está atento.';
  }

  @override
  String get recordVoice => 'Grabar una nota de voz';

  @override
  String get stopVoice => 'Detener y guardar la nota de voz';

  @override
  String snoozedUntil(String time) {
    return ' · 💤 hasta $time';
  }

  @override
  String get edit => 'Editar';

  @override
  String get done => 'Hecho';

  @override
  String get tickOff => 'Marcar';

  @override
  String get inLeaveBasket => 'En la canasta de salida';

  @override
  String daysLate(int days) {
    return '$days d tarde';
  }

  @override
  String get today => 'hoy';

  @override
  String daysShort(int days) {
    return '$days d';
  }

  @override
  String dueOn(String date) {
    return 'Vence: $date';
  }

  @override
  String get dragHint => 'Arrastra para reordenar o a una nube de categoría';

  @override
  String get noteHint => 'Nota';

  @override
  String get newNoteHint => 'Nueva nota';

  @override
  String get deadline => 'Fecha límite';

  @override
  String get leaveBasket => 'Canasta de salida';

  @override
  String get leaveBasketTooltip => 'Recuérdamelo cuando salga de este lugar';

  @override
  String get save => 'Guardar';

  @override
  String get add => 'Agregar';

  @override
  String get turnDial => 'Gira el selector';

  @override
  String get clear => 'Borrar';

  @override
  String cloudSemantics(String name, int count) {
    return 'Categoría $name, $count pendientes';
  }

  @override
  String get cloudHintShowAll => 'Toca dos veces para ver todo';

  @override
  String get cloudHintOnly => 'Toca dos veces para ver solo esta categoría';

  @override
  String get addCategory => 'Agregar una categoría';

  @override
  String get plusCategory => '+ categoría';

  @override
  String get sun => 'Sol';

  @override
  String get moon => 'Luna';

  @override
  String get showsAllItems => 'Muestra todos los elementos';

  @override
  String get noDeadline => 'sin fecha límite';

  @override
  String get tomorrow => 'mañana';

  @override
  String inDays(int days) {
    return 'en $days días';
  }

  @override
  String get noDate => 'sin fecha';

  @override
  String dayUnit(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'días',
      one: 'día',
    );
    return '$_temp0';
  }

  @override
  String basketSemantics(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Canasta de salida, $count elementos',
      one: 'Canasta de salida, 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get basketWatchingSuffix => ', vigilando';

  @override
  String get basketHint =>
      'Suelta elementos aquí para que te los recuerde al salir. Toca dos veces para filtrar.';
}
