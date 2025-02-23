    //
    //  DetailViewPresenterTests.swift
    //  ToDoList
    //
    //  Created by Sasha on 23.02.25.
    //

    import XCTest
    @testable import ToDoList
import CoreData

    class DetailViewPresenterTests: XCTestCase {
        var sut: DetailViewPresenter!
        var mockView: MockDetailViewController!
        var mockInteractor: MockDetailInteractor!
        var mockRouter: MockDetailRouter!

        override func setUp() {
            super.setUp()
            mockView = MockDetailViewController()
            mockInteractor = MockDetailInteractor()
            mockRouter = MockDetailRouter()
            sut = DetailViewPresenter()
            sut.view = mockView
            sut.interactor = mockInteractor
            sut.router = mockRouter
        }

        override func tearDown() {
            sut = nil
            mockView = nil
            mockInteractor = nil
            mockRouter = nil
            super.tearDown()
        }

        func testConfigureWithTask_CallsInteractorFetchTaskDetails() {
            // Arrange
            let context = createTestContext()
            let task = createTestTask(in: context)

            // Act
            sut.configure(with: task)

            // Assert
            XCTAssertTrue(mockInteractor.fetchTasksDetailsCalled, "configure should call interactor's fetchTasksDetails")
        }

        func testSaveButtonTapped_CallsInteractorSaveUpdateTask() {
            // Arrange
            let context = createTestContext()
            let task = createTestTask(in: context)
            sut.configure(with: task)

            // Act
            sut.saveButtonTapped(title: "Updated Title", details: "Updated Details")

            // Assert
            XCTAssertTrue(mockInteractor.saveUpdateTaskCalled, "saveButtonTapped should call interactor's saveUpdateTask")
        }

        // Helper method to create a test NSManagedObjectContext
        private func createTestContext() -> NSManagedObjectContext {
            let managedObjectModel = NSManagedObjectModel.mergedModel(from: [Bundle.main])!
            let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
            try! persistentStoreCoordinator.addPersistentStore(
                ofType: NSInMemoryStoreType,
                configurationName: nil,
                at: nil,
                options: nil
            )

            let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            context.persistentStoreCoordinator = persistentStoreCoordinator
            return context
        }

        // Helper method to create a test TasksList
        private func createTestTask(in context: NSManagedObjectContext) -> TasksList {
            let task = TasksList(context: context)
            task.title = "Test Task"
            task.details = "Test Details"
            task.date = Date()
            task.isCompleted = false
            return task
        }
    }

    class MockDetailViewController: DetailViewControllerProtocol {
        var presenter: DetailViewPresenterProtocol?
        var tasks: TasksList?

        func displayTaskTitle(title: String) {}
        func displayTaskDetail(detail: String) {}
        func displayDate(date: String) {}
        func enableSaveButton(_ enabled: Bool) {}
    }

    class MockDetailInteractor: DetailViewInteractorProtocol {
        var presenter: DetailViewInteractorOutputProtocol?
        var fetchTasksDetailsCalled = false
        var saveUpdateTaskCalled = false

        func fetchTasksDetails(task: TasksList) {
            fetchTasksDetailsCalled = true
        }

        func saveUpdateTask(title: String, details: String) {
            saveUpdateTaskCalled = true
        }

        func createNewTask(title: String, details: String) {}
    }

    class MockDetailRouter: DetailViewRouterProtocol {
        var viewController: DetailViewController?
        func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController {
            return UIViewController()
        }

        func createDetailModule(completion: @escaping () -> Void) -> UIViewController {
            return UIViewController()
        }

        func dismiss() {}
    }
