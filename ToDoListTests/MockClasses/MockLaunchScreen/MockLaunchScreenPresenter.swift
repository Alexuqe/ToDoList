import Foundation
@testable import ToDoList

final class MockLaunchScreenPresenter: LaunchScreenPresenterProtocols {
    // MARK: - Spy Properties
    var startAnimatingCalled = false
    var showTaskListViewCalled = false

    // MARK: - Protocol Implementation
    func startAnimating() {
        startAnimatingCalled = true
    }

    func showTaskListView() {
        showTaskListViewCalled = true
    }
}
