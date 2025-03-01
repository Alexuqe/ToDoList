//import XCTest
//@testable import ToDoList
//import CoreData
//
//class DetailViewPresenterTests: XCTestCase {
//    var sut: DetailViewPresenter!
//    var mockView: MockDetailViewController!
//    var mockInteractor: MockDetailViewInteractor!
//    var mockRouter: MockDetailViewRouter!
//
//    override func setUp() {
//        super.setUp()
//        mockView = MockDetailViewController()
//        mockInteractor = MockDetailViewInteractor()
//        mockRouter = MockDetailViewRouter()
//
//        sut = DetailViewPresenter()
//        sut.view = mockView
//        sut.interactor = mockInteractor
//        sut.router = mockRouter
//    }
//
//    override func tearDown() {
//        sut = nil
//        mockView = nil
//        mockInteractor = nil
//        mockRouter = nil
//        super.tearDown()
//    }
//
//    func testConfigure_SetsEditModeAndFetchesTask() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//
//        // Act
//        sut.configure(with: task)
//
//        // Assert
//        XCTAssertTrue(mockInteractor.fetchTasksDetailsCalled)
//    }
//
//    func testSaveButtonTapped_InEditMode_CallsUpdateTask() {
//        // Arrange
//        let task = TasksList(context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType))
//        sut.configure(with: task) // Sets edit mode to true
//
//        // Act
//        sut.saveButtonTapped(title: "Updated Title", details: "Updated Details")
//
//        // Assert
//        XCTAssertTrue(mockInteractor.saveUpdateTaskCalled)
//        XCTAssertEqual(mockInteractor.lastUpdatedTitle, "Updated Title")
//        XCTAssertEqual(mockInteractor.lastUpdatedDetails, "Updated Details")
//    }
//
//    func testSaveButtonTapped_InCreateMode_CallsCreateTask() {
//        // Arrange - not calling configure, so isEditMode remains false
//
//        // Act
//        sut.saveButtonTapped(title: "New Title", details: "New Details")
//
//        // Assert
//        XCTAssertTrue(mockInteractor.createNewTaskCalled)
//        XCTAssertEqual(mockInteractor.lastCreatedTitle, "New Title")
//        XCTAssertEqual(mockInteractor.lastCreatedDetails, "New Details")
//    }
//
//    func testTextFieldDidChange_WithValidInput_EnablesSaveButton() {
//        // Act
//        sut.textFieldDidChange(title: "Valid Title", details: "Valid Details")
//
//        // Assert
//        XCTAssertTrue(mockView.enableSaveButtonCalled)
//        XCTAssertTrue(mockView.lastEnableSaveButtonValue)
//    }
//
//    func testTextFieldDidChange_WithEmptyTitle_DisablesSaveButton() {
//        // Act
//        sut.textFieldDidChange(title: "", details: "Valid Details")
//
//        // Assert
//        XCTAssertTrue(mockView.enableSaveButtonCalled)
//        XCTAssertFalse(mockView.lastEnableSaveButtonValue)
//    }
//
//    func testTextFieldDidChange_WithEmptyDetails_DisablesSaveButton() {
//        // Act
//        sut.textFieldDidChange(title: "Valid Title", details: "")
//
//        // Assert
//        XCTAssertTrue(mockView.enableSaveButtonCalled)
//        XCTAssertFalse(mockView.lastEnableSaveButtonValue)
//    }
//
//    func testDismiss_CallsRouterDismiss() {
//        // Act
//        sut.dismiss()
//
//        // Assert
//        XCTAssertTrue(mockRouter.dismissCalled)
//    }
//
//    func testDidFetchTaskDetails_UpdatesView() {
//        // Arrange
//        let context = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
//        let task = TasksList(context: context)
//        task.title = "Test Title"
//        task.details = "Test Details"
//        task.date = Date()
//
//        // Act
//        sut.didFetchTaskDetails(task: task)
//
//        // Assert
//        XCTAssertTrue(mockView.displayTaskTitleCalled)
//        XCTAssertTrue(mockView.displayTaskDetailCalled)
//        XCTAssertTrue(mockView.displayDateCalled)
//    }
//
//    func testDidSaveTaskDetails_CallsRouterDismiss() {
//        // Act
//        sut.didSaveTaskDetails()
//
//        // Assert
//        XCTAssertTrue(mockRouter.dismissCalled)
//    }
//}
//
//// MARK: - Mock Classes
//
//class MockDetailViewController: DetailViewControllerProtocol {
//    var presenter: DetailViewPresenterProtocol?
//
//    var displayTaskTitleCalled = false
//    var displayTaskDetailCalled = false
//    var displayDateCalled = false
//    var enableSaveButtonCalled = false
//
//    var lastDisplayedTitle: String?
//    var lastDisplayedDetail: String?
//    var lastDisplayedDate: String?
//    var lastEnableSaveButtonValue: Bool = false
//
//    func displayTaskTitle(title: String) {
//        displayTaskTitleCalled = true
//        lastDisplayedTitle = title
//    }
//
//    func displayTaskDetail(detail: String) {
//        displayTaskDetailCalled = true
//        lastDisplayedDetail = detail
//    }
//
//    func displayDate(date: String) {
//        displayDateCalled = true
//        lastDisplayedDate = date
//    }
//
//    func enableSaveButton(_ enabled: Bool) {
//        enableSaveButtonCalled = true
//        lastEnableSaveButtonValue = enabled
//    }
//}
//
//class MockDetailViewInteractor: DetailViewInteractorProtocol {
//    var presenter: DetailViewInteractorOutputProtocol?
//
//    var fetchTasksDetailsCalled = false
//    var saveUpdateTaskCalled = false
//    var createNewTaskCalled = false
//
//    var lastFetchedTask: TasksList?
//    var lastUpdatedTitle: String?
//    var lastUpdatedDetails: String?
//    var lastCreatedTitle: String?
//    var lastCreatedDetails: String?
//
//    func fetchTasksDetails(task: TasksList) {
//        fetchTasksDetailsCalled = true
//        lastFetchedTask = task
//    }
//
//    func saveUpdateTask(title: String, details: String) {
//        saveUpdateTaskCalled = true
//        lastUpdatedTitle = title
//        lastUpdatedDetails = details
//    }
//
//    func createNewTask(title: String, details: String) {
//        createNewTaskCalled = true
//        lastCreatedTitle = title
//        lastCreatedDetails = details
//    }
//}
//
//class MockDetailViewRouter: DetailViewRouterProtocol {
//    var viewController: DetailViewController?
//
//    var dismissCalled = false
//
//    func createDetailModule(with task: TasksList, completion: @escaping () -> Void) -> UIViewController {
//        return UIViewController()
//    }
//
//    func createDetailModule(completion: @escaping () -> Void) -> UIViewController {
//        return UIViewController()
//    }
//
//    func dismiss() {
//        dismissCalled = true
//    }
//}
