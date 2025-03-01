import Foundation
@testable import ToDoList

final class MockDetailViewPresenter: DetailViewPresenterProtocol & DetailViewInteractorOutputProtocol {
    var view: DetailViewControllerProtocol?
    var interactor: DetailViewInteractorProtocol?
    var router: DetailViewRouterProtocol?

    // MARK: - Spy Properties
    var saveButtonTappedCalled = false
    var textFieldDidChangeCalled = false
    var configureCalled = false
    var dismissCalled = false
    var didFetchTaskDetailsCalled = false
    var didSaveTaskDetailsCalled = false

    // MARK: - Captured Parameters
    var capturedTitle: String?
    var capturedDetails: String?
    var capturedTask: TasksList?

    // MARK: - DetailViewPresenterProtocol
    func saveButtonTapped(title: String, details: String) {
        saveButtonTappedCalled = true
        capturedTitle = title
        capturedDetails = details
    }

    func textFieldDidChange(title: String?, details: String?) {
        textFieldDidChangeCalled = true
        capturedTitle = title
        capturedDetails = details
    }

    func configure(with task: TasksList) {
        configureCalled = true
        capturedTask = task
    }

    func dismiss() {
        dismissCalled = true
    }

    // MARK: - DetailViewInteractorOutputProtocol
    func didFetchTaskDetails(task: TasksList) {
        didFetchTaskDetailsCalled = true
        capturedTask = task
    }

    func didSaveTaskDetails() {
        didSaveTaskDetailsCalled = true
    }
}
