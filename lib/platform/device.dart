import 'package:flutter/services.dart';

/// What kind of device the app runs on.
class Device {
  static const _channel = MethodChannel('red_panda/app_group');

  /// An iPad: no Action Button, more room. Not the window size (Split View
  /// can make an iPad window phone-narrow), so read once from iOS.
  static bool isPad = false;

  static Future<void> load() async {
    try {
      isPad = await _channel.invokeMethod<bool>('isPad') ?? false;
    } catch (_) {
      // Tests and other platforms: a phone.
    }
  }
}
