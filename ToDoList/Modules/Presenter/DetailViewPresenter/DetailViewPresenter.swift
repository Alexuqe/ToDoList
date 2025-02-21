//
//  DetailViewPresenter.swift
//  ToDoList
//
//  Created by Sasha on 21.02.25.
//

final class DetailViewPresenter: DetailViewPresenterProtocol {

    var view: DetailViewControllerProtocol?
    var interactor: DetailViewInteractorProtocol?
    var router: DetailViewRouterProtocol?
    
    func loadTaskDetails(_ task: TasksList) {
        interactor?.fetchTaskDetails(task: task)
    }
    
    func updateTask(task: TasksList, title: String, details: String) {
        interactor?.saveUpdateTask(task: task, title: title, details: details)
    }
}


extension DetailViewPresenter: DetailViewInteractorOutputProtocol {

    func didFetchTaskDetail(task: TasksList) {
        view?.showTaskDetail(task: task)
    }
    
    func didSaveTaskDetail() {
        view?.updateTask()
    }
    

}
