import Foundation
import UIKit
@testable import ToDoList

final class MockTaskListPresenter: TaskListPresenterProtocol & TaskListInteractorOutputProtocol {
    // MARK: - Required Protocol Properties
    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    var tasks: [TasksList] = []

    // MARK: - Spy Properties
    var viewDidLoadCalled = false
    var showTasksDetailCalled = false
    var showDetailPreviewCalled = false
    var showAddTaskScreenCalled = false
    var taskCreatedCalled = false
    var taskDeletedCalled = false
    var taskUpdatedCalled = false

    // MARK: - Captured Parameters
    var capturedTasks: [TasksList]?
    var capturedError: Error?
    var capturedTask: TasksList?

    // MARK: - TaskListPresenterProtocol Implementation
    func viewDidLoad() {
        viewDidLoadCalled = true
    }

    func addTask(title: String, details: String) {}
    func updateTask(task: TasksList, title: String, details: String) {}
    func deleteTask(task: TasksList) {}
    func searchTask(title: String) {}
    func isCompleted(task: TasksList) {}
    func didSelectSegment(at index: Int) {}

    func showTasksDetail(for task: TasksList) {
        showTasksDetailCalled = true
        capturedTask = task
    }

    func showDetailPreview(with task: TasksList, completion: (UIViewController?) -> Void) {
        showDetailPreviewCalled = true
        capturedTask = task
        completion(nil)
    }

    func showAddTaskScreen() {
        showAddTaskScreenCalled = true
    }

    // MARK: - TaskListInteractorOutputProtocol Implementation
    func didFetchTasks(tasks: [TasksList]) {
        capturedTasks = tasks
    }

    func didReceiveError(_ error: Error) {
        capturedError = error
    }

    func taskCreated(_ task: TasksList) {
        taskCreatedCalled = true
        capturedTask = task
    }

    func taskDeleted() {
        taskDeletedCalled = true
    }

    func taskUpdated() {
        taskUpdatedCalled = true
    }
}
