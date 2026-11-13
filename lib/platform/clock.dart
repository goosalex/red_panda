/// The time the app shows: `DateTime.now()`, except in App Store screenshot
/// builds. tool/screenshots/shoot.sh builds with `--dart-define=SHOT_TIME=09:41`
/// so the panda, the sky and the dates match the 9:41 status bar whenever the
/// screenshots are taken. Release builds never set it.
library;

const _shotTime = String.fromEnvironment('SHOT_TIME');

/// How far the shown time is from the real time (zero unless SHOT_TIME is set).
final Duration clockOffset = _offset(_shotTime);

Duration _offset(String hhmm) {
  final m = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(hhmm);
  if (m == null) return Duration.zero;
  final n = DateTime.now();
  return DateTime(n.year, n.month, n.day, int.parse(m.group(1)!), int.parse(m.group(2)!)).difference(n);
}

/// Use instead of `DateTime.now()` for anything the user sees.
DateTime clockNow() => DateTime.now().add(clockOffset);
