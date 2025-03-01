import XCTest
@testable import ToDoList

final class DetailViewRouterTests: XCTestCase {
    var sut: DetailViewRouter!

    override func setUp() {
        super.setUp()
        sut = DetailViewRouter()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testCreateDetailModuleWithTask() {
        // Given
        let task = TasksList()
        var completionCalled = false

        // When
        let viewController = sut.createDetailModule(with: task) {
            completionCalled = true
        }

        // Then
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(sut.viewController)

        // Test completion
        sut.dismiss()
        XCTAssertTrue(completionCalled)
    }

    func testCreateDetailModule() {
        // Given
        var completionCalled = false

        // When
        let viewController = sut.createDetailModule {
            completionCalled = true
        }

        // Then
        XCTAssertNotNil(viewController)
        XCTAssertNotNil(sut.viewController)

        // Test completion
        sut.dismiss()
        XCTAssertTrue(completionCalled)
    }
}
