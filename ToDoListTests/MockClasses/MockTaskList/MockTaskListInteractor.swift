import Foundation
@testable import ToDoList

final class MockTaskListInteractor: TaskListInteractorProtocol {


        // MARK: - Required Protocol Property
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)?

        // MARK: - Spy Properties
    var fetchTaskCalled = false
    var addTaskCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var searchTaskCalled = false
    var isCompletedCalled = false
    var segmentChangedCalled = false

        // MARK: - Captured Parameters
    var capturedTitle: String?
    var capturedDetails: String?
    var capturedTask: TasksList?
    var capturedSegmentIndex: Int?

        // MARK: - Protocol Implementation
    func fetchTask() {
        fetchTaskCalled = true
    }

    func fetchTaskForCurrentSegment() {
        fetchTaskCalled = true
    }

    func addTask(title: String, details: String) {
        addTaskCalled = true
        capturedTitle = title
        capturedDetails = details
    }

    func updateTask(task: TasksList, title: String, details: String) {
        updateTaskCalled = true
        capturedTask = task
        capturedTitle = title
    }

    func deleteTask(task: ToDoList.TasksList) {
        capturedTask = task
    }
    func searchTask(title: String) {}
    func isCompleted(task: ToDoList.TasksList) {
        capturedTask = task
    }
    func segmentChanged(to index: Int) {
        capturedSegmentIndex = index
    }
}
