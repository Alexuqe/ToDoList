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

        let detailTextView = app.textViews["detailTextView"]
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 10), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.typeText("Valid Details")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 10), "Save button should exist")
        XCTAssertTrue(saveButton.isEnabled, "Save button should be enabled for valid input")
        saveButton.tap()

        // Wait to return to the main screen
        XCTAssertTrue(addButton.waitForExistence(timeout: 10), "Should return to main screen after saving")

        // Verify task added to the table
        let newTaskCell = app.tables.staticTexts["Valid Title"]
        XCTAssertTrue(newTaskCell.waitForExistence(timeout: 10), "New task should be added to the list")
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
        // First ensure there's a task to update
        addTaskIfNoneExists()

        // Wait for UI to settle
        sleep(1)

        // Find and tap the first task
        let taskCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(taskCell.waitForExistence(timeout: 5), "Task cell should exist")
        taskCell.press(forDuration: 1.0)

        let editButton = app.buttons["Редактировать"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5), "Edit button should exist")
        editButton.tap()

        // Update the task details
        let titleTextField = app.textFields["titleTextField"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "Title text field should exist")
        titleTextField.tap()
        titleTextField.press(forDuration: 0.5) // Press to show the selection menu
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()// Select all text
        titleTextField.typeText("Updated Task Title")

        let detailTextView = app.textViews["detailTextView"]
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 5), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.press(forDuration: 0.5) // Press to show the selection menu
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()// Select all text
        detailTextView.typeText("Updated Task Details")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.exists, "Save button should exist in DetailView")
        saveButton.tap()

        // Wait for navigation and verify update
        XCTAssertTrue(app.tables.staticTexts["Updated Task Title"].waitForExistence(timeout: 5), "Updated task title should appear in the list")
    }

    func addTaskIfNoneExists() {
        if !app.tables.cells.element(boundBy: 0).exists {
            // Add a task as none exist
            let addButton = app.toolbars.buttons["addTaskButton"]
            XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
            addButton.tap()

            let titleTextField = app.textFields["Введите заголовок"]
            XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "Title text field should exist")
            titleTextField.tap()
            titleTextField.typeText("Sample Task")

            let detailTextView = app.textViews["detailTextView"]
            XCTAssertTrue(detailTextView.waitForExistence(timeout: 5), "Detail text view should exist")
            detailTextView.tap()
            detailTextView.typeText("Sample Details")

            let saveButton = app.navigationBars.buttons["Сохранить"]
            XCTAssertTrue(saveButton.waitForExistence(timeout: 5), "Save button should exist")
            saveButton.tap()

            // Wait for completion of task addition
            sleep(1)
        }
    }
}

extension XCUIElement {
    func clearText() {
        guard let stringValue = self.value as? String else { return }
        self.tap()
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        self.typeText(deleteString)
    }
}
