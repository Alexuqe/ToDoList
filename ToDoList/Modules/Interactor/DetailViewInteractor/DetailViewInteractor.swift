    //
    //  DetailViewInteractor.swift
    //  ToDoList
    //
    //  Created by Sasha on 21.02.25.
    //
import Foundation

final class DetailViewInteractor: DetailViewInteractorProtocol {
    
    var presenter: DetailViewInteractorOutputProtocol?
    private let storageManager = StorageManager.shared
    private var currentTask: TasksList?
    
    func fetchTasksDetails(task: TasksList) {
        currentTask = task
        presenter?.didFetchTaskDetails(task: task)
    }
    
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
