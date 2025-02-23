import XCTest
@testable import ToDoList

class DetailViewRouterTests: XCTestCase {
    var sut: DetailViewRouter!
    var mockViewController: DetailViewController!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()
        sut = DetailViewRouter()
        mockViewController = DetailViewController()
        mockNavigationController = MockNavigationController(rootViewController: mockViewController)
        sut.viewController = mockViewController
    }

    override func tearDown() {
        sut = nil
        mockViewController = nil
        mockNavigationController = nil
        super.tearDown()
    }

    func testDismiss_CallsNavigationControllerPop() {
        // Act
        sut.dismiss()

        // Assert
        XCTAssertTrue(mockNavigationController.popViewControllerCalled, "Dismiss should call popViewController on navigationController")
    }

    func testCreateDetailModule_ReturnsViewController() {
        // Act
        let viewController = sut.createDetailModule { }

        // Assert
        XCTAssertTrue(viewController is DetailViewController, "createDetailModule should return DetailViewController")
    }
}

class MockNavigationController: UINavigationController {
    var popViewControllerCalled = false

    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return super.popViewController(animated: animated)
    }
}
