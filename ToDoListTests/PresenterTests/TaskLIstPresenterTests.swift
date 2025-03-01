//import XCTest
//@testable import ToDoList
//import CoreData
//
//class TaskListPresenterTests: XCTestCase {
//    var sut: TaskListPresenter!
//    var mockView: MockTaskListView!
//    var mockInteractor: MockTaskListInteractor!
//    var mockRouter: MockTaskListRouter!
//
//    override func setUp() {
//        super.setUp()
//        mockView = MockTaskListView()
//        mockInteractor = MockTaskListInteractor()
//        mockRouter = MockTaskListRouter()
//        sut = TaskListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
//    }
//
//    override func tearDown() {
//        sut = nil
//        mockView = nil
//        mockInteractor = nil
//        mockRouter = nil
//        super.tearDown()
//    }
//
//    func testViewDidLoad_CallsInteractor() {
//        // Act
//        sut.viewDidLoad()
//
//        // Assert
//        XCTAssertTrue(mockInteractor.fetchTaskForCurrentSegmentCalled)
//    }
//
//    func testAddTask_CallsInteractor() {
//        // Arrange
//        let title = "Test Task"
//        let details = "Test Details"
//
//        // Act
//        sut.addTask(title: title, details: details)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.addTaskCalled)
//        XCTAssertEqual(mockInteractor.lastAddedTitle, title)
//        XCTAssertEqual(mockInteractor.lastAddedDetails, details)
//    }
//
//    func testUpdateTask_CallsInteractor() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        let title = "Updated Task"
//        let details = "Updated Details"
//
//        // Act
//        sut.updateTask(task: task, title: title, details: details)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.updateTaskCalled)
//        XCTAssertEqual(mockInteractor.lastUpdatedTitle, title)
//        XCTAssertEqual(mockInteractor.lastUpdatedDetails, details)
//    }
//
//    func testDeleteTask_CallsInteractor() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//
//        // Act
//        sut.deleteTask(task: task)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.deleteTaskCalled)
//    }
//
//    func testSearchTask_CallsInteractor() {
//        // Arrange
//        let searchText = "Search"
//
//        // Act
//        sut.searchTask(title: searchText)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.searchTaskCalled)
//        XCTAssertEqual(mockInteractor.lastSearchTitle, searchText)
//    }
//
//    func testIsCompleted_CallsInteractor() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//
//        // Act
//        sut.isCompleted(task: task)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.isCompletedCalled)
//    }
//
//    func testDidSelectSegment_CallsInteractor() {
//        // Arrange
//        let index = 1
//
//        // Act
//        sut.didSelectSegment(at: index)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.segmentChangedCalled)
//        XCTAssertEqual(mockInteractor.lastSegmentIndex, index)
//    }
//
//    func testShowTasksDetail_CallsRouter() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//
//        // Act
//        sut.showTasksDetail(for: task)
//
//        // Assert
//        XCTAssertTrue(mockRouter.navigateToTaskDetailCalled)
//    }
//
//    func testShowAddTaskScreen_CallsRouter() {
//        // Act
//        sut.showAddTaskScreen()
//
//        // Assert
//        XCTAssertTrue(mockRouter.navigateToAddTaskCalled)
//    }
//
//    func testDidFetchTasks_UpdatesViewAndTasks() {
//        // Arrange
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        let tasks = [TasksList(context: context)]
//
//        // Act
//        sut.didFetchTasks(tasks: tasks)
//
//        // Assert
//        XCTAssertEqual(sut.tasks, tasks)
//        XCTAssertTrue(mockView.showTasksCalled)
//    }
//
//    func testDidReceiveError_ShowsErrorOnView() {
//        // Arrange
//        let error = NSError(domain: "test", code: 1)
//
//        // Act
//        sut.didReceiveError(error)
//
//        // Assert
//        XCTAssertTrue(mockView.showErrorCalled)
//    }
//
//    func testTaskCreated_ShowsSuccessOnView() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//
//        // Act
//        sut.taskCreated(task)
//
//        // Assert
//        XCTAssertTrue(mockView.showSuccessCalled)
//    }
//}
//
//// MARK: - Mock Classes
//
//class MockTaskListView: TaskListViewProtocol {
//    var showTasksCalled = false
//    var showErrorCalled = false
//    var showSuccessCalled = false
//
//    func showTasks(tasks: [TasksList]) {
//        showTasksCalled = true
//    }
//
//    func showError(_ message: String) {
//        showErrorCalled = true
//    }
//
//    func showSuccess() {
//        showSuccessCalled = true
//    }
//}
//
//class MockTaskListInteractor: TaskListInteractorProtocol {
//    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)?
//
//    var fetchTaskCalled = false
//    var fetchTaskForCurrentSegmentCalled = false
//    var addTaskCalled = false
//    var updateTaskCalled = false
//    var deleteTaskCalled = false
//    var searchTaskCalled = false
//    var isCompletedCalled = false
//    var segmentChangedCalled = false
//
//    var lastAddedTitle: String?
//    var lastAddedDetails: String?
//    var lastUpdatedTask: TasksList?
//    var lastUpdatedTitle: String?
//    var lastUpdatedDetails: String?
//    var lastDeletedTask: TasksList?
//    var lastSearchTitle: String?
//    var lastCompletedTask: TasksList?
//    var lastSegmentIndex: Int?
//
//    func fetchTask() {
//        fetchTaskCalled = true
//    }
//
//    func fetchTaskForCurrentSegment() {
//        fetchTaskForCurrentSegmentCalled = true
//    }
//
//    func addTask(title: String, details: String) {
//        addTaskCalled = true
//        lastAddedTitle = title
//        lastAddedDetails = details
//    }
//
//    func updateTask(task: TasksList, title: String, details: String) {
//        updateTaskCalled = true
//        lastUpdatedTask = task
//        lastUpdatedTitle = title
//        lastUpdatedDetails = details
//    }
//
//    func deleteTask(task: TasksList) {
//        deleteTaskCalled = true
//        lastDeletedTask = task
//    }
//
//    func searchTask(title: String) {
//        searchTaskCalled = true
//        lastSearchTitle = title
//    }
//
//    func isCompleted(task: TasksList) {
//        isCompletedCalled = true
//        lastCompletedTask = task
//    }
//
//    func segmentChanged(to index: Int) {
//        segmentChangedCalled = true
//        lastSegmentIndex = index
//    }
//}
//
//class MockTaskListRouter: TaskListRouterProtocol {
//    var viewController: UITableViewController?
//
//    var navigateToTaskDetailCalled = false
//    var navigateToAddTaskCalled = false
//    var showDetailPreviewCalled = false
//
//    static func createdModule() -> UITableViewController {
//        return UITableViewController()
//    }
//
//    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void) {
//        navigateToTaskDetailCalled = true
//        completion()
//    }
//
//    func navigateToAddTask(completion: @escaping () -> Void) {
//        navigateToAddTaskCalled = true
//        completion()
//    }
//
//    func showDetailPreview(with task: TasksList) -> UIViewController? {
//        showDetailPreviewCalled = true
//        return UIViewController()
//    }
//}
