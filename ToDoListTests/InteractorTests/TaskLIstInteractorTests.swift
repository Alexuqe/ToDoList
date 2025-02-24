import XCTest
@testable import ToDoList
import CoreData

class TaskListInteractorTests: XCTestCase {
    var sut: TaskListInteractor!
    var mockPresenter: MockTaskListPresenterOutput!
    var mockStorageManager: MockStorageManager!

    override func setUp() {
        super.setUp()
        mockPresenter = MockTaskListPresenterOutput()
        mockStorageManager = MockStorageManager()
        sut = TaskListInteractor()
        sut.presenter = mockPresenter
        // Inject the mock storage manager
        sut.storageManager = mockStorageManager
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        mockStorageManager = nil
        super.tearDown()
    }

    func testFetchTask_CallsStorageManagerFetchTasks() {
        // Act
        sut.fetchTask()

        // Assert
        XCTAssertTrue(mockStorageManager.fetchTasksCalled, "fetchTask should call storageManager's fetchTasks")
    }

    func testDeleteTask_CallsStorageManagerDelete() {
        // Arrange
        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
        task.title = "Test Task"
        task.details = "Test Details"
        task.date = Date()
        task.isCompleted = false

        // Act
        sut.deleteTask(task: task)

        // Assert
        XCTAssertTrue(mockStorageManager.deleteCalled, "deleteTask should call storageManager's delete")
    }
}

// MARK: - Mocks
class MockStorageManager: StorageManagerProtocol {
    
    var fetchTasksCalled = false
    var deleteCalled = false

    func fetchTasksOnAPI(_ apiTasks: [ToDoList.APITask],_ savedNameTask: [String], completion: @escaping () -> Void) {
        fetchTasksCalled = true
        completion()
    }

    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
        fetchTasksCalled = true
        completion(.success([]))
    }

    func delete(_ task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        deleteCalled = true
        completion(.success([]))
    }

    func create(_ title: String, with details: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        completion(.success([]))
    }

    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        completion(.success([]))
    }

    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        completion(.success([]))
    }

    func isCompletedTask(task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        completion(.success([]))
    }
}

class MockTaskListPresenterOutput: TaskListInteractorOutputProtocol & TaskListPresenterProtocol {
    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?

    func viewDidLoad() {}
    func addTask(title: String, details: String) {}
    func updateTask(task: TasksList, title: String, details: String) {}
    func deleteTask(task: TasksList) {}
    func searchTask(title: String) {}
    func isCompleted(task: TasksList) {}
    func showTasksDetail(for task: TasksList) {}
    func showDetailPreview(task: TasksList) {}
    func showAddTaskScreen() {}

    func didFetchTasks(tasks: [TasksList]) {}
}
