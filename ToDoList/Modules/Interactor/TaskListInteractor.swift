

import CoreData

protocol TaskListInteractorProtocol: AnyObject {
    var presenter: (TaskListPresenterProtocol & TaskListInteractorOutputProtocol)? { get set }

    func fetchTask()
    func fetchTaskForCurrentSegment()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
    func isCompleted(task: TasksList)
    func segmentChanged(to index: Int)
}

protocol TaskListInteractorOutputProtocol: AnyObject {
    func didFetchTasks(tasks: [TasksList])
    func didReceiveError(_ error: Error)
    func taskCreated(_ task: TasksList)
    func taskDeleted()
    func taskUpdated()
}

final class TaskListInteractor: TaskListInteractorProtocol {

        //MARK: - Properties
    var presenter: (TaskListInteractorOutputProtocol & TaskListPresenterProtocol)?
    var storageManager: StorageManagerProtocol = StorageManager.shared
    private var currentIndex = 0

        //MARK: - Private Properties
    private let networkManager = NetworkManager.shared
    private let savedNames = APINameTaskStorage.shared
    private let userDefaultsKey = "ifFirstLaunch"

        //MARK: - Fetch Methods
    func fetchTask() {
        if !UserDefaults.standard.bool(forKey: userDefaultsKey) {
            print("Loading from API")
            loadTaskFromAPI()
        } else {
            print("Loading from CoreData")
            loadTaskFromCoreData()
        }
    }

    func loadTaskFromAPI() {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            presenter?.didReceiveError(NetworkError.invalidUrl)
            return
        }
        networkManager.fetch(APITasks.self, url: url) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let tasks):
                    print("API Success: \(tasks.todos.count) tasks received")
                    self.storageManager.fetchTasksOnAPI(tasks.todos, savedNames.taskTitles) {
                        print("Tasks saved to CoreData")
                        UserDefaults.standard.set(true, forKey: self.userDefaultsKey)
                        self.loadTaskFromCoreData()
                    }
                case .failure(let error):
                    self.presenter?.didReceiveError(error)
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
                    presenter?.didReceiveError(error)
            }
        }
    }

    func fetchTaskForCurrentSegment() {
        storageManager.segmentedTask(index: currentIndex) { [weak self] result in
            switch result {
                case .success(let tasks):
                    self?.presenter?.didFetchTasks(tasks: tasks)
                case .failure(let error):
                    self?.presenter?.didReceiveError(error)
            }
        }
    }

        //MARK: - Task Methods
    func addTask(title: String, details: String) {
        storageManager.create(title, with: details) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success(let task):
                    presenter?.taskCreated(task)
                    fetchTaskForCurrentSegment()
                case .failure(let error):
                    presenter?.didReceiveError(error)
            }
        }
    }

    func updateTask(task: TasksList, title: String, details: String) {
        storageManager.updateTask(task: task, title: title, details: details) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success():
                    presenter?.taskUpdated()
                    fetchTaskForCurrentSegment()
                case .failure(let error):
                    print(error)
            }
        }
    }

    func deleteTask(task: TasksList) {
        storageManager.delete(task) { [weak self] result in
            guard let self else { return }

            switch result {
                case .success():
                    presenter?.taskDeleted()
                    fetchTaskForCurrentSegment()
                case .failure(let error):
                    presenter?.didReceiveError(error)
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
                case .success():
                    fetchTaskForCurrentSegment()
                case .failure(let error):
                    presenter?.didReceiveError(error)
            }
        }
    }

    func segmentChanged(to index: Int) {
        currentIndex = index
        fetchTaskForCurrentSegment()
    }




}
