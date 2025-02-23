

import CoreData

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)? { get set }

    func fetchTask()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
    func isCompleted(task: TasksList)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(tasks: [TasksList])
}

final class TaskListInteractor: TaskListInteractorProtocol {

    //MARK: - Properties
    var presenter: (TaskListInteractorOutputProtocol & TaskListPresenterProtocol)?
    var storageManager: StorageManagerProtocol = StorageManager.shared

    //MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private let userDefaultsKey = "ifFirstLaunch"

    //MARK: - Fetch Methods
    func fetchTask() {
        if !UserDefaults.standard.bool(forKey: userDefaultsKey) {
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
                    self.storageManager.fetchTasksOnAPI(tasks.todos) {
                        UserDefaults.standard.set(true, forKey: self.userDefaultsKey)
                        self.loadTaskFromCoreData()
                    }
                case .failure(let error):
                    print(error)
            }
        }
    }

    func loadTaskFromCoreData() {
        storageManager.fetchTasks { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let tasks):
                    presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    print(error)
            }
        }
    }

    //MARK: - Task Methods
    func addTask(title: String, details: String) {
        storageManager.create(title, with: details) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let tasks):
                    presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func updateTask(task: TasksList, title: String, details: String) {
        storageManager.updateTask(task: task, title: title, details: details) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let tasks):
                    presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func deleteTask(task: TasksList) {
        storageManager.delete(task) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let tasks):
                    presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func searchTask(title: String) {
        storageManager.searchTask(title: title) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let tasks):
                    presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    print(error)
            }
        }
    }

    func isCompleted(task: TasksList) {
        storageManager.isCompletedTask(task: task) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let task):
                    presenter?.didFetchTasks(tasks: task)
                case .failure(let error):
                    print(error)
            }
        }
    }


}
