import UIKit
@testable import ToDoList

final class MockDetailViewRouter: DetailViewRouterProtocol {
    var viewController: DetailViewController?

    // MARK: - Spy Properties
    var createDetailModuleWithTaskCalled = false
    var createDetailModuleCalled = false
    var dismissCalled = false

    // MARK: - Captured Parameters
    var capturedTask: TasksList?
    var capturedCompletion: (() -> Void)?

    func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController {
        createDetailModuleWithTaskCalled = true
        capturedTask = task
        capturedCompletion = completion
        return UIViewController()
    }

    func createDetailModule(completion: @escaping () -> Void) -> UIViewController {
        createDetailModuleCalled = true
        capturedCompletion = completion
        return UIViewController()
    }

    func dismiss() {
        dismissCalled = true
        capturedCompletion?()
    }
}
