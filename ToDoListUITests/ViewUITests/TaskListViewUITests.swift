import XCTest

final class TaskListViewUITests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }

    func testLaunchAppAndCheckTaskList() {
        let navigationTitle = app.navigationBars["Задачи"]
        XCTAssertTrue(navigationTitle.exists, "Task list screen should display the title 'Задачи'")
    }

    func testAddNewTask() {
        let addButton = app.toolbars.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
        addButton.tap()

        let titleTextField = app.textFields["Введите заголовок"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "Title text field should exist")
        titleTextField.tap()
        titleTextField.typeText("Новая задача")

        let detailTextView = app.textViews.element(boundBy: 0)
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 5), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.typeText("Тестовое описание задачи")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()

        XCTAssertTrue(app.tables.staticTexts["Новая задача"].waitForExistence(timeout: 5), "The new task should be visible in the list")
    }

    func testEditTask() {
        // Get the first task cell
        let taskCell = app.tables.cells.element(boundBy: 0)
        XCTAssertTrue(taskCell.waitForExistence(timeout: 5), "Task cell should exist")
        taskCell.press(forDuration: 1.0)

        let editButton = app.buttons["Редактировать"]
        XCTAssertTrue(editButton.waitForExistence(timeout: 5), "Edit button should exist")
        editButton.tap()

        // Update title with quick selection and replacement
        let titleTextField = app.textFields["titleTextField"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "Title text field should exist")
        titleTextField.tap()
        titleTextField.press(forDuration: 1.0) // Press to show the selection menu
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()// Select all text
        titleTextField.typeText("Редактируемая задача")

        // Update details with quick selection and replacement
        let detailTextView = app.textViews["detailTextView"]
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 8), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.press(forDuration: 0.5) // Press to show the selection menu
        app.menuItems["Select All"].tap()
        app.menuItems["Cut"].tap()// Select all text
        detailTextView.typeText("Редактируемые детали задачи")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.exists, "Save button should exist in DetailView")
        saveButton.tap()

        // Verify the update
        XCTAssertTrue(app.tables.staticTexts["Редактируемая задача"].waitForExistence(timeout: 5), "The task title should be updated in the list")
    }

    // Rest of the file remains the same

    func testDeleteTask() {
            // First add a task to ensure we have something to delete
        let addButton = app.toolbars.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 5), "Add button should exist")
        addButton.tap()

        let titleTextField = app.textFields["Введите заголовок"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 5), "Title text field should exist")
        titleTextField.tap()
        titleTextField.typeText("Task To Delete")

        let detailTextView = app.textViews["detailTextView"]
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 5), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.typeText("Task To Delete Details")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()

            // Find the task by name and delete it
        let taskCell = app.tables.staticTexts["Task To Delete"].firstMatch
        XCTAssertTrue(taskCell.waitForExistence(timeout: 5), "Task cell should exist")
        taskCell.press(forDuration: 1.0)

        let deleteButton = app.buttons["Удалить"]
        XCTAssertTrue(deleteButton.waitForExistence(timeout: 5), "Delete button in context menu should exist")
        deleteButton.tap()

            // Verify the task is deleted
        XCTAssertFalse(taskCell.waitForExistence(timeout: 5), "Task cell should no longer exist")
    }

    func testToggleTaskCompletion() {
            // First add a task to ensure we have something to toggle
        let addButton = app.toolbars.buttons["addTaskButton"]
        XCTAssertTrue(addButton.waitForExistence(timeout: 2), "Add button should exist")
        addButton.tap()

        let titleTextField = app.textFields["Введите заголовок"]
        XCTAssertTrue(titleTextField.waitForExistence(timeout: 2), "Title text field should exist")
        titleTextField.tap()
        titleTextField.typeText("Toggle Task")

        let detailTextView = app.textViews["detailTextView"]
        XCTAssertTrue(detailTextView.waitForExistence(timeout: 2), "Detail text view should exist")
        detailTextView.tap()
        detailTextView.typeText("Task to test completion toggle")

        let saveButton = app.navigationBars.buttons["Сохранить"]
        XCTAssertTrue(saveButton.exists, "Save button should exist")
        saveButton.tap()

            // Find the task cell that contains our task
        let taskCell = app.tables.cells.containing(.staticText, identifier: "Toggle Task").firstMatch
        XCTAssertTrue(taskCell.waitForExistence(timeout: 2), "Task cell should exist")

            // Get the checkmark button within this specific cell
        let checkmarkButton = taskCell.buttons["checkmarkButton"]
        XCTAssertTrue(checkmarkButton.waitForExistence(timeout: 2), "Checkmark button should exist")

            // Initial state - verify initial state
        let initialTextStyle = taskCell.staticTexts["Toggle Task"].label
        XCTAssertNotNil(initialTextStyle, "Task text should be visible")

            // Toggle to completed
        checkmarkButton.tap()
        sleep(1) // Wait for UI update

            // Verify completed state
        let completedCell = app.tables.cells.containing(.staticText, identifier: "Toggle Task").firstMatch
        XCTAssertTrue(completedCell.waitForExistence(timeout: 2), "Completed task cell should exist")

            // Toggle back to uncompleted
        let completedCheckmarkButton = completedCell.buttons["checkmarkButton"]
        completedCheckmarkButton.tap()
        sleep(1) // Wait for UI update

            // Verify uncompleted state
        let uncompletedCell = app.tables.cells.containing(.staticText, identifier: "Toggle Task").firstMatch
        XCTAssertTrue(uncompletedCell.waitForExistence(timeout: 2), "Uncompleted task cell should exist")
    }

    func testSearchTask() {
        let searchBar = app.searchFields["Поиск"]
        XCTAssertTrue(searchBar.waitForExistence(timeout: 5), "Search bar should exist")
        searchBar.tap()
        searchBar.typeText("Новая задача")

        let expectation = XCTNSPredicateExpectation(predicate: NSPredicate(format: "count > 0"), object: app.tables.cells)
        let result = XCTWaiter().wait(for: [expectation], timeout: 5)
        XCTAssertEqual(result, .completed, "Table should have filtered cells")

        let filteredTaskCell = app.tables.staticTexts["Новая задача"]
        XCTAssertTrue(filteredTaskCell.exists, "The search results should display the filtered tasks")
    }

        // Ensure that UIHelpers.swift contains the necessary methods for shared functionality and is included in the test target.
}
