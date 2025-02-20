    //
    //  TaskListInteractor.swift
    //  ToDoList
    //
    //  Created by Sasha on 20.02.25.
    //

import CoreData


protocol TaskListInteractorProtocol: AnyObject {
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)? { get set }

    func fetchTask()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(tasks: [TasksList])
}


final class TaskListInteractor: TaskListInteractorProtocol {

    var presenter: (TaskListInteractorOutputProtocol & TaskListPresenterProtocol)?

    private let networkManager = NetworkManager.shared
    private let storageManager = StorageManager.shared

    func fetchTask() {
        if !UserDefaults.standard.bool(forKey: "ifFirstLaunch") {
            loadTaskFromAPI()
        } else {
            loadTaskFromCoreData()
        }
    }

    func loadTaskFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else { return }

        networkManager.fetch(APITasks.self, url: url) { [weak self] result in
            guard let self else { return }
            switch result {
                case .success(let tasks):
                    storageManager.fetchTasksOnAPI(tasks.todos)
                    UserDefaults.standard.set(true, forKey: "ifFirstLaunch")
                    loadTaskFromCoreData()
                case .failure(let error):
                    print(error)
            }
        }
    }

    func loadTaskFromCoreData() {
        storageManager.fetchTasks { tasks in
            switch tasks {
                case .success(let task):
                    presenter?.didFetchTasks(tasks: task)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func addTask(title: String, details: String) {
        storageManager.create(title, with: details) { [weak self] tasks in
            guard let self else { return }
            presenter?.didFetchTasks(tasks: [tasks])
        }
    }

    func updateTask(task: TasksList, title: String, details: String) {
        storageManager.updateTask(task: task, title: title, details: details) { [weak self] tasks in
            guard let self else { return }
            presenter?.didFetchTasks(tasks: [tasks])
        }
    }

    func deleteTask(task: TasksList) {
        storageManager.delete(task)
    }

    func searchTask(title: String) {
        storageManager.searchTask(title: title) { [weak self] tasks in
            guard let self else { return }
            presenter?.didFetchTasks(tasks: tasks)
        }
    }


}
