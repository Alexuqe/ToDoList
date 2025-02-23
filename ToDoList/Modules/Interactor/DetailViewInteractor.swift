    //
    //  DetailViewInteractor.swift


import Foundation

protocol DetailViewInteractorProtocol: AnyObject {

    var presenter: DetailViewInteractorOutputProtocol? { get set }

    func fetchTasksDetails(task: TasksList)
    func saveUpdateTask(title: String, details: String)
    func createNewTask(title: String, details: String)

}

protocol DetailViewInteractorOutputProtocol: AnyObject {
    func didFetchTaskDetails(task: TasksList)
    func didSaveTaskDetails()
}

final class DetailViewInteractor: DetailViewInteractorProtocol {

        //MARK: - Properties
    var presenter: DetailViewInteractorOutputProtocol?

        //MARK: - Private Properties
    private let storageManager = StorageManager.shared
    private var currentTask: TasksList?

        //MARK: - Fetch Methods
    func fetchTasksDetails(task: TasksList) {
        currentTask = task
        presenter?.didFetchTaskDetails(task: task)
    }

        //MARK: - Task Methods
    func createNewTask(title: String, details: String) {
        storageManager.create(title, with: details) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(_):
                        self?.presenter?.didSaveTaskDetails()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }

    func saveUpdateTask(title: String, details: String) {
        guard let task = currentTask else { return }
        storageManager.updateTask(task: task, title: title, details: details) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success( _):
                        self?.presenter?.didSaveTaskDetails()
                    case .failure(let error):
                        print(error)
                }
            }
        }
    }


}
