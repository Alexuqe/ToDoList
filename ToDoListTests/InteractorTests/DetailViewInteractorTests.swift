import XCTest
import CoreData
@testable import ToDoList

class DetailViewInteractorTests: XCTestCase {
    var interactor: DetailViewInteractor!
    var mockPresenter: MockDetailViewInteractorOutput!
    var mockStorageManager: MockDetailStorageManager!
    var persistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        mockPresenter = MockDetailViewInteractorOutput()
        mockStorageManager = MockDetailStorageManager()

        // Create the in-memory Core Data stack
        persistentContainer = createInMemoryPersistentContainer()
        mockStorageManager.viewContext = persistentContainer.viewContext

        interactor = DetailViewInteractor()
        interactor.presenter = mockPresenter
        interactor.storageManager = mockStorageManager
    }

    override func tearDown() {
        interactor = nil
        mockPresenter = nil
        mockStorageManager = nil
        persistentContainer = nil
        super.tearDown()
    }

    func testFetchTasksDetails_NotifyPresenterWithTask() {
        // Arrange
        let task = TasksList(context: persistentContainer.viewContext)
        task.title = "Test Title"

        // Act
        interactor.fetchTasksDetails(task: task)

        // Assert
        XCTAssertEqual(mockPresenter.fetchedTask?.title, task.title)
    }

    func testCreateNewTask_CallsStorageManagerCreate() {
        // Arrange
        let expectation = XCTestExpectation(description: "Create new task")
        mockStorageManager.createTaskCompletion = {
            expectation.fulfill()
        }

        // Act
        interactor.createNewTask(title: "New Title", details: "New Details")

        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockStorageManager.createCalled, "Create should be called")
    }

    func testSaveUpdateTask_CallsStorageManagerUpdate() {
        // Arrange
        let task = TasksList(context: persistentContainer.viewContext)
        task.title = "Old Title"
        interactor.fetchTasksDetails(task: task)

        let expectation = XCTestExpectation(description: "Update task")
        mockStorageManager.updateTaskCompletion = {
            expectation.fulfill()
        }

        // Act
        interactor.saveUpdateTask(title: "Updated Title", details: "Updated Details")

        // Assert
        wait(for: [expectation], timeout: 2.0)
        XCTAssertTrue(mockStorageManager.updateCalled, "Update should be called")
    }

    // Helper function to setup an in-memory Core Data stack
    private func createInMemoryPersistentContainer() -> NSPersistentContainer {
        let container = NSPersistentContainer(name: "TasksList")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Failed to load in-memory store: \(error)")
            }
        }
        return container
    }
}

//MARK: - Mocks
class MockDetailViewInteractorOutput: DetailViewInteractorOutputProtocol {
    var fetchedTask: TasksList?
    var didSaveTaskDetailsCalled = false

    func didFetchTaskDetails(task: TasksList) {
        fetchedTask = task
    }

    func didSaveTaskDetails() {
        didSaveTaskDetailsCalled = true
    }
}

class MockDetailStorageManager: StorageManagerProtocol {
    var createCalled = false
    var updateCalled = false
    var fetchTasksOnAPICalled = false
    var deleteCalled = false
    var searchCalled = false
    var isCompletedCalled = false

    var viewContext: NSManagedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)

    var createTaskCompletion: (() -> Void)?
    var updateTaskCompletion: (() -> Void)?

    func fetchTasksOnAPI(_ apiTasks: [APITask], _ savedNameTask: [String], completion: @escaping () -> Void) {
        fetchTasksOnAPICalled = true
    }

    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
        completion(.success([]))
    }

    func create(_ title: String, with details: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        createCalled = true
        createTaskCompletion?()
        completion(.success([]))
    }

    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        updateCalled = true
        updateTaskCompletion?()
        completion(.success([]))
    }

    func delete(_ task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        deleteCalled = true
        completion(.success([]))
    }

    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        searchCalled = true
        completion(.success([]))
    }

    func isCompletedTask(task: TasksList, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        isCompletedCalled = true
        completion(.success([]))
    }
}
