import 'package:flutter/services.dart';

/// Deep links into Apple's Shortcuts app, for wiring Red Panda's actions to
/// automations (Wi-Fi, location) that iOS doesn't let apps watch themselves.
///
/// The automation links are not documented by Apple but work on iOS 17/18
/// (checked on iOS 18.3): `create-automation` opens the "New Automation"
/// trigger list, `automations` the Automation tab. If a link fails, the
/// Shortcuts app is opened instead.
class ShortcutsLinks {
  static const channel = MethodChannel('red_panda/app_group');

  static const newAutomation = 'shortcuts://create-automation';
  static const automations = 'shortcuts://automations';
  static const app = 'shortcuts://';

  /// Name of the Red Panda action as it appears in Shortcuts
  /// (RemindLeaveBasketIntent in ios/Runner/LeaveBasket.swift).
  static const remindAction = 'Remind me of my leave basket';

  /// Opens [url]; falls back to the Shortcuts app. Returns whether anything
  /// opened.
  static Future<bool> open(String url) async {
    if (await _open(url)) return true;
    return url != app && await _open(app);
  }

  /// Opens any URL (e.g. a web page in Safari), without the fallback.
  static Future<bool> openExternal(String url) => _open(url);

  static Future<bool> _open(String url) async {
    try {
      return await channel.invokeMethod<bool>('openUrl', {'url': url}) ?? false;
    } on MissingPluginException {
      return false; // Tests.
    } on PlatformException {
      return false;
    }
  }
}
