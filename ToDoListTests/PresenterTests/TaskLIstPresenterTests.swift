import XCTest
@testable import ToDoList

final class TaskListPresenterTests: XCTestCase {
    var sut: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!

    override func setUp() {
        super.setUp()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()

        sut = TaskListPresenter(view: mockView, interactor: mockInteractor, router: mockRouter)
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
        super.tearDown()
    }

    func testViewDidLoadCallsInteractor() {
        // When
        sut.viewDidLoad()

        // Then
        XCTAssertTrue(mockInteractor.fetchTaskCalled)
    }

    func testShowTasksDetailNavigatesToDetail() {
        // Given
        let task = TasksList()

        // When
        sut.showTasksDetail(for: task)

        // Then
        XCTAssertTrue(mockRouter.navigateToTaskDetailCalled)
        XCTAssertEqual(mockRouter.lastTask, task)
    }

    func testShowAddTaskScreenNavigatesToAddTask() {
        // When
        sut.showAddTaskScreen()

        // Then
        XCTAssertTrue(mockRouter.navigateToAddTaskCalled)
    }

    func testDidFetchTasksUpdatesViewAndTasks() {
        // Given
        let tasks = [TasksList()]

        // When
        sut.didFetchTasks(tasks: tasks)

        // Then
        XCTAssertEqual(sut.tasks, tasks)
        XCTAssertTrue(mockView.showTasksCalled)
        XCTAssertEqual(mockView.capturedTasks, tasks)
    }

    func testDidReceiveErrorShowsError() {
        // Given
        let error = NSError(domain: "test", code: 0, userInfo: [NSLocalizedDescriptionKey: "Test Error"])

        // When
        sut.didReceiveError(error)

        // Then
        XCTAssertTrue(mockView.showErrorCalled)
        XCTAssertEqual(mockView.capturedErrorMessage, error.localizedDescription)
    }
}
