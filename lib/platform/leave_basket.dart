import 'package:flutter/services.dart';
import 'clock.dart';

/// State of the leave reminder on the native side.
class LeaveStatus {
  const LeaveStatus({
    this.armed = false,
    this.permission = LocationPermission.unknown,
    this.armedAt,
    this.radiusMeters,
  });

  /// Watching for leaving the place / the Wi-Fi.
  final bool armed;
  final LocationPermission permission;

  /// When the current place was taken as "here".
  final DateTime? armedAt;
  final int? radiusMeters;

  factory LeaveStatus.fromMap(Map<Object?, Object?> m) => LeaveStatus(
        armed: m['armed'] == true,
        permission: LocationPermission.values.firstWhere(
          (p) => p.name == m['permission'],
          orElse: () => LocationPermission.unknown,
        ),
        armedAt: m['armedAt'] is int ? DateTime.fromMillisecondsSinceEpoch(m['armedAt'] as int).add(clockOffset) : null,
        radiusMeters: m['radius'] as int?,
      );
}

/// Location permission as the leave reminder sees it. "always" is needed to
/// notice leaving while the app is closed.
enum LocationPermission { unknown, notDetermined, denied, whenInUse, always }

/// Leave basket reminder (iOS: ios/Runner/LeaveBasket.swift).
///
/// While the basket holds open items, native watches for leaving the place
/// where it was armed (a circle of the chosen radius) and for the Wi-Fi
/// dropping, then posts one notification listing the items and disarms. The
/// app re-arms at the current place the next time it syncs a non-empty basket
/// while disarmed.
class LeaveBasket {
  static const _channel = MethodChannel('red_panda/app_group');

  /// Arms (or updates) the reminder. Asks for location permission the first
  /// time. Keeps the current centre when already armed; [rearmHere] moves it
  /// to the current location.
  static Future<LeaveStatus> sync({
    required List<String> titles,
    required int radiusMeters,
    required bool onPlace,
    required bool onWifi,
    bool rearmHere = false,
  }) async {
    try {
      final m = await _channel.invokeMapMethod<Object?, Object?>('leaveBasketSync', {
        'titles': titles,
        'radius': radiusMeters,
        'onPlace': onPlace,
        'onWifi': onWifi,
        'rearmHere': rearmHere,
      });
      return m == null ? const LeaveStatus() : LeaveStatus.fromMap(m);
    } on MissingPluginException {
      return const LeaveStatus();
    } on PlatformException {
      return const LeaveStatus();
    }
  }

  static Future<LeaveStatus> status() async {
    try {
      final m = await _channel.invokeMapMethod<Object?, Object?>('leaveBasketStatus');
      return m == null ? const LeaveStatus() : LeaveStatus.fromMap(m);
    } on MissingPluginException {
      return const LeaveStatus();
    } on PlatformException {
      return const LeaveStatus();
    }
  }

  /// Opens the app's page in the iOS Settings (to allow "Always" location).
  static Future<void> openSettings() async {
    try {
      await _channel.invokeMethod<void>('openAppSettings');
    } on MissingPluginException {
      // Tests.
    } on PlatformException {
      // Ignore.
    }
  }
}
