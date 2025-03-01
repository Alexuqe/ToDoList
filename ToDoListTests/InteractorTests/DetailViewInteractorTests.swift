//import XCTest
//@testable import ToDoList
//import CoreData
//
//class DetailViewInteractorTests: XCTestCase {
//    var sut: DetailViewInteractor!
//    var mockPresenter: MockDetailViewPresenterOutput!
//    var mockStorageManager: MockStorageManager!
//
//    override func setUp() {
//        super.setUp()
//        mockPresenter = MockDetailViewPresenterOutput()
//        mockStorageManager = MockStorageManager()
//        sut = DetailViewInteractor()
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
//    func testFetchTasksDetails() {
//        // Arrange
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        let task = TasksList(context: context)
//        task.title = "Test Task"
//        task.details = "Test Details"
//
//        // Act
//        sut.fetchTasksDetails(task: task)
//
//        // Assert
//        XCTAssertTrue(mockPresenter.didFetchTaskDetailsCalled)
//    }
//
//    func testCreateNewTask_Success() {
//        // Arrange
//        let testTitle = "New Task"
//        let testDetails = "New Details"
//        let mockTask = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        mockStorageManager.createTaskResult = .success(mockTask)
//
//        // Act
//        sut.createNewTask(title: testTitle, details: testDetails)
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.createCalled)
//        XCTAssertEqual(mockStorageManager.lastCreatedTitle, testTitle)
//        XCTAssertEqual(mockStorageManager.lastCreatedDetails, testDetails)
//        XCTAssertTrue(mockPresenter.didSaveTaskDetailsCalled)
//    }
//
//    func testSaveUpdateTask_Success() {
//        // Arrange
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        let task = TasksList(context: context)
//        sut.fetchTasksDetails(task: task) // Set currentTask
//
//        let newTitle = "Updated Task"
//        let newDetails = "Updated Details"
//        mockStorageManager.updateTaskResult = .success(())
//
//        // Act
//        sut.saveUpdateTask(title: newTitle, details: newDetails)
//
//        // Assert
//        XCTAssertTrue(mockStorageManager.updateTaskCalled)
//        XCTAssertEqual(mockStorageManager.lastUpdatedTitle, newTitle)
//        XCTAssertEqual(mockStorageManager.lastUpdatedDetails, newDetails)
//        XCTAssertTrue(mockPresenter.didSaveTaskDetailsCalled)
//    }
//
//    func testSaveUpdateTask_NoCurrentTask() {
//        // Arrange
//        let newTitle = "Updated Task"
//        let newDetails = "Updated Details"
//
//        // Act
//        sut.saveUpdateTask(title: newTitle, details: newDetails)
//
//        // Assert
//        XCTAssertFalse(mockStorageManager.updateTaskCalled)
//        XCTAssertFalse(mockPresenter.didSaveTaskDetailsCalled)
//    }
//}
//
//class MockDetailViewPresenterOutput: DetailViewInteractorOutputProtocol {
//    var didFetchTaskDetailsCalled = false
//    var didSaveTaskDetailsCalled = false
//
//    func didFetchTaskDetails(task: TasksList) {
//        didFetchTaskDetailsCalled = true
//    }
//
//    func didSaveTaskDetails() {
//        didSaveTaskDetailsCalled = true
//    }
//}
