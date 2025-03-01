import XCTest
@testable import ToDoList
import CoreData

class StorageManagerTests: XCTestCase {
    var sut: StorageManagerProtocol!
    var inMemoryPersistentContainer: NSPersistentContainer!

    override func setUp() {
        super.setUp()
        setupInMemoryPersistentContainer()
        sut = StorageManager.shared
    }

    override func tearDown() {
        sut = nil
        inMemoryPersistentContainer = nil
        super.tearDown()
    }

    private func setupInMemoryPersistentContainer() {
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType

        inMemoryPersistentContainer = NSPersistentContainer(name: "TasksList")
        inMemoryPersistentContainer.persistentStoreDescriptions = [persistentStoreDescription]

        inMemoryPersistentContainer.loadPersistentStores { description, error in
            XCTAssertNil(error, "Failed to load in-memory persistent store: \(error?.localizedDescription ?? "")")
        }
    }

    func testCreateTask() {
        // Arrange
        let expectation = self.expectation(description: "Create task")
        let title = "Test Task"
        let details = "Test Details"

        // Act
        sut.create(title, with: details) { result in
            switch result {
            case .success(let task):
                XCTAssertNotNil(task)
                XCTAssertEqual(task.title, title)
                XCTAssertEqual(task.details, details)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Task creation failed with error: \(error)")
            }
        }

        // Assert
        waitForExpectations(timeout: 1.0)
    }
}
