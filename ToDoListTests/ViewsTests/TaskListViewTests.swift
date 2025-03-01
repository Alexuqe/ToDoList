import XCTest
@testable import ToDoList

final class TaskListViewControllerTests: XCTestCase {
    var sut: TaskListViewController!
    var mockPresenter: MockTaskListPresenter!

    override func setUp() {
        super.setUp()
        sut = TaskListViewController()
        mockPresenter = MockTaskListPresenter()
        sut.presenter = mockPresenter
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        // When
        sut.viewDidLoad()

        // Then
        XCTAssertTrue(mockPresenter.viewDidLoadCalled)
    }

    func testShowTasks() {
        // Given
        let tasks = [TasksList()]

        // When
        sut.showTasks(tasks: tasks)

        // Then
        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), 1)
    }

    func testShowError() {
        // Given
        let errorMessage = "Test Error"

        // When
        sut.showError(errorMessage)

        // Then
        let expectation = XCTestExpectation(description: "Alert shown")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let alertController = self.sut.presentedViewController as? UIAlertController
            XCTAssertNotNil(alertController)
            XCTAssertEqual(alertController?.message, errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
}
