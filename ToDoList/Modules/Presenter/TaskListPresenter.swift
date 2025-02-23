

import Foundation

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }

    func viewDidLoad()
    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
    func isCompleted(task: TasksList)
    func showTasksDetail(for task: TasksList)
    func showDetailPreview(task: TasksList)
    func showAddTaskScreen()
}

final class TaskListPresenter: TaskListPresenterProtocol {

    //MARK: Properties
    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?

    //MARK: - Task Methods
    func viewDidLoad() {
        interactor?.fetchTask()
    }
    
    func addTask(title: String, details: String) {
        interactor?.addTask(title: title, details: details)
    }
    
    func updateTask(task: TasksList, title: String, details: String) {
        interactor?.updateTask(task: task, title: title, details: details)
    }
    
    func deleteTask(task: TasksList) {
        interactor?.deleteTask(task: task)
        interactor?.fetchTask()
    }
    
    func searchTask(title: String) {
        interactor?.searchTask(title: title)
    }

    func isCompleted(task: TasksList) {
        interactor?.isCompleted(task: task)
    }

    //MARK: - Show Methods
    func showTasksDetail(for task: TasksList) {
        router?.navigateToTaskDetail(with: task) { [weak self] in
            self?.viewDidLoad()
        }
    }

    func showDetailPreview(task: TasksList) {
        router?.showDetailPreview(with: task)
    }

    func showAddTaskScreen() {
        router?.navigateToAddTask { [weak self] in
            self?.viewDidLoad()
        }
    }

}

//MARK: - Extension TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(tasks: [TasksList]) {
        view?.showTasks(tasks: tasks)
    }
}
