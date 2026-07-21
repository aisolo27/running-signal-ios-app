import XCTest

final class RunningWorkoutAnalysisUITests: XCTestCase {
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    @MainActor
    func testSettingsTabLoadsHealthKitStatus() throws {
        let healthAccessMonitor = addUIInterruptionMonitor(withDescription: "Health Access") { sheet in
            let denyButton = sheet.buttons["Don’t Allow"]
            guard denyButton.exists else { return false }
            denyButton.tap()
            return true
        }
        defer { removeUIInterruptionMonitor(healthAccessMonitor) }

        let app = XCUIApplication()
        app.launchArguments += ["-RunSignal.HealthKitOnboardingCompleted.v1", "true"]
        app.launch()

        XCTAssertTrue(app.tabBars.buttons["Runs"].waitForExistence(timeout: 5))
        XCTAssertTrue(app.tabBars.buttons["Settings"].waitForExistence(timeout: 5))

        app.tabBars.buttons["Settings"].tap()
        app.tap()
        XCTAssertTrue(
            app.descendants(matching: .any)["settings-healthkit-card"]
                .waitForExistence(timeout: 5)
        )
    }
}
