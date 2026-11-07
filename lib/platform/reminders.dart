import 'package:flutter/services.dart';

import 'compose_requests.dart';

/// An open to-do the panda may nag about.
class ReminderItem {
  const ReminderItem({
    required this.id,
    required this.title,
    this.dueAt,
    this.remindAt,
  });

  final String id;
  final String title;
  final DateTime? dueAt;
  final DateTime? remindAt;

  Map<String, Object?> toMap() => {
    'id': id,
    'title': title,
    if (dueAt != null) 'dueAt': dueAt!.toUtc().toIso8601String(),
    if (remindAt != null) 'remindAt': remindAt!.toUtc().toIso8601String(),
  };
}

/// Local notifications and widget refreshes (iOS Reminders.swift).
/// Every call is a no-op in tests / on other platforms.
class Reminders {
  static const _channel = ComposeRequests.channel;

  /// Asks for alert + sound + badge permission; true if granted.
  static Future<bool> requestPermission() async {
    try {
      return await _channel.invokeMethod<bool>(
            'requestNotificationPermission',
          ) ??
          false;
    } on MissingPluginException {
      return false;
    } on PlatformException {
      return false;
    }
  }

  /// Replaces all scheduled Red Panda notifications. intensity 0 = off,
  /// 1 gentle, 2 normal, 3 persistent.
  /// quietStartHour/quietEndHour: local hours (e.g. 22 and 8) during which
  /// nothing fires (nudges shift to quietEndHour; an explicit remindAt fires
  /// at the chosen time).
  static Future<void> schedule(
    List<ReminderItem> openItems, {
    required int intensity,
    int quietStartHour = 22,
    int quietEndHour = 8,
  }) async {
    try {
      await _channel.invokeMethod<void>('scheduleReminders', {
        'items': [for (final i in openItems) i.toMap()],
        'intensity': intensity,
        'quietStartHour': quietStartHour,
        'quietEndHour': quietEndHour,
      });
    } on MissingPluginException {
      // Tests / non-iOS.
    } on PlatformException {
      // Ignore: rescheduled on the next change or start.
    }
  }

  /// Asks the Lock Screen / Home Screen widgets to re-read the notes.
  static Future<void> reloadWidgets() async {
    try {
      await _channel.invokeMethod<void>('reloadWidgets');
    } on MissingPluginException {
      // Tests / non-iOS.
    } on PlatformException {
      // Ignore.
    }
  }
}
