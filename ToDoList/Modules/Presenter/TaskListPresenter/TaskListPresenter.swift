




import Foundation


final class TaskListPresenter: TaskListPresenterProtocol {

    var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    
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

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(tasks: [TasksList]) {
        view?.showTasks(tasks: tasks)
    }
}
