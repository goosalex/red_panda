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
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    /// Where the current walkthrough happens.
    lazy var app = settings
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

    func testHomeScreenWidget() throws {
        try record("homeScreenWidget", springboard: true) {
            longPress(x: 0.5, y: 0.62)
            // Edit (top corner), then its menu's first item, Add Widget.
            step(editDone()[0])
            var menu: [XCUIElement] = []
            for _ in 0..<10 where menu.isEmpty {
                sleep(1)
                menu = springboard.buttons.allElementsBoundByIndex
                    .filter { $0.frame.width > 200 && $0.frame.height > 35 && $0.frame.minY > 50 && $0.frame.minY < 220 }
                    .sorted { $0.frame.minY < $1.frame.minY }
            }
            XCTAssertFalse(menu.isEmpty, "Edit menu")
            step(menu[0])
            let search = springboard.searchFields.matching(NSPredicate(format: "identifier != 'dewey-search-field'")).firstMatch
            step(search)
            springboard.typeText("Panda")
            sleep(2)
            step(springboard.cells["Red Panda"])
            step(springboard.buttons.allElementsBoundByIndex.first { $0.frame.minY > 700 && $0.frame.width > 300 }!)
            sleep(2)
            step(editDone()[1])
        }
    }

    /// The Home Screen's Edit and Done buttons in edit mode (in that order).
    func editDone() -> [XCUIElement] {
        let b = springboard.buttons.allElementsBoundByIndex.filter {
            $0.frame.minY >= 0 && $0.frame.minY < 10 && abs($0.frame.height - 60) < 3 && $0.frame.width > 60
        }
        if b.count != 2 {
            print("TOPBUTTONS", springboard.buttons.allElementsBoundByIndex.prefix(12).map { "\($0.label) \($0.frame)" })
        }
        XCTAssertEqual(b.count, 2, "Edit and Done")
        return b
    }

    func testLockScreenWidget() throws {
        try record("lockScreenWidget", springboard: true) {
            XCUIDevice.shared.perform(NSSelectorFromString("pressLockButton"))
            sleep(2)
            XCUIDevice.shared.press(.home) // wakes up on the Lock Screen
            sleep(2)
            longPress(x: 0.5, y: 0.45)
            step(springboard.buttons["posterboard-customize-button"])
            step(springboard.cells.matching(NSPredicate(format: "identifier BEGINSWITH 'posterboard-posteruuid'")).element(boundBy: 0))
            sleep(2)
            step(springboard.buttons["grouped-widgets-reticle-view"])
            // The list is alphabetical: in some languages Red Panda is below the fold.
            let panda = springboard.cells["Red Panda"]
            _ = panda.waitForExistence(timeout: 4)
            for _ in 0..<4 where !(panda.exists && panda.isHittable) {
                shot(["swipe": ["from": ["x": 0.5, "y": 0.75], "to": ["x": 0.5, "y": 0.45]]])
                scroll()
            }
            step(panda)
            let widgets = springboard.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Red Panda'")).allElementsBoundByIndex
            step(widgets.max { $0.frame.width < $1.frame.width }!, labelFromValue: true) // the rectangular one
            // Close the widget list (its round button, top right; left in Arabic), then Done.
            let done = springboard.buttons["editing-done"]
            for _ in 0..<3 where !done.isHittable {
                sleep(1)
                springboard.buttons.allElementsBoundByIndex
                    .first { (rtl ? $0.frame.maxX < 72 : $0.frame.minX > 330) && $0.frame.width < 50 && $0.frame.minY > 300 && $0.isHittable }?.tap()
            }
            sleep(1)
            step(springboard.buttons["editing-done"])
        }
    }

    // MARK: recording

    /// Records [body] in the Settings app, or on the Home and Lock Screen
    /// ([springboard]; the simulator itself is set to the language).
    func record(_ id: String, springboard: Bool = false, _ body: () -> Void) throws {
        walk = id
        frames = []
        try? FileManager.default.removeItem(at: folder)
        try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        if springboard {
            app = self.springboard
            XCUIDevice.shared.press(.home)
            sleep(2)
        } else {
            app = settings
            app.terminate()
            app.launchArguments = ["-AppleLanguages", "(\(lang))", "-AppleLocale", locale]
            app.launch()
            sleep(2)
        }
        body()
        sleep(2)
        shot([:]) // how it looks in the end
        let data = try JSONSerialization.data(withJSONObject: ["lang": lang, "id": id, "frames": frames],
                                              options: [.prettyPrinted, .sortedKeys])
        try data.write(to: folder.appendingPathComponent("frames.json"))
        if !springboard { app.terminate() }
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
        let runner = app.descendants(matching: .any)
            .matching(NSPredicate(format: "identifier ENDSWITH '.xctrunner'")).firstMatch
        if runner.exists, let cell = app.cells.containing(.any, identifier: runner.identifier).allElementsBoundByIndex.first {
            let f = cell.frame
            info["hide"] = ["y": Double((f.minY - screen.minY) / screen.height), "h": Double(f.height / screen.height)]
        }
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: folder.appendingPathComponent(file))
        info["image"] = file
        frames.append(info)
    }

    var screen: CGRect { app.windows.firstMatch.frame }

    func point(_ p: CGPoint) -> [String: Double] {
        ["x": Double((p.x - screen.minX) / screen.width), "y": Double((p.y - screen.minY) / screen.height)]
    }

    /// Records a tap on [el], then taps it (unless [press] is false: a switch
    /// that is already on stays on).
    func step(_ el: XCUIElement, press: Bool = true, labelFromValue: Bool = false) {
        _ = el.waitForExistence(timeout: 4)
        // Settings scroll to their rows; the Home and Lock Screen have nothing to scroll.
        if app == settings { for _ in 0..<10 where !visible(el) { scroll() } } else { _ = el.waitForExistence(timeout: 6) }
        if !el.exists {
            try? XCUIScreen.main.screenshot().pngRepresentation.write(to: folder.appendingPathComponent("failed.png"))
        }
        XCTAssertTrue(el.exists, "missing \(el)")
        let f = el.frame
        // A widget is named by its kind ("Widget, Rectangular" → "Widget · Rectangular").
        var label = labelFromValue ? (el.value as? String ?? el.label).replacingOccurrences(of: ", ", with: " · ") : el.label
        // A row's label can carry its value after a comma ("Location Services, 1 always").
        if el.elementType == .button, !labelFromValue, let i = label.firstIndex(of: ",") { label = String(label[..<i]) }
        label = label.trimmingCharacters(in: .whitespaces)
        shot(["tap": point(CGPoint(x: f.midX, y: f.midY)), "label": label])
        if press { el.tap(); sleep(2) }
    }

    /// A recorded long press at a point of the screen (fractions).
    func longPress(x: Double, y: Double) {
        shot(["press": ["x": x, "y": y]])
        app.windows.firstMatch.coordinate(withNormalizedOffset: CGVector(dx: x, dy: y)).press(forDuration: 1.5)
        sleep(3)
    }

    func open(_ id: String) {
        step(app.buttons[id])
    }

    /// Fully on screen, clear of the home indicator.
    func visible(_ el: XCUIElement) -> Bool {
        el.exists && el.isHittable && el.frame.maxY < screen.maxY - 80 && el.frame.minY > screen.minY + 100
    }

    /// A gentle scroll down, so rows are not flung past.
    func scroll() {
        let w = app.windows.firstMatch
        w.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.75))
            .press(forDuration: 0.05, thenDragTo: w.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.45)),
                   withVelocity: 600, thenHoldForDuration: 0.3)
        sleep(1)
    }

    func back() {
        app.navigationBars.firstMatch.buttons.firstMatch.tap()
        sleep(2)
    }

    /// One page of the Action Button carousel, not recorded.
    func page(forward: Bool) {
        let leftward = forward != rtl
        let w = app.windows.firstMatch
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
        // The carousel can still be settling after a fresh boot: retry until
        // the Controls page with its choose button shows.
        var choose: XCUIElement?
        for _ in 0..<3 where choose == nil {
            for _ in 0..<4 { drag(0.4, 0.6) }
            drag(0.6, 0.4)
            sleep(2)
            choose = s.buttons.allElementsBoundByIndex.first { $0.frame.minY > 600 && $0.frame.minY < 720 }
        }
        XCTAssertNotNil(choose, "no Controls page in the Action Button settings")
        choose!.tap()
        let control = s.buttons["ch.masdatos.redpanda.control.text"]
        for _ in 0..<12 where !control.exists {
            let field = s.searchFields.firstMatch
            _ = field.waitForExistence(timeout: 15)
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
