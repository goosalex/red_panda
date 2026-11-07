import AppIntents
import CoreLocation
import Foundation
import Network
import UIKit
import UserNotifications

/// Leave basket: reminds about the basket's items when the user leaves the
/// place where the basket was armed (a circle of the chosen radius) or the
/// Wi-Fi connection drops. One notification, then it disarms; Dart re-arms at
/// the current place the next time it syncs a non-empty basket.
///
/// - Place: CLMonitor circular condition. It also relaunches the app in the
///   background, which needs "Always" location permission.
/// - Wi-Fi: NWPathMonitor while the app is running. iOS gives apps no
///   background Wi-Fi trigger; for that the user can add a Shortcuts
///   automation (Wi-Fi > Leaves) that runs RemindLeaveBasketIntent.
@MainActor
final class LeaveBasket: NSObject, CLLocationManagerDelegate {
  static let shared = LeaveBasket()

  private static let conditionId = "leave-basket-here"
  private static let notificationId = "ch.masdatos.redpanda.leave"
  private let defaults = UserDefaults.standard
  private let manager = CLLocationManager()
  private var monitor: CLMonitor?
  private var monitorTask: Task<Void, Never>?
  private var path: NWPathMonitor?
  private var wasOnWifi = false
  private var authWaiters: [CheckedContinuation<Void, Never>] = []
  private var locationWaiters: [CheckedContinuation<CLLocation?, Never>] = []

  private enum Key {
    static let titles = "leave.titles"
    static let armed = "leave.armed"
    static let armedAt = "leave.armedAt"
    static let radius = "leave.radius"
    static let onPlace = "leave.onPlace"
    static let onWifi = "leave.onWifi"
    static let lastFired = "leave.lastFired"
    static let askedAlways = "leave.askedAlways"
  }

  override private init() {
    super.init()
    manager.delegate = self
    manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
  }

  // MARK: Launch

  /// Called at app launch: re-opens the location monitor so exit events that
  /// relaunched the app in the background are delivered, and resumes Wi-Fi
  /// watching when armed.
  func start() {
    guard monitorTask == nil else { return }
    monitorTask = Task { await self.listen() }
    if armed && onWifi { startWifi() }
  }

  private func listen() async {
    let m = await readyMonitor()
    do {
      for try await event in await m.events where event.identifier == Self.conditionId {
        if event.state == .unsatisfied { await fire(reason: "place") }
      }
    } catch {
      // Monitor ended; it is recreated on the next launch.
    }
  }

  private func readyMonitor() async -> CLMonitor {
    if let m = monitor { return m }
    let m = await CLMonitor("RedPandaLeaveBasket")
    if let existing = monitor { return existing }  // created meanwhile
    monitor = m
    return m
  }

  // MARK: State

  private var armed: Bool {
    get { defaults.bool(forKey: Key.armed) }
    set { defaults.set(newValue, forKey: Key.armed) }
  }
  private var onPlace: Bool { defaults.object(forKey: Key.onPlace) as? Bool ?? true }
  private var onWifi: Bool { defaults.object(forKey: Key.onWifi) as? Bool ?? true }
  private var titles: [String] { defaults.stringArray(forKey: Key.titles) ?? [] }

  var permission: String {
    switch manager.authorizationStatus {
    case .notDetermined: return "notDetermined"
    case .denied, .restricted: return "denied"
    case .authorizedWhenInUse: return "whenInUse"
    case .authorizedAlways: return "always"
    @unknown default: return "unknown"
    }
  }

  func status() -> [String: Any] {
    var s: [String: Any] = ["armed": armed, "permission": permission]
    if let at = defaults.object(forKey: Key.armedAt) as? Date {
      s["armedAt"] = Int(at.timeIntervalSince1970 * 1000)
    }
    if armed { s["radius"] = defaults.integer(forKey: Key.radius) }
    return s
  }

  // MARK: Sync from Dart

  func sync(titles: [String], radius: Int, onPlace: Bool, onWifi: Bool, rearmHere: Bool) async
    -> [String: Any]
  {
    let settingsChanged =
      radius != defaults.integer(forKey: Key.radius) || onPlace != self.onPlace
      || onWifi != self.onWifi
    defaults.set(titles, forKey: Key.titles)
    defaults.set(onPlace, forKey: Key.onPlace)
    defaults.set(onWifi, forKey: Key.onWifi)

    if titles.isEmpty || (!onPlace && !onWifi) {
      if armed { await disarm() }
      return status()
    }
    if armed && !rearmHere && !settingsChanged { return status() }
    await arm(radius: radius, onPlace: onPlace, onWifi: onWifi)
    return status()
  }

  private func arm(radius: Int, onPlace: Bool, onWifi: Bool) async {
    await disarm()
    var ok = false
    if onPlace, await ensurePermission(), let here = await currentLocation() {
      let m = await readyMonitor()
      let condition = CLMonitor.CircularGeographicCondition(
        center: here.coordinate, radius: CLLocationDistance(max(radius, 25)))
      await m.add(condition, identifier: Self.conditionId, assuming: .satisfied)
      ok = true
    }
    if onWifi {
      startWifi()
      ok = true
    }
    armed = ok
    defaults.set(radius, forKey: Key.radius)
    if ok { defaults.set(Date(), forKey: Key.armedAt) }
  }

