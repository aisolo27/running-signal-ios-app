import XCTest

final class RunningWorkoutAnalysisUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSettingsTabLoadsHealthKitStatus() throws {
        let app = XCUIApplication()
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Runs"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Settings"].tap()
        XCTAssertTrue(
            app.descendants(matching: .any)["settings-healthkit-card"]
                .waitForExistence(timeout: 5)
        )
    }
}
