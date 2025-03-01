import XCTest
@testable import ToDoList

final class LaunchScreenViewControllerTests: XCTestCase {
    var sut: LaunchScreenViewController!
    var mockPresenter: MockLaunchScreenPresenter!

    override func setUp() {
        super.setUp()
        sut = LaunchScreenViewController()
        mockPresenter = MockLaunchScreenPresenter()
        sut.presenter = mockPresenter
    }

    override func tearDown() {
        sut = nil
        mockPresenter = nil
        super.tearDown()
    }

    func testViewDidLoad() {
        // When
        sut.viewDidLoad()

        // Then
        XCTAssertNotNil(sut.view.subviews.first)
    }

    func testAnimateLaunchScreen() {
        // When
        sut.animateLaunchScreen()

        // Then
        let expectation = XCTestExpectation(description: "Animation completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 4.0)
    }
}
