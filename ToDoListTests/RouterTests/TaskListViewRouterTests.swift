import XCTest

final class DetailViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testSaveNewTaskWithValidInput() {
        // Start the process to add a new task
        let addButton = app.toolbars.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
        addButton.tap()

        let titleTextField = app.textFields["Введите заголовок"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "Title text field should exist")
        titleTextField.tap()
        titleTextField.typeText("Valid Title")

        let detailTextView = app.descendants(matching: .textView).matching(identifier: "detailTextView").firstMatch
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 10), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.typeText("Valid Details")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5), "Save button should exist")
        XCTAssertTrue(saveButton.isEnabled, "Save button should be enabled for valid input")
    }

    func testSaveButtonDisabledWhenEmpty() {
        // Open DetailView and check save button state with empty fields
        let addButton = app.toolbars.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
        addButton.tap()

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5), "Save button should exist")
        XCTAssertFalse(saveButton.isEnabled, "Save button should be disabled when input fields are empty")
    }

    func testUpdateExistingTask() {
        // Tap on a task to edit
        let taskCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(taskCell.waitForExistence(timeout: 5), "Task cell should exist")
        taskCell.tap()

        // Add a brief sleep to ensure the transition to DetailView is complete
        sleep(1)

        // Direct query method for detailTextView
        let detailTextView = app.textViews["detailTextView"]
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 10), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.clearText()
        detailTextView.typeText("Updated Details")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5), "Save button should exist")
        saveButton.tap()

        // Ensure we navigate back to the list and verify details are updated
        sleep(1)
        XCTAssertTrue(app.tables.firstMatch.waitForExistence(timeout: 5), "Should return to the task list")
        let updatedTaskCell = app.tables.staticTexts["Updated Details"]
        XCTAssertTrue(updatedTaskCell.waitForExistence(timeout: 5), "The task details should be updated in the list")
    }
}

// Helper to clear text in UITextField or UITextView
extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else { return }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
