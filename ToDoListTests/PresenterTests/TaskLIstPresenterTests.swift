//
//  TaskLIstPresenterTests.swift
//  ToDoList
//
//  Created by Sasha on 23.02.25.
//

import XCTest
import CoreData
@testable import ToDoList

class TaskListPresenterTests: XCTestCase {
    var sut: TaskListPresenter!
    var mockView: MockTaskListView!
    var mockInteractor: MockTaskListInteractor!
    var mockRouter: MockTaskListRouter!

    override func setUp() {
        super.setUp()
        mockView = MockTaskListView()
        mockInteractor = MockTaskListInteractor()
        mockRouter = MockTaskListRouter()
        sut = TaskListPresenter()
        sut.view = mockView
        sut.interactor = mockInteractor
        sut.router = mockRouter
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockInteractor = nil
        mockRouter = nil
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
        let task = TasksList(testTitle: "Task", testDetails: "Details", testDate: Date(), testIsCompleted: false)
        // Act
        sut.deleteTask(task: task)
        // Assert
        XCTAssertTrue(mockInteractor.deleteTaskCalled, "deleteTask should trigger interactor's deleteTask")
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
    func showDetailPreview(with task: TasksList) -> UIViewController {
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
