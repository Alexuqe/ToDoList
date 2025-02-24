import XCTest
import CoreData
@testable import ToDoList

class TaskListRouterTests: XCTestCase {
    var sut: TaskListRouter!
    var mockNavigationController: MockTaskListNavigationController!
    var mockContext: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        sut = TaskListRouter()
        mockNavigationController = MockTaskListNavigationController(rootViewController: UITableViewController())
        sut.viewController = mockNavigationController.viewControllers.first as? UITableViewController

        let modelURL = Bundle.main.url(forResource: "TasksList", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        let persistentContainer = NSPersistentContainer(name: "TasksList", managedObjectModel: managedObjectModel)
        persistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        mockContext = persistentContainer.viewContext
    }

    override func tearDown() {
        sut = nil
        mockNavigationController = nil
        mockContext = nil
        super.tearDown()
    }

    func testCreatedModuleReturnsCorrectType() {
        // Act
        let viewController = TaskListRouter.createdModule()

        // Assert
        XCTAssertTrue(viewController is TaskListViewController, "createdModule should return TaskListViewController")
    }

    func testNavigateToTaskDetailPushesDetailViewController() {
        // Arrange
        let task = TasksList(context: mockContext)
        task.title = "Test Task"

        // Act
        sut.navigateToTaskDetail(with: task) {}

        // Assert
        XCTAssertTrue(mockNavigationController.pushViewControllerCalled, "navigateToTaskDetail should push DetailViewController")
    }

    func testNavigateToAddTaskPushesDetailViewController() {
        // Act
        sut.navigateToAddTask {}

        // Assert
        XCTAssertTrue(mockNavigationController.pushViewControllerCalled, "navigateToAddTask should push DetailViewController")
    }

    func testShowDetailPreviewReturnsCorrectViewController() {
        // Arrange
        let task = TasksList(context: mockContext)
        task.title = "Test Task"

        // Act
        let viewController = sut.showDetailPreview(with: task)

        // Assert
        XCTAssertTrue(viewController is TaskContextPreview, "showDetailPreview should return TaskContextPreview")
    }
}

// Mock Navigation Controller
class MockTaskListNavigationController: UINavigationController {
    var pushViewControllerCalled = false

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
    }
}
