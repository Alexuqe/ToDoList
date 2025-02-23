    //
    //  DetailViewPresenter.swift
    //  ToDoList
    //
    //  Created by Sasha on 21.02.25.
    //

import Foundation

final class DetailViewPresenter: DetailViewPresenterProtocol {

    var view: DetailViewControllerProtocol?
    var interactor: DetailViewInteractorProtocol?
    var router: DetailViewRouterProtocol?

    private let detailView = DetailViewController()
    private var isEditMode: Bool = false


    func viewDidLoad() {
        if isEditMode {
        } else {
            view?.displayDate(date: "Сегодня")
        }
    }

    func configure(with task: TasksList) {
        isEditMode = true
        interactor?.fetchTasksDetails(task: task)
    }

    func saveButtonTapped(title: String, details: String) {
        if isEditMode {
            interactor?.saveUpdateTask(title: title, details: details)
        } else {
            interactor?.createNewTask(title: title, details: details)
        }
    }

    func textFieldDidChange(title: String?, details: String?) {
        let isValid = !(title?.isEmpty ?? true) && !(details?.isEmpty ?? true)
        view?.enableSaveButton(isValid)
    }

    func dismiss() {
        router?.dismiss()
    }

}

extension DetailViewPresenter: DetailViewInteractorOutputProtocol {
    func didFetchTaskDetails(task: TasksList) {
        view?.displayTaskTitle(title: task.title ?? "")
        view?.displayTaskDetail(detail: task.details ?? "")
        view?.displayDate(date: task.date?.formatted() ?? "")
    }
    
    func didSaveTaskDetails() {
        router?.dismiss()
    }
}
