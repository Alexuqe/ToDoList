    //
    //  Untitled.swift
    //  ToDoList
    //
    //  Created by Sasha on 23.02.25.
    //

    import XCTest

    @testable import ToDoList

    class TaskListViewControllerTests: XCTestCase {
        var sut: TaskListViewController!
        var mockPresenter: MockTaskListPresenter!
        var storageManager: StorageManager!

        override func setUp() {
                super.setUp()
                sut = TaskListViewController()
                mockPresenter = MockTaskListPresenter()
                storageManager = StorageManager.shared
                sut.presenter = mockPresenter
                sut.loadViewIfNeeded()
        }

        override func tearDown() {
                sut = nil
                mockPresenter = nil
                storageManager = nil
                super.tearDown()
        }

        func testViewDidLoad_CallsPresenterViewDidLoad() {
                // Act
                sut.viewDidLoad()

                // Assert
                XCTAssertTrue(mockPresenter.viewDidLoadCalled, "viewDidLoad should call presenter's viewDidLoad")
        }

        func testShowTasks_UpdatesTasksAndReloadsTableView() {
                // Arrange
                let tasks = [TasksList]() 

                // Act
                sut.showTasks(tasks: tasks)

                // Assert
                XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), tasks.count, "Table view should have correct number of rows")
        }
    }

    class MockTaskListPresenter: TaskListPresenterProtocol {
            var viewDidLoadCalled = false

            var view: TaskListViewProtocol?
            var interactor: TaskListInteractorProtocol?
            var router: TaskListRouterProtocol?

            func viewDidLoad() {
                viewDidLoadCalled = true
            }

            func addTask(title: String, details: String) {}
            func updateTask(task: TasksList, title: String, details: String) {}
            func deleteTask(task: TasksList) {}
            func searchTask(title: String) {}
            func isCompleted(task: TasksList) {}
            func showTasksDetail(for task: TasksList) {}
            func showDetailPreview(task: TasksList) {}
            func showAddTaskScreen() {}
    }
