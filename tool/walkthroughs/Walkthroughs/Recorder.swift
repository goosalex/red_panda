import XCTest

/// Records how to reach Red Panda's settings in the iOS Settings app: one
/// screenshot per step, where the finger taps or swipes (normalised 0…1) and
/// the label of what is tapped, in the language given by WALK_LANG.
///
/// Run it through tool/walkthroughs/record.sh, which passes WALK_LANG and
/// WALK_OUT (as TEST_RUNNER_WALK_*), prepares the permissions and builds the
/// app assets. Elements are found by identifiers that stay the same in every
/// language; only the Action Button carousel is found by position.
final class Recorder: XCTestCase {
    let settings = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    var lang = "en"
    var out = URL(fileURLWithPath: NSTemporaryDirectory())
    var walk = ""
    var frames: [[String: Any]] = []

    override func setUp() {
        continueAfterFailure = false
        let env = ProcessInfo.processInfo.environment
        lang = env["WALK_LANG"] ?? "en"
        if let o = env["WALK_OUT"] { out = URL(fileURLWithPath: o) }
    }

    var rtl: Bool { lang == "ar" }

    // MARK: walkthroughs (ids match lib/ui/walkthrough.dart)

    func testLocation() throws {
        try record("location") {
            open("com.apple.settings.privacyAndSecurity")
            step(settings.buttons["LOCATION"])
            step(settings.cells["Red Panda"])
            step(settings.staticTexts["LOCATION_SERVICES_AUTH_ALWAYS"])
        }
    }

    func testMicrophone() throws {
        try record("microphone") {
            open("com.apple.settings.privacyAndSecurity")
            step(settings.buttons["MICROPHONE"])
            step(settings.switches["Red Panda"], press: false)
            back()
            step(settings.buttons["SPEECH_RECOGNITION"])
            step(settings.switches["Red Panda"], press: false)
        }
    }

    func testSiri() throws {
        try record("siri") {
            open("com.apple.settings.siri")
            let apps = settings.cells.allElementsBoundByIndex.last!
            step(apps)
            step(settings.staticTexts["ch.masdatos.redpanda"])
        }
    }

    func testActionButton() throws {
        try record("actionButton") {
            open("com.apple.settings.actionButton")
            for _ in 0..<4 { page(forward: false) }
            // Silent Mode, then Controls. An iPhone has more pages in between
            // than the simulator: the recorded swipe stands for "swipe to Controls".
            swipe()
            let choose = settings.buttons.allElementsBoundByIndex.first { $0.frame.minY > 600 && $0.frame.minY < 720 }!
            step(choose)
            step(settings.searchFields.firstMatch)
            // One word (no autocorrect after a space); the search matches whole words.
            settings.typeText("Panda")
            sleep(2)
            step(settings.buttons["ch.masdatos.redpanda.control.text"])
        }
    }

    // MARK: recording

    func record(_ id: String, _ body: () -> Void) throws {
        walk = id
        frames = []
        try? FileManager.default.removeItem(at: folder)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        settings.terminate()
        settings.launchArguments = ["-AppleLanguages", "(\(lang))", "-AppleLocale", locale]
        settings.launch()
        sleep(2)
        body()
        sleep(2)
        shot([:]) // how it looks in the end
        let data = try JSONSerialization.data(withJSONObject: ["lang": lang, "id": id, "frames": frames],
                                              options: [.prettyPrinted, .sortedKeys])
        try data.write(to: folder.appendingPathComponent("frames.json"))
        settings.terminate()
    }

    var folder: URL { out.appendingPathComponent("\(lang)/\(walk)") }

    var locale: String {
        ["en": "en_GB", "fr": "fr_FR", "de": "de_DE", "es": "es_MX", "it": "it_IT", "ja": "ja_JP", "ar": "ar_LB"][lang] ?? lang
    }

