import Foundation
@testable import ToDoList

final class MockDetailViewController: DetailViewControllerProtocol {
    var presenter: DetailViewPresenterProtocol?

    // MARK: - Spy Properties
    var displayTaskTitleCalled = false
    var displayTaskDetailCalled = false
    var displayDateCalled = false
    var enableSaveButtonCalled = false

    // MARK: - Captured Parameters
    var capturedTitle: String?
    var capturedDetail: String?
    var capturedDate: String?
    var capturedEnabled: Bool?

    func displayTaskTitle(title: String) {
        displayTaskTitleCalled = true
        capturedTitle = title
    }

    func displayTaskDetail(detail: String) {
        displayTaskDetailCalled = true
        capturedDetail = detail
    }

    func displayDate(date: String) {
        displayDateCalled = true
        capturedDate = date
    }

    func enableSaveButton(_ enabled: Bool) {
        enableSaveButtonCalled = true
        capturedEnabled = enabled
    }
}
