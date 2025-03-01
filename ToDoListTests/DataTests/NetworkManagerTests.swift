import XCTest
@testable import ToDoList

class NetworkManagerTests: XCTestCase {
    var sut: NetworkManager!

    override func setUp() {
        super.setUp()
        sut = NetworkManager.shared
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testFetch_Success() {
        // Arrange
        let expectation = self.expectation(description: "Fetch success")
        let url = URL(string: "https://dummyjson.com/todos")!

        // Act
        sut.fetch(APITasks.self, url: url) { result in
            switch result {
            case .success(let tasks):
                XCTAssertNotNil(tasks)
                expectation.fulfill()
            case .failure(let error):
                XCTFail("Fetch failed with error: \(error)")
            }
        }

        // Assert
        waitForExpectations(timeout: 5.0)
    }
}
