import XCTest
@testable import ToDoList

final class DetailViewPresenterTests: XCTestCase {
    var sut: DetailViewPresenter!
    var mockView: MockDetailViewController!
    var mockInteractor: MockDetailViewInteractor!
    var mockRouter: MockDetailViewRouter!

    override func setUp() {
        super.setUp()
        mockView = MockDetailViewController()
        mockInteractor = MockDetailViewInteractor()
        mockRouter = MockDetailViewRouter()

        sut = DetailViewPresenter()
        sut.view = mockView
        sut.interactor = mockInteractor
        sut.router = mockRouter
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testSaveButtonTapped() {
        // Given
        let title = "Test Task"
        let details = "Test Details"

        // When
        sut.saveButtonTapped(title: title, details: details)

        // Then
        XCTAssertTrue(mockInteractor.saveUpdateTaskCalled)
        XCTAssertEqual(mockInteractor.capturedTitle, title)
        XCTAssertEqual(mockInteractor.capturedDetails, details)
    }

    func testTextFieldDidChange() {
        // Given
        let title = "Test"
        let details = "Details"

        // When
        sut.textFieldDidChange(title: title, details: details)

        // Then
        XCTAssertTrue(mockView.enableSaveButtonCalled)
        XCTAssertEqual(mockView.capturedEnabled, true)
    }

    func testTextFieldDidChangeEmptyTitle() {
        // When
        sut.textFieldDidChange(title: "", details: "Details")

        // Then
        XCTAssertTrue(mockView.enableSaveButtonCalled)
        XCTAssertEqual(mockView.capturedEnabled, false)
    }

    func testConfigure() {
        // Given
        let task = TasksList()
        task.title = "Test Task"

        // When
        sut.configure(with: task)

        // Then
        XCTAssertTrue(mockInteractor.fetchTasksDetailsCalled)
        XCTAssertEqual(mockInteractor.capturedTask, task)
    }

    func testDismiss() {
        // When
        sut.dismiss()

        // Then
        XCTAssertTrue(mockRouter.dismissCalled)
    }
}
