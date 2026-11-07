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
}
