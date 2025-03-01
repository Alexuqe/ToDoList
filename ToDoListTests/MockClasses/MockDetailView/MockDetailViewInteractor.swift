import Foundation
@testable import ToDoList

final class MockDetailViewInteractor: DetailViewInteractorProtocol {
    var presenter: DetailViewInteractorOutputProtocol?

    // MARK: - Spy Properties
    var fetchTasksDetailsCalled = false
    var saveUpdateTaskCalled = false
    var createNewTaskCalled = false

    // MARK: - Captured Parameters
    var capturedTask: TasksList?
    var capturedTitle: String?
    var capturedDetails: String?

    func fetchTasksDetails(task: TasksList) {
        fetchTasksDetailsCalled = true
        capturedTask = task
    }

    func saveUpdateTask(title: String, details: String) {
        saveUpdateTaskCalled = true
        capturedTitle = title
        capturedDetails = details
    }

    func createNewTask(title: String, details: String) {
        createNewTaskCalled = true
        capturedTitle = title
        capturedDetails = details
    }
}
