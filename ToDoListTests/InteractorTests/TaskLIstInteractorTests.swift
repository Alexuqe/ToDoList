//import XCTest
//@testable import ToDoList
//import CoreData
//
//class TaskListInteractorTests: XCTestCase {
//    var sut: TaskListInteractor!
//    var mockPresenter: MockTaskListPresenterOutput!
//    var mockStorageManager: MockStorageManager!
//
//    override func setUp() {
//        super.setUp()
//        mockPresenter = MockTaskListPresenterOutput()
//        mockStorageManager = MockStorageManager()
//        sut = TaskListInteractor()
//        sut.presenter = mockPresenter
//        sut.storageManager = mockStorageManager
//    }
//
//    override func tearDown() {
//        sut = nil
//        mockPresenter = nil
//        mockStorageManager = nil
//        super.tearDown()
//    }
//
//    // MARK: - Fetch Tasks Tests
//
//    func testFetchTaskForCurrentSegment() {
//        // Act
//        sut.fetchTaskForCurrentSegment()
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.segmentedTaskCalled)
//        XCTAssertEqual(mockStorageManager.lastSegmentIndex, 0) // Default index is 0
//    }
//
//    func testAddTask_Success() {
//        // Arrange
//        let testTitle = "Test Task"
//        let testDetails = "Test Details"
//        let mockTask = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        mockStorageManager.createTaskResult = .success(mockTask)
//
//        // Act
//        sut.addTask(title: testTitle, details: testDetails)
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.createCalled)
//        XCTAssertEqual(mockStorageManager.lastCreatedTitle, testTitle)
//        XCTAssertEqual(mockStorageManager.lastCreatedDetails, testDetails)
//        XCTAssertTrue(mockPresenter.taskCreatedCalled)
//    }
//
//    func testAddTask_Failure() {
//        // Arrange
//        let error = NSError(domain: "test", code: 1)
//        mockStorageManager.createTaskResult = .failure(error)
//
//        // Act
//        sut.addTask(title: "Test", details: "Test")
//
//        // Assert
//        XCTAssertTrue(mockPresenter.didReceiveErrorCalled)
//    }
//
//    func testUpdateTask_Success() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        mockStorageManager.updateTaskResult = .success(())
//
//        // Act
//        sut.updateTask(task: task, title: "New Title", details: "New Details")
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.updateTaskCalled)
//        XCTAssertTrue(mockPresenter.taskUpdatedCalled)
//    }
//
//    func testDeleteTask_Success() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        mockStorageManager.deleteTaskResult = .success(())
//
//        // Act
//        sut.deleteTask(task: task)
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.deleteCalled)
//        XCTAssertTrue(mockPresenter.taskDeletedCalled)
//    }
//
//    func testSearchTask_Success() {
//        // Arrange
//        let mockTasks = [TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))]
//        mockStorageManager.searchTaskResult = .success(mockTasks)
//
//        // Act
//        sut.searchTask(title: "Test")
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.searchTaskCalled)
//        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
//    }
//
//    func testIsCompleted_Success() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        mockStorageManager.isCompletedTaskResult = .success(())
//
//        // Act
//        sut.isCompleted(task: task)
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.isCompletedTaskCalled)
//    }
//
//    func testSegmentChanged_UpdatesCurrentIndexAndFetchesTasks() {
//        // Arrange
//        let mockTasks = [TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))]
//        mockStorageManager.segmentedTaskResult = .success(mockTasks)
//
//        // Act
//        sut.segmentChanged(to: 1)
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.segmentedTaskCalled)
//        XCTAssertEqual(mockStorageManager.lastSegmentIndex, 1)
//        XCTAssertTrue(mockPresenter.didFetchTasksCalled)
//    }
//}
//
//// MARK: - Mock Classes
//
//class MockTaskListPresenterOutput: TaskListInteractorOutputProtocol, TaskListPresenterProtocol {
//    // Properties for TaskListInteractorOutputProtocol
//    var didFetchTasksCalled = false
//    var didReceiveErrorCalled = false
//    var taskCreatedCalled = false
//    var taskDeletedCalled = false
//    var taskUpdatedCalled = false
//
//    // Required properties for TaskListPresenterProtocol
//    var view: TaskListViewProtocol?
//    var interactor: TaskListInteractorProtocol?
//    var router: TaskListRouterProtocol?
//    var tasks: [TasksList] = []
//
//    // Implement required methods for TaskListPresenterProtocol
//    func viewDidLoad() {}
//    func addTask(title: String, details: String) {}
//    func updateTask(task: TasksList, title: String, details: String) {}
//    func deleteTask(task: TasksList) {}
//    func searchTask(title: String) {}
//    func isCompleted(task: TasksList) {}
//    func didSelectSegment(at index: Int) {}
//    func showTasksDetail(for task: TasksList) {}
//    func showDetailPreview(with task: TasksList, completion: (UIViewController?) -> Void) {}
//    func showAddTaskScreen() {}
//
//    // Implement methods for TaskListInteractorOutputProtocol
//    func didFetchTasks(tasks: [TasksList]) {
//        didFetchTasksCalled = true
//    }
//
//    func didReceiveError(_ error: Error) {
//        didReceiveErrorCalled = true
//    }
//
//    func taskCreated(_ task: TasksList) {
//        taskCreatedCalled = true
//    }
//
//    func taskDeleted() {
//        taskDeletedCalled = true
//    }
//
//    func taskUpdated() {
//        taskUpdatedCalled = true
//    }
//}
//
//class MockStorageManager: StorageManagerProtocol {
//    // Tracking Properties
//    var createCalled = false
//    var updateTaskCalled = false
//    var deleteCalled = false
//    var fetchTasksCalled = false
//    var searchTaskCalled = false
//    var isCompletedTaskCalled = false
//    var segmentedTaskCalled = false
//    var fetchTasksOnAPICalled = false
//
//    // Last Called Parameters
//    var lastCreatedTitle: String?
//    var lastCreatedDetails: String?
//    var lastUpdatedTask: TasksList?
//    var lastUpdatedTitle: String?
//    var lastUpdatedDetails: String?
//    var lastDeletedTask: TasksList?
//    var lastSearchTitle: String?
//    var lastCompletedTask: TasksList?
//    var lastSegmentIndex: Int?
//
//    // Mock Results
//    var createTaskResult: Result<TasksList, Error>?
//    var updateTaskResult: Result<Void, Error>?
//    var deleteTaskResult: Result<Void, Error>?
//    var fetchTasksResult: Result<[TasksList], Error>?
//    var searchTaskResult: Result<[TasksList], Error>?
//    var isCompletedTaskResult: Result<Void, Error>?
//    var segmentedTaskResult: Result<[TasksList], Error>?
//
//    // Protocol Methods
//    func create(_ title: String, with details: String, completion: @escaping (Result<TasksList, Error>) -> Void) {
//        createCalled = true
//        lastCreatedTitle = title
//        lastCreatedDetails = details
//        if let result = createTaskResult {
//            completion(result)
//        }
//    }
//
//    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        updateTaskCalled = true
//        lastUpdatedTask = task
//        lastUpdatedTitle = title
//        lastUpdatedDetails = details
//        if let result = updateTaskResult {
//            completion(result)
//        }
//    }
//
//    func delete(_ task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
//        deleteCalled = true
//        lastDeletedTask = task
//        if let result = deleteTaskResult {
//            completion(result)
//        }
//    }
//
//    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
//        fetchTasksCalled = true
//        if let result = fetchTasksResult {
//            completion(result)
//        }
//    }
//
//    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
//        searchTaskCalled = true
//        lastSearchTitle = title
//        if let result = searchTaskResult {
//            completion(result)
//        }
//    }
//
//    func isCompletedTask(task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
//        isCompletedTaskCalled = true
//        lastCompletedTask = task
//        if let result = isCompletedTaskResult {
//            completion(result)
//        }
//    }
//
//    func segmentedTask(index: Int, completion: @escaping (Result<[TasksList], Error>) -> Void) {
//        segmentedTaskCalled = true
//        lastSegmentIndex = index
//        if let result = segmentedTaskResult {
//            completion(result)
//        }
//    }
//
//    func fetchTasksOnAPI(_ apiTasks: [APITask], _ savedNameTask: [String], completion: @escaping () -> Void) {
//        fetchTasksOnAPICalled = true
//        completion()
//    }
//}
