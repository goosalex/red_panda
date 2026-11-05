import 'package:flutter/services.dart';

import 'compose_requests.dart';

/// Why the mic button couldn't start recording.
enum RecordingError { noMicrophonePermission, failed }

class RecordingException implements Exception {
  RecordingException(this.error);
  final RecordingError error;
}

/// The app's mic button, recording through the iOS VoiceRecorder (the same
/// one the Voice note control uses, so both see one recording).
class VoiceRecording {
  static const _channel = ComposeRequests.channel;

  /// Starts recording; may show the microphone prompt the first time.
  static Future<void> start() async {
    try {
      await _channel.invokeMethod<void>('startRecording');
    } on PlatformException catch (e) {
      throw RecordingException(e.code == 'noMicrophonePermission'
          ? RecordingError.noMicrophonePermission
          : RecordingError.failed);
    } on MissingPluginException {
      throw RecordingException(RecordingError.failed);
    }
  }

  /// Stops and saves the voice note; completes after transcription.
  static Future<void> stop() async {
    try {
      await _channel.invokeMethod<void>('stopRecording');
    } on PlatformException {
      // The note is saved before transcription; nothing to tell the user.
    } on MissingPluginException {
      // Tests / non-iOS.
    }
  }

  /// When the current recording started, or null when not recording.
  static Future<DateTime?> startedAt() async {
    try {
      final ms = await _channel.invokeMethod<int>('recordingStartedAt');
      return ms == null ? null : DateTime.fromMillisecondsSinceEpoch(ms);
    } on MissingPluginException {
      return null;
    } on PlatformException {
      return null;
    }
  }
}
