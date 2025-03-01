//import XCTest
//import CoreData
//@testable import ToDoList
//import UIKit
//
//class TaskListRouterTests: XCTestCase {
//    var sut: TaskListRouter!
//    var mockViewController: UITableViewController!
//
//    override func setUp() {
//        super.setUp()
//        sut = TaskListRouter()
//        mockViewController = UITableViewController()
//        sut.viewController = mockViewController
//    }
//
//    override func tearDown() {
//        sut = nil
//        mockViewController = nil
//        super.tearDown()
//    }
//
//    func testCreatedModule_ReturnsViewController() {
//        // Act
//        let viewController = TaskListRouter.createdModule()
//
//        // Assert
//        XCTAssertNotNil(viewController)
//        XCTAssertTrue(viewController is UITableViewController)
//
//        // Verify the VIPER connections
//        guard let taskListVC = viewController as? TaskListViewController else {
//            XCTFail("ViewController is not TaskListViewController")
//            return
//        }
//
//        XCTAssertNotNil(taskListVC.presenter)
//        XCTAssertNotNil(taskListVC.presenter?.interactor)
//        XCTAssertNotNil(taskListVC.presenter?.router)
//    }
//
//    func testNavigateToTaskDetail() {
//        // Arrange
//        let navigationController = UINavigationController(rootViewController: mockViewController)
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        let expectation = self.expectation(description: "Navigation completion called")
//
//        // Act
//        sut.navigateToTaskDetail(with: task) {
//            expectation.fulfill()
//        }
//
//        // Assert
//        waitForExpectations(timeout: 1.0)
//        XCTAssertEqual(navigationController.viewControllers.count, 2)
//        XCTAssertTrue(navigationController.viewControllers[1] is DetailViewController)
//    }
//
//    func testNavigateToAddTask() {
//        // Arrange
//        let navigationController = UINavigationController(rootViewController: mockViewController)
//        let expectation = self.expectation(description: "Navigation completion called")
//
//        // Act
//        sut.navigateToAddTask {
//            expectation.fulfill()
//        }
//
//        // Assert
//        waitForExpectations(timeout: 1.0)
//        XCTAssertEqual(navigationController.viewControllers.count, 2)
//        XCTAssertTrue(navigationController.viewControllers[1] is DetailViewController)
//    }
//
//    func testShowDetailPreview() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        task.title = "Test Task"
//        task.details = "Test Details"
//
//        // Act
//        let previewController = sut.showDetailPreview(with: task)
//
//        // Assert
//        XCTAssertNotNil(previewController)
//        XCTAssertTrue(previewController is TaskContextPreview)
//    }
//}
