//
//  DetailViewInteractor.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//


final class DetailViewInteractor: DetailViewInteractorProtocol {

    var presenter: DetailViewInteractorOutputProtocol?
    
    private let storageManager = StorageManager.shared

    func fetchTaskDetails(task: TasksList) {
        presenter?.didFetchTaskDetail(task: task)
    }
    
    func saveUpdateTask(task: TasksList, title: String, details: String) {
        task.title = title
        task.details = details
        storageManager.saveContext()
        presenter?.didSaveTaskDetail()
    }
}
