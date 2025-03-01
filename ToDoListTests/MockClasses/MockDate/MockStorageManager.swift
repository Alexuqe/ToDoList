import Foundation
import CoreData
@testable import ToDoList

final class MockStorageManager: StorageManagerProtocol {
    // MARK: - Spy Properties
    var fetchTasksOnAPICalled = false
    var fetchTasksCalled = false
    var createTaskCalled = false
    var updateTaskCalled = false
    var deleteTaskCalled = false
    var searchTaskCalled = false
    var isCompletedTaskCalled = false
    var segmentedTaskCalled = false

    // MARK: - Mock Results
    var fetchTasksResult: Result<[TasksList], Error> = .success([])
    var createTaskResult: Result<TasksList, Error> = .success(TasksList())
    var updateTaskResult: Result<Void, Error> = .success(())
    var deleteTaskResult: Result<Void, Error> = .success(())
    var searchTaskResult: Result<[TasksList], Error> = .success([])
    var isCompletedTaskResult: Result<Void, Error> = .success(())
    var segmentedTaskResult: Result<[TasksList], Error> = .success([])

    // MARK: - Protocol Implementation
    func fetchTasksOnAPI(_ apiTasks: [APITask], _ savedNameTask: [String], completion: @escaping () -> Void) {
        fetchTasksOnAPICalled = true
        completion()
    }

    func fetchTasks(completion: @escaping (Result<[TasksList], Error>) -> Void) {
        fetchTasksCalled = true
        completion(fetchTasksResult)
    }

    func create(_ title: String, with details: String, completion: @escaping (Result<TasksList, Error>) -> Void) {
        createTaskCalled = true
        completion(createTaskResult)
    }

    func updateTask(task: TasksList, title: String, details: String, completion: @escaping (Result<Void, Error>) -> Void) {
        updateTaskCalled = true
        completion(updateTaskResult)
    }

    func delete(_ task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
        deleteTaskCalled = true
        completion(deleteTaskResult)
    }

    func searchTask(title: String, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        searchTaskCalled = true
        completion(searchTaskResult)
    }

    func isCompletedTask(task: TasksList, completion: @escaping (Result<Void, Error>) -> Void) {
        isCompletedTaskCalled = true
        completion(isCompletedTaskResult)
    }

    func segmentedTask(index: Int, completion: @escaping (Result<[TasksList], Error>) -> Void) {
        segmentedTaskCalled = true
        completion(segmentedTaskResult)
    }
}
