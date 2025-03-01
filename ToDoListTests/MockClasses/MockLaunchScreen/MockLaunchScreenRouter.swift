import UIKit
@testable import ToDoList

final class MockLaunchScreenRouter: LaunchScreenRouterProtocols {
    // MARK: - Spy Properties
    var navigateToTaskListViewCalled = false

    static func createModule() -> UIViewController {
        return UIViewController()
    }

    func navigateToTaskListView() {
        navigateToTaskListViewCalled = true
    }
}
