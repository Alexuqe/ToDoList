




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
    }
    
    func searchTask(title: String) {
        interactor?.searchTask(title: title)
    }

    func isCompleted(task: TasksList) {
        interactor?.isCompleted(task: task)
    }

    func showTasksDetail(for task: TasksList) {
        router?.navigateToTaskDetail(with: task)
    }

    func showAddTaskScreen() {
        router?.navigateToAddTask()
    }

}

extension TaskListPresenter: TaskListInteractorOutputProtocol {
    func didFetchTasks(tasks: [TasksList]) {
        view?.showTasks(tasks: tasks)
    }
}
