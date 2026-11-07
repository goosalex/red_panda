import 'package:flutter/services.dart';

/// Requests from the Text note control (iOS OpenComposeIntent) to open the
/// compose sheet. Native keeps one pending flag; [take] reads and clears it,
/// and native pings 'compose' when the app is already running.
class ComposeRequests {
  static const channel = MethodChannel('red_panda/app_group');

  /// Calls [onPing] whenever native says a request may be waiting,
  /// [onNotesChanged] when native rewrote notes (e.g. a new transcript), and
  /// [onRecordingChanged] when a voice recording started or stopped.
  /// [onCloudChanged] when iCloud brought changes from another device.
  static void listen(VoidCallback onPing,
      {VoidCallback? onNotesChanged, VoidCallback? onRecordingChanged, VoidCallback? onCloudChanged}) {
    channel.setMethodCallHandler((call) async {
      if (call.method == 'compose') onPing();
      if (call.method == 'cloudChanged') onCloudChanged?.call();
      if (call.method == 'notesChanged') onNotesChanged?.call();
      if (call.method == 'recordingChanged') onRecordingChanged?.call();
    });
  }

  static void stopListening() => channel.setMethodCallHandler(null);

  /// Whether a compose request was waiting (and clears it).
  static Future<bool> take() => _take('takeCompose');

  /// Whether the "Panda's basket" control or widget button asked to show the
  /// leave basket (and clears it). Pinged like compose requests.
  static Future<bool> takeBasket() => _take('takeBasket');

  static Future<bool> _take(String method) async {
    try {
      return await channel.invokeMethod<bool>(method) ?? false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }
}

/// Speech to text for voice notes (iOS Transcriber in VoiceRecorder.swift).
class Transcripts {
  /// Asks native to transcribe waiting voice notes (may show the Speech
  /// permission prompt). Native pings 'notesChanged' when any were updated.
  static Future<void> transcribePending() async {
    try {
      await ComposeRequests.channel.invokeMethod<int>('transcribePending');
    } on MissingPluginException {
      // Tests / non-iOS.
    } on PlatformException {
      // Ignore: it is retried on the next start or resume.
    }
  }
}
