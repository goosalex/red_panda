import XCTest

/// App Store screenshots of Red Panda itself (not the Settings app), on
/// sample notes from tool/screenshots/seed.py. Run through
/// tool/screenshots/shoot.sh, which passes SHOT_OUT (folder), SHOT_PREFIX
/// (iphone / ipad) and SHOT_LABELS (the app's own texts for the buttons to
/// tap, from the ARB files) as TEST_RUNNER_SHOT_*.
final class StoreShots: XCTestCase {
    let app = XCUIApplication(bundleIdentifier: "ch.masdatos.redpanda")
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    var out = URL(fileURLWithPath: NSTemporaryDirectory())
    var prefix = "iphone"
    var labels: [String: String] = [:]
    var count = 0

    override func setUp() {
        continueAfterFailure = false
        let env = ProcessInfo.processInfo.environment
        if let o = env["SHOT_OUT"] { out = URL(fileURLWithPath: o) }
        prefix = env["SHOT_PREFIX"] ?? prefix
        if let j = env["SHOT_LABELS"]?.data(using: .utf8) {
            labels = (try? JSONSerialization.jsonObject(with: j)) as? [String: String] ?? [:]
        }
        try? FileManager.default.createDirectory(at: out, withIntermediateDirectories: true)
    }

    func testShots() throws {
        app.launchArguments = ["-AppleLanguages", "(\(labels["lang"] ?? "en"))", "-AppleLocale", labels["locale"] ?? "en_GB"]
        app.launch()
        allowAlerts()
        sleep(3)
        shot("1_list")

        // The leave basket (long press opens its sheet).
        let basket = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", labels["basket"] ?? "Leave basket")).firstMatch
        XCTAssertTrue(basket.waitForExistence(timeout: 5), "no basket")
        basket.press(forDuration: 1.2)
        sleep(2)
        shot("2_basket")
        app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.15)).tap() // closes the sheet
        sleep(2)

        // A voice note being recorded. (Not a typed note: the simulator's
        // keyboard follows this Mac's layout, not the screenshot's language.)
        let mic = element(labels["record"])
        let f = mic.frame, w = app.windows.firstMatch.frame
        let where_ = app.coordinate(withNormalizedOffset: CGVector(dx: f.midX / w.width, dy: f.midY / w.height))
        mic.tap()
        allowAlerts()
        sleep(4)
        shot("3_voice")
        where_.tap() // the stop button replaces the mic; its label is the running time
        sleep(2)
        app.terminate()

        // Settings, then the privacy page.
        app.launch()
        sleep(3)
        tap(labels["settings"])
        sleep(2)
        shot("4_settings")
        let privacy = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label BEGINSWITH %@", labels["privacy"] ?? "Privacy")).firstMatch
        for _ in 0..<6 where !(privacy.exists && privacy.isHittable) { app.swipeUp() }
        privacy.tap()
        sleep(2)
        shot("5_privacy")
    }

    /// Permission prompts that iOS shows on the first launch: allow them
    /// (the "Allow" button is the last one in every language).
    func allowAlerts() {
        for _ in 0..<4 {
            let alert = springboard.alerts.firstMatch
            guard alert.waitForExistence(timeout: 4) else { return }
            alert.buttons.element(boundBy: alert.buttons.count - 1).tap()
            sleep(1)
        }
    }

    func element(_ label: String?) -> XCUIElement {
        let el = app.descendants(matching: .any)
            .matching(NSPredicate(format: "label == %@", label ?? "")).firstMatch
        XCTAssertTrue(el.waitForExistence(timeout: 5), "missing \(label ?? "")")
        return el
    }

    func tap(_ label: String?) { element(label).tap() }

    func shot(_ name: String) {
        let url = out.appendingPathComponent("\(prefix)_\(name).png")
        try? XCUIScreen.main.screenshot().pngRepresentation.write(to: url)
        count += 1
    }
}
