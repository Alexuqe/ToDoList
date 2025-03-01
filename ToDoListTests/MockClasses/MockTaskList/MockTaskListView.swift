import Foundation
@testable import ToDoList

final class MockTaskListView: TaskListViewProtocol {
    // MARK: - Spy Properties
    var showTasksCalled = false
    var showErrorCalled = false
    var showSuccessCalled = false

    // MARK: - Captured Parameters
    var capturedTasks: [TasksList]?
    var capturedErrorMessage: String?

    // MARK: - Protocol Implementation
    func showTasks(tasks: [TasksList]) {
        showTasksCalled = true
        capturedTasks = tasks
    }

    func showError(_ message: String) {
        showErrorCalled = true
        capturedErrorMessage = message
    }

    func showSuccess() {
        showSuccessCalled = true
    }
}
