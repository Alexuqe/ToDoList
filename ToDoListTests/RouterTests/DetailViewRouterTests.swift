//import XCTest
//import CoreData
//@testable import ToDoList
//import UIKit
//
//class DetailViewRouterTests: XCTestCase {
//    var sut: DetailViewRouter!
//
//    override func setUp() {
//        super.setUp()
//        sut = DetailViewRouter()
//    }
//
//    override func tearDown() {
//        sut = nil
//        super.tearDown()
//    }
//
//    func testCreateDetailModule_WithTask_ReturnsViewController() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        let expectation = self.expectation(description: "Completion called")
//
//        // Act
//        let viewController = sut.createDetailModule(with: task) {
//            expectation.fulfill()
//        }
//
//        // Assert
//        XCTAssertNotNil(viewController)
//        XCTAssertTrue(viewController is DetailViewController)
//
//        // Verify the VIPER connections
//        guard let detailVC = viewController as? DetailViewController else {
//            XCTFail("ViewController is not DetailViewController")
//            return
//        }
//
//        XCTAssertNotNil(detailVC.presenter)
//        XCTAssertNotNil(detailVC.presenter?.interactor)
//        XCTAssertNotNil(detailVC.presenter?.router)
//
//        // Verify the router's viewController property is set
//        XCTAssertEqual(sut.viewController, detailVC)
//    }
//
//    func testCreateDetailModule_WithoutTask_ReturnsViewController() {
//        // Arrange
//        let expectation = self.expectation(description: "Completion called")
//
//        // Act
//        let viewController = sut.createDetailModule {
//            expectation.fulfill()
//        }
//
//        // Assert
//        XCTAssertNotNil(viewController)
//        XCTAssertTrue(viewController is DetailViewController)
//
//        // Verify the VIPER connections
//        guard let detailVC = viewController as? DetailViewController else {
//            XCTFail("ViewController is not DetailViewController")
//            return
//        }
//
//        XCTAssertNotNil(detailVC.presenter)
//        XCTAssertNotNil(detailVC.presenter?.interactor)
//        XCTAssertNotNil(detailVC.presenter?.router)
//
//        // Verify the router's viewController property is set
//        XCTAssertEqual(sut.viewController, detailVC)
//    }
//
//    func testDismiss_CallsCompletionAndPopsViewController() {
//        // Arrange
//        let expectation = self.expectation(description: "Completion called")
//        let mockViewController = DetailViewController()
//        let navigationController = UINavigationController(rootViewController: UIViewController())
//        navigationController.pushViewController(mockViewController, animated: false)
//
//        sut.viewController = mockViewController
//        sut.createDetailModule {
//            expectation.fulfill()
//        }
//
//        // Act
//        sut.dismiss()
//
//        // Assert
//        waitForExpectations(timeout: 1.0)
//        XCTAssertEqual(navigationController.viewControllers.count, 1)
//    }
//}
