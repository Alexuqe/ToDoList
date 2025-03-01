import XCTest
@testable import ToDoList

final class TaskListInteractorTests: XCTestCase {
    var sut: TaskListInteractor!
    var mockPresenter: MockTaskListPresenter!
    var mockStorageManager: MockStorageManager!
    var mockNetworkManager: MockNetworkManager!

    override func setUp() {
        super.setUp()

        mockPresenter = MockTaskListPresenter()
        mockStorageManager = MockStorageManager()
        mockNetworkManager = MockNetworkManager.shared

        sut = TaskListInteractor()
        sut.presenter = mockPresenter
        sut.storageManager = mockStorageManager
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockStorageManager = nil
        mockNetworkManager = nil
        super.tearDown()
    }

    func testFetchTaskFirstLaunch() {
        // Given
        UserDefaults.standard.set(false, forKey: "ifFirstLaunch")
        let mockTasks = [APITask(id: 1, todo: "Test", completed: false, userId: 1)]
        mockNetworkManager.fetchResult = .success(APITasks(todos: mockTasks, total: 1, skip: 0, limit: 10))

        // When
        sut.fetchTask()

        // Then
        XCTAssertTrue(mockNetworkManager.fetchCalled)
        XCTAssertTrue(mockStorageManager.fetchTasksOnAPICalled)
    }

    func testFetchTaskFromCoreData() {
        // Given
        UserDefaults.standard.set(true, forKey: "ifFirstLaunch")
        let mockTasks = [TasksList()]
        mockStorageManager.fetchTasksResult = .success(mockTasks)

        // When
        sut.fetchTask()

        // Then
        XCTAssertTrue(mockStorageManager.fetchTasksCalled)
        XCTAssertEqual(mockPresenter.capturedTasks, mockTasks)
    }

    func testAddTask() {
        // Given
        let title = "Test Task"
        let details = "Test Details"
        let mockTask = TasksList()
        mockStorageManager.createTaskResult = .success(mockTask)

        // When
        sut.addTask(title: title, details: details)

        // Then
        XCTAssertTrue(mockStorageManager.createTaskCalled)
        XCTAssertTrue(mockPresenter.taskCreatedCalled)
    }

    func testDeleteTask() {
        // Given
        let task = TasksList()
        mockStorageManager.deleteTaskResult = .success(())

        // When
        sut.deleteTask(task: task)

        // Then
        XCTAssertTrue(mockStorageManager.deleteTaskCalled)
        XCTAssertTrue(mockPresenter.taskDeletedCalled)
    }

    func testSearchTask() {
        // Given
        let searchTitle = "Test"
        let mockTasks = [TasksList()]
        mockStorageManager.searchTaskResult = .success(mockTasks)

        // When
        sut.searchTask(title: searchTitle)

        // Then
        XCTAssertTrue(mockStorageManager.searchTaskCalled)
        XCTAssertEqual(mockPresenter.capturedTasks, mockTasks)
    }

    func testSegmentChanged() {
        // Given
        let mockTasks = [TasksList()]
        mockStorageManager.segmentedTaskResult = .success(mockTasks)

        // When
        sut.segmentChanged(to: 1)

        // Then
        XCTAssertTrue(mockStorageManager.segmentedTaskCalled)
        XCTAssertEqual(mockPresenter.capturedTasks, mockTasks)
    }
}
