
    import XCTest
    import CoreData
    @testable import ToDoList

    class TaskListPresenterTests: XCTestCase {
        var sut: TaskListPresenter!
        var mockView: MockTaskListView!
        var mockInteractor: MockTaskListInteractor!
        var mockRouter: MockTaskListRouter!
        var persistentContainer: NSPersistentContainer!

        override func setUp() {
            super.setUp()
            mockView = MockTaskListView()
            mockInteractor = MockTaskListInteractor()
            mockRouter = MockTaskListRouter()
            sut = TaskListPresenter()
            sut.view = mockView
            sut.interactor = mockInteractor
            sut.router = mockRouter

            // Initialize the in-memory persistent container
            persistentContainer = createInMemoryPersistentContainer()
        }

        override func tearDown() {
            sut = nil
            mockView = nil
            mockInteractor = nil
            mockRouter = nil
            persistentContainer = nil
            super.tearDown()
        }

        func testViewDidLoad() {
            // Act
            sut.viewDidLoad()

            // Assert
            XCTAssertTrue(mockInteractor.fetchTaskCalled, "viewDidLoad should trigger interactor's fetchTask")
        }

        func testDeleteTask() {
            // Arrange
            let task = TasksList(context: persistentContainer.viewContext)
            task.title = "Task"
            task.details = "Details"
            task.date = Date()
            task.isCompleted = false

            // Act
            sut.deleteTask(task: task)

            // Assert
            XCTAssertTrue(mockInteractor.deleteTaskCalled, "deleteTask should trigger interactor's deleteTask")
        }

        // Helper to create in-memory Core Data stack
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

    class MockTaskListView: TaskListViewProtocol {
        var tasks: [TasksList] = []

        func showTasks(tasks: [TasksList]) {
            self.tasks = tasks
        }
    }

    class MockTaskListInteractor: TaskListInteractorProtocol {
        var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)?
        var fetchTaskCalled = false
        var deleteTaskCalled = false

        func fetchTask() {
            fetchTaskCalled = true
        }

        func addTask(title: String, details: String) {}
        func updateTask(task: TasksList, title: String, details: String) {}
        func deleteTask(task: TasksList) {
            deleteTaskCalled = true
        }
        func searchTask(title: String) {}
        func isCompleted(task: TasksList) {}
    }

class MockTaskListRouter: TaskListRouterProtocol {

    var viewController: UITableViewController?

    static func createdModule() -> UITableViewController {
        return UITableViewController()
    }

    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void) {}
    func navigateToAddTask(completion: @escaping () -> Void) {}
    func showDetailPreview(with task: ToDoList.TasksList) -> UIViewController? {
        return UIViewController()
    }
}

    extension TasksList {
        convenience init(testTitle: String, testDetails: String, testDate: Date, testIsCompleted: Bool) {
            let temporaryContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            self.init(context: temporaryContext)
            self.title = testTitle
            self.details = testDetails
            self.date = testDate
            self.isCompleted = testIsCompleted
        }
    }
