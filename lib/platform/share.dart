import 'package:flutter/services.dart';

/// Shares text through the iOS share sheet (AppDelegate 'share'); copies it
/// to the clipboard where that isn't available.
class NoteShare {
  static const _channel = MethodChannel('red_panda/app_group');

  static Future<void> share(String text) async {
    try {
      await _channel.invokeMethod<void>('share', {'text': text});
    } on MissingPluginException {
      await Clipboard.setData(ClipboardData(text: text));
    } on PlatformException {
      await Clipboard.setData(ClipboardData(text: text));
    }
  }
}
