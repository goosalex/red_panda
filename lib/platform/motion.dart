import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Device tilt for the mascot's ears (iOS MotionStreamHandler, Motion.swift).
class Motion {
  static const _channel = EventChannel('red_panda/motion');

  /// While listened: ~30 updates per second from gravity, smoothed, each
  /// axis in -1..1.
  ///  dx: side to side (-1 tipped fully left, +1 fully right).
  ///  dy: forward/back around a ~45° reading angle (+1 upright, -1 flat).
  /// Sensors stop when the subscription is cancelled. Empty (no error) in
  /// tests, on other platforms, on the simulator, or when anything fails.
  static Stream<Offset> tilt() {
    // EventChannel reports a missing native side through FlutterError
    // (fails widget tests), so only listen where the handler exists.
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.iOS) {
      return const Stream<Offset>.empty();
    }
    late StreamController<Offset> controller;
    StreamSubscription<dynamic>? sub;
    controller = StreamController<Offset>(
      onListen: () {
        try {
          sub = _channel.receiveBroadcastStream().listen(
            (event) {
              if (event is List && event.length >= 2) {
                final x = event[0], y = event[1];
                if (x is num && y is num) {
                  controller.add(Offset(x.toDouble(), y.toDouble()));
                }
              }
            },
            onError: (Object _) {},
            onDone: controller.close,
            cancelOnError: false,
          );
        } catch (_) {
          controller.close();
        }
      },
      onCancel: () async {
        try {
          await sub?.cancel();
        } catch (_) {
          // MissingPluginException on cancel without native side.
        }
      },
    );
    return controller.stream;
  }
}
