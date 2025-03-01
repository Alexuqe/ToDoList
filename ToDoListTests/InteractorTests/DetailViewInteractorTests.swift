import XCTest
@testable import ToDoList

final class DetailViewInteractorTests: XCTestCase {
    var sut: DetailViewInteractor!
    var mockPresenter: MockDetailViewPresenter!
    var mockStorageManager: MockStorageManager!

    override func setUp() {
        super.setUp()
        mockPresenter = MockDetailViewPresenter()
        mockStorageManager = MockStorageManager()

        sut = DetailViewInteractor()
        sut.presenter = mockPresenter
        sut.storageManager = mockStorageManager
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockStorageManager = nil
        super.tearDown()
    }

    func testFetchTasksDetails() {
        // Given
        let task = TasksList()
        task.title = "Test Task"
        task.details = "Test Details"

        // When
        sut.fetchTasksDetails(task: task)

        // Then
        XCTAssertEqual(sut.currentTask, task)
        XCTAssertTrue(mockPresenter.didFetchTaskDetailsCalled)
        XCTAssertEqual(mockPresenter.capturedTask, task)
    }

    func testCreateNewTask() {
        // Given
        let title = "New Task"
        let details = "New Details"
        let mockTask = TasksList()
        mockStorageManager.createTaskResult = .success(mockTask)

        // When
        sut.createNewTask(title: title, details: details)

        // Then
        XCTAssertTrue(mockStorageManager.createTaskCalled)
        XCTAssertTrue(mockPresenter.didSaveTaskDetailsCalled)
    }

    func testSaveUpdateTask() {
        // Given
        let task = TasksList()
        let title = "Updated Task"
        let details = "Updated Details"
        sut.currentTask = task
        mockStorageManager.updateTaskResult = .success(())

        // When
        sut.saveUpdateTask(title: title, details: details)

        // Then
        XCTAssertTrue(mockStorageManager.updateTaskCalled)
        XCTAssertTrue(mockPresenter.didSaveTaskDetailsCalled)
    }

    func testSaveUpdateTaskFailure() {
        // Given
        let task = TasksList()
        let title = "Updated Task"
        let details = "Updated Details"
        sut.currentTask = task
        let error = NSError(domain: "test", code: 0)
        mockStorageManager.updateTaskResult = .failure(error)

        // When
        sut.saveUpdateTask(title: title, details: details)

        // Then
        XCTAssertTrue(mockStorageManager.updateTaskCalled)
        XCTAssertFalse(mockPresenter.didSaveTaskDetailsCalled)
    }
}
