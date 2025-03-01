import UIKit
@testable import ToDoList

final class MockTaskListRouter: TaskListRouterProtocol {
    var viewController: UITableViewController?

    // Spy properties
    var navigateToTaskDetailCalled = false
    var navigateToAddTaskCalled = false
    var showDetailPreviewCalled = false

    // Properties for verification
    var lastTask: TasksList?

    static func createdModule() -> UITableViewController {
        return UITableViewController()
    }

    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void) {
        navigateToTaskDetailCalled = true
        lastTask = task
        completion()
    }

    func navigateToAddTask(completion: @escaping () -> Void) {
        navigateToAddTaskCalled = true
        completion()
    }

    func showDetailPreview(with task: TasksList) -> UIViewController? {
        showDetailPreviewCalled = true
        lastTask = task
        return nil
    }
}
