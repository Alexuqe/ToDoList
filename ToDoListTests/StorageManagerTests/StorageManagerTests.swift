//import XCTest
//@testable import ToDoList
//import CoreData
//
//class StorageManagerTests: XCTestCase {
//    var sut: MocksStorageManager!
//    var inMemoryPersistentContainer: NSPersistentContainer!
//
//    override func setUp() {
//        super.setUp()
//        setupInMemoryPersistentContainer()
//        sut = MocksStorageManager(container: inMemoryPersistentContainer)
//    }
//
//    override func tearDown() {
//        sut = nil
//        inMemoryPersistentContainer = nil
//        super.tearDown()
//    }
//
//    private func setupInMemoryPersistentContainer() {
//        // Create an in-memory persistent container for testing
//        let persistentStoreDescription = NSPersistentStoreDescription()
//        persistentStoreDescription.type = NSInMemoryStoreType
//
//        inMemoryPersistentContainer = NSPersistentContainer(name: "TasksList")
//        inMemoryPersistentContainer.persistentStoreDescriptions = [persistentStoreDescription]
//
//        inMemoryPersistentContainer.loadPersistentStores { description, error in
//            XCTAssertNil(error, "Failed to load in-memory persistent store: \(error?.localizedDescription ?? "")")
//        }
//    }
//
//    // MARK: - Test Cases
//
//    func testCreateTask() {
//        // Arrange
//        let expectation = self.expectation(description: "Create task")
//        let title = "Test Task"
//        let details = "Test Details"
//        var createdTask: TasksList?
//
//        // Act
//        sut.create(title, with: details) { result in
//            switch result {
//            case .success(let task):
//                createdTask = task
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        // Assert
//        waitForExpectations(timeout: 1.0)
//        XCTAssertNotNil(createdTask)
//        XCTAssertEqual(createdTask?.title, title)
//        XCTAssertEqual(createdTask?.details, details)
//        XCTAssertFalse(createdTask?.isCompleted ?? true)
//    }
//
//    func testUpdateTask() {
//        // Arrange
//        let createExpectation = self.expectation(description: "Create task")
//        let updateExpectation = self.expectation(description: "Update task")
//
//        var taskToUpdate: TasksList?
//        let initialTitle = "Initial Title"
//        let initialDetails = "Initial Details"
//        let updatedTitle = "Updated Title"
//        let updatedDetails = "Updated Details"
//
//        // Create a task first
//        sut.create(initialTitle, with: initialDetails) { result in
//            switch result {
//            case .success(let task):
//                taskToUpdate = task
//                createExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        // Act
//        guard let task = taskToUpdate else {
//            XCTFail("Task not created")
//            return
//        }
//
//        sut.updateTask(task: task, title: updatedTitle, details: updatedDetails) { result in
//            switch result {
//            case .success:
//                updateExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task update failed with error: \(error)")
//            }
//        }
//
//        // Assert
//        waitForExpectations(timeout: 7.0)
//        XCTAssertEqual(task.title, updatedTitle)
//        XCTAssertEqual(task.details, updatedDetails)
//    }
//
//    func testDeleteTask() {
//        // Arrange
//        let createExpectation = self.expectation(description: "Create task")
//        let deleteExpectation = self.expectation(description: "Delete task")
//        let fetchExpectation = self.expectation(description: "Fetch tasks")
//
//        var taskToDelete: TasksList?
//        var tasksAfterDeletion: [TasksList] = []
//
//        // Create a task first
//        sut.create("Task to Delete", with: "Will be deleted") { result in
//            switch result {
//            case .success(let task):
//                taskToDelete = task
//                createExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        // Act
//        guard let task = taskToDelete else {
//            XCTFail("Task not created")
//            return
//        }
//
//        sut.delete(task) { result in
//            switch result {
//            case .success:
//                deleteExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task deletion failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        // Verify task is deleted
//        sut.fetchTasks { result in
//            switch result {
//            case .success(let tasks):
//                tasksAfterDeletion = tasks
//                fetchExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task fetch failed with error: \(error)")
//            }
//        }
//
//        // Assert
//        waitForExpectations(timeout: 1.0)
//        XCTAssertFalse(tasksAfterDeletion.contains(where: { $0.objectID == task.objectID }))
//    }
//
//    func testIsCompletedTask() {
//        // Arrange
//        let createExpectation = self.expectation(description: "Create task")
//        let toggleExpectation = self.expectation(description: "Toggle completion")
//
//        var task: TasksList?
//
//        // Create a task first
//        sut.create("Test Task", with: "Test Details") { result in
//            switch result {
//            case .success(let createdTask):
//                task = createdTask
//                createExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        // Act
//        guard let taskToToggle = task else {
//            XCTFail("Task not created")
//            return
//        }
//
//        let initialCompletionState = taskToToggle.isCompleted
//
//        sut.isCompletedTask(task: taskToToggle) { result in
//            switch result {
//            case .success:
//                toggleExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task toggle failed with error: \(error)")
//            }
//        }
//
//        // Assert
//        waitForExpectations(timeout: 7.0)
//        XCTAssertEqual(taskToToggle.isCompleted, !initialCompletionState)
//    }
//
//    func testSearchTask() {
//        // Arrange
//        let createExpectation1 = self.expectation(description: "Create task 1")
//        let createExpectation2 = self.expectation(description: "Create task 2")
//        let searchExpectation = self.expectation(description: "Search tasks")
//
//        // Create two tasks with different titles
//        sut.create("Apple Task", with: "Details about apple") { result in
//            switch result {
//            case .success:
//                createExpectation1.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        sut.create("Banana Task", with: "Details about banana") { result in
//            switch result {
//            case .success:
//                createExpectation2.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        var searchResults: [TasksList] = []
//
//        // Act - search for "Apple"
//        sut.searchTask(title: "Apple") { result in
//            switch result {
//            case .success(let tasks):
//                searchResults = tasks
//                searchExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task search failed with error: \(error)")
//            }
//        }
//
//        // Assert
//        waitForExpectations(timeout: 7.0)
//        XCTAssertEqual(searchResults.count, 1)
//        XCTAssertEqual(searchResults.first?.title, "Apple Task")
//    }
//
//    func testSegmentedTask() {
//        // Arrange
//        let createExpectation1 = self.expectation(description: "Create completed task")
//        let createExpectation2 = self.expectation(description: "Create uncompleted task")
//        let toggleExpectation = self.expectation(description: "Toggle completion")
//        let segmentExpectation = self.expectation(description: "Fetch segmented tasks")
//
//        var completedTask: TasksList?
//
//        // Create two tasks
//        sut.create("Completed Task", with: "Done") { result in
//            switch result {
//            case .success(let task):
//                completedTask = task
//                createExpectation1.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        sut.create("Uncompleted Task", with: "Not done") { result in
//            switch result {
//            case .success:
//                createExpectation2.fulfill()
//            case .failure(let error):
//                XCTFail("Task creation failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        // Mark first task as completed
//        guard let taskToComplete = completedTask else {
//            XCTFail("Task not created")
//            return
//        }
//
//        sut.isCompletedTask(task: taskToComplete) { result in
//            switch result {
//            case .success:
//                toggleExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Task toggle failed with error: \(error)")
//            }
//        }
//
//        waitForExpectations(timeout: 7.0)
//
//        var segmentedTasks: [TasksList] = []
//
//        // Act - fetch completed tasks (segment 1)
//        sut.segmentedTask(index: 1) { result in
//            switch result {
//            case .success(let tasks):
//                segmentedTasks = tasks
//                segmentExpectation.fulfill()
//            case .failure(let error):
//                XCTFail("Segmented fetch failed with error: \(error)")
//            }
//        }
//
//        // Assert
//        waitForExpectations(timeout: 1.0)
//        XCTAssertEqual(segmentedTasks.count, 1)
//        XCTAssertEqual(segmentedTasks.first?.title, "Completed Task")
//    }
//}
//
//// MARK: - Mock StorageManager for Testing
//class MocksStorageManager: StorageManagerProtocol {
//    private let viewContext: NSManagedObjectContext
//    private let backgroundContext: NSManagedObjectContext
//
//    init(container: NSPersistentContainer) {
//        self.viewContext = container.viewContext
//        self.backgroundContext = container.newBackgroundContext()
//        self.backgroundContext.automaticallyMergesChangesFromParent = true
//    }
//
//    func fetchTasksOnAPI(_ apiTasks: [APITask], _ savedNameTask: [String], completion: @escaping () -> Void) {
//        backgroundContext.perform {
//            for (index, apiTask) in apiTasks.enumerated() {
//                let taskLists = TasksList(context: self.backgroundContext)
//                taskLists.title = savedNameTask[index]
//                taskLists.details = apiTask.todo
//                taskLists.date = Date()
//                taskLists.isCompleted = apiTask.completed
//            }
//            do {
//                try self.backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion()
//                }
//            } catch {
//                print("Failed to save tasks: \(error)")
//            }
//        }
//    }
//
//    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
//        let fetchRequest = TasksList.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        backgroundContext.perform {
//            do {
//                let tasks = try self.backgroundContext.fetch(fetchRequest)
//                DispatchQueue.main.async {
//                    completion(.success(tasks))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func create(_ title: String, with details: String, completion: @escaping (Result<TasksList, Error>) -> Void) {
//        backgroundContext.perform {
//            let task = TasksList(context: self.backgroundContext)
//            task.title = title
//            task.details = details
//            task.date = Date()
//            task.isCompleted = false
//
//            do {
//                try self.backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(.success(task))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        backgroundContext.perform {
//            task.title = title
//            task.details = details
//
//            do {
//                try self.backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(.success(()))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func delete(_ task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
//        backgroundContext.perform {
//            self.backgroundContext.delete(task)
//
//            do {
//                try self.backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(.success(()))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func isCompletedTask(task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
//        backgroundContext.perform {
//            task.isCompleted.toggle()
//
//            do {
//                try self.backgroundContext.save()
//                DispatchQueue.main.async {
//                    completion(.success(()))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
//        let fetchRequest = TasksList.fetchRequest()
//        backgroundContext.perform {
//            fetchRequest.predicate = NSPredicate(
//                format: "title CONTAINS[cd] %@ OR details CONTAINS[cd] %@", title, title
//            )
//
//            do {
//                let tasks = try self.backgroundContext.fetch(fetchRequest)
//                DispatchQueue.main.async {
//                    completion(.success(tasks))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//
//    func segmentedTask(index: Int, completion: @escaping (Result<[TasksList], Error>) -> Void) {
//        let fetchRequest = TasksList.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "date", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        backgroundContext.perform {
//            switch index {
//            case 0:
//                fetchRequest.predicate = nil
//            case 1:
//                fetchRequest.predicate = NSPredicate(format: "isCompleted == true")
//            case 2:
//                fetchRequest.predicate = NSPredicate(format: "isCompleted == false")
//            default:
//                fetchRequest.predicate = nil
//            }
//
//            do {
//                let tasks = try self.backgroundContext.fetch(fetchRequest)
//                DispatchQueue.main.async {
//                    completion(.success(tasks))
//                }
//            } catch {
//                DispatchQueue.main.async {
//                    completion(.failure(error))
//                }
//            }
//        }
//    }
//}