    /// Saves a screenshot, with what happens on it.
    func shot(_ info: [String: Any]) {
        let file = String(format: "%02d.png", frames.count)
        var info = info
        // The test runner is an app too and shows in app lists: build_assets.py removes its row.
        let runner = settings.descendants(matching: .any)
            .matching(NSPredicate(format: "identifier ENDSWITH '.xctrunner'")).firstMatch
        if runner.exists, let cell = settings.cells.containing(.any, identifier: runner.identifier).allElementsBoundByIndex.first {
            let f = cell.frame
            info["hide"] = ["y": Double((f.minY - screen.minY) / screen.height), "h": Double(f.height / screen.height)]
        }
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: folder.appendingPathComponent(file))
        info["image"] = file
        frames.append(info)
    }

    var screen: CGRect { settings.windows.firstMatch.frame }

    func point(_ p: CGPoint) -> [String: Double] {
        ["x": Double((p.x - screen.minX) / screen.width), "y": Double((p.y - screen.minY) / screen.height)]
    }

    /// Records a tap on [el], then taps it (unless [press] is false: a switch
    /// that is already on stays on).
    func step(_ el: XCUIElement, press: Bool = true) {
        _ = el.waitForExistence(timeout: 4)
        for _ in 0..<10 where !visible(el) { scroll() }
        if !el.exists {
            try? XCUIScreen.main.screenshot().pngRepresentation.write(to: folder.appendingPathComponent("failed.png"))
        }
        XCTAssertTrue(el.exists, "missing \(el)")
        let f = el.frame
        var label = el.label
        // A row's label can carry its value after a comma ("Location Services, 1 always").
        if el.elementType == .button, let i = label.firstIndex(of: ",") { label = String(label[..<i]) }
        shot(["tap": point(CGPoint(x: f.midX, y: f.midY)), "label": label])
        if press { el.tap(); sleep(2) }
    }

    func open(_ id: String) {
        step(settings.buttons[id])
    }

    /// Fully on screen, clear of the home indicator.
    func visible(_ el: XCUIElement) -> Bool {
        el.exists && el.isHittable && el.frame.maxY < screen.maxY - 80 && el.frame.minY > screen.minY + 100
    }

    /// A gentle scroll down, so rows are not flung past.
    func scroll() {
        let w = settings.windows.firstMatch
        w.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75))
            .press(forDuration: 0.05, thenDragTo: w.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)),
                   withVelocity: 600, thenHoldForDuration: 0.3)
        sleep(1)
    }

    func back() {
        settings.navigationBars.firstMatch.buttons.firstMatch.tap()
        sleep(2)
    }

    /// One page of the Action Button carousel, not recorded.
    func page(forward: Bool) {
        let leftward = forward != rtl
        let w = settings.windows.firstMatch
        let a = w.coordinate(withNormalizedOffset: CGVector(dx: leftward ? 0.6 : 0.4, dy: 0.62))
        let b = w.coordinate(withNormalizedOffset: CGVector(dx: leftward ? 0.4 : 0.6, dy: 0.62))
        a.press(forDuration: 0.05, thenDragTo: b, withVelocity: 300, thenHoldForDuration: 0.1)
        sleep(1)
    }

    /// A recorded swipe to the next carousel page.
    func swipe() {
        let from = rtl ? 0.25 : 0.75, to = rtl ? 0.75 : 0.25
        shot(["swipe": ["from": ["x": from, "y": 0.62], "to": ["x": to, "y": 0.62]]])
        page(forward: true)
    }
}

/// Puts the clean base simulator into the state every recording starts from:
/// Red Panda has asked for speech recognition (after a first voice note), so
/// it is listed under Privacy & Security > Speech Recognition.
final class Prepare: XCTestCase {
    func testPermissions() {
        let app = XCUIApplication(bundleIdentifier: "ch.masdatos.redpanda")
        app.launchArguments = ["-AppleLanguages", "(en)"]
        app.launch()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        func allow() {
            let alert = springboard.alerts.firstMatch
            if alert.waitForExistence(timeout: 3) { alert.buttons.allElementsBoundByIndex.last?.tap() }
        }
        allow() // notifications, if asked at launch
        let record = app.buttons["Record a voice note"]
        XCTAssertTrue(record.waitForExistence(timeout: 10))
        // Tap by position: the button's label changes once it records.
        let w = app.windows.firstMatch.frame, f = record.frame
        let spot = app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(
            dx: (f.midX - w.minX) / w.width, dy: (f.midY - w.minY) / w.height))
        spot.tap()
        allow()
        sleep(3)
        spot.tap() // the same button now stops and saves
        allow() // speech recognition
        sleep(2)
        app.terminate()
        discoverControls()
    }

    /// Opens the controls gallery once and waits until iOS lists Red Panda's
    /// controls (a fresh install takes a while), then closes it unchosen.
    func discoverControls() {
        let s = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        s.terminate()
        s.launchArguments = ["-AppleLanguages", "(en)"]
        s.launch()
        let ab = s.buttons["com.apple.settings.actionButton"]
        XCTAssertTrue(ab.waitForExistence(timeout: 10))
        ab.tap()
        sleep(2)
        let w = s.windows.firstMatch
        func drag(_ from: Double, _ to: Double) {
            w.coordinate(withNormalizedOffset: CGVector(dx: from, dy: 0.62))
                .press(forDuration: 0.05, thenDragTo: w.coordinate(withNormalizedOffset: CGVector(dx: to, dy: 0.62)),
                       withVelocity: 300, thenHoldForDuration: 0.1)
            sleep(1)
        }
        for _ in 0..<4 { drag(0.4, 0.6) }
        drag(0.6, 0.4)
        s.buttons["Choose a Control…"].tap()
        let control = s.buttons["ch.masdatos.redpanda.control.text"]
        for _ in 0..<12 where !control.exists {
            let field = s.searchFields.firstMatch
            field.tap()
            if let v = field.value as? String, !v.isEmpty, v != field.placeholderValue { field.buttons.firstMatch.tap() }
            field.typeText("Panda")
            if control.waitForExistence(timeout: 5) { break }
            s.buttons["Cancel"].firstMatch.tap()
            sleep(5)
        }
        XCTAssertTrue(control.exists, "iOS never listed Red Panda's controls")
        s.terminate()
    }
}
