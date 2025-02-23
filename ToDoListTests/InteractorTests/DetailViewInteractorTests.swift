//    //
//    //  DetailViewPresenterTests.swift
//    //  ToDoList
//    //
//    //  Created by Sasha on 23.02.25.
//    //
//
//    import XCTest
//    @testable import ToDoList
//
//    class DetailViewPresenterTests: XCTestCase {
//        var sut: DetailViewPresenter!
//        var mockView: MockDetailViewForPresenter!
//        var mockInteractor: MockDetailInteractorForPresenter!
//        var mockRouter: MockDetailRouterForPresenter!
//
//        override func setUp() {
//            super.setUp()
//            mockView = MockDetailViewForPresenter()
//            mockInteractor = MockDetailInteractorForPresenter()
//            mockRouter = MockDetailRouterForPresenter()
//            sut = DetailViewPresenter()
//            sut.view = mockView
//            sut.interactor = mockInteractor
//            sut.router = mockRouter
//        }
//
//        override func tearDown() {
//            sut = nil
//            mockView = nil
//            mockInteractor = nil
//            mockRouter = nil
//            super.tearDown()
//        }
//
//        func testConfigureWithTask_CallsInteractorFetchTaskDetails() {
//            // Arrange
//            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//            let task = TasksList(context: context)
//            task.title = "Test Task"
//            task.details = "Test Details"
//            task.date = Date()
//            task.isCompleted = false
//
//            // Act
//            sut.configure(with: task)
//
//            // Assert
//            XCTAssertTrue(mockInteractor.fetchTasksDetailsCalled, "configure should call interactor's fetchTasksDetails")
//        }
//
//        func testSaveButtonTapped_CallsInteractorSaveUpdateTask() {
//            // Arrange
//            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//            let task = TasksList(context: context)
//            task.title = "Test Task"
//            task.details = "Test Details"
//            task.date = Date()
//            task.isCompleted = false
//            sut.configure(with: task)
//
//            // Act
//            sut.saveButtonTapped(title: "Updated Title", details: "Updated Details")
//
//            // Assert
//            XCTAssertTrue(mockInteractor.saveUpdateTaskCalled, "saveButtonTapped should call interactor's saveUpdateTask")
//        }
//    }
//
//    class MockDetailViewForPresenter: DetailViewControllerProtocol {
//        var presenter: DetailViewPresenterProtocol?
//        var tasks: TasksList?
//
//        func displayTaskTitle(title: String) {}
//        func displayTaskDetail(detail: String) {}
//        func displayDate(date: String) {}
//        func enableSaveButton(_ enabled: Bool) {}
//    }
//
//    class MockDetailInteractorForPresenter: DetailViewInteractorProtocol {
//        var presenter: DetailViewInteractorOutputProtocol?
//        var fetchTasksDetailsCalled = false
//        var saveUpdateTaskCalled = false
//
//        func fetchTasksDetails(task: TasksList) {
//            fetchTasksDetailsCalled = true
//        }
//
//        func saveUpdateTask(title: String, details: String) {
//            saveUpdateTaskCalled = true
//        }
//
//        func createNewTask(title: String, details: String) {}
//    }
//
//    class MockDetailRouterForPresenter: DetailViewRouterProtocol {
//        var viewController: DetailViewController?
//        func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController {
//            return UIViewController()
//        }
//
//        func createDetailModule(completion: @escaping () -> Void) -> UIViewController {
//            return UIViewController()
//        }
//
//        func dismiss() {}
//    }
