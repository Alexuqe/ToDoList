import XCTest
@testable import ToDoList

final class LaunchScreenRouterTests: XCTestCase {
    var sut: LaunchScreenRouter!
    var mockViewController: UIViewController!

    override func setUp() {
        super.setUp()
        sut = LaunchScreenRouter()
        mockViewController = UIViewController()
        sut.viewController = mockViewController
    }

    override func tearDown() {
        sut = nil
        mockViewController = nil
        super.tearDown()
    }

    func testCreateModule() {
        // When
        let viewController = LaunchScreenRouter.createModule()

        // Then
        XCTAssertNotNil(viewController)
        XCTAssertTrue(viewController is LaunchScreenViewController)

        let launchScreen = viewController as? LaunchScreenViewController
        XCTAssertNotNil(launchScreen?.presenter)
        XCTAssertNotNil((launchScreen?.presenter as? LaunchScreenPresenter)?.view)
        XCTAssertNotNil((launchScreen?.presenter as? LaunchScreenPresenter)?.router)
    }

    func testNavigateToTaskListView() {
        // Given
        let window = UIWindow()
        window.rootViewController = mockViewController
        window.makeKeyAndVisible()

        // When
        sut.navigateToTaskListView()

        // Then
        let expectation = XCTestExpectation(description: "Navigation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            XCTAssertTrue(window.rootViewController is UINavigationController)
            let navController = window.rootViewController as? UINavigationController
            XCTAssertTrue(navController?.viewControllers.first is TaskListViewController)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
}
