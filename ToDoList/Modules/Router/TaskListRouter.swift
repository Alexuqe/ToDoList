

import UIKit
import UIKit

protocol TaskListRouterProtocol: AnyObject {
    var viewController: UITableViewController? { get set }

    static func createdModule() -> UITableViewController
    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void)
    func navigateToAddTask(completion: @escaping () -> Void)
    func showDetailPreview(with task: TasksList) -> UIViewController?
}

final class TaskListRouter: TaskListRouterProtocol {

    //MARK: Properties
    var viewController: UITableViewController?

    //MARK: - Static Methods
    static func createdModule() -> UITableViewController {
        let view = TaskListViewController()
        let presenter: TaskListPresenterProtocol & TaskListInteractorOutputProtocol = TaskListPresenter()
        let interactor: TaskListInteractorProtocol = TaskListInteractor()
        let router: TaskListRouterProtocol = TaskListRouter()

        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        interactor.presenter = presenter

        router.viewController = view

        return view
    }

    //MARK: - Navigation Methods
    func navigateToTaskDetail(with task: TasksList, completion: @escaping () -> Void) {
        let detailViewRouter = DetailViewRouter()
        let detailViewController = detailViewRouter.createDetailModule(with: task, completion: completion)

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func navigateToAddTask(completion: @escaping () -> Void) {
        let detailViewRouter = DetailViewRouter()
        let detailViewController = detailViewRouter.createDetailModule(
            completion: completion)

        viewController?.navigationController?.pushViewController(detailViewController, animated: true)
    }

    func showDetailPreview(with task: TasksList) -> UIViewController? {
        let detailView = TaskContextPreview()
        detailView.configure(with: task)
        return detailView
    }
}
