import Foundation
@testable import ToDoList

final class MockLaunchScreenViewController: LaunchScreenProtocols {
    var presenter: LaunchScreenPresenterProtocols?

    // MARK: - Spy Properties
    var animateLaunchScreenCalled = false

    func animateLaunchScreen() {
        animateLaunchScreenCalled = true
    }
}
