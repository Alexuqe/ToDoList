

import Foundation
import UIKit

protocol TaskListPresenterProtocol: AnyObject {
    var view: TaskListViewProtocol? { get set }
    var interactor: TaskListInteractorProtocol? { get set }
    var router: TaskListRouterProtocol? { get set }
    var tasks: [TasksList] { get set }

    func viewDidLoad()

    func addTask(title: String, details: String)
    func updateTask(task: TasksList, title: String, details: String)
    func deleteTask(task: TasksList)
    func searchTask(title: String)
    func isCompleted(task: TasksList)
    func didSelectSegment(at index: Int)

    func showTasksDetail(for task: TasksList)
    func showDetailPreview(with task: TasksList, completion: (UIViewController?) -> Void)
    func showAddTaskScreen()
}



final class TaskListPresenter: TaskListPresenterProtocol {

    //MARK: Properties
    weak var view: TaskListViewProtocol?
    var interactor: TaskListInteractorProtocol?
    var router: TaskListRouterProtocol?
    var tasks: [TasksList] = []

    init(view: TaskListViewProtocol, interactor: TaskListInteractorProtocol, router: TaskListRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }

    //MARK: - Task Methods
    func viewDidLoad() {
        interactor?.fetchTaskForCurrentSegment()
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

    func didSelectSegment(at index: Int) {
        interactor?.segmentChanged(to: index)
    }

    //MARK: - Show Methods
    func showTasksDetail(for task: TasksList) {
        router?.navigateToTaskDetail(with: task) { [weak self] in
            self?.viewDidLoad()
        }
    }

    func showDetailPreview(with task: TasksList, completion: (UIViewController?) -> Void) {
       let perview =  router?.showDetailPreview(with: task)
        completion(perview)
    }

    func showAddTaskScreen() {
        router?.navigateToAddTask { [weak self] in
            self?.viewDidLoad()
        }
    }


}

//MARK: - TaskListInteractorOutputProtocol
extension TaskListPresenter: TaskListInteractorOutputProtocol {

    func didFetchTasks(tasks: [TasksList]) {
        self.tasks = tasks
        view?.showTasks(tasks: tasks)
    }

    func didReceiveError(_ error: any Error) {
        view?.showError(error.localizedDescription)
    }
    
    func taskCreated(_ task: TasksList) {
        view?.showSuccess()
    }
    
    func taskDeleted() {
        view?.showSuccess()
    }
    
    func taskUpdated() {
        view?.showSuccess()
    }

}
