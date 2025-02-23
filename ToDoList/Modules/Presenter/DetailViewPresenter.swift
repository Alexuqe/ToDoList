

import Foundation

protocol DetailViewPresenterProtocol: AnyObject {

    var view: DetailViewControllerProtocol? { get set }
    var interactor: DetailViewInteractorProtocol? { get set }
    var router: DetailViewRouterProtocol? { get set }

    func viewDidLoad()
    func saveButtonTapped(title: String, details: String)
    func textFieldDidChange(title: String?, details: String?)
    func configure(with task: TasksList)
    func dismiss()
}

final class DetailViewPresenter: DetailViewPresenterProtocol {

    //MARK: Properties
    var view: DetailViewControllerProtocol?
    var interactor: DetailViewInteractorProtocol?
    var router: DetailViewRouterProtocol?

    //MARK: - Private Properties
    private let detailView = DetailViewController()
    private var isEditMode: Bool = false

    //MARK: - Lifecycle Methods
    func viewDidLoad() {
        if isEditMode {
        } else {
            view?.displayDate(date: "Сегодня")
        }
    }

    //MARK: - Configuration Methods
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

//MARK: - Extension DetailViewInteractorOutputProtocol
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