  private func disarm() async {
    if let m = monitor { await m.remove(Self.conditionId) }
    path?.cancel()
    path = nil
    armed = false
    defaults.removeObject(forKey: Key.armedAt)
  }

  // MARK: Wi-Fi

  private func startWifi() {
    path?.cancel()
    let p = NWPathMonitor()
    wasOnWifi = false
    p.pathUpdateHandler = { [weak self] path in
      let onWifiNow = path.status == .satisfied && path.usesInterfaceType(.wifi)
      Task { @MainActor in
        guard let self else { return }
        if self.wasOnWifi && !onWifiNow { await self.fire(reason: "wifi") }
        self.wasOnWifi = onWifiNow
      }
    }
    p.start(queue: .main)
    path = p
  }

  // MARK: Firing

  /// Posts the "before you go" notification for the open basket items, then
  /// disarms. Also used by the Shortcuts action (reason "shortcut"), which
  /// doesn't need the basket to be armed.
  func fire(reason: String) async {
    if reason != "shortcut", let last = defaults.object(forKey: Key.lastFired) as? Date,
      Date().timeIntervalSince(last) < 120
    {
      return  // place and Wi-Fi often trigger together: one reminder is enough
    }
    let items = currentBasketTitles()
    if reason != "shortcut" { await disarm() }
    guard !items.isEmpty else { return }
    defaults.set(Date(), forKey: Key.lastFired)

    let content = UNMutableNotificationContent()
    content.title = "🧺 Before you go…"
    let shown = items.prefix(4).joined(separator: ", ")
    let more = items.count > 4 ? " and \(items.count - 4) more" : ""
    content.body = "The red panda packed your basket: \(shown)\(more)."
    content.sound = .default
    let request = UNNotificationRequest(
      identifier: Self.notificationId, content: content, trigger: nil)
    try? await UNUserNotificationCenter.current().add(request)
  }

  /// Open basket items from disk (fresh), falling back to the titles Dart
  /// last sent (note files are unreadable while the phone is locked).
  private func currentBasketTitles() -> [String] {
    let notes = NoteStore.readAll()
    guard !notes.isEmpty else { return titles }
    let now = Date()
    return notes.filter {
      $0.leaveBasket == true && $0.doneAt == nil && !($0.snoozedUntil.map { $0 > now } ?? false)
    }
    .sorted { $0.createdAt > $1.createdAt }
    .map { ($0.text?.isEmpty == false ? $0.text : nil) ?? "Voice note" }
  }

  // MARK: Location plumbing

  /// Asks for "When In Use", then once for "Always" (needed to notice leaving
  /// while the app is closed). Returns whether any location access exists.
  private func ensurePermission() async -> Bool {
    if manager.authorizationStatus == .notDetermined {
      await withCheckedContinuation { c in
        authWaiters.append(c)
        manager.requestWhenInUseAuthorization()
      }
    }
    if manager.authorizationStatus == .authorizedWhenInUse, !defaults.bool(forKey: Key.askedAlways) {
      defaults.set(true, forKey: Key.askedAlways)
      manager.requestAlwaysAuthorization()
    }
    let s = manager.authorizationStatus
    return s == .authorizedAlways || s == .authorizedWhenInUse
  }

  private func currentLocation() async -> CLLocation? {
    if let recent = manager.location, -recent.timestamp.timeIntervalSinceNow < 30,
      recent.horizontalAccuracy <= 100
    {
      return recent
    }
    return await withCheckedContinuation { c in
      locationWaiters.append(c)
      manager.requestLocation()
    }
  }

  nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    let status = manager.authorizationStatus
    Task { @MainActor in
      guard status != .notDetermined else { return }
      let waiters = self.authWaiters
      self.authWaiters = []
      waiters.forEach { $0.resume() }
    }
  }

  nonisolated func locationManager(
    _ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]
  ) {
    let last = locations.last
    Task { @MainActor in
      let waiters = self.locationWaiters
      self.locationWaiters = []
      waiters.forEach { $0.resume(returning: last) }
    }
  }

  nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    Task { @MainActor in
      let waiters = self.locationWaiters
      self.locationWaiters = []
      waiters.forEach { $0.resume(returning: nil) }
    }
  }
}

/// Shortcuts action for an automation like "When my iPhone leaves Wi-Fi":
/// posts the leave basket reminder right away.
struct RemindLeaveBasketIntent: AppIntent {
  static let title: LocalizedStringResource = "Remind me of my leave basket"
  static let description = IntentDescription(
    "Shows a notification with the items in Red Panda's leave basket.")
  static let openAppWhenRun: Bool = false
  static let authenticationPolicy: IntentAuthenticationPolicy = .alwaysAllowed

  init() {}

  @MainActor
  func perform() async throws -> some IntentResult {
    await LeaveBasket.shared.fire(reason: "shortcut")
    return .result()
  }
}
