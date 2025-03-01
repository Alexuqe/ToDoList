import XCTest
@testable import ToDoList

final class LaunchScreenPresenterTests: XCTestCase {
    var sut: LaunchScreenPresenter!
    var mockView: MockLaunchScreenViewController!
    var mockRouter: MockLaunchScreenRouter!

    override func setUp() {
        super.setUp()
        mockView = MockLaunchScreenViewController()
        mockRouter = MockLaunchScreenRouter()

        sut = LaunchScreenPresenter()
        sut.view = mockView
        sut.router = mockRouter
    }

    override func tearDown() {
        sut = nil
        mockView = nil
        mockRouter = nil
        super.tearDown()
    }

    func testStartAnimating() {
        // When
        sut.startAnimating()

        // Then
        XCTAssertTrue(mockView.animateLaunchScreenCalled)
    }

    func testShowTaskListView() {
        // When
        sut.showTaskListView()

        // Then
        XCTAssertTrue(mockRouter.navigateToTaskListViewCalled)
    }
}
