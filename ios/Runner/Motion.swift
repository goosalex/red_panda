import CoreMotion
import Flutter
import Foundation

/// EventChannel 'red_panda/motion' (lib/platform/motion.dart): while Dart
/// listens, emits [x, y] at ~30 Hz from gravity, smoothed, each in -1...1.
///  x: roll, side to side (-1 tipped fully left, +1 fully right).
///  y: pitch around a natural ~45° reading angle (+1 upright, -1 lying flat
///     face up; face down / upside down clamp).
/// Without a motion sensor (simulator) nothing is emitted.
final class MotionStreamHandler: NSObject, FlutterStreamHandler {
  private let manager = CMMotionManager()
  private var smoothed: (x: Double, y: Double)?
  private static let interval = 1.0 / 30.0
  private static let alpha = 0.25  // low-pass factor per sample

  func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink)
    -> FlutterError?
  {
    stop()
    if manager.isDeviceMotionAvailable {
      manager.deviceMotionUpdateInterval = Self.interval
      manager.startDeviceMotionUpdates(to: .main) { [weak self] motion, _ in
        guard let g = motion?.gravity else { return }
        self?.emit(gx: g.x, gy: g.y, gz: g.z, events)
      }
    } else if manager.isAccelerometerAvailable {
      // Raw acceleration includes gravity; the low-pass filter removes most shake.
      manager.accelerometerUpdateInterval = Self.interval
      manager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
        guard let a = data?.acceleration else { return }
        self?.emit(gx: a.x, gy: a.y, gz: a.z, events)
      }
    }
    return nil
  }

  func onCancel(withArguments arguments: Any?) -> FlutterError? {
    stop()
    return nil
  }

  private func stop() {
    if manager.isDeviceMotionActive { manager.stopDeviceMotionUpdates() }
    if manager.isAccelerometerActive { manager.stopAccelerometerUpdates() }
    smoothed = nil
  }

  private func emit(gx: Double, gy: Double, gz: Double, _ events: FlutterEventSink) {
    let x = clamp(gx)
    // 0° flat face up, 90° upright; 45° maps to 0.
    let pitch = atan2(-gy, -gz)
    let y = clamp((pitch - .pi / 4) / (.pi / 4))
    let s: (x: Double, y: Double)
    if let p = smoothed {
      s = (p.x + Self.alpha * (x - p.x), p.y + Self.alpha * (y - p.y))
    } else {
      s = (x, y)
    }
    smoothed = s
    events([s.x, s.y])
  }

  private func clamp(_ v: Double) -> Double { v.isFinite ? min(1, max(-1, v)) : 0 }
}
